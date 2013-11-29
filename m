Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3K2Ih6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:37:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:33616 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3K2Ihx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:37:53 -0500
X-AuditID: cbfee61b-b7f166d000007a34-41-5298526059aa
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: avoid to calculate incorrect max orphan number
Date: Fri, 29 Nov 2013 16:37:00 +0800
Message-id: <004701ceecde$49c7f8a0$dd57e9e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7s3XJHCifhHASITfmulxQ2qWBTdg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd2EoBlBBr82i1hc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxqO+f8wF
	Tzgrln/8yNrA+I29i5GTQ0LAROL6hDUsELaYxIV769m6GLk4hAQWMUpMmHoerEhI4AejxMbv
	iSA2m4CKxPKO/0wgtoiAosSG9xvYQRqYBWYwShye+48VJCEsECCxYdo1MJtFQFXiw4cpjCA2
	r4ClxJodx1ggbEGJH5PvgdnMAhoS/Ys2sEHY8hKb17xlhrhIQWLH2deMEMv0JC5NOgZVLy6x
	8cgtlgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4qJ9J
	72Bc1WBxiFGAg1GJh3dF9/QgIdbEsuLK3EOMEhzMSiK8v4qAQrwpiZVVqUX58UWlOanFhxil
	OViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhiDwjykPu8/c+JKVXfirgpWF9PVNzc2urhe
	LUvsOFTPLLNUMHBmUrfBBb7o8HX/2KYy+CnPF/6xe5HfrzylfZMXBhfo64Y/j2/epbrbxJEn
	bnUK737p+9FZtWvj/rK8cZY6yZRa8vaxMJPInKXPpbc1bZsq8mrdofeWv+8IT3udJLSrp3Dj
	oc1KLMUZiYZazEXFiQABOFLHZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because we will write node summaries when do_checkpoint with umount flag,
our number of max orphan blocks should minus NR_CURSEG_NODE_TYPE additional.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Shu Tan <shu.tan@samsung.com>
---
 fs/f2fs/checkpoint.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index b28e61b..32178f3 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -190,12 +190,13 @@ int acquire_orphan_inode(struct f2fs_sb_info *sbi)
 	int err = 0;
 
 	/*
-	 * considering 512 blocks in a segment 5 blocks are needed for cp
+	 * considering 512 blocks in a segment 8 blocks are needed for cp
 	 * and log segment summaries. Remaining blocks are used to keep
 	 * orphan entries with the limitation one reserved segment
-	 * for cp pack we can have max 1020*507 orphan entries
+	 * for cp pack we can have max 1020*504 orphan entries
 	 */
-	max_orphans = (sbi->blocks_per_seg - 5) * F2FS_ORPHANS_PER_BLOCK;
+	max_orphans = (sbi->blocks_per_seg - 2 - NR_CURSEG_TYPE)
+				* F2FS_ORPHANS_PER_BLOCK;
 	mutex_lock(&sbi->orphan_inode_mutex);
 	if (sbi->n_orphans >= max_orphans)
 		err = -ENOSPC;
-- 
1.7.9.5

