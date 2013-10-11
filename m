Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab3JKNsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:48:06 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:47064 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3JKNsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:48:03 -0400
Message-ID: <5258018F.4090902@linaro.org>
Date: Fri, 11 Oct 2013 09:47:59 -0400
From: Matt Porter <matt.porter@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: balbi@ti.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 3/5] usb: phy: add Broadcom Kona USB control driver
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org> <1381140752-312-4-git-send-email-matt.porter@linaro.org> <20131010153154.GG28375@radagast>
In-Reply-To: <20131010153154.GG28375@radagast>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 11:31 AM, Felipe Balbi wrote:
> Hi,
>
> On Mon, Oct 07, 2013 at 06:12:30AM -0400, Matt Porter wrote:
>> Broadcom BCM281xx parts have a PHY control block that
>> operates in conjunction with the DWC2 USB OTG. This driver
>> exposes an API that allows control of power/reset for a
>> connected USB PHY.
>>
>> Signed-off-by: Matt Porter <matt.porter@linaro.org>
>> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
>> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
>> ---
>>   .../devicetree/bindings/usb/bcm-kona-usb-ctrl.txt  |  12 ++
>>   drivers/usb/phy/Kconfig                            |   5 +
>>   drivers/usb/phy/Makefile                           |   1 +
>>   drivers/usb/phy/bcm-kona-usb.h                     |  31 +++++
>>   drivers/usb/phy/phy-bcm-kona-ctrl.c                | 151 +++++++++++++++++++++
>>   5 files changed, 200 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/usb/bcm-kona-usb-ctrl.txt
>>   create mode 100644 drivers/usb/phy/bcm-kona-usb.h
>>   create mode 100644 drivers/usb/phy/phy-bcm-kona-ctrl.c
>>
>> diff --git a/Documentation/devicetree/bindings/usb/bcm-kona-usb-ctrl.txt b/Documentation/devicetree/bindings/usb/bcm-kona-usb-ctrl.txt
>> new file mode 100644
>> index 0000000..98163f6
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/usb/bcm-kona-usb-ctrl.txt
>> @@ -0,0 +1,12 @@
>> +BROADCOM KONA USB CONTROL
>> +
>> +Required properties:
>> + - compatible: brcm,kona-ctrl-usb
>> + - reg: offset and length of the USB control registers
>> +
>> +Example:
>> +
>> +	usbctl: usbctl@3f130000 {
>> +		compatible = "brcm,kona-ctrl-usb";
>> +		reg = <0x3f130000 0x28>;
>> +	};
>> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
>> index d5589f9..2b7b4f1 100644
>> --- a/drivers/usb/phy/Kconfig
>> +++ b/drivers/usb/phy/Kconfig
>> @@ -100,6 +100,11 @@ config AM335X_PHY_USB
>>   	  This driver provides PHY support for that phy which part for the
>>   	  AM335x SoC.
>>
>> +config BCM_KONA_CTRL_USB
>> +	tristate
>> +	help
>> +	  Enable this to support the Broadcom Kona USB control block
>> +
>>   config SAMSUNG_USBPHY
>>   	tristate
>>   	help
>> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
>> index 2135e85..98c545e 100644
>> --- a/drivers/usb/phy/Makefile
>> +++ b/drivers/usb/phy/Makefile
>> @@ -15,6 +15,7 @@ obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-generic.o
>>   obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
>>   obj-$(CONFIG_AM335X_CONTROL_USB)	+= phy-am335x-control.o
>>   obj-$(CONFIG_AM335X_PHY_USB)		+= phy-am335x.o
>> +obj-$(CONFIG_BCM_KONA_CTRL_USB)		+= phy-bcm-kona-ctrl.o
>>   obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>>   obj-$(CONFIG_OMAP_USB3)			+= phy-omap-usb3.o
>>   obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
>> diff --git a/drivers/usb/phy/bcm-kona-usb.h b/drivers/usb/phy/bcm-kona-usb.h
>> new file mode 100644
>> index 0000000..4563dd6
>> --- /dev/null
>> +++ b/drivers/usb/phy/bcm-kona-usb.h
>> @@ -0,0 +1,31 @@
>> +/*
>> + * bcm_kona_usb.h -- Broadcom Kona USB header file
>> + *
>> + * Copyright (C) 2013 Linaro Limited
>> + * Matt Porter <matt.porter@linaro.org>
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef __BCM_KONA_USB_H
>> +#define __BCM_KONA_USB_H
>> +
>> +#include <linux/usb/phy.h>
>> +
>> +struct bcm_kona_usb {
>> +	struct usb_phy phy;
>> +	struct device *dev;
>> +	struct device *ctrl_dev;
>> +};
>> +
>> +extern struct device *bcm_kona_get_ctrl_dev(void);
>> +extern void bcm_kona_ctrl_usb_phy_power(struct device *, int);
>
> looks like a job for extcon fwk.
>
>> diff --git a/drivers/usb/phy/phy-bcm-kona-ctrl.c b/drivers/usb/phy/phy-bcm-kona-ctrl.c
>> new file mode 100644
>> index 0000000..d2936b6
>> --- /dev/null
>> +++ b/drivers/usb/phy/phy-bcm-kona-ctrl.c
>> @@ -0,0 +1,151 @@
>> +/*
>> + * phy-bcm-kona-ctrl.c - Broadcom Kona USB Control Driver
>> + *
>> + * Based on phy-omap-control.c
>> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
>> + * Copyright (C) 2013 Linaro Limited
>> + * Matt Porter <matt.porter@linaro.org>
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/of.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/clk.h>
>> +
>> +#include "bcm-kona-usb.h"
>> +
>> +#define OTGCTL_OTGSTAT2		(1 << 31)
>> +#define OTGCTL_OTGSTAT1		(1 << 30)
>> +#define OTGCTL_PRST_N_SW	(1 << 11)
>> +#define OTGCTL_HRESET_N		(1 << 10)
>> +#define OTGCTL_UTMI_LINE_STATE1	(1 << 9)
>> +#define OTGCTL_UTMI_LINE_STATE0	(1 << 8)
>> +
>> +#define P1CTL_SOFT_RESET	(1 << 1)
>> +#define P1CTL_NON_DRIVING	(1 << 0)
>> +
>> +struct bcm_kona_usb_ctrl_regs {
>> +	u32 ctrl;
>> +	u32 cfg;
>> +	u32 p1ctl;
>> +	u32 status;
>> +	u32 bc_cfg;
>> +	u32 tp_in;
>> +	u32 tp_out;
>> +	u32 phy_ctrl;
>> +	u32 usbreg;
>> +	u32 usbproben;
>> +};
>> +
>> +struct bcm_kona_ctrl_usb {
>> +	struct device *dev;
>> +	struct bcm_kona_usb_ctrl_regs *regs;
>> +};
>> +
>> +static struct bcm_kona_ctrl_usb *ctrl_usb;
>> +
>> +/**
>> + * bcm_kona_ctrl_dev - returns the device pointer for this control device
>> + *
>> + * This API should be called to get the device pointer for the Kona USB
>> + * control device. This device pointer should be used when calling the
>> + * exported bcm_kona_ctrl_usb_phy_power() API.
>> + */
>> +struct device *bcm_kona_get_ctrl_dev(void)
>> +{
>> +	if (!ctrl_usb)
>> +		return ERR_PTR(-ENODEV);
>> +
>> +	return ctrl_usb->dev;
>> +}
>> +EXPORT_SYMBOL_GPL(bcm_kona_get_ctrl_dev);
>
> definitely a job for extcon ;-)
>
>> +void bcm_kona_ctrl_usb_phy_power(struct device *dev, int on)
>> +{
>> +	struct bcm_kona_ctrl_usb *ctrl = dev_get_drvdata(dev);
>> +	u32 val;
>> +
>> +	val = readl(&ctrl->regs->ctrl);
>> +	if (on) {
>> +		/* Configure and power PHY */
>> +		val &= ~(OTGCTL_OTGSTAT2 | OTGCTL_OTGSTAT1 |
>> +			 OTGCTL_UTMI_LINE_STATE1 | OTGCTL_UTMI_LINE_STATE0);
>> +		val |= OTGCTL_PRST_N_SW | OTGCTL_HRESET_N;
>> +		writel(val, &ctrl->regs->ctrl);
>> +
>> +		/* Soft reset PHY */
>> +		val = readl(&ctrl->regs->p1ctl);
>> +		val &= ~P1CTL_NON_DRIVING;
>> +		val |= P1CTL_SOFT_RESET;
>> +		writel(val, &ctrl->regs->p1ctl);
>> +		writel(val & ~P1CTL_SOFT_RESET, &ctrl->regs->p1ctl);
>> +		/* Reset needs to be asserted for 2ms */
>> +		mdelay(2);
>> +		writel(val | P1CTL_SOFT_RESET, &ctrl->regs->p1ctl);
>> +	} else {
>> +		val &= ~(OTGCTL_PRST_N_SW | OTGCTL_HRESET_N);
>> +		writel(val, &ctrl->regs->ctrl);
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(bcm_kona_ctrl_usb_phy_power);
>
> what a hack :-)

:)

> Please use phy->init() and phy->exit() callbacks. In fact, please use
> Kishon's generic PHY layer.

Ok, reworking on top of his series...looks to be straightforward.

Thanks,
Matt

