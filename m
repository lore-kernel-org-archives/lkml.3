Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3FEF1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:27:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50502 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab3FEF1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:27:12 -0400
Message-ID: <51AECBE6.9090400@ti.com>
Date: Wed, 5 Jun 2013 10:55:58 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <b-cousson@ti.com>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <akpm@linux-foundation.org>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>
Subject: Re: [PATCH v6 1/9] drivers: phy: add generic PHY framework
References: <1367229812-30574-1-git-send-email-kishon@ti.com> <1367229812-30574-2-git-send-email-kishon@ti.com> <51ADBF9B.5060403@samsung.com> <51ADDCD9.8080400@ti.com> <51ADEEF6.1030200@samsung.com>
In-Reply-To: <51ADEEF6.1030200@samsung.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 04 June 2013 07:13 PM, Sylwester Nawrocki wrote:
> Hi,
>
> On 06/04/2013 02:26 PM, Kishon Vijay Abraham I wrote:
>>>> +static inline int phy_init(struct phy *phy)
>>>> +{
>>>> +	pm_runtime_get_sync(&phy->dev);
>>>
>>> Hmm, no need to check return value here ? Also it looks a bit unexpected to
>>
>> I purposely dint check the return values in order to support platforms
>> that don’t enable pm_runtime.
>
> Then I guess this should be called conditionally and any errors returned
> if runtime PM is enabled ? Not sure if pm_runtime_enabled() would be
> helpful such situation.
Indeed. I think it can be used.
>
>>> possibly have runtime_resume callback of a PHY device called before ops->init()
>>> call ? It seems a bit unclear what the purpose of init() callback is.
>>
>> Not really. Anything that is used to initialize the PHY (internal
>> configuration) can go in phy_init. Usually in runtime_resume callback,
>> optional functional clocks are enabled and also in some cases context
>> restore is done. So it really makes sense to enable clocks/module
>> (pm_runtime_get_sync) before doing a PHY configuration (phy_init).
>
> OK, that makes sense. All PHY device resources must be prepared anyway
> before a PHY object is registered with the PHY core.
>
>>>> +	if (phy->ops->init)
>>>> +		return phy->ops->init(phy);
>>>> +
>>>> +	return -EINVAL;
>>>> +}
>>>> +
>>>> +static inline int phy_exit(struct phy *phy)
>>>> +{
>>>> +	int ret = -EINVAL;
>>>> +
>>>> +	if (phy->ops->exit)
>>>> +		ret = phy->ops->exit(phy);
>>>> +
>>>> +	pm_runtime_put_sync(&phy->dev);
>>>> +
>>>> +	return ret;
>>>> +}
>>>
>>> Do phy_init/phy_exit need to be mandatory ? What if there is really
>>
>> No. phy_init/phy_exit is not mandatory at all.
>>> nothing to do in those callbacks ? Perhaps -ENOIOCTLCMD should be
>>> returned if a callback is not implemented, so PHY users can recognize
>>> such situation and proceed ?
>>
>> So currently these APIs return -EINVAL if these callbacks are not
>> populated which is good enough IMHO.
>
> But -EINVAL could be well returned from the callback function. Perhaps
> ENOTSUPP could be used instead ?

hmm.. could be..

Thanks
Kishon
