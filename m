Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121AbaFQRLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:11:25 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49102 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557AbaFQRLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:11:22 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, Sneha Priya <sneha.cse@hotmail.com>,
        linux-kernel@vger.kernel.org
Cc: Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH] ARM: perf: allow tracing with kernel tracepoints events
Date: Tue, 17 Jun 2014 19:11:05 +0200
Message-Id: <1403025065-18001-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <CAFrcx1n-cPXm=w+84gQiUjZoFKi7gYnvJ0BQ+8yXKS=k3nEt3g@mail.gmail.com>
References: <CAFrcx1n-cPXm=w+84gQiUjZoFKi7gYnvJ0BQ+8yXKS=k3nEt3g@mail.gmail.com>
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
fills the necessary registers used for the callchain unwinding and
to determine the user/kernel space property of the samples: ip, sp, fp
and cpsr.

Tested with perf record and tracepoints filtering (-e <tracepoint>), with
unwinding using fp (--call-graph fp) and dwarf info (--call-graph dwarf).

Reported by Sneha Priya on linaro-dev, cf.
http://lists.linaro.org/pipermail/linaro-dev/2014-May/017151.html

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
Reported-by: Sneha Priya <sneha.cse@hotmail.com>
---
 arch/arm/include/asm/perf_event.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index 7558775..5e31d46 100644
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
@@ -26,6 +26,25 @@ struct pt_regs;
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 #define perf_misc_flags(regs)	perf_misc_flags(regs)
+
+/*
+ * Take a snapshot of the regs.
+ * We only need a few of the regs:
+ * - ip for PERF_SAMPLE_IP
+ * - sp, fp for callchains
+ * - cpsr for user_mode() tests
+ */
+#define perf_arch_fetch_caller_regs(regs, __ip) {	\
+	instruction_pointer(regs)= (__ip);		\
+	__asm__ (					\
+		"mov	%[_ARM_sp], sp		\n\t"	\
+		"mov	%[_ARM_fp], fp		\n\t"	\
+		"mrs	%[_ARM_cpsr], cpsr	\n\t"	\
+		: [_ARM_sp]   "=r" (regs->ARM_sp),	\
+		  [_ARM_fp]   "=r" (regs->ARM_fp),	\
+		  [_ARM_cpsr] "=r" (regs->ARM_cpsr)	\
+	);						\
+}
 #endif
 
 #endif /* __ARM_PERF_EVENT_H__ */
-- 
1.8.1.2

