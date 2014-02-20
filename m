Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaBTIzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:55:08 -0500
Received: from [115.239.196.105] ([115.239.196.105]:46951 "EHLO mail.ucloud.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbaBTIzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:55:05 -0500
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Feb 2014 03:55:05 EST
From: Minfei Huang <huangminfei@ucloud.cn>
To: linux-kernel@vger.kernel.org
Cc: Minfei Huang <huangminfei@ucloud.cn>, Joern Engel <joern@logfs.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] btree: Fix the bug to release whole btree nodes
Date: Thu, 20 Feb 2014 16:45:03 +0800
Message-Id: <1392885903-2831-1-git-send-email-huangminfei@ucloud.cn>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use the btree which pickes up the latest version of kernel source
3.14-rc2 in my own module. When the btree module is removed, a warning arised:

kmem_cache_destroy btree_node: Slab cache still has objects
CPU: 13 PID: 9150 Comm: rmmod Tainted: GF          O 3.14.0-rc2 #1
Hardware name: Inspur NF5270M3/NF5270M3, BIOS CHEETAH_2.1.3 09/10/2013
ffff881ff8643b18 ffff881ffdc23ea8 ffffffff815a4ecc 0000000000000000
ffff881ff8643ac0 ffff881ffdc23ec8 ffffffff811610df 0000000000000880
ffffffffa057da60 ffff881ffdc23ed8 ffffffffa057d57c ffff881ffdc23f78
Call Trace:
[<ffffffff815a4ecc>] dump_stack+0x49/0x5d
[<ffffffff811610df>] kmem_cache_destroy+0xcf/0xe0
[<ffffffffa057d57c>] btree_module_exit+0x10/0x12 [btree]
[<ffffffff810d7948>] SyS_delete_module+0x198/0x1f0
[<ffffffff815aac89>] ? retint_swapgs+0xe/0x13
[<ffffffff810a561d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[<ffffffff812addde>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[<ffffffff815b3652>] system_call_fastpath+0x16/0x1b

The cause is that it doesn't release the last btree node,
when height = 1 and fill = 1.

Signed-off-by: Minfei Huang <huangminfei@ucloud.cn>
CC: Joern Engel <joern@logfs.org>
CC: Johannes Berg <johannes@sipsolutions.net>
---
 lib/btree.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/lib/btree.c b/lib/btree.c
index f9a4846..fd17d26 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -444,6 +444,16 @@ static void btree_shrink(struct btree_head *head, struct btree_geo *geo)
 	mempool_free(node, head->mempool);
 }
 
+static void btree_shrink_head(struct btree_head *head)
+{
+	if (head->height != 1)
+		return;
+
+	mempool_free(head->node, head->mempool);
+	head->node = NULL;
+	head->height--;
+}
+
 static int btree_insert_level(struct btree_head *head, struct btree_geo *geo,
 			      unsigned long *key, void *val, int level,
 			      gfp_t gfp)
@@ -620,6 +630,8 @@ static void *btree_remove_level(struct btree_head *head, struct btree_geo *geo,
 			rebalance(head, geo, key, level, node, fill - 1);
 		else if (fill - 1 == 1)
 			btree_shrink(head, geo);
+		else if (fill - 1 == 0)
+			btree_shrink_head(head);
 	}
 
 	return ret;
-- 
1.7.1

