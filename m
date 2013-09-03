Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3ICRYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:24:25 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51797 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab3ICRYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:24:23 -0400
MIME-Version: 1.0
In-Reply-To: <b5506ec6c293011dc880ae70cc1f0111e1512ff6.1375999914.git.milosz@adfin.com>
References: <cover.1375999914.git.milosz@adfin.com>
	<b5506ec6c293011dc880ae70cc1f0111e1512ff6.1375999914.git.milosz@adfin.com>
Date: Tue, 3 Sep 2013 13:24:21 -0400
Message-ID: <CANP1eJE_so8fj4OhkBWS-kCAoa4CWj+sJc=SioCo42SYRAcjTA@mail.gmail.com>
Subject: Re: [PATCH 4/5] fscache: netfs function for cleanup post readpages
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel <ceph-devel@vger.kernel.org>
Cc: Sage Weil <sage@inktank.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        David Howells <dhowells@redhat.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just wanted to follow up on this patch (and number 5) in the series.
The backtrace I posted originally is not correct backtrace from this
particular issue. The new one I attached at the bottom of this email
is the right one. The backtrace I posted is a that only Ceph
experiences in ceph_readpages because it directly returns the pages.
However, the patch I posted is still valid and still address a real
problem. The only issue was the wrong backtrace.

The fixed is between Ceph and Fscache interaction when called from
readahed code path. I also investigated the other filesystems (CIFS
and NFS) and they are also susceptible to the same issue.

In any case the correct backtrace to company the patch for review is
in this email.

- Milosz

» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824267] BUG:
Bad page state in process petabucket pfn:407aed
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824273]
page:ffffea00101ebb40 count:0 mapcount:0 mapping: (null) index:0x9cb
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824278] page
flags: 0x200000000001000(private_2)
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824282]
Modules linked in: ceph libceph cachefiles ghash_clmulni_intel
aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64
microcode auth_rpcgss oid_registry nfsv4 nfs fscache lockd sunrpc
raid10 raid456 async_pq async_xor async_memcpy async_raid6_recov
async_tx raid1 raid0 multipath linear btrfs raid6_pq lzo_compress xor
zlib_deflate libcrc32c
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824297] CPU:
1 PID: 32527 Comm: petabucket Tainted: G B 3.10.0-virtual #45
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824298]
0000000000000001 ffff880424341a48 ffffffff815523f2 ffff880424341a68
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824300]
ffffffff8111def7 0000000000000001 ffffea00101ebb40 ffff880424341aa8
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824302]
ffffffff8111e49e ffffffff81132ce9 ffffea00101ebb40 0200000000001000
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824304] Call Trace:
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824307]
[<ffffffff815523f2>] dump_stack+0x19/0x1b
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824309]
[<ffffffff8111def7>] bad_page+0xc7/0x120
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824312]
[<ffffffff8111e49e>] free_pages_prepare+0x10e/0x120
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824314]
[<ffffffff81132ce9>] ? zone_statistics+0x99/0xc0
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824316]
[<ffffffff8111fc80>] free_hot_cold_page+0x40/0x170
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824318]
[<ffffffff81123507>] __put_single_page+0x27/0x30
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824320]
[<ffffffff81123df5>] put_page+0x25/0x40
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824321]
[<ffffffff81123e66>] put_pages_list+0x56/0x70
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824324]
[<ffffffff81122a98>] __do_page_cache_readahead+0x1b8/0x260
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824327]
[<ffffffff81122ea1>] ra_submit+0x21/0x30
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824329]
[<ffffffff81118f64>] filemap_fault+0x254/0x490
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824332]
[<ffffffff8113a74f>] __do_fault+0x6f/0x4e0
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824334]
[<ffffffff81004ec2>] ? xen_mc_flush+0xb2/0x1c0
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824336]
[<ffffffff8113d856>] handle_pte_fault+0xf6/0x930
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824339]
[<ffffffff81008c33>] ? pte_mfn_to_pfn+0x93/0x110
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824341]
[<ffffffff81008cce>] ? xen_pmd_val+0xe/0x10
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824343]
[<ffffffff81005469>] ? __raw_callee_save_xen_pmd_val+0x11/0x1e
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824346]
[<ffffffff8113f361>] handle_mm_fault+0x251/0x370
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824348]
[<ffffffff8155bffa>] __do_page_fault+0x1aa/0x550
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824350]
[<ffffffff81004ec2>] ? xen_mc_flush+0xb2/0x1c0
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824352]
[<ffffffff8100483d>] ? xen_clts+0x8d/0x190
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824354]
[<ffffffff8155c3ae>] do_page_fault+0xe/0x10
» 12:20:34.896 Aug 9 16:20:38 betanode2 kernel: [11121126.824357]
[<ffffffff81558818>] page_fault+0x28/0x30

On Wed, Aug 21, 2013 at 5:30 PM, Milosz Tanski <milosz@adfin.com> wrote:
> Currently the fscache code expect the netfs to call fscache_readpages_or_alloc
> inside the aops readpages callback. It marks all the pages in the list provided
> by readahead with PgPrivate2. In the cases that the netfs fails to read all the
> pages (which is legal) it ends up returning to the readahead and triggering a
> BUG. This happens because the page list still contains marked pages.
>
> This patch implements a simple fscache_readpages_cancel function that the netfs
> should call before returning from readpages. It will revoke the pages from the
> underlying cache backend and unmark them.
>
> This addresses this BUG being triggered by netfs code:
>
> [12410647.597278] BUG: Bad page state in process petabucket  pfn:3d504e
> [12410647.597292] page:ffffea000f541380 count:0 mapcount:0 mapping:
>         (null) index:0x0
> [12410647.597298] page flags: 0x200000000001000(private_2)
>
> ...
>
> [12410647.597334] Call Trace:
> [12410647.597345]  [<ffffffff815523f2>] dump_stack+0x19/0x1b
> [12410647.597356]  [<ffffffff8111def7>] bad_page+0xc7/0x120
> [12410647.597359]  [<ffffffff8111e49e>] free_pages_prepare+0x10e/0x120
> [12410647.597361]  [<ffffffff8111fc80>] free_hot_cold_page+0x40/0x170
> [12410647.597363]  [<ffffffff81123507>] __put_single_page+0x27/0x30
> [12410647.597365]  [<ffffffff81123df5>] put_page+0x25/0x40
> [12410647.597376]  [<ffffffffa02bdcf9>] ceph_readpages+0x2e9/0x6e0 [ceph]
> [12410647.597379]  [<ffffffff81122a8f>] __do_page_cache_readahead+0x1af/0x260
> [12410647.597382]  [<ffffffff81122ea1>] ra_submit+0x21/0x30
> [12410647.597384]  [<ffffffff81118f64>] filemap_fault+0x254/0x490
> [12410647.597387]  [<ffffffff8113a74f>] __do_fault+0x6f/0x4e0
> [12410647.597391]  [<ffffffff810125bd>] ? __switch_to+0x16d/0x4a0
> [12410647.597395]  [<ffffffff810865ba>] ? finish_task_switch+0x5a/0xc0
> [12410647.597398]  [<ffffffff8113d856>] handle_pte_fault+0xf6/0x930
> [12410647.597401]  [<ffffffff81008c33>] ? pte_mfn_to_pfn+0x93/0x110
> [12410647.597403]  [<ffffffff81008cce>] ? xen_pmd_val+0xe/0x10
> [12410647.597405]  [<ffffffff81005469>] ? __raw_callee_save_xen_pmd_val+0x11/0x1e
> [12410647.597407]  [<ffffffff8113f361>] handle_mm_fault+0x251/0x370
> [12410647.597411]  [<ffffffff812b0ac4>] ? call_rwsem_down_read_failed+0x14/0x30
> [12410647.597414]  [<ffffffff8155bffa>] __do_page_fault+0x1aa/0x550
> [12410647.597418]  [<ffffffff8108011d>] ? up_write+0x1d/0x20
> [12410647.597422]  [<ffffffff8113141c>] ? vm_mmap_pgoff+0xbc/0xe0
> [12410647.597425]  [<ffffffff81143bb8>] ? SyS_mmap_pgoff+0xd8/0x240
> [12410647.597427]  [<ffffffff8155c3ae>] do_page_fault+0xe/0x10
> [12410647.597431]  [<ffffffff81558818>] page_fault+0x28/0x30
>
> Signed-off-by: Milosz Tanski <milosz@adfin.com>
> ---
>  fs/fscache/page.c       | 16 ++++++++++++++++
>  include/linux/fscache.h | 22 ++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
>
> diff --git a/fs/fscache/page.c b/fs/fscache/page.c
> index d479ab3..0cc3153 100644
> --- a/fs/fscache/page.c
> +++ b/fs/fscache/page.c
> @@ -1132,3 +1132,19 @@ void __fscache_uncache_all_inode_pages(struct fscache_cookie *cookie,
>         _leave("");
>  }
>  EXPORT_SYMBOL(__fscache_uncache_all_inode_pages);
> +
> +/**
> + * Unmark pages allocate in the readahead code path (via:
> + * fscache_readpages_or_alloc) after delegating to the base filesystem
> + */
> +void __fscache_readpages_cancel(struct fscache_cookie *cookie,
> +                               struct list_head *pages)
> +{
> +       struct page *page;
> +
> +       list_for_each_entry(page, pages, lru) {
> +               if (PageFsCache(page))
> +                       __fscache_uncache_page(cookie, page);
> +       }
> +}
> +EXPORT_SYMBOL(__fscache_readpages_cancel);
> diff --git a/include/linux/fscache.h b/include/linux/fscache.h
> index 7a49e8f..c324177 100644
> --- a/include/linux/fscache.h
> +++ b/include/linux/fscache.h
> @@ -209,6 +209,8 @@ extern bool __fscache_maybe_release_page(struct fscache_cookie *, struct page *,
>                                          gfp_t);
>  extern void __fscache_uncache_all_inode_pages(struct fscache_cookie *,
>                                               struct inode *);
> +extern void __fscache_readpages_cancel(struct fscache_cookie *cookie,
> +                                      struct list_head *pages);
>
>  /**
>   * fscache_register_netfs - Register a filesystem as desiring caching services
> @@ -719,4 +721,24 @@ void fscache_uncache_all_inode_pages(struct fscache_cookie *cookie,
>                 __fscache_uncache_all_inode_pages(cookie, inode);
>  }
>
> +/**
> + * fscache_readpages_cancel
> + * @cookie: The cookie representing the inode's cache object.
> + * @pages: The netfs pages that we canceled write on in readpages()
> + *
> + * Uncache/unreserve the pages reserved earlier in readpages() via
> + * fscache_readpages_or_alloc(). In most successful caches in readpages() this
> + * doesn't do anything. In cases when the underlying netfs's readahead failed
> + * we need to cleanup the pagelist (unmark and uncache).
> + *
> + * This function may sleep (if it's calling to the cache backend).
> + */
> +static inline
> +void fscache_readpages_cancel(struct fscache_cookie *cookie,
> +                             struct list_head *pages)
> +{
> +       if (fscache_cookie_valid(cookie))
> +               __fscache_readpages_cancel(cookie, pages);
> +}
> +
>  #endif /* _LINUX_FSCACHE_H */
> --
> 1.8.1.2
>
