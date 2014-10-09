Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbaJIVWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:22:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59528 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbaJIVKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 054/163] arm64: flush TLS registers during exec
Date: Thu,  9 Oct 2014 14:01:19 -0700
Message-Id: <1412888588-26755-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/process.c    | 18 ++++++++++++++++++
 arch/arm64/kernel/sys_compat.c |  6 ++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index de17c89..938704d 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -190,9 +190,27 @@ void exit_thread(void)
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
 
diff --git a/arch/arm64/kernel/sys_compat.c b/arch/arm64/kernel/sys_compat.c
index 26e9c4e..7803992 100644
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -79,6 +79,12 @@ long compat_arm_syscall(struct pt_regs *regs)
 
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
 
-- 
1.9.1

