Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3I1SIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:08:42 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:45534 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3I1SIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:08:39 -0400
Date: Sat, 28 Sep 2013 20:08:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fix
Message-ID: <20130928180835.GA6360@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 62d08aec6a9f4b45cc9cba1e3b2855995df133e6 Merge branch 'context_tracking/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks into sched/urgent

A context tracking ARM build and functional fix.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      arm: Fix build error with context tracking calls


 arch/arm/kernel/entry-header.S |  8 ++++----
 kernel/context_tracking.c      | 12 ++++++++++++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index de23a9b..39f89fb 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -329,10 +329,10 @@
 #ifdef CONFIG_CONTEXT_TRACKING
 	.if	\save
 	stmdb   sp!, {r0-r3, ip, lr}
-	bl	user_exit
+	bl	context_tracking_user_exit
 	ldmia	sp!, {r0-r3, ip, lr}
 	.else
-	bl	user_exit
+	bl	context_tracking_user_exit
 	.endif
 #endif
 	.endm
@@ -341,10 +341,10 @@
 #ifdef CONFIG_CONTEXT_TRACKING
 	.if	\save
 	stmdb   sp!, {r0-r3, ip, lr}
-	bl	user_enter
+	bl	context_tracking_user_enter
 	ldmia	sp!, {r0-r3, ip, lr}
 	.else
-	bl	user_enter
+	bl	context_tracking_user_enter
 	.endif
 #endif
 	.endm
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 247091b..859c8df 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -51,6 +51,15 @@ void context_tracking_user_enter(void)
 	unsigned long flags;
 
 	/*
+	 * Repeat the user_enter() check here because some archs may be calling
+	 * this from asm and if no CPU needs context tracking, they shouldn't
+	 * go further. Repeat the check here until they support the static key
+	 * check.
+	 */
+	if (!static_key_false(&context_tracking_enabled))
+		return;
+
+	/*
 	 * Some contexts may involve an exception occuring in an irq,
 	 * leading to that nesting:
 	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
@@ -151,6 +160,9 @@ void context_tracking_user_exit(void)
 {
 	unsigned long flags;
 
+	if (!static_key_false(&context_tracking_enabled))
+		return;
+
 	if (in_interrupt())
 		return;
 
