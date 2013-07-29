Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3G2TT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:19:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50597 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3G2TTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:19:53 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 2/5] rbtree: add rbtree_postorder_for_each_entry_safe() helper
Date: Mon, 29 Jul 2013 12:19:27 -0700
Message-Id: <1375125570-9401-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375125570-9401-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1375125570-9401-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072919-7606-0000-0000-00000DC71011
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because deletion (of the entire tree) is a relatively common use of the
rbtree_postorder iteration, and because doing it safely means fiddling
with temporary storage, provide a helper to simplify postorder rbtree
iteration.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 include/linux/rbtree.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index c467151..aa870a4 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -85,4 +85,22 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 	*rb_link = node;
 }
 
+/**
+ * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
+ * given type safe against removal of rb_node entry
+ *
+ * @pos:	the 'type *' to use as a loop cursor.
+ * @n:		another 'type *' to use as temporary storage
+ * @root:	'rb_root *' of the rbtree.
+ * @field:	the name of the rb_node field within 'type'.
+ */
+#define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
+	for (pos = rb_entry(rb_first_postorder(root), typeof(*pos), field),\
+		n = rb_entry(rb_next_postorder(&pos->field), \
+			typeof(*pos), field); \
+	     &pos->field; \
+	     pos = n, \
+		n = rb_entry(rb_next_postorder(&pos->field), \
+			typeof(*pos), field))
+
 #endif	/* _LINUX_RBTREE_H */
-- 
1.8.3.4

