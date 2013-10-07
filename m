Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab3JGQbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:31:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57358 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756483Ab3JGQbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:31:11 -0400
Message-ID: <5252E19C.3090404@ti.com>
Date: Mon, 7 Oct 2013 22:00:20 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paul Chavent <Paul.Chavent@onera.fr>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: davinci: usb: provide minimal support for da850.
References: <1380030365-30373-1-git-send-email-paul.chavent@onera.fr>
In-Reply-To: <1380030365-30373-1-git-send-email-paul.chavent@onera.fr>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 September 2013 07:16 PM, Paul Chavent wrote:
> As for the da830 and hawk boards, the da850 can provide minimalist usb
> 1.1 implementation. Moreover, this patch has only been tested with the
> OHCI (on an OMAP L138 EVM / DA850 board), not with the Inventra HC
> (that seems broken for the DA8XX).
> 
> This patch is inspired by the hawk board implementation.
> 
> Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c | 153 ++++++++++++++++++++++++++++++++
>  1 file changed, 153 insertions(+)
> 
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index dd1fb24..f0bee9d 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -62,6 +62,9 @@
>  
>  #define DA850_MII_MDIO_CLKEN_PIN	GPIO_TO_PIN(2, 6)
>  
> +#define DA850_USB1_VBUS_PIN		GPIO_TO_PIN(2, 4)
> +#define DA850_USB1_OC_PIN		GPIO_TO_PIN(6, 13)
> +
>  static struct mtd_partition da850evm_spiflash_part[] = {
>  	[0] = {
>  		.name = "UBL",
> @@ -1431,6 +1434,155 @@ static __init int da850_wl12xx_init(void)
>  
>  #endif /* CONFIG_DA850_WL12XX */
>  
> +#ifdef CONFIG_USB
> +
> +static irqreturn_t da850_usb_ocic_irq(int irq, void *dev_id);
> +static da8xx_ocic_handler_t da850_usb_ocic_handler;
> +
> +static const short da850_usb11_pins[] = {
> +	DA850_GPIO2_4, DA850_GPIO6_13,
> +	-1
> +};
> +
> +static int da850_usb_set_power(unsigned port, int on)
> +{
> +	gpio_set_value(DA850_USB1_VBUS_PIN, on);
> +	return 0;
> +}
> +
> +static int da850_usb_get_power(unsigned port)
> +{
> +	return gpio_get_value(DA850_USB1_VBUS_PIN);
> +}
> +
> +static int da850_usb_get_oci(unsigned port)
> +{
> +	return !gpio_get_value(DA850_USB1_OC_PIN);
> +}
> +
> +static int da850_usb_ocic_notify(da8xx_ocic_handler_t handler)
> +{
> +	int irq         = gpio_to_irq(DA850_USB1_OC_PIN);
> +	int error       = 0;
> +
> +	if (handler != NULL) {
> +		da850_usb_ocic_handler = handler;
> +
> +		error = request_irq(irq, da850_usb_ocic_irq,
> +					IRQF_DISABLED | IRQF_TRIGGER_RISING |
> +					IRQF_TRIGGER_FALLING,
> +					"OHCI over-current indicator", NULL);
> +		if (error)
> +			pr_err("%s: could not request IRQ to watch "
> +				"over-current indicator changes\n", __func__);
> +	} else {
> +		free_irq(irq, NULL);
> +	}
> +	return error;
> +}
> +
> +static struct da8xx_ohci_root_hub da850_usb11_pdata = {
> +	.set_power      = da850_usb_set_power,
> +	.get_power      = da850_usb_get_power,
> +	.get_oci        = da850_usb_get_oci,
> +	.ocic_notify    = da850_usb_ocic_notify,
> +	/* TPS2087 switch @ 5V */
> +	.potpgt         = (3 + 1) / 2,  /* 3 ms max */
> +};
> +
> +static irqreturn_t da850_usb_ocic_irq(int irq, void *dev_id)
> +{
> +	da850_usb_ocic_handler(&da850_usb11_pdata, 1);
> +	return IRQ_HANDLED;
> +}
> +
> +static __init void da850_usb_init(void)
> +{
> +	void __iomem *cfg_chip2_base;
> +	int ret;
> +	u32 val;
> +
> +	/*
> +	 * Set up USB clock/mode in the CFGCHIP2 register.
> +	 */
> +
> +	cfg_chip2_base = DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP2_REG);
> +
> +	val = __raw_readl(cfg_chip2_base);
> +
> +	/* USB2.0 PHY reference clock is 24 MHz */
> +	val &= ~CFGCHIP2_REFFREQ;
> +	val |=  CFGCHIP2_REFFREQ_24MHZ;
> +
> +	/*
> +	 * Select internal reference clock for USB 2.0 PHY
> +	 * and use it as a clock source for USB 1.1 PHY
> +	 * (this is the default setting anyway).
> +	 */
> +	 val &= ~CFGCHIP2_USB1PHYCLKMUX;
> +	 val |=  CFGCHIP2_USB2PHYCLKMUX;
> +
> +	/*
> +	 * We have to override VBUS/ID signals when MUSB is configured into the
> +	 * host-only mode -- ID pin will float if no cable is connected, so the
> +	 * controller won't be able to drive VBUS thinking that it's a B-device.
> +	 * Otherwise, we want to use the OTG mode and enable VBUS comparators.
> +	 */
> +	val &= ~CFGCHIP2_OTGMODE;
> +#ifdef	CONFIG_USB_MUSB_HOST
> +	val |=  CFGCHIP2_FORCE_HOST;
> +#else
> +	val |=  CFGCHIP2_SESENDEN | CFGCHIP2_VBDTCTEN;
> +#endif

This is not good since it forces you to have two different kernel builds
for host and device mode. Are you sure this configuration is needed? If
this cannot be avoided, then can you see if this can be moved to the
driver itself since then it can probably make better runtime decisions?

> +
> +	/* configure the CFGCHIP2 register */
> +	__raw_writel(val, cfg_chip2_base);

Please use writel() and readl() or the _relaxed() variants.

Actually, it looks like all of this initialization can be moved to the
driver itself with data passed from platform. That way you dont have the
replicate this code for EVM.

Since you say the inventra doesn't work, it will most probably help if
you drop the inventra specific code from this patch. That part can be
dealt along with getting inventra to work on DA850.

Thanks,
Sekhar

> +
> +	ret = davinci_cfg_reg_list(da850_usb11_pins);
> +	if (ret) {
> +		pr_warn("%s: USB 1.1 PinMux setup failed: %d\n", __func__, ret);
> +		return;
> +	}
> +
> +	ret = gpio_request_one(DA850_USB1_VBUS_PIN,
> +			GPIOF_DIR_OUT, "USB1 VBUS");
> +	if (ret < 0) {
> +		pr_err("%s: failed to request GPIO for USB 1.1 port "
> +			"power control: %d\n", __func__, ret);
> +		return;
> +	}
> +
> +	ret = gpio_request_one(DA850_USB1_OC_PIN,
> +			GPIOF_DIR_IN, "USB1 OC");
> +	if (ret < 0) {
> +		pr_err("%s: failed to request GPIO for USB 1.1 port "
> +			"over-current indicator: %d\n", __func__, ret);
> +		goto usb11_setup_oc_fail;
> +	}
> +
> +	ret = da8xx_register_usb11(&da850_usb11_pdata);
> +	if (ret) {
> +		pr_warn("%s: USB 1.1 registration failed: %d\n", __func__, ret);
> +		goto usb11_setup_fail;
> +	}
> +
> +	return;
> +
> +usb11_setup_fail:
> +	gpio_free(DA850_USB1_OC_PIN);
> +usb11_setup_oc_fail:
> +	gpio_free(DA850_USB1_VBUS_PIN);
> +}
> +
> +#else /* CONFIG_USB */
> +
> +static __init void da850_usb_init(void)
> +{
> +	return 0;
> +}
> +
> +#endif /* CONFIG_USB */
> +
>  #define DA850EVM_SATA_REFCLKPN_RATE	(100 * 1000 * 1000)
>  
>  static __init void da850_evm_init(void)
> @@ -1453,6 +1605,7 @@ static __init void da850_evm_init(void)
>  	if (ret)
>  		pr_warn("%s: I2C0 registration failed: %d\n", __func__, ret);
>  
> +	da850_usb_init();
>  
>  	ret = da8xx_register_watchdog();
>  	if (ret)
> 

