Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaCVG6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 02:58:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36903 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaCVG6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 02:58:39 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-94-532d349dcedf
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH 1/2] f2fs: avoid unnecessary bio submit when wait
 page writeback
Date: Sat, 22 Mar 2014 14:57:23 +0800
Message-id: <000c01cf459c$25f2af30$71d80d90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9FkMPAHTm9uT0sSPWJbYkSu2XSnA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd25JrrBBs/3aVtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbFrkmBBk1zFrIWH
	2BsYD0t0MXJySAiYSMz4MokdwhaTuHBvPVsXIxeHkMAiRom9uzawQDg/GCUWtS9lA6liE1CR
	WN7xnwnEFhFQlNjwfgNYN7NApsS9phnMILawQKzE77ezGEFsFgFVia/NnUCDODh4BSwl5m0t
	BwnzCghK/Jh8jwWiVUti/c7jTBC2vMTmNW+ZIQ5SkNhx9jUjxCo9iXVPPrNC1IhLbDxyi2UC
	o8AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDuNnUjsYVzZY
	HGIU4GBU4uG9Ia8bLMSaWFZcmXuIUYKDWUmE94QCUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjv
	gVbrQCGB9MSS1OzU1ILUIpgsEwenVANjJYvmnQsfp7kuKLns6HlQp/lKz0/+/K33jgZuefZn
	schz+7CTsovvma+3lf2pfUJWPPeDwO/SRxMmWHVfTfcqCP9QuHbnpyNceqpfnwbosjbYr5aW
	uvRP/SfPexOBzR1HZj26+S6OO5TPI/n649ePm5Z1X27/Yp8R5iVZd8Hg9h55j2keHgl7lViK
	MxINtZiLihMBrBa04l8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce is_merged_page() to check whether current page is merged
in f2fs bio cache. When page is not in cache, we can avoid submitting bio cache,
resulting in having more chance to merge pages.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c    |    8 ++++----
 fs/f2fs/f2fs.h    |    2 +-
 fs/f2fs/segment.c |   28 +++++++++++++++++++++++++++-
 fs/f2fs/super.c   |    4 ++--
 4 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b0c923a..598bfa6 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -134,7 +134,7 @@ void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
 
 	io = is_read_io(rw) ? &sbi->read_io : &sbi->write_io[btype];
 
-	mutex_lock(&io->io_mutex);
+	down_write(&io->io_rwsem);
 
 	/* change META to META_FLUSH in the checkpoint procedure */
 	if (type >= META_FLUSH) {
@@ -142,7 +142,7 @@ void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
 		io->fio.rw = WRITE_FLUSH_FUA | REQ_META | REQ_PRIO;
 	}
 	__submit_merged_bio(io);
-	mutex_unlock(&io->io_mutex);
+	up_write(&io->io_rwsem);
 }
 
 /*
@@ -180,7 +180,7 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
 
 	verify_block_addr(sbi, blk_addr);
 
-	mutex_lock(&io->io_mutex);
+	down_write(&io->io_rwsem);
 
 	if (!is_read)
 		inc_page_count(sbi, F2FS_WRITEBACK);
@@ -204,7 +204,7 @@ alloc_new:
 
 	io->last_block_in_bio = blk_addr;
 
-	mutex_unlock(&io->io_mutex);
+	up_write(&io->io_rwsem);
 	trace_f2fs_submit_page_mbio(page, fio->rw, fio->type, blk_addr);
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f83433e..1e3d869 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -394,7 +394,7 @@ struct f2fs_bio_info {
 	struct bio *bio;		/* bios to merge */
 	sector_t last_block_in_bio;	/* last block number */
 	struct f2fs_io_info fio;	/* store buffered io info. */
-	struct mutex io_mutex;		/* mutex for bio */
+	struct rw_semaphore io_rwsem;	/* blocking op for bio */
 };
 
 struct f2fs_sb_info {
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index e7ff23a..570ab9a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1046,12 +1046,38 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 	mutex_unlock(&curseg->curseg_mutex);
 }
 
+static inline bool is_merged_page(struct f2fs_sb_info *sbi,
+					struct page *page, enum page_type type)
+{
+	enum page_type btype = PAGE_TYPE_OF_BIO(type);
+	struct f2fs_bio_info *io = &sbi->write_io[btype];
+	struct bio *bio = io->bio;
+	struct bio_vec *bvec;
+	int i;
+
+	down_read(&io->io_rwsem);
+	if (!bio)
+		goto out;
+
+	bio_for_each_segment_all(bvec, bio, i) {
+		if (page == bvec->bv_page) {
+			up_read(&io->io_rwsem);
+			return true;
+		}
+	}
+
+out:
+	up_read(&io->io_rwsem);
+	return false;
+}
+
 void f2fs_wait_on_page_writeback(struct page *page,
 				enum page_type type)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
 	if (PageWriteback(page)) {
-		f2fs_submit_merged_bio(sbi, type, WRITE);
+		if (is_merged_page(sbi, page, type))
+			f2fs_submit_merged_bio(sbi, type, WRITE);
 		wait_on_page_writeback(page);
 	}
 }
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 89ea046..9598340 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -920,11 +920,11 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->por_doing = false;
 	spin_lock_init(&sbi->stat_lock);
 
-	mutex_init(&sbi->read_io.io_mutex);
+	init_rwsem(&sbi->read_io.io_rwsem);
 	sbi->read_io.sbi = sbi;
 	sbi->read_io.bio = NULL;
 	for (i = 0; i < NR_PAGE_TYPE; i++) {
-		mutex_init(&sbi->write_io[i].io_mutex);
+		init_rwsem(&sbi->write_io[i].io_rwsem);
 		sbi->write_io[i].sbi = sbi;
 		sbi->write_io[i].bio = NULL;
 	}
-- 
1.7.9.5


