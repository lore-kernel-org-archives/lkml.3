Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3KTIza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:55:30 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:42846 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3KTIz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:55:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAFp+6iFO7d+zYuwUEhK2fquG5gmaTY+gMi48vYAOLbNHxmdWJw@mail.gmail.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
	<1383205544-32244-2-git-send-email-gautam.vivek@samsung.com>
	<3003098.ST2aP1uk4M@flatron>
	<CAFp+6iFO7d+zYuwUEhK2fquG5gmaTY+gMi48vYAOLbNHxmdWJw@mail.gmail.com>
Date: Wed, 20 Nov 2013 14:25:25 +0530
Message-ID: <CAFp+6iGw9pF+F-NRRkPzfmEkDLtQrPUnjPBZe_J6_L3bBPFSGw@mail.gmail.com>
Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kamil Debski <k.debski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-doc@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, Tomasz Figa <t.figa@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, kishon <kishon@ti.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Julius Werner <jwerner@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 2:14 PM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:
> Hi Tomasz,
>
>
> On Sun, Nov 10, 2013 at 7:38 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> Hi Vivek,
>>
>> On Thursday 31 of October 2013 13:15:41 Vivek Gautam wrote:
>>> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
>>> The new driver uses the generic PHY framework and will interact
>>> with DWC3 controller present on Exynos5 series of SoCs.
>>>
>>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>> ---
>>>  .../devicetree/bindings/phy/samsung-phy.txt        |   20 +
>>>  drivers/phy/Kconfig                                |    7 +
>>>  drivers/phy/Makefile                               |    1 +
>>>  drivers/phy/phy-exynos5-usb3.c                     |  562 ++++++++++++++++++++
>>>  4 files changed, 590 insertions(+), 0 deletions(-)
>>>  create mode 100644 drivers/phy/phy-exynos5-usb3.c
>>>
>>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>> index c0fccaa..9b5c111 100644
>>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>> @@ -20,3 +20,23 @@ Required properties:
>>>  - compatible : should be "samsung,exynos5250-dp-video-phy";
>>>  - reg : offset and length of the Display Port PHY register set;
>>>  - #phy-cells : from the generic PHY bindings, must be 0;
>>> +
>>> +Samsung Exynos5 SoC seiries USB 3.0 PHY controller
>>
>> typo: s/seiries/series/
> will correct it.
>
>>
>>> +--------------------------------------------------
>>> +
>>> +Required properties:
>>> +- compatible :
>>> +     should be "samsung,exynos5250-usb3phy" for exynos5250 SoC
>>> +     should be "samsung,exynos5420-usb3phy" for exynos5420 SoC
>>
>> I'd slightly change this into something like this:
>>
>> - compatible: Should be set to one of following supported values:
>>         - "samsung,exynos5250-usb3phy" - for Exynos5250 SoC,
>>         - "samsung,exynos5420-usb3phy" - for Exynos5420 SoC.
>
> sure, will make it as suggested.
>
>>
>>> +- reg : Register offset and length array
>>> +     - first field corresponds to USB 3.0 PHY register set;
>>> +     - second field corresponds to PHY power isolation register
>>> +       present in PMU;
>>
>> For consistency and to make things more future-proof, you should consider
>> using the PMU indirectly, through the syscon interface, as done in Leela
>> Krishna Amudala's series[1] in case of watchdog driver.
>
> Right that's a better way to do.
> But this will again introduce the register offset arithmetic once again.
> And in case of multiple USB 3.0 PHY controllers (like for Exynos5420),
> we would need to take extra care of each such offset, by having
> provision for aliases
> for the usb3phy nodes and then setting required offset before doing isolation.
>
> For Exynos5420 USB3.0 PHY channel 0 is controlled by 0x10040704; and
> USB3.0 PHY channel 1 is controlled by 0x10040708.

Or i think i can add PHY IDs similar to what Sylwester does for
MIPI_CSIS and MIPI_DSIM,
so that i will have something like this:
enum exynos5_usb3phy_id {
        EXYNOS5_USB3PHY0,
        EXYNOS5_USB3PHY1,
};
and then make use of this to add respective offsets to the pmu reg
base address as obtained from syscon node (0x10040000).

>
>>
>> I will tell Kamil to do the same for USB 2.0 PHY as well.
>>
>> [1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/24652
>>
>>> +- clocks: Clock IDs array as required by the controller
>>> +- clock-names: names of clocks correseponding to IDs in the clock property;
>>> +     Required clocks:
>>> +     - first clock is main PHY clock (same as USB 3.0 controller IP clock)
>>> +     - second clock is reference clock (usually crystal clock)
>>> +     optional clock:
>>> +     - third clock is special clock used by PHY for operation
>>
>> Is this clock really optional? It looks like it's required for Exynos5420.
>
> Yes, this clock is an additional clock for Exynos5420 rather then
> being just optional
>
>> If so, you should instead change this to:
>>
>> "Additional clocks required for Exynos5420:"
>
> Ok will change this.
>
>>
>> Also you have not specified names of the clocks, just what they are.
>> Please remember that those are input names, so you can imagine them as
>> names of clock input pins of the IP block, not SoC-level clock names.
>
> So you mean, similar to what driver requests (clocks with their input names) ?
> will add clock names.
>
>>
>>> +- #phy-cells : from the generic PHY bindings, must be 0;
>>
>> I'd also add an example of correct USB 3.0 PHY device tree node here.
>
> Sorry, forgot to add an example of the device node :-)
> will add one.
>
>>
>>> diff --git a/drivers/phy/phy-exynos5-usb3.c b/drivers/phy/phy-exynos5-usb3.c
>>> new file mode 100644
>>> index 0000000..b9a2674
>>> --- /dev/null
>>> +++ b/drivers/phy/phy-exynos5-usb3.c
>>> @@ -0,0 +1,562 @@
>> [snip]
>>> +#define EXYNOS5_DRD_PHYRESUME                        (0x34)
>>> +#define EXYNOS5_DRD_LINKPORT                 (0x44)
>>> +
>>> +
>>
>> nit: Duplicate blank line.
> will remove it.
>
>>
>>> +/* Isolation, configured in the power management unit */
>>> +#define EXYNOS5_USB_ISOL_DRD         (1 << 0)
>>> +
>>> +#define CLKSEL_ERROR                       -1
>>
>> What's this?
> Hmm..i shouldn't be defining error codes out of blue, will remove it.
>
>>
>>> +
>>> +#ifndef KHZ
>>> +#define KHZ 1000
>>> +#endif
>>> +
>>> +#ifndef MHZ
>>> +#define MHZ (KHZ * KHZ)
>>> +#endif
>>
>> Do you really need the #ifndef's above?
>
> You are right. #ifndef not really needed, since no header included
> here have these definitions.
> Although for samsung i can see they are defined in
> arch/arm/plat-samsung/include/plat/cpu.h;
> and i am sure we don't want to include that here.
>
>>
>>> +
>>> +enum samsung_cpu_type {
>>> +     TYPE_EXYNOS5250,
>>> +     TYPE_EXYNOS5420,
>>> +};
>>
>> Instead of using this kind of enumeration, I'd rather introduce a struct
>> that describes the differences between all supported types.
>
> Will drop these, anyways they are not being used anywhere.
>
>>
>>> +
>>> +enum usb3phy_state {
>>> +     STATE_OFF,
>>> +     STATE_ON,
>>> +};
>>
>> Hmm, isn't it a simple boolean value - false and true?
> Right :-)
>
>>
>>> +
>>> +struct usb3phy_config {
>>> +     enum samsung_cpu_type cpu;
>>> +     bool has_sclk_usbphy30;
>>> +};
>>
>> Oh, you already have such struct, so there is even a bigger reason to drop
>> the samsung_cpu_type enum above.
>
> Right, i created this structure to make distinction between various cpu types.
> And moreover the "samsung_cpu_type" enumerations are not being used
> anywhere right now.
> I will drop the same.
>
>>
>>> +
>>> +struct usb3phy_instance {
>>> +     char *label;
>>> +     struct usb3phy_driver *drv;
>>> +     struct phy *phy;
>>> +     enum usb3phy_state state;
>>> +     u32 clk;
>>> +     unsigned long rate;
>>> +};
>>
>> You seem to have just one instance in this driver. Do you really
>> need this struct?
>
> Right, i was hoping to get a comment on this ;-)
> Will move the field to "usb3phy_driver" structure.
>
>>
>>> +
>>> +struct usb3phy_driver {
>>> +     struct device *dev;
>>> +     void __iomem *reg_phy;
>>> +     void __iomem *reg_isol;
>>> +     struct clk *clk;
>>> +     struct clk *sclk_usbphy30;
>>> +     struct usb3phy_instance instance;
>>
>> Fields from that struct could be simply moved here.
> Hmm, will move them here.
>
>>
>>> +};
>>> +
>>> +/*
>>> + * exynos5_rate_to_clk() converts the supplied clock rate to the value that
>>> + * can be written to the phy register.
>>> + */
>>> +static u32 exynos5_rate_to_clk(unsigned long rate)
>>> +{
>>> +     unsigned int clksel;
>>> +
>>> +     /* EXYNOS5_FSEL_MASK */
>>> +
>>> +     switch (rate) {
>>> +     case 9600 * KHZ:
>>> +             clksel = EXYNOS5_FSEL_9MHZ6;
>>> +             break;
>>> +     case 10 * MHZ:
>>> +             clksel = EXYNOS5_FSEL_10MHZ;
>>> +             break;
>>> +     case 12 * MHZ:
>>> +             clksel = EXYNOS5_FSEL_12MHZ;
>>> +             break;
>>> +     case 19200 * KHZ:
>>> +             clksel = EXYNOS5_FSEL_19MHZ2;
>>> +             break;
>>> +     case 20 * MHZ:
>>> +             clksel = EXYNOS5_FSEL_20MHZ;
>>> +             break;
>>> +     case 24 * MHZ:
>>> +             clksel = EXYNOS5_FSEL_24MHZ;
>>> +             break;
>>> +     case 50 * MHZ:
>>> +             clksel = EXYNOS5_FSEL_50MHZ;
>>> +             break;
>>> +     default:
>>> +             clksel = CLKSEL_ERROR;
>>> +     }
>>> +
>>> +     return clksel;
>>> +}
>>> +
>>> +static void exynos5_usb3phy_isol(struct usb3phy_instance *inst, bool on)
>>> +{
>>> +     struct usb3phy_driver *drv = inst->drv;
>>> +     u32 tmp;
>>> +
>>> +     if (!drv->reg_isol)
>>> +             return;
>>> +
>>> +     tmp = readl(drv->reg_isol);
>>> +     if (on)
>>> +             tmp &= ~EXYNOS5_USB_ISOL_DRD;
>>> +     else
>>> +             tmp |= EXYNOS5_USB_ISOL_DRD;
>>> +     writel(tmp, drv->reg_isol);
>>> +}
>>> +
>>> +/*
>>> + * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock from clock core.
>>> + */
>>> +static u32 exynos5_usb3phy_set_refclk(struct usb3phy_instance *inst)
>>> +{
>>> +     u32 reg;
>>> +     u32 refclk;
>>> +
>>> +     refclk = inst->clk;
>>> +
>>> +     reg = PHYCLKRST_REFCLKSEL_EXT_REFCLK |
>>> +             PHYCLKRST_FSEL(refclk);
>>> +
>>> +     switch (refclk) {
>>
>> If I'm reading this correctly, you are switching a value returned by
>> another switch before (in exynos5_rate_to_clk()), which is only used in
>> this function.
>
> We are not only switching the refclk but also setting "PHYCLKRST_FSEL(__x)".
> Below i have given a brief explanation about the PHYCLKRST register
> settings required by PHY
> for different input reference clock frequencies.
>
>>
>> You could instead drop the exynos5_rate_to_clk() function completely and
>> simply make a switch over the real clock frequency here.
>>
>>> +     case EXYNOS5_FSEL_50MHZ:
>>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_50M_REF |
>>> +                     PHYCLKRST_SSC_REFCLKSEL(0x00));
>>> +             break;
>>> +     case EXYNOS5_FSEL_20MHZ:
>>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF |
>>> +                     PHYCLKRST_SSC_REFCLKSEL(0x00));
>>> +             break;
>>> +     case EXYNOS5_FSEL_19MHZ2:
>>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF |
>>> +                     PHYCLKRST_SSC_REFCLKSEL(0x88));
>>> +             break;
>>> +     case EXYNOS5_FSEL_24MHZ:
>>> +     default:
>>
>> This switch does not seem to handle all the cases handled by
>> exynos5_rate_to_clk(). Does it mean that the value for 24 MHz refclk can
>> be used for all the remaining cases or they are not supported?
>
> I got the PHY databook from our H/w team.
> Looking into that i can find that there are two ways the operational
> clocks are generated by PHY block from input reference clock
> for super-speed and high-speed operations :
> 1) either using shared reference clock for HS and SS operations (when
> refclksel [3:2] = 0x10 in PHYCLKRST register of USB 3.0 PHY of
> Exynos5250)
> 2) or using separate reference clock for HS and SS operations (when
> refclksel [3:2] = 0x11 in PHYCLKRST register of USB 3.0 PHY of
> Exynos5250)
>
> Both approaches have different settings for PHYCLKRST register.
> Right now we are using the second approach.
> So, as given in databook
> - the bit settings used for High-speed are defined for input reference
> clock freq ranging from 9.6 MHz to 50MHz,
>   as given by exynos5_rate_to_clk() function. Only bit setting needs
> to be done in this case is PHYCLKRST_FSEL(__x).
> - And, for super-speed the bit settings are defined for input
> reference clock freq ranging from 19.2 MHz to 200MHz.
>   Bit settings to be done in this case are
> PHYCLKRST_MPLL_MULTIPLIER_** and PHYCLKRST_SSC_REFCLKSEL(__x).
>
> So basically exynos5_usb3phy_set_refclk() function includes a subset
> of input reference clock freq as defined by exynos5_rate_to_clk()
> function.
> Hope this explanation makes things a bit clear.
>
>>
>>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF |
>>> +                     PHYCLKRST_SSC_REFCLKSEL(0x88));
>>> +             break;
>>> +     }
>>> +
>>> +     return reg;
>>> +}
>> [snip]
>>> +static int exynos5_usb3phy_power_on(struct phy *phy)
>>> +{
>>> +     struct usb3phy_instance *inst = phy_get_drvdata(phy);
>>> +     struct usb3phy_driver *drv = inst->drv;
>>> +     int ret;
>>> +
>>> +     dev_info(drv->dev, "Request to power_on \"%s\" usb phy\n",
>>> +                                                     inst->label);
>>
>> dev_dbg()
> sure
>
>>
>>> +
>>> +     if (drv->sclk_usbphy30)
>>
>> This check is incorrect. A NULL pointer is a correct value for a clock
>> as defined by Common Clock Framework, so IS_ERR() must be used here
>> instead.
>
> Right, will instead check of IS_ERR(drv->sclk_usbphy30), and act accrodingly.
>
>>
>>> +             clk_prepare_enable(drv->sclk_usbphy30);
>>
>> Missing error check.
>
> Hmm, will add one.
>
>>
>>> +
>>> +     ret = clk_prepare_enable(drv->clk);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>
>> All the code starting here...
>>
>>> +     if (inst->state == STATE_ON) {
>>> +             dev_err(drv->dev, "usb phy \"%s\" already on",
>>> +                                                     inst->label);
>>> +             ret = -ENODEV;
>>> +             goto err0;
>>> +     }
>>> +
>>> +     inst->state = STATE_ON;
>>
>> ...and ending here, can be safely removed, since the PHY framework already
>> provides reference counting for PHYs.
>
> Sure will remove this chunk of code for state checking.
>
>>
>>> +
>>> +     /* Initialize the PHY and power it ON */
>>> +     exynos5_usb3phy_init(inst);
>>> +     exynos5_usb3phy_isol(inst, 0);
>>> +
>>> +err0:
>>> +     clk_disable_unprepare(drv->clk);
>>
>> Is this clock needed for USB PHY operation or just for register accesses?
>
> This clock is required for register accesses. The operational clocks
> are derived out of reference clock
> given to PHY block, which comes from XXTI (FIN_PLL).
>
>>
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static int exynos5_usb3phy_power_off(struct phy *phy)
>>> +{
>>> +     struct usb3phy_instance *inst = phy_get_drvdata(phy);
>>> +     struct usb3phy_driver *drv = inst->drv;
>>> +     int ret;
>>> +
>>> +     dev_info(drv->dev, "Request to power_off \"%s\" usb phy\n",
>>> +                                                     inst->label);
>>
>> dev_dbg()
> ok
>
>>
>>> +     ret = clk_prepare_enable(drv->clk);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     if (inst->state == STATE_OFF) {
>>> +             dev_err(drv->dev, "usb phy \"%s\" already off",
>>> +                                                     inst->label);
>>> +             ret = -ENODEV;
>>> +             goto err0;
>>> +     }
>>> +
>>> +     inst->state = STATE_OFF;
>>
>> Same comment about the PHY framework already doing reference counting.
>
> Sure will remove this chunk of code for state checking.
>
>>
>>> +
>>> +     /* Power-off the PHY and de-initialize it */
>>> +     exynos5_usb3phy_isol(inst, 1);
>>> +     exynos5_usb3phy_exit(inst);
>>> +
>>> +err0:
>>> +     clk_disable_unprepare(drv->clk);
>>> +     if (drv->sclk_usbphy30)
>>> +             clk_disable_unprepare(drv->sclk_usbphy30);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static struct phy_ops exynos5_usb3phy_ops = {
>>> +     .power_on       = exynos5_usb3phy_power_on,
>>> +     .power_off      = exynos5_usb3phy_power_off,
>>> +     .owner          = THIS_MODULE,
>>> +};
>>> +
>>> +static const struct of_device_id exynos5_usb3phy_of_match[];
>>
>> What about simply moving the definition here instead using a forward
>> declaration?
>
> Ok, will move the of_device_id struct definition here. I just thought
> i would be cleaner to place it below probe () ;-)
>
>>
>>> +
>>> +static int exynos5_usb3phy_probe(struct platform_device *pdev)
>>> +{
>>> +     struct device *dev = &pdev->dev;
>>> +     struct usb3phy_driver *drv;
>>> +     struct usb3phy_instance *inst;
>>> +     struct phy_provider *phy_provider;
>>> +     struct resource *res;
>>> +     struct clk *clk;
>>> +     const struct of_device_id *match;
>>> +     const struct usb3phy_config *cfg;
>>> +
>>
>> Just to be safe, you should check if pdev->dev.of_node is not NULL here,
>> to make sure that the driver got instantiated from device tree.
>
> Sure will add check for pdev->dev.of_node; and will return from probe
> with -ENODEV in case
> we don't find any node since Exynos5 and above are anyways DT enabled systems.
>
>>
>>> +     match = of_match_node(exynos5_usb3phy_of_match, pdev->dev.of_node);
>>> +     if (!match) {
>>> +             dev_err(dev, "of_match_node() failed\n");
>>> +             return -EINVAL;
>>> +     }
>>> +     cfg = match->data;
>>> +     if (!cfg) {
>>
>> I don't think this is possible.
> Hmm, will remove this check completely.
>
>>
>>> +             dev_err(dev, "Failed to get configuration\n");
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     drv = devm_kzalloc(dev, sizeof(struct usb3phy_driver), GFP_KERNEL);
>>
>> sizeof(*drv)
>
> sure
>
>>
>>> +     if (!drv) {
>>> +             dev_err(dev, "Failed to allocate memory\n");
>>
>> kmalloc() and friends already print an error message for you.
>
> sorry i could not find the referred error message, can you please
> point me to that ?
> AFAICS most of the people print error messages if kmalloc() and friends failed.
> I tried finding until include/linux/slab.h.
>>
>>> +             return -ENOMEM;
>>> +     }
>>> +
>>> +     dev_set_drvdata(dev, drv);
>>> +     drv->dev = dev;
>>> +
>>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +     drv->reg_phy = devm_ioremap_resource(dev, res);
>>> +     if (IS_ERR(drv->reg_phy)) {
>>> +             dev_err(dev, "Failed to map register memory (phy)\n");
>>> +             return PTR_ERR(drv->reg_phy);
>>> +     }
>>> +
>>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>>> +     drv->reg_isol = devm_ioremap_resource(dev, res);
>>> +     if (IS_ERR(drv->reg_isol)) {
>>> +             dev_err(dev, "Failed to map register memory (isolation)\n");
>>> +             return PTR_ERR(drv->reg_isol);
>>> +     }
>>> +
>>> +     phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
>>> +     if (IS_ERR(phy_provider)) {
>>> +             dev_err(drv->dev, "Failed to register phy provider\n");
>>> +             return PTR_ERR(phy_provider);
>>> +     }
>>
>> The provider should be registered as the last thing in the sequence, as
>> the driver must be ready for handling PHY requests as soon as
>> of_phy_provider_register() returns.
>
> Sure, will move this at the end of probe().
>
>>
>>> +
>>> +     drv->clk = devm_clk_get(dev, "phy");
>>> +     if (IS_ERR(drv->clk)) {
>>> +             dev_err(dev, "Failed to get clock of phy controller\n");
>>> +             return PTR_ERR(drv->clk);
>>> +     }
>>> +
>>> +     /*
>>> +      * Exysno5420 SoC has an additional special clock, used for
>>> +      * for USB 3.0 PHY operation, this clock goes to the PHY block
>>> +      * as a reference clock to clock generation block of the controller.
>>> +      */
>>> +     if (cfg->has_sclk_usbphy30) {
>>> +             drv->sclk_usbphy30 = devm_clk_get(dev, "sclk_usbphy30");
>>> +             if (IS_ERR(drv->clk)) {
>>> +                     dev_err(dev, "Failed to get phy reference clock\n");
>>> +                     return PTR_ERR(drv->clk);
>>> +             }
>>
>> Seems like this clock is required for Exynos5420 indeed, as opposed to
>> what the DT binding documentation says.
>
> Yes, this is clock is required for Exynos5420. I will modify the
> device tree documentation
> further to avoid any confusion.
>
>>
>>> +     }
>>> +
>>> +     inst            = &drv->instance;
>>> +     inst->drv       = drv;
>>
>> This pointer does not seem to be needed.
> Ok will drop it. In fact i am going  to drop the instance thing
> entirely, so this makes sense.
>
>>
>>> +     inst->label     = "usb3drd";
>>
>> Do you need this label at all?
>
> not really when we use phy's name string directly. ;-)
> will drop this.
>
>>
>>> +
>>> +     dev_info(dev, "Creating phy \"%s\"\n", inst->label);
>>
>> dev_dbg()
> sure
>
>>
>>> +     inst->phy = devm_phy_create(dev, &exynos5_usb3phy_ops, NULL);
>>> +     if (IS_ERR(inst->phy)) {
>>> +             dev_err(drv->dev, "Failed to create usb3phy \"%s\"\n",
>>> +                                     inst->label);
>>> +             return PTR_ERR(inst->phy);
>>> +     }
>>> +
>>> +     phy_set_drvdata(inst->phy, inst);
>>> +
>>> +     clk = clk_get(dev, inst->label);
>>
>> Since this driver provides only a single PHY, I think you should simply
>> use the clock name directly.
>
> Ok will use the name string directly.
>
>>
>>> +     if (IS_ERR(clk)) {
>>> +             dev_err(dev, "Failed to get clock of \"%s\" phy\n",
>>> +                                                     inst->label);
>>> +             return PTR_ERR(clk);
>>> +     }
>>> +
>>> +     inst->rate = clk_get_rate(clk);
>>> +
>>> +     inst->clk = exynos5_rate_to_clk(inst->rate);
>>> +     if (inst->clk == CLKSEL_ERROR) {
>>> +             dev_err(dev, "Clock rate (%ld) not supported\n",
>>> +                                             inst->rate);
>>> +             clk_put(clk);
>>> +             return -EINVAL;
>>> +     }
>>> +     clk_put(clk);
>>
>> Technically this should happen at the time of calling PHY enable, while
>> a reference to the clock should be kept through the whole PHY lifetime.
>> In addition, the clock should be prepare_enabled before it is used.
>
> This is actually the FIN_PLL (XXTI) clock which is being used as
> reference clock to
> the PHY block, which has its own clock generator.
> On knowing the rate of this FIN_PLL, the driver would like to program
> the PHY registers
> (PHYCLKRST in particular), which contain settings for generating
> different operational clocks used by PHY
> for high-speed and super-speed operations.
>
>>
>> So, to recall, here you could call devm_clk_get(...). Then in
>> exynos5_usb3phy_power_on(), call clk_prepare_enable() on it, in
>> exynos5_usb3phy_set_refclk() call clk_get_rate() to get its frequency
>> and finally clk_disable_unprepare() it in exynos5_usb3phy_power_off().
>
> So do we really need to call prepare_enable() and disable_unprepare()
> over this Fin_PLL clock ?
> I can move this to the place where PHY is enabled.
>
>>
>> Best regards,
>> Tomasz
>
> Thanks Tomasz for reviewing this. I will address your comments and
> update the new patch-set soon.
>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Best Regards
> Vivek Gautam
> Samsung R&D Institute, Bangalore
> India



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
