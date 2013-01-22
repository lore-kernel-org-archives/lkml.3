Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3AVPiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:38:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48781 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab3AVPiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:38:21 -0500
Message-ID: <50FEB248.5090701@ti.com>
Date: Tue, 22 Jan 2013 21:07:44 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "tony@atomide.com" <tony@atomide.com>, "balbi@ti.com" <balbi@ti.com>,
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
References: <1358848694-20145-1-git-send-email-kishon@ti.com> <1358848694-20145-6-git-send-email-kishon@ti.com> <20130122103650.GB18876@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130122103650.GB18876@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 22 January 2013 04:06 PM, Mark Rutland wrote:
>> +struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
>> +	const char *phandle, u8 index)
>> +{
>> +	struct usb_phy	*phy = NULL, **ptr;
>> +	unsigned long	flags;
>> +	struct device_node *node;
>> +
>> +	if (!dev->of_node) {
>> +		dev_dbg(dev, "device does not have a device node entry\n");
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +
>> +	node = of_parse_phandle(dev->of_node, phandle, index);
>> +	if (!node) {
>> +		dev_dbg(dev, "failed to get %s phandle in %s node\n", phandle,
>> +			dev->of_node->full_name);
>> +		return ERR_PTR(-ENODEV);
>> +	}
>
> At any point past this, node's refcount is incremented (done automatically by
> of_parse_phandle => of_find_node_by_phandle).
>
>> +
>> +	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
>> +	if (!ptr) {
>> +		dev_dbg(dev, "failed to allocate memory for devres\n");
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	spin_lock_irqsave(&phy_lock, flags);
>> +
>> +	phy = __of_usb_find_phy(node);
>> +	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
>> +		phy = ERR_PTR(-EPROBE_DEFER);
>> +		devres_free(ptr);
>> +		goto err0;
>> +	}
>> +
>> +	*ptr = phy;
>> +	devres_add(dev, ptr);
>> +
>> +	get_device(phy->dev);
>> +
>> +err0:
>> +	spin_unlock_irqrestore(&phy_lock, flags);
>> +
>> +	return phy;
>> +}
>
> This means that on all of the exit paths, node's refcount is left incremented
> incorrectly. You'll need an of_node_put(node) on each exit path.

Ok. Will fix it.

Thanks
Kishon
