Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbaJaGQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 02:16:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:44078 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759317AbaJaGQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 02:16:15 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/4] f2fs: avoid race condition in handling wait_io
Date: Thu, 30 Oct 2014 23:16:14 -0700
Message-Id: <1414736176-13201-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414736176-13201-1-git-send-email-jaegeuk@kernel.org>
References: <1414736176-13201-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__submit_merged_bio    f2fs_write_end_io        f2fs_write_end_io
                       wait_io = X              wait_io = x
                       complete(X)              complete(X)
                       wait_io = NULL
wait_for_completion()
free(X)
                                                 spin_lock(X)
                                                 kernel panic

In order to avoid this, this patch removes the wait_io facility.
Instead, we can use wait_on_all_pages_writeback(sbi) to wait for end_ios.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c |  3 +++
 fs/f2fs/data.c       | 35 +++++++----------------------------
 fs/f2fs/f2fs.h       |  1 -
 3 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index ca514d5..dd6a357 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -978,6 +978,9 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	/* Here, we only have one bio having CP pack */
 	sync_meta_pages(sbi, META_FLUSH, LONG_MAX);
 
+	/* wait for previous submitted meta pages writeback */
+	wait_on_all_pages_writeback(sbi);
+
 	release_dirty_inode(sbi);
 
 	if (unlikely(f2fs_cp_error(sbi)))
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ceee1a6..8f16443 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -61,11 +61,6 @@ static void f2fs_write_end_io(struct bio *bio, int err)
 		dec_page_count(sbi, F2FS_WRITEBACK);
 	}
 
-	if (sbi->wait_io) {
-		complete(sbi->wait_io);
-		sbi->wait_io = NULL;
-	}
-
 	if (!get_pages(sbi, F2FS_WRITEBACK) &&
 			!list_empty(&sbi->cp_wait.task_list))
 		wake_up(&sbi->cp_wait);
@@ -95,34 +90,18 @@ static struct bio *__bio_alloc(struct f2fs_sb_info *sbi, block_t blk_addr,
 static void __submit_merged_bio(struct f2fs_bio_info *io)
 {
 	struct f2fs_io_info *fio = &io->fio;
-	int rw;
 
 	if (!io->bio)
 		return;
 
-	rw = fio->rw;
-
-	if (is_read_io(rw)) {
-		trace_f2fs_submit_read_bio(io->sbi->sb, rw,
-						fio->type, io->bio);
-		submit_bio(rw, io->bio);
-	} else {
-		trace_f2fs_submit_write_bio(io->sbi->sb, rw,
-						fio->type, io->bio);
-		/*
-		 * META_FLUSH is only from the checkpoint procedure, and we
-		 * should wait this metadata bio for FS consistency.
-		 */
-		if (fio->type == META_FLUSH) {
-			DECLARE_COMPLETION_ONSTACK(wait);
-			io->sbi->wait_io = &wait;
-			submit_bio(rw, io->bio);
-			wait_for_completion(&wait);
-		} else {
-			submit_bio(rw, io->bio);
-		}
-	}
+	if (is_read_io(fio->rw))
+		trace_f2fs_submit_read_bio(io->sbi->sb, fio->rw,
+							fio->type, io->bio);
+	else
+		trace_f2fs_submit_write_bio(io->sbi->sb, fio->rw,
+							fio->type, io->bio);
 
+	submit_bio(fio->rw, io->bio);
 	io->bio = NULL;
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index afe3022..5a97058 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -516,7 +516,6 @@ struct f2fs_sb_info {
 	/* for bio operations */
 	struct f2fs_bio_info read_io;			/* for read bios */
 	struct f2fs_bio_info write_io[NR_PAGE_TYPE];	/* for write bios */
-	struct completion *wait_io;		/* for completion bios */
 
 	/* for checkpoint */
 	struct f2fs_checkpoint *ckpt;		/* raw checkpoint pointer */
-- 
2.1.1

