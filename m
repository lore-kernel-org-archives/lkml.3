Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968037Ab3HIQEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:04:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:29935 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934350Ab3HIQDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:03:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,846,1367996400"; 
   d="scan'208";a="384498930"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        david.daney@cavium.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] kallsyms/kbuild: Remove relocations from kallsyms table
Date: Fri,  9 Aug 2013 09:03:17 -0700
Message-Id: <1376064199-8296-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376064199-8296-1-git-send-email-andi@firstfloor.org>
References: <1376064199-8296-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Remove the ELF relocations from the kallsyms_address[] table.
Instead we just store offsets to _text and relocate that while
accessing the kallsyms table. This is done with a new
kallsyms_offsets[] table. With these changes .tmp_kallsyms*.o
becomes relocation free.

This allows various optimizations further on.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/kallsyms.c  | 27 ++++++++++++++++-----------
 scripts/kallsyms.c | 18 ++++++------------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 3127ad5..e7d7844 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -36,7 +36,7 @@
  * These will be re-linked against their real values
  * during the second link stage.
  */
-extern const unsigned long kallsyms_addresses[] __attribute__((weak));
+extern const long kallsyms_offsets[] __attribute__((weak));
 extern const u8 kallsyms_names[] __attribute__((weak));
 
 /*
@@ -51,6 +51,11 @@ extern const u16 kallsyms_token_index[] __attribute__((weak));
 
 extern const unsigned long kallsyms_markers[] __attribute__((weak));
 
+static inline unsigned long kallsyms_address(int ind)
+{
+	return (unsigned long)RELOC_HIDE(&_text, kallsyms_offsets[ind]);
+}
+
 static inline int is_kernel_inittext(unsigned long addr)
 {
 	if (addr >= (unsigned long)_sinittext
@@ -186,7 +191,7 @@ unsigned long kallsyms_lookup_name(const char *name)
 		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
 
 		if (strcmp(namebuf, name) == 0)
-			return kallsyms_addresses[i];
+			return kallsyms_address(i);
 	}
 	return module_kallsyms_lookup_name(name);
 }
@@ -203,7 +208,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 
 	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
 		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		ret = fn(data, namebuf, NULL, kallsyms_addresses[i]);
+		ret = fn(data, namebuf, NULL, kallsyms_address(i));
 		if (ret != 0)
 			return ret;
 	}
@@ -219,15 +224,15 @@ static unsigned long get_symbol_pos(unsigned long addr,
 	unsigned long i, low, high, mid;
 
 	/* This kernel should never had been booted. */
-	BUG_ON(!kallsyms_addresses);
+	BUG_ON(!kallsyms_offsets);
 
-	/* Do a binary search on the sorted kallsyms_addresses array. */
+	/* Do a binary search on the sorted kallsyms_offsets array. */
 	low = 0;
 	high = kallsyms_num_syms;
 
 	while (high - low > 1) {
 		mid = low + (high - low) / 2;
-		if (kallsyms_addresses[mid] <= addr)
+		if (kallsyms_address(mid) <= addr)
 			low = mid;
 		else
 			high = mid;
@@ -237,15 +242,15 @@ static unsigned long get_symbol_pos(unsigned long addr,
 	 * Search for the first aliased symbol. Aliased
 	 * symbols are symbols with the same address.
 	 */
-	while (low && kallsyms_addresses[low-1] == kallsyms_addresses[low])
+	while (low && kallsyms_address(low - 1) == kallsyms_address(low))
 		--low;
 
-	symbol_start = kallsyms_addresses[low];
+	symbol_start = kallsyms_address(low);
 
 	/* Search for next non-aliased symbol. */
 	for (i = low + 1; i < kallsyms_num_syms; i++) {
-		if (kallsyms_addresses[i] > symbol_start) {
-			symbol_end = kallsyms_addresses[i];
+		if (kallsyms_address(i) > symbol_start) {
+			symbol_end = kallsyms_address(i);
 			break;
 		}
 	}
@@ -469,7 +474,7 @@ static unsigned long get_ksymbol_core(struct kallsym_iter *iter)
 	unsigned off = iter->nameoff;
 
 	iter->module_name[0] = '\0';
-	iter->value = kallsyms_addresses[iter->pos];
+	iter->value = kallsyms_address(iter->pos);
 
 	iter->type = kallsyms_get_symbol_type(off);
 
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 487ac6f..38c8ede 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -180,7 +180,7 @@ static int symbol_valid(struct sym_entry *s)
 	 * specified so exclude them to get a stable symbol list.
 	 */
 	static char *special_symbols[] = {
-		"kallsyms_addresses",
+		"kallsyms_offsets",
 		"kallsyms_num_syms",
 		"kallsyms_names",
 		"kallsyms_markers",
@@ -309,19 +309,13 @@ static void write_src(void)
 	 * symbols that are declared static and are private to their
 	 * .o files.  This prevents .tmp_kallsyms.o or any other
 	 * object from referencing them.
+	 *
+	 * We do the offsets to _text now in kallsyms.c at runtime,
+	 * to get a relocationless symbol table.
 	 */
-	output_label("kallsyms_addresses");
+	output_label("kallsyms_offsets");
 	for (i = 0; i < table_cnt; i++) {
-		if (toupper(table[i].sym[0]) != 'A') {
-			if (_text <= table[i].addr)
-				printf("\tPTR\t_text + %#llx\n",
-					table[i].addr - _text);
-			else
-				printf("\tPTR\t_text - %#llx\n",
-					_text - table[i].addr);
-		} else {
-			printf("\tPTR\t%#llx\n", table[i].addr);
-		}
+		printf("\tPTR\t%#llx\n", table[i].addr - _text);
 	}
 	printf("\n");
 
-- 
1.8.3.1

