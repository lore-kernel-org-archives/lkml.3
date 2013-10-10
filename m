Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3JJNYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:24:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55897 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab3JJNYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:24:43 -0400
Message-ID: <5256AA7F.8030005@ti.com>
Date: Thu, 10 Oct 2013 16:24:15 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <bcousson@baylibre.com>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
References: <20131003054104.8941.88857.stgit@localhost> <20131003054221.8941.87801.stgit@localhost>
In-Reply-To: <20131003054221.8941.87801.stgit@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 10/03/2013 08:42 AM, Tony Lindgren wrote:
> The pin control registers can have interrupts for example
> for device wake-up. These interrupts can be treated as a
> chained interrupt controller as suggested earlier by
> Linus Walleij <linus.walleij@linaro.org>.
> 
> This patch adds support for interrupts in a way that
> should be pretty generic, and works for the omaps that
> support wake-up interrupts. On omaps, there's an
> interrupt enable and interrupt status bit for each pin.
> The two pinctrl domains on omaps share a single interrupt
> from the PRM chained interrupt handler. Support for
> other similar hardware should be easy to add.
> 
> Note that this patch does not attempt to handle the
> wake-up interrupts automatically unlike the earlier
> patches. This patch allows the device drivers to do
> a request_irq() on the wake-up pins as needed. I'll
> try to do also a separate generic patch for handling
> the wake-up events automatically.
> 
> Also note that as this patch makes the pinctrl-single
> an irq controller, the current bindings need some
> extra trickery to use interrupts from two different
> interrupt controllers for the same driver. So it
> might be worth waiting a little on the patches
> enabling the wake-up interrupts from drivers as there
> should be a generic way to handle it coming. And also
> there's been discussion of interrupts-extended binding
> for using interrupts from multiple interrupt controllers.
> 
> In any case, this patch should be ready to go allowing
> handling the wake-up interrupts in a generic way, or
> separately from the device drivers.
> 
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: Prakash Manjunathappa <prakash.pm@ti.com>
> Cc: Roger Quadros <rogerq@ti.com>
> Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: Benoît Cousson <bcousson@baylibre.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  .../devicetree/bindings/pinctrl/pinctrl-single.txt |   11 +
>  drivers/pinctrl/pinctrl-single.c                   |  325 ++++++++++++++++++++
>  2 files changed, 336 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> index 5a02e30..7069a0b 100644
> --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> @@ -72,6 +72,13 @@ Optional properties:
>  		/* pin base, nr pins & gpio function */
>  		pinctrl-single,gpio-range = <&range 0 3 0 &range 3 9 1>;
>  
> +- interrupt-controller : standard interrupt controller binding if using
> +  interrupts for wake-up events for example. In this case pinctrl-single
> +  is set up as a chained interrupt controller and the wake-up interrupts
> +  can be requested by the drivers using request_irq().
> +
> +- #interrupt-cells : standard interrupt binding if using interrupts
> +
>  This driver assumes that there is only one register for each pin (unless the
>  pinctrl-single,bit-per-mux is set), and uses the common pinctrl bindings as
>  specified in the pinctrl-bindings.txt document in this directory.
> @@ -121,6 +128,8 @@ pmx_core: pinmux@4a100040 {
>  	reg = <0x4a100040 0x0196>;
>  	#address-cells = <1>;
>  	#size-cells = <0>;
> +	#interrupt-cells = <1>;
> +	interrupt-controller;
>  	pinctrl-single,register-width = <16>;
>  	pinctrl-single,function-mask = <0xffff>;
>  };
> @@ -131,6 +140,8 @@ pmx_wkup: pinmux@4a31e040 {
>  	reg = <0x4a31e040 0x0038>;
>  	#address-cells = <1>;
>  	#size-cells = <0>;
> +	#interrupt-cells = <1>;
> +	interrupt-controller;
>  	pinctrl-single,register-width = <16>;
>  	pinctrl-single,function-mask = <0xffff>;
>  };
> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
> index f88d3d1..b4ff055 100644
> --- a/drivers/pinctrl/pinctrl-single.c
> +++ b/drivers/pinctrl/pinctrl-single.c
> @@ -15,10 +15,14 @@
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/list.h>
> +#include <linux/interrupt.h>
> +
> +#include <linux/irqchip/chained_irq.h>
>  
>  #include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/of_address.h>
> +#include <linux/of_irq.h>
>  
>  #include <linux/pinctrl/pinctrl.h>
>  #include <linux/pinctrl/pinmux.h>
> @@ -152,9 +156,15 @@ struct pcs_name {
>  /**
>   * struct pcs_soc_data - SoC specific settings
>   * @flags:	initial SoC specific PCS_FEAT_xxx values
> + * @irq:	optional interrupt for the controller
> + * @irq_enable_mask:	optional SoC specific interrupt enable mask
> + * @irq_status_mask:	optional SoC specific interrupt status mask
>   */
>  struct pcs_soc_data {
>  	unsigned flags;
> +	int irq;
> +	unsigned irq_enable_mask;
> +	unsigned irq_status_mask;
>  };
>  
>  /**
> @@ -165,6 +175,7 @@ struct pcs_soc_data {
>   * @dev:	device entry
>   * @pctl:	pin controller device
>   * @flags:	mask of PCS_FEAT_xxx values
> + * @lock:	spinlock for register access
>   * @mutex:	mutex protecting the lists
>   * @width:	bits per mux register
>   * @fmask:	function register mask
> @@ -179,6 +190,9 @@ struct pcs_soc_data {
>   * @pingroups:	list of pingroups
>   * @functions:	list of functions
>   * @gpiofuncs:	list of gpio functions
> + * @irqs:	list of interrupt registers
> + * @chip:	chip container for this instance
> + * @domain:	IRQ domain for this instance
>   * @ngroups:	number of pingroups
>   * @nfuncs:	number of functions
>   * @desc:	pin controller descriptor
> @@ -192,7 +206,11 @@ struct pcs_device {
>  	struct device *dev;
>  	struct pinctrl_dev *pctl;
>  	unsigned flags;
> +#define PCS_QUIRK_SHARED_IRQ	(1 << 2)
> +#define PCS_FEAT_IRQ		(1 << 1)
>  #define PCS_FEAT_PINCONF	(1 << 0)
> +	struct pcs_soc_data socdata;
> +	raw_spinlock_t lock;
>  	struct mutex mutex;
>  	unsigned width;
>  	unsigned fmask;
> @@ -208,6 +226,9 @@ struct pcs_device {
>  	struct list_head pingroups;
>  	struct list_head functions;
>  	struct list_head gpiofuncs;
> +	struct list_head irqs;
> +	struct irq_chip chip;
> +	struct irq_domain *domain;
>  	unsigned ngroups;
>  	unsigned nfuncs;
>  	struct pinctrl_desc desc;
> @@ -215,6 +236,8 @@ struct pcs_device {
>  	void (*write)(unsigned val, void __iomem *reg);
>  };
>  
> +#define PCS_QUIRK_HAS_SHARED_IRQ	(pcs->flags & PCS_QUIRK_SHARED_IRQ)
> +#define PCS_HAS_IRQ		(pcs->flags & PCS_FEAT_IRQ)
>  #define PCS_HAS_PINCONF		(pcs->flags & PCS_FEAT_PINCONF)
>  
>  static int pcs_pinconf_get(struct pinctrl_dev *pctldev, unsigned pin,
> @@ -440,9 +463,11 @@ static int pcs_enable(struct pinctrl_dev *pctldev, unsigned fselector,
>  
>  	for (i = 0; i < func->nvals; i++) {
>  		struct pcs_func_vals *vals;
> +		unsigned long flags;
>  		unsigned val, mask;
>  
>  		vals = &func->vals[i];
> +		raw_spin_lock_irqsave(&pcs->lock, flags);
>  		val = pcs->read(vals->reg);
>  
>  		if (pcs->bits_per_mux)
> @@ -453,6 +478,7 @@ static int pcs_enable(struct pinctrl_dev *pctldev, unsigned fselector,
>  		val &= ~mask;
>  		val |= (vals->val & mask);
>  		pcs->write(val, vals->reg);
> +		raw_spin_unlock_irqrestore(&pcs->lock, flags);
>  	}
>  
>  	return 0;
> @@ -494,13 +520,16 @@ static void pcs_disable(struct pinctrl_dev *pctldev, unsigned fselector,
>  
>  	for (i = 0; i < func->nvals; i++) {
>  		struct pcs_func_vals *vals;
> +		unsigned long flags;
>  		unsigned val;
>  
>  		vals = &func->vals[i];
> +		raw_spin_lock_irqsave(&pcs->lock, flags);
>  		val = pcs->read(vals->reg);
>  		val &= ~pcs->fmask;
>  		val |= pcs->foff << pcs->fshift;
>  		pcs->write(val, vals->reg);
> +		raw_spin_unlock_irqrestore(&pcs->lock, flags);
>  	}
>  }
>  
> @@ -1451,11 +1480,33 @@ static void pcs_free_pingroups(struct pcs_device *pcs)
>  }
>  
>  /**
> + * pcs_irq_free() - free interrupt
> + * @pcs: pcs driver instance
> + */
> +static void pcs_irq_free(struct pcs_device *pcs)
> +{
> +	struct pcs_soc_data *pcs_soc = &pcs->socdata;
> +
> +	if (pcs_soc->irq < 0)
> +		return;
> +
> +	if (pcs->domain)
> +		irq_domain_remove(pcs->domain);
> +
> +	if (PCS_QUIRK_HAS_SHARED_IRQ)
> +		free_irq(pcs_soc->irq, pcs_soc);
> +	else
> +		irq_set_chained_handler(pcs_soc->irq, NULL);
> +}
> +
> +/**
>   * pcs_free_resources() - free memory used by this driver
>   * @pcs: pcs driver instance
>   */
>  static void pcs_free_resources(struct pcs_device *pcs)
>  {
> +	pcs_irq_free(pcs);
> +
>  	if (pcs->pctl)
>  		pinctrl_unregister(pcs->pctl);
>  
> @@ -1504,6 +1555,259 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
>  	}
>  	return ret;
>  }
> +/**
> + * @reg:	virtual address of interrupt register
> + * @hwirq:	hardware irq number
> + * @irq:	virtual irq number
> + * @node:	list node
> + */
> +struct pcs_interrupt {
> +	void __iomem *reg;
> +	irq_hw_number_t hwirq;
> +	unsigned int irq;
> +	struct list_head node;
> +};
> +
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
> +
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
> +
> +/**
> + * pcs_irq_mask() - mask pinctrl interrupt
> + * @d: interrupt data
> + */
> +static void pcs_irq_mask(struct irq_data *d)
> +{
> +	struct pcs_soc_data *pcs_soc = irq_data_get_irq_chip_data(d);
> +
> +	pcs_irq_set(pcs_soc, d->irq, false);
> +}
> +
> +/**
> + * pcs_irq_unmask() - unmask pinctrl interrupt
> + * @d: interrupt data
> + */
> +static void pcs_irq_unmask(struct irq_data *d)
> +{
> +	struct pcs_soc_data *pcs_soc = irq_data_get_irq_chip_data(d);
> +
> +	pcs_irq_set(pcs_soc, d->irq, true);
> +}
> +
> +/**
> + * pcs_irq_set_wake() - toggle the suspend and resume wake up
> + * @d: interrupt data
> + * @state: wake-up state
> + *
> + * Note that this should be called only for suspend and resume.
> + * For runtime PM, the wake-up events should be enabled by default.
> + */
> +static int pcs_irq_set_wake(struct irq_data *d, unsigned int state)
> +{
> +	if (state)
> +		pcs_irq_unmask(d);
> +	else
> +		pcs_irq_mask(d);
> +
> +	return 0;
> +}
> +


I tried testing this with the USB EHCI driver, but I'm not getting wake up interrupts
while the system is still running and only the EHCI controller is runtime suspended.

It seems we need to somehow call _reconfigure_io_chain() to update the daisy chain
whenever the pad wakeup_enable bit is changed.

I think pcs_irq_set_wake() is where need to control system wakeup behaviour for the irq.
This is where we should be able to change WAKEUP_EN bit of the pad
to enable/disable system wakeup for that pad and also call _reconfigure_io_chain().

This would mean that we don't really need to set WAKEUP_EN for the pads in the DTS file.

cheers,
-roger

