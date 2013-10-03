Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3JCRup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:50:45 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26758 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754493Ab3JCRun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:50:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/1ZywmHztHccia5CcATLWl
Date: Thu, 3 Oct 2013 10:50:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, Grygorii Strashko <grygorii.strashko@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
Message-ID: <20131003175039.GL8949@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
 <20131003054221.8941.87801.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131003054221.8941.87801.stgit@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [131002 22:51]:
> --- a/drivers/pinctrl/pinctrl-single.c
> +++ b/drivers/pinctrl/pinctrl-single.c
> +/**
> + * pcs_irq_set() - enables or disables an interrupt
> + *
> + * Note that this currently assumes one interrupt per pinctrl
> + * register that is typically used for wake-up events.
> + */
> +static inline void pcs_irq_set(struct pcs_soc_data *pcs_soc,
> +			       int irq, const bool enable)
> +{
> +	struct pcs_device *pcs;
> +	struct list_head *pos;
> +	unsigned mask;
> +
> +	pcs = container_of(pcs_soc, struct pcs_device, socdata);
> +	list_for_each(pos, &pcs->irqs) {
> +		struct pcs_interrupt *pcswi;
> +		unsigned soc_mask;
> +
> +		pcswi = list_entry(pos, struct pcs_interrupt, node);
> +		if (irq != pcswi->hwirq)
> +			continue;

Oops, this should be pcswi->irq instead, otherwise this will
never match. And it just happened to work for me as I had
the wake-up flags set from the bootloader..

> +		soc_mask = pcs_soc->irq_enable_mask;
> +		raw_spin_lock(&pcs->lock);
> +		mask = pcs->read(pcswi->reg);
> +		if (enable)
> +			mask &= ~soc_mask;
> +		else
> +			mask |= soc_mask;
> +		pcs->write(mask, pcswi->reg);
> +		raw_spin_unlock(&pcs->lock);
> +	}
> +}

And then the if (enable) mask needs to be swapped around for
this to work when the wake up events are not set by the
bootloader :)

> +static void pcs_irq_chain_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct pcs_soc_data *pcs_soc = irq_desc_get_handler_data(desc);
> +	struct irq_chip *chip;
> +	int res;
> +
> +	chip = irq_get_chip(irq);
> +	chained_irq_enter(chip, desc);
> +	res = pcs_irq_handle(pcs_soc);
> +	if (!res)
> +		handle_bad_irq(irq, desc);
> +	chained_irq_exit(chip, desc);
> +
> +	return;
> +}

Looks like handle_bad_irq is not exported for modules, so I've
just made it into a comment for now.

> +	/* FIXME: Test rmmod */

And this can be removed now, I've briefly tested it as a
loadable module by not claiming any pins.

Updated patch below,

Tony

8<---------------------

From: Tony Lindgren <tony@atomide.com>
Date: Wed, 2 Oct 2013 21:39:40 -0700
Subject: [PATCH] pinctrl: single: Add support for wake-up interrupts
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The pin control registers can have interrupts for example
for device wake-up. These interrupts can be treated as a
chained interrupt controller as suggested earlier by
Linus Walleij <linus.walleij@linaro.org>.

This patch adds support for interrupts in a way that
should be pretty generic, and works for the omaps that
support wake-up interrupts. On omaps, there's an
interrupt enable and interrupt status bit for each pin.
The two pinctrl domains on omaps share a single interrupt
from the PRM chained interrupt handler. Support for
other similar hardware should be easy to add.

Note that this patch does not attempt to handle the
wake-up interrupts automatically unlike the earlier
patches. This patch allows the device drivers to do
a request_irq() on the wake-up pins as needed. I'll
try to do also a separate generic patch for handling
the wake-up events automatically.

Also note that as this patch makes the pinctrl-single
an irq controller, the current bindings need some
extra trickery to use interrupts from two different
interrupt controllers for the same driver. So it
might be worth waiting a little on the patches
enabling the wake-up interrupts from drivers as there
should be a generic way to handle it coming. And also
there's been discussion of interrupts-extended binding
for using interrupts from multiple interrupt controllers.

In any case, this patch should be ready to go allowing
handling the wake-up interrupts in a generic way, or
separately from the device drivers.

Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Prakash Manjunathappa <prakash.pm@ti.com>
Cc: Roger Quadros <rogerq@ti.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Cc: Benoît Cousson <bcousson@baylibre.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
index 5a02e30..7069a0b 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
@@ -72,6 +72,13 @@ Optional properties:
 		/* pin base, nr pins & gpio function */
 		pinctrl-single,gpio-range = <&range 0 3 0 &range 3 9 1>;
 
+- interrupt-controller : standard interrupt controller binding if using
+  interrupts for wake-up events for example. In this case pinctrl-single
+  is set up as a chained interrupt controller and the wake-up interrupts
+  can be requested by the drivers using request_irq().
+
+- #interrupt-cells : standard interrupt binding if using interrupts
+
 This driver assumes that there is only one register for each pin (unless the
 pinctrl-single,bit-per-mux is set), and uses the common pinctrl bindings as
 specified in the pinctrl-bindings.txt document in this directory.
@@ -121,6 +128,8 @@ pmx_core: pinmux@4a100040 {
 	reg = <0x4a100040 0x0196>;
 	#address-cells = <1>;
 	#size-cells = <0>;
+	#interrupt-cells = <1>;
+	interrupt-controller;
 	pinctrl-single,register-width = <16>;
 	pinctrl-single,function-mask = <0xffff>;
 };
@@ -131,6 +140,8 @@ pmx_wkup: pinmux@4a31e040 {
 	reg = <0x4a31e040 0x0038>;
 	#address-cells = <1>;
 	#size-cells = <0>;
+	#interrupt-cells = <1>;
+	interrupt-controller;
 	pinctrl-single,register-width = <16>;
 	pinctrl-single,function-mask = <0xffff>;
 };
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index f88d3d1..dad65df 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -15,10 +15,14 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/list.h>
+#include <linux/interrupt.h>
+
+#include <linux/irqchip/chained_irq.h>
 
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
@@ -152,9 +156,15 @@ struct pcs_name {
 /**
  * struct pcs_soc_data - SoC specific settings
  * @flags:	initial SoC specific PCS_FEAT_xxx values
+ * @irq:	optional interrupt for the controller
+ * @irq_enable_mask:	optional SoC specific interrupt enable mask
+ * @irq_status_mask:	optional SoC specific interrupt status mask
  */
 struct pcs_soc_data {
 	unsigned flags;
+	int irq;
+	unsigned irq_enable_mask;
+	unsigned irq_status_mask;
 };
 
 /**
@@ -165,6 +175,7 @@ struct pcs_soc_data {
  * @dev:	device entry
  * @pctl:	pin controller device
  * @flags:	mask of PCS_FEAT_xxx values
+ * @lock:	spinlock for register access
  * @mutex:	mutex protecting the lists
  * @width:	bits per mux register
  * @fmask:	function register mask
@@ -179,6 +190,9 @@ struct pcs_soc_data {
  * @pingroups:	list of pingroups
  * @functions:	list of functions
  * @gpiofuncs:	list of gpio functions
+ * @irqs:	list of interrupt registers
+ * @chip:	chip container for this instance
+ * @domain:	IRQ domain for this instance
  * @ngroups:	number of pingroups
  * @nfuncs:	number of functions
  * @desc:	pin controller descriptor
@@ -192,7 +206,11 @@ struct pcs_device {
 	struct device *dev;
 	struct pinctrl_dev *pctl;
 	unsigned flags;
+#define PCS_QUIRK_SHARED_IRQ	(1 << 2)
+#define PCS_FEAT_IRQ		(1 << 1)
 #define PCS_FEAT_PINCONF	(1 << 0)
+	struct pcs_soc_data socdata;
+	raw_spinlock_t lock;
 	struct mutex mutex;
 	unsigned width;
 	unsigned fmask;
@@ -208,6 +226,9 @@ struct pcs_device {
 	struct list_head pingroups;
 	struct list_head functions;
 	struct list_head gpiofuncs;
+	struct list_head irqs;
+	struct irq_chip chip;
+	struct irq_domain *domain;
 	unsigned ngroups;
 	unsigned nfuncs;
 	struct pinctrl_desc desc;
@@ -215,6 +236,8 @@ struct pcs_device {
 	void (*write)(unsigned val, void __iomem *reg);
 };
 
+#define PCS_QUIRK_HAS_SHARED_IRQ	(pcs->flags & PCS_QUIRK_SHARED_IRQ)
+#define PCS_HAS_IRQ		(pcs->flags & PCS_FEAT_IRQ)
 #define PCS_HAS_PINCONF		(pcs->flags & PCS_FEAT_PINCONF)
 
 static int pcs_pinconf_get(struct pinctrl_dev *pctldev, unsigned pin,
@@ -440,9 +463,11 @@ static int pcs_enable(struct pinctrl_dev *pctldev, unsigned fselector,
 
 	for (i = 0; i < func->nvals; i++) {
 		struct pcs_func_vals *vals;
+		unsigned long flags;
 		unsigned val, mask;
 
 		vals = &func->vals[i];
+		raw_spin_lock_irqsave(&pcs->lock, flags);
 		val = pcs->read(vals->reg);
 
 		if (pcs->bits_per_mux)
@@ -453,6 +478,7 @@ static int pcs_enable(struct pinctrl_dev *pctldev, unsigned fselector,
 		val &= ~mask;
 		val |= (vals->val & mask);
 		pcs->write(val, vals->reg);
+		raw_spin_unlock_irqrestore(&pcs->lock, flags);
 	}
 
 	return 0;
@@ -494,13 +520,16 @@ static void pcs_disable(struct pinctrl_dev *pctldev, unsigned fselector,
 
 	for (i = 0; i < func->nvals; i++) {
 		struct pcs_func_vals *vals;
+		unsigned long flags;
 		unsigned val;
 
 		vals = &func->vals[i];
+		raw_spin_lock_irqsave(&pcs->lock, flags);
 		val = pcs->read(vals->reg);
 		val &= ~pcs->fmask;
 		val |= pcs->foff << pcs->fshift;
 		pcs->write(val, vals->reg);
+		raw_spin_unlock_irqrestore(&pcs->lock, flags);
 	}
 }
 
@@ -1451,11 +1480,33 @@ static void pcs_free_pingroups(struct pcs_device *pcs)
 }
 
 /**
+ * pcs_irq_free() - free interrupt
+ * @pcs: pcs driver instance
+ */
+static void pcs_irq_free(struct pcs_device *pcs)
+{
+	struct pcs_soc_data *pcs_soc = &pcs->socdata;
+
+	if (pcs_soc->irq < 0)
+		return;
+
+	if (pcs->domain)
+		irq_domain_remove(pcs->domain);
+
+	if (PCS_QUIRK_HAS_SHARED_IRQ)
+		free_irq(pcs_soc->irq, pcs_soc);
+	else
+		irq_set_chained_handler(pcs_soc->irq, NULL);
+}
+
+/**
  * pcs_free_resources() - free memory used by this driver
  * @pcs: pcs driver instance
  */
 static void pcs_free_resources(struct pcs_device *pcs)
 {
+	pcs_irq_free(pcs);
+
 	if (pcs->pctl)
 		pinctrl_unregister(pcs->pctl);
 
@@ -1504,6 +1555,256 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 	}
 	return ret;
 }
+/**
+ * @reg:	virtual address of interrupt register
+ * @hwirq:	hardware irq number
+ * @irq:	virtual irq number
+ * @node:	list node
+ */
+struct pcs_interrupt {
+	void __iomem *reg;
+	irq_hw_number_t hwirq;
+	unsigned int irq;
+	struct list_head node;
+};
+
+/**
+ * pcs_irq_set() - enables or disables an interrupt
+ *
+ * Note that this currently assumes one interrupt per pinctrl
+ * register that is typically used for wake-up events.
+ */
+static inline void pcs_irq_set(struct pcs_soc_data *pcs_soc,
+			       int irq, const bool enable)
+{
+	struct pcs_device *pcs;
+	struct list_head *pos;
+	unsigned mask;
+
+	pcs = container_of(pcs_soc, struct pcs_device, socdata);
+	list_for_each(pos, &pcs->irqs) {
+		struct pcs_interrupt *pcswi;
+		unsigned soc_mask;
+
+		pcswi = list_entry(pos, struct pcs_interrupt, node);
+		if (irq != pcswi->irq)
+			continue;
+
+		soc_mask = pcs_soc->irq_enable_mask;
+		raw_spin_lock(&pcs->lock);
+		mask = pcs->read(pcswi->reg);
+		if (enable)
+			mask |= soc_mask;
+		else
+			mask &= ~soc_mask;
+		pcs->write(mask, pcswi->reg);
+		raw_spin_unlock(&pcs->lock);
+	}
+}
+
+/**
+ * pcs_irq_mask() - mask pinctrl interrupt
+ * @d: interrupt data
+ */
+static void pcs_irq_mask(struct irq_data *d)
+{
+	struct pcs_soc_data *pcs_soc = irq_data_get_irq_chip_data(d);
+
+	pcs_irq_set(pcs_soc, d->irq, false);
+}
+
+/**
+ * pcs_irq_unmask() - unmask pinctrl interrupt
+ * @d: interrupt data
+ */
+static void pcs_irq_unmask(struct irq_data *d)
+{
+	struct pcs_soc_data *pcs_soc = irq_data_get_irq_chip_data(d);
+
+	pcs_irq_set(pcs_soc, d->irq, true);
+}
+
+/**
+ * pcs_irq_set_wake() - toggle the suspend and resume wake up
+ * @d: interrupt data
+ * @state: wake-up state
+ *
+ * Note that this should be called only for suspend and resume.
+ * For runtime PM, the wake-up events should be enabled by default.
+ */
+static int pcs_irq_set_wake(struct irq_data *d, unsigned int state)
+{
+	if (state)
+		pcs_irq_unmask(d);
+	else
+		pcs_irq_mask(d);
+
+	return 0;
+}
+
+/**
+ * pcs_irq_handle() - common interrupt handler
+ * @pcs_irq: interrupt data
+ *
+ * Note that this currently assumes we have one interrupt bit per
+ * mux register. This interrupt is typically used for wake-up events.
+ * For more complex interrupts different handlers can be specified.
+ */
+static int pcs_irq_handle(struct pcs_soc_data *pcs_soc)
+{
+	struct pcs_device *pcs;
+	struct list_head *pos;
+	int count = 0;
+
+	pcs = container_of(pcs_soc, struct pcs_device, socdata);
+	list_for_each(pos, &pcs->irqs) {
+		struct pcs_interrupt *pcswi;
+		unsigned mask;
+
+		pcswi = list_entry(pos, struct pcs_interrupt, node);
+		raw_spin_lock(&pcs->lock);
+		mask = pcs->read(pcswi->reg);
+		raw_spin_unlock(&pcs->lock);
+		if (mask & pcs_soc->irq_status_mask) {
+			generic_handle_irq(irq_find_mapping(pcs->domain,
+							    pcswi->hwirq));
+			count++;
+		}
+	}
+
+	return count;
+}
+
+/**
+ * pcs_irq_handler() - handler for the shared interrupt case
+ * @irq: interrupt
+ * @d: data
+ *
+ * Use this for cases where multiple instances of
+ * pinctrl-single share a single interrupt like on omaps.
+ */
+static irqreturn_t pcs_irq_handler(int irq, void *d)
+{
+	struct pcs_soc_data *pcs_soc = d;
+
+	return pcs_irq_handle(pcs_soc) ? IRQ_HANDLED : IRQ_NONE;
+}
+
+/**
+ * pcs_irq_handle() - handler for the dedicated chained interrupt case
+ * @irq: interrupt
+ * @desc: interrupt descriptor
+ *
+ * Use this if you have a separate interrupt for each
+ * pinctrl-single instance.
+ */
+static void pcs_irq_chain_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct pcs_soc_data *pcs_soc = irq_desc_get_handler_data(desc);
+	struct irq_chip *chip;
+	int res;
+
+	chip = irq_get_chip(irq);
+	chained_irq_enter(chip, desc);
+	res = pcs_irq_handle(pcs_soc);
+	/* REVISIT: export and add handle_bad_irq(irq, desc)? */
+	chained_irq_exit(chip, desc);
+
+	return;
+}
+
+static int pcs_irqdomain_map(struct irq_domain *d, unsigned int irq,
+			     irq_hw_number_t hwirq)
+{
+	struct pcs_soc_data *pcs_soc = d->host_data;
+	struct pcs_device *pcs;
+	struct pcs_interrupt *pcswi;
+
+	pcs = container_of(pcs_soc, struct pcs_device, socdata);
+	pcswi = devm_kzalloc(pcs->dev, sizeof(*pcswi), GFP_KERNEL);
+	if (!pcswi)
+		return -ENOMEM;
+
+	pcswi->reg = pcs->base + hwirq;
+	pcswi->hwirq = hwirq;
+	pcswi->irq = irq;
+
+	mutex_lock(&pcs->mutex);
+	list_add_tail(&pcswi->node, &pcs->irqs);
+	mutex_unlock(&pcs->mutex);
+
+	irq_set_chip_data(irq, pcs_soc);
+	irq_set_chip_and_handler(irq, &pcs->chip,
+				 handle_level_irq);
+	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+
+	return 0;
+}
+
+static struct irq_domain_ops pcs_irqdomain_ops = {
+	.map = pcs_irqdomain_map,
+	.xlate = irq_domain_xlate_onecell,
+};
+
+/**
+ * pcs_irq_init_chained_handler() - set up a chained interrupt handler
+ * @pcs: pcs driver instance
+ * @np: device node pointer
+ */
+static int pcs_irq_init_chained_handler(struct pcs_device *pcs,
+					struct device_node *np)
+{
+	struct pcs_soc_data *pcs_soc = &pcs->socdata;
+	const char *name = "pinctrl";
+	int num_irqs;
+
+	if (!pcs_soc->irq_enable_mask ||
+	    !pcs_soc->irq_status_mask) {
+		pcs_soc->irq = -1;
+		return -EINVAL;
+	}
+
+	INIT_LIST_HEAD(&pcs->irqs);
+	pcs->chip.name = name;
+	pcs->chip.irq_ack = pcs_irq_mask;
+	pcs->chip.irq_mask = pcs_irq_mask;
+	pcs->chip.irq_unmask = pcs_irq_unmask;
+	pcs->chip.irq_set_wake = pcs_irq_set_wake;
+
+	if (PCS_QUIRK_HAS_SHARED_IRQ) {
+		int res;
+
+		res = request_irq(pcs_soc->irq, pcs_irq_handler,
+				  IRQF_SHARED | IRQF_NO_SUSPEND,
+				  name, pcs_soc);
+		if (res) {
+			pcs_soc->irq = -1;
+			return res;
+		}
+	} else {
+		irq_set_handler_data(pcs_soc->irq, pcs_soc);
+		irq_set_chained_handler(pcs_soc->irq,
+					pcs_irq_chain_handler);
+	}
+
+	/*
+	 * We can use the register offset as the hardirq
+	 * number as irq_domain_add_simple maps them lazily.
+	 * This way we can easily support more than one
+	 * interrupt per function if needed.
+	 */
+	num_irqs = pcs->size;
+
+	pcs->domain = irq_domain_add_simple(np, num_irqs, 0,
+					    &pcs_irqdomain_ops,
+					    pcs_soc);
+	if (!pcs->domain) {
+		irq_set_chained_handler(pcs_soc->irq, NULL);
+		return -EINVAL;
+	}
+
+	return 0;
+}
 
 #ifdef CONFIG_PM
 static int pinctrl_single_suspend(struct platform_device *pdev,
@@ -1549,12 +1850,14 @@ static int pcs_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	pcs->dev = &pdev->dev;
+	raw_spin_lock_init(&pcs->lock);
 	mutex_init(&pcs->mutex);
 	INIT_LIST_HEAD(&pcs->pingroups);
 	INIT_LIST_HEAD(&pcs->functions);
 	INIT_LIST_HEAD(&pcs->gpiofuncs);
 	soc = match->data;
 	pcs->flags = soc->flags;
+	memcpy(&pcs->socdata, soc, sizeof(*soc));
 
 	PCS_GET_PROP_U32("pinctrl-single,register-width", &pcs->width,
 			 "register width not specified\n");
@@ -1642,6 +1945,16 @@ static int pcs_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto free;
 
+	pcs->socdata.irq = irq_of_parse_and_map(np, 0);
+	if (pcs->socdata.irq)
+		pcs->flags |= PCS_FEAT_IRQ;
+
+	if (PCS_HAS_IRQ) {
+		ret = pcs_irq_init_chained_handler(pcs, np);
+		if (ret < 0)
+			dev_warn(pcs->dev, "initialized with no interrupts\n");
+	}
+
 	dev_info(pcs->dev, "%i pins at pa %p size %u\n",
 		 pcs->desc.npins, pcs->base, pcs->size);
 
@@ -1665,6 +1978,12 @@ static int pcs_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct pcs_soc_data pinctrl_single_omap_wkup = {
+	.flags = PCS_QUIRK_SHARED_IRQ,
+	.irq_enable_mask = (1 << 14),	/* OMAP_WAKEUP_EN */
+	.irq_status_mask = (1 << 15),	/* OMAP_WAKEUP_EVENT */
+};
+
 static const struct pcs_soc_data pinctrl_single = {
 };
 
@@ -1673,6 +1992,9 @@ static const struct pcs_soc_data pinconf_single = {
 };
 
 static struct of_device_id pcs_of_match[] = {
+	{ .compatible = "ti,omap3-padconf", .data = &pinctrl_single_omap_wkup },
+	{ .compatible = "ti,omap4-padconf", .data = &pinctrl_single_omap_wkup },
+	{ .compatible = "ti,omap5-padconf", .data = &pinctrl_single_omap_wkup },
 	{ .compatible = "pinctrl-single", .data = &pinctrl_single },
 	{ .compatible = "pinconf-single", .data = &pinconf_single },
 	{ },
