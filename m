Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaLaTDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 14:03:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbaLaTDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 14:03:32 -0500
From: Daniel Borkmann <dborkman@redhat.com>
To: akpm@linux-foundation.org
Cc: dborkman@redhat.com, linux-kernel@vger.kernel.org,
        Joe Mario <jmario@redhat.com>
Subject: [PATCH akpm/next] lib: crc32: conditionally constify crc32 lookup table
Date: Wed, 31 Dec 2014 20:03:28 +0100
Message-Id: <1420052608-30515-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8f243af42ade ("sections: fix const sections for crc32 table")
removed the compile-time generated crc32 tables from the RO sections,
because it conflicts with the definition of __cacheline_aligned
which puts all such aligned data into .data..cacheline_aligned section
optimized for wasting less space, and causes const align issues with
some GCC versions (see #52181, for example).

We can fix that in two steps: 1) by using the ____cacheline_aligned
version, which only aligns the data but doesn't move it into specific
sections, 2) test GCC and in problematic cases fall back to the current
code, otherwise use const and proper alignment for the lookup tables.

After patch tables are in RO:

$ nm -v lib/crc32.o | grep -1 -E "crc32c?table"
0000000000000000 t arch_local_irq_enable
0000000000000000 r crc32ctable_le
0000000000000000 t crc32_exit
--
0000000000000960 t test_buf
0000000000002000 r crc32table_be
0000000000004000 r crc32table_le
000000001d1056e5 A __crc_crc32_be

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
---
 Makefile                   |  5 +++++
 lib/Makefile               |  3 +++
 lib/gen_crc32table.c       | 21 +++++++++++++++------
 scripts/gcc-const-align.sh | 21 +++++++++++++++++++++
 4 files changed, 44 insertions(+), 6 deletions(-)
 create mode 100755 scripts/gcc-const-align.sh

diff --git a/Makefile b/Makefile
index ef748e1..be02ac2 100644
--- a/Makefile
+++ b/Makefile
@@ -776,6 +776,11 @@ ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
 	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
 endif
 
+# check for const + align
+ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-const-align.sh $(CC)), y)
+	KBUILD_CFLAGS += -DCC_HAVE_CONST_ALIGN
+endif
+
 include $(srctree)/scripts/Makefile.extrawarn
 
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
diff --git a/lib/Makefile b/lib/Makefile
index 3c3b30b..8b33eec 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -171,6 +171,9 @@ obj-$(CONFIG_FONT_SUPPORT) += fonts/
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
+# We need to transfer this flag to the host compiler if present
+HOSTCFLAGS_gen_crc32table.o := $(findstring -DCC_HAVE_CONST_ALIGN,$(KBUILD_CFLAGS))
+
 $(obj)/crc32.o: $(obj)/crc32table.h
 
 quiet_cmd_crc32 = GEN     $@
diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
index 71fcfcd..2f06893 100644
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -21,6 +21,14 @@
 # define BE_TABLE_SIZE (1 << CRC_BE_BITS)
 #endif
 
+#ifdef CC_HAVE_CONST_ALIGN
+# define TABLE_CONST_ATTR "const"
+# define TABLE_ALIGNMENT  "____cacheline_aligned"
+#else
+# define TABLE_CONST_ATTR ""
+# define TABLE_ALIGNMENT  "__cacheline_aligned"
+#endif
+
 static uint32_t crc32table_le[LE_TABLE_ROWS][256];
 static uint32_t crc32table_be[BE_TABLE_ROWS][256];
 static uint32_t crc32ctable_le[LE_TABLE_ROWS][256];
@@ -109,8 +117,8 @@ int main(int argc, char** argv)
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static u32 __cacheline_aligned "
-		       "crc32table_le[%d][%d] = {",
+		printf("static %s u32 %s crc32table_le[%d][%d] = {",
+		       TABLE_CONST_ATTR, TABLE_ALIGNMENT,
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32table_le, LE_TABLE_ROWS,
 			     LE_TABLE_SIZE, "tole");
@@ -119,17 +127,18 @@ int main(int argc, char** argv)
 
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static u32 __cacheline_aligned "
-		       "crc32table_be[%d][%d] = {",
+		printf("static %s u32 %s crc32table_be[%d][%d] = {",
+		       TABLE_CONST_ATTR, TABLE_ALIGNMENT,
 		       BE_TABLE_ROWS, BE_TABLE_SIZE);
 		output_table(crc32table_be, LE_TABLE_ROWS,
 			     BE_TABLE_SIZE, "tobe");
 		printf("};\n");
 	}
+
 	if (CRC_LE_BITS > 1) {
 		crc32cinit_le();
-		printf("static u32 __cacheline_aligned "
-		       "crc32ctable_le[%d][%d] = {",
+		printf("static %s u32 %s crc32ctable_le[%d][%d] = {",
+		       TABLE_CONST_ATTR, TABLE_ALIGNMENT,
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32ctable_le, LE_TABLE_ROWS,
 			     LE_TABLE_SIZE, "tole");
diff --git a/scripts/gcc-const-align.sh b/scripts/gcc-const-align.sh
new file mode 100755
index 0000000..9b4cf69
--- /dev/null
+++ b/scripts/gcc-const-align.sh
@@ -0,0 +1,21 @@
+#!/bin/sh
+# Test for gcc const + __attribute__((aligned())) support
+
+cat << "END" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
+/*
+ * Some GCC versions will result in broken alignment, probe for
+ * them so we can work around this (see GCC Bug 52181).
+ */
+#define SMP_CACHE_BYTES 64	/* Example alignment. */
+extern const int tv1[];
+const int __attribute__((aligned(SMP_CACHE_BYTES))) tv1[] = { 1 };
+extern const int __attribute__((aligned(SMP_CACHE_BYTES))) tv2[];
+const int tv2[] = { 1 };
+extern const int __attribute__((aligned(SMP_CACHE_BYTES))) tv3[];
+const int __attribute__((aligned(SMP_CACHE_BYTES))) tv3[] = { 1 };
+const int __attribute__((aligned(SMP_CACHE_BYTES))) tv4[] = { 1 };
+int probe[__alignof__(tv4) != __alignof__(tv1) ||
+	  __alignof__(tv4) != __alignof__(tv2) ||
+	  __alignof__(tv4) != __alignof__(tv3) ||
+	  __alignof__(tv4) != SMP_CACHE_BYTES ? -1 : 0];
+END
-- 
1.7.11.7

