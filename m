Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3AVKg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:36:59 -0500
Received: from service87.mimecast.com ([91.220.42.44]:32795 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3AVKg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:36:57 -0500
Date: Tue, 22 Jan 2013 10:36:50 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "tony@atomide.com" <tony@atomide.com>, "balbi@ti.com" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "eballetbo@gmail.com" <eballetbo@gmail.com>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH v1 5/6] usb: otg: add device tree support to otg library
Message-ID: <20130122103650.GB18876@e106331-lin.cambridge.arm.com>
References: <1358848694-20145-1-git-send-email-kishon@ti.com>
 <1358848694-20145-6-git-send-email-kishon@ti.com>
MIME-Version: 1.0
In-Reply-To: <1358848694-20145-6-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Jan 2013 10:36:51.0633 (UTC) FILETIME=[63C13A10:01CDF88C]
X-MC-Unique: 113012210365405301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
> +	const char *phandle, u8 index)
> +{
> +	struct usb_phy	*phy = NULL, **ptr;
> +	unsigned long	flags;
> +	struct device_node *node;
> +
> +	if (!dev->of_node) {
> +		dev_dbg(dev, "device does not have a device node entry\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	node = of_parse_phandle(dev->of_node, phandle, index);
> +	if (!node) {
> +		dev_dbg(dev, "failed to get %s phandle in %s node\n", phandle,
> +			dev->of_node->full_name);
> +		return ERR_PTR(-ENODEV);
> +	}

At any point past this, node's refcount is incremented (done automatically by
of_parse_phandle => of_find_node_by_phandle).

> +
> +	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr) {
> +		dev_dbg(dev, "failed to allocate memory for devres\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	spin_lock_irqsave(&phy_lock, flags);
> +
> +	phy = __of_usb_find_phy(node);
> +	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> +		phy = ERR_PTR(-EPROBE_DEFER);
> +		devres_free(ptr);
> +		goto err0;
> +	}
> +
> +	*ptr = phy;
> +	devres_add(dev, ptr);
> +
> +	get_device(phy->dev);
> +
> +err0:
> +	spin_unlock_irqrestore(&phy_lock, flags);
> +
> +	return phy;
> +}

This means that on all of the exit paths, node's refcount is left incremented
incorrectly. You'll need an of_node_put(node) on each exit path.

Thanks,
Mark.

