Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511AbaEGPqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:46:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:48670 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaEGPoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:05 -0400
Message-Id: <20140507154339.811205235@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 27/32] s390: Avoid call to irq_reserve_irqs()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=s390-avoid-call-to-reserve-irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to mark the lower interrupts as reserved in order to
exclude them from dynamic allocation.

Provide arch_dynirq_lower_bound() to exclude the lower space.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
---
 arch/s390/kernel/irq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: tip/arch/s390/kernel/irq.c
===================================================================
--- tip.orig/arch/s390/kernel/irq.c
+++ tip/arch/s390/kernel/irq.c
@@ -92,7 +92,6 @@ static const struct irq_class irqclass_s
 
 void __init init_IRQ(void)
 {
-	irq_reserve_irqs(0, THIN_INTERRUPT);
 	init_cio_interrupts();
 	init_airq_interrupts();
 	init_ext_interrupts();
@@ -151,6 +150,11 @@ out:
 	return 0;
 }
 
+unsigned int arch_dynirq_lower_bound(unsigned int from)
+{
+	return from < THIN_INTERRUPT ? THIN_INTERRUPT : from;
+}
+
 /*
  * Switch to the asynchronous interrupt stack for softirq execution.
  */


