Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbbAFIlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:41:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:36790 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbbAFIln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:41:43 -0500
X-AuditID: cbfee61a-f79c06d000004e71-d6-54ab9fc06ad9
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: fix wrong memory footprint statistics in
 debugfs
Date: Tue, 06 Jan 2015 16:40:49 +0800
Message-id: <009c01d0298c$946435e0$bd2ca1a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdApjEmcdKFDe7euSRC3JkEhNpbnqg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd0D81eHGOyapmFxbV8jk8WT9bOY
	LS4tcre4vGsOmwOLx6ZVnWweuxd8ZvLo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujI+NX5gK
	PnNXnD/dzdbA+Jmzi5GTQ0LAROL7v9OMELaYxIV769m6GLk4hAQWMUr0zb3BAuH8YJTYv34p
	M0gVm4CKxPKO/0wgtoiAl8Sk/SdYQGxmAQ+Jxo7vrCC2sECwxK9v29lAbBYBVYn1Pf/AenkF
	LCV+3NvLAmELSvyYfA+qV0ti/c7jTBC2vMTmNW+ZIS5SkNhx9jUjxC49if9zetkgasQlNh65
	xTKBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEB/UzqR2M
	KxssDjEKcDAq8fB6dK0OEWJNLCuuzD3EKMHBrCTCu2M6UIg3JbGyKrUoP76oNCe1+BCjNAeL
	kjivkn1biJBAemJJanZqakFqEUyWiYNTqoFR+1JC3T4LpTXvnJP6pCdLPvz96om2Ud+b1I4L
	S79PkZU5OWP/8Yh4xql7E7bymmimOR/ftLqMwfyEVJTghHnXi3nvNypU6r/Iddu+tbNjzV6r
	u7OXp3kLn3PlzAzb7+xb/ER+45m6rbt83A0W7zppE7iuPe2ajn6K2P0Jl9eUzgtZIOe35ECB
	EktxRqKhFnNRcSIATA6K8GYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our value of memory footprint statistics showed in debugfs is not calculated
correctly. Fix it in this patch.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/debug.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index dd7835b..6aeaf46 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -125,7 +125,7 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 	int i;
 
 	if (si->base_mem)
-		goto get_cache;
+		goto get_dynamic_cache;
 
 	si->base_mem = sizeof(struct f2fs_sb_info) + sbi->sb->s_blocksize;
 	si->base_mem += 2 * sizeof(struct f2fs_inode_info);
@@ -161,13 +161,18 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 	si->base_mem += sizeof(struct f2fs_nm_info);
 	si->base_mem += __bitmap_size(sbi, NAT_BITMAP);
 
+get_dynamic_cache:
 	/* build gc */
-	si->base_mem += sizeof(struct f2fs_gc_kthread);
+	if (sbi->gc_thread)
+		si->base_mem += sizeof(struct f2fs_gc_kthread);
+
+	/* build merge flush thread */
+	if (SM_I(sbi)->cmd_control_info)
+		si->base_mem += sizeof(struct flush_cmd_control);
 
-get_cache:
 	/* free nids */
-	si->cache_mem = NM_I(sbi)->fcnt;
-	si->cache_mem += NM_I(sbi)->nat_cnt;
+	si->cache_mem = NM_I(sbi)->fcnt * sizeof(struct free_nid);
+	si->cache_mem += NM_I(sbi)->nat_cnt * sizeof(struct nat_entry);
 	npages = NODE_MAPPING(sbi)->nrpages;
 	si->cache_mem += npages << PAGE_CACHE_SHIFT;
 	npages = META_MAPPING(sbi)->nrpages;
-- 
2.2.1


