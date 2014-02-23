Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaBWVkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:40:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:52197 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaBWVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:02 -0500
Message-Id: <20140223212736.562906212@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc <linuxppc-dev@lists.ozlabs.org>
Subject: [patch 03/26] powerpc: eeh: Kill another abuse of irq_desc
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline;
 filename=powerpc-eeh-kill-more-abuse-of-irq-desc.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 91150af3a (powerpc/eeh: Fix unbalanced enable for IRQ) is
another brilliant example of trainwreck engineering.

The patch "fixes" the issue of an unbalanced call to irq_enable()
which causes a prominent warning by checking the disabled state of the
interrupt line and call conditionally into the core code.

This is wrong in two aspects:

1) The warning is there to tell users, that they need to fix their
   asymetric enable/disable patterns by finding the root cause and
   solving it there.

   It's definitely not meant to work around it by conditionally
   calling into the core code depending on the random state of the irq
   line.

   Asymetric irq_disable/enable calls are a clear sign of wrong usage
   of the interfaces which have to be cured at the root and not by
   somehow hacking around it.

2) The abuse of core internal data structure instead of using the
   proper interfaces for retrieving the information for the 'hack
   around'

   irq_desc is core internal and it's clear enough stated.

Replace at least the irq_desc abuse with the proper functions and add
a big fat comment why this is absurd and completely wrong.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc <linuxppc-dev@lists.ozlabs.org>
---
 arch/powerpc/kernel/eeh_driver.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

Index: tip/arch/powerpc/kernel/eeh_driver.c
===================================================================
--- tip.orig/arch/powerpc/kernel/eeh_driver.c
+++ tip/arch/powerpc/kernel/eeh_driver.c
@@ -143,15 +143,31 @@ static void eeh_disable_irq(struct pci_d
 static void eeh_enable_irq(struct pci_dev *dev)
 {
 	struct eeh_dev *edev = pci_dev_to_eeh_dev(dev);
-	struct irq_desc *desc;
 
 	if ((edev->mode) & EEH_DEV_IRQ_DISABLED) {
 		edev->mode &= ~EEH_DEV_IRQ_DISABLED;
-
-		desc = irq_to_desc(dev->irq);
-		if (desc && desc->depth > 0)
+		/*
+		 * FIXME !!!!!
+		 *
+		 * This is just ass backwards. This maze has
+		 * unbalanced irq_enable/disable calls. So instead of
+		 * finding the root cause it works around the warning
+		 * in the irq_enable code by conditionally calling
+		 * into it.
+		 *
+		 * That's just wrong.The warning in the core code is
+		 * there to tell people to fix their assymetries in
+		 * their own code, not by abusing the core information
+		 * to avoid it.
+		 *
+		 * I so wish that the assymetry would be the other way
+		 * round and a few more irq_disable calls render that
+		 * shit unusable forever.
+		 *
+		 *	tglx
+		 */
+		if (irqd_irq_disabled(irq_get_irq_data(dev->irq))
 			enable_irq(dev->irq);
-	}
 }
 
 /**


