Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab3GPRgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:36:47 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:55845 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933578Ab3GPRfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:35:03 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [RFC PATCH 05/10] alpha: Primitive support for CPU power down.
Date: Tue, 16 Jul 2013 10:34:13 -0700
Message-Id: <1373996058-13399-6-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373996058-13399-1-git-send-email-rth@twiddle.net>
References: <1373996058-13399-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use WTINT to wait for the next interrupt.  Squash the WTINT call
if the PALcode doesn't support it (e.g. MILO).  No attempt is yet
made to skip clock ticks during normal scheduling in order to stay
in power down mode longer.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/include/asm/pal.h      |  1 +
 arch/alpha/include/uapi/asm/pal.h |  1 +
 arch/alpha/kernel/process.c       | 15 +++++++++++++++
 arch/alpha/kernel/traps.c         | 12 ++++++++++++
 4 files changed, 29 insertions(+)

diff --git a/arch/alpha/include/asm/pal.h b/arch/alpha/include/asm/pal.h
index 6fcd2b5..e78ec9b 100644
--- a/arch/alpha/include/asm/pal.h
+++ b/arch/alpha/include/asm/pal.h
@@ -89,6 +89,7 @@ __CALL_PAL_W1(wrmces, unsigned long);
 __CALL_PAL_RW2(wrperfmon, unsigned long, unsigned long, unsigned long);
 __CALL_PAL_W1(wrusp, unsigned long);
 __CALL_PAL_W1(wrvptptr, unsigned long);
+__CALL_PAL_RW1(wtint, unsigned long, unsigned long);
 
 /*
  * TB routines..
diff --git a/arch/alpha/include/uapi/asm/pal.h b/arch/alpha/include/uapi/asm/pal.h
index 3c0ce08..dfc8140 100644
--- a/arch/alpha/include/uapi/asm/pal.h
+++ b/arch/alpha/include/uapi/asm/pal.h
@@ -46,6 +46,7 @@
 #define PAL_rdusp	58
 #define PAL_whami	60
 #define PAL_retsys	61
+#define PAL_wtint	62
 #define PAL_rti		63
 
 
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index f2360a7..3130f13 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -46,6 +46,21 @@
 void (*pm_power_off)(void) = machine_power_off;
 EXPORT_SYMBOL(pm_power_off);
 
+/*
+ * Sleep the CPU.
+ * EV6, LCA45 and QEMU know how to power down, skipping N timer interrupts.
+ */
+void arch_cpu_idle(void)
+{
+	wtint(0);
+	local_irq_enable();
+}
+
+void arch_cpu_idle_dead(void)
+{
+	wtint(INT_MAX);
+}
+
 struct halt_info {
 	int mode;
 	char *restart_cmd;
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index affccb9..991f6c3 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -243,6 +243,18 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 			       (const char *)(data[1] | (long)data[2] << 32), 
 			       data[0]);
 		}
+		if (type == 4) {
+			/* If CALL_PAL WTINT is not supported by the PALcode,
+			   "emulate" it by overwriting the insn.  */
+			unsigned int *pinsn
+			  = (unsigned int *) regs->pc - 1;
+			if (*pinsn == PAL_wtint) {
+				*pinsn = 0x47e01400; /* mov 0,$0 */
+				imb();
+				regs->r0 = 0;
+				return;
+			}
+		}
 		die_if_kernel((type == 1 ? "Kernel Bug" : "Instruction fault"),
 			      regs, type, NULL);
 	}
-- 
1.8.1.4

