Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbaIQO6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:58:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39750 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755267AbaIQO56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:57:58 -0400
Date: Wed, 17 Sep 2014 10:57:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <kgene.kim@samsung.com>, <jg1.han@samsung.com>
Subject: Re: [PATCH v3 1/2] usb: host: ehci-exynos: Remove unnecessary usb-phy
 support
In-Reply-To: <1410952662-4297-2-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1409171051520.1579-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Vivek Gautam wrote:

> Now that we have completely moved from older USB-PHY drivers
> to newer GENERIC-PHY drivers for PHYs available with USB controllers
> on Exynos series of SoCs, we can remove the support for the same
> in our host drivers too.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

I don't see why you made your changes in this awkward way.  For 
instance...

> @@ -59,49 +54,39 @@ static int exynos_ehci_get_phy(struct device *dev,
>  {
>  	struct device_node *child;
>  	struct phy *phy;
> -	int phy_number;
> -	int ret = 0;
> +	int phy_num;

Why rename this variable?  Wasn't the original name good enough?

> +	int ret;
>  
>  	for_each_available_child_of_node(dev->of_node, child) {
> -		ret = of_property_read_u32(child, "reg", &phy_number);
> +		ret = of_property_read_u32(child, "reg", &phy_num);
>  		if (ret) {
>  			dev_err(dev, "Failed to parse device tree\n");
>  			of_node_put(child);
>  			return ret;
>  		}
>  
> -		if (phy_number >= PHY_NUMBER) {
> +		if (phy_num >= PHY_NUMBER) {
>  			dev_err(dev, "Invalid number of PHYs\n");
>  			of_node_put(child);
>  			return -EINVAL;
>  		}
>  
> -		phy = devm_of_phy_get(dev, child, NULL);
> +		exynos_ehci->phy[phy_num] = devm_of_phy_get(dev, child, NULL);
> +		phy = exynos_ehci->phy[phy_num];

Why make two changes, resulting in more code, when you could have made 
just one change?

		phy = devm_of_phy_get(dev, child, NULL);
+		exynos_ehci->phy[phy_num] = phy;

Also, the patch description should mention that you are adding support 
for EPROBE_DEFER.

Alan Stern

