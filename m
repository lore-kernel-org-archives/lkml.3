Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3I0RQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:16:10 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57328 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3I0RQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:16:09 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Anil Kumar <anilk4.v@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>
Subject: [GIT PULL] arm/context_tracking build fix
Date: Fri, 27 Sep 2013 19:15:59 +0200
Message-Id: <1380302159-10376-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the context_tracking/fixes branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	context_tracking/fixes

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      arm: Fix build error with context tracking calls


 arch/arm/kernel/entry-header.S |  8 ++++----
 kernel/context_tracking.c      | 12 ++++++++++++
 2 files changed, 16 insertions(+), 4 deletions(-)

---
commit 0c06a5d4b13cd66c833805a0d1db76b977944aac
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Tue Sep 10 00:54:17 2013 +0200

    arm: Fix build error with context tracking calls
    
    ad65782fba50 (context_tracking: Optimize main APIs off case
    with static key) converted context tracking main APIs to inline
    function and left ARM asm callers behind.
    
    This can be easily fixed by making ARM calling the post static
    keys context tracking function. We just need to replicate the
    static key checks there. We'll remove these later when ARM will
    support the context tracking static keys.
    
    Reported-by: Guenter Roeck <linux@roeck-us.net>
    Reported-by: Russell King <linux@arm.linux.org.uk>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Tested-by: Kevin Hilman <khilman@linaro.org>
    Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
    Cc: Anil Kumar <anilk4.v@gmail.com>
    Cc: Tony Lindgren <tony@atomide.com>
    Cc: Benoit Cousson <b-cousson@ti.com>
    Cc: Guenter Roeck <linux@roeck-us.net>
    Cc: Russell King <linux@arm.linux.org.uk>
    Cc: Kevin Hilman <khilman@linaro.org>

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
 
