Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3LPJBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:01:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42531 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab3LPJBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:01:04 -0500
Message-ID: <52AEC145.6070208@ti.com>
Date: Mon, 16 Dec 2013 14:30:53 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <matt.porter@linaro.org>
Subject: Re: [PATCH RESEND v2 1/2] phy: core: Add an exported of_phy_get function
References: <1386943380-28596-1-git-send-email-k.debski@samsung.com> <52AB1D75.4030207@ti.com> <008a01cef817$b24844e0$16d8cea0$%debski@samsung.com>
In-Reply-To: <008a01cef817$b24844e0$16d8cea0$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 December 2013 08:56 PM, Kamil Debski wrote:
> Hi Kishon,
> 
>> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
>> Sent: Friday, December 13, 2013 3:45 PM
>>
>> Hi,
>>
>> On Friday 13 December 2013 07:32 PM, Kamil Debski wrote:
>>> Previously the of_phy_get function took a struct device * and was
>>> declared static. It was impossible to call it from another driver and
>>> thus it was impossible to get phy defined for a given node. The old
>>> function was renamed to _of_phy_get and was left for internal use.
>>> of_phy_get function was added and it was exported. The function
>>> enables to get a phy for a given device tree node.
>>>
>>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
>>> ---
>>> It seems that my git send-email is playing up and sent the previous
>>> emails without from. This is a resend. Sorry for any confusion.
>>> ---
>>>  drivers/phy/phy-core.c  |   41 ++++++++++++++++++++++++++++++++-----
>> ----
>>>  include/linux/phy/phy.h |    1 +
>>>  2 files changed, 33 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c index
>>> 03cf8fb..f0dbd42 100644
>>> --- a/drivers/phy/phy-core.c
>>> +++ b/drivers/phy/phy-core.c
>>> @@ -240,8 +240,8 @@ out:
>>>  EXPORT_SYMBOL_GPL(phy_power_off);
>>>
>>>  /**
>>> - * of_phy_get() - lookup and obtain a reference to a phy by phandle
>>> - * @dev: device that requests this phy
>>> + * _of_phy_get() - lookup and obtain a reference to a phy by phandle
>>> + * @np: device_node for which to get the phy
>>>   * @index: the index of the phy
>>>   *
>>>   * Returns the phy associated with the given phandle value, @@
>>> -250,20 +250,17 @@ EXPORT_SYMBOL_GPL(phy_power_off);
>>>   * not yet loaded. This function uses of_xlate call back function
>> provided
>>>   * while registering the phy_provider to find the phy instance.
>>>   */
>>> -static struct phy *of_phy_get(struct device *dev, int index)
>>> +static struct phy *_of_phy_get(struct device_node *np, int index)
>>>  {
>>>  	int ret;
>>>  	struct phy_provider *phy_provider;
>>>  	struct phy *phy = NULL;
>>>  	struct of_phandle_args args;
>>>
>>> -	ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-
>> cells",
>>> +	ret = of_parse_phandle_with_args(np, "phys", "#phy-cells",
>>>  		index, &args);
>>> -	if (ret) {
>>> -		dev_dbg(dev, "failed to get phy in %s node\n",
>>> -			dev->of_node->full_name);
>>> +	if (ret)
>>>  		return ERR_PTR(-ENODEV);
>>> -	}
>>>
>>>  	mutex_lock(&phy_provider_mutex);
>>>  	phy_provider = of_phy_provider_lookup(args.np); @@ -283,6 +280,32
>> @@
>>> err0:
>>>  }
>>>
>>>  /**
>>> + * of_phy_get() - lookup and obtain a reference to a phy using a
>> device_node.
>>> + * @np: device_node for which to get the phy
>>> + * @index: the index of the phy
>>
>> Would be better if the user can get the PHY by string instead of index.
> 
> Ok, this sounds doable. I will add of_phy_get_by_name analogous to the clk
> framework.

Nope. It was decided initially to have minimal no of APIs exported to get PHYs.
So you can just get string as argument instead of index and leave the name of
the API to just of_phy_get.

Thanks
Kishon

> 
>>> + *
>>> + * Returns the phy driver, after getting a refcount to it; or
>>> + * -ENODEV if there is no such phy.  The caller is responsible for
>>> + * calling phy_put() to release that count.
>>> + */
>>> +struct phy *of_phy_get(struct device_node *np, int index) {
>>> +	struct phy *phy = NULL;
>>> +
>>> +	phy = _of_phy_get(np, index);
>>> +	if (IS_ERR(phy))
>> dev_err here?
> 
> dev_err requires a dev, so it is not possible with the arguments used.
> And we do not want to add any extra parameters to keep the function call
> analogous to other of_*_get (as for example of_clk_get).
> 
> Best wishes,
> 

