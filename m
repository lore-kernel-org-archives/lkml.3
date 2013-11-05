Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3KEX4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:56:13 -0500
Received: from cobra.newdream.net ([66.33.216.30]:55270 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3KEX4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:56:12 -0500
Date: Tue, 5 Nov 2013 15:56:11 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Milosz Tanski <milosz@adfin.com>
cc: Li Wang <liwang@ubuntukylin.com>, ceph-devel <ceph-devel@vger.kernel.org>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org, Min Chen <minchen@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH] ceph: Update the pages in fscache in writepages() path
In-Reply-To: <CANP1eJH2ewpYyWe2Oo4OMMg2UB+RE8DBt=Xg-MUDo6uJ5aGcpg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1311051543170.9474@cobra.newdream.net>
References: <1383278208-4053-1-git-send-email-liwang@ubuntukylin.com> <CANP1eJH2ewpYyWe2Oo4OMMg2UB+RE8DBt=Xg-MUDo6uJ5aGcpg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013, Milosz Tanski wrote:
> Li,
> 
> First, sorry for the late reply on this.
> 
> Currently fscache is only supported for files that are open in read
> only mode. I originally was going to let fscache cache in the write
> path as well as long as the file was open in with O_LAZY. I abandoned
> that idea. When a user opens the file in O_LAZY we can cache things
> locally with the assumption that the user will care of the
> synchronization in some other manner. There is no way of invalidating
> a subset of the pages in object cached by fscache, there is no way we
> can make O_LAZY work well.
> 
> The ceph_readpage_to_fscache() in writepage has no effect and it
> should be removed. ceph_readpage_to_fscache() calls cache_valid() to
> see if it should perform the page save, and since the file can't have
> a CACHE cap at the point in time it doesn't do it.

(Hmm, Dusting off my understanding of fscache and reading 
fs/ceph/cache.c; watch out!)  It looks like cache_valid is

static inline int cache_valid(struct ceph_inode_info *ci)
{
	return ((ceph_caps_issued(ci) & CEPH_CAP_FILE_CACHE) &&
		(ci->i_fscache_gen == ci->i_rdcache_gen));
}

and in the FILE_EXCL case, the MDS will issue CACHE|BUFFER caps.  But I 
think the aux key (size+mtime) will prevent any use of the cache as soon 
as the first write happens and mtime changes, right?

I think that in order to make this work, we need to fix/create a 
file_version (or something similar) field in the (mds) inode_t to have 
some useful value.  I.e., increment it any time

 - a different client/writer comes along
 - a file is modified by the mds (e.g., truncated or recovered)

but allow it to otherwise remain the same as long as only a single client 
is working with the file exclusively.  This will be more precise than the 
(size, mtime) check that is currently used, and would remain valid when a 
single client opens the same file for exclusive read/write multiple times 
but there are no other intervening changes.

Milosz, if that were in place, is there any reason not to wire up 
writepage and allow the fscache to be used write-through?

sage




> 
> Thanks,
> - Milosz
> 
> On Thu, Oct 31, 2013 at 11:56 PM, Li Wang <liwang@ubuntukylin.com> wrote:
> > Currently, the pages in fscache only are updated in writepage() path,
> > add the process in writepages().
> >
> > Signed-off-by: Min Chen <minchen@ubuntukylin.com>
> > Signed-off-by: Li Wang <liwang@ubuntukylin.com>
> > Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
> > ---
> >  fs/ceph/addr.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 6df8bd4..cc57911 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -746,7 +746,7 @@ retry:
> >
> >         while (!done && index <= end) {
> >                 int num_ops = do_sync ? 2 : 1;
> > -               unsigned i;
> > +               unsigned i, j;
> >                 int first;
> >                 pgoff_t next;
> >                 int pvec_pages, locked_pages;
> > @@ -894,7 +894,6 @@ get_more_pages:
> >                 if (!locked_pages)
> >                         goto release_pvec_pages;
> >                 if (i) {
> > -                       int j;
> >                         BUG_ON(!locked_pages || first < 0);
> >
> >                         if (pvec_pages && i == pvec_pages &&
> > @@ -924,7 +923,10 @@ get_more_pages:
> >
> >                 osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0,
> >                                                         !!pool, false);
> > -
> > +               for(j = 0; j < locked_pages; j++) {
> > +                       struct page *page = pages[j];
> > +                       ceph_readpage_to_fscache(inode, page);
> > +               }
> >                 pages = NULL;   /* request message now owns the pages array */
> >                 pool = NULL;
> >
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
> 
> 
