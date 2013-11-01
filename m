Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3KAQvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:51:20 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40480 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3KAQvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:51:17 -0400
MIME-Version: 1.0
In-Reply-To: <1383313758-9776-1-git-send-email-liwang@ubuntukylin.com>
References: <1383313758-9776-1-git-send-email-liwang@ubuntukylin.com>
Date: Fri, 1 Nov 2013 12:51:16 -0400
Message-ID: <CANP1eJGGT2m53EuwwTw_GzsQj9LaGFS8_Bwr4tXP1Tm9viAxAA@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: Write through cache support based on fscache
From: Milosz Tanski <milosz@adfin.com>
To: Li Wang <liwang@ubuntukylin.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        Sage Weil <sage@inktank.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Min Chen <minchen@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li,

I think it would be fantastic to see a write cache. In many workloads
you ended up writing out a file and then turning around and reading it
right back in on the same node.

There's a few things that I would like to see. First, an mount option
to turn on/off write through caching. There are some workloads / user
hardware configurations that will not benefit from this (it might be a
net negative). Also, I think it's nice to have a fallback to disable
it it's miss behaving.

Second, for correctness I think you should only do write-through
caching if you have an exclusive cap on the file. Currently as the
code is written it only reads from fscache if the file is open in read
only mode and has the cache cap. This would also have to change.

Thanks,
- Milosz

P.S: Sorry for the second message Li, I fail at email and forgot to reply-all.

On Fri, Nov 1, 2013 at 9:49 AM, Li Wang <liwang@ubuntukylin.com> wrote:
> Currently, fscache only plays as read cache for ceph, this patch
> enables it plays as the write through cache as well.
>
> A small trick to be discussed: if the writing to OSD finishes before
> the writing to fscache, the fscache writing is cancelled to avoid
> slow down the writepages() process.
>
> Signed-off-by: Min Chen <minchen@ubuntukylin.com>
> Signed-off-by: Li Wang <liwang@ubuntukylin.com>
> Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
> ---
>  fs/ceph/addr.c  |   10 +++++++---
>  fs/ceph/cache.c |   29 +++++++++++++++++++++++++++++
>  fs/ceph/cache.h |   13 +++++++++++++
>  3 files changed, 49 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 6df8bd4..2465c49 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -506,7 +506,7 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>             CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
>                 set_bdi_congested(&fsc->backing_dev_info, BLK_RW_ASYNC);
>
> -       ceph_readpage_to_fscache(inode, page);
> +       ceph_writepage_to_fscache(inode, page);
>
>         set_page_writeback(page);
>         err = ceph_osdc_writepages(osdc, ceph_vino(inode),
> @@ -634,6 +634,7 @@ static void writepages_finish(struct ceph_osd_request *req,
>                 if ((issued & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0)
>                         generic_error_remove_page(inode->i_mapping, page);
>
> +               ceph_maybe_release_fscache_page(inode, page);
>                 unlock_page(page);
>         }
>         dout("%p wrote+cleaned %d pages\n", inode, wrote);
> @@ -746,7 +747,7 @@ retry:
>
>         while (!done && index <= end) {
>                 int num_ops = do_sync ? 2 : 1;
> -               unsigned i;
> +               unsigned i, j;
>                 int first;
>                 pgoff_t next;
>                 int pvec_pages, locked_pages;
> @@ -894,7 +895,6 @@ get_more_pages:
>                 if (!locked_pages)
>                         goto release_pvec_pages;
>                 if (i) {
> -                       int j;
>                         BUG_ON(!locked_pages || first < 0);
>
>                         if (pvec_pages && i == pvec_pages &&
> @@ -924,6 +924,10 @@ get_more_pages:
>
>                 osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0,
>                                                         !!pool, false);
> +               for (j = 0; j < locked_pages; j++) {
> +                       struct page *page = pages[j];
> +                       ceph_writepage_to_fscache(inode, page);
> +               }
>
>                 pages = NULL;   /* request message now owns the pages array */
>                 pool = NULL;
> diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
> index 6bfe65e..6f928c4 100644
> --- a/fs/ceph/cache.c
> +++ b/fs/ceph/cache.c
> @@ -320,6 +320,24 @@ void ceph_readpage_to_fscache(struct inode *inode, struct page *page)
>                  fscache_uncache_page(ci->fscache, page);
>  }
>
> +void ceph_writepage_to_fscache(struct inode *inode, struct page *page)
> +{
> +       struct ceph_inode_info *ci = ceph_inode(inode);
> +       int ret;
> +
> +       if (!cache_valid(ci))
> +               return;
> +
> +       if (!PageFsCache(page)) {
> +               if (fscache_alloc_page(ci->fscache, page, GFP_KERNEL))
> +                       return;
> +       }
> +
> +       if (fscache_write_page(ci->fscache, page, GFP_KERNEL))
> +               fscache_uncache_page(ci->fscache, page);
> +}
> +
> +
>  void ceph_invalidate_fscache_page(struct inode* inode, struct page *page)
>  {
>         struct ceph_inode_info *ci = ceph_inode(inode);
> @@ -328,6 +346,17 @@ void ceph_invalidate_fscache_page(struct inode* inode, struct page *page)
>         fscache_uncache_page(ci->fscache, page);
>  }
>
> +void ceph_maybe_release_fscache_page(struct inode *inode, struct page *page)
> +{
> +       struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +       if (PageFsCache(page)) {
> +               if (!fscache_check_page_write(ci->fscache, page))
> +                       fscache_maybe_release_page(ci->fscache,
> +                                                  page, GFP_KERNEL);
> +       }
> +}
> +
>  void ceph_fscache_unregister_fs(struct ceph_fs_client* fsc)
>  {
>         if (fsc->revalidate_wq)
> diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
> index ba94940..aa02b7a 100644
> --- a/fs/ceph/cache.h
> +++ b/fs/ceph/cache.h
> @@ -45,7 +45,9 @@ int ceph_readpages_from_fscache(struct inode *inode,
>                                 struct list_head *pages,
>                                 unsigned *nr_pages);
>  void ceph_readpage_to_fscache(struct inode *inode, struct page *page);
> +void ceph_writepage_to_fscache(struct inode *inode, struct page *page);
>  void ceph_invalidate_fscache_page(struct inode* inode, struct page *page);
> +void ceph_maybe_release_fscache_page(struct inode *inode, struct page *page);
>  void ceph_queue_revalidate(struct inode *inode);
>
>  static inline void ceph_fscache_invalidate(struct inode *inode)
> @@ -127,6 +129,11 @@ static inline void ceph_readpage_to_fscache(struct inode *inode,
>  {
>  }
>
> +static inline void ceph_writepage_to_fscache(struct inode *inode,
> +                                            struct page *page)
> +{
> +}
> +
>  static inline void ceph_fscache_invalidate(struct inode *inode)
>  {
>  }
> @@ -140,6 +147,12 @@ static inline void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info*
>  {
>  }
>
> +
> +static inline void ceph_maybe_release_fscache_page(struct inode *inode,
> +                                                  struct page *page)
> +{
> +}
> +
>  static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
>  {
>         return 1;
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Milosz Tanski
CTO
10 East 53rd Street, 37th floor
New York, NY 10022

p: 646-253-9055
e: milosz@adfin.com
