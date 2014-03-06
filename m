Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaCFWBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:01:12 -0500
Received: from cobra.newdream.net ([66.33.216.30]:60183 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaCFWBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:01:10 -0500
Date: Thu, 6 Mar 2014 14:01:09 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Milosz Tanski <milosz@adfin.com>
cc: Li Wang <liwang@ubuntukylin.com>, ceph-devel <ceph-devel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH 0/3] Ceph fscache: Fix kernel panic due to a race
In-Reply-To: <CANP1eJGeb+S6R=2c5s-Ged3Ysu03DzZWRvoeKOZqTNSahcwE=Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1403061400590.3593@cobra.newdream.net>
References: <cover.1388066937.git.liwang@ubuntukylin.com> <CANP1eJFMZrT+GbHhg3gWqsy=whSozEiWmZj-L08EyhD8LcqzeQ@mail.gmail.com> <52BE4AB1.6090901@ubuntukylin.com> <CANP1eJG237CRrXjfiAPJsL5NK6E9e6OuwiaTWSydiXJ=QFa0uw@mail.gmail.com>
 <CANP1eJGeb+S6R=2c5s-Ged3Ysu03DzZWRvoeKOZqTNSahcwE=Q@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milosz,

Thanks, I've added this to the testing branch!

sage


On Mon, 3 Mar 2014, Milosz Tanski wrote:

> Hey guys, I'm terribly sorry but apparently this got stuck in my draft
> mailbox for 3 months. Since we've been running this on both our test /
> prod clusters I would say this is sufficiently tested.
> 
> I've looked at the code and tested this for a week now on test cluster
> and it looks good. It does fix a real problem and I think we should
> push it to mainline. Thanks for fixing this Li! The reason I was not
> seeing this is that I had other fscache patches that were masking this
> problem :/
> 
> Thanks,
> - Milosz
> 
> P.S: Sorry for the double mail, the first one was not sent as text. I
> apparently do not know how to use gmail.
> 
> On Fri, Jan 3, 2014 at 9:43 AM, Milosz Tanski <milosz@adfin.com> wrote:
> > I'm going to look the patches and the issue in full detail. In the
> > meantime do you guys have the oops back trace. I have some other
> > fscache patches that haven't made it upstream yet that might have been
> > masking this issue for me.
> >
> > On Fri, Dec 27, 2013 at 10:51 PM, Li Wang <liwang@ubuntukylin.com> wrote:
> >> Hi Milosz,
> >>   As far as I know, logically, currently fscache does not play
> >> as write cache for Ceph, except that there is a
> >> call to ceph_readpage_to_fscache() in ceph_writepage(), but that
> >> is nothing related to our test case. According to our observation,
> >> our test case never goes through ceph_writepage(), instead, it goes
> >> through ceph_writepages(). So in other words, I donot think this
> >> is related to caching in write path.
> >>   May I try to explain the panic in more detail,
> >>
> >> (1) dd if=/dev/zero of=cephfs/foo bs=8 count=512
> >> (2) echo 3 > /proc/sys/vm/drop_caches
> >> (3) dd if=cephfs/foo of=/dev/null bs=8 count=1024
> >>
> >> For statement (1), it is frequently appending a file, so
> >> ceph_aio_write() frequently updates the inode->i_size,
> >> however, these updates did not immediately reflected to
> >> object->store_limit_l. For statement (3), when we
> >> start reading the second page at [4096, 8192), ceph find that the page
> >> does not be cached in fscache, then it decides to write this page into
> >> fscache, during this process in cachefiles_write_page(), it found that
> >> object->store_limit_l < 4096 (page->index << 12), it causes panic. Does
> >> it make sense?
> >>
> >> Cheers,
> >> Li Wang
> >>
> >>
> >> On 2013/12/27 6:51, Milosz Tanski wrote:
> >>>
> >>> Li,
> >>>
> >>> I looked at the patchset am I correct that this only happens when we
> >>> enable caching in the write path?
> >>>
> >>> - Milosz
> >>>
> >>> On Thu, Dec 26, 2013 at 9:29 AM, Li Wang <liwang@ubuntukylin.com> wrote:
> >>>>
> >>>> From: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
> >>>>
> >>>> The following scripts could easily panic the kernel,
> >>>>
> >>>> #!/bin/bash
> >>>> mount -t ceph -o fsc MONADDR:/ cephfs
> >>>> rm -rf cephfs/foo
> >>>> dd if=/dev/zero of=cephfs/foo bs=8 count=512
> >>>> echo 3 > /proc/sys/vm/drop_caches
> >>>> dd if=cephfs/foo of=/dev/null bs=8 count=1024
> >>>>
> >>>> This is due to when writing a page into fscache, the code will
> >>>> assert that the write position does not exceed the
> >>>> object->store_limit_l, which is supposed to be equal to inode->i_size.
> >>>> However, for current implementation, after file writing, the
> >>>> object->store_limit_l is not synchronized with new
> >>>> inode->i_size immediately, which introduces a race that if writing
> >>>> a new page into fscache, will reach the ASSERT that write position
> >>>> has exceeded the object->store_limit_l, and cause kernel panic.
> >>>> This patch fixes it.
> >>>>
> >>>> Yunchuan Wen (3):
> >>>>    Ceph fscache: Add an interface to synchronize object store limit
> >>>>    Ceph fscache: Update object store limit after writing
> >>>>    Ceph fscache: Wait for completion of object initialization
> >>>>
> >>>>   fs/ceph/cache.c |    1 +
> >>>>   fs/ceph/cache.h |   10 ++++++++++
> >>>>   fs/ceph/file.c  |    3 +++
> >>>>   3 files changed, 14 insertions(+)
> >>>>
> >>>> --
> >>>> 1.7.9.5
> >>>>
> >>>
> >>>
> >>>
> >>
> >
> >
> >
> > --
> > Milosz Tanski
> > CTO
> > 10 East 53rd Street, 37th floor
> > New York, NY 10022
> >
> > p: 646-253-9055
> > e: milosz@adfin.com
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
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
