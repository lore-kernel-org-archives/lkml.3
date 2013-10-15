Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab3JOPuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:50:13 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:36923 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901Ab3JOPuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:50:10 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <201310141435.31147.hartleys@visionengravers.com>
References: <201310141435.31147.hartleys@visionengravers.com>
Date: Tue, 15 Oct 2013 08:50:07 -0700
Message-ID: <CAOesGMgDW6scSq7s__Cyu-V=o2xFAbR2zKgO4FF8Jd29CyWy_w@mail.gmail.com>
Subject: Re: [PATCH] usb: ohci: remove ep93xx bus glue platform driver
From: Olof Johansson <olof@lixom.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Ryan Mallon <rmallon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 14, 2013 at 2:35 PM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> Convert ep93xx to use the OHCI platform driver and remove the
> ohci-ep93xx bus glue driver.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Ryan Mallon <rmallon@gmail.com>
> ---
>  arch/arm/mach-ep93xx/clock.c   |   2 +-
>  arch/arm/mach-ep93xx/core.c    |  45 +++++++++-
>  drivers/usb/host/Kconfig       |   2 +-
>  drivers/usb/host/ohci-ep93xx.c | 184 -----------------------------------------
>  drivers/usb/host/ohci-hcd.c    |  18 ----
>  5 files changed, 43 insertions(+), 208 deletions(-)
>  delete mode 100644 drivers/usb/host/ohci-ep93xx.c
>
> diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
> index c95dbce..39ef3b6 100644
> --- a/arch/arm/mach-ep93xx/clock.c
> +++ b/arch/arm/mach-ep93xx/clock.c
> @@ -212,7 +212,7 @@ static struct clk_lookup clocks[] = {
>         INIT_CK(NULL,                   "hclk",         &clk_h),
>         INIT_CK(NULL,                   "apb_pclk",     &clk_p),
>         INIT_CK(NULL,                   "pll2",         &clk_pll2),
> -       INIT_CK("ep93xx-ohci",          NULL,           &clk_usb_host),
> +       INIT_CK("ohci-platform",        NULL,           &clk_usb_host),
>         INIT_CK("ep93xx-keypad",        NULL,           &clk_keypad),
>         INIT_CK("ep93xx-fb",            NULL,           &clk_video),
>         INIT_CK("ep93xx-spi.0",         NULL,           &clk_spi),
> diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
> index 3f12b88..5489824 100644
> --- a/arch/arm/mach-ep93xx/core.c
> +++ b/arch/arm/mach-ep93xx/core.c
> @@ -36,6 +36,7 @@
>  #include <linux/export.h>
>  #include <linux/irqchip/arm-vic.h>
>  #include <linux/reboot.h>
> +#include <linux/usb/ohci_pdriver.h>
>
>  #include <mach/hardware.h>
>  #include <linux/platform_data/video-ep93xx.h>
> @@ -297,22 +298,58 @@ static struct platform_device ep93xx_rtc_device = {
>         .resource       = ep93xx_rtc_resource,
>  };
>
> +/*************************************************************************
> + * EP93xx OHCI USB Host
> + *************************************************************************/
> +
> +static struct clk *ep93xx_ohci_host_clock;
> +
> +static int ep93xx_ohci_power_on(struct platform_device *pdev)
> +{
> +       if (!ep93xx_ohci_host_clock) {
> +               ep93xx_ohci_host_clock = devm_clk_get(&pdev->dev, NULL);
> +               if (IS_ERR(ep93xx_ohci_host_clock))
> +                       return PTR_ERR(ep93xx_ohci_host_clock);
> +       }
> +
> +       clk_enable(ep93xx_ohci_host_clock);
> +
> +       return 0;
> +}
> +
> +static void ep93xx_ohci_power_off(struct platform_device *pdev)
> +{
> +       clk_disable(ep93xx_ohci_host_clock);
> +}
> +
> +static void ep93xx_ohci_power_suspend(struct platform_device *pdev)
> +{
> +       ep93xx_ohci_power_off(pdev);
> +}
> +
> +static struct usb_ohci_pdata ep93xx_ohci_pdata = {
> +       .power_on       = ep93xx_ohci_power_on,
> +       .power_off      = ep93xx_ohci_power_off,
> +       .power_suspend  = ep93xx_ohci_power_suspend,
> +};

This is definitely not a show-stopper in any way, but since this is
just standard clock management, could you even move these clock ops
into the driver? Are any other platforms already doing similar things
so you could remove code from their platform that way as well, per
chance?


-Olof
