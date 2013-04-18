Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3DRF1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 01:27:52 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:48832 "EHLO mailhub2.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab3DRF1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 01:27:51 -0400
Date: Thu, 18 Apr 2013 07:26:11 +0200
Message-Id: <201304180526.r3I5QB6v029520@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2] Erroneous double irq_eoi() on CPM IRQ in MPC8xx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_eoi() is already called by generic_handle_irq() so 
it shall not be called a again

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Index: linux/arch/powerpc/platforms/8xx/m8xx_setup.c
===================================================================
--- linux/arch/powerpc/platforms/8xx/m8xx_setup.c	(revision 4802)
+++ linux/arch/powerpc/platforms/8xx/m8xx_setup.c	(working copy)
@@ -218,19 +218,12 @@
 
 static void cpm_cascade(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_chip *chip;
-	int cascade_irq;
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	int cascade_irq = cpm_get_irq();
 
-	if ((cascade_irq = cpm_get_irq()) >= 0) {
-		struct irq_desc *cdesc = irq_to_desc(cascade_irq);
-
+	if (cascade_irq >= 0)
 		generic_handle_irq(cascade_irq);
 
-		chip = irq_desc_get_chip(cdesc);
-		chip->irq_eoi(&cdesc->irq_data);
-	}
-
-	chip = irq_desc_get_chip(desc);
 	chip->irq_eoi(&desc->irq_data);
 }
 
