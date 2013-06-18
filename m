Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab3FRQSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:18:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab3FRQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:06 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 41/48] powerpc: Fix emulation of illegal instructions on PowerNV platform
Date: Tue, 18 Jun 2013 09:18:07 -0700
Message-Id: <20130618161731.858661016@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/exceptions-64s.S |    2 +-
 arch/powerpc/kernel/traps.c          |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -707,7 +707,7 @@ machine_check_common:
 	STD_EXCEPTION_COMMON(0xb00, trap_0b, .unknown_exception)
 	STD_EXCEPTION_COMMON(0xd00, single_step, .single_step_exception)
 	STD_EXCEPTION_COMMON(0xe00, trap_0e, .unknown_exception)
-	STD_EXCEPTION_COMMON(0xe40, emulation_assist, .program_check_exception)
+	STD_EXCEPTION_COMMON(0xe40, emulation_assist, .emulation_assist_interrupt)
 	STD_EXCEPTION_COMMON(0xe60, hmi_exception, .unknown_exception)
 #ifdef CONFIG_PPC_DOORBELL
 	STD_EXCEPTION_COMMON_ASYNC(0xe80, h_doorbell, .doorbell_exception)
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1142,6 +1142,16 @@ void __kprobes program_check_exception(s
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


