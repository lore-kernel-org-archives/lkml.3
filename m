Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaCRGMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 02:12:12 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34029 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaCRGMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 02:12:09 -0400
From: behanw@converseincode.com
To: davem@davemloft.net
Cc: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu, Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        =?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>
Subject: [PATCH v2] net: netfilter: LLVMLinux: vlais-netfilter
Date: Mon, 17 Mar 2014 23:12:01 -0700
Message-Id: <1395123121-27053-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <022D9517-4804-47BB-B789-CCF25F25C1ED@me.com>
References: <022D9517-4804-47BB-B789-CCF25F25C1ED@me.com>
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
 net/netfilter/xt_repldata.h | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_repldata.h b/net/netfilter/xt_repldata.h
index 6efe4e5..f83a519 100644
--- a/net/netfilter/xt_repldata.h
+++ b/net/netfilter/xt_repldata.h
@@ -5,29 +5,50 @@
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
+		char data[0]; \
+	} *tbl; \
+	struct type##_standard *entries; \
+	struct type##_error *term; \
+	size_t entries_offset = (-sizeof(tbl->repl)) & \
+		(__alignof__(*entries)-1); \
+	size_t entries_end = entries_offset + nhooks * sizeof(*entries); \
+	size_t term_offset = entries_end + \
+		(-sizeof(tbl->repl) - entries_end) & (__alignof__(*term)-1); \
+	size_t term_end = term_offset + sizeof(*term); \
+	size_t data_sz = term_end + \
+		(-sizeof(tbl->repl) - term_end) & (__alignof__(tbl->repl)-1); \
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

