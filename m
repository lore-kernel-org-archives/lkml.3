Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaLRGbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:31:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58696 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaLRGbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:31:35 -0500
Date: Wed, 17 Dec 2014 22:30:52 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-fkbma1h04ki0zzdmp0dpgfyy@git.kernel.org>
Cc: dzickus@redhat.com, acme@redhat.com, efault@gmx.de, eranian@google.com,
        jolsa@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        mingo@kernel.org, hpa@zytor.com, bp@suse.de, tglx@linutronix.de,
        dsahern@gmail.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, adrian.hunter@intel.com
Reply-To: tglx@linutronix.de, bp@suse.de, hpa@zytor.com, mingo@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, dsahern@gmail.com,
        dzickus@redhat.com, peterz@infradead.org, eranian@google.com,
        jolsa@redhat.com, efault@gmx.de, acme@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib: Move asm-generic/bitops/
 find.h code to tools/include and tools/lib
Git-Commit-ID: 23e1a358e81017759714cb413a0e930d4f892563
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23e1a358e81017759714cb413a0e930d4f892563
Gitweb:     http://git.kernel.org/tip/23e1a358e81017759714cb413a0e930d4f892563
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 15 Dec 2014 19:50:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:14:48 -0300

tools lib: Move asm-generic/bitops/find.h code to tools/include and tools/lib

To match the Linux kernel source code structure from where this code came from.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-fkbma1h04ki0zzdmp0dpgfyy@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/asm-generic/bitops/find.h | 33 ++++++++++++
 tools/lib/util/find_next_bit.c          | 89 +++++++++++++++++++++++++++++++++
 tools/perf/MANIFEST                     |  3 ++
 tools/perf/Makefile.perf                |  5 ++
 tools/perf/util/include/linux/bitops.h  | 73 +--------------------------
 5 files changed, 131 insertions(+), 72 deletions(-)

diff --git a/tools/include/asm-generic/bitops/find.h b/tools/include/asm-generic/bitops/find.h
new file mode 100644
index 0000000..31f5154
--- /dev/null
+++ b/tools/include/asm-generic/bitops/find.h
@@ -0,0 +1,33 @@
+#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_
+#define _TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_
+
+#ifndef find_next_bit
+/**
+ * find_next_bit - find the next set bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
+		size, unsigned long offset);
+#endif
+
+#ifndef find_first_bit
+
+/**
+ * find_first_bit - find the first set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum number of bits to search
+ *
+ * Returns the bit number of the first set bit.
+ * If no bits are set, returns @size.
+ */
+extern unsigned long find_first_bit(const unsigned long *addr,
+				    unsigned long size);
+
+#endif /* find_first_bit */
+
+#endif /*_TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_ */
diff --git a/tools/lib/util/find_next_bit.c b/tools/lib/util/find_next_bit.c
new file mode 100644
index 0000000..41b44f6
--- /dev/null
+++ b/tools/lib/util/find_next_bit.c
@@ -0,0 +1,89 @@
+/* find_next_bit.c: fallback find next bit implementation
+ *
+ * Copied from lib/find_next_bit.c to tools/lib/next_bit.c
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/bitops.h>
+#include <asm/types.h>
+#include <asm/byteorder.h>
+
+#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
+
+#ifndef find_next_bit
+/*
+ * Find the next set bit in a memory region.
+ */
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+			    unsigned long offset)
+{
+	const unsigned long *p = addr + BITOP_WORD(offset);
+	unsigned long result = offset & ~(BITS_PER_LONG-1);
+	unsigned long tmp;
+
+	if (offset >= size)
+		return size;
+	size -= result;
+	offset %= BITS_PER_LONG;
+	if (offset) {
+		tmp = *(p++);
+		tmp &= (~0UL << offset);
+		if (size < BITS_PER_LONG)
+			goto found_first;
+		if (tmp)
+			goto found_middle;
+		size -= BITS_PER_LONG;
+		result += BITS_PER_LONG;
+	}
+	while (size & ~(BITS_PER_LONG-1)) {
+		if ((tmp = *(p++)))
+			goto found_middle;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+	tmp = *p;
+
+found_first:
+	tmp &= (~0UL >> (BITS_PER_LONG - size));
+	if (tmp == 0UL)		/* Are any bits set? */
+		return result + size;	/* Nope. */
+found_middle:
+	return result + __ffs(tmp);
+}
+#endif
+
+#ifndef find_first_bit
+/*
+ * Find the first set bit in a memory region.
+ */
+unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
+{
+	const unsigned long *p = addr;
+	unsigned long result = 0;
+	unsigned long tmp;
+
+	while (size & ~(BITS_PER_LONG-1)) {
+		if ((tmp = *(p++)))
+			goto found;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+
+	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
+	if (tmp == 0UL)		/* Are any bits set? */
+		return result + size;	/* Nope. */
+found:
+	return result + __ffs(tmp);
+}
+#endif
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 67d48e2..bfd7e22 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -4,8 +4,10 @@ tools/lib/traceevent
 tools/lib/api
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
+tools/lib/util/find_next_bit.c
 tools/include/asm/bug.h
 tools/include/asm-generic/bitops/atomic.h
+tools/include/asm-generic/bitops/find.h
 tools/include/asm-generic/bitops/__ffs.h
 tools/include/linux/compiler.h
 tools/include/linux/export.h
@@ -18,6 +20,7 @@ include/linux/rbtree.h
 include/linux/list.h
 include/linux/hash.h
 include/linux/stringify.h
+lib/find_next_bit.c
 lib/rbtree.c
 include/linux/swab.h
 arch/*/include/asm/unistd*.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 604349d..1aef417 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -233,6 +233,7 @@ LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
 LIB_H += ../include/asm-generic/bitops/atomic.h
+LIB_H += ../include/asm-generic/bitops/find.h
 LIB_H += ../include/asm-generic/bitops/__ffs.h
 LIB_H += ../include/linux/compiler.h
 LIB_H += ../include/linux/log2.h
@@ -338,6 +339,7 @@ LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/evlist.o
 LIB_OBJS += $(OUTPUT)util/evsel.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
+LIB_OBJS += $(OUTPUT)util/find_next_bit.o
 LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/kallsyms.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
@@ -737,6 +739,9 @@ $(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+$(OUTPUT)util/find_next_bit.o: ../lib/util/find_next_bit.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
 $(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-redundant-decls $<
 
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 58c4a25..292aade 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -37,78 +37,7 @@ static inline unsigned long hweight_long(unsigned long w)
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-
 #include <asm-generic/bitops/__ffs.h>
-
-typedef const unsigned long __attribute__((__may_alias__)) long_alias_t;
-
-/*
- * Find the first set bit in a memory region.
- */
-static inline unsigned long
-find_first_bit(const unsigned long *addr, unsigned long size)
-{
-	long_alias_t *p = (long_alias_t *) addr;
-	unsigned long result = 0;
-	unsigned long tmp;
-
-	while (size & ~(BITS_PER_LONG-1)) {
-		if ((tmp = *(p++)))
-			goto found;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-
-	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size;	/* Nope. */
-found:
-	return result + __ffs(tmp);
-}
-
-/*
- * Find the next set bit in a memory region.
- */
-static inline unsigned long
-find_next_bit(const unsigned long *addr, unsigned long size, unsigned long offset)
-{
-	const unsigned long *p = addr + BITOP_WORD(offset);
-	unsigned long result = offset & ~(BITS_PER_LONG-1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	size -= result;
-	offset %= BITS_PER_LONG;
-	if (offset) {
-		tmp = *(p++);
-		tmp &= (~0UL << offset);
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-	while (size & ~(BITS_PER_LONG-1)) {
-		if ((tmp = *(p++)))
-			goto found_middle;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = *p;
-
-found_first:
-	tmp &= (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size;	/* Nope. */
-found_middle:
-	return result + __ffs(tmp);
-}
+#include <asm-generic/bitops/find.h>
 
 #endif
