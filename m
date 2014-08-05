Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaHESSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:18:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbaHESQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:16:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Minfei Huang <huangminfei@ucloud.cn>, Joern Engel <joern@logfs.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 26/27] lib/btree.c: fix leak of whole btree nodes
Date: Tue,  5 Aug 2014 11:14:18 -0700
Message-Id: <20140805181345.038208785@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181344.268039690@linuxfoundation.org>
References: <20140805181344.268039690@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/btree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/btree.c
+++ b/lib/btree.c
@@ -198,6 +198,7 @@ EXPORT_SYMBOL_GPL(btree_init);
 
 void btree_destroy(struct btree_head *head)
 {
+	mempool_free(head->node, head->mempool);
 	mempool_destroy(head->mempool);
 	head->mempool = NULL;
 }


