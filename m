Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3GRHUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:20:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3GRHT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:19:58 -0400
Date: Thu, 18 Jul 2013 00:20:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: kyungmin.park@samsung.com, balbi@ti.com, jg1.han@samsung.com,
        s.nawrocki@samsung.com, kgene.kim@samsung.com, grant.likely@linaro.org,
        tony@atomide.com, arnd@arndb.de, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Message-ID: <20130718072004.GA16720@kroah.com>
References: <1374129984-765-1-git-send-email-kishon@ti.com>
 <1374129984-765-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374129984-765-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:16:10PM +0530, Kishon Vijay Abraham I wrote:
> +struct phy_provider *__of_phy_provider_register(struct device *dev,
> +	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
> +	struct of_phandle_args *args));
> +struct phy_provider *__devm_of_phy_provider_register(struct device *dev,
> +	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
> +	struct of_phandle_args *args))
> +
> +__of_phy_provider_register and __devm_of_phy_provider_register can be used to
> +register the phy_provider and it takes device, owner and of_xlate as
> +arguments. For the dt boot case, all PHY providers should use one of the above
> +2 APIs to register the PHY provider.

Why do you have __ for the prefix of a public function?  Is that really
the way that OF handles this type of thing?

> --- /dev/null
> +++ b/drivers/phy/Kconfig
> @@ -0,0 +1,13 @@
> +#
> +# PHY
> +#
> +
> +menuconfig GENERIC_PHY
> +	tristate "PHY Subsystem"
> +	help
> +	  Generic PHY support.
> +
> +	  This framework is designed to provide a generic interface for PHY
> +	  devices present in the kernel. This layer will have the generic
> +	  API by which phy drivers can create PHY using the phy framework and
> +	  phy users can obtain reference to the PHY.

Again, please reverse this.  The drivers that use it should select it,
not depend on it, which will then enable this option.  I will never know
if I need to enable it, and based on your follow-on patches, if I don't,
drivers that were working just fine, now disappeared from my build,
which isn't nice, and a pain to notice and fix up.

> +/**
> + * phy_create() - create a new phy
> + * @dev: device that is creating the new phy
> + * @id: id of the phy
> + * @ops: function pointers for performing phy operations
> + * @label: label given to the phy
> + *
> + * Called to create a phy using phy framework.
> + */
> +struct phy *phy_create(struct device *dev, u8 id, const struct phy_ops *ops,
> +	const char *label)
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
> +	mutex_init(&phy->mutex);
> +
> +	phy->dev.class = phy_class;
> +	phy->dev.parent = dev;
> +	phy->dev.of_node = dev->of_node;
> +	phy->id = id;
> +	phy->ops = ops;
> +	phy->label = kstrdup(label, GFP_KERNEL);
> +
> +	ret = dev_set_name(&phy->dev, "%s.%d", dev_name(dev), id);

Your naming is odd, no "phy" anywhere in it?  You rely on the sender to
never send a duplicate name.id pair?  Why not create your own ids based
on the number of phys in the system, like almost all other classes and
subsystems do?

> +static inline int phy_pm_runtime_get(struct phy *phy)
> +{
> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
> +		return -EINVAL;

Why would phy ever not be valid and a error pointer?  And why dump the
stack if that happens, that seems really extreme.

> +
> +	if (!pm_runtime_enabled(&phy->dev))
> +		return -ENOTSUPP;
> +
> +	return pm_runtime_get(&phy->dev);
> +}

This, and the other inline functions in this .h file seem huge, why are
they inline and not in the .c file?  There's no speed issues, and it
should save space overall in the .c file.  Please move them.


> +static inline int phy_init(struct phy *phy)
> +{
> +	int ret;
> +
> +	ret = phy_pm_runtime_get_sync(phy);
> +	if (ret < 0 && ret != -ENOTSUPP)
> +		return ret;
> +
> +	mutex_lock(&phy->mutex);
> +	if (phy->init_count++ == 0 && phy->ops->init) {
> +		ret = phy->ops->init(phy);
> +		if (ret < 0) {
> +			dev_err(&phy->dev, "phy init failed --> %d\n", ret);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&phy->mutex);
> +	phy_pm_runtime_put(phy);
> +	return ret;
> +}
> +
> +static inline int phy_exit(struct phy *phy)
> +{
> +	int ret;
> +
> +	ret = phy_pm_runtime_get_sync(phy);
> +	if (ret < 0 && ret != -ENOTSUPP)
> +		return ret;
> +
> +	mutex_lock(&phy->mutex);
> +	if (--phy->init_count == 0 && phy->ops->exit) {
> +		ret = phy->ops->exit(phy);
> +		if (ret < 0) {
> +			dev_err(&phy->dev, "phy exit failed --> %d\n", ret);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&phy->mutex);
> +	phy_pm_runtime_put(phy);
> +	return ret;
> +}
> +
> +static inline int phy_power_on(struct phy *phy)
> +{
> +	int ret = -ENOTSUPP;
> +
> +	ret = phy_pm_runtime_get_sync(phy);
> +	if (ret < 0 && ret != -ENOTSUPP)
> +		return ret;
> +
> +	mutex_lock(&phy->mutex);
> +	if (phy->power_count++ == 0 && phy->ops->power_on) {
> +		ret = phy->ops->power_on(phy);
> +		if (ret < 0) {
> +			dev_err(&phy->dev, "phy poweron failed --> %d\n", ret);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&phy->mutex);
> +
> +	return ret;
> +}
> +
> +static inline int phy_power_off(struct phy *phy)
> +{
> +	int ret = -ENOTSUPP;
> +
> +	mutex_lock(&phy->mutex);
> +	if (--phy->power_count == 0 && phy->ops->power_off) {
> +		ret =  phy->ops->power_off(phy);
> +		if (ret < 0) {
> +			dev_err(&phy->dev, "phy poweroff failed --> %d\n", ret);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&phy->mutex);
> +	phy_pm_runtime_put(phy);
> +
> +	return ret;
> +}

Look at those 3 functions, they are all "real" and not an inline
function at all, please move them.

thanks,

greg k-h
