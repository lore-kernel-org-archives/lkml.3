Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbaJDAo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:44:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbaJCVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.16 040/357] arm64: flush TLS registers during exec
Date: Fri,  3 Oct 2014 14:27:06 -0700
Message-Id: <20141003212934.667924737@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit eb35bdd7bca29a13c8ecd44e6fd747a84ce675db upstream.

Nathan reports that we leak TLS information from the parent context
during an exec, as we don't clear the TLS registers when flushing the
thread state.

This patch updates the flushing code so that we:

  (1) Unconditionally zero the tpidr_el0 register (since this is fully
      context switched for native tasks and zeroed for compat tasks)

  (2) Zero the tp_value state in thread_info before clearing the
      tpidrr0_el0 register for compat tasks (since this is only writable
      by the set_tls compat syscall and therefore not fully switched).

A missing compiler barrier is also added to the compat set_tls syscall.

Acked-by: Nathan Lynch <Nathan_Lynch@mentor.com>
Reported-by: Nathan Lynch <Nathan_Lynch@mentor.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/process.c    |   18 ++++++++++++++++++
 arch/arm64/kernel/sys_compat.c |    6 ++++++
 2 files changed, 24 insertions(+)

--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -224,9 +224,27 @@ void exit_thread(void)
 {
 }
 
+static void tls_thread_flush(void)
+{
+	asm ("msr tpidr_el0, xzr");
+
+	if (is_compat_task()) {
+		current->thread.tp_value = 0;
+
+		/*
+		 * We need to ensure ordering between the shadow state and the
+		 * hardware state, so that we don't corrupt the hardware state
+		 * with a stale shadow state during context switch.
+		 */
+		barrier();
+		asm ("msr tpidrro_el0, xzr");
+	}
+}
+
 void flush_thread(void)
 {
 	fpsimd_flush_thread();
+	tls_thread_flush();
 	flush_ptrace_hw_breakpoint(current);
 }
 
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -79,6 +79,12 @@ long compat_arm_syscall(struct pt_regs *
 
 	case __ARM_NR_compat_set_tls:
 		current->thread.tp_value = regs->regs[0];
+
+		/*
+		 * Protect against register corruption from context switch.
+		 * See comment in tls_thread_flush.
+		 */
+		barrier();
 		asm ("msr tpidrro_el0, %0" : : "r" (regs->regs[0]));
 		return 0;
 


