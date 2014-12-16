Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaLPRBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 12:01:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:46829 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaLPQ57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:57:59 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/18] tools: Move __ffs implementation to tools/include/asm-generic/bitops/__ffs.h
Date: Tue, 16 Dec 2014 13:57:08 -0300
Message-Id: <1418749040-31807-7-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
Link: http://lkml.kernel.org/n/tip-gubysnp4a8hd98lxoeruak13@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/asm-generic/bitops/__ffs.h | 43 ++++++++++++++++++++++++++++++++
 tools/perf/MANIFEST                      |  1 +
 tools/perf/Makefile.perf                 |  1 +
 tools/perf/util/include/linux/bitops.h   | 37 +--------------------------
 4 files changed, 46 insertions(+), 36 deletions(-)
 create mode 100644 tools/include/asm-generic/bitops/__ffs.h

diff --git a/tools/include/asm-generic/bitops/__ffs.h b/tools/include/asm-generic/bitops/__ffs.h
new file mode 100644
index 000000000000..c94175015a82
--- /dev/null
+++ b/tools/include/asm-generic/bitops/__ffs.h
@@ -0,0 +1,43 @@
+#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS___FFS_H_
+#define _TOOLS_LINUX_ASM_GENERIC_BITOPS___FFS_H_
+
+#include <asm/types.h>
+
+/**
+ * __ffs - find first bit in word.
+ * @word: The word to search
+ *
+ * Undefined if no bit exists, so code should check against 0 first.
+ */
+static __always_inline unsigned long __ffs(unsigned long word)
+{
+	int num = 0;
+
+#if __BITS_PER_LONG == 64
+	if ((word & 0xffffffff) == 0) {
+		num += 32;
+		word >>= 32;
+	}
+#endif
+	if ((word & 0xffff) == 0) {
+		num += 16;
+		word >>= 16;
+	}
+	if ((word & 0xff) == 0) {
+		num += 8;
+		word >>= 8;
+	}
+	if ((word & 0xf) == 0) {
+		num += 4;
+		word >>= 4;
+	}
+	if ((word & 0x3) == 0) {
+		num += 2;
+		word >>= 2;
+	}
+	if ((word & 0x1) == 0)
+		num += 1;
+	return num;
+}
+
+#endif /* _TOOLS_LINUX_ASM_GENERIC_BITOPS___FFS_H_ */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 344c4d3d0a4a..39c08636357b 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -5,6 +5,7 @@ tools/lib/api
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
 tools/include/asm/bug.h
+tools/include/asm-generic/bitops/__ffs.h
 tools/include/linux/compiler.h
 tools/include/linux/hash.h
 tools/include/linux/export.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 763e68fb5767..bfd86a32254a 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -232,6 +232,7 @@ LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
+LIB_H += ../include/asm-generic/bitops/__ffs.h 
 LIB_H += ../include/linux/compiler.h
 LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index c3294163de17..762bb83333c0 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -52,42 +52,7 @@ static inline unsigned long hweight_long(unsigned long w)
 
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 
-/**
- * __ffs - find first bit in word.
- * @word: The word to search
- *
- * Undefined if no bit exists, so code should check against 0 first.
- */
-static __always_inline unsigned long __ffs(unsigned long word)
-{
-	int num = 0;
-
-#if BITS_PER_LONG == 64
-	if ((word & 0xffffffff) == 0) {
-		num += 32;
-		word >>= 32;
-	}
-#endif
-	if ((word & 0xffff) == 0) {
-		num += 16;
-		word >>= 16;
-	}
-	if ((word & 0xff) == 0) {
-		num += 8;
-		word >>= 8;
-	}
-	if ((word & 0xf) == 0) {
-		num += 4;
-		word >>= 4;
-	}
-	if ((word & 0x3) == 0) {
-		num += 2;
-		word >>= 2;
-	}
-	if ((word & 0x1) == 0)
-		num += 1;
-	return num;
-}
+#include <asm-generic/bitops/__ffs.h>
 
 typedef const unsigned long __attribute__((__may_alias__)) long_alias_t;
 
-- 
1.9.3

