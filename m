Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaIWErX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:47:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:42967 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbaIWErB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:47:01 -0400
Date: Mon, 22 Sep 2014 21:46:56 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 07/10] f2fs: use meta_inode cache to improve
 roll-forward speed
Message-ID: <20140923044656.GA37809@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
 <1410732864-53069-7-git-send-email-jaegeuk@kernel.org>
 <000001cfd60e$1ca204a0$55e60de0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cfd60e$1ca204a0$55e60de0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Mon, Sep 22, 2014 at 10:36:25AM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Monday, September 15, 2014 6:14 AM
> > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Cc: Jaegeuk Kim
> > Subject: [f2fs-dev] [PATCH 07/10] f2fs: use meta_inode cache to improve roll-forward speed
> > 
> > Previously, all the dnode pages should be read during the roll-forward recovery.
> > Even worsely, whole the chain was traversed twice.
> > This patch removes that redundant and costly read operations by using page cache
> > of meta_inode and readahead function as well.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/checkpoint.c | 11 ++++++++--
> >  fs/f2fs/f2fs.h       |  5 +++--
> >  fs/f2fs/recovery.c   | 59 +++++++++++++++++++++++++---------------------------
> >  fs/f2fs/segment.h    |  5 +++--
> >  4 files changed, 43 insertions(+), 37 deletions(-)
> > 
> > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > index 7262d99..d1ed889 100644
> > --- a/fs/f2fs/checkpoint.c
> > +++ b/fs/f2fs/checkpoint.c
> > @@ -82,6 +82,8 @@ static inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
> >  	case META_SSA:
> >  	case META_CP:
> >  		return 0;
> > +	case META_POR:
> > +		return SM_I(sbi)->main_blkaddr + sbi->user_block_count;
> 
> Here we will skip virtual over-provision segments, so better to use TOTAL_BLKS(sbi).
> 
> >  	default:
> >  		BUG();
> >  	}
> > @@ -90,11 +92,11 @@ static inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
> >  /*
> >   * Readahead CP/NAT/SIT/SSA pages
> >   */
> > -int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int type)
> > +int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type)
> >  {
> >  	block_t prev_blk_addr = 0;
> >  	struct page *page;
> > -	int blkno = start;
> > +	block_t blkno = start;
> >  	int max_blks = get_max_meta_blks(sbi, type);
> > 
> >  	struct f2fs_io_info fio = {
> > @@ -128,6 +130,11 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int
> > type)
> >  			/* get ssa/cp block addr */
> >  			blk_addr = blkno;
> >  			break;
> > +		case META_POR:
> > +			if (unlikely(blkno >= max_blks))
> > +				goto out;
> > +			blk_addr = blkno;
> > +			break;
> 
> The real modification in patch which is merged to dev of f2fs is as following:
> 
> - /* get ssa/cp block addr */
> + case META_POR:
> + if (blkno >= max_blks || blkno < min_blks)
> + goto out;
> 
> IMHO, it's better to verify boundary separately for META_{SSA,CP,POR} with unlikely.
> How do you think?

Not bad.
Could you check the v2 below?

> 
> >  		default:
> >  			BUG();
> >  		}
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 4f84d2a..48d7d46 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -103,7 +103,8 @@ enum {
> >  	META_CP,
> >  	META_NAT,
> >  	META_SIT,
> > -	META_SSA
> > +	META_SSA,
> > +	META_POR,
> >  };
> > 
> >  /* for the list of ino */
> > @@ -1291,7 +1292,7 @@ void destroy_segment_manager_caches(void);
> >   */
> >  struct page *grab_meta_page(struct f2fs_sb_info *, pgoff_t);
> >  struct page *get_meta_page(struct f2fs_sb_info *, pgoff_t);
> > -int ra_meta_pages(struct f2fs_sb_info *, int, int, int);
> > +int ra_meta_pages(struct f2fs_sb_info *, block_t, int, int);
> >  long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
> >  void add_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
> >  void remove_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
> > diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> > index 3736728..6f7fbfa 100644
> > --- a/fs/f2fs/recovery.c
> > +++ b/fs/f2fs/recovery.c
> > @@ -173,7 +173,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head
> > *head)
> >  {
> >  	unsigned long long cp_ver = cur_cp_version(F2FS_CKPT(sbi));
> >  	struct curseg_info *curseg;
> > -	struct page *page;
> > +	struct page *page = NULL;
> >  	block_t blkaddr;
> >  	int err = 0;
> > 
> > @@ -181,20 +181,19 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head
> > *head)
> >  	curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
> >  	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
> > 
> > -	/* read node page */
> > -	page = alloc_page(GFP_F2FS_ZERO);
> > -	if (!page)
> > -		return -ENOMEM;
> > -	lock_page(page);
> > -
> >  	while (1) {
> >  		struct fsync_inode_entry *entry;
> > 
> > -		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
> > -		if (err)
> > -			return err;
> > +		if (blkaddr < SM_I(sbi)->main_blkaddr ||
> > +					blkaddr > TOTAL_BLKS(sbi))
> 
> blkaddr >= TOTAL_BLKS(sbi) ?

Right.

> 
> > +			break;
> > 
> > -		lock_page(page);
> > +		page = get_meta_page(sbi, blkaddr);
> > +		if (IS_ERR(page))
> > +			return PTR_ERR(page);
> > +
> > +		ra_meta_pages(sbi, next_blkaddr_of_node(page),
> > +				MAX_BIO_BLOCKS(max_hw_blocks(sbi)), META_POR);
> 
> In first round we readahead [0,n] pages, then in second round we readahead [1,n+1] pages,
> but as [1,n] pages is already uptodate, so we will readahead only one page, the same for the
> following rounds. It's low efficiency.
> 
> So how about modify in find_fsync_dnodes/recover_data like this:
> 
> 	block_t blkaddr, ra_start_blk;
> 	int err = 0;
> 
> 	/* get node pages in the current segment */
> 	curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
> 	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
> 	ra_start_blk = blkaddr;
> 
> 	while (1) {
> 		struct fsync_inode_entry *entry;
> 
> 		if (blkaddr < SM_I(sbi)->main_blkaddr ||
> 					blkaddr > TOTAL_BLKS(sbi))
> 			return 0;
> 
> 		if (ra_start_blk == blkaddr) {
> 			ra_meta_pages(sbi, ra_start_blk, MAX_BIO_BLOCKS(sbi),
> 								META_POR);
> 			ra_start_blk += MAX_BIO_BLOCKS(sbi);
> 		}
> 
> 		page = get_meta_page(sbi, blkaddr);

Well. the blkaddr would not be alway able to be matched.
How about this?

commit 1cdbd53437f32046af8d94f551505754446c9720
Author: Jaegeuk Kim <jaegeuk@kernel.org>
Date:   Thu Sep 11 13:49:55 2014 -0700

    f2fs: use meta_inode cache to improve roll-forward speed
    
    Previously, all the dnode pages should be read during the roll-forward recovery.
    Even worsely, whole the chain was traversed twice.
    This patch removes that redundant and costly read operations by using page cache
    of meta_inode and readahead function as well.
    
    Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index d44d287..700869c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -72,7 +72,23 @@ out:
 	return page;
 }
 
-static inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
+struct page *get_meta_page_ra(struct f2fs_sb_info *sbi, pgoff_t index)
+{
+	bool readahead = false;
+	struct page *page;
+
+	page = find_get_page(META_MAPPING(sbi), index);
+	if (!page || (page && !PageUptodate(page)))
+		readahead = true;
+	f2fs_put_page(page, 0);
+
+	if (readahead)
+		ra_meta_pages(sbi, index,
+				MAX_BIO_BLOCKS(max_hw_blocks(sbi)), META_POR);
+	return get_meta_page(sbi, index);
+}
+
+static inline block_t get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
 {
 	switch (type) {
 	case META_NAT:
@@ -82,6 +98,8 @@ static inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
 	case META_SSA:
 	case META_CP:
 		return 0;
+	case META_POR:
+		return SM_I(sbi)->main_blkaddr + TOTAL_BLKS(sbi);
 	default:
 		BUG();
 	}
@@ -90,12 +108,13 @@ static inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
 /*
  * Readahead CP/NAT/SIT/SSA pages
  */
-int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int type)
+int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type)
 {
 	block_t prev_blk_addr = 0;
 	struct page *page;
-	int blkno = start;
-	int max_blks = get_max_meta_blks(sbi, type);
+	block_t blkno = start;
+	block_t max_blks = get_max_meta_blks(sbi, type);
+	block_t min_blks = SM_I(sbi)->seg0_blkaddr;
 
 	struct f2fs_io_info fio = {
 		.type = META,
@@ -125,7 +144,11 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int type)
 			break;
 		case META_SSA:
 		case META_CP:
-			/* get ssa/cp block addr */
+		case META_POR:
+			if (unlikely(blkno >= max_blks))
+				goto out;
+			if (unlikely(blkno < min_blks))
+				goto out;
 			blk_addr = blkno;
 			break;
 		default:
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8efa170..b6439c3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -103,7 +103,8 @@ enum {
 	META_CP,
 	META_NAT,
 	META_SIT,
-	META_SSA
+	META_SSA,
+	META_POR,
 };
 
 /* for the list of ino */
@@ -1294,7 +1295,8 @@ void destroy_segment_manager_caches(void);
  */
 struct page *grab_meta_page(struct f2fs_sb_info *, pgoff_t);
 struct page *get_meta_page(struct f2fs_sb_info *, pgoff_t);
-int ra_meta_pages(struct f2fs_sb_info *, int, int, int);
+struct page *get_meta_page_ra(struct f2fs_sb_info *, pgoff_t);
+int ra_meta_pages(struct f2fs_sb_info *, block_t, int, int);
 long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
 void add_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
 void remove_dirty_inode(struct f2fs_sb_info *, nid_t, int type);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index e587ee1..3a259a9 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -138,7 +138,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 {
 	unsigned long long cp_ver = cur_cp_version(F2FS_CKPT(sbi));
 	struct curseg_info *curseg;
-	struct page *page;
+	struct page *page = NULL;
 	block_t blkaddr;
 	int err = 0;
 
@@ -146,20 +146,14 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 	curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
 	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
 
-	/* read node page */
-	page = alloc_page(GFP_F2FS_ZERO);
-	if (!page)
-		return -ENOMEM;
-	lock_page(page);
-
 	while (1) {
 		struct fsync_inode_entry *entry;
 
-		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
-		if (err)
-			return err;
+		if (blkaddr < SM_I(sbi)->main_blkaddr ||
+					blkaddr >= TOTAL_BLKS(sbi))
+			return 0;
 
-		lock_page(page);
+		page = get_meta_page_ra(sbi, blkaddr);
 
 		if (cp_ver != cpver_of_node(page))
 			break;
@@ -202,11 +196,9 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
+		f2fs_put_page(page, 1);
 	}
-
-	unlock_page(page);
-	__free_pages(page, 0);
-
+	f2fs_put_page(page, 1);
 	return err;
 }
 
@@ -400,7 +392,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 {
 	unsigned long long cp_ver = cur_cp_version(F2FS_CKPT(sbi));
 	struct curseg_info *curseg;
-	struct page *page;
+	struct page *page = NULL;
 	int err = 0;
 	block_t blkaddr;
 
@@ -408,32 +400,29 @@ static int recover_data(struct f2fs_sb_info *sbi,
 	curseg = CURSEG_I(sbi, type);
 	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
 
-	/* read node page */
-	page = alloc_page(GFP_F2FS_ZERO);
-	if (!page)
-		return -ENOMEM;
-
-	lock_page(page);
-
 	while (1) {
 		struct fsync_inode_entry *entry;
 
-		err = f2fs_submit_page_bio(sbi, page, blkaddr, READ_SYNC);
-		if (err)
-			return err;
+		if (blkaddr < SM_I(sbi)->main_blkaddr ||
+					blkaddr > TOTAL_BLKS(sbi))
+			break;
 
-		lock_page(page);
+		page = get_meta_page_ra(sbi, blkaddr);
 
-		if (cp_ver != cpver_of_node(page))
+		if (cp_ver != cpver_of_node(page)) {
+			f2fs_put_page(page, 1);
 			break;
+		}
 
 		entry = get_fsync_inode(head, ino_of_node(page));
 		if (!entry)
 			goto next;
 
 		err = do_recover_data(sbi, entry->inode, page, blkaddr);
-		if (err)
+		if (err) {
+			f2fs_put_page(page, 1);
 			break;
+		}
 
 		if (entry->blkaddr == blkaddr) {
 			iput(entry->inode);
@@ -443,11 +432,8 @@ static int recover_data(struct f2fs_sb_info *sbi,
 next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
+		f2fs_put_page(page, 1);
 	}
-
-	unlock_page(page);
-	__free_pages(page, 0);
-
 	if (!err)
 		allocate_new_segments(sbi);
 	return err;
@@ -493,6 +479,10 @@ out:
 	destroy_fsync_dnodes(&inode_list);
 	kmem_cache_destroy(fsync_entry_slab);
 
+	/* truncate meta pages to be used by the recovery */
+	truncate_inode_pages_range(META_MAPPING(sbi),
+		SM_I(sbi)->main_blkaddr << PAGE_CACHE_SHIFT, -1);
+
 	if (err) {
 		truncate_inode_pages_final(NODE_MAPPING(sbi));
 		truncate_inode_pages_final(META_MAPPING(sbi));
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 013aed2..c6f37f2 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -87,6 +87,7 @@
 	(BITS_TO_LONGS(nr) * sizeof(unsigned long))
 #define TOTAL_SEGS(sbi)	(SM_I(sbi)->main_segments)
 #define TOTAL_SECS(sbi)	(sbi->total_sections)
+#define TOTAL_BLKS(sbi)	(SM_I(sbi)->segment_count << sbi->log_blocks_per_seg)
 
 #define SECTOR_FROM_BLOCK(sbi, blk_addr)				\
 	(((sector_t)blk_addr) << (sbi)->log_sectors_per_block)
@@ -553,7 +554,7 @@ static inline void check_seg_range(struct f2fs_sb_info *sbi, unsigned int segno)
 static inline void verify_block_addr(struct f2fs_sb_info *sbi, block_t blk_addr)
 {
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
-	block_t total_blks = sm_info->segment_count << sbi->log_blocks_per_seg;
+	block_t total_blks = TOTAL_BLKS(sbi);
 	block_t start_addr = sm_info->seg0_blkaddr;
 	block_t end_addr = start_addr + total_blks - 1;
 	BUG_ON(blk_addr < start_addr);
@@ -606,7 +607,7 @@ static inline void check_seg_range(struct f2fs_sb_info *sbi, unsigned int segno)
 static inline void verify_block_addr(struct f2fs_sb_info *sbi, block_t blk_addr)
 {
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
-	block_t total_blks = sm_info->segment_count << sbi->log_blocks_per_seg;
+	block_t total_blks = TOTAL_BLKS(sbi);
 	block_t start_addr = sm_info->seg0_blkaddr;
 	block_t end_addr = start_addr + total_blks - 1;
 
