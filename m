Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3KDG2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 01:28:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:32953 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab3KDG2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 01:28:07 -0500
Message-ID: <52773E3E.10909@ti.com>
Date: Mon, 4 Nov 2013 11:57:10 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matt Porter <matt.porter@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v2 8/9] phy: add Broadcom Kona USB2 PHY driver
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org> <1383335158-19730-9-git-send-email-matt.porter@linaro.org>
In-Reply-To: <1383335158-19730-9-git-send-email-matt.porter@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 02 November 2013 01:15 AM, Matt Porter wrote:
> Add a driver for the internal Broadcom Kona USB 2.0 PHY found
> on the BCM281xx family of SoCs.
>
> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> ---
>   drivers/phy/Kconfig             |   6 ++
>   drivers/phy/Makefile            |   2 +
>   drivers/phy/phy-bcm-kona-usb2.c | 161 ++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 169 insertions(+)
>   create mode 100644 drivers/phy/phy-bcm-kona-usb2.c
>
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 349bef2..cedada5 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -15,4 +15,10 @@ config GENERIC_PHY
>   	  phy users can obtain reference to the PHY. All the users of this
>   	  framework should select this config.
>
> +config BCM_KONA_USB2_PHY
> +	tristate "Broadcom Kona USB2 PHY Driver"
> +	depends on GENERIC_PHY
> +	help
> +	  Enable this to support the Broadcom Kona USB 2.0 PHY.
> +
>   endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 9e9560f..ce83a14 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -3,3 +3,5 @@
>   #
>
>   obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
> +
> +obj-$(CONFIG_BCM_KONA_USB2_PHY)	+= phy-bcm-kona-usb2.o
> diff --git a/drivers/phy/phy-bcm-kona-usb2.c b/drivers/phy/phy-bcm-kona-usb2.c
> new file mode 100644
> index 0000000..1beea7f
> --- /dev/null
> +++ b/drivers/phy/phy-bcm-kona-usb2.c
> @@ -0,0 +1,161 @@
> +/*
> + * phy-bcm-kona-usb2.c - Broadcom Kona USB2 Phy Driver
> + *
> + * Copyright (C) 2013 Linaro Limited
> + * Matt Porter <matt.porter@linaro.org>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/phy/phy.h>
> +
> +#define OTGCTL_OTGSTAT2		(1 << 31)
> +#define OTGCTL_OTGSTAT1		(1 << 30)
> +#define OTGCTL_PRST_N_SW	(1 << 11)
> +#define OTGCTL_HRESET_N		(1 << 10)
> +#define OTGCTL_UTMI_LINE_STATE1	(1 << 9)
> +#define OTGCTL_UTMI_LINE_STATE0	(1 << 8)
> +
> +#define P1CTL_SOFT_RESET	(1 << 1)
> +#define P1CTL_NON_DRIVING	(1 << 0)
> +
> +struct bcm_kona_usb_phy_regs {
> +	u32 ctrl;
> +	u32 cfg;
> +	u32 p1ctl;
> +	u32 status;
> +	u32 bc_cfg;
> +	u32 tp_in;
> +	u32 tp_out;
> +	u32 phy_ctrl;
> +	u32 usbreg;
> +	u32 usbproben;
> +};

I would prefer to have constant macros for register offset unless you 
have a good reason to do otherwise.
> +
> +struct bcm_kona_usb {
> +	struct bcm_kona_usb_phy_regs *regs;
> +};
> +
> +static void bcm_kona_usb_phy_power(struct bcm_kona_usb *phy, int on)
> +{
> +	u32 val;
> +
> +	val = readl(&phy->regs->ctrl);
> +	if (on) {
> +		/* Configure and power PHY */
> +		val &= ~(OTGCTL_OTGSTAT2 | OTGCTL_OTGSTAT1 |
> +			 OTGCTL_UTMI_LINE_STATE1 | OTGCTL_UTMI_LINE_STATE0);
> +		val |= OTGCTL_PRST_N_SW | OTGCTL_HRESET_N;
> +		writel(val, &phy->regs->ctrl);
> +
> +		/* Soft reset PHY */
> +		val = readl(&phy->regs->p1ctl);
> +		val &= ~P1CTL_NON_DRIVING;
> +		val |= P1CTL_SOFT_RESET;
> +		writel(val, &phy->regs->p1ctl);
> +		writel(val & ~P1CTL_SOFT_RESET, &phy->regs->p1ctl);
> +		/* Reset needs to be asserted for 2ms */
> +		mdelay(2);
> +		writel(val | P1CTL_SOFT_RESET, &phy->regs->p1ctl);

Is soft reset needed for every power-on? Shouldn't soft reset be present 
in phy_init?

Cheers
Kishon
