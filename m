Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaFLFYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 01:24:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38162 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaFLFYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 01:24:44 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-23-5399399a5d07
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/3] f2fs: check lower bound nid value in
 check_nid_range
Date: Thu, 12 Jun 2014 13:23:41 +0800
Message-id: <000001cf85fe$9e63ed10$db2bc730$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+F/YnOIjLCwnUhQqGQS6pFCQ1B0g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd3ZljODDVY3slo8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlXH0UD9zwV3eihe3
	1rA1MM7h7mLk5JAQMJH4MGU+C4QtJnHh3nq2LkYuDiGBRYwSCyauYAVJCAn8YJR4dNwQxGYT
	UJFY3vGfCcQWAbIPLbrMDmIzC2RK3GuawQxiCwuESlz5eAqshkVAVeLU+dOMIDavgKXEopaN
	bBC2oMSPyfdYIHq1JNbvPM4EYctLbF7zlhniIAWJHWdfM0Ls0pO4taEVape4xMYjt1gmMArM
	QjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4EB+Jr2DcVWDxSFG
	AQ5GJR5ehtoZwUKsiWXFlbmHGCU4mJVEeB3PA4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1
	DhQSSE8sSc1OTS1ILYLJMnFwSjUwivHdaHx/O23TnshwrtM+mqr7Xa4E36n6OTn2w00Di+3b
	dxgpuxVPrznzIUB5t657fnic8GuunaFO64vSnfeceMnXNWnrzKVJrPP1Vl52S5zeUmXJc0PI
	y/75lo9SGxPOrDRUczt7iC/5tZVHg1bzlp53s0RmLLnvHVhS3JEpHXdL/u+cZTfmK7EUZyQa
	ajEXFScCAEJ013tgAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add lower bound verification for nid in check_nid_range, so nids
reserved like 0, node, meta passed by caller could be checked there.

And then check_nid_range could be used in f2fs_nfs_get_inode for simplifying
code.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h  |    3 ++-
 fs/f2fs/inode.c |    1 +
 fs/f2fs/super.c |    4 +---
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 7ef7acd..58df97e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -641,7 +641,8 @@ static inline void f2fs_unlock_all(struct f2fs_sb_info *sbi)
  */
 static inline int check_nid_range(struct f2fs_sb_info *sbi, nid_t nid)
 {
-	WARN_ON((nid >= NM_I(sbi)->max_nid));
+	if (unlikely(nid < F2FS_ROOT_INO(sbi)))
+		return -EINVAL;
 	if (unlikely(nid >= NM_I(sbi)->max_nid))
 		return -EINVAL;
 	return 0;
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index adc622c..2cf6962 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -78,6 +78,7 @@ static int do_read_inode(struct inode *inode)
 	if (check_nid_range(sbi, inode->i_ino)) {
 		f2fs_msg(inode->i_sb, KERN_ERR, "bad inode number: %lu",
 			 (unsigned long) inode->i_ino);
+		WARN_ON(1);
 		return -EINVAL;
 	}
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index b2b1863..8f96d93 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -689,9 +689,7 @@ static struct inode *f2fs_nfs_get_inode(struct super_block *sb,
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	struct inode *inode;
 
-	if (unlikely(ino < F2FS_ROOT_INO(sbi)))
-		return ERR_PTR(-ESTALE);
-	if (unlikely(ino >= NM_I(sbi)->max_nid))
+	if (check_nid_range(sbi, ino))
 		return ERR_PTR(-ESTALE);
 
 	/*
-- 
1.7.9.5


