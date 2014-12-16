Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaLPQ6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:58:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:46889 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbaLPQ6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:58:11 -0500
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
Subject: [PATCH 08/18] tools: Move code originally from asm-generic/atomic.h into tools/include/asm-generic/
Date: Tue, 16 Dec 2014 13:57:10 -0300
Message-Id: <1418749040-31807-9-git-send-email-acme@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-1ldjhvioch1uczilno5e1epl@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/asm-generic/bitops/atomic.h | 22 ++++++++++++++++++++++
 tools/perf/MANIFEST                       |  1 +
 tools/perf/Makefile.perf                  |  1 +
 tools/perf/util/include/linux/bitops.h    | 16 +---------------
 4 files changed, 25 insertions(+), 15 deletions(-)
 create mode 100644 tools/include/asm-generic/bitops/atomic.h

diff --git a/tools/include/asm-generic/bitops/atomic.h b/tools/include/asm-generic/bitops/atomic.h
new file mode 100644
index 000000000000..4bccd7c3d5d6
--- /dev/null
+++ b/tools/include/asm-generic/bitops/atomic.h
@@ -0,0 +1,22 @@
+#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS_ATOMIC_H_
+#define _TOOLS_LINUX_ASM_GENERIC_BITOPS_ATOMIC_H_
+
+#include <asm/types.h>
+
+static inline void set_bit(int nr, unsigned long *addr)
+{
+	addr[nr / __BITS_PER_LONG] |= 1UL << (nr % __BITS_PER_LONG);
+}
+
+static inline void clear_bit(int nr, unsigned long *addr)
+{
+	addr[nr / __BITS_PER_LONG] &= ~(1UL << (nr % __BITS_PER_LONG));
+}
+
+static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
+{
+	return ((1UL << (nr % __BITS_PER_LONG)) &
+		(((unsigned long *)addr)[nr / __BITS_PER_LONG])) != 0;
+}
+
+#endif /* _TOOLS_LINUX_ASM_GENERIC_BITOPS_ATOMIC_H_ */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index db7827fd2518..67d48e20f7e1 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -5,6 +5,7 @@ tools/lib/api
 tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
 tools/include/asm/bug.h
+tools/include/asm-generic/bitops/atomic.h
 tools/include/asm-generic/bitops/__ffs.h
 tools/include/linux/compiler.h
 tools/include/linux/export.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index bd6073e0dec7..fc4082fdf6bf 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -232,6 +232,7 @@ LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
+LIB_H += ../include/asm-generic/bitops/atomic.h 
 LIB_H += ../include/asm-generic/bitops/__ffs.h 
 LIB_H += ../include/linux/compiler.h
 LIB_H += ../include/linux/log2.h
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 762bb83333c0..71f017dc6230 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -29,21 +29,7 @@
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
-static inline void set_bit(int nr, unsigned long *addr)
-{
-	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
-}
-
-static inline void clear_bit(int nr, unsigned long *addr)
-{
-	addr[nr / BITS_PER_LONG] &= ~(1UL << (nr % BITS_PER_LONG));
-}
-
-static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
-{
-	return ((1UL << (nr % BITS_PER_LONG)) &
-		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
-}
+#include <asm-generic/bitops/atomic.h>
 
 static inline unsigned long hweight_long(unsigned long w)
 {
-- 
1.9.3

