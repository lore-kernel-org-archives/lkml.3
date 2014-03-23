Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaCWGzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 02:55:53 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:58516 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaCWGzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 02:55:50 -0400
From: behanw@converseincode.com
To: davem@davemloft.net
Cc: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu, Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>
Subject: [PATCH v4] net: netfilter: LLVMLinux: vlais-netfilter
Date: Sat, 22 Mar 2014 23:55:44 -0700
Message-Id: <1395557744-25248-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6E0F8D@AcuExch.aculab.com>
References: <063D6719AE5E284EB5DD2968C1650D6D0F6E0F8D@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

Replaced non-standard C use of Variable Length Arrays In Structs (VLAIS) in
xt_repldata.h with a C99 compliant flexible array member and then calculated
offsets to the other struct members. These other members aren't referenced by
name in this code, however this patch maintains the same memory layout and
padding as was previously accomplished using VLAIS.

Had the original structure been ordered differently, with the entries VLA at
the end, then it could have been a flexible member, and this patch would have
been a lot simpler. However since the data stored in this structure is
ultimately exported to userspace, the order of this structure can't be changed.

This patch makes no attempt to change the existing behavior, merely the way in
which the current layout is accomplished using standard C99 constructs. As such
the code can now be compiled with either gcc or clang.

This version of the patch removes the trailing alignment that the VLAIS
structure would allocate in order to simplify the patch.

Author: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
---
 net/netfilter/xt_repldata.h | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_repldata.h b/net/netfilter/xt_repldata.h
index 6efe4e5..8fd3241 100644
--- a/net/netfilter/xt_repldata.h
+++ b/net/netfilter/xt_repldata.h
@@ -5,23 +5,35 @@
  * they serve as the hanging-off data accessed through repl.data[].
  */
 
+/* tbl has the following structure equivalent, but is C99 compliant:
+ * struct {
+ *	struct type##_replace repl;
+ *	struct type##_standard entries[nhooks];
+ *	struct type##_error term;
+ * } *tbl;
+ */
+
 #define xt_alloc_initial_table(type, typ2) ({ \
 	unsigned int hook_mask = info->valid_hooks; \
 	unsigned int nhooks = hweight32(hook_mask); \
 	unsigned int bytes = 0, hooknum = 0, i = 0; \
 	struct { \
 		struct type##_replace repl; \
-		struct type##_standard entries[nhooks]; \
-		struct type##_error term; \
-	} *tbl = kzalloc(sizeof(*tbl), GFP_KERNEL); \
+		struct type##_standard entries[]; \
+	} *tbl; \
+	struct type##_error *term; \
+	size_t term_offset = (offsetof(typeof(*tbl), entries[nhooks]) + \
+		__alignof__(*term) - 1) & ~(__alignof__(*term) - 1); \
+	tbl = kzalloc(term_offset + sizeof(*term), GFP_KERNEL); \
 	if (tbl == NULL) \
 		return NULL; \
+	term = (struct type##_error *)&(((char *)tbl)[term_offset]); \
 	strncpy(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
-	tbl->term = (struct type##_error)typ2##_ERROR_INIT;  \
+	*term = (struct type##_error)typ2##_ERROR_INIT;  \
 	tbl->repl.valid_hooks = hook_mask; \
 	tbl->repl.num_entries = nhooks + 1; \
 	tbl->repl.size = nhooks * sizeof(struct type##_standard) + \
-	                 sizeof(struct type##_error); \
+			 sizeof(struct type##_error); \
 	for (; hook_mask != 0; hook_mask >>= 1, ++hooknum) { \
 		if (!(hook_mask & 1)) \
 			continue; \
-- 
1.8.3.2

