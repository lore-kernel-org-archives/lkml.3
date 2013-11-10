Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3KJOJC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 09:09:02 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:63354 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3KJOIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 09:08:55 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        k.debski@samsung.com, kgene.kim@samsung.com, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, t.figa@samsung.com, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org, balbi@ti.com, kishon@ti.com,
        s.nawrocki@samsung.com, jwerner@chromium.org
Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
Date: Sun, 10 Nov 2013 15:08:52 +0100
Message-ID: <3003098.ST2aP1uk4M@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1383205544-32244-2-git-send-email-gautam.vivek@samsung.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com> <1383205544-32244-2-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Thursday 31 of October 2013 13:15:41 Vivek Gautam wrote:
> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
> The new driver uses the generic PHY framework and will interact
> with DWC3 controller present on Exynos5 series of SoCs.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  .../devicetree/bindings/phy/samsung-phy.txt        |   20 +
>  drivers/phy/Kconfig                                |    7 +
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/phy-exynos5-usb3.c                     |  562 ++++++++++++++++++++
>  4 files changed, 590 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/phy/phy-exynos5-usb3.c
> 
> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> index c0fccaa..9b5c111 100644
> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> @@ -20,3 +20,23 @@ Required properties:
>  - compatible : should be "samsung,exynos5250-dp-video-phy";
>  - reg : offset and length of the Display Port PHY register set;
>  - #phy-cells : from the generic PHY bindings, must be 0;
> +
> +Samsung Exynos5 SoC seiries USB 3.0 PHY controller

typo: s/seiries/series/

> +--------------------------------------------------
> +
> +Required properties:
> +- compatible :
> +	should be "samsung,exynos5250-usb3phy" for exynos5250 SoC
> +	should be "samsung,exynos5420-usb3phy" for exynos5420 SoC

I'd slightly change this into something like this:

- compatible: Should be set to one of following supported values:
	- "samsung,exynos5250-usb3phy" - for Exynos5250 SoC,
	- "samsung,exynos5420-usb3phy" - for Exynos5420 SoC.

> +- reg : Register offset and length array
> +	- first field corresponds to USB 3.0 PHY register set;
> +	- second field corresponds to PHY power isolation register
> +	  present in PMU;

For consistency and to make things more future-proof, you should consider
using the PMU indirectly, through the syscon interface, as done in Leela
Krishna Amudala's series[1] in case of watchdog driver.

I will tell Kamil to do the same for USB 2.0 PHY as well.

[1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/24652

> +- clocks: Clock IDs array as required by the controller
> +- clock-names: names of clocks correseponding to IDs in the clock property;
> +	Required clocks:
> +	- first clock is main PHY clock (same as USB 3.0 controller IP clock)
> +	- second clock is reference clock (usually crystal clock)
> +	optional clock:
> +	- third clock is special clock used by PHY for operation

Is this clock really optional? It looks like it's required for Exynos5420.
If so, you should instead change this to:

"Additional clocks required for Exynos5420:"

Also you have not specified names of the clocks, just what they are.
Please remember that those are input names, so you can imagine them as
names of clock input pins of the IP block, not SoC-level clock names.

> +- #phy-cells : from the generic PHY bindings, must be 0;

I'd also add an example of correct USB 3.0 PHY device tree node here.

> diff --git a/drivers/phy/phy-exynos5-usb3.c b/drivers/phy/phy-exynos5-usb3.c
> new file mode 100644
> index 0000000..b9a2674
> --- /dev/null
> +++ b/drivers/phy/phy-exynos5-usb3.c
> @@ -0,0 +1,562 @@
[snip]
> +#define EXYNOS5_DRD_PHYRESUME			(0x34)
> +#define EXYNOS5_DRD_LINKPORT			(0x44)
> +
> +

nit: Duplicate blank line.

> +/* Isolation, configured in the power management unit */
> +#define EXYNOS5_USB_ISOL_DRD		(1 << 0)
> +
> +#define CLKSEL_ERROR                       -1

What's this?

> +
> +#ifndef KHZ
> +#define KHZ 1000
> +#endif
> +
> +#ifndef MHZ
> +#define MHZ (KHZ * KHZ)
> +#endif

Do you really need the #ifndef's above?

> +
> +enum samsung_cpu_type {
> +	TYPE_EXYNOS5250,
> +	TYPE_EXYNOS5420,
> +};

Instead of using this kind of enumeration, I'd rather introduce a struct
that describes the differences between all supported types.

> +
> +enum usb3phy_state {
> +	STATE_OFF,
> +	STATE_ON,
> +};

Hmm, isn't it a simple boolean value - false and true?

> +
> +struct usb3phy_config {
> +	enum samsung_cpu_type cpu;
> +	bool has_sclk_usbphy30;
> +};

Oh, you already have such struct, so there is even a bigger reason to drop
the samsung_cpu_type enum above.

> +
> +struct usb3phy_instance {
> +	char *label;
> +	struct usb3phy_driver *drv;
> +	struct phy *phy;
> +	enum usb3phy_state state;
> +	u32 clk;
> +	unsigned long rate;
> +};

You seem to have just one instance in this driver. Do you really
need this struct?

> +
> +struct usb3phy_driver {
> +	struct device *dev;
> +	void __iomem *reg_phy;
> +	void __iomem *reg_isol;
> +	struct clk *clk;
> +	struct clk *sclk_usbphy30;
> +	struct usb3phy_instance instance;

Fields from that struct could be simply moved here.

> +};
> +
> +/*
> + * exynos5_rate_to_clk() converts the supplied clock rate to the value that
> + * can be written to the phy register.
> + */
> +static u32 exynos5_rate_to_clk(unsigned long rate)
> +{
> +	unsigned int clksel;
> +
> +	/* EXYNOS5_FSEL_MASK */
> +
> +	switch (rate) {
> +	case 9600 * KHZ:
> +		clksel = EXYNOS5_FSEL_9MHZ6;
> +		break;
> +	case 10 * MHZ:
> +		clksel = EXYNOS5_FSEL_10MHZ;
> +		break;
> +	case 12 * MHZ:
> +		clksel = EXYNOS5_FSEL_12MHZ;
> +		break;
> +	case 19200 * KHZ:
> +		clksel = EXYNOS5_FSEL_19MHZ2;
> +		break;
> +	case 20 * MHZ:
> +		clksel = EXYNOS5_FSEL_20MHZ;
> +		break;
> +	case 24 * MHZ:
> +		clksel = EXYNOS5_FSEL_24MHZ;
> +		break;
> +	case 50 * MHZ:
> +		clksel = EXYNOS5_FSEL_50MHZ;
> +		break;
> +	default:
> +		clksel = CLKSEL_ERROR;
> +	}
> +
> +	return clksel;
> +}
> +
> +static void exynos5_usb3phy_isol(struct usb3phy_instance *inst, bool on)
> +{
> +	struct usb3phy_driver *drv = inst->drv;
> +	u32 tmp;
> +
> +	if (!drv->reg_isol)
> +		return;
> +
> +	tmp = readl(drv->reg_isol);
> +	if (on)
> +		tmp &= ~EXYNOS5_USB_ISOL_DRD;
> +	else
> +		tmp |= EXYNOS5_USB_ISOL_DRD;
> +	writel(tmp, drv->reg_isol);
> +}
> +
> +/*
> + * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock from clock core.
> + */
> +static u32 exynos5_usb3phy_set_refclk(struct usb3phy_instance *inst)
> +{
> +	u32 reg;
> +	u32 refclk;
> +
> +	refclk = inst->clk;
> +
> +	reg = PHYCLKRST_REFCLKSEL_EXT_REFCLK |
> +		PHYCLKRST_FSEL(refclk);
> +
> +	switch (refclk) {

If I'm reading this correctly, you are switching a value returned by
another switch before (in exynos5_rate_to_clk()), which is only used in
this function.

You could instead drop the exynos5_rate_to_clk() function completely and
simply make a switch over the real clock frequency here.

> +	case EXYNOS5_FSEL_50MHZ:
> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_50M_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x00));
> +		break;
> +	case EXYNOS5_FSEL_20MHZ:
> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x00));
> +		break;
> +	case EXYNOS5_FSEL_19MHZ2:
> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x88));
> +		break;
> +	case EXYNOS5_FSEL_24MHZ:
> +	default:

This switch does not seem to handle all the cases handled by
exynos5_rate_to_clk(). Does it mean that the value for 24 MHz refclk can
be used for all the remaining cases or they are not supported?

> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x88));
> +		break;
> +	}
> +
> +	return reg;
> +}
[snip]
> +static int exynos5_usb3phy_power_on(struct phy *phy)
> +{
> +	struct usb3phy_instance *inst = phy_get_drvdata(phy);
> +	struct usb3phy_driver *drv = inst->drv;
> +	int ret;
> +
> +	dev_info(drv->dev, "Request to power_on \"%s\" usb phy\n",
> +							inst->label);

dev_dbg()

> +
> +	if (drv->sclk_usbphy30)

This check is incorrect. A NULL pointer is a correct value for a clock
as defined by Common Clock Framework, so IS_ERR() must be used here
instead.

> +		clk_prepare_enable(drv->sclk_usbphy30);

Missing error check.

> +
> +	ret = clk_prepare_enable(drv->clk);
> +	if (ret)
> +		return ret;
> +

All the code starting here...

> +	if (inst->state == STATE_ON) {
> +		dev_err(drv->dev, "usb phy \"%s\" already on",
> +							inst->label);
> +		ret = -ENODEV;
> +		goto err0;
> +	}
> +
> +	inst->state = STATE_ON;

...and ending here, can be safely removed, since the PHY framework already
provides reference counting for PHYs.

> +
> +	/* Initialize the PHY and power it ON */
> +	exynos5_usb3phy_init(inst);
> +	exynos5_usb3phy_isol(inst, 0);
> +
> +err0:
> +	clk_disable_unprepare(drv->clk);

Is this clock needed for USB PHY operation or just for register accesses?

> +
> +	return ret;
> +}
> +
> +static int exynos5_usb3phy_power_off(struct phy *phy)
> +{
> +	struct usb3phy_instance *inst = phy_get_drvdata(phy);
> +	struct usb3phy_driver *drv = inst->drv;
> +	int ret;
> +
> +	dev_info(drv->dev, "Request to power_off \"%s\" usb phy\n",
> +							inst->label);

dev_dbg()

> +	ret = clk_prepare_enable(drv->clk);
> +	if (ret)
> +		return ret;
> +
> +	if (inst->state == STATE_OFF) {
> +		dev_err(drv->dev, "usb phy \"%s\" already off",
> +							inst->label);
> +		ret = -ENODEV;
> +		goto err0;
> +	}
> +
> +	inst->state = STATE_OFF;

Same comment about the PHY framework already doing reference counting.

> +
> +	/* Power-off the PHY and de-initialize it */
> +	exynos5_usb3phy_isol(inst, 1);
> +	exynos5_usb3phy_exit(inst);
> +
> +err0:
> +	clk_disable_unprepare(drv->clk);
> +	if (drv->sclk_usbphy30)
> +		clk_disable_unprepare(drv->sclk_usbphy30);
> +
> +	return ret;
> +}
> +
> +static struct phy_ops exynos5_usb3phy_ops = {
> +	.power_on	= exynos5_usb3phy_power_on,
> +	.power_off	= exynos5_usb3phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static const struct of_device_id exynos5_usb3phy_of_match[];

What about simply moving the definition here instead using a forward
declaration?

> +
> +static int exynos5_usb3phy_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct usb3phy_driver *drv;
> +	struct usb3phy_instance *inst;
> +	struct phy_provider *phy_provider;
> +	struct resource *res;
> +	struct clk *clk;
> +	const struct of_device_id *match;
> +	const struct usb3phy_config *cfg;
> +

Just to be safe, you should check if pdev->dev.of_node is not NULL here,
to make sure that the driver got instantiated from device tree.

> +	match = of_match_node(exynos5_usb3phy_of_match, pdev->dev.of_node);
> +	if (!match) {
> +		dev_err(dev, "of_match_node() failed\n");
> +		return -EINVAL;
> +	}
> +	cfg = match->data;
> +	if (!cfg) {

I don't think this is possible.

> +		dev_err(dev, "Failed to get configuration\n");
> +		return -EINVAL;
> +	}
> +
> +	drv = devm_kzalloc(dev, sizeof(struct usb3phy_driver), GFP_KERNEL);

sizeof(*drv)

> +	if (!drv) {
> +		dev_err(dev, "Failed to allocate memory\n");

kmalloc() and friends already print an error message for you.

> +		return -ENOMEM;
> +	}
> +
> +	dev_set_drvdata(dev, drv);
> +	drv->dev = dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	drv->reg_phy = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(drv->reg_phy)) {
> +		dev_err(dev, "Failed to map register memory (phy)\n");
> +		return PTR_ERR(drv->reg_phy);
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	drv->reg_isol = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(drv->reg_isol)) {
> +		dev_err(dev, "Failed to map register memory (isolation)\n");
> +		return PTR_ERR(drv->reg_isol);
> +	}
> +
> +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider)) {
> +		dev_err(drv->dev, "Failed to register phy provider\n");
> +		return PTR_ERR(phy_provider);
> +	}

The provider should be registered as the last thing in the sequence, as
the driver must be ready for handling PHY requests as soon as
of_phy_provider_register() returns.

> +
> +	drv->clk = devm_clk_get(dev, "phy");
> +	if (IS_ERR(drv->clk)) {
> +		dev_err(dev, "Failed to get clock of phy controller\n");
> +		return PTR_ERR(drv->clk);
> +	}
> +
> +	/*
> +	 * Exysno5420 SoC has an additional special clock, used for
> +	 * for USB 3.0 PHY operation, this clock goes to the PHY block
> +	 * as a reference clock to clock generation block of the controller.
> +	 */
> +	if (cfg->has_sclk_usbphy30) {
> +		drv->sclk_usbphy30 = devm_clk_get(dev, "sclk_usbphy30");
> +		if (IS_ERR(drv->clk)) {
> +			dev_err(dev, "Failed to get phy reference clock\n");
> +			return PTR_ERR(drv->clk);
> +		}

Seems like this clock is required for Exynos5420 indeed, as opposed to
what the DT binding documentation says.

> +	}
> +
> +	inst		= &drv->instance;
> +	inst->drv	= drv;

This pointer does not seem to be needed.

> +	inst->label	= "usb3drd";

Do you need this label at all?

> +
> +	dev_info(dev, "Creating phy \"%s\"\n", inst->label);

dev_dbg()

> +	inst->phy = devm_phy_create(dev, &exynos5_usb3phy_ops, NULL);
> +	if (IS_ERR(inst->phy)) {
> +		dev_err(drv->dev, "Failed to create usb3phy \"%s\"\n",
> +					inst->label);
> +		return PTR_ERR(inst->phy);
> +	}
> +
> +	phy_set_drvdata(inst->phy, inst);
> +
> +	clk = clk_get(dev, inst->label);

Since this driver provides only a single PHY, I think you should simply
use the clock name directly.

> +	if (IS_ERR(clk)) {
> +		dev_err(dev, "Failed to get clock of \"%s\" phy\n",
> +							inst->label);
> +		return PTR_ERR(clk);
> +	}
> +
> +	inst->rate = clk_get_rate(clk);
> +
> +	inst->clk = exynos5_rate_to_clk(inst->rate);
> +	if (inst->clk == CLKSEL_ERROR) {
> +		dev_err(dev, "Clock rate (%ld) not supported\n",
> +						inst->rate);
> +		clk_put(clk);
> +		return -EINVAL;
> +	}
> +	clk_put(clk);

Technically this should happen at the time of calling PHY enable, while
a reference to the clock should be kept through the whole PHY lifetime.
In addition, the clock should be prepare_enabled before it is used.

So, to recall, here you could call devm_clk_get(...). Then in
exynos5_usb3phy_power_on(), call clk_prepare_enable() on it, in
exynos5_usb3phy_set_refclk() call clk_get_rate() to get its frequency
and finally clk_disable_unprepare() it in exynos5_usb3phy_power_off().

Best regards,
Tomasz

