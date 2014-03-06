Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaCFT4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:56:45 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48941 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbaCFT4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:56:42 -0500
From: behanw@converseincode.com
To: davem@davemloft.net
Cc: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>
Subject: [PATCH] net: inetfilter: LLVMLinux: vlais-netfilter
Date: Thu,  6 Mar 2014 11:56:08 -0800
Message-Id: <1394135768-27621-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
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

Author: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
---
 net/netfilter/xt_repldata.h | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_repldata.h b/net/netfilter/xt_repldata.h
index 6efe4e5..c138fea 100644
--- a/net/netfilter/xt_repldata.h
+++ b/net/netfilter/xt_repldata.h
@@ -5,29 +5,51 @@
  * they serve as the hanging-off data accessed through repl.data[].
  */
 
+#define padbytes(offset, type) ((-offset) & (__alignof__(type)-1))
+
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
+		char data[0]; \
+	} *tbl; \
+	struct type##_standard *entries; \
+	struct type##_error *term; \
+	size_t entries_offset = padbytes(sizeof(tbl->repl), *entries); \
+	size_t entries_end = entries_offset + nhooks * sizeof(*entries); \
+	size_t term_offset = entries_end \
+		+ padbytes(sizeof(tbl->repl) + entries_end, *term); \
+	size_t term_end = term_offset + sizeof(*term); \
+	size_t data_sz = term_end \
+		+ padbytes(sizeof(tbl->repl) + term_end, tbl->repl); \
+	size_t tbl_sz = sizeof(tbl->repl) + data_sz; \
+	tbl = kzalloc(tbl_sz, GFP_KERNEL); \
 	if (tbl == NULL) \
 		return NULL; \
+	entries = (struct type##_standard *)&tbl->data[entries_offset]; \
+	term = (struct type##_error *)&tbl->data[term_offset]; \
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
 		tbl->repl.hook_entry[hooknum] = bytes; \
 		tbl->repl.underflow[hooknum]  = bytes; \
-		tbl->entries[i++] = (struct type##_standard) \
+		entries[i++] = (struct type##_standard) \
 			typ2##_STANDARD_INIT(NF_ACCEPT); \
 		bytes += sizeof(struct type##_standard); \
 	} \
-- 
1.8.3.2

