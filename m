Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3D2Kkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:40:47 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:52879 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756853Ab3D2Kkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:40:46 -0400
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH v2] openrisc: call do_notify_resume() with interrupts enabled
Date: Mon, 29 Apr 2013 13:40:32 +0300
Message-Id: <1367232032-14270-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130429095040.GA11785@chokladfabriken.org>
References: <20130429095040.GA11785@chokladfabriken.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A signal delivered through do_notify_resume() would cause the
irqs_disabled() check in _local_bh_enable_ip() to be triggered.

Enable interrupts before calling do_notify_resume(), but read
the current_thread_info->flags before doing so.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/kernel/entry.S  | 5 +++--
 arch/openrisc/kernel/signal.c | 7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index d8a455e..7564784 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -858,8 +858,8 @@ _work_pending:
 	 * if (current_thread_info->flags & _TIF_NEED_RESCHED)
 	 *     schedule();
 	 */
-	l.lwz   r5,TI_FLAGS(r10)
-	l.andi	r3,r5,_TIF_NEED_RESCHED
+	l.lwz   r4,TI_FLAGS(r10)
+	l.andi	r3,r4,_TIF_NEED_RESCHED
 	l.sfnei r3,0
 	l.bnf   _work_notifysig
 	 l.nop
@@ -874,6 +874,7 @@ _work_pending:
  * must be set so that the syscall restart functionality works.
  */
 _work_notifysig:
+	ENABLE_INTERRUPTS(r29)
 	l.jal	do_notify_resume
 	 l.ori	r3,r1,0		  /* pt_regs */
 
diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index ae167f7..032bed1 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -331,12 +331,13 @@ void do_signal(struct pt_regs *regs)
 	return;
 }
 
-asmlinkage void do_notify_resume(struct pt_regs *regs)
+asmlinkage void do_notify_resume(struct pt_regs *regs,
+				 unsigned long thread_flags)
 {
-	if (current_thread_info()->flags & _TIF_SIGPENDING)
+	if (thread_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
-	if (current_thread_info()->flags & _TIF_NOTIFY_RESUME) {
+	if (thread_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 	}
-- 
1.8.1.2

