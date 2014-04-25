Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaDYQJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:09:48 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:33311 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaDYQJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:09:46 -0400
Date: Fri, 25 Apr 2014 18:07:05 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 14/18] ARM: mvebu: Add support for USB cluster on the
 Armada 375 SoC
Message-ID: <20140425160705.GE12472@lunn.ch>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
 <1398434836-18908-15-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398434836-18908-15-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 04:07:12PM +0200, Gregory CLEMENT wrote:
> The Armada 375 SoC comes with an USB2 host and device controller and
> an USB3 controller. The USB cluster control register allows to manage
> common features of both USB controllers.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  arch/arm/mach-mvebu/Makefile      |  2 +-
>  arch/arm/mach-mvebu/usb-cluster.c | 96 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 97 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/mach-mvebu/usb-cluster.c
> 
> diff --git a/arch/arm/mach-mvebu/Makefile b/arch/arm/mach-mvebu/Makefile
> index a63e43b6b451..dec05e7e1802 100644
> --- a/arch/arm/mach-mvebu/Makefile
> +++ b/arch/arm/mach-mvebu/Makefile
> @@ -4,7 +4,7 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include \
>  AFLAGS_coherency_ll.o		:= -Wa,-march=armv7-a
>  
>  obj-y				 += system-controller.o mvebu-soc-id.o
> -obj-$(CONFIG_MACH_MVEBU_V7)      += board-v7.o
> +obj-$(CONFIG_MACH_MVEBU_V7)      += board-v7.o usb-cluster.o
>  obj-$(CONFIG_MACH_DOVE)		 += dove.o
>  obj-$(CONFIG_ARCH_MVEBU)	 += coherency.o coherency_ll.o pmsu.o
>  obj-$(CONFIG_SMP)                += platsmp.o headsmp.o
> diff --git a/arch/arm/mach-mvebu/usb-cluster.c b/arch/arm/mach-mvebu/usb-cluster.c
> new file mode 100644
> index 000000000000..4c15d282db23
> --- /dev/null
> +++ b/arch/arm/mach-mvebu/usb-cluster.c
> @@ -0,0 +1,96 @@
> +/*
> + * USB cluster support for Armada 375 platform.
> + *
> + * Copyright (C) 2014 Marvell
> + *
> + * Gregory CLEMENT <gregory.clement@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + *
> + * Armada 375 comes with an USB2 host and device controller and an
> + * USB3 controller. The USB cluster control register allows to manage
> + * common features of both USB controller.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/of_address.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +
> +#define USB2_PHY_CONFIG_ENABLE BIT(0) /* active low */
> +
> +static struct of_device_id of_usb_cluster_table[] = {
> +	{ .compatible = "marvell,armada-375-usb-cluster", },
> +	{ /* end of list */ },
> +};
> +
> +static int __init mvebu_usb_cluster_init(void)
> +{
> +	struct device_node *np;
> +
> +	np = of_find_matching_node(NULL, of_usb_cluster_table);
> +	if (np) {
> +		void __iomem *usb_cluster_base;
> +		u32 reg;
> +		struct device_node *ehci_node, *xhci_node;
> +		struct property *ehci_status;
> +		bool use_usb3 = false;
> +
> +		usb_cluster_base = of_iomap(np, 0);
> +		BUG_ON(!usb_cluster_base);
> +
> +		xhci_node = of_find_compatible_node(NULL, NULL,
> +						"marvell,armada-375-xhci");
> +
> +		if (xhci_node && of_device_is_available(xhci_node))
> +			use_usb3 = true;
> +
> +		ehci_node = of_find_compatible_node(NULL, NULL,
> +						"marvell,orion-ehci");
> +
> +		if (ehci_node && of_device_is_available(ehci_node)
> +			&& use_usb3) {
> +			/*
> +			 * We can't use usb2 and usb3 in the same time, so let's
> +			 * disbale usb2 and complain about it to the user askinf
> +			 * to fix the device tree.
> +			 */
> +
> +			ehci_status = kzalloc(sizeof(struct property),
> +					GFP_KERNEL);
> +			WARN_ON(!ehci_status);
> +
> +			ehci_status->value = kstrdup("disabled", GFP_KERNEL);
> +			WARN_ON(!ehci_status->value);
> +
> +			ehci_status->length = 8;
> +			ehci_status->name = kstrdup("status", GFP_KERNEL);
> +			WARN_ON(!ehci_status->name);
> +
> +			of_update_property(ehci_node, ehci_status);
> +			pr_err("%s: armada-375-xhci and orion-ehci are incompatible for this SoC.\n",
> +				__func__);
> +			pr_err("Please fix your dts!\n");
> +			pr_err("orion-ehci have been disabled by default...\n");
> +
> +		}
> +
> +		reg = readl(usb_cluster_base);
> +		if (use_usb3)
> +			reg |= USB2_PHY_CONFIG_ENABLE;
> +		else
> +			reg &= ~USB2_PHY_CONFIG_ENABLE;
> +		writel(reg, usb_cluster_base);

Am i right in saying this in the end is about enabling the USB2 phy or
a USB3 why? So why not just implement a phy driver?

  Andrew
