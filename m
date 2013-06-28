Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab3F1S6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:58:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3F1S6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:58:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 050/105] powerpc: Fix emulation of illegal instructions on PowerNV platform
Date: Fri, 28 Jun 2013 11:51:12 -0700
Message-Id: <1372445527-24414-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/exceptions-64s.S |  2 +-
 arch/powerpc/kernel/traps.c          | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index bb11075..d2455b2 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -655,7 +655,7 @@ machine_check_common:
 	STD_EXCEPTION_COMMON(0xb00, trap_0b, .unknown_exception)
 	STD_EXCEPTION_COMMON(0xd00, single_step, .single_step_exception)
 	STD_EXCEPTION_COMMON(0xe00, trap_0e, .unknown_exception)
-	STD_EXCEPTION_COMMON(0xe40, emulation_assist, .program_check_exception)
+	STD_EXCEPTION_COMMON(0xe40, emulation_assist, .emulation_assist_interrupt)
 	STD_EXCEPTION_COMMON(0xe60, hmi_exception, .unknown_exception)
 	STD_EXCEPTION_COMMON_ASYNC(0xf00, performance_monitor, .performance_monitor_exception)
 	STD_EXCEPTION_COMMON(0x1300, instruction_breakpoint, .instruction_breakpoint_exception)
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 6686794..0313856 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1075,6 +1075,16 @@ void __kprobes program_check_exception(struct pt_regs *regs)
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
-- 
1.8.1.2

