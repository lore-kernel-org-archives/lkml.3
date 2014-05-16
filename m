Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbaEPPBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:01:32 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:65522 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbaEPPBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:01:30 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH] [RFC] ARM: perf: allow tracing with kernel tracepoints events
Date: Fri, 16 May 2014 17:01:16 +0200
Message-Id: <1400252476-20128-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tracing with tracepoints events the IP and CPSR are set to 0,
preventing the perf code to resolve the symbols:

./perf record -e kmem:kmalloc cal
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.007 MB perf.data (~321 samples) ]

./perf report
Overhead Command Shared Object Symbol
........ ....... ............. ...........
40.78%   cal     [unknown]     [.]00000000
31.6%    cal     [unknown]     [.]00000000

The examination of the gathered samples (perf report -D) shows the IP
is set to 0 and that the samples are considered as user space samples,
while the IP should be set from the registers and the samples should be
considered as kernel samples.

The fix is to implement perf_arch_fetch_caller_regs for ARM, which
fills the necessary registers: ip, lr, sp and cpsr (used to check
the user mode property of the samples).

Heavily inspired from arch/arm/include/asm/kexec.h.

Reported by Sneha Priya on linaro-dev, cf.
http://lists.linaro.org/pipermail/linaro-dev/2014-May/017151.html

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
Reported-by: Sneha Priya <sneha.cse@hotmail.com>
---
 arch/arm/include/asm/perf_event.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index 7558775..d466e39 100644
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
@@ -26,6 +26,19 @@ struct pt_regs;
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 #define perf_misc_flags(regs)	perf_misc_flags(regs)
+
+#define perf_arch_fetch_caller_regs(regs, __ip) {	\
+	instruction_pointer(regs)= (__ip);		\
+	__asm__ __volatile__ (				\
+		"mov	%[_ARM_sp], sp\n\t"		\
+		"str	lr, %[_ARM_lr]\n\t"		\
+		"mrs	%[_ARM_cpsr], cpsr\n\t"		\
+		: [_ARM_cpsr] "=r" (regs->ARM_cpsr),	\
+		  [_ARM_sp] "=r" (regs->ARM_sp),	\
+		  [_ARM_lr] "=o" (regs->ARM_lr)		\
+		: : "memory"				\
+	);						\
+}
 #endif
 
 #endif /* __ARM_PERF_EVENT_H__ */
-- 
1.8.1.2

