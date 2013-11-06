Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3KFPBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:01:44 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:62702 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab3KFPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:01:42 -0500
MIME-Version: 1.0
In-Reply-To: <CANP1eJEF4UTr-UC3S5TWsD9p69_gwy5i4_OkAmg=_GUFHF3TBQ@mail.gmail.com>
References: <1383278208-4053-1-git-send-email-liwang@ubuntukylin.com>
	<CANP1eJH2ewpYyWe2Oo4OMMg2UB+RE8DBt=Xg-MUDo6uJ5aGcpg@mail.gmail.com>
	<alpine.DEB.2.00.1311051543170.9474@cobra.newdream.net>
	<CANP1eJEF4UTr-UC3S5TWsD9p69_gwy5i4_OkAmg=_GUFHF3TBQ@mail.gmail.com>
Date: Wed, 6 Nov 2013 23:01:40 +0800
Message-ID: <CAAM7YAkOLM_C-ydXQN9wpCXuHTJL1drOucdLdVNX1UB66uaXbA@mail.gmail.com>
Subject: Re: [PATCH] ceph: Update the pages in fscache in writepages() path
From: "Yan, Zheng" <ukernel@gmail.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: Sage Weil <sage@inktank.com>, Li Wang <liwang@ubuntukylin.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org, Min Chen <minchen@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 9:41 PM, Milosz Tanski <milosz@adfin.com> wrote:
> Sage,
>
> I think the incrementing version counter on the whole is a neater
> solution then using size and mtime. If nothing else it's more explicit
> in the the read cache version. With what you suggested plus additional
> changes to the open code (where the cookie gets created) the
> write-through scenario should be correct.
>
> Sadly, my understanding of the MDS protocol is still not great. So
> when doing this in the first place I erred on the side of using what
> was already in place.
>
> In a kind of un-related question. Is there a debug hook in the kclient
> (or MDS for that matter) to dump the current file inodes (names) with
> issues caps and to which hosts. This would be very helpful for
> debugging, since from time to time I see a one of the clients get
> stuck in getattr (via mdsc debug log).
>

"ceph mds tell \* dumpcache" dump the mds cache to a file. the dump
file contains caps information.

Regards
Yan, Zheng

> Thanks,
> - Milosz
>
> On Tue, Nov 5, 2013 at 6:56 PM, Sage Weil <sage@inktank.com> wrote:
>> On Tue, 5 Nov 2013, Milosz Tanski wrote:
>>> Li,
>>>
>>> First, sorry for the late reply on this.
>>>
>>> Currently fscache is only supported for files that are open in read
>>> only mode. I originally was going to let fscache cache in the write
>>> path as well as long as the file was open in with O_LAZY. I abandoned
>>> that idea. When a user opens the file in O_LAZY we can cache things
>>> locally with the assumption that the user will care of the
>>> synchronization in some other manner. There is no way of invalidating
>>> a subset of the pages in object cached by fscache, there is no way we
>>> can make O_LAZY work well.
>>>
>>> The ceph_readpage_to_fscache() in writepage has no effect and it
>>> should be removed. ceph_readpage_to_fscache() calls cache_valid() to
>>> see if it should perform the page save, and since the file can't have
>>> a CACHE cap at the point in time it doesn't do it.
>>
>> (Hmm, Dusting off my understanding of fscache and reading
>> fs/ceph/cache.c; watch out!)  It looks like cache_valid is
>>
>> static inline int cache_valid(struct ceph_inode_info *ci)
>> {
>>         return ((ceph_caps_issued(ci) & CEPH_CAP_FILE_CACHE) &&
>>                 (ci->i_fscache_gen == ci->i_rdcache_gen));
>> }
>>
>> and in the FILE_EXCL case, the MDS will issue CACHE|BUFFER caps.  But I
>> think the aux key (size+mtime) will prevent any use of the cache as soon
>> as the first write happens and mtime changes, right?
>>
>> I think that in order to make this work, we need to fix/create a
>> file_version (or something similar) field in the (mds) inode_t to have
>> some useful value.  I.e., increment it any time
>>
>>  - a different client/writer comes along
>>  - a file is modified by the mds (e.g., truncated or recovered)
>>
>> but allow it to otherwise remain the same as long as only a single client
>> is working with the file exclusively.  This will be more precise than the
>> (size, mtime) check that is currently used, and would remain valid when a
>> single client opens the same file for exclusive read/write multiple times
>> but there are no other intervening changes.
>>
>> Milosz, if that were in place, is there any reason not to wire up
>> writepage and allow the fscache to be used write-through?
>>
>> sage
>>
>>
>>
>>
>>>
>>> Thanks,
>>> - Milosz
>>>
>>> On Thu, Oct 31, 2013 at 11:56 PM, Li Wang <liwang@ubuntukylin.com> wrote:
>>> > Currently, the pages in fscache only are updated in writepage() path,
>>> > add the process in writepages().
>>> >
>>> > Signed-off-by: Min Chen <minchen@ubuntukylin.com>
>>> > Signed-off-by: Li Wang <liwang@ubuntukylin.com>
>>> > Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
>>> > ---
>>> >  fs/ceph/addr.c |    8 +++++---
>>> >  1 file changed, 5 insertions(+), 3 deletions(-)
>>> >
>>> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>> > index 6df8bd4..cc57911 100644
>>> > --- a/fs/ceph/addr.c
>>> > +++ b/fs/ceph/addr.c
>>> > @@ -746,7 +746,7 @@ retry:
>>> >
>>> >         while (!done && index <= end) {
>>> >                 int num_ops = do_sync ? 2 : 1;
>>> > -               unsigned i;
>>> > +               unsigned i, j;
>>> >                 int first;
>>> >                 pgoff_t next;
>>> >                 int pvec_pages, locked_pages;
>>> > @@ -894,7 +894,6 @@ get_more_pages:
>>> >                 if (!locked_pages)
>>> >                         goto release_pvec_pages;
>>> >                 if (i) {
>>> > -                       int j;
>>> >                         BUG_ON(!locked_pages || first < 0);
>>> >
>>> >                         if (pvec_pages && i == pvec_pages &&
>>> > @@ -924,7 +923,10 @@ get_more_pages:
>>> >
>>> >                 osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0,
>>> >                                                         !!pool, false);
>>> > -
>>> > +               for(j = 0; j < locked_pages; j++) {
>>> > +                       struct page *page = pages[j];
>>> > +                       ceph_readpage_to_fscache(inode, page);
>>> > +               }
>>> >                 pages = NULL;   /* request message now owns the pages array */
>>> >                 pool = NULL;
>>> >
>>> > --
>>> > 1.7.9.5
>>> >
>>> > --
>>> > To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
>>> > the body of a message to majordomo@vger.kernel.org
>>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>> --
>>> Milosz Tanski
>>> CTO
>>> 10 East 53rd Street, 37th floor
>>> New York, NY 10022
>>>
>>> p: 646-253-9055
>>> e: milosz@adfin.com
>>>
>>>
>
>
>
> --
> Milosz Tanski
> CTO
> 10 East 53rd Street, 37th floor
> New York, NY 10022
>
> p: 646-253-9055
> e: milosz@adfin.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
