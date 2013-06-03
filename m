Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab3FCWbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:31:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759938Ab3FCWaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:30:21 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=gsK0YPsXAUsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=smzH-CkWnJsA:10 a=FBHGMhGWAAAA:8 a=KmqCZUEVAza2QQZapJAA:9 a=j9nzo_0lS1QA:10 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=AfjNWNy65zGGqaB8:21 a=HDEnkPoGvyjsxJfZ:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221201.828398198@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>
Subject: [56/65] parisc: only re-enable interrupts if we need to schedule or deliver
 signals when returning to userspace
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0056-parisc-only-re-enable-interrupts-if-we-need-to-sched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit c207a76bf155cb5cf24cf849c08f6555e9180594 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/parisc/kernel/entry.S |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/kernel/entry.S b/arch/parisc/kernel/entry.S
index 18670a0..38a4998 100644
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -909,11 +909,6 @@ ENTRY(syscall_exit_rfi)
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
@@ -940,6 +935,11 @@ intr_check_sig:
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
@@ -991,6 +991,10 @@ intr_do_resched:
 	cmpib,COND(=)	0, %r20, intr_do_preempt
 	nop
 
+	/* NOTE: We need to enable interrupts if we schedule.  We used
+	 * to do this earlier but it caused kernel stack overflows. */
+	ssm     PSW_SM_I, %r0
+
 #ifdef CONFIG_64BIT
 	ldo	-16(%r30),%r29		/* Reference param save area */
 #endif
-- 
1.7.10.4


