Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab3A1NET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 08:04:19 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:57863 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3A1NER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:04:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130128120909.GG28698@arwen.pp.htv.fi>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
	<1359373348-18320-5-git-send-email-gautam.vivek@samsung.com>
	<20130128120909.GG28698@arwen.pp.htv.fi>
Date: Mon, 28 Jan 2013 18:34:15 +0530
Message-ID: <CAFp+6iHjzSKyya-t6dtsVQdOuhBTsCgWu+NFnDXFeRWwnBt-Jw@mail.gmail.com>
Subject: Re: [PATCH 4/4] usb: phy: samsung: Enable runtime power management on samsung-usb3
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        dianders@chromium.org, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Mon, Jan 28, 2013 at 5:39 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Jan 28, 2013 at 05:12:28PM +0530, Vivek Gautam wrote:
>> Enabling runtime power management support on samsung-usb3 phy
>> and further adding support to turn off the PHY ref_clk PLL.
>> It thereby requires PHY ref_clk to be switched between internal
>> core clock and external PLL clock.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>
> this needs to be broken down a bit. I can see three patches at least:
> add support for external clock, add support for phy gpio powerdown and
> add runtime pm ;-)
>

Alright, will break this into required number of patches.

>> ---
>>  drivers/usb/phy/samsung-usb3.c   |  107 +++++++++++++++++++++++++++++++++++--
>>  drivers/usb/phy/samsung-usbphy.c |   26 +++++++++
>>  drivers/usb/phy/samsung-usbphy.h |    1 +
>>  3 files changed, 128 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/usb/phy/samsung-usb3.c b/drivers/usb/phy/samsung-usb3.c
>> index 29e1321..4dbef15 100644
>> --- a/drivers/usb/phy/samsung-usb3.c
>> +++ b/drivers/usb/phy/samsung-usb3.c
>> @@ -22,8 +22,10 @@
>>  #include <linux/clk.h>
>>  #include <linux/delay.h>
>>  #include <linux/err.h>
>> +#include <linux/gpio.h>
>>  #include <linux/io.h>
>>  #include <linux/of.h>
>> +#include <linux/pm_runtime.h>
>>  #include <linux/usb/samsung_usb_phy.h>
>>  #include <linux/platform_data/samsung-usbphy.h>
>>
>> @@ -32,7 +34,7 @@
>>  /*
>>   * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock from clock core.
>>   */
>> -static u32 samsung_usb3_phy_set_refclk(struct samsung_usbphy *sphy)
>> +static u32 samsung_usb3_phy_set_refclk_int(struct samsung_usbphy *sphy)
>>  {
>>       u32 reg;
>>       u32 refclk;
>> @@ -65,7 +67,22 @@ static u32 samsung_usb3_phy_set_refclk(struct samsung_usbphy *sphy)
>>       return reg;
>>  }
>>
>> -static int samsung_exynos5_usb3_phy_enable(struct samsung_usbphy *sphy)
>> +/*
>> + * Sets the phy clk as ref_pad_clk (XusbXTI) which is clock from external PLL.
>> + */
>> +static u32 samsung_usb3_phy_set_refclk_ext(void)
>> +{
>> +     u32 reg;
>> +
>> +     reg = PHYCLKRST_REFCLKSEL_PAD_REFCLK |
>> +             PHYCLKRST_FSEL_PAD_100MHZ |
>> +             PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF;
>> +
>> +     return reg;
>> +}
>
> I wonder if you really need this small function (likewise for
> set_refclk_int()). They don't do much, so you could just inline them on
> the only caller.
>

Created this just to keep symmetry, ;-)
will move this in the caller only.

>> @@ -80,7 +97,11 @@ static int samsung_exynos5_usb3_phy_enable(struct samsung_usbphy *sphy)
>>
>>       phyparam0 = readl(regs + EXYNOS5_DRD_PHYPARAM0);
>>       /* Select PHY CLK source */
>> -     phyparam0 &= ~PHYPARAM0_REF_USE_PAD;
>> +     if (use_ext_clk)
>> +             phyparam0 |= PHYPARAM0_REF_USE_PAD;
>> +     else
>> +             phyparam0 &= ~PHYPARAM0_REF_USE_PAD;
>> +
>>       /* Set Loss-of-Signal Detector sensitivity */
>>       phyparam0 &= ~PHYPARAM0_REF_LOSLEVEL_MASK;
>>       phyparam0 |= PHYPARAM0_REF_LOSLEVEL;
>> @@ -115,7 +136,10 @@ static int samsung_exynos5_usb3_phy_enable(struct samsung_usbphy *sphy)
>>       /* UTMI Power Control */
>>       writel(PHYUTMI_OTGDISABLE, regs + EXYNOS5_DRD_PHYUTMI);
>>
>> -     phyclkrst = samsung_usb3_phy_set_refclk(sphy);
>> +     if (use_ext_clk)
>> +             phyclkrst = samsung_usb3_phy_set_refclk_ext();
>> +     else
>> +             phyclkrst = samsung_usb3_phy_set_refclk_int(sphy);
>>
>>       phyclkrst |= PHYCLKRST_PORTRESET |
>>                       /* Digital power supply in normal operating mode */
>> @@ -163,7 +187,7 @@ static void samsung_exynos5_usb3_phy_disable(struct samsung_usbphy *sphy)
>>       writel(phytest, regs + EXYNOS5_DRD_PHYTEST);
>>  }
>>
>> -static int samsung_usb3_phy_init(struct usb_phy *phy)
>> +static int samsung_exynos5_usb3_phy_init(struct usb_phy *phy, bool use_ext_clk)
>>  {
>>       struct samsung_usbphy *sphy;
>>       unsigned long flags;
>> @@ -187,7 +211,7 @@ static int samsung_usb3_phy_init(struct usb_phy *phy)
>>       samsung_usbphy_set_isolation(sphy, false);
>>
>>       /* Initialize usb phy registers */
>> -     samsung_exynos5_usb3_phy_enable(sphy);
>> +     samsung_exynos5_usb3_phy_enable(sphy, use_ext_clk);
>>
>>       spin_unlock_irqrestore(&sphy->lock, flags);
>>
>> @@ -198,6 +222,34 @@ static int samsung_usb3_phy_init(struct usb_phy *phy)
>>  }
>>
>>  /*
>> + * Switch  between internal core clock and external oscillator clock
>> + * for PHY reference clock
>> + */
>> +static int samsung_exynos5_usb3phy_clk_switch(struct usb_phy *phy,
>> +                                             bool use_ext_clk)
>> +{
>> +     /*
>> +      * This will switch PHY refclk from internal core clock
>> +      * to external PLL clock when device is in use and vice versa
>> +      * when device plunge into runtime suspend mode.
>> +      */
>> +     return samsung_exynos5_usb3_phy_init(phy, use_ext_clk);
>> +}
>> +
>> +/*
>> + * The function passed to the usb driver for phy initialization
>> + */
>> +static int samsung_usb3_phy_init(struct usb_phy *phy)
>> +{
>> +     /*
>> +      * We start with using PHY refclk from external PLL,
>> +      * once runtime suspend for the device is called this
>> +      * will change to internal core clock
>> +      */
>> +     return  samsung_exynos5_usb3_phy_init(phy, true);
>> +}
>> +
>> +/*
>>   * The function passed to the usb driver for phy shutdown
>>   */
>>  static void samsung_usb3_phy_shutdown(struct usb_phy *phy)
>> @@ -287,6 +339,9 @@ static int samsung_usb3_phy_probe(struct platform_device *pdev)
>>
>>       platform_set_drvdata(pdev, sphy);
>>
>> +     pm_runtime_set_active(&pdev->dev);
>> +     pm_runtime_enable(&pdev->dev);
>> +
>>       return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB3);
>>  }
>>
>> @@ -296,6 +351,8 @@ static int samsung_usb3_phy_remove(struct platform_device *pdev)
>>
>>       usb_remove_phy(&sphy->phy);
>>
>> +     pm_runtime_disable(&pdev->dev);
>
> before disabling, shouldn't you make sure the IP is turned off by
> calling:
>
> if (!pm_runtime_suspend(&pdev->dev))
>         pm_runtime_put_sync(&pdev->dev);
>
> ??
>
True, will amend this.

>> @@ -304,6 +361,42 @@ static int samsung_usb3_phy_remove(struct platform_device *pdev)
>>       return 0;
>>  }
>>
>> +static int samsung_usb3_phy_runtime_suspend(struct device *dev)
>> +{
>> +     struct samsung_usbphy *sphy = dev_get_drvdata(dev);
>> +
>> +     samsung_exynos5_usb3phy_clk_switch(&sphy->phy, false);
>> +
>> +     if (gpio_is_valid(sphy->phyclk_gpio))
>> +             gpio_set_value(sphy->phyclk_gpio, 0);
>> +
>> +     return 0;
>> +}
>> +
>> +static int samsung_usb3_phy_runtime_resume(struct device *dev)
>> +{
>> +     struct samsung_usbphy *sphy = dev_get_drvdata(dev);
>> +
>> +     if (gpio_is_valid(sphy->phyclk_gpio)) {
>> +             gpio_set_value(sphy->phyclk_gpio, 1);
>> +             /*
>> +              * PI6C557-03 clock generator needs 3ms typically to stabilise,
>> +              * but the datasheet doesn't list max.  We'll sleep for 10ms
>> +              * and cross our fingers that it's enough.
>> +              */
>> +             usleep_range(10000, 20000);
>> +     }
>> +
>> +     samsung_exynos5_usb3phy_clk_switch(&sphy->phy, true);
>> +
>> +     return 0;
>> +}
>> +
>> +static const struct dev_pm_ops samsung_usb3_phy_pm_ops = {
>> +     SET_RUNTIME_PM_OPS(samsung_usb3_phy_runtime_suspend,
>> +                             samsung_usb3_phy_runtime_resume, NULL)
>> +};
>
> you need to wrap this with #ifdef CONFIG_PM_RUNTIME. So it would look
> better as:
>
> #ifdef CONFIG_PM_RUNTIME
> suspend()
> resume()
> #define DEV_PM_OPS      (&samsung_usb3_phy_pm_ops)
> #else
> #define DEV_PM_OPS      NULL
> #endif
>

Yeah, this one looks much better :-)
Will amend this as suggested.

>> +
>>  static struct samsung_usbphy_drvdata usb3_phy_exynos5 = {
>>       .cpu_type               = TYPE_EXYNOS5250,
>>       .devphy_en_mask         = EXYNOS_USBPHY_ENABLE,
>> @@ -338,7 +431,9 @@ static struct platform_driver samsung_usb3_phy_driver = {
>>               .name   = "samsung-usb3-phy",
>>               .owner  = THIS_MODULE,
>>               .of_match_table = of_match_ptr(samsung_usbphy_dt_match),
>> +             .pm     = &samsung_usb3_phy_pm_ops,
>
> and here you have:
>
>         .pm = DEV_PM_OPS,
>

sure,



-- 
Thanks & Regards
Vivek
