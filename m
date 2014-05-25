Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaEYTPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:15:32 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:57563 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaEYTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:15:30 -0400
From: minyard@acm.org
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] arm: Set hardirq tracing to on when idling
Date: Sun, 25 May 2014 14:15:23 -0500
Message-Id: <1401045323-7116-1-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

The CPU will go to idle with interrupts off, but the interrupts
will wake up the idle.  This was causing very long irqsoff trace
values because, basically, the whole idle time was traces with
irqs off, even though they weren't really off.  Rework the idle
code to turn hardirq tracing to on befor calling idle.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 arch/arm/kernel/process.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

I'm not sure this is correct for all ARM boards, but it fixes the
issue for the Vexpress board I have.  No more 4 second irqsoff
times.

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 1ca6cf1..92413af 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -133,11 +133,12 @@ void (*arm_pm_idle)(void);
 
 static void default_idle(void)
 {
+	trace_hardirqs_on();
 	if (arm_pm_idle)
 		arm_pm_idle();
 	else
 		cpu_do_idle();
-	local_irq_enable();
+	raw_local_irq_enable();
 }
 
 void arch_cpu_idle_prepare(void)
-- 
1.8.3.1

