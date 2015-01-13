Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbbAMN2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:28:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbbAMN2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:28:34 -0500
Date: Tue, 13 Jan 2015 11:29:12 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: your recent tools/include/ adjustments
Message-ID: <20150113132912.GA2468@redhat.com>
References: <54B4E9F3020000780005427E@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B4E9F3020000780005427E@mail.emea.novell.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 13, 2015 at 08:48:35AM +0000, Jan Beulich escreveu:
> Arnaldo,
> 
> considering that tools/include/ gets used by other than just perf, in
> particular arch/x86/vdso/vdso2c.c, would you mind clarifying how
> "tools: Move bitops.h from tools/perf/util to tools/" adding an
> inclusion of asm/hweight.h to linux/bitops.h is supposed to work,
> when the only potentially relevant header to be found is
> tools/perf/util/include/asm/hweight.h?

Oops, includes are tricky, even more so when trying to reuse the kernel
ones in tools/, so we need to go on addressing these problems, thanks
for reporting.

Please take a look if the patch at the end addresses this problem, I
think it should at least disentangle what is in tools/include from what
is in tools/perf/.

I added the bits in the same places as in the matching
include/linux/bitops.h, etc, so that when doing a:

diff -u include/linux/bitops.h tools/include/linux/bitops.h,

For things which we don't completely share with the kernel, the
differences are kept at a minimum.

I think we need to introduce a tools/tests/ to test these kinds of
changes, i.e. introduce simple tests that have in its include path just
what is in tools/include/, to make sure that we don't have it including
things from tools/foo/ tools, like I messed up this time :-/

> Similarly, with "tools: Adopt fls_long and deps" adding 3 stub
> headers to tools/include/asm-generic/bitops/ using
> "#include <../../../../include/asm-generic/bitops/...>", I can't
> see how these headers are to be found when building the above
> mentioned utility - I suppose these really were meant to use
> quotes instead of angle brackets.
> 
> For reference, the breakage was observed on a relatively old
> x86 system where linux/elf.h includes asm/elf.h, reaching
> linux/bitops.h via asm/system.h and asm/cpufeature.h.
> 
> Thanks for any insight/clarification,

Thanks for the report, I'll try to address this <> issue later today.

- Arnaldo

>From a2440421e742e8572dd91ac08f834ca38fd86939 Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 13 Jan 2015 10:19:12 -0300
Subject: [PATCH] tools: Remove bitops/hweight usage of bits in tools/perf

We need to use lib/hweight.c for that, just like we do for lib/rbtree.c,
so tools need to link hweight.o. For now do it directly, but we need to
have a tools/lib/lk.a or .so that collects these goodies...

Reported-by: Jan Beulich <JBeulich@suse.com>
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
Link: http://lkml.kernel.org/n/tip-a1e91dx3apzqw5kbdt7ut21s@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/asm-generic/bitops.h               |  2 ++
 tools/include/asm-generic/bitops/arch_hweight.h  |  1 +
 tools/include/asm-generic/bitops/const_hweight.h |  1 +
 tools/include/linux/bitops.h                     |  7 +++++-
 tools/perf/MANIFEST                              |  2 ++
 tools/perf/Makefile.perf                         |  6 ++++-
 tools/perf/util/hweight.c                        | 31 ------------------------
 tools/perf/util/include/asm/hweight.h            |  8 ------
 tools/perf/util/python-ext-sources               |  2 +-
 9 files changed, 18 insertions(+), 42 deletions(-)
 create mode 100644 tools/include/asm-generic/bitops/arch_hweight.h
 create mode 100644 tools/include/asm-generic/bitops/const_hweight.h
 delete mode 100644 tools/perf/util/hweight.c
 delete mode 100644 tools/perf/util/include/asm/hweight.h

diff --git a/tools/include/asm-generic/bitops.h b/tools/include/asm-generic/bitops.h
index 6eedba1f7732..653d1bad77de 100644
--- a/tools/include/asm-generic/bitops.h
+++ b/tools/include/asm-generic/bitops.h
@@ -22,6 +22,8 @@
 #error only <linux/bitops.h> can be included directly
 #endif
 
+#include <asm-generic/bitops/hweight.h>
+
 #include <asm-generic/bitops/atomic.h>
 
 #endif /* __TOOLS_ASM_GENERIC_BITOPS_H */
diff --git a/tools/include/asm-generic/bitops/arch_hweight.h b/tools/include/asm-generic/bitops/arch_hweight.h
new file mode 100644
index 000000000000..318bb2b202b0
--- /dev/null
+++ b/tools/include/asm-generic/bitops/arch_hweight.h
@@ -0,0 +1 @@
+#include "../../../../include/asm-generic/bitops/arch_hweight.h"
diff --git a/tools/include/asm-generic/bitops/const_hweight.h b/tools/include/asm-generic/bitops/const_hweight.h
new file mode 100644
index 000000000000..0afd644aff83
--- /dev/null
+++ b/tools/include/asm-generic/bitops/const_hweight.h
@@ -0,0 +1 @@
+#include "../../../../include/asm-generic/bitops/const_hweight.h"
diff --git a/tools/include/linux/bitops.h b/tools/include/linux/bitops.h
index 26005a15e7e2..5ad9ee1dd7f6 100644
--- a/tools/include/linux/bitops.h
+++ b/tools/include/linux/bitops.h
@@ -1,9 +1,9 @@
 #ifndef _TOOLS_LINUX_BITOPS_H_
 #define _TOOLS_LINUX_BITOPS_H_
 
+#include <asm/types.h>
 #include <linux/kernel.h>
 #include <linux/compiler.h>
-#include <asm/hweight.h>
 
 #ifndef __WORDSIZE
 #define __WORDSIZE (__SIZEOF_LONG__ * 8)
@@ -19,6 +19,11 @@
 #define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
 #define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
 
+extern unsigned int __sw_hweight8(unsigned int w);
+extern unsigned int __sw_hweight16(unsigned int w);
+extern unsigned int __sw_hweight32(unsigned int w);
+extern unsigned long __sw_hweight64(__u64 w);
+
 /*
  * Include this here because some architectures need generic_ffs/fls in
  * scope
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 83e2887f91a3..628491b6a3c7 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -6,7 +6,9 @@ tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
 tools/lib/util/find_next_bit.c
 tools/include/asm/bug.h
+tools/include/asm-generic/bitops/arch_hweight.h
 tools/include/asm-generic/bitops/atomic.h
+tools/include/asm-generic/bitops/const_hweight.h
 tools/include/asm-generic/bitops/__ffs.h
 tools/include/asm-generic/bitops/__fls.h
 tools/include/asm-generic/bitops/find.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1f71a32aea78..d8fb0ffb03a3 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -232,7 +232,9 @@ LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += ../include/linux/bitops.h
+LIB_H += ../include/asm-generic/bitops/arch_hweight.h
 LIB_H += ../include/asm-generic/bitops/atomic.h
+LIB_H += ../include/asm-generic/bitops/const_hweight.h
 LIB_H += ../include/asm-generic/bitops/find.h
 LIB_H += ../include/asm-generic/bitops/fls64.h
 LIB_H += ../include/asm-generic/bitops/fls.h
@@ -255,7 +257,6 @@ LIB_H += util/include/linux/linkage.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += ../include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
-LIB_H += util/include/asm/hweight.h
 LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
@@ -745,6 +746,9 @@ $(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+$(OUTPUT)util/hweight.o: ../../lib/hweight.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
 $(OUTPUT)util/find_next_bit.o: ../lib/util/find_next_bit.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/util/hweight.c b/tools/perf/util/hweight.c
deleted file mode 100644
index 5c1d0d099f0d..000000000000
--- a/tools/perf/util/hweight.c
+++ /dev/null
@@ -1,31 +0,0 @@
-#include <linux/bitops.h>
-
-/**
- * hweightN - returns the hamming weight of a N-bit word
- * @x: the word to weigh
- *
- * The Hamming Weight of a number is the total number of bits set in it.
- */
-
-unsigned int hweight32(unsigned int w)
-{
-	unsigned int res = w - ((w >> 1) & 0x55555555);
-	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
-	res = (res + (res >> 4)) & 0x0F0F0F0F;
-	res = res + (res >> 8);
-	return (res + (res >> 16)) & 0x000000FF;
-}
-
-unsigned long hweight64(__u64 w)
-{
-#if BITS_PER_LONG == 32
-	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
-#elif BITS_PER_LONG == 64
-	__u64 res = w - ((w >> 1) & 0x5555555555555555ul);
-	res = (res & 0x3333333333333333ul) + ((res >> 2) & 0x3333333333333333ul);
-	res = (res + (res >> 4)) & 0x0F0F0F0F0F0F0F0Ful;
-	res = res + (res >> 8);
-	res = res + (res >> 16);
-	return (res + (res >> 32)) & 0x00000000000000FFul;
-#endif
-}
diff --git a/tools/perf/util/include/asm/hweight.h b/tools/perf/util/include/asm/hweight.h
deleted file mode 100644
index 36cf26d434a5..000000000000
--- a/tools/perf/util/include/asm/hweight.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef PERF_HWEIGHT_H
-#define PERF_HWEIGHT_H
-
-#include <linux/types.h>
-unsigned int hweight32(unsigned int w);
-unsigned long hweight64(__u64 w);
-
-#endif /* PERF_HWEIGHT_H */
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 16a475a7d492..6c6a6953fa93 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -10,7 +10,7 @@ util/ctype.c
 util/evlist.c
 util/evsel.c
 util/cpumap.c
-util/hweight.c
+../../lib/hweight.c
 util/thread_map.c
 util/util.c
 util/xyarray.c
-- 
1.8.3.1

