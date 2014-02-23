Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaBWVkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:40:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:52192 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaBWVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:01 -0500
Message-Id: <20140223212736.451970660@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ashish Kalra <ashish.kalra@freescale.com>,
        Timur Tabi <timur@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        ppc <linuxppc-dev@lists.ozlabs.org>
Subject: [patch 02/26] powerpc:evh_pic: Kill irq_desc abuse
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=power-evh-pic-kill-irq-desc-abuse.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm really grumpy about this one. The line:

#include "../../../kernel/irq/settings.h"

should have been an alarm sign for all people who added their SOB to
this trainwreck.

When I cleaned up the mess people made with interrupt descriptors a
few years ago, I warned that I'm going to hunt down new offenders and
treat them with stinking trouts. In this case I'll use frozen shark
for a better educational value.

The whole idiocy which was done there could have been avoided with two
lines of perfectly fine code. And do not complain about the lack of
correct examples in tree.

The solution is simple:

  Remove the brainfart and use the proper functions, which should
  have been used in the first place

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ashish Kalra <ashish.kalra@freescale.com>
Cc: Timur Tabi <timur@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: ppc <linuxppc-dev@lists.ozlabs.org>
---
 arch/powerpc/sysdev/ehv_pic.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: tip/arch/powerpc/sysdev/ehv_pic.c
===================================================================
--- tip.orig/arch/powerpc/sysdev/ehv_pic.c
+++ tip/arch/powerpc/sysdev/ehv_pic.c
@@ -28,8 +28,6 @@
 #include <asm/ehv_pic.h>
 #include <asm/fsl_hcalls.h>
 
-#include "../../../kernel/irq/settings.h"
-
 static struct ehv_pic *global_ehv_pic;
 static DEFINE_SPINLOCK(ehv_pic_lock);
 
@@ -113,17 +111,13 @@ static unsigned int ehv_pic_type_to_vecp
 int ehv_pic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 {
 	unsigned int src = virq_to_hw(d->irq);
-	struct irq_desc *desc = irq_to_desc(d->irq);
 	unsigned int vecpri, vold, vnew, prio, cpu_dest;
 	unsigned long flags;
 
 	if (flow_type == IRQ_TYPE_NONE)
 		flow_type = IRQ_TYPE_LEVEL_LOW;
 
-	irq_settings_clr_level(desc);
-	irq_settings_set_trigger_mask(desc, flow_type);
-	if (flow_type & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
-		irq_settings_set_level(desc);
+	irqd_set_trigger_type(d, flow_type);
 
 	vecpri = ehv_pic_type_to_vecpri(flow_type);
 
@@ -144,7 +138,7 @@ int ehv_pic_set_irq_type(struct irq_data
 	ev_int_set_config(src, vecpri, prio, cpu_dest);
 
 	spin_unlock_irqrestore(&ehv_pic_lock, flags);
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 static struct irq_chip ehv_pic_irq_chip = {


