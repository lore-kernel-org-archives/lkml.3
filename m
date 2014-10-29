Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbaJ2K0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:26:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:55483 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaJ2K03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:26:29 -0400
Date: Wed, 29 Oct 2014 11:26:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] genirq: Add support for priority-drop/deactivate
 interrupt controllers
In-Reply-To: <5450BD61.10102@arm.com>
Message-ID: <alpine.DEB.2.11.1410291115310.5308@nanos>
References: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com> <1414235215-10468-2-git-send-email-marc.zyngier@arm.com> <alpine.DEB.2.11.1410252144170.5308@nanos> <544E67D8.3020504@arm.com> <alpine.DEB.2.11.1410272158160.5308@nanos> <544FF183.9030705@arm.com>
 <alpine.DEB.2.11.1410282054490.5308@nanos> <5450BD61.10102@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Marc Zyngier wrote:
> On 28/10/14 20:14, Thomas Gleixner wrote:
> > irq_enable() calls chip->irq_unmask(), i.e. DIR. So that clears the
> > ACTIVE bit and then the IRQ either gets resent by hardware (in case of
> > level as the device interrupt is still active) or retriggered by the
> > irq_retrigger() callback.
> 
> The problem I see here is for an interrupt that has been flagged as
> disabled with irq_disabled(), but that hasn't fired. We'd end up doing a
> DIR on something that hasn't had an EOI first. I think that's the only
> wrinkle in this scheme.

Right. So the untested patch below should do the trick and prevent
irq_enable() to invoke irq_unmask() if the interrupt is not flagged
masked. And it only can be flagged masked if it was masked in the
handler. The startup callback will make sure that irq_enable() is not
invoked at startup time.

Thanks,

	tglx

------------------

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index e5202f00cabc..9c0f73e1994a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -182,7 +182,7 @@ int irq_startup(struct irq_desc *desc, bool resend)
 		ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
 		irq_state_clr_masked(desc);
 	} else {
-		irq_enable(desc);
+		irq_enable(desc, false);
 	}
 	if (resend)
 		check_irq_resend(desc, desc->irq_data.irq);
@@ -202,13 +202,14 @@ void irq_shutdown(struct irq_desc *desc)
 	irq_state_set_masked(desc);
 }
 
-void irq_enable(struct irq_desc *desc)
+void irq_enable(struct irq_desc *desc, bool ifmasked)
 {
 	irq_state_clr_disabled(desc);
-	if (desc->irq_data.chip->irq_enable)
+	if (desc->irq_data.chip->irq_enable) {
 		desc->irq_data.chip->irq_enable(&desc->irq_data);
-	else
+	} else if (!ifmasked || irqd_irq_masked(&desc->irq_data)) {
 		desc->irq_data.chip->irq_unmask(&desc->irq_data);
+	}
 	irq_state_clr_masked(desc);
 }
 
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 4332d766619d..6eff2678cf6d 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -68,7 +68,7 @@ extern void __enable_irq(struct irq_desc *desc, unsigned int irq);
 
 extern int irq_startup(struct irq_desc *desc, bool resend);
 extern void irq_shutdown(struct irq_desc *desc);
-extern void irq_enable(struct irq_desc *desc);
+extern void irq_enable(struct irq_desc *desc, bool ifmasked);
 extern void irq_disable(struct irq_desc *desc);
 extern void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu);
 extern void irq_percpu_disable(struct irq_desc *desc, unsigned int cpu);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a9104b4608b..d8c474608c2d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -448,7 +448,7 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq)
 			goto err_out;
 		/* Prevent probing on this irq: */
 		irq_settings_set_noprobe(desc);
-		irq_enable(desc);
+		irq_enable(desc, true);
 		check_irq_resend(desc, irq);
 		/* fall-through */
 	}
