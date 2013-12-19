Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3LSJLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:11:00 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59133 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3LSJJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:09:53 -0500
Subject: [PATCH -tip v6 06/22] [BUGFIX] x86: Prohibit probing on
 memcpy/memset
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 19 Dec 2013 09:04:09 +0000
Message-ID: <20131219090409.14309.25677.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcpy/memset functions are fundamental functions and
those are involved in kprobe's exception handling.
Prohibit probing on them to avoid kernel crash.

BTW, perf bench also includes some assembly files
and _ASM_NOKPROBE causes a build error. This includes
some fixes for that too.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/string_32.h         |    6 +++---
 arch/x86/lib/memcpy_32.c                 |    2 ++
 arch/x86/lib/memcpy_64.S                 |    4 ++++
 arch/x86/lib/memset_64.S                 |    3 +++
 tools/perf/bench/mem-memcpy-x86-64-asm.S |    1 +
 tools/perf/bench/mem-memset-x86-64-asm.S |    1 +
 6 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index 3d3e835..3227294 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -151,14 +151,14 @@ static __always_inline void *__constant_memcpy(void *to, const void *from,
  *	This CPU favours 3DNow strongly (eg AMD Athlon)
  */
 
-static inline void *__constant_memcpy3d(void *to, const void *from, size_t len)
+static nokprobe_inline void *__constant_memcpy3d(void *to, const void *from, size_t len)
 {
 	if (len < 512)
 		return __constant_memcpy(to, from, len);
 	return _mmx_memcpy(to, from, len);
 }
 
-static inline void *__memcpy3d(void *to, const void *from, size_t len)
+static nokprobe_inline void *__memcpy3d(void *to, const void *from, size_t len)
 {
 	if (len < 512)
 		return __memcpy(to, from, len);
@@ -204,7 +204,7 @@ void *memmove(void *dest, const void *src, size_t n);
 #define __HAVE_ARCH_MEMCHR
 extern void *memchr(const void *cs, int c, size_t count);
 
-static inline void *__memset_generic(void *s, char c, size_t count)
+static nokprobe_inline void *__memset_generic(void *s, char c, size_t count)
 {
 	int d0, d1;
 	asm volatile("rep\n\t"
diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index e78761d..dabf966 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -1,5 +1,6 @@
 #include <linux/string.h>
 #include <linux/module.h>
+#include <linux/kprobes.h>	/* for NOKPROBE_SYMBOL */
 
 #undef memcpy
 #undef memset
@@ -13,6 +14,7 @@ void *memcpy(void *to, const void *from, size_t n)
 #endif
 }
 EXPORT_SYMBOL(memcpy);
+NOKPROBE_SYMBOL(memcpy);
 
 void *memset(void *s, int c, size_t count)
 {
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 56313a3..80adbf5 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -2,6 +2,7 @@
 
 #include <linux/linkage.h>
 
+#include <asm/asm.h>
 #include <asm/cpufeature.h>
 #include <asm/dwarf2.h>
 #include <asm/alternative-asm.h>
@@ -184,6 +185,9 @@ ENTRY(memcpy)
 ENDPROC(memcpy)
 ENDPROC(__memcpy)
 
+_ASM_NOKPROBE(memcpy)
+_ASM_NOKPROBE(__memcpy)
+
 	/*
 	 * Some CPUs are adding enhanced REP MOVSB/STOSB feature
 	 * If the feature is supported, memcpy_c_e() is the first choice.
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 2dcb380..a62849d 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -135,6 +135,9 @@ ENTRY(__memset)
 ENDPROC(memset)
 ENDPROC(__memset)
 
+_ASM_NOKPROBE(memset)
+_ASM_NOKPROBE(__memset)
+
 	/* Some CPUs support enhanced REP MOVSB/STOSB feature.
 	 * It is recommended to use this when possible.
 	 *
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm.S b/tools/perf/bench/mem-memcpy-x86-64-asm.S
index fcd9cf0..d3d2d41 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-asm.S
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -3,6 +3,7 @@
 #define globl p2align 4; .globl
 #define Lmemcpy_c globl memcpy_c; memcpy_c
 #define Lmemcpy_c_e globl memcpy_c_e; memcpy_c_e
+#define _ASM_NOKPROBE(a)
 #include "../../../arch/x86/lib/memcpy_64.S"
 /*
  * We need to provide note.GNU-stack section, saying that we want
diff --git a/tools/perf/bench/mem-memset-x86-64-asm.S b/tools/perf/bench/mem-memset-x86-64-asm.S
index 9e5af89..c9cbb29 100644
--- a/tools/perf/bench/mem-memset-x86-64-asm.S
+++ b/tools/perf/bench/mem-memset-x86-64-asm.S
@@ -3,6 +3,7 @@
 #define globl p2align 4; .globl
 #define Lmemset_c globl memset_c; memset_c
 #define Lmemset_c_e globl memset_c_e; memset_c_e
+#define _ASM_NOKPROBE(a)
 #include "../../../arch/x86/lib/memset_64.S"
 
 /*


