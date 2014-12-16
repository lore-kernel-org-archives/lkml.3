Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaLPQ6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:58:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:47007 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaLPQ6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:58:35 -0500
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
Subject: [PATCH 12/18] tools: Move bitops.h from tools/perf/util to tools/
Date: Tue, 16 Dec 2014 13:57:14 -0300
Message-Id: <1418749040-31807-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we better mirror the kernel sources and make it available for
other tools.

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
Link: http://lkml.kernel.org/n/tip-mvfu6x753tksnto3t6412m93@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/linux/bitops.h           | 46 ++++++++++++++++++++++++++++++++++
 tools/perf/MANIFEST                    |  1 +
 tools/perf/Makefile.perf               |  2 +-
 tools/perf/util/include/linux/bitops.h | 46 ----------------------------------
 4 files changed, 48 insertions(+), 47 deletions(-)
 create mode 100644 tools/include/linux/bitops.h
 delete mode 100644 tools/perf/util/include/linux/bitops.h

diff --git a/tools/include/linux/bitops.h b/tools/include/linux/bitops.h
new file mode 100644
index 000000000000..5237bc9f6266
--- /dev/null
+++ b/tools/include/linux/bitops.h
@@ -0,0 +1,46 @@
+#ifndef _TOOLS_LINUX_BITOPS_H_
+#define _TOOLS_LINUX_BITOPS_H_
+
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <asm/hweight.h>
+
+#ifndef __WORDSIZE
+#define __WORDSIZE (__SIZEOF_LONG__ * 8)
+#endif
+
+#define BITS_PER_LONG __WORDSIZE
+
+#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+#define BITS_PER_BYTE		8
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+#define BITS_TO_U64(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
+#define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
+#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
+
+/*
+ * Include this here because some architectures need generic_ffs/fls in
+ * scope
+ *
+ * XXX: this needs to be asm/bitops.h, when we get to per arch optimizations
+ */
+#include <asm-generic/bitops.h>
+
+#define for_each_set_bit(bit, addr, size) \
+	for ((bit) = find_first_bit((addr), (size));		\
+	     (bit) < (size);					\
+	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+
+/* same as for_each_set_bit() but use bit as value to start with */
+#define for_each_set_bit_from(bit, addr, size) \
+	for ((bit) = find_next_bit((addr), (size), (bit));	\
+	     (bit) < (size);					\
+	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+
+static inline unsigned long hweight_long(unsigned long w)
+{
+	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
+}
+
+#endif
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 86f115cdbb5b..7729af9f417a 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -10,6 +10,7 @@ tools/include/asm-generic/bitops/atomic.h
 tools/include/asm-generic/bitops/__ffs.h
 tools/include/asm-generic/bitops/find.h
 tools/include/asm-generic/bitops.h
+tools/include/linux/bitops.h
 tools/include/linux/compiler.h
 tools/include/linux/export.h
 tools/include/linux/hash.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index d9bf9685e9da..55b9c97cafc2 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -231,7 +231,7 @@ LIB_H += ../../include/uapi/linux/const.h
 LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
-LIB_H += util/include/linux/bitops.h
+LIB_H += ../include/linux/bitops.h
 LIB_H += ../include/asm-generic/bitops/atomic.h 
 LIB_H += ../include/asm-generic/bitops/find.h 
 LIB_H += ../include/asm-generic/bitops/__ffs.h 
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
deleted file mode 100644
index 5237bc9f6266..000000000000
--- a/tools/perf/util/include/linux/bitops.h
+++ /dev/null
@@ -1,46 +0,0 @@
-#ifndef _TOOLS_LINUX_BITOPS_H_
-#define _TOOLS_LINUX_BITOPS_H_
-
-#include <linux/kernel.h>
-#include <linux/compiler.h>
-#include <asm/hweight.h>
-
-#ifndef __WORDSIZE
-#define __WORDSIZE (__SIZEOF_LONG__ * 8)
-#endif
-
-#define BITS_PER_LONG __WORDSIZE
-
-#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
-#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITS_PER_BYTE		8
-#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
-#define BITS_TO_U64(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
-#define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
-#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
-
-/*
- * Include this here because some architectures need generic_ffs/fls in
- * scope
- *
- * XXX: this needs to be asm/bitops.h, when we get to per arch optimizations
- */
-#include <asm-generic/bitops.h>
-
-#define for_each_set_bit(bit, addr, size) \
-	for ((bit) = find_first_bit((addr), (size));		\
-	     (bit) < (size);					\
-	     (bit) = find_next_bit((addr), (size), (bit) + 1))
-
-/* same as for_each_set_bit() but use bit as value to start with */
-#define for_each_set_bit_from(bit, addr, size) \
-	for ((bit) = find_next_bit((addr), (size), (bit));	\
-	     (bit) < (size);					\
-	     (bit) = find_next_bit((addr), (size), (bit) + 1))
-
-static inline unsigned long hweight_long(unsigned long w)
-{
-	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
-}
-
-#endif
-- 
1.9.3

