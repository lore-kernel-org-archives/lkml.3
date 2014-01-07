Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaAGNlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:41:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60733 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaAGNlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:41:03 -0500
Message-ID: <52CC03D4.50603@ti.com>
Date: Tue, 7 Jan 2014 19:10:36 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 2/5] phy: add support for indexed lookup
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com> <1386601737-8735-3-git-send-email-heikki.krogerus@linux.intel.com> <52AEDDE2.8060406@ti.com> <20131216143227.GA22944@xps8300>
In-Reply-To: <20131216143227.GA22944@xps8300>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 16 December 2013 08:02 PM, Heikki Krogerus wrote:
> Hi Kishon,
> 
> On Mon, Dec 16, 2013 at 04:32:58PM +0530, Kishon Vijay Abraham I wrote:
>> On Monday 09 December 2013 08:38 PM, Heikki Krogerus wrote:
>>> Removes the need for the consumer drivers requesting the
>>> phys to provide name for the phy. This should ease the use
>>> of the framework considerable when using only one phy, which
>>> is usually the case when except with USB, but it can also
>>> be useful with multiple phys.
>>
>> If index has to be used with multiple PHYs, the controller should be aware of
>> the order in which it is populated in dt data. That's not good.
> 
> The Idea is not to replace the name based lookup. Just to provide
> possibility for index based lookup.
> 
> With ACPI, if we get the device entries for PHYs, the order will be
> fixed and we will not have any other reference to the phys. In case
> of USB, the first one should always be USB2 PHY and the second the
> USB3 PHY.
> 
>>> This will also reduce noise from the framework when there is
>>> no phy by changing warnings to debug messages.
>>>
>>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>> ---
>>>  drivers/phy/phy-core.c  | 106 ++++++++++++++++++++++++++++++++++--------------
>>>  include/linux/phy/phy.h |  14 +++++++
>>>  2 files changed, 89 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>>> index 1102aef..99dc046 100644
>>> --- a/drivers/phy/phy-core.c
>>> +++ b/drivers/phy/phy-core.c
>>> @@ -53,7 +53,8 @@ static int devm_phy_match(struct device *dev, void *res, void *match_data)
>>>  	return res == match_data;
>>>  }
>>>  
>>> -static struct phy *phy_lookup(struct device *device, const char *con_id)
>>> +static struct phy *phy_lookup(struct device *device, const char *con_id,
>>> +			      unsigned int idx)
>>>  {
>>>  	unsigned int count;
>>>  	struct phy *phy;
>>> @@ -67,6 +68,10 @@ static struct phy *phy_lookup(struct device *device, const char *con_id)
>>>  		count = phy->init_data->num_consumers;
>>>  		consumers = phy->init_data->consumers;
>>>  		while (count--) {
>>> +			/* index must always match exactly */
>>> +			if (!con_id)
>>> +				if (idx != count)
>>> +					continue;
>>>  			if (!strcmp(consumers->dev_name, dev_name(device)) &&
>>>  					!strcmp(consumers->port, con_id)) {
>>>  				class_dev_iter_exit(&iter);
>>> @@ -242,7 +247,8 @@ EXPORT_SYMBOL_GPL(phy_power_off);
>>>  /**
>>>   * of_phy_get() - lookup and obtain a reference to a phy by phandle
>>>   * @dev: device that requests this phy
>>> - * @index: the index of the phy
>>> + * @con_id: name of the phy from device's point of view
>>> + * @idx: the index of the phy if name is not used
>>>   *
>>>   * Returns the phy associated with the given phandle value,
>>>   * after getting a refcount to it or -ENODEV if there is no such phy or
>>> @@ -250,12 +256,20 @@ EXPORT_SYMBOL_GPL(phy_power_off);
>>>   * not yet loaded. This function uses of_xlate call back function provided
>>>   * while registering the phy_provider to find the phy instance.
>>>   */
>>> -static struct phy *of_phy_get(struct device *dev, int index)
>>> +static struct phy *of_phy_get(struct device *dev, const char *con_id,
>>> +			      unsigned int idx)
>>>  {
>>>  	int ret;
>>>  	struct phy_provider *phy_provider;
>>>  	struct phy *phy = NULL;
>>>  	struct of_phandle_args args;
>>> +	int index;
>>> +
>>> +	if (!con_id)
>>> +		index = idx;
>>> +	else
>>> +		index = of_property_match_string(dev->of_node, "phy-names",
>>> +						 con_id);
>>>  
>>>  	ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-cells",
>>>  		index, &args);
>>> @@ -348,38 +362,36 @@ struct phy *of_phy_simple_xlate(struct device *dev, struct of_phandle_args
>>>  EXPORT_SYMBOL_GPL(of_phy_simple_xlate);
>>>  
>>>  /**
>>> - * phy_get() - lookup and obtain a reference to a phy.
>>> + * phy_get_index() - obtain a phy based on index
>>
>> NAK. It still takes a 'char' argument and the name is misleading.
>> Btw are you replacing phy_get() or adding a new API in addition to phy_get()?
> 
> Additional API. The phy_get() would in practice act as a wrapper after

In this patch it looks like you've replaced phy_get().
> this. It could actually be just a #define macro in the include file.
> The function naming I just copied straight from gpiolib.c. I did not
> have the imagination for anything fancier.
> 
> I would like to be able to use some function like phy_get_index() and
> be able to deliver it both the name and the index. With DT you guys
> will always be able to use the name (and the string will always
> supersede the index if we do it like this), but with ACPI, and possibly
> the platform lookup tables, the index can be used...

I think in that case, we should drop the 'string' from phy_get_index since we
have the other API to handle that? I don't know about ACPI, but is it not
possible to use strings with ACPI?

Thanks
Kishon
