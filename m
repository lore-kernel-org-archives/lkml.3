Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3BQW6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:58:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45816 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755217Ab3BQWzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:44 -0500
Message-Id: <20130217225005.475331641@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:34 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [ 33/66] ptrace/x86: Introduce set_task_blockstep() helper
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 848e8f5f0ad3169560c516fff6471be65f76e69f upstream.

No functional changes, preparation for the next fix and for uprobes
single-step fixes.

Move the code playing with TIF_BLOCKSTEP/DEBUGCTLMSR_BTF into the
new helper, set_task_blockstep().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/step.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index c346d11..7a51498 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -157,6 +157,21 @@ static int enable_single_step(struct task_struct *child)
 	return 1;
 }
 
+static void set_task_blockstep(struct task_struct *task, bool on)
+{
+	unsigned long debugctl;
+
+	debugctl = get_debugctlmsr();
+	if (on) {
+		debugctl |= DEBUGCTLMSR_BTF;
+		set_tsk_thread_flag(task, TIF_BLOCKSTEP);
+	} else {
+		debugctl &= ~DEBUGCTLMSR_BTF;
+		clear_tsk_thread_flag(task, TIF_BLOCKSTEP);
+	}
+	update_debugctlmsr(debugctl);
+}
+
 /*
  * Enable single or block step.
  */
@@ -169,19 +184,10 @@ static void enable_step(struct task_struct *child, bool block)
 	 * So no one should try to use debugger block stepping in a program
 	 * that uses user-mode single stepping itself.
 	 */
-	if (enable_single_step(child) && block) {
-		unsigned long debugctl = get_debugctlmsr();
-
-		debugctl |= DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		set_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	} else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
-		unsigned long debugctl = get_debugctlmsr();
-
-		debugctl &= ~DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		clear_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	}
+	if (enable_single_step(child) && block)
+		set_task_blockstep(child, true);
+	else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP))
+		set_task_blockstep(child, false);
 }
 
 void user_enable_single_step(struct task_struct *child)
@@ -199,13 +205,8 @@ void user_disable_single_step(struct task_struct *child)
 	/*
 	 * Make sure block stepping (BTF) is disabled.
 	 */
-	if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
-		unsigned long debugctl = get_debugctlmsr();
-
-		debugctl &= ~DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		clear_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	}
+	if (test_tsk_thread_flag(child, TIF_BLOCKSTEP))
+		set_task_blockstep(child, false);
 
 	/* Always clear TIF_SINGLESTEP... */
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);


