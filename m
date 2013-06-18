Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab3FRVXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:23:01 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:44954 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab3FRVW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:22:59 -0400
Message-ID: <51C0CFAC.9080606@gmail.com>
Date: Tue, 18 Jun 2013 23:22:52 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@linaro.org, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com, linux@arm.linux.org.uk, benoit.cousson@linaro.org,
        mchehab@redhat.com, cesarb@cesarb.net, davem@davemloft.net,
        rnayak@ti.com, shawn.guo@linaro.org, santosh.shilimkar@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        nsekhar@ti.com
Subject: Re: [PATCH v7 1/9] drivers: phy: add generic PHY framework
References: <1371113039-5784-1-git-send-email-kishon@ti.com> <1371113039-5784-2-git-send-email-kishon@ti.com>
In-Reply-To: <1371113039-5784-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

I've noticed there is a little inconsistency between the code and 
documentation.

On 06/13/2013 10:43 AM, Kishon Vijay Abraham I wrote:
> +3. Creating the PHY
> +
> +The PHY driver should create the PHY in order for other peripheral controllers
> +to make use of it. The PHY framework provides 2 APIs to create the PHY.
> +
> +struct phy *phy_create(struct device *dev, int id, const struct phy_ops *ops,
> +	void *priv);
> +struct phy *devm_phy_create(struct device *dev, int id,
> +	const struct phy_ops *ops, void *priv);

The 'label' argument is missing in those function prototypes. It seems the
labels must be unique, I guess this needs to be documented. And do we allow
NULL labels ? If so, then there is probably a check for NULL label needed
in phy_lookup() and if not, then phy_create() should fail when NULL label
is passed ?

> +The PHY drivers can use one of the above 2 APIs to create the PHY by passing
> +the device pointer, id, phy ops and a driver data.
> +phy_ops is a set of function pointers for performing PHY operations such as
> +init, exit, power_on and power_off.

> +/**
> + * phy_create() - create a new phy
> + * @dev: device that is creating the new phy
> + * @id: id of the phy
> + * @ops: function pointers for performing phy operations
> + * @label: label given to the phy
> + * @priv: private data from phy driver
> + *
> + * Called to create a phy using phy framework.
> + */
> +struct phy *phy_create(struct device *dev, u8 id, const struct phy_ops *ops,
> +	const char *label, void *priv)
> +{
> +	int ret;
> +	struct phy *phy;
> +
> +	if (!dev) {
> +		dev_WARN(dev, "no device provided for PHY\n");
> +		ret = -EINVAL;
> +		goto err0;
> +	}
> +
> +	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		ret = -ENOMEM;
> +		goto err0;
> +	}
> +
> +	device_initialize(&phy->dev);
> +
> +	phy->dev.class = phy_class;
> +	phy->dev.parent = dev;
> +	phy->dev.of_node = dev->of_node;
> +	phy->id = id;
> +	phy->ops = ops;
> +	phy->label = label;
> +
> +	dev_set_drvdata(&phy->dev, priv);
> +
> +	ret = dev_set_name(&phy->dev, "%s.%d", dev_name(dev), id);
> +	if (ret)
> +		goto err1;
> +
> +	ret = device_add(&phy->dev);
> +	if (ret)
> +		goto err1;
> +
> +	if (pm_runtime_enabled(dev))
> +		pm_runtime_enable(&phy->dev);
> +
> +	return phy;
> +
> +err1:
> +	put_device(&phy->dev);
> +	kfree(phy);
> +
> +err0:
> +	return ERR_PTR(ret);
> +}

Thanks,
Sylwester
