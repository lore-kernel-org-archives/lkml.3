Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab3DAG5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:57:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62386 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab3DAG5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:57:03 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-a6-51592fb994ea
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 8/9] f2fs: avoid race for summary information
Date: Mon, 01 Apr 2013 15:55:59 +0900
Message-id: <1364799360-23145-8-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zfd2d+pGBBr8faFhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXHn6RfmggsCFccb
	XrE2MB7m7WLk5JAQMJE4cGk9G4QtJnHhHojNxSEksIxR4t3dvUwwRQ2nzkAlFjFKfH/YxALh
	tDFJrLhwn72LkYODTUBbYvN+A5AGEQFmiQVTzzOC1DALTGCU+L/oPQtIQljAVqLl9k2wdSwC
	qhJ/2puYQWxeAXeJjb0boLbpSqz+/5wdxOYU8JD43PYRrFcIqObUvtVgV0gIfGeTWN3RyQ4x
	SEDi2+RDLCBHSAjISmw6wAwxR1Li4IobLBMYhRcwMqxiFE0tSC4oTkovMtYrTswtLs1L10vO
	z93ECAna/h2Mdw9YH2JMBho3kVlKNDkfGPR5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmk
	J5akZqemFqQWxReV5qQWH2Jk4uCUamC0OnDPfT2zpvTJ+EilpsiH3kt2sU6tbPe3Uak7s79C
	wsPs3c3jTk/uMm7/sm/DjRc7FvbHtmsFbX/UwDYz9oaUfkH1xBLGWVO10r6GmjHPTXq28mas
	2U1XX5uyj7dEpA/9mPOU41bAP0XWCx+bpiet31D4dHn2xz9f6i/09V6dOL936oVzhS9WKLEU
	ZyQaajEXFScCAF6RCUdwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd2d+pGBBg8PqVhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx5+kX5oILAhXHG16xNjAe5u1i5OSQEDCRaDh1hg3CFpO4cG89kM3FISSw
	iFHi+8MmFginjUlixYX77F2MHBxsAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvWUASwgK2
	Ei23b4JNZRFQlfjT3sQMYvMKuEts7N3ABLFNV2L1/+fsIDangIfE57aPYL1CQDWn9q1mm8DI
	u4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcEw8k97BuKrB4hCjAAejEg9vxIWIQCHW
	xLLiytxDjBIczEoivD7fgEK8KYmVValF+fFFpTmpxYcYk4GumsgsJZqcD4zXvJJ4Q2MTMyNL
	IzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgnHkx/0nfa69tW/QSyqYekl6r
	Kxjc/TGoov1GxOwpPuF1zxMevvw16/xepcAdNdv2zVme0s/zaFPx3Ehx600mar/SU3IYc7b3
	vejsVznIJ1L7tuUi4+R1pYvrvkfab17Z9aA9o7r7yQmnuBnrFB8Jz80T4kjq0mL6/vLkk/hT
	vZs3z2HK6giSUmIpzkg01GIuKk4EALoMzK7NAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to do GC more reliably, I'd like to lock the vicitm summary page
until its GC is completed, and also prevent any checkpoint process.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/gc.c    | 8 +-------
 fs/f2fs/node.c  | 2 +-
 fs/f2fs/super.c | 7 +++++--
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 54aceb2..54ac13d 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -641,12 +641,6 @@ static void do_garbage_collect(struct f2fs_sb_info *sbi, unsigned int segno,
 	if (IS_ERR(sum_page))
 		return;
 
-	/*
-	 * CP needs to lock sum_page. In this time, we don't need
-	 * to lock this page, because this summary page is not gone anywhere.
-	 * Also, this page is not gonna be updated before GC is done.
-	 */
-	unlock_page(sum_page);
 	sum = page_address(sum_page);
 
 	switch (GET_SUM_TYPE((&sum->footer))) {
@@ -660,7 +654,7 @@ static void do_garbage_collect(struct f2fs_sb_info *sbi, unsigned int segno,
 	stat_inc_seg_count(sbi, GET_SUM_TYPE((&sum->footer)));
 	stat_inc_call_count(sbi->stat_info);
 
-	f2fs_put_page(sum_page, 0);
+	f2fs_put_page(sum_page, 1);
 }
 
 int f2fs_gc(struct f2fs_sb_info *sbi)
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c5360b7..7555fb7 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1148,7 +1148,7 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 
 	/* First check balancing cached NAT entries */
 	if (try_to_free_nats(sbi, NAT_ENTRY_PER_BLOCK)) {
-		write_checkpoint(sbi, false);
+		f2fs_sync_fs(sbi->sb, true);
 		return 0;
 	}
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ea325c8..161e6c6 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -137,10 +137,13 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 	if (!sbi->s_dirty && !get_pages(sbi, F2FS_DIRTY_NODES))
 		return 0;
 
-	if (sync)
+	if (sync) {
+		mutex_lock(&sbi->gc_mutex);
 		write_checkpoint(sbi, false);
-	else
+		mutex_unlock(&sbi->gc_mutex);
+	} else {
 		f2fs_balance_fs(sbi);
+	}
 
 	return 0;
 }
-- 
1.8.1.3.566.gaa39828

