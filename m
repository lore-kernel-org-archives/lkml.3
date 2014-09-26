Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaIZJrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:47:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbaIZJqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 142/142] arm64: flush TLS registers during exec
Date: Fri, 26 Sep 2014 11:45:53 +0200
Message-Id: <7bcae251a2dfb6c0aa2c34dc505a5796c7c39426.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm64/kernel/process.c    | 18 ++++++++++++++++++
 arch/arm64/kernel/sys_compat.c |  6 ++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 7ae8a1f00c3c..7af6183daa2e 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -183,9 +183,27 @@ void exit_thread(void)
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
index 26e9c4eeaba8..78039927c807 100644
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
2.1.0

