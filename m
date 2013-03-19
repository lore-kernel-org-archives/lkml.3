Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786Ab3CSUVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:21:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55689 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105Ab3CSUVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:21:13 -0400
Message-ID: <5148C8B6.90303@wwwdotorg.org>
Date: Tue, 19 Mar 2013 14:21:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 7/7] usb: phy: registering tegra USB PHY as platform driver
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com> <1363609781-4045-8-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1363609781-4045-8-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 06:29 AM, Venu Byravarasu wrote:
> Registered tegra USB PHY as a separate platform driver.
> 
> To synchronize host controller and PHY initialization, used deferred
> probe mechanism. As PHY should be initialized before EHCI starts running,
> deferred probe of Tegra EHCI driver till PHY probe gets completed.
> 
> Got rid of instance number based handling in host driver.
> 
> Made use of DT params to get the PHY Pad registers.
> 
> Merged tegra_phy_init into tegra_usb_phy_init.

> diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c

>  static void tegra_usb_phy_close(struct usb_phy *x)
>  {
>  	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
>  
>  	if (phy->is_ulpi_phy)
>  		clk_put(phy->clk);

phy->clk is obtained using devm_clk_get(). This typically means you
never need to clk_put() it, and if for some reason you really have to,
you should use devm_clk_put() instead of plain clk_put().

>  	clk_put(phy->pll_u);

Same here.

> @@ -774,23 +667,53 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,

> +	if (phy->is_ulpi_phy) {
> +		phy->clk = devm_clk_get(phy->dev, "ulpi-link");
> +		if (IS_ERR(phy->clk)) {
> +			pr_err("%s: can't get ulpi clock\n", __func__);
> +			err = PTR_ERR(phy->clk);
> +			goto fail;
> +
> +		}
> +
> +		err = gpio_request(phy->reset_gpio, "ulpi_phy_reset_b");

I think you can use devm_gpio_request() here to simplify the error-handling.

> +		if (err < 0) {
> +			dev_err(phy->dev, "request failed for gpio: %d\n",
> +			       phy->reset_gpio);
> +			goto fail;
> +		}
> +
> +		err = gpio_direction_output(phy->reset_gpio, 0);
> +		if (err < 0) {
> +			dev_err(phy->dev, "gpio %d direction not set to output\n",
> +			       phy->reset_gpio);
> +			goto cleanup_gpio_req;
> +		}
>  
> -	return phy;
> +		phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
> +		if (!phy->ulpi) {
> +			dev_err(phy->dev, "otg_ulpi_create returned err\n");
> +			err = -ENOMEM;
> +			goto cleanup_gpio_req;
> +		}
>  
> -err1:
> +		phy->ulpi->io_priv = phy->regs + ULPI_VIEWPORT;
> +	} else {
> +		err = utmip_pad_open(phy);
> +		if (err < 0)
> +			goto fail;
> +	}

I wonder why in the ULPI case, all the code is inline here, whereas in
the UTMI case, this simply calls a function. Wouldn't it be more
consistent to have the following code here:

	if (phy->is_ulpi_phy)
		err = ulpi_open();
	else
		err = utmip_open();
	if (err)
		goto fail;

> +static int tegra_usb_phy_probe(struct platform_device *pdev)

Hmmm. Note that in order to make deferred probe work correctly, all the
gpio_request(), clk_get(), etc. calls that acquire resources from other
drivers must happen here in probe() and not in tegra_usb_phy_open().

> +	err = of_property_match_string(np, "dr_mode", "otg");
> +	if (err < 0) {
> +		err = of_property_match_string(np, "dr_mode", "gadget");

Again, use "peripheral", not "gadget".

> +struct usb_phy *tegra_usb_get_phy(struct device_node *dn)
> +{
> +	struct device *dev;
> +	struct tegra_usb_phy *tegra_phy;
> +
> +	dev = driver_find_device(&tegra_usb_phy_driver.driver, NULL, dn,
> +				 tegra_usb_phy_match);
> +	if (!dev)
> +		return ERR_PTR(-EPROBE_DEFER);
> +
> +	tegra_phy = dev_get_drvdata(dev);
> +
> +	return &tegra_phy->u_phy;
> +}

I think you need a module_get() somewhere in there, and also need to add
a tegra_usb_put_phy() function too, so you can call module_put() from it.
