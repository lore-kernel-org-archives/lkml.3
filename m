Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3LTKZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:25:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27769 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab3LTKZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:25:11 -0500
X-IronPort-AV: E=Sophos;i="4.95,519,1384272000"; 
   d="scan'208";a="9297873"
Message-ID: <52B4194D.1010300@cn.fujitsu.com>
Date: Fri, 20 Dec 2013 18:17:49 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [f2fs-dev][PATCH] f2fs: remove the rw_flag domain from f2fs_io_info
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 18:24:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 18:24:27,
	Serialize complete at 2013/12/20 18:24:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the f2fs_io_info in the low level, we still need to merge the
rw and rw_flag, so use the rw to hold all the io flags directly,
and remove the rw_flag field.

ps.It is based on the previous patch:
f2fs: move all the bio initialization into __bio_alloc

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/data.c    |    3 +--
 fs/f2fs/f2fs.h    |    5 ++---
 fs/f2fs/gc.c      |    1 -
 fs/f2fs/node.c    |    6 ++----
 fs/f2fs/segment.c |    8 ++------
 5 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 94fa651..439ed6c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -105,7 +105,7 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 	if (!io->bio)
 		return;
 
-	rw = fio->rw | fio->rw_flag;
+	rw = fio->rw;
 
 	if (is_read_io(rw)) {
 		trace_f2fs_submit_read_bio(io->sbi->sb, rw,
@@ -755,7 +755,6 @@ static int f2fs_write_data_page(struct page *page,
 	struct f2fs_io_info fio = {
 		.type = DATA,
 		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC: WRITE,
-		.rw_flag = 0,
 	};
 
 	if (page->index < end_index)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8cbc5a6..d03d2ab 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -368,9 +368,8 @@ enum page_type {
 };
 
 struct f2fs_io_info {
-	enum page_type type;		/* contains DATA/NODE/META/META_FLUSH */
-	int rw;				/* contains R/RS/W/WS */
-	int rw_flag;			/* contains REQ_META/REQ_PRIO */
+	enum page_type type;	/* contains DATA/NODE/META/META_FLUSH */
+	int rw;			/* contains R/RS/W/WS with REQ_META/REQ_PRIO */
 };
 
 #define is_read_io(rw)	(((rw) & 1) == READ)
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 69c18e3..599f546 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -523,7 +523,6 @@ static void move_data_page(struct inode *inode, struct page *page, int gc_type)
 	struct f2fs_io_info fio = {
 		.type = DATA,
 		.rw = WRITE_SYNC,
-		.rw_flag = 0,
 	};
 
 	if (gc_type == BG_GC) {
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 3565caf..0af0a71 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -94,8 +94,7 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
 	int i;
 	struct f2fs_io_info fio = {
 		.type = META,
-		.rw = READ_SYNC,
-		.rw_flag = REQ_META | REQ_PRIO
+		.rw = READ_SYNC | REQ_META | REQ_PRIO
 	};
 
 
@@ -1581,8 +1580,7 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
 	int page_idx = start;
 	struct f2fs_io_info fio = {
 		.type = META,
-		.rw = READ_SYNC,
-		.rw_flag = REQ_META | REQ_PRIO
+		.rw = READ_SYNC | REQ_META | REQ_PRIO
 	};
 
 	for (; page_idx < start + nrpages; page_idx++) {
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 9f8bdd0..555ae76 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -916,8 +916,7 @@ void write_meta_page(struct f2fs_sb_info *sbi, struct page *page)
 {
 	struct f2fs_io_info fio = {
 		.type = META,
-		.rw = WRITE_SYNC,
-		.rw_flag = REQ_META | REQ_PRIO
+		.rw = WRITE_SYNC | REQ_META | REQ_PRIO
 	};
 
 	set_page_writeback(page);
@@ -931,7 +930,6 @@ void write_node_page(struct f2fs_sb_info *sbi, struct page *page,
 	struct f2fs_io_info fio = {
 		.type = NODE,
 		.rw = WRITE_SYNC,
-		.rw_flag = 0
 	};
 
 	set_summary(&sum, nid, 0, 0);
@@ -1018,7 +1016,6 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
 	struct f2fs_io_info fio = {
 		.type = NODE,
 		.rw = WRITE_SYNC,
-		.rw_flag = 0
 	};
 
 	curseg = CURSEG_I(sbi, type);
@@ -1598,8 +1595,7 @@ static int ra_sit_pages(struct f2fs_sb_info *sbi, int start, int nrpages)
 	int blkno = start;
 	struct f2fs_io_info fio = {
 		.type = META,
-		.rw = READ_SYNC,
-		.rw_flag = REQ_META | REQ_PRIO
+		.rw = READ_SYNC | REQ_META | REQ_PRIO
 	};
 
 	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
-- 
1.7.7

