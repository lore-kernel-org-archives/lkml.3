Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab3HAKzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:55:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:41252 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3HAKzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:55:13 -0400
Message-ID: <51FA3E8F.7010906@linutronix.de>
Date: Thu, 01 Aug 2013 12:55:11 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] usb: phy: Add AM335x PHY driver
References: <1375215401-19729-1-git-send-email-bigeasy@linutronix.de> <1375215401-19729-4-git-send-email-bigeasy@linutronix.de> <51F9F3D4.50108@ti.com>
In-Reply-To: <51F9F3D4.50108@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 07:36 AM, George Cherian wrote:

please keep the file here file snipping

>> +static const struct of_device_id omap_control_usb_id_table[] = {
>> +    { .compatible = "ti,am335x-ctrl-module", .data = &ctrl_am335x },
>> +    {}
>> +};
>> +MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
>> +
>> +static struct platform_driver am335x_control_driver;
>> +static int match(struct device *dev, void *data)
>> +{
>> +    struct device_node *node = (struct device_node *)data;
>> +    return dev->of_node == node &&
>> +        dev->driver == &am335x_control_driver.driver;
>> +}
>> +
>> +struct phy_control *am335x_get_phy_control(struct device *dev)
>> +{
>> +    struct device_node *node;
>> +    struct am335x_control_usb *ctrl_usb;
>> +
>> +    node = of_parse_phandle(dev->of_node, "ti,ctrl_mod", 0);
>> +    if (!node)
>> +        return NULL;
>> +
>> +    dev = bus_find_device(&platform_bus_type, NULL, node, match);
> 
> of_find_device_by_node doesn't work???

It would but I have here a reference to the device.

> 
>> +    ctrl_usb = dev_get_drvdata(dev);
>> +    if (!ctrl_usb)
>> +        return NULL;
>> +    return &ctrl_usb->phy_ctrl;
>> +}
>> +EXPORT_SYMBOL_GPL(am335x_get_phy_control);
>> +
>> +static int am335x_control_usb_probe(struct platform_device *pdev)
>> +{
>> +    struct resource    *res;
>> +    struct am335x_control_usb *ctrl_usb;
>> +    const struct of_device_id *of_id;
>> +    const struct phy_control *phy_ctrl;
>> +
>> +    of_id = of_match_node(omap_control_usb_id_table, pdev->dev.of_node);
>> +    if (!of_id)
>> +        return -EINVAL;
>> +
>> +    phy_ctrl = of_id->data;
>> +
>> +    ctrl_usb = devm_kzalloc(&pdev->dev, sizeof(*ctrl_usb), GFP_KERNEL);
>> +    if (!ctrl_usb) {
>> +        dev_err(&pdev->dev, "unable to alloc memory for control usb\n");
>> +        return -ENOMEM;
>> +    }
>> +
>> +    ctrl_usb->dev = &pdev->dev;
>> +
>> +    res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>> "control_dev");
>> +    ctrl_usb->reset_reg = devm_ioremap_resource(&pdev->dev, res);
> 
> As per current DTSI in patch 5 you are mapping from control module base
> till 0x650.
> Cant it be split to 2 registers one mapping for phy on/off and one for
> phy wkup?

You asked the same question in the other pathch. It could but please
refer to the other patch.

Sebastian
