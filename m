Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab3FPWQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:16:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46428 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755771Ab3FPWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Mackerras" <paulus@samba.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.696794213@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [83/83] powerpc: Fix emulation of illegal instructions on PowerNV
 platform
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit bf593907f7236e95698a76b7c7a2bbf8b1165327 upstream.

Normally, the kernel emulates a few instructions that are unimplemented
on some processors (e.g. the old dcba instruction), or privileged (e.g.
mfpvr).  The emulation of unimplemented instructions is currently not
working on the PowerNV platform.  The reason is that on these machines,
unimplemented and illegal instructions cause a hypervisor emulation
assist interrupt, rather than a program interrupt as on older CPUs.
Our vector for the emulation assist interrupt just calls
program_check_exception() directly, without setting the bit in SRR1
that indicates an illegal instruction interrupt.  This fixes it by
making the emulation assist interrupt set that bit before calling
program_check_interrupt().  With this, old programs that use no-longer
implemented instructions such as dcba now work again.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/exceptions-64s.S |    2 +-
 arch/powerpc/kernel/traps.c          |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -463,7 +463,7 @@ machine_check_common:
 	STD_EXCEPTION_COMMON(0xb00, trap_0b, .unknown_exception)
 	STD_EXCEPTION_COMMON(0xd00, single_step, .single_step_exception)
 	STD_EXCEPTION_COMMON(0xe00, trap_0e, .unknown_exception)
-        STD_EXCEPTION_COMMON(0xe40, emulation_assist, .program_check_exception)
+	STD_EXCEPTION_COMMON(0xe40, emulation_assist, .emulation_assist_interrupt)
         STD_EXCEPTION_COMMON(0xe60, hmi_exception, .unknown_exception)
 	STD_EXCEPTION_COMMON_IDLE(0xf00, performance_monitor, .performance_monitor_exception)
 	STD_EXCEPTION_COMMON(0x1300, instruction_breakpoint, .instruction_breakpoint_exception)
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1036,6 +1036,16 @@ void __kprobes program_check_exception(s
 		_exception(SIGILL, regs, ILL_ILLOPC, regs->nip);
 }
 
+/*
+ * This occurs when running in hypervisor mode on POWER6 or later
+ * and an illegal instruction is encountered.
+ */
+void __kprobes emulation_assist_interrupt(struct pt_regs *regs)
+{
+	regs->msr |= REASON_ILLEGAL;
+	program_check_exception(regs);
+}
+
 void alignment_exception(struct pt_regs *regs)
 {
 	int sig, code, fixed = 0;

