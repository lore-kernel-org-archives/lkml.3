Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3GHLhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:37:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37786 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab3GHLhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:37:37 -0400
Message-ID: <51DAA473.9030207@ti.com>
Date: Mon, 8 Jul 2013 17:07:23 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <bigeasy@linutronix.de>
Subject: Re: [PATCH 2/5] usb: phy: phy-omap-control: Add API to power on/off
 USB PHY for AM335X
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com> <1373280201-31785-3-git-send-email-george.cherian@ti.com>
In-Reply-To: <1373280201-31785-3-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 08 July 2013 04:13 PM, George Cherian wrote:
> Add API to power on/off USB PHY for AM335X. This API will be called
> from phy-amxxxx-usb driver.
>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/usb/phy/phy-omap-control.c   | 32 ++++++++++++++++++++++++++++++++
>   include/linux/usb/omap_control_usb.h | 11 +++++++++++
>   2 files changed, 43 insertions(+)
>
> diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/usb/phy/phy-omap-control.c
> index 1419ced..0c1822d 100644
> --- a/drivers/usb/phy/phy-omap-control.c
> +++ b/drivers/usb/phy/phy-omap-control.c
> @@ -46,6 +46,38 @@ struct device *omap_get_control_dev(void)
>   EXPORT_SYMBOL_GPL(omap_get_control_dev);
>
>   /**
> + * omap_control_am335x_phy_power - power on/off the serializer using control
> + *	module
> + * @dev: the control module device
> + * @on: 0 to off and 1 to on based on powering on or off the PHY
> + * @id: phy id 0 or 1 for phy instance 0 and 1 repectively
> + *
> + * AMXXXX PHY driver should call this API to power on or off the PHY.
> + */
> +void omap_control_am335x_phy_power(struct device *dev, bool on, u8 id)
> +{
> +	u32 val;
> +	struct omap_control_usb	*control_usb = dev_get_drvdata(dev);
> +
> +	if (control_usb->type != OMAP_CTRL_DEV_TYPE3)
> +		return;

Lets validate id also here.
> +
> +	val = readl(control_usb->dev_conf + (id * 2));

Understand you use id to calculate the offset. But looks a bit hacky to me.
Can we define macros and use it instead?
> +
> +	if (on) {
> +		val &= ~(AM335X_USBPHY_CM_PWRDN | AM335X_USBPHY_OTG_PWRDN);
> +		val |= AM335X_USBPHY_OTGVDET_EN |
> +			AM335X_USBPHY_OTGSESSEND_EN;
> +	} else
> +		val |= AM335X_USBPHY_CM_PWRDN | AM335X_USBPHY_OTG_PWRDN;
> +
> +
> +	writel(val, (control_usb->dev_conf + (id * 2)));
> +}
> +EXPORT_SYMBOL_GPL(omap_control_am335x_phy_power);
> +
> +
> +/**
>    * omap_control_usb3_phy_power - power on/off the serializer using control
>    *	module
>    * @dev: the control module device
> diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/usb/omap_control_usb.h
> index 27b5b8c..11d7a34 100644
> --- a/include/linux/usb/omap_control_usb.h
> +++ b/include/linux/usb/omap_control_usb.h
> @@ -45,6 +45,7 @@ enum omap_control_usb_mode {
>   /* To differentiate ctrl module IP having either mailbox or USB3 PHY power */
>   #define	OMAP_CTRL_DEV_TYPE1		0x1
>   #define	OMAP_CTRL_DEV_TYPE2		0x2
> +#define	OMAP_CTRL_DEV_TYPE3		0x3
>
>   #define	OMAP_CTRL_DEV_PHY_PD		BIT(0)
>
> @@ -63,10 +64,20 @@ enum omap_control_usb_mode {
>   #define	OMAP_CTRL_USB3_PHY_TX_RX_POWERON	0x3
>   #define	OMAP_CTRL_USB3_PHY_TX_RX_POWEROFF	0x0
>
> +#define AM335X_USBPHY_CM_PWRDN		(1 << 0)
> +#define AM335X_USBPHY_OTG_PWRDN		(1 << 1)
> +#define AM335X_USBPHY_OTGVDET_EN		(1 << 19)
> +#define AM335X_USBPHY_OTGSESSEND_EN	(1 << 20)
> +#define AM335X_USB0_WKUP_CTRL_ENABLE	(1 << 0)
> +#define AM335X_USB1_WKUP_CTRL_ENABLE	(1 << 8)
> +
> +
> +
>   #if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)
>   extern struct device *omap_get_control_dev(void);
>   extern void omap_control_usb_phy_power(struct device *dev, int on);
>   extern void omap_control_usb3_phy_power(struct device *dev, bool on);
> +extern void omap_control_am335x_phy_power(struct device *dev, bool on, u8 id);

You might also need to provide an empty stub when CONFIG_OMAP_CONTROL_USB is
not set.

Thanks
Kishon
