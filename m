Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3K2Rsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:48:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50514 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3K2Rsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:48:41 -0500
Message-Id: <20131129174429.801026101@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 29 Nov 2013 18:36:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>, hpa@zytor.com,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 1/7] math64: mul_u64_u32_shr()
References: <20131129173657.252094369@infradead.org>
Content-Disposition: inline; filename=peterz-mul_u64_u32_shr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce mul_u64_u32_shr() as proposed by Andy a while back; it
allows using 64x64->128 muls on 64bit archs and recent GCC.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: fweisbec@gmail.com
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/Kconfig       |    1 +
 include/linux/math64.h |   30 ++++++++++++++++++++++++++++++
 init/Kconfig           |    6 ++++++
 3 files changed, 37 insertions(+)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,6 +26,7 @@ config X86
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING
+	select ARCH_SUPPORTS_INT128 if X86_64
 	select ARCH_WANTS_PROT_NUMA_PROT_NONE
 	select HAVE_IDE
 	select HAVE_OPROFILE
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -133,4 +133,34 @@ __iter_div_u64_rem(u64 dividend, u32 div
 	return ret;
 }
 
+#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
+
+#ifndef mul_u64_u32_shr
+static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
+{
+	return (u64)(((unsigned __int128)a * mul) >> shift);
+}
+#endif /* mul_u64_u32_shr */
+
+#else
+
+#ifndef mul_u64_u32_shr
+static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
+{
+	u32 ah, al;
+	u64 ret;
+
+	al = a;
+	ah = a >> 32;
+
+	ret = ((u64)al * mul) >> shift;
+	if (ah)
+		ret += ((u64)ah * mul) << (32 - shift);
+
+	return ret;
+}
+#endif /* mul_u64_u32_shr */
+
+#endif
+
 #endif /* _LINUX_MATH64_H */
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -809,6 +809,12 @@ config GENERIC_SCHED_CLOCK
 config ARCH_SUPPORTS_NUMA_BALANCING
 	bool
 
+#
+# For architectures that know their GCC __int128 support is sound
+#
+config ARCH_SUPPORTS_INT128
+	bool
+
 # For architectures that (ab)use NUMA to represent different memory regions
 # all cpu-local but of different latencies, such as SuperH.
 #


