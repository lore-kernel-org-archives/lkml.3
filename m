Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaIAOMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:12:48 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55801 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754016AbaIAOL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:11:26 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: [PATCH 04/13] genirq: Make use of pm misfeature accounting
Date: Mon, 01 Sep 2014 16:22:02 +0200
Message-ID: <1544653.nbssNZd6vM@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2516134.pmOxkEuOOy@vostro.rjw.lan>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <5320472.coYotHR1d0@vostro.rjw.lan> <2516134.pmOxkEuOOy@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Use the accounting fields which got introduced for snity checking for
the various PM options.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/irq/pm.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux/kernel/irq/pm.c
===================================================================
--- linux.orig/kernel/irq/pm.c
+++ linux/kernel/irq/pm.c
@@ -51,7 +51,7 @@ void irq_pm_remove_action(struct irq_des
 
 static void suspend_device_irq(struct irq_desc *desc, int irq)
 {
-	if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
+	if (!desc->action || desc->no_suspend_depth)
 		return;
 
 	desc->istate |= IRQS_SUSPENDED;
@@ -94,11 +94,8 @@ static void resume_irq(struct irq_desc *
 	if (desc->istate & IRQS_SUSPENDED)
 		goto resume;
 
-	if (!desc->action)
-		return;
-
-	/* Interrupts marked with that flag are force reenabled */
-	if (!(desc->action->flags & IRQF_FORCE_RESUME))
+	/* Force resume the interrupt? */
+	if (!desc->force_resume_depth)
 		return;
 
 	/* Pretend that it got disabled ! */

