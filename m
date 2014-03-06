Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaCFI5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:57:04 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45098 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaCFI5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:57:01 -0500
Message-ID: <5318384B.7020009@ti.com>
Date: Thu, 6 Mar 2014 14:26:43 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Anton Tikhomirov <av.tikhomirov@samsung.com>,
        "'Kamil Debski'" <k.debski@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <s.nawrocki@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <jg1.han@samsung.com>, <galak@codeaurora.org>,
        <matt.porter@linaro.org>, <tjakobi@math.uni-bielefeld.de>,
        <stern@rowland.harvard.edu>, <sander@humilis.net>
Subject: Re: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
References: <1394033288-5551-1-git-send-email-k.debski@samsung.com> <1394033288-5551-4-git-send-email-k.debski@samsung.com> <005c01cf3915$c53476c0$4f9d6440$%tikhomirov@samsung.com> <53183220.3040606@ti.com> <006201cf3919$5f760750$1e6215f0$%tikhomirov@samsung.com>
In-Reply-To: <006201cf3919$5f760750$1e6215f0$%tikhomirov@samsung.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 06 March 2014 02:22 PM, Anton Tikhomirov wrote:
> Hello,
>
>> Subject: Re: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
>>
>>
>>
>> On Thursday 06 March 2014 01:56 PM, Anton Tikhomirov wrote:
>>> Hi Kamil,
>>>
>>> ...
>>>
>>>> +| 3. Supporting SoCs
>>>> ++--------------------
>>>> +
>>>> +To support a new SoC a new file should be added to the drivers/phy
>>>> +directory. Each SoC's configuration is stored in an instance of the
>>>> +struct samsung_usb2_phy_config.
>>>> +
>>>> +struct samsung_usb2_phy_config {
>>>> +	const struct samsung_usb2_common_phy *phys;
>>>> +	unsigned int num_phys;
>>>> +	bool has_mode_switch;
>>>
>>> You missed rate_to_clk here.
>>>
>>>> +};
>>>> +
>>>
>>> ...
>>>
>>>> diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-
>> samsung-
>>>> usb2.c
>>>> new file mode 100644
>>>> index 0000000..c3b7719
>>>> --- /dev/null
>>>> +++ b/drivers/phy/phy-samsung-usb2.c
>>>> @@ -0,0 +1,222 @@
>>>> +/*
>>>> + * Samsung SoC USB 1.1/2.0 PHY driver
>>>> + *
>>>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>>>> + * Author: Kamil Debski <k.debski@samsung.com>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or
>>>> modify
>>>> + * it under the terms of the GNU General Public License version 2
>> as
>>>> + * published by the Free Software Foundation.
>>>> + */
>>>> +
>>>> +#include <linux/clk.h>
>>>> +#include <linux/mfd/syscon.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/of.h>
>>>> +#include <linux/of_address.h>
>>>> +#include <linux/phy/phy.h>
>>>> +#include <linux/platform_device.h>
>>>> +#include <linux/spinlock.h>
>>>> +#include "phy-samsung-usb2.h"
>>>> +
>>>> +static int samsung_usb2_phy_power_on(struct phy *phy)
>>>> +{
>>>> +	struct samsung_usb2_phy_instance *inst = phy_get_drvdata(phy);
>>>> +	struct samsung_usb2_phy_driver *drv = inst->drv;
>>>> +	int ret;
>>>> +
>>>> +	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
>>>> +		inst->cfg->label);
>>>> +	ret = clk_prepare_enable(drv->clk);
>>>
>>> clk_prepare_enable() can sleep, and therefore doesn't allow
>>> samusng_usb2_phy_power_on() to be used in atomic context
>>> (e.g. inside spin_lock-ed area), what sometimes may be desirable.
>>> What about to prepare clock in probe, and just enable it here
>>> (note: clk_enable() doesn't sleep).
>>
>> The PHY power-on callback is anyway called with mutex held, so I guess
>> it's fine to have clk_prepare_enable() here.
>
> If we rely totally on generic PHY functions such as phy_power_on()
> and friends, why do we need to use locking in callbacks at all.

Didn't get you.. We don't want to invoke power_on when init is getting 
executed or you don't want power on or power off to get executed 
simultaneously right? So we need to protect it.

Cheers
Kishon
