Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475Ab3E3VAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:00:40 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64508 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3E3VAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:00:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+gWBwi1oPRbN4Xc8yFFU6N
Date: Thu, 30 May 2013 14:00:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: linux@arm.linux.org.uk, balbi@ti.com, shc_work@mail.ru,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: omap-usb-host: Fix memory leaks
Message-ID: <20130530210025.GE6467@atomide.com>
References: <1369400818-31625-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369400818-31625-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

* Roger Quadros <rogerq@ti.com> [130524 06:12]:
> Fix memory leaks in the error path.
> Also, use platform_device_register_full() to allocate
> the platform devices and set platform data.

If you need this for the v3.10-rc, you should describe why this patch
is needed and ideally have some oops or regression causing commit
listed. Care to update the description for that?

Regards,

Tony
 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/mach-omap2/usb-host.c |  106 +++++++++++++++++++++-------------------
>  1 files changed, 56 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
> index aa27d7f..609b330 100644
> --- a/arch/arm/mach-omap2/usb-host.c
> +++ b/arch/arm/mach-omap2/usb-host.c
> @@ -28,6 +28,7 @@
>  #include <linux/io.h>
>  #include <linux/gpio.h>
>  #include <linux/usb/phy.h>
> +#include <linux/usb/nop-usb-xceiv.h>
>  
>  #include "soc.h"
>  #include "omap_device.h"
> @@ -560,7 +561,8 @@ static int usbhs_add_regulator(char *name, char *dev_id, char *dev_supply,
>  	struct regulator_init_data *reg_data;
>  	struct fixed_voltage_config *config;
>  	struct platform_device *pdev;
> -	int ret;
> +	struct platform_device_info pdevinfo;
> +	int ret = -ENOMEM;
>  
>  	supplies = kzalloc(sizeof(*supplies), GFP_KERNEL);
>  	if (!supplies)
> @@ -571,7 +573,7 @@ static int usbhs_add_regulator(char *name, char *dev_id, char *dev_supply,
>  
>  	reg_data = kzalloc(sizeof(*reg_data), GFP_KERNEL);
>  	if (!reg_data)
> -		return -ENOMEM;
> +		goto err_data;
>  
>  	reg_data->constraints.valid_ops_mask = REGULATOR_CHANGE_STATUS;
>  	reg_data->consumer_supplies = supplies;
> @@ -580,39 +582,53 @@ static int usbhs_add_regulator(char *name, char *dev_id, char *dev_supply,
>  	config = kmemdup(&hsusb_reg_config, sizeof(hsusb_reg_config),
>  			GFP_KERNEL);
>  	if (!config)
> -		return -ENOMEM;
> +		goto err_config;
> +
> +	config->supply_name = kstrdup(name, GFP_KERNEL);
> +	if (!config->supply_name)
> +		goto err_supplyname;
>  
> -	config->supply_name = name;
>  	config->gpio = gpio;
>  	config->enable_high = polarity;
>  	config->init_data = reg_data;
>  
>  	/* create a regulator device */
> -	pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
> -	if (!pdev)
> -		return -ENOMEM;
> +	memset(&pdevinfo, 0, sizeof(pdevinfo));
> +	pdevinfo.name = reg_name;
> +	pdevinfo.id = PLATFORM_DEVID_AUTO;
> +	pdevinfo.data = config;
> +	pdevinfo.size_data = sizeof(*config);
>  
> -	pdev->id = PLATFORM_DEVID_AUTO;
> -	pdev->name = reg_name;
> -	pdev->dev.platform_data = config;
> +	pdev = platform_device_register_full(&pdevinfo);
> +	if (IS_ERR(pdev)) {
> +		ret = PTR_ERR(pdev);
> +		pr_err("%s: Failed registering regulator %s for %s : %d\n",
> +				__func__, name, dev_id, ret);
> +		goto err_register;
> +	}
>  
> -	ret = platform_device_register(pdev);
> -	if (ret)
> -		pr_err("%s: Failed registering regulator %s for %s\n",
> -				__func__, name, dev_id);
> +	return 0;
>  
> +err_register:
> +	kfree(config->supply_name);
> +err_supplyname:
> +	kfree(config);
> +err_config:
> +	kfree(reg_data);
> +err_data:
> +	kfree(supplies);
>  	return ret;
>  }
>  
> +#define MAX_STR 20
> +
>  int usbhs_init_phys(struct usbhs_phy_data *phy, int num_phys)
>  {
> -	char *rail_name;
> -	int i, len;
> +	char rail_name[MAX_STR];
> +	int i;
>  	struct platform_device *pdev;
>  	char *phy_id;
> -
> -	/* the phy_id will be something like "nop_usb_xceiv.1" */
> -	len = strlen(nop_name) + 3; /* 3 -> ".1" and NULL terminator */
> +	struct platform_device_info pdevinfo;
>  
>  	for (i = 0; i < num_phys; i++) {
>  
> @@ -627,25 +643,26 @@ int usbhs_init_phys(struct usbhs_phy_data *phy, int num_phys)
>  			!gpio_is_valid(phy->vcc_gpio))
>  			continue;
>  
> -		/* create a NOP PHY device */
> -		pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
> -		if (!pdev)
> -			return -ENOMEM;
> -
> -		pdev->id = phy->port;
> -		pdev->name = nop_name;
> -		pdev->dev.platform_data = phy->platform_data;
> -
> -		phy_id = kmalloc(len, GFP_KERNEL);
> -		if (!phy_id)
> +		phy_id = kmalloc(MAX_STR, GFP_KERNEL);
> +		if (!phy_id) {
> +			pr_err("%s: kmalloc() failed\n", __func__);
>  			return -ENOMEM;
> +		}
>  
> -		scnprintf(phy_id, len, "nop_usb_xceiv.%d\n",
> -					pdev->id);
> -
> -		if (platform_device_register(pdev)) {
> -			pr_err("%s: Failed to register device %s\n",
> -				__func__,  phy_id);
> +		/* create a NOP PHY device */
> +		memset(&pdevinfo, 0, sizeof(pdevinfo));
> +		pdevinfo.name = nop_name;
> +		pdevinfo.id = phy->port;
> +		pdevinfo.data = phy->platform_data;
> +		pdevinfo.size_data = sizeof(struct nop_usb_xceiv_platform_data);
> +
> +		scnprintf(phy_id, MAX_STR, "nop_usb_xceiv.%d",
> +					phy->port);
> +		pdev = platform_device_register_full(&pdevinfo);
> +		if (IS_ERR(pdev)) {
> +			pr_err("%s: Failed to register device %s : %ld\n",
> +				__func__,  phy_id, PTR_ERR(pdev));
> +			kfree(phy_id);
>  			continue;
>  		}
>  
> @@ -653,26 +670,15 @@ int usbhs_init_phys(struct usbhs_phy_data *phy, int num_phys)
>  
>  		/* Do we need RESET regulator ? */
>  		if (gpio_is_valid(phy->reset_gpio)) {
> -
> -			rail_name = kmalloc(13, GFP_KERNEL);
> -			if (!rail_name)
> -				return -ENOMEM;
> -
> -			scnprintf(rail_name, 13, "hsusb%d_reset", phy->port);
> -
> +			scnprintf(rail_name, MAX_STR,
> +					"hsusb%d_reset", phy->port);
>  			usbhs_add_regulator(rail_name, phy_id, "reset",
>  						phy->reset_gpio, 1);
>  		}
>  
>  		/* Do we need VCC regulator ? */
>  		if (gpio_is_valid(phy->vcc_gpio)) {
> -
> -			rail_name = kmalloc(13, GFP_KERNEL);
> -			if (!rail_name)
> -				return -ENOMEM;
> -
> -			scnprintf(rail_name, 13, "hsusb%d_vcc", phy->port);
> -
> +			scnprintf(rail_name, MAX_STR, "hsusb%d_vcc", phy->port);
>  			usbhs_add_regulator(rail_name, phy_id, "vcc",
>  					phy->vcc_gpio, phy->vcc_polarity);
>  		}
> -- 
> 1.7.4.1
> 
