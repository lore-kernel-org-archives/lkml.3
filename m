Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3BESa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:30:26 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:53831 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab3BESaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:30:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAD6zSYPsOG6nzqkJOSeikHB+Sd7A8f+gP2=uQjDU9yGRLQLQRg@mail.gmail.com>
References: <1360027522-18196-1-git-send-email-tobetter@gmail.com>
	<CAD6zSYPsOG6nzqkJOSeikHB+Sd7A8f+gP2=uQjDU9yGRLQLQRg@mail.gmail.com>
Date: Wed, 6 Feb 2013 03:30:07 +0900
Message-ID: <CADoNuNddrhtASF6t=jiH549cT0D4a0EJdG_td9zG0YKtd0UmNw@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb: phy: Add USB host phy support on Exyno4412
From: Dongjin Kim <tobetter@gmail.com>
To: Praveen Paneri <p.paneri@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Praveen,

Thank you for reviewing.
I was also considered to use TYPE_4X12, but in some other thread some
people prefer to use 4412 instead of 4X12 because no 4212 based
hardware yet. :)
Anyway, TYPE_4X12 is also fine to me.

And as you pointed out about PHY0, while testing my patch with my
hardware I also wondered why PHY0 has to be enabled. Unless USBPHY its
status was monitored as "halted" it didn't work at all. Now I find the
reason that the first is power for USB block is wrong (not stable) and
the second is when the hardware is initialized at first, like power
up, URSTCON's initial value is 0x79, which means HSIC0, HSIC1, PHY1
and OTG is in reset state. So it has to be released before USB starts.
So I am finding the good place to initiate URSTCON properly, u-boot or
kernel itself.

Do you have any advice on this?

Thank you again.
Dongjin.

On Tue, Feb 5, 2013 at 11:38 PM, Praveen Paneri <p.paneri@samsung.com> wrote:
>
> Hi,
>
> On Tue, Feb 5, 2013 at 6:55 AM, Dongjin Kim <tobetter@gmail.com> wrote:
> > This patch adds host phy support for Samsung's Exynos4412 SoC to
> > samsung-usbphy driver. This patch is created upon
> > "http://git.kernel.org/?p=linux/kernel/git/balbi/usb.git;a=commit;h=2564b526b8cf01e6c36285edfd40a438e683c2b8"
> >
> > Cc: Praveen Paneri <p.paneri@samsung.com>
> > Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> > ---
> >  drivers/usb/phy/samsung-usbphy.c |  156
> > +++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 154 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/usb/phy/samsung-usbphy.c
> > b/drivers/usb/phy/samsung-usbphy.c
> > index 6ea5537..c800fa4 100644
> > --- a/drivers/usb/phy/samsung-usbphy.c
> > +++ b/drivers/usb/phy/samsung-usbphy.c
> > @@ -47,7 +47,7 @@
> >
> >  #define PHYCLK_MODE_USB11                      (0x1 << 6)
> >  #define PHYCLK_EXT_OSC                         (0x1 << 5)
> > -#define PHYCLK_COMMON_ON_N                     (0x1 << 4)
> > +#define PHYCLK_COMMON_ON_N_PHY0                        (0x1 << 4)
> >  #define PHYCLK_ID_PULL                         (0x1 << 2)
> >  #define PHYCLK_CLKSEL_MASK                     (0x3 << 0)
> >  #define PHYCLK_CLKSEL_48M                      (0x0 << 0)
> > @@ -60,6 +60,22 @@
> >  #define RSTCON_HLINK_SWRST                     (0x1 << 1)
> >  #define RSTCON_SWRST                           (0x1 << 0)
> >
> > +/* For Exynos4412 */
> > +#define PHYCLK_COMMON_ON_N_PHY1                        (0x1 << 7)
> > +
> > +#define PHYPWR_NORMAL_MASK_HSIC1               (0x7 << 12)
> > +#define PHYPWR_NORMAL_MASK_HSIC0               (0x7 << 9)
> > +#define PHYPWR_NORMAL_MASK_PHY1                        (0x7 << 6)
> > +
> > +#define PHYPWR_ANALOG_POWERDOWN_PHY1           (0x1 << 7)
> > +
> > +#define RSTCON_HLINK_SWRST_MASK                        (0xf << 7)
> > +#define RSTCON_PHY1_SWRST_MASK                 (0xf << 3)
> > +#define RSTCON_PHY0_SWRST_MASK                 (0x7 << 0)
> > +
> > +#define EXYNOS4_PHY_HSIC_CTRL0                 (0x04)
> > +#define EXYNOS4_PHY_HSIC_CTRL1                 (0x08)
> > +
> >  /* EXYNOS5 */
> >  #define EXYNOS5_PHY_HOST_CTRL0                 (0x00)
> >
> > @@ -174,6 +190,7 @@
> >  enum samsung_cpu_type {
> >         TYPE_S3C64XX,
> >         TYPE_EXYNOS4210,
> > +       TYPE_EXYNOS4412,
> Shouldn't you add it under the TYPE_EXYNOS4X12. We will have to add a
> separate support for 4212 then.
> >         TYPE_EXYNOS5250,
> >  };
> >
> > @@ -322,6 +339,17 @@ static void samsung_usbphy_set_isolation(struct
> > samsung_usbphy *sphy, bool on)
> >                         en_mask = sphy->drv_data->hostphy_en_mask;
> >                 }
> >                 break;
> > +       case TYPE_EXYNOS4412:
> > +               if (sphy->phy_type == USB_PHY_TYPE_DEVICE) {
> > +                       reg = sphy->pmuregs +
> > +                               sphy->drv_data->devphy_reg_offset;
> > +                       en_mask = sphy->drv_data->devphy_en_mask;
> > +               } else if (sphy->phy_type == USB_PHY_TYPE_HOST) {
> > +                       reg = sphy->pmuregs +
> > +                               sphy->drv_data->hostphy_reg_offset;
> > +                       en_mask = sphy->drv_data->hostphy_en_mask;
> > +               }
> > +               break;
> >         default:
> >                 dev_err(sphy->dev, "Invalid SoC type\n");
> >                 return;
> > @@ -422,6 +450,29 @@ static int samsung_usbphy_get_refclk_freq(struct
> > samsung_usbphy *sphy)
> >                         refclk_freq = FSEL_CLKSEL_24M;
> >                         break;
> >                 }
> > +       } else if (sphy->drv_data->cpu_type == TYPE_EXYNOS4412) {
> > +               switch (clk_get_rate(ref_clk)) {
> > +               case 9600 * KHZ:
> > +                       refclk_freq = FSEL_CLKSEL_9600K;
> > +                       break;
> > +               case 10 * MHZ:
> > +                       refclk_freq = FSEL_CLKSEL_10M;
> > +                       break;
> > +               case 12 * MHZ:
> > +                       refclk_freq = FSEL_CLKSEL_12M;
> > +                       break;
> > +               case 19200 * KHZ:
> > +                       refclk_freq = FSEL_CLKSEL_19200K;
> > +                       break;
> > +               case 20 * MHZ:
> > +                       refclk_freq = FSEL_CLKSEL_20M;
> > +                       break;
> > +               case 24 * MHZ:
> > +               default:
> > +                       /* default reference clock */
> > +                       refclk_freq = FSEL_CLKSEL_24M;
> > +                       break;
> > +               }
> >         } else {
> >                 switch (clk_get_rate(ref_clk)) {
> >                 case 12 * MHZ:
> > @@ -561,6 +612,69 @@ static void samsung_exynos5_usbphy_enable(struct
> > samsung_usbphy *sphy)
> >         writel(ohcictrl, regs + EXYNOS5_PHY_HOST_OHCICTRL);
> >  }
> >
> > +static bool exynos4_phyhost_is_on(void *regs)
> > +{
> > +       u32 reg;
> > +
> > +       reg = readl(regs + SAMSUNG_PHYPWR);
> > +
> > +       return !(reg & PHYPWR_ANALOG_POWERDOWN_PHY1);
> > +}
> > +
> > +static void samsung_exynos4412_usbphy_enable(struct samsung_usbphy
> > *sphy)
> > +{
> > +       void __iomem *regs = sphy->regs;
> > +       u32 phypwr;
> > +       u32 phyclk;
> > +       u32 rstcon;
> > +
> > +       /*
> > +        * phy_usage helps in keeping usage count for phy
> > +        * so that the first consumer enabling the phy is also
> > +        * the last consumer to disable it.
> > +        */
> > +
> > +       atomic_inc(&sphy->phy_usage);
> > +
> > +       if (exynos4_phyhost_is_on(regs)) {
> > +               dev_info(sphy->dev, "Already power on PHY\n");
> > +               return;
> > +       }
> > +
> > +       writel(EXYNOS_USBPHY_ENABLE, sphy->pmuregs +
> > EXYNOS4_PHY_HSIC_CTRL0);
> > +       writel(EXYNOS_USBPHY_ENABLE, sphy->pmuregs +
> > EXYNOS4_PHY_HSIC_CTRL1);
> > +
> > +       /* Common block configuration during suspend */
> > +       phyclk = sphy->ref_clk_freq
> > +               & ~(PHYCLK_COMMON_ON_N_PHY0 | PHYCLK_COMMON_ON_N_PHY1);
> Why PHY0 here? Shouldn't it come with the support for device phy?
> > +       writel(phyclk, regs + SAMSUNG_PHYCLK);
> > +
> > +       /* set to normal of Device */
> Please edit this comment for better readability. See the existing code.
> > +       phypwr = readl(regs + SAMSUNG_PHYPWR) &
> > ~PHYPWR_NORMAL_MASK_PHY0;
> > +       writel(phypwr, regs + SAMSUNG_PHYPWR);
> > +
> > +       /* set to normal of Host */
> Here as well
> > +       phypwr &= ~(PHYPWR_NORMAL_MASK_HSIC0 | PHYPWR_NORMAL_MASK_HSIC1
> > +                       | PHYPWR_NORMAL_MASK_PHY1);
> > +       writel(phypwr, regs + SAMSUNG_PHYPWR);
> > +
> > +       /* reset both PHY and Link of Device */
> > +       rstcon = readl(regs + SAMSUNG_RSTCON) | RSTCON_PHY0_SWRST_MASK;
> > +       writel(rstcon, regs + SAMSUNG_RSTCON);
> > +       udelay(10);
> > +       rstcon &= ~RSTCON_PHY0_SWRST_MASK;
> > +       writel(rstcon, regs + SAMSUNG_RSTCON);
> Do we really need to reset PHY0 too? As long as PHY0 is not required.
> > +
> > +       /* reset both PHY and Link of Host */
> > +       rstcon = readl(regs + SAMSUNG_RSTCON)
> > +               | (RSTCON_HLINK_SWRST_MASK | RSTCON_PHY1_SWRST_MASK);
> > +       writel(rstcon, regs + SAMSUNG_RSTCON);
> > +       udelay(10);
> > +       rstcon &= ~(RSTCON_HLINK_SWRST_MASK | RSTCON_PHY1_SWRST_MASK);
> > +       writel(rstcon, regs + SAMSUNG_RSTCON);
> > +       udelay(80);
> > +}
> > +
> >  static void samsung_usbphy_enable(struct samsung_usbphy *sphy)
> >  {
> >         void __iomem *regs = sphy->regs;
> > @@ -575,7 +689,7 @@ static void samsung_usbphy_enable(struct
> > samsung_usbphy *sphy)
> >
> >         switch (sphy->drv_data->cpu_type) {
> >         case TYPE_S3C64XX:
> > -               phyclk &= ~PHYCLK_COMMON_ON_N;
> > +               phyclk &= ~PHYCLK_COMMON_ON_N_PHY0;
> >                 phypwr &= ~PHYPWR_NORMAL_MASK;
> >                 rstcon |= RSTCON_SWRST;
> >                 break;
> > @@ -631,6 +745,28 @@ static void samsung_exynos5_usbphy_disable(struct
> > samsung_usbphy *sphy)
> >         writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
> >  }
> >
> > +static void samsung_exynos4412_usbphy_disable(struct samsung_usbphy
> > *sphy)
> > +{
> > +       void __iomem *regs = sphy->regs;
> > +       u32 phypwr;
> > +
> > +       if (atomic_dec_return(&sphy->phy_usage) > 0) {
> > +               dev_info(sphy->dev, "still being used\n");
> > +               return;
> > +       }
> > +
> > +       /* unset to normal of Host and Device */
> > +       phypwr = readl(regs + SAMSUNG_PHYPWR);
> > +       phypwr |= (PHYPWR_NORMAL_MASK_HSIC0
> > +                       | PHYPWR_NORMAL_MASK_HSIC1
> > +                       | PHYPWR_NORMAL_MASK_PHY1
> > +                       | PHYPWR_NORMAL_MASK_PHY0);
> PHY0?
> > +       writel(phypwr, regs + SAMSUNG_PHYPWR);
> > +
> > +       writel(0, sphy->pmuregs + EXYNOS4_PHY_HSIC_CTRL0);
> > +       writel(0, sphy->pmuregs + EXYNOS4_PHY_HSIC_CTRL1);
> > +}
> > +
> >  static void samsung_usbphy_disable(struct samsung_usbphy *sphy)
> >  {
> >         void __iomem *regs = sphy->regs;
> > @@ -696,6 +832,8 @@ static int samsung_usbphy_init(struct usb_phy *phy)
> >         /* Initialize usb phy registers */
> >         if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
> >                 samsung_exynos5_usbphy_enable(sphy);
> > +       else if (sphy->drv_data->cpu_type == TYPE_EXYNOS4412)
> > +               samsung_exynos4412_usbphy_enable(sphy);
> >         else
> >                 samsung_usbphy_enable(sphy);
> >
> > @@ -739,6 +877,8 @@ static void samsung_usbphy_shutdown(struct usb_phy
> > *phy)
> >         /* De-initialize usb phy registers */
> >         if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
> >                 samsung_exynos5_usbphy_disable(sphy);
> > +       else if (sphy->drv_data->cpu_type == TYPE_EXYNOS4412)
> > +               samsung_exynos4412_usbphy_disable(sphy);
> >         else
> >                 samsung_usbphy_disable(sphy);
> >
> > @@ -872,6 +1012,12 @@ static const struct samsung_usbphy_drvdata
> > usbphy_exynos4 = {
> >         .hostphy_en_mask        = EXYNOS_USBPHY_ENABLE,
> >  };
> >
> > +static const struct samsung_usbphy_drvdata usbphy_exynos4412 = {
> > +       .cpu_type               = TYPE_EXYNOS4412,
> > +       .devphy_en_mask         = EXYNOS_USBPHY_ENABLE,
> > +       .hostphy_en_mask        = EXYNOS_USBPHY_ENABLE,
> > +};
> > +
> >  static struct samsung_usbphy_drvdata usbphy_exynos5 = {
> >         .cpu_type               = TYPE_EXYNOS5250,
> >         .hostphy_en_mask        = EXYNOS_USBPHY_ENABLE,
> > @@ -887,6 +1033,9 @@ static const struct of_device_id
> > samsung_usbphy_dt_match[] = {
> >                 .compatible = "samsung,exynos4210-usbphy",
> >                 .data = &usbphy_exynos4,
> >         }, {
> > +               .compatible = "samsung,exynos4412-usbphy",
> > +               .data = &usbphy_exynos4412,
> > +       }, {
> >                 .compatible = "samsung,exynos5250-usbphy",
> >                 .data = &usbphy_exynos5
> >         },
> > @@ -903,6 +1052,9 @@ static struct platform_device_id
> > samsung_usbphy_driver_ids[] = {
> >                 .name           = "exynos4210-usbphy",
> >                 .driver_data    = (unsigned long)&usbphy_exynos4,
> >         }, {
> > +               .name           = "exynos4412-usbphy",
> > +               .driver_data    = (unsigned long)&usbphy_exynos4412,
> > +       }, {
> >                 .name           = "exynos5250-usbphy",
> >                 .driver_data    = (unsigned long)&usbphy_exynos5,
> >         },
> > --
> > 1.7.10.4
> I am not sure if you were following this.
> http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/15296
>
> Tomasz,
>
> Would you like to add something here?
>
> regards,
> Praveen
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
