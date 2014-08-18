Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaHRJgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:36:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43082 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbaHRJgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Minfei Huang <huangminfei@ucloud.cn>, Joern Engel <joern@logfs.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 114/137] lib/btree.c: fix leak of whole btree nodes
Date: Mon, 18 Aug 2014 10:32:55 +0100
Message-Id: <1408354398-10226-115-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minfei Huang <huangminfei@ucloud.cn>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

