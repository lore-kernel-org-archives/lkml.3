Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaFEEmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:42:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbaFEEVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 139/214] ptrace/x86: Introduce set_task_blockstep() helper
Date: Wed,  4 Jun 2014 21:18:22 -0700
Message-Id: <20140605041658.446516319@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/step.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -157,6 +157,21 @@ static int enable_single_step(struct tas
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
@@ -169,19 +184,10 @@ static void enable_step(struct task_stru
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
@@ -199,13 +205,8 @@ void user_disable_single_step(struct tas
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


