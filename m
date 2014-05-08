Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaEHEhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 00:37:24 -0400
Received: from m97135.qiye.163.com ([220.181.97.135]:58290 "EHLO
	m97135.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaEHEhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 00:37:23 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2014 00:37:22 EDT
From: Minfei Huang <huangminfei@ucloud.cn>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, tj@kernel.org,
        davem@davemloft.net, dborkman@redhat.com
Cc: linux-kernel@vger.kernel.org, Minfei Huang <huangminfei@ucloud.cn>,
        Joern Engel <joern@logfs.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] btree: Fix the bug to release whole btree nodes
Date: Thu,  8 May 2014 12:21:12 +0800
Message-Id: <1399522872-7589-1-git-send-email-huangminfei@ucloud.cn>
X-Mailer: git-send-email 1.7.9.5
X-CM-TRANSID: h+CowED5clhFBmtThw6bAA--.960S3
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU8hL0UUUUU
X-CM-SenderInfo: xkxd0wxplqwvnl6xuzxrxghubq/1tbiFAWFQVIUz1Y72QAAso
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
 lib/btree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/btree.c b/lib/btree.c
index f9a4846..725bf8b 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -198,6 +198,8 @@ EXPORT_SYMBOL_GPL(btree_init);
 
 void btree_destroy(struct btree_head *head)
 {
+	if (head->node)
+		mempool_free(head->node, head->mempool);
 	mempool_destroy(head->mempool);
 	head->mempool = NULL;
 }
-- 
1.7.1


