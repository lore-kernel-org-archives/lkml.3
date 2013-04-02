Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442Ab3DBIkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:40:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60766 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761014Ab3DBIkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:40:42 -0400
Message-ID: <515A9939.40406@ti.com>
Date: Tue, 2 Apr 2013 14:09:21 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <rob@landley.net>,
        <swarren@wwwdotorg.org>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <b-cousson@ti.com>, <linux@arm.linux.org.uk>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <mchehab@redhat.com>,
        <santosh.shilimkar@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <swarren@nvidia.com>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/6] drivers: phy: add generic PHY framework
References: <1364449408-9510-1-git-send-email-kishon@ti.com> <1364449408-9510-2-git-send-email-kishon@ti.com> <5159E157.6000800@gmail.com>
In-Reply-To: <5159E157.6000800@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 02 April 2013 01:04 AM, Sylwester Nawrocki wrote:
> Just couple minor comments...
>
> On 03/28/2013 06:43 AM, Kishon Vijay Abraham I wrote:
>> The PHY framework provides a set of APIs for the PHY drivers to
>> create/destroy a PHY and APIs for the PHY users to obtain a reference
>> to the
>> PHY with or without using phandle. To obtain a reference to the PHY
>> without
>> using phandle, the platform specfic intialization code (say from board
>> file)
>> should have already called phy_bind with the binding information. The
>> binding
>> information consists of phy's device name, phy user device name and an
>> index.
>> The index is used when the same phy user binds to mulitple phys.
>>
>> PHY drivers should create the PHY by passing phy_descriptor that has
>> describes the PHY (label, type etc..) and ops like init, exit,
>> suspend, resume,
>> poweron, shutdown.
>>
>> The documentation for the generic PHY framework is added in
>> Documentation/phy.txt and the documentation for the sysfs entry is added
>> in Documentation/ABI/testing/sysfs-class-phy and the documentation for
>> dt binding is can be found at
>> Documentation/devicetree/bindings/phy/phy-bindings.txt
>>
>> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
>> ---
> [...]
>> +/**
>> + * phy_put - release the PHY
>
> nit: According to kernel-doc documentation function names should have
> parentheses appended to the name. So it would need to be
>
> + * phy_put() - release the PHY
>
> in this case and it applies to multiple places elsewhere in this patch.

Will fix it.
>
>> + * @phy: the phy returned by phy_get()
>> + *
>> + * Releases a refcount the caller received from phy_get().
>> + */
>> +void phy_put(struct phy *phy)
>> +{
>> +    if (phy) {
>> +        module_put(phy->ops->owner);
>> +        put_device(&phy->dev);
>> +    }
>> +}
>> +EXPORT_SYMBOL_GPL(phy_put);
> [...]
>> +/**
>> + * devm_of_phy_get_byname - lookup and obtain a reference to a phy by
>> name
>> + * @dev: device that requests this phy
>> + * @string - the phy name as given in the dt data
>
> s/ -/:

Ok.
>
>> + *
>> + * Calls devm_of_phy_get (which associates the device with the phy
>> using devres
>> + * on successful phy get) and passes on the return value of
>> devm_of_phy_get.
>> + */
>> +struct phy *devm_of_phy_get_byname(struct device *dev, const char
>> *string)
>> +{
>> +    int index;
>> +
>> +    if (!dev->of_node) {
>> +        dev_dbg(dev, "device does not have a device node entry\n");
>> +        return ERR_PTR(-EINVAL);
>> +    }
>> +
>> +    index = of_property_match_string(dev->of_node, "phy-names", string);
>> +
>> +    return devm_of_phy_get(dev, index);
>> +}
>> +EXPORT_SYMBOL_GPL(devm_of_phy_get_byname);
>> +
>> +/**
>> + * phy_get - lookup and obtain a reference to a phy.
>> + * @dev: device that requests this phy
>> + * @index: the index of the phy
>> + *
>> + * Returns the phy driver, after getting a refcount to it; or
>> + * -ENODEV if there is no such phy.  The caller is responsible for
>> + * calling phy_put() to release that count.
>> + */
>> +struct phy *phy_get(struct device *dev, int index)
>> +{
>> +    struct phy *phy = NULL;
>
> Unneeded initialization.
>
>> +    phy = phy_lookup(dev, index);
>> +    if (IS_ERR(phy)) {
>> +        dev_err(dev, "unable to find phy\n");
>> +        goto err0;
>
> Wouldn't it be better to just do:

Indeed.
>
>          return phy;
>> +    }
>> +
>> +    if (!try_module_get(phy->ops->owner)) {
>> +        phy = ERR_PTR(-EPROBE_DEFER);
>
> and
>          return ERR_PTR(-EPROBE_DEFER);
>
>> +        goto err0;
>
> and to drop this goto and the label below ?
>
>> +    }
>> +
>> +    get_device(&phy->dev);
>> +
>> +err0:
>> +    return phy;
>> +}
>> +EXPORT_SYMBOL_GPL(phy_get);
>
>> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
>> new file mode 100644
>> index 0000000..0cb2298
>> --- /dev/null
>> +++ b/include/linux/phy/phy.h
>> @@ -0,0 +1,237 @@
>> +/*
>> + * phy.h -- generic phy header file
> [...]
>> +#ifndef __DRIVERS_PHY_H
>> +#define __DRIVERS_PHY_H
>> +
>> +#include<linux/err.h>
>> +#include<linux/of.h>
>> +
>> +struct phy
>
> I think you also need to add either
>
> #include <linux/device.h>
>
> or
>
> struct device;
>
> struct device * is used further in this file.

Ok.
>
>> +/**
>> + * struct phy_ops - set of function pointers for performing phy
>> operations
>> + * @init: operation to be performed for initializing phy
>> + * @exit: operation to be performed while exiting
>> + * @suspend: suspending the phy
>> + * @resume: resuming the phy
>
>> + * @poweron: powering on the phy
>> + * @shutdown: shutting down the phy
>
> Could these be named power_on/power_off ? Looks a bit more symmetric
> to me that way.

Ok. Will have it that way.

Thanks
Kishon
