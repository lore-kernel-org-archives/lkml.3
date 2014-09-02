Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaIBR2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:28:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48113 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaIBR2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:28:37 -0400
Message-ID: <5405FE42.90809@codeaurora.org>
Date: Tue, 02 Sep 2014 11:28:34 -0600
From: Jeffrey Hugo <jhugo@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Suman Anna <s-anna@ti.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Eric Holmberg <eholmber@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: [PATCH v2] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex
 block
References: <1409354063-20289-1-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1409354063-20289-1-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/2014 5:14 PM, Bjorn Andersson wrote:
> From: Kumar Gala <galak@codeaurora.org>
>
> Add driver for Qualcomm MSM Hardware Mutex block that exists on
> newer Qualcomm SoCs.
>
> Cc: Jeffrey Hugo <jhugo@codeaurora.org>
> Cc: Eric Holmberg <eholmber@codeaurora.org>
> Cc: Courtney Cavin <courtney.cavin@sonymobile.com>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> [bjorn: added pm_runtime calls, from Courtney,
> 	added sfpb-mutex compatible,
> 	updated DT binding documentation formatting]
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
[...]
> diff --git a/drivers/hwspinlock/msm_hwspinlock.c b/drivers/hwspinlock/msm_hwspinlock.c
> new file mode 100644
> index 0000000..9ddd020
> --- /dev/null
> +++ b/drivers/hwspinlock/msm_hwspinlock.c
> @@ -0,0 +1,155 @@
> +/*
> + * Copyright (c) 2013, The Linux Foundation. All rights reserved.

Should the copyright range be updated to include your changes which I 
presume were authored in 2014?

> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/hwspinlock.h>
> +#include <linux/io.h>

Could these be put in alphabetical order?  I vaguely recall a few 
maintainers expressing this preference to avoid merge issues.

> +
> +#include "hwspinlock_internal.h"
> +
> +#define SPINLOCK_ID_APPS_PROC	1
> +#define BASE_ID			0
[...]
> +static int msm_hwspinlock_probe(struct platform_device *pdev)
> +{
> +	int ret, i, stride;
> +	size_t array_size;
> +	u32 num_locks;
> +	struct hwspinlock_device *bank;
> +	struct hwspinlock *hwlock;
> +	struct resource *res;
> +	void __iomem *iobase;
> +	struct device_node *node = pdev->dev.of_node;
> +	const struct of_device_id *match;
> +
> +	match = of_match_device(msm_hwspinlock_of_match, &pdev->dev);
> +	if (!match)
> +		return -EINVAL;

This seems redundant.  It is my understanding that probe will only be 
called for a matching device.  What are we attempting to accomplish here?

> +
> +	ret = of_property_read_u32(node, "qcom,num-locks", &num_locks);
> +	if (ret || num_locks == 0)
> +		return -ENODEV;
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mutex-base");
> +	iobase = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(iobase))
> +		return PTR_ERR(iobase);
> +
> +	array_size = num_locks * sizeof(*hwlock);
> +	bank = devm_kzalloc(&pdev->dev, sizeof(*bank) + array_size, GFP_KERNEL);
> +	if (!bank)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, bank);
> +
> +	stride = (int)match->data;
> +	for (i = 0, hwlock = &bank->lock[0]; i < num_locks; i++, hwlock++)
> +		hwlock->priv = iobase + i * stride;

I am not a fan of this method for determining the stride.  We already 
have 0x4 and 0x80 in this driver, and will soon need 0x1000 for some of 
the current chips (still listed as TCSR too).  The stride is completely 
up to our hardware designers, and it seems like encoding stride in this 
manner will require constant updates and maintenance.  I prefer 
calculating stride by dividing the reg size by num_locks since that will 
automatically adjust for whatever the hardware designers decide to use 
next month.  If you wanted to, with the reg size calculation, you could 
remove the "qcom,sfpb-mutex" since there is no functional difference 
other than stride.  What are your thoughts?

> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	ret = hwspin_lock_register(bank, &pdev->dev, &msm_hwspinlock_ops,
> +						BASE_ID, num_locks);
> +	if (ret)
> +		pm_runtime_disable(&pdev->dev);
> +
> +	return ret;
> +}
[...]


Jeffrey Hugo
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation.
