Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaEHJB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:01:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25172 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaEHJBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:01:24 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-7d-536b47e32ace
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: avoid to use slab memory in f2fs_issue_flush
 for efficiency
Date: Thu, 08 May 2014 17:00:35 +0800
Message-id: <000101cf6a9c$14428560$3cc79020$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9qe97Nup9G46BRTu2CsBoJB0WHxg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd3H7tnBBpOes1tc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldH/YCZjwQ/Bir+f
	fzA2MH7i62Lk5JAQMJG4/fIpG4QtJnHh3nogm4tDSGARo8SKn3fAEkICPxglTpwJAbHZBFQk
	lnf8ZwKxRQQ0JR4v38wMYjMLZErca5oBZgsLxEmc7vvLDmKzCKhKXN/cA2bzClhKTO97yAxh
	C0r8mHyPBaJXS2L9zuNMELa8xOY1b5khDlKQ2HH2NSPELj2J28ua2SBqxCU2HrnFMoFRYBaS
	UbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQH8jOpHYwrGywOMQpw
	MCrx8GY4ZwULsSaWFVfmHmKU4GBWEuFNc8wOFuJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6
	UEggPbEkNTs1tSC1CCbLxMEp1cAYl7lGRPa+Z/gT2cnSPa+NFxUvTSydIdswWfKvndGXqVy6
	3DHCAqtKNRdFfhPxXW7uwHdaYULFw/StvpecquYmrfI/2qXYuvpG5f/wI0+e5kzyDcko5OZf
	4XUy70Nk8LGI3eL3HnS4F659LegqfOdk+/1T3gKTDcL45OtOyehZ/V0lprzOSVOJpTgj0VCL
	uag4EQDeWh3fYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we use slab memory in f2fs_issue_flush(), we will face memory pressure and
latency time caused by racing of kmem_cache_{alloc,free}.

Let's alloc memory in stack instead of slab.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/segment.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 2ecbffb..f25f0e0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -25,7 +25,6 @@
 #define __reverse_ffz(x) __reverse_ffs(~(x))
 
 static struct kmem_cache *discard_entry_slab;
-static struct kmem_cache *flush_cmd_slab;
 
 /*
  * __reverse_ffs is copied from include/asm-generic/bitops/__ffs.h since
@@ -238,30 +237,28 @@ repeat:
 int f2fs_issue_flush(struct f2fs_sb_info *sbi)
 {
 	struct flush_cmd_control *fcc = SM_I(sbi)->cmd_control_info;
-	struct flush_cmd *cmd;
-	int ret;
+	struct flush_cmd cmd;
 
 	if (!test_opt(sbi, FLUSH_MERGE))
 		return blkdev_issue_flush(sbi->sb->s_bdev, GFP_KERNEL, NULL);
 
-	cmd = f2fs_kmem_cache_alloc(flush_cmd_slab, GFP_ATOMIC | __GFP_ZERO);
-	init_completion(&cmd->wait);
+	init_completion(&cmd.wait);
+	cmd.next = NULL;
 
 	spin_lock(&fcc->issue_lock);
 	if (fcc->issue_list)
-		fcc->issue_tail->next = cmd;
+		fcc->issue_tail->next = &cmd;
 	else
-		fcc->issue_list = cmd;
-	fcc->issue_tail = cmd;
+		fcc->issue_list = &cmd;
+	fcc->issue_tail = &cmd;
 	spin_unlock(&fcc->issue_lock);
 
 	if (!fcc->dispatch_list)
 		wake_up(&fcc->flush_wait_queue);
 
-	wait_for_completion(&cmd->wait);
-	ret = cmd->ret;
-	kmem_cache_free(flush_cmd_slab, cmd);
-	return ret;
+	wait_for_completion(&cmd.wait);
+
+	return cmd.ret;
 }
 
 int create_flush_cmd_control(struct f2fs_sb_info *sbi)
@@ -2036,17 +2033,10 @@ int __init create_segment_manager_caches(void)
 			sizeof(struct discard_entry));
 	if (!discard_entry_slab)
 		return -ENOMEM;
-	flush_cmd_slab = f2fs_kmem_cache_create("flush_command",
-			sizeof(struct flush_cmd));
-	if (!flush_cmd_slab) {
-		kmem_cache_destroy(discard_entry_slab);
-		return -ENOMEM;
-	}
 	return 0;
 }
 
 void destroy_segment_manager_caches(void)
 {
 	kmem_cache_destroy(discard_entry_slab);
-	kmem_cache_destroy(flush_cmd_slab);
 }
-- 
1.7.10.4


