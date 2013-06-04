Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3FDM11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:27:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55947 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab3FDM1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:27:21 -0400
Message-ID: <51ADDCD9.8080400@ti.com>
Date: Tue, 4 Jun 2013 17:56:01 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
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
References: <1367229812-30574-1-git-send-email-kishon@ti.com> <1367229812-30574-2-git-send-email-kishon@ti.com> <51ADBF9B.5060403@samsung.com>
In-Reply-To: <51ADBF9B.5060403@samsung.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 04 June 2013 03:51 PM, Sylwester Nawrocki wrote:
> On 04/29/2013 12:03 PM, Kishon Vijay Abraham I wrote:
>> The PHY framework provides a set of APIs for the PHY drivers to
>> create/destroy a PHY and APIs for the PHY users to obtain a reference to the
>> PHY with or without using phandle. For dt-boot, the PHY drivers should
>> also register *PHY provider* with the framework.
>>
>> PHY drivers should create the PHY by passing id and ops like init, exit,
>> power_on and power_off. This framework is also pm runtime enabled.
>>
>> The documentation for the generic PHY framework is added in
>> Documentation/phy.txt and the documentation for dt binding can be found at
>> Documentation/devicetree/bindings/phy/phy-bindings.txt
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   .../devicetree/bindings/phy/phy-bindings.txt       |   66 +++
>>   Documentation/phy.txt                              |  123 +++++
>>   MAINTAINERS                                        |    7 +
>>   drivers/Kconfig                                    |    2 +
>>   drivers/Makefile                                   |    2 +
>>   drivers/phy/Kconfig                                |   13 +
>>   drivers/phy/Makefile                               |    5 +
>>   drivers/phy/phy-core.c                             |  539 ++++++++++++++++++++
>>   include/linux/phy/phy.h                            |  248 +++++++++
>>   9 files changed, 1005 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
>>   create mode 100644 Documentation/phy.txt
>>   create mode 100644 drivers/phy/Kconfig
>>   create mode 100644 drivers/phy/Makefile
>>   create mode 100644 drivers/phy/phy-core.c
>>   create mode 100644 include/linux/phy/phy.h
>
>> +static inline int phy_init(struct phy *phy)
>> +{
>> +	pm_runtime_get_sync(&phy->dev);
>
> Hmm, no need to check return value here ? Also it looks a bit unexpected to

I purposely dint check the return values in order to support platforms 
that don’t enable pm_runtime.
> possibly have runtime_resume callback of a PHY device called before ops->init()
> call ? It seems a bit unclear what the purpose of init() callback is.

Not really. Anything that is used to initialize the PHY (internal 
configuration) can go in phy_init. Usually in runtime_resume callback, 
optional functional clocks are enabled and also in some cases context 
restore is done. So it really makes sense to enable clocks/module 
(pm_runtime_get_sync) before doing a PHY configuration (phy_init).

>
>> +	if (phy->ops->init)
>> +		return phy->ops->init(phy);
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static inline int phy_exit(struct phy *phy)
>> +{
>> +	int ret = -EINVAL;
>> +
>> +	if (phy->ops->exit)
>> +		ret = phy->ops->exit(phy);
>> +
>> +	pm_runtime_put_sync(&phy->dev);
>> +
>> +	return ret;
>> +}
>
> Do phy_init/phy_exit need to be mandatory ? What if there is really

No. phy_init/phy_exit is not mandatory at all.
> nothing to do in those callbacks ? Perhaps -ENOIOCTLCMD should be
> returned if a callback is not implemented, so PHY users can recognize
> such situation and proceed ?

So currently these APIs return -EINVAL if these callbacks are not 
populated which is good enough IMHO.
>
>> +static inline int phy_power_on(struct phy *phy)
>> +{
>> +	if (phy->ops->power_on)
>> +		return phy->ops->power_on(phy);
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static inline int phy_power_off(struct phy *phy)
>> +{
>> +	if (phy->ops->power_off)
>> +		return phy->ops->power_off(phy);
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static inline int phy_pm_runtime_get(struct phy *phy)
>> +{
>> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
>> +		return -EINVAL;
>> +
>> +	return pm_runtime_get(&phy->dev);
>> +}
>> +
>> +static inline int phy_pm_runtime_get_sync(struct phy *phy)
>> +{
>> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
>> +		return -EINVAL;
>> +
>> +	return pm_runtime_get_sync(&phy->dev);
>> +}
>> +
>> +static inline int phy_pm_runtime_put(struct phy *phy)
>> +{
>> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
>> +		return -EINVAL;
>> +
>> +	return pm_runtime_put(&phy->dev);
>> +}
>> +
>> +static inline int phy_pm_runtime_put_sync(struct phy *phy)
>> +{
>> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
>> +		return -EINVAL;
>> +
>> +	return pm_runtime_put_sync(&phy->dev);
>> +}
>> +
>> +static inline void phy_pm_runtime_allow(struct phy *phy)
>> +{
>> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
>> +		return;
>> +
>> +	pm_runtime_allow(&phy->dev);
>> +}
>> +
>> +static inline void phy_pm_runtime_forbid(struct phy *phy)
>> +{
>> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
>> +		return;
>> +
>> +	pm_runtime_forbid(&phy->dev);
>> +}
>
> Do we need to have all these runtime PM wrappers ? I guess you
> intended to avoid referencing phy->dev from the PHY consumers ?

Yeah.. I dint want pm_runtime of phy core device to be called from PHY 
consumers.

Thanks
Kishon
