Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3HAFge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 01:36:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58339 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3HAFgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 01:36:32 -0400
Message-ID: <51F9F3D4.50108@ti.com>
Date: Thu, 1 Aug 2013 11:06:20 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] usb: phy: Add AM335x PHY driver
References: <1375215401-19729-1-git-send-email-bigeasy@linutronix.de> <1375215401-19729-4-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1375215401-19729-4-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/2013 1:46 AM, Sebastian Andrzej Siewior wrote:
> This driver is a redo of my earlier attempt. It uses parts of the
> generic PHY driver and uses the new control driver for the register
> the phy needs to power on/off the phy. It also enables easy access for
> the wakeup register which is not yet implemented.
> The difference between the omap attempt is:
> - no static holding variable
> - one global visible function which exports a struct with callbacks to
>    access the "control" registers.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>   

<snip>

> +static const struct of_device_id omap_control_usb_id_table[] = {
> +	{ .compatible = "ti,am335x-ctrl-module", .data = &ctrl_am335x },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
> +
> +static struct platform_driver am335x_control_driver;
> +static int match(struct device *dev, void *data)
> +{
> +	struct device_node *node = (struct device_node *)data;
> +	return dev->of_node == node &&
> +		dev->driver == &am335x_control_driver.driver;
> +}
> +
> +struct phy_control *am335x_get_phy_control(struct device *dev)
> +{
> +	struct device_node *node;
> +	struct am335x_control_usb *ctrl_usb;
> +
> +	node = of_parse_phandle(dev->of_node, "ti,ctrl_mod", 0);
> +	if (!node)
> +		return NULL;
> +
> +	dev = bus_find_device(&platform_bus_type, NULL, node, match);

of_find_device_by_node doesn't work???

> +	ctrl_usb = dev_get_drvdata(dev);
> +	if (!ctrl_usb)
> +		return NULL;
> +	return &ctrl_usb->phy_ctrl;
> +}
> +EXPORT_SYMBOL_GPL(am335x_get_phy_control);
> +
> +static int am335x_control_usb_probe(struct platform_device *pdev)
> +{
> +	struct resource	*res;
> +	struct am335x_control_usb *ctrl_usb;
> +	const struct of_device_id *of_id;
> +	const struct phy_control *phy_ctrl;
> +
> +	of_id = of_match_node(omap_control_usb_id_table, pdev->dev.of_node);
> +	if (!of_id)
> +		return -EINVAL;
> +
> +	phy_ctrl = of_id->data;
> +
> +	ctrl_usb = devm_kzalloc(&pdev->dev, sizeof(*ctrl_usb), GFP_KERNEL);
> +	if (!ctrl_usb) {
> +		dev_err(&pdev->dev, "unable to alloc memory for control usb\n");
> +		return -ENOMEM;
> +	}
> +
> +	ctrl_usb->dev = &pdev->dev;
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "control_dev");
> +	ctrl_usb->reset_reg = devm_ioremap_resource(&pdev->dev, res);

As per current DTSI in patch 5 you are mapping from control module base till 0x650.
Cant it be split to 2 registers one mapping for phy on/off and one for phy wkup?

> +	if (IS_ERR(ctrl_usb->reset_reg))
> +		return PTR_ERR(ctrl_usb->reset_reg);
> +	spin_lock_init(&ctrl_usb->lock);
> +	ctrl_usb->phy_ctrl = *phy_ctrl;
> +
> +	dev_set_drvdata(ctrl_usb->dev, ctrl_usb);
> +	return 0;
> +}
> +
> +static struct platform_driver am335x_control_driver = {
> +	.probe		= am335x_control_usb_probe,
> +	.driver		= {
> +		.name	= "am335x-control-usb",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(omap_control_usb_id_table),
> +	},
> +};
> +
> +module_platform_driver(am335x_control_driver);
> +MODULE_LICENSE("GPL v2");
>

-- 
-George

