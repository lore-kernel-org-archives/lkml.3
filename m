Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3EQVko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:40:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab3EQViG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>
Subject: [ 096/102] parisc: only re-enable interrupts if we need to schedule or deliver signals when returning to userspace
Date: Fri, 17 May 2013 14:36:51 -0700
Message-Id: <20130517213254.314251151@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit c207a76bf155cb5cf24cf849c08f6555e9180594 upstream.

Helge and I have found that we have a kernel stack overflow problem
which causes a variety of random failures.
Currently, we re-enable interrupts when returning from an external
interrupt incase we need to schedule or delivery
signals.  As a result, a potentially unlimited number of interrupts
can occur while we are running on the kernel
stack.  It is very limited in space (currently, 16k).  This change
defers enabling interrupts until we have
actually decided to schedule or delivery signals.  This only occurs
when we about to return to userspace.  This
limits the number of interrupts on the kernel stack to one.  In other
cases, interrupts remain disabled until the
final return from interrupt (rfi).

Signed-off-by: John David Anglin  <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/entry.S |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -825,11 +825,6 @@ ENTRY(syscall_exit_rfi)
 	STREG   %r19,PT_SR7(%r16)
 
 intr_return:
-	/* NOTE: Need to enable interrupts incase we schedule. */
-	ssm     PSW_SM_I, %r0
-
-intr_check_resched:
-
 	/* check for reschedule */
 	mfctl   %cr30,%r1
 	LDREG   TI_FLAGS(%r1),%r19	/* sched.h: TIF_NEED_RESCHED */
@@ -856,6 +851,11 @@ intr_check_sig:
 	LDREG	PT_IASQ1(%r16), %r20
 	cmpib,COND(=),n 0,%r20,intr_restore /* backward */
 
+	/* NOTE: We need to enable interrupts if we have to deliver
+	 * signals. We used to do this earlier but it caused kernel
+	 * stack overflows. */
+	ssm     PSW_SM_I, %r0
+
 	copy	%r0, %r25			/* long in_syscall = 0 */
 #ifdef CONFIG_64BIT
 	ldo	-16(%r30),%r29			/* Reference param save area */
@@ -907,6 +907,10 @@ intr_do_resched:
 	cmpib,COND(=)	0, %r20, intr_do_preempt
 	nop
 
+	/* NOTE: We need to enable interrupts if we schedule.  We used
+	 * to do this earlier but it caused kernel stack overflows. */
+	ssm     PSW_SM_I, %r0
+
 #ifdef CONFIG_64BIT
 	ldo	-16(%r30),%r29		/* Reference param save area */
 #endif


