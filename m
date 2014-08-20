Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaHTLt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:49:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59048 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Minfei Huang <huangminfei@ucloud.cn>,
        Joern Engel <joern@logfs.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 030/104] lib/btree.c: fix leak of whole btree nodes
Date: Wed, 20 Aug 2014 13:42:53 +0200
Message-Id: <834ed96b54b04bfd07c7e0964d20ccc2da0c534d.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Minfei Huang <huangminfei@ucloud.cn>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c75b53af2f0043aff500af0a6f878497bef41bca upstream.

I use btree from 3.14-rc2 in my own module.  When the btree module is
removed, a warning arises:

 kmem_cache_destroy btree_node: Slab cache still has objects
 CPU: 13 PID: 9150 Comm: rmmod Tainted: GF          O 3.14.0-rc2 #1
 Hardware name: Inspur NF5270M3/NF5270M3, BIOS CHEETAH_2.1.3 09/10/2013
 Call Trace:
   dump_stack+0x49/0x5d
   kmem_cache_destroy+0xcf/0xe0
   btree_module_exit+0x10/0x12 [btree]
   SyS_delete_module+0x198/0x1f0
   system_call_fastpath+0x16/0x1b

The cause is that it doesn't release the last btree node, when height = 1
and fill = 1.

[akpm@linux-foundation.org: remove unneeded test of NULL]
Signed-off-by: Minfei Huang <huangminfei@ucloud.cn>
Cc: Joern Engel <joern@logfs.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 lib/btree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/btree.c b/lib/btree.c
index f9a484676cb6..4264871ea1a0 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -198,6 +198,7 @@ EXPORT_SYMBOL_GPL(btree_init);
 
 void btree_destroy(struct btree_head *head)
 {
+	mempool_free(head->node, head->mempool);
 	mempool_destroy(head->mempool);
 	head->mempool = NULL;
 }
-- 
2.0.4

