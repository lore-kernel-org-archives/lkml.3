Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3GID7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 23:59:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28649 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3GID7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 23:59:08 -0400
X-IronPort-AV: E=Sophos;i="4.87,1025,1363104000"; 
   d="scan'208";a="7827171"
Message-ID: <51DB89C0.6070003@cn.fujitsu.com>
Date: Tue, 09 Jul 2013 11:55:44 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] f2fs: Modify do_garbage_collect() to collect all the segs
 in once
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/09 11:57:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/09 11:57:27,
	Serialize complete at 2013/07/09 11:57:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current do_garbage_collect() collect per segment per time. If there are more
than one segments in section, we need to call do_garbage_collect() many times to
collect all the segments(current is a for loop). We can move the loop into the
do_garbage_collect(), so that we can collect all the segs of section in one time.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/gc.c |   59 ++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 35f9b1a..ccde9f7 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -634,42 +634,50 @@ static int __get_victim(struct f2fs_sb_info *sbi, unsigned
int *victim,
 	return ret;
 }

-static void do_garbage_collect(struct f2fs_sb_info *sbi, unsigned int segno,
-				struct list_head *ilist, int gc_type)
+static void do_garbage_collect(struct f2fs_sb_info *sbi,
+		unsigned int start_segno, struct list_head *ilist, int gc_type)
 {
-	struct page *sum_page;
-	struct f2fs_summary_block *sum;
-	struct blk_plug plug;
+	unsigned int segno = start_segno;

-	/* read segment summary of victim */
-	sum_page = get_sum_page(sbi, segno);
-	if (IS_ERR(sum_page))
-		return;
+	for (; sbi->segs_per_sec--; segno++) {
+		struct page *sum_page;
+		struct f2fs_summary_block *sum;
+		struct blk_plug plug;

-	blk_start_plug(&plug);
+		/* read segment summary of victim */
+		sum_page = get_sum_page(sbi, segno);
+		if (IS_ERR(sum_page))
+			continue;

-	sum = page_address(sum_page);
+		blk_start_plug(&plug);

-	switch (GET_SUM_TYPE((&sum->footer))) {
-	case SUM_TYPE_NODE:
-		gc_node_segment(sbi, sum->entries, segno, gc_type);
-		break;
-	case SUM_TYPE_DATA:
-		gc_data_segment(sbi, sum->entries, ilist, segno, gc_type);
-		break;
-	}
-	blk_finish_plug(&plug);
+		sum = page_address(sum_page);

-	stat_inc_seg_count(sbi, GET_SUM_TYPE((&sum->footer)));
-	stat_inc_call_count(sbi->stat_info);
+		switch (GET_SUM_TYPE((&sum->footer))) {
+		case SUM_TYPE_NODE:
+			gc_node_segment(sbi, sum->entries,
+				segno, gc_type);
+			break;
+		case SUM_TYPE_DATA:
+			gc_data_segment(sbi, sum->entries, ilist,
+				segno, gc_type);
+			break;
+		default:
+			BUG();
+		}
+		blk_finish_plug(&plug);
+
+		stat_inc_seg_count(sbi, GET_SUM_TYPE((&sum->footer)));
+		stat_inc_call_count(sbi->stat_info);

-	f2fs_put_page(sum_page, 1);
+		f2fs_put_page(sum_page, 1);
+	}
 }

 int f2fs_gc(struct f2fs_sb_info *sbi)
 {
 	struct list_head ilist;
-	unsigned int segno, i;
+	unsigned int segno;
 	int gc_type = BG_GC;
 	int nfree = 0;
 	int ret = -1;
@@ -688,8 +696,7 @@ gc_more:
 		goto stop;
 	ret = 0;

-	for (i = 0; i < sbi->segs_per_sec; i++)
-		do_garbage_collect(sbi, segno + i, &ilist, gc_type);
+	do_garbage_collect(sbi, segno, &ilist, gc_type);

 	if (gc_type == FG_GC) {
 		sbi->cur_victim_sec = NULL_SEGNO;
-- 
1.7.7

