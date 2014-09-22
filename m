Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaIVChQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 22:37:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54490 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaIVChO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 22:37:14 -0400
X-AuditID: cbfee61a-f79c06d000004e71-3c-541f8b57e924
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
 <1410732864-53069-7-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1410732864-53069-7-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 07/10] f2fs: use meta_inode cache to improve
	roll-forward speed
Date: Mon, 22 Sep 2014 10:36:25 +0800
Message-id: <000001cfd60e$1ca204a0$55e60de0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIbmzp62SYUdq9YHpxJKHWnY05jfAIlDbBAm2OwdKA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jAd3wbvkQg/7PehZP1s9itri0yN1i
	z96TLBaXd81hc2Dx2LSqk81j94LPTB6fN8kFMEdx2aSk5mSWpRbp2yVwZSzavJG14IFvxcn+
	BywNjBvtuhg5OSQETCQ+321jgrDFJC7cW8/WxcjFISSwiFHi0LGFTBDOD0aJ6397WEGq2ARU
	JJZ3/AfrEBFQk+jdNwXMZhbIlJjQ/4IdxBYSqJbY8+gNG4jNKeAs0f9lLlivsECCRPPyy2A1
	LAKqEv//vgSzeQUsJZb8P8gGYQtK/Jh8jwVippbE+p3HoebLS2xe85YZ4lIFiR1nXzNC3GAl
	sezmM6gacYmNR26xTGAUmoVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ
	+bmbGMGh/0xqB+PKBotDjAIcjEo8vAua5EOEWBPLiitzDzFKcDArifAezQEK8aYkVlalFuXH
	F5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRqYLQ7IqNm+cNlkiGzm72woGE+
	lyNPU2nOk0vKzB1/WFWe2FgVb98itjP7/YqoNW+s/r1aE+t2rMlSYuOZjdumfTPqnG+7rOTy
	rrkvvjbaJ3qekp20uG6vZEpsunbiPH3RpJdXbcPTFQz7tt9w5pXLOh1an7l+tlJF9vHrTy6e
	6uvYXrmvYYKBhRJLcUaioRZzUXEiAPTODTZ5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Monday, September 15, 2014 6:14 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 07/10] f2fs: use meta_inode cache to improve roll-forward speed
> 
> Previously, all the dnode pages should be read during the roll-forward recovery.
> Even worsely, whole the chain was traversed twice.
> This patch removes that redundant and costly read operations by using page cache
> of meta_inode and readahead function as well.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/checkpoint.c | 11 ++++++++--
>  fs/f2fs/f2fs.h       |  5 +++--
>  fs/f2fs/recovery.c   | 59 +++++++++++++++++++++++++---------------------------
>  fs/f2fs/segment.h    |  5 +++--
>  4 files changed, 43 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 7262d99..d1ed889 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -82,6 +82,8 @@ static inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
>  	case META_SSA:
>  	case META_CP:
>  		return 0;
> +	case META_POR:
> +		return SM_I(sbi)->main_blkaddr + sbi->user_block_count;

Here we will skip virtual over-provision segments, so better to use TOTAL_BLKS(sbi).

>  	default:
>  		BUG();
>  	}
> @@ -90,11 +92,11 @@ static inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
>  /*
>   * Readahead CP/NAT/SIT/SSA pages
>   */
> -int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int type)
> +int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type)
>  {
>  	block_t prev_blk_addr = 0;
>  	struct page *page;
> -	int blkno = start;
> +	block_t blkno = start;
>  	int max_blks = get_max_meta_blks(sbi, type);
> 
>  	struct f2fs_io_info fio = {
> @@ -128,6 +130,11 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int
> type)
>  			/* get ssa/cp block addr */
>  			blk_addr = blkno;
>  			break;
> +		case META_POR:
> +			if (unlikely(blkno >= max_blks))
> +				goto out;
> +			blk_addr = blkno;
> +			break;

The real modification in patch which is merged to dev of f2fs is as following:

- /* get ssa/cp block addr */
+ case META_POR:
+ if (blkno >= max_blks || blkno < min_blks)
+ goto out;

IMHO, it's better to verify boundary separately for META_{SSA,CP,POR} with unlikely.
How do you think?

>  		default:
>  			BUG();
>  		}
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 4f84d2a..48d7d46 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -103,7 +103,8 @@ enum {
>  	META_CP,
>  	META_NAT,
>  	META_SIT,
> -	META_SSA
> +	META_SSA,
> +	META_POR,
>  };
> 
>  /* for the list of ino */
> @@ -1291,7 +1292,7 @@ void destroy_segment_manager_caches(void);
>   */
>  struct page *grab_meta_page(struct f2fs_sb_info *, pgoff_t);
>  struct page *get_meta_page(struct f2fs_sb_info *, pgoff_t);
> -int ra_meta_pages(struct f2fs_sb_info *, int, int, int);
> +int ra_meta_pages(struct f2fs_sb_info *, block_t, int, int);
>  long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
>  void add_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
>  void remove_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index 3736728..6f7fbfa 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -173,7 +173,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head
> *head)
>  {
>  	unsigned long long cp_ver = cur_cp_version(F2FS_CKPT(sbi));
>  	struct curseg_info *curseg;
> -	struct page *page;
> +	struct page *page = NULL;
>  	block_t blkaddr;
>  	int err = 0;
> 
> @@ -181,20 +181,19 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head
> *head)
>  	curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
>  	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
> 
> -	/* read node page */
> -	page = alloc_page(GFP_F2FS_ZERO);
> -	if (!page)
> -		return -ENOMEM;
> -	lock_page(page);
> -
>  	while (1) {
>  		struct fsync_inode_entry *entry;
> 
> -		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
> -		if (err)
> -			return err;
> +		if (blkaddr < SM_I(sbi)->main_blkaddr ||
> +					blkaddr > TOTAL_BLKS(sbi))

blkaddr >= TOTAL_BLKS(sbi) ?

> +			break;
> 
> -		lock_page(page);
> +		page = get_meta_page(sbi, blkaddr);
> +		if (IS_ERR(page))
> +			return PTR_ERR(page);
> +
> +		ra_meta_pages(sbi, next_blkaddr_of_node(page),
> +				MAX_BIO_BLOCKS(max_hw_blocks(sbi)), META_POR);

In first round we readahead [0,n] pages, then in second round we readahead [1,n+1] pages,
but as [1,n] pages is already uptodate, so we will readahead only one page, the same for the
following rounds. It's low efficiency.

So how about modify in find_fsync_dnodes/recover_data like this:

	block_t blkaddr, ra_start_blk;
	int err = 0;

	/* get node pages in the current segment */
	curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
	ra_start_blk = blkaddr;

	while (1) {
		struct fsync_inode_entry *entry;

		if (blkaddr < SM_I(sbi)->main_blkaddr ||
					blkaddr > TOTAL_BLKS(sbi))
			return 0;

		if (ra_start_blk == blkaddr) {
			ra_meta_pages(sbi, ra_start_blk, MAX_BIO_BLOCKS(sbi),
								META_POR);
			ra_start_blk += MAX_BIO_BLOCKS(sbi);
		}

		page = get_meta_page(sbi, blkaddr);

Thanks,
Yu

> 
>  		if (cp_ver != cpver_of_node(page))
>  			break;
> @@ -243,11 +242,9 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head
> *head)
>  next:
>  		/* check next segment */
>  		blkaddr = next_blkaddr_of_node(page);
> +		f2fs_put_page(page, 1);
>  	}
> -
> -	unlock_page(page);
> -	__free_pages(page, 0);
> -
> +	f2fs_put_page(page, 1);
>  	return err;
>  }
> 
> @@ -427,7 +424,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
>  {
>  	unsigned long long cp_ver = cur_cp_version(F2FS_CKPT(sbi));
>  	struct curseg_info *curseg;
> -	struct page *page;
> +	struct page *page = NULL;
>  	int err = 0;
>  	block_t blkaddr;
> 
> @@ -435,21 +432,19 @@ static int recover_data(struct f2fs_sb_info *sbi,
>  	curseg = CURSEG_I(sbi, type);
>  	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
> 
> -	/* read node page */
> -	page = alloc_page(GFP_F2FS_ZERO);
> -	if (!page)
> -		return -ENOMEM;
> -
> -	lock_page(page);
> -
>  	while (1) {
>  		struct fsync_inode_entry *entry;
> 
> -		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
> -		if (err)
> -			return err;
> +		if (blkaddr < SM_I(sbi)->main_blkaddr ||
> +					blkaddr > TOTAL_BLKS(sbi))
> +			break;
> 
> -		lock_page(page);
> +		page = get_meta_page(sbi, blkaddr);
> +		if (IS_ERR(page))
> +			return PTR_ERR(page);
> +
> +		ra_meta_pages(sbi, next_blkaddr_of_node(page),
> +				MAX_BIO_BLOCKS(max_hw_blocks(sbi)), META_POR);
> 
>  		if (cp_ver != cpver_of_node(page))
>  			break;
> @@ -477,11 +472,9 @@ static int recover_data(struct f2fs_sb_info *sbi,
>  next:
>  		/* check next segment */
>  		blkaddr = next_blkaddr_of_node(page);
> +		f2fs_put_page(page, 1);
>  	}
> -
> -	unlock_page(page);
> -	__free_pages(page, 0);
> -
> +	f2fs_put_page(page, 1);
>  	if (!err)
>  		allocate_new_segments(sbi);
>  	return err;
> @@ -527,6 +520,10 @@ out:
>  	destroy_fsync_dnodes(&inode_list);
>  	kmem_cache_destroy(fsync_entry_slab);
> 
> +	/* truncate meta pages to be used by the recovery */
> +	truncate_inode_pages_range(META_MAPPING(sbi),
> +		SM_I(sbi)->main_blkaddr << PAGE_CACHE_SHIFT, -1);
> +
>  	if (err) {
>  		truncate_inode_pages_final(NODE_MAPPING(sbi));
>  		truncate_inode_pages_final(META_MAPPING(sbi));
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index 013aed2..c6f37f2 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -87,6 +87,7 @@
>  	(BITS_TO_LONGS(nr) * sizeof(unsigned long))
>  #define TOTAL_SEGS(sbi)	(SM_I(sbi)->main_segments)
>  #define TOTAL_SECS(sbi)	(sbi->total_sections)
> +#define TOTAL_BLKS(sbi)	(SM_I(sbi)->segment_count << sbi->log_blocks_per_seg)
> 
>  #define SECTOR_FROM_BLOCK(sbi, blk_addr)				\
>  	(((sector_t)blk_addr) << (sbi)->log_sectors_per_block)
> @@ -553,7 +554,7 @@ static inline void check_seg_range(struct f2fs_sb_info *sbi, unsigned int
> segno)
>  static inline void verify_block_addr(struct f2fs_sb_info *sbi, block_t blk_addr)
>  {
>  	struct f2fs_sm_info *sm_info = SM_I(sbi);
> -	block_t total_blks = sm_info->segment_count << sbi->log_blocks_per_seg;
> +	block_t total_blks = TOTAL_BLKS(sbi);
>  	block_t start_addr = sm_info->seg0_blkaddr;
>  	block_t end_addr = start_addr + total_blks - 1;
>  	BUG_ON(blk_addr < start_addr);
> @@ -606,7 +607,7 @@ static inline void check_seg_range(struct f2fs_sb_info *sbi, unsigned int
> segno)
>  static inline void verify_block_addr(struct f2fs_sb_info *sbi, block_t blk_addr)
>  {
>  	struct f2fs_sm_info *sm_info = SM_I(sbi);
> -	block_t total_blks = sm_info->segment_count << sbi->log_blocks_per_seg;
> +	block_t total_blks = TOTAL_BLKS(sbi);
>  	block_t start_addr = sm_info->seg0_blkaddr;
>  	block_t end_addr = start_addr + total_blks - 1;
> 
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> Want excitement?
> Manually upgrade your production database.
> When you want reliability, choose Perforce
> Perforce version control. Predictably reliable.
> http://pubads.g.doubleclick.net/gampad/clk?id=157508191&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

