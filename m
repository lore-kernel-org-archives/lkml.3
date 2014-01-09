Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaAIF1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:27:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47368 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaAIF1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:27:51 -0500
Message-ID: <52CE3343.3020902@ti.com>
Date: Thu, 9 Jan 2014 10:57:31 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <kyungmin.park@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>,
        <tjakobi@math.uni-bielefeld.de>, <stern@rowland.harvard.edu>
Subject: Re: [PATCH v5 3/9] phy: Add new Exynos USB 2.0 PHY driver
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com> <1387545857-9472-4-git-send-email-k.debski@samsung.com> <52CA818A.4090403@ti.com> <04dc01cf0c9a$f37c24d0$da746e70$%debski@samsung.com>
In-Reply-To: <04dc01cf0c9a$f37c24d0$da746e70$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 08 January 2014 11:26 PM, Kamil Debski wrote:
> Hi,
> 
>> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
>> Sent: Monday, January 06, 2014 11:12 AM
>>
>> Hi,
>>
>> On Friday 20 December 2013 06:54 PM, Kamil Debski wrote:
>>> Add a new driver for the Exynos USB 2.0 PHY. The new driver uses the
>>> generic PHY framework. The driver includes support for the Exynos
>> 4x10
>>> and 4x12 SoC families.
>>>
>>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>   .../devicetree/bindings/phy/samsung-phy.txt        |   55 ++++
>>>   drivers/phy/Kconfig                                |   29 ++
>>>   drivers/phy/Makefile                               |    3 +
>>>   drivers/phy/phy-exynos4210-usb2.c                  |  257
>> ++++++++++++++++
>>>   drivers/phy/phy-exynos4212-usb2.c                  |  306
>> ++++++++++++++++++++
>>>   drivers/phy/phy-samsung-usb2.c                     |  226
>> +++++++++++++++
>>>   drivers/phy/phy-samsung-usb2.h                     |   67 +++++
>>>   7 files changed, 943 insertions(+)
>>>   create mode 100644 drivers/phy/phy-exynos4210-usb2.c
>>>   create mode 100644 drivers/phy/phy-exynos4212-usb2.c
>>>   create mode 100644 drivers/phy/phy-samsung-usb2.c
>>>   create mode 100644 drivers/phy/phy-samsung-usb2.h
>>>
>> .
>> .
>> <snip>
>> .
>> .
>>
>>> diff --git a/drivers/phy/phy-samsung-usb2.h
>>> b/drivers/phy/phy-samsung-usb2.h new file mode 100644 index
>>> 0000000..ab89f91
>>> --- /dev/null
>>> +++ b/drivers/phy/phy-samsung-usb2.h
>>> @@ -0,0 +1,67 @@
>>> +/*
>>> + * Samsung SoC USB 1.1/2.0 PHY driver
>>> + *
>>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>>> + * Author: Kamil Debski <k.debski@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> +modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#ifndef _PHY_EXYNOS_USB2_H
>>> +#define _PHY_EXYNOS_USB2_H
>>> +
>>> +#include <linux/clk.h>
>>> +#include <linux/phy/phy.h>
>>> +#include <linux/device.h>
>>> +#include <linux/regmap.h>
>>> +#include <linux/spinlock.h>
>>> +
>>> +#define KHZ 1000
>>> +#define MHZ (KHZ * KHZ)
>>> +
>>> +struct samsung_usb2_phy_driver;
>>> +struct samsung_usb2_phy_instance;
>>> +struct samsung_usb2_phy_config;
>>> +
>>> +struct samsung_usb2_phy_instance {
>>> +	const struct samsung_usb2_common_phy *cfg;
>>> +	struct clk *clk;
>>> +	struct phy *phy;
>>> +	struct samsung_usb2_phy_driver *drv;
>>> +	unsigned long rate;
>>> +	u32 clk_reg_val;
>>> +	bool enabled;
>>> +};
>>> +
>>> +struct samsung_usb2_phy_driver {
>>> +	const struct samsung_usb2_phy_config *cfg;
>>> +	struct clk *clk;
>>> +	struct device *dev;
>>> +	void __iomem *reg_phy;
>>> +	struct regmap *reg_pmu;
>>> +	struct regmap *reg_sys;
>>> +	spinlock_t lock;
>>> +	struct samsung_usb2_phy_instance instances[0];
>>
>> I think having instances as array here would allocate more space while
>> allocating 'samsung_usb2_phy_driver' in 'samsung_usb2_phy_probe'.
>>
> 
> I am not sure if I understand you correctly here. Maybe I will explain
> what I intended to write. An array with size 0 at the end of a structure
> takes no space in the structure. The benefit of using it is that after
> the structure one can allocate a number of the array elements and
> address them easily. Another option would be placing pointer in the
> samsung_usb2_phy_instance and allocate memory separately, but this would
> involve two allocations and a pointer would be always present in the 
> structure.

Al-right.. makes sense.

Thanks
Kishon
> 
> Best wishes,
> 

