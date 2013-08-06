Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3HFLsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 07:48:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33257 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab3HFLs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 07:48:27 -0400
Message-ID: <5200E286.8050303@ti.com>
Date: Tue, 6 Aug 2013 17:18:22 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <dmurphy@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] usb: phy: omap-usb3: Don't use omap_get_control_dev()
References: <1375365915-21380-1-git-send-email-rogerq@ti.com> <1375365915-21380-4-git-send-email-rogerq@ti.com>
In-Reply-To: <1375365915-21380-4-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 August 2013 07:35 PM, Roger Quadros wrote:
> omap_get_control_dev() is being deprecated as it doesn't support
> multiple instances. As control device is present only from OMAP4
> onwards which supports DT only, we use phandles to get the
> reference to the control device.
>
> As we don't support non-DT boot, we just bail out on probe
> if device node is not present.
>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Tested-by: Kishon Vijay Abraham I <kishon@ti.com>


> ---
>   drivers/usb/phy/phy-omap-usb3.c |   20 +++++++++++++++++---
>   1 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/phy/phy-omap-usb3.c b/drivers/usb/phy/phy-omap-usb3.c
> index 4a7f27c..bad032e 100644
> --- a/drivers/usb/phy/phy-omap-usb3.c
> +++ b/drivers/usb/phy/phy-omap-usb3.c
> @@ -26,6 +26,7 @@
>   #include <linux/pm_runtime.h>
>   #include <linux/delay.h>
>   #include <linux/usb/omap_control_usb.h>
> +#include <linux/of_platform.h>
>
>   #define	PLL_STATUS		0x00000004
>   #define	PLL_GO			0x00000008
> @@ -198,6 +199,12 @@ static int omap_usb3_probe(struct platform_device *pdev)
>   {
>   	struct omap_usb			*phy;
>   	struct resource			*res;
> +	struct device_node *node = pdev->dev.of_node;
> +	struct device_node *control_node;
> +	struct platform_device *control_pdev;
> +
> +	if (!node)
> +		return -ENODEV;
>
>   	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
>   	if (!phy) {
> @@ -239,11 +246,18 @@ static int omap_usb3_probe(struct platform_device *pdev)
>   		return -EINVAL;
>   	}
>
> -	phy->control_dev = omap_get_control_dev();
> -	if (IS_ERR(phy->control_dev)) {
> -		dev_dbg(&pdev->dev, "Failed to get control device\n");
> +	control_node = of_parse_phandle(node, "ctrl-module", 0);
> +	if (!control_node) {
> +		dev_err(&pdev->dev, "Failed to get control device phandle\n");
>   		return -ENODEV;
>   	}
> +	control_pdev = of_find_device_by_node(control_node);
> +	if (!control_pdev) {
> +		dev_err(&pdev->dev, "Failed to get control device\n");
> +		return -ENODEV;
> +	}
> +
> +	phy->control_dev = &control_pdev->dev;
>
>   	omap_control_usb_phy_power(phy->control_dev, 0);
>   	usb_add_phy_dev(&phy->phy);
>

