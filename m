Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab3HFLwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 07:52:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35569 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab3HFLwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 07:52:37 -0400
Message-ID: <5200E380.6030005@ti.com>
Date: Tue, 6 Aug 2013 17:22:32 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <dmurphy@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] usb: phy: omap: get rid of omap_get_control_dev()
References: <1375365915-21380-1-git-send-email-rogerq@ti.com> <1375365915-21380-6-git-send-email-rogerq@ti.com>
In-Reply-To: <1375365915-21380-6-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 August 2013 07:35 PM, Roger Quadros wrote:
> This function was preventing us from supporting multiple
> instances. Get rid of it. Since we support DT boots only,
> users can get the control device phandle from the DT node.
>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Tested-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   drivers/usb/phy/phy-omap-control.c   |   31 ++++++++++---------------------
>   include/linux/usb/omap_control_usb.h |    5 -----
>   2 files changed, 10 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/usb/phy/phy-omap-control.c
> index cf93c5a..015eeef 100644
> --- a/drivers/usb/phy/phy-omap-control.c
> +++ b/drivers/usb/phy/phy-omap-control.c
> @@ -25,26 +25,6 @@
>   #include <linux/clk.h>
>   #include <linux/usb/omap_control_usb.h>
>
> -static struct omap_control_usb *control_usb;
> -
> -/**
> - * omap_get_control_dev - returns the device pointer for this control device
> - *
> - * This API should be called to get the device pointer for this control
> - * module device. This device pointer should be used for called other
> - * exported API's in this driver.
> - *
> - * To be used by PHY driver and glue driver.
> - */
> -struct device *omap_get_control_dev(void)
> -{
> -	if (!control_usb)
> -		return ERR_PTR(-ENODEV);
> -
> -	return control_usb->dev;
> -}
> -EXPORT_SYMBOL_GPL(omap_get_control_dev);
> -
>   /**
>    * omap_control_usb_phy_power - power on/off the phy using control module reg
>    * @dev: the control module device
> @@ -187,11 +167,19 @@ void omap_control_usb_set_mode(struct device *dev,
>   {
>   	struct omap_control_usb	*ctrl_usb;
>
> -	if (IS_ERR(dev) || control_usb->type != OMAP_CTRL_DEV_TYPE1)
> +	if (IS_ERR(dev) || !dev)
>   		return;
>
>   	ctrl_usb = dev_get_drvdata(dev);
>
> +	if (!ctrl_usb) {
> +		dev_err(dev, "Invalid control usb device\n");
> +		return;
> +	}
> +
> +	if (ctrl_usb->type != OMAP_CTRL_DEV_TYPE1)
> +		return;
> +
>   	switch (mode) {
>   	case USB_MODE_HOST:
>   		omap_control_usb_host_mode(ctrl_usb);
> @@ -214,6 +202,7 @@ static int omap_control_usb_probe(struct platform_device *pdev)
>   	struct device_node *np = pdev->dev.of_node;
>   	struct omap_control_usb_platform_data *pdata =
>   			dev_get_platdata(&pdev->dev);
> +	struct omap_control_usb *control_usb;
>
>   	control_usb = devm_kzalloc(&pdev->dev, sizeof(*control_usb),
>   		GFP_KERNEL);
> diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/usb/omap_control_usb.h
> index 7f027d3..8b48584 100644
> --- a/include/linux/usb/omap_control_usb.h
> +++ b/include/linux/usb/omap_control_usb.h
> @@ -67,15 +67,10 @@ enum omap_control_usb_mode {
>   #define OMAP_CTRL_USB2_PHY_PD		BIT(28)
>
>   #if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)
> -extern struct device *omap_get_control_dev(void);
>   extern void omap_control_usb_phy_power(struct device *dev, int on);
>   extern void omap_control_usb_set_mode(struct device *dev,
>   	enum omap_control_usb_mode mode);
>   #else
> -static inline struct device *omap_get_control_dev(void)
> -{
> -	return ERR_PTR(-ENODEV);
> -}
>
>   static inline void omap_control_usb_phy_power(struct device *dev, int on)
>   {
>

