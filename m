Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaFFKo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:44:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51985 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaFFKoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:44:23 -0400
Message-ID: <53919B82.9040705@gmail.com>
Date: Fri, 06 Jun 2014 12:44:18 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] reset: add the Berlin reset controller driver
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com> <1401983326-19205-2-git-send-email-antoine.tenart@free-electrons.com> <1401986205.4103.9.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1401986205.4103.9.camel@paszta.hi.pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 06:36 PM, Philipp Zabel wrote:
> Am Donnerstag, den 05.06.2014, 17:48 +0200 schrieb Antoine Ténart:
>> Add a reset controller for Marvell Berlin SoCs which is used by the
>> USB PHYs drivers (for now).
>>
>> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
>> ---
>>   drivers/reset/Makefile       |   1 +
>>   drivers/reset/reset-berlin.c | 113 +++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 114 insertions(+)
>>   create mode 100644 drivers/reset/reset-berlin.c
>>
[...]
>>   obj-$(CONFIG_ARCH_STI) += sti/
>> diff --git a/drivers/reset/reset-berlin.c b/drivers/reset/reset-berlin.c
>> new file mode 100644
>> index 000000000000..78b42c882cb2
>> --- /dev/null
>> +++ b/drivers/reset/reset-berlin.c
>> @@ -0,0 +1,113 @@
>> +/*
>> + * Copyright (C) 2014 Marvell Technology Group Ltd.
>> + *
>> + * Antoine Ténart <antoine.tenart@free-electrons.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2. This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#include <linux/delay.h>
>> +#include <linux/io.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/platform_device.h>
>
> Is there a reason this is not actually implemented as platform device?
>
[...]
>> +static int __berlin_reset_init(struct device_node *np)
>> +{
>> +	struct berlin_reset_priv *priv;
>> +	struct resource res;
>> +	resource_size_t size;
>> +	int ret;
>> +
>> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>> +	if (!priv)
>> +		return -ENOMEM;
>> +
>> +	ret = of_address_to_resource(np, 0, &res);
>> +	if (ret)
>> +		goto err;
>> +
>> +	size = resource_size(&res);
>> +
>> +	priv->base = ioremap(res.start, size);
>> +	if (!priv->base) {
>> +		ret = -ENOMEM;
>> +		goto err;
>> +	}
>
> A platform driver could use devm_kzalloc, platform_get_resource,
> and devm_ioremap_resource here.
>
>> +	priv->base += BERLIN_RESET_REGISTER;
>> +
>> +	priv->rcdev.owner = THIS_MODULE;
>> +	priv->rcdev.nr_resets = size * 32;
>
> This doesn't seem right. The device tree patch shows that
> size = 0x400.

Actually, not using a platform_device now is the outcome of
some late DT node rework we had for the clock driver. The reason
we only have one node for the whole register set providing
pinctrl, reset, clock, ... is that it would require tiny separate
register ranges spread over the whole register set.

Instead, the idea is to have a single DT node, register a
driver providing a mmio regmap, and registering individual
platform_devices for the non-early drivers using the regmap.
We also evaluated syscon, but it will require dummy nodes for
each proper platform_device and that is something we really
want to avoid here.

Of course, writing that driver is delayed on my side because
of other non-Linux stuff that has to be taken care of first.
As I cannot tell how much time I can spend on it now, I prefer
to take this as is and provide update patches as soon as I have
worked out the regset driver.

Sebastian
