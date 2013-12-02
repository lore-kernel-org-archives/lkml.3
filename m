Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3LBUXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:23:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3LBTRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, Paul Mundt <lethal@linux-sh.org>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 032/212] rbtree: fix rbtree_postorder_for_each_entry_safe() iterator
Date: Mon,  2 Dec 2013 11:13:43 -0800
Message-Id: <20131202191252.134198880@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 1310a5a99d900ee30b9f171146406bde0c6c2bd4 upstream.

The iterator rbtree_postorder_for_each_entry_safe() relies on pointer
underflow behavior when testing for loop termination.  In particular it
expects that

  &rb_entry(NULL, type, field)->field

is NULL.  But the result of this expression is not defined by a C standard
and some gcc versions (e.g.  4.3.4) assume the above expression can never
be equal to NULL.  The net result is an oops because the iteration is not
properly terminated.

Fix the problem by modifying the iterator to avoid pointer underflows.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/rbtree.h |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -85,6 +85,11 @@ static inline void rb_link_node(struct r
 	*rb_link = node;
 }
 
+#define rb_entry_safe(ptr, type, member) \
+	({ typeof(ptr) ____ptr = (ptr); \
+	   ____ptr ? rb_entry(____ptr, type, member) : NULL; \
+	})
+
 /**
  * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
  * given type safe against removal of rb_node entry
@@ -95,12 +100,9 @@ static inline void rb_link_node(struct r
  * @field:	the name of the rb_node field within 'type'.
  */
 #define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
-	for (pos = rb_entry(rb_first_postorder(root), typeof(*pos), field),\
-		n = rb_entry(rb_next_postorder(&pos->field), \
-			typeof(*pos), field); \
-	     &pos->field; \
-	     pos = n, \
-		n = rb_entry(rb_next_postorder(&pos->field), \
-			typeof(*pos), field))
+	for (pos = rb_entry_safe(rb_first_postorder(root), typeof(*pos), field); \
+	     pos && ({ n = rb_entry_safe(rb_next_postorder(&pos->field), \
+			typeof(*pos), field); 1; }); \
+	     pos = n)
 
 #endif	/* _LINUX_RBTREE_H */


