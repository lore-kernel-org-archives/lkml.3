Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaIZJfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:35:07 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35497 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaIZJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:35:04 -0400
Date: Fri, 26 Sep 2014 10:34:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, tglx@linutronix.de, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/6] irqchip: Supply new driver for STi based devices
Message-ID: <20140926093433.GC4097@lee--X1>
References: <1406642744-22589-1-git-send-email-lee.jones@linaro.org>
 <1406642744-22589-3-git-send-email-lee.jones@linaro.org>
 <20140818123208.GR12769@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140818123208.GR12769@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014, Jason Cooper wrote:
> On Tue, Jul 29, 2014 at 03:05:40PM +0100, Lee Jones wrote:
> > This driver is used to enable System Configuration Register controlled
> > External, CTI (Core Sight), PMU (Performance Management), and PL310 L2
> > Cache IRQs prior to use.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/irqchip/Kconfig  |   7 ++
> >  drivers/irqchip/Makefile |   1 +
> >  drivers/irqchip/irq-st.c | 206 +++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 214 insertions(+)
> >  create mode 100644 drivers/irqchip/irq-st.c

Wow, I forgot all about this!

I'll fixup and resubmit after the merge window.

> > diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> > index bbb746e..7252de9 100644
> > --- a/drivers/irqchip/Kconfig
> > +++ b/drivers/irqchip/Kconfig
> > @@ -91,3 +91,10 @@ config IRQ_CROSSBAR
> >  	  The primary irqchip invokes the crossbar's callback which inturn allocates
> >  	  a free irq and configures the IP. Thus the peripheral interrupts are
> >  	  routed to one of the free irqchip interrupt lines.
> > +
> > +config ST_IRQCHIP
> > +	bool
> > +	select REGMAP
> > +	select MFD_SYSCON
> > +	help
> > +	  Enables SysCfg Controlled IRQs on STi based platforms.
> 
> Now that I have my head above water (a bit) wrt irqchip, I really don't
> like the hot mess that this file has become...

What does that mean?

> > diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> > index 62a13e5..f859c14 100644
> > --- a/drivers/irqchip/Makefile
> > +++ b/drivers/irqchip/Makefile
> > @@ -30,3 +30,4 @@ obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
> >  obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
> >  obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
> >  obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
> > +obj-$(CONFIG_ST_IRQCHIP)		+= irq-st.o
> > diff --git a/drivers/irqchip/irq-st.c b/drivers/irqchip/irq-st.c
> > new file mode 100644
> > index 0000000..f31126f
> > --- /dev/null
> > +++ b/drivers/irqchip/irq-st.c

[...]

> > +#define ST_A9_IRQ_EN_pl310_L2		BIT(4)
> 
> PL310

Good spot.

[...]

> > +	/* Set the device enable bit. */
> > +	switch (device) {
> > +	case ST_IRQ_SYSCFG_EXT_0 :
> > +		ddata->result |= ST_A9_IRQ_EN_EXT_0;
> > +		break;
> > +	case ST_IRQ_SYSCFG_EXT_1 :
> > +		ddata->result |= ST_A9_IRQ_EN_EXT_1;
> > +		break;
> > +	case ST_IRQ_SYSCFG_EXT_2 :
> > +		ddata->result |= ST_A9_IRQ_EN_EXT_2;
> > +		break;
> > +	case ST_IRQ_SYSCFG_CTI_0 :
> > +		ddata->result |= ST_A9_IRQ_EN_CTI_0;
> > +		break;
> > +	case ST_IRQ_SYSCFG_CTI_1 :
> > +		ddata->result |= ST_A9_IRQ_EN_CTI_1;
> > +		break;
> > +	case ST_IRQ_SYSCFG_PMU_0 :
> > +		ddata->result |= ST_A9_IRQ_EN_PMU_0;
> > +		break;
> > +	case ST_IRQ_SYSCFG_PMU_1 :
> > +		ddata->result |= ST_A9_IRQ_EN_PMU_1;
> > +		break;
> > +	case ST_IRQ_SYSCFG_pl310_L2 :
> > +		ddata->result |= ST_A9_IRQ_EN_pl310_L2;
> > +		break;
> > +	case ST_IRQ_SYSCFG_DISABLED :
> > +		return 0;
> > +	default :
> > +		dev_err(&pdev->dev, "Unrecognised device %d\n", device);
> 
> dev_dbg

I believe dev_err() to be correct here, as this is an error
condition.

[...]

> > +	channels = of_property_count_u32_elems(np, "st,irq-device");
> > +	if (channels != ST_A9_IRQ_MAX_CHANS) {
> > +		dev_err(&pdev->dev, "st,enable-irq-device must have 2 elems\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	channels = of_property_count_u32_elems(np, "st,fiq-device");
> > +	if (channels != ST_A9_IRQ_MAX_CHANS) {
> > +		dev_err(&pdev->dev, "st,enable-fiq-device must have 2 elems\n");
> > +		return -EINVAL;
> > +	}
> 
> I would drop these two blocks,
> 
> > +
> > +	for (i = 0; i < channels; i++) {
> 
> then use ST_A9_IRQ_MAX_CHANS here
> 
> > +		of_property_read_u32_index(np,"st,irq-device", i, &device);
> 
> and dev_dbg() if of_property_read_u32_index() returns an error

But what if less than ST_A9_IRQ_MAX_CHANS channels are found?
of_property_read_u32_index() will not return an error and we will have
the incorrect number of channels?  I'm not sure that it's okay to have
less than ST_A9_IRQ_MAX_CHANS.

And I think you mean dev_err().  dev_dbg() is for code used to debug
the driver/kernel.  Useful error messages such as these should be
printed in the system log at lower printk levels.

> > +
> > +		ret = st_irq_xlate(pdev, device, i, true);
> > +		if (ret)
> > +			return ret;
> > +
> > +		of_property_read_u32_index(np,"st,fiq-device", i, &device);
> 
> for both of these.
> 
> > +
> > +		ret = st_irq_xlate(pdev, device, i, false);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	/* External IRQs may be inverted. */
> > +	of_property_read_u32(np, "st,invert-ext", &invert);
> > +	ddata->result |= ST_A9_EXTIRQ_INV_SEL(invert);
> > +
> > +	return regmap_update_bits(ddata->regmap, ddata->syscfg,
> > +				  ST_A9_IRQ_MASK, ddata->result);
> > +}
> > +
> > +int st_irq_syscfg_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *np = pdev->dev.of_node;
> > +	const struct of_device_id *match;
> > +	struct st_irq_syscfg *ddata;
> > +
> > +	match = of_match_device(st_irq_syscfg_match, &pdev->dev);
> > +	if (!np)
> 
> if (!match) ?

Whoah!  Yes, absolutely.

Actually, the match information isn't even used.  I need to take a
closer look at this.

> > +		return -ENODEV;
> > +
> > +	ddata = devm_kzalloc(&pdev->dev, sizeof(*ddata), GFP_KERNEL);
> > +	if (!ddata)
> > +		return -ENOMEM;
> > +
> > +	ddata->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
> > +	if (IS_ERR(ddata->regmap)) {
> > +		dev_err(&pdev->dev, "syscfg phandle missing\n");
> 
> dev_dbg

No.  What makes you think that?

When the driver fails, to inform the user dev_err() should always be
used.  If something odd happens, but the driver can still continue
then dev_warn() should be used.  dev_dbg() should only be used for
debug information that is useful for the developer, but not for the
end user.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
