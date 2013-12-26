Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3LZKcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 05:32:14 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:64172 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab3LZKcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 05:32:12 -0500
MIME-Version: 1.0
In-Reply-To: <1387545857-9472-10-git-send-email-k.debski@samsung.com>
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
	<1387545857-9472-10-git-send-email-k.debski@samsung.com>
Date: Thu, 26 Dec 2013 16:02:09 +0530
Message-ID: <CAFp+6iH9AGP9J5regd7Z5XM8kP=PiFhvqxrV9qRf7rzmBSu9uQ@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] dts: Add usb2phy to Exynos 5250
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, kishon <kishon@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mateusz Krawczuk <mat.krawczuk@gmail.com>, yulgon.kim@samsung.com,
        Praveen Paneri <p.paneri@samsung.com>, av.tikhomirov@samsung.com,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        matt.porter@linaro.org, tjakobi@math.uni-bielefeld.de,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamil,


On Fri, Dec 20, 2013 at 6:54 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Add support to PHY of USB2 of the Exynos 5250 SoC.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi |   33 ++++++++++++-------
>  drivers/phy/phy-exynos5250-usb2.c |   64 +++++++++++++++++++++++++++++++++----
>  2 files changed, 78 insertions(+), 19 deletions(-)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 2f264ad..922e0ed 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -163,6 +163,11 @@
>                 interrupts = <0 47 0>;
>         };
>
> +       sys_syscon: syscon@10040000 {
> +               compatible = "samsung,exynos5250-sys", "syscon";
> +               reg = <0x10050000 0x5000>;
> +       };
> +
>         pmu_syscon: syscon@10040000 {
>                 compatible = "samsung,exynos5250-pmu", "syscon";
>                 reg = <0x10040000 0x5000>;
> @@ -505,6 +510,14 @@
>
>                 clocks = <&clock 285>;
>                 clock-names = "usbhost";
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               port@0 {
> +                       reg = <0>;
> +                       phys = <&usb2_phy 1>;
> +                       phy-names = "host";
> +                       status = "ok";
> +               };
>         };
>
>         usb@12120000 {
> @@ -516,19 +529,15 @@
>                 clock-names = "usbhost";
>         };
>
> -       usb2_phy: usbphy@12130000 {
> -               compatible = "samsung,exynos5250-usb2phy";
> +       usb2_phy: phy@12130000 {
> +               compatible = "samsung,exynos5250-usb2-phy";
>                 reg = <0x12130000 0x100>;
> -               clocks = <&clock 1>, <&clock 285>;
> -               clock-names = "ext_xtal", "usbhost";
> -               #address-cells = <1>;
> -               #size-cells = <1>;
> -               ranges;
> -
> -               usbphy-sys {
> -                       reg = <0x10040704 0x8>,
> -                             <0x10050230 0x4>;
> -               };
> +               clocks = <&clock 285>, <&clock 1>, <&clock 1>, <&clock 1>,
> +                                                               <&clock 1>;
> +               clock-names = "phy", "device", "host", "hsic0", "hsic1";
> +               #phy-cells = <1>;
> +               samsung,sysreg-phandle = <&sys_syscon>;
> +               samsung,pmureg-phandle = <&pmu_syscon>;
>         };
>
>         amba {
> diff --git a/drivers/phy/phy-exynos5250-usb2.c b/drivers/phy/phy-exynos5250-usb2.c
> index b9b3b98..337bf82 100644
> --- a/drivers/phy/phy-exynos5250-usb2.c
> +++ b/drivers/phy/phy-exynos5250-usb2.c

Separate patches for dt and driver ?
I think you wanted to move these changes to :
[PATCH v5 7/9] phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY driver

> @@ -58,7 +58,13 @@
>  #define EXYNOS_5250_HOSTPHYCTRL2                       0x20

Shouldn't we leave the naming as EXYNOS_5250_HSICPHYCTRL2 instead of
EXYNOS_5250_HOSTPHYCTRL2 ? That will go in sync with the user-manual too.
and similar for EXYNOS_5250_HOSTPHYCTRL1 and below bit definitions too ?

>
>  #define EXYNOS_5250_HOSTPHYCTRLX_REFCLKSEL_MASK                (0x3 << 23)
> +#define EXYNOS_5250_HOSTPHYCTRLX_REFCLKSEL_DEFAULT     (0x2 << 23)
>  #define EXYNOS_5250_HOSTPHYCTRLX_REFCLKDIV_MASK                (0x7f << 16)
> +#define EXYNOS_5250_HOSTPHYCTRLX_REFCLKDIV_12          (0x24 << 16)
> +#define EXYNOS_5250_HOSTPHYCTRLX_REFCLKDIV_15          (0x1c << 16)
> +#define EXYNOS_5250_HOSTPHYCTRLX_REFCLKDIV_16          (0x1a << 16)
> +#define EXYNOS_5250_HOSTPHYCTRLX_REFCLKDIV_19_2                (0x15 << 16)
> +#define EXYNOS_5250_HOSTPHYCTRLX_REFCLKDIV_20          (0x14 << 16)
>  #define EXYNOS_5250_HOSTPHYCTRLX_SIDDQ                 BIT(6)
>  #define EXYNOS_5250_HOSTPHYCTRLX_FORCESLEEP            BIT(5)
>  #define EXYNOS_5250_HOSTPHYCTRLX_FORCESUSPEND          BIT(4)
> @@ -191,13 +197,14 @@ static void exynos5250_isol(struct samsung_usb2_phy_instance *inst, bool on)
>         regmap_update_bits(drv->reg_pmu, offset, mask, on ? 0 : mask);
>  }
>
> -static void exynos5250_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
> +static int exynos5250_power_on(struct samsung_usb2_phy_instance *inst)

void ? we really don't have much to return in this function.

>  {
>         struct samsung_usb2_phy_driver *drv = inst->drv;
>         u32 ctrl0;
>         u32 otg;
>         u32 ehci;
>         u32 ohci;
> +       u32 hsic;
>
>         switch (inst->cfg->id) {
>         case EXYNOS5250_DEVICE:
> @@ -234,6 +241,8 @@ static void exynos5250_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
>
>                 break;
>         case EXYNOS5250_HOST:
> +       case EXYNOS5250_HSIC0:
> +       case EXYNOS5250_HSIC1:
>                 /* Host registers configuration */
>                 ctrl0 = readl(drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
>                 /* The clock */
> @@ -279,6 +288,18 @@ static void exynos5250_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
>                         EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
>                         EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET);
>
> +               /* HSIC phy configuration */
> +               hsic = (EXYNOS_5250_HOSTPHYCTRLX_REFCLKDIV_12 |
> +                               EXYNOS_5250_HOSTPHYCTRLX_REFCLKSEL_DEFAULT |
> +                               EXYNOS_5250_HOSTPHYCTRLX_PHYSWRST);
> +               writel(hsic, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL1);
> +               writel(hsic, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL2);
> +               udelay(10);
> +               hsic &= ~EXYNOS_5250_HOSTPHYCTRLX_PHYSWRST;
> +               writel(hsic, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL1);
> +               writel(hsic, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL2);
> +               udelay(80);
> +
>                 /* Enable EHCI DMA burst */
>                 ehci = readl(drv->reg_phy + EXYNOS_5250_HOSTEHCICTRL);
>                 ehci |= EXYNOS_5250_HOSTEHCICTRL_ENAINCRXALIGN |
> @@ -295,12 +316,7 @@ static void exynos5250_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
>
>                 break;
>         }
> -}
> -
> -static int exynos5250_power_on(struct samsung_usb2_phy_instance *inst)
> -{
>         inst->enabled = 1;
> -       exynos5250_phy_pwr(inst, 1);
>         exynos5250_isol(inst, 0);
>
>         return 0;
> @@ -308,9 +324,43 @@ static int exynos5250_power_on(struct samsung_usb2_phy_instance *inst)
>
>  static int exynos5250_power_off(struct samsung_usb2_phy_instance *inst)

ditto

>  {
> +       struct samsung_usb2_phy_driver *drv = inst->drv;
> +       u32 ctrl0;
> +       u32 otg;
> +       u32 hsic;
> +
>         inst->enabled = 0;
>         exynos5250_isol(inst, 1);
> -       exynos5250_phy_pwr(inst, 0);
> +
> +       switch (inst->cfg->id) {
> +       case EXYNOS5250_DEVICE:
> +               otg = readl(drv->reg_phy + EXYNOS_5250_USBOTGSYS);
> +               otg |= (EXYNOS_5250_USBOTGSYS_FORCE_SUSPEND |
> +                       EXYNOS_5250_USBOTGSYS_SIDDQ_UOTG |
> +                       EXYNOS_5250_USBOTGSYS_FORCE_SLEEP);
> +               writel(otg, drv->reg_phy + EXYNOS_5250_USBOTGSYS);
> +               break;
> +       case EXYNOS5250_HOST:
> +               ctrl0 = readl(drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
> +               ctrl0 |= (EXYNOS_5250_HOSTPHYCTRL0_SIDDQ |
> +                               EXYNOS_5250_HOSTPHYCTRL0_FORCESUSPEND |
> +                               EXYNOS_5250_HOSTPHYCTRL0_FORCESLEEP |
> +                               EXYNOS_5250_HOSTPHYCTRL0_PHYSWRST |
> +                               EXYNOS_5250_HOSTPHYCTRL0_PHYSWRSTALL);
> +               writel(ctrl0, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
> +               break;
> +       case EXYNOS5250_HSIC0:
> +       case EXYNOS5250_HSIC1:
> +               hsic = (EXYNOS_5250_HOSTPHYCTRLX_REFCLKDIV_12 |
> +                               EXYNOS_5250_HOSTPHYCTRLX_REFCLKSEL_DEFAULT |
> +                               EXYNOS_5250_HOSTPHYCTRLX_SIDDQ |
> +                               EXYNOS_5250_HOSTPHYCTRLX_FORCESLEEP |
> +                               EXYNOS_5250_HOSTPHYCTRLX_FORCESUSPEND
> +                               );
> +               writel(hsic, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL1);
> +               writel(hsic, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL2);
> +               break;
> +       }
>
>         return 0;
>  }
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
