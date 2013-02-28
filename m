Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab3B1OvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:51:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42513 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027Ab3B1Ouy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 122/139] ptrace/x86: Partly fix set_task_blockstep()->update_debugctlmsr() logic
Date: Thu, 28 Feb 2013 14:44:32 +0000
Message-Id: <1362062689-2567-123-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 95cf00fa5d5e2a200a2c044c84bde8389a237e02 upstream.

Afaics the usage of update_debugctlmsr() and TIF_BLOCKSTEP in
step.c was always very wrong.

1. update_debugctlmsr() was simply unneeded. The child sleeps
   TASK_TRACED, __switch_to_xtra(next_p => child) should notice
   TIF_BLOCKSTEP and set/clear DEBUGCTLMSR_BTF after resume if
   needed.

2. It is wrong. The state of DEBUGCTLMSR_BTF bit in CPU register
   should always match the state of current's TIF_BLOCKSTEP bit.

3. Even get_debugctlmsr() + update_debugctlmsr() itself does not
   look right. Irq can change other bits in MSR_IA32_DEBUGCTLMSR
   register or the caller can be preempted in between.

4. It is not safe to play with TIF_BLOCKSTEP if task != current.
   DEBUGCTLMSR_BTF and TIF_BLOCKSTEP should always match each
   other if the task is running. The tracee is stopped but it
   can be SIGKILL'ed right before set/clear_tsk_thread_flag().

However, now that uprobes uses user_enable_single_step(current)
we can't simply remove update_debugctlmsr(). So this patch adds
the additional "task == current" check and disables irqs to avoid
the race with interrupts/preemption.

Unfortunately this patch doesn't solve the last problem, we need
another fix. Probably we should teach ptrace_stop() to set/clear
single/block stepping after resume.

And afaics there is yet another problem: perf can play with
MSR_IA32_DEBUGCTLMSR from nmi, this obviously means that even
__switch_to_xtra() has problems.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/step.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 7a51498..f89cdc6 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -161,6 +161,16 @@ static void set_task_blockstep(struct task_struct *task, bool on)
 {
 	unsigned long debugctl;
 
+	/*
+	 * Ensure irq/preemption can't change debugctl in between.
+	 * Note also that both TIF_BLOCKSTEP and debugctl should
+	 * be changed atomically wrt preemption.
+	 * FIXME: this means that set/clear TIF_BLOCKSTEP is simply
+	 * wrong if task != current, SIGKILL can wakeup the stopped
+	 * tracee and set/clear can play with the running task, this
+	 * can confuse the next __switch_to_xtra().
+	 */
+	local_irq_disable();
 	debugctl = get_debugctlmsr();
 	if (on) {
 		debugctl |= DEBUGCTLMSR_BTF;
@@ -169,7 +179,9 @@ static void set_task_blockstep(struct task_struct *task, bool on)
 		debugctl &= ~DEBUGCTLMSR_BTF;
 		clear_tsk_thread_flag(task, TIF_BLOCKSTEP);
 	}
-	update_debugctlmsr(debugctl);
+	if (task == current)
+		update_debugctlmsr(debugctl);
+	local_irq_enable();
 }
 
 /*
-- 
1.8.1.2

