Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbaCDQsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:48:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41494 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbaCDQk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:40:58 -0500
Date: Tue, 4 Mar 2014 08:40:05 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-b8a9a11b976810ba12a43c4fe699a14892c97e52@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linuxppc-dev@lists.ozlabs.org, peterz@infradead.org,
        benh@kernel.crashing.org, tglx@linutronix.de,
        shangw@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, tglx@linutronix.de,
        shangw@linux.vnet.ibm.com
In-Reply-To: <20140223212736.562906212@linutronix.de>
References: <20140223212736.562906212@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] powerpc: Eeh: Kill another abuse of irq_desc
Git-Commit-ID: b8a9a11b976810ba12a43c4fe699a14892c97e52
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8a9a11b976810ba12a43c4fe699a14892c97e52
Gitweb:     http://git.kernel.org/tip/b8a9a11b976810ba12a43c4fe699a14892c97e52
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:09 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:52 +0100

powerpc: Eeh: Kill another abuse of irq_desc

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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc <linuxppc-dev@lists.ozlabs.org>
Link: http://lkml.kernel.org/r/20140223212736.562906212@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/kernel/eeh_driver.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index fdc679d..3e1d7de 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -143,15 +143,31 @@ static void eeh_disable_irq(struct pci_dev *dev)
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
