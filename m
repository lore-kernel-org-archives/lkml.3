Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaCHJPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:15:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:42731 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaCHJPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:15:41 -0500
Date: Sat, 8 Mar 2014 10:15:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irq: Consider a negative return value of irq_startup()
 as an error
In-Reply-To: <CACRpkdZ6D1XfDBdJEcR8G2HWkNcZSfz08Yvx8f0s+CqTUmybkg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1403080857160.18573@ionos.tec.linutronix.de>
References: <1393345719-3707-1-git-send-email-jjhiblot@traphandler.com> <alpine.DEB.2.02.1402262119560.4174@ionos.tec.linutronix.de> <CACRpkdZ6D1XfDBdJEcR8G2HWkNcZSfz08Yvx8f0s+CqTUmybkg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2014, Linus Walleij wrote:
> I'll see what Jean-Jacques comes up with and take it from there unless
> he's interested in taking it all the way.

Thought more about it while trying to come up with a persuasive
argument for the other Linus to take the irq_startup change that late
in the cycle:

Using startup is the wrong point in __setup_irq() because we call
chip->irq_set_type() before we call chip->irq_startup(). And we want
this to be in that order to avoid spurious interrupts.

Proper solution below. That leaves the startup/unmask logic untouched
and provides separate callbacks for this kind of requirements. That
makes it also simpler to have common functions for all gpios as you
don't have to do the mask/unmask dance in startup/shutdown. So you can
simply create gpio_irq_request/release_resources() and let the drivers
add those to their callbacks.

If you agree, I put that into a separate branch based on an upstream
-rc so you can pull it into your gpiolib stuff and work from there.

Thanks,

	tglx

---------------------->
Subject: genirq: Provide irq_request/release_resources chip callbacks
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 08 Mar 2014 08:59:58 +0100

For certain irq types, e.g. gpios, it's necessary to request resources
before starting up the irq.

This might fail so we cannot use the irq_startup() callback because we
might call the irq_set_type() callback before that which does not make
sense when the resource is not available. Calling irq_startup() before
irq_set_type() can lead to spurious interrupts which is not desired
either.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    6 ++++++
 kernel/irq/manage.c |   28 +++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -303,6 +303,10 @@ static inline irq_hw_number_t irqd_to_hw
  * @irq_pm_shutdown:	function called from core code on shutdown once per chip
  * @irq_calc_mask:	Optional function to set irq_data.mask for special cases
  * @irq_print_chip:	optional to print special chip info in show_interrupts
+ * @irq_request_resources:	optional to request resources before calling
+ *				any other callback related to this irq
+ * @irq_release_resources:	optional to release resources acquired with
+ *				irq_request_resources
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -336,6 +340,8 @@ struct irq_chip {
 	void		(*irq_calc_mask)(struct irq_data *data);
 
 	void		(*irq_print_chip)(struct irq_data *data, struct seq_file *p);
+	int		(*irq_request_resources)(struct irq_data *data);
+	void		(*irq_release_resources)(struct irq_data *data);
 
 	unsigned long	flags;
 };
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -897,6 +897,23 @@ static void irq_setup_forced_threading(s
 	}
 }
 
+static int irq_request_resources(struct irq_desc *desc)
+{
+	struct irq_data *d = &desc->irq_data;
+	struct irq_chip *c = d->chip;
+
+	return c->irq_request_resources ? c->irq_request_resources(d) : 0;
+}
+
+static void irq_release_resources(struct irq_desc *desc)
+{
+	struct irq_data *d = &desc->irq_data;
+	struct irq_chip *c = d->chip;
+
+	if (c->irq_release_resources)
+		c->irq_release_resources(d);
+}
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
@@ -1092,6 +1109,13 @@ __setup_irq(unsigned int irq, struct irq
 	}
 
 	if (!shared) {
+		ret = irq_request_resources(desc);
+		if (ret) {
+			pr_err("Failed to request resources for %s (irq %d) on irqchip %s\n",
+			       new->name, irq, desc->irq_data.chip->name);
+			goto out_mask;
+		}
+
 		init_waitqueue_head(&desc->wait_for_threads);
 
 		/* Setup the type (level, edge polarity) if configured: */
@@ -1262,8 +1286,10 @@ static struct irqaction *__free_irq(unsi
 	*action_ptr = action->next;
 
 	/* If this was the last handler, shut down the IRQ line: */
-	if (!desc->action)
+	if (!desc->action) {
 		irq_shutdown(desc);
+		irq_release_resources(desc);
+	}
 
 #ifdef CONFIG_SMP
 	/* make sure affinity_hint is cleaned up */





