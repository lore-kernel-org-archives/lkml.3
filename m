Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab3G2Vy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:54:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46106 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab3G2Vy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:54:26 -0400
Subject: Re: [PATCH] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex block
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20130729214035.GC8868@codeaurora.org>
Date: Mon, 29 Jul 2013 16:54:24 -0500
Cc: ohad@wizery.com,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <9EB1A821-7137-4812-B58A-20F669BCA7DD@codeaurora.org>
References: <1375128719-23642-1-git-send-email-galak@codeaurora.org> <E9700EA7-7154-46C5-9258-03F030DF69F6@codeaurora.org> <20130729214035.GC8868@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 29, 2013, at 4:40 PM, Stephen Boyd wrote:

> On 07/29, Kumar Gala wrote:
>>> diff --git a/Documentation/devicetree/bindings/arm/msm/tcsr-mutex.txt b/Documentation/devicetree/bindings/arm/msm/tcsr-mutex.txt
>>> new file mode 100644
>>> index 0000000..ddd6889
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/arm/msm/tcsr-mutex.txt
> 
> Maybe this should go under a new hwspinlock directory?

Will look for Ohad to comment on this.

> 
>>> @@ -0,0 +1,20 @@
>>> +Qualcomm MSM Hardware Mutex Block:
>>> +
>>> +The hardware block provides mutexes utilized between different processors
>>> +on the SoC as part of the communication protocol used by these processors.
>>> +
>>> +Required properties:
>>> +- compatible: should be "qcom,tcsr-mutex"
>>> +- reg: Should contain registers location and length of mutex registers
>>> +- reg-names:
>>> +	"mutex-base"  - string to identify mutex registers
>>> +- qcom,num-locks: the number of locks/mutexes supported
>>> +
>>> +Example:
>>> +
>>> +	qcom,tcsr-mutex@fd484000 {
> 
> Maybe it should be hw-mutex@fd484000?

again, will look for Ohad to make some comment on this.

>>> +		compatible = "qcom,tcsr-mutex";
>>> +		reg = <0xfd484000 0x1000>;
>>> +		reg-names = "mutex-base";
>>> +		qcom,num-locks = <32>;
>>> +	};
>>> diff --git a/drivers/hwspinlock/msm_hwspinlock.c b/drivers/hwspinlock/msm_hwspinlock.c
>>> new file mode 100644
>>> index 0000000..c7d80c5
>>> --- /dev/null
>>> +++ b/drivers/hwspinlock/msm_hwspinlock.c
>>> @@ -0,0 +1,150 @@
>>> +/*
>>> + * Copyright (c) 2013, The Linux Foundation. All rights reserved.
>>> + *
>>> + * This software is licensed under the terms of the GNU General Public
>>> + * License version 2, as published by the Free Software Foundation, and
>>> + * may be copied, distributed, and modified under those terms.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +
>>> +#include <linux/err.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/device.h>
>>> +#include <linux/module.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_address.h>
>>> +#include <linux/of_device.h>
>>> +#include <linux/hwspinlock.h>
>>> +
>>> +#include <asm/io.h>
> 
> <linux/io.h> please.

will change, I choice <asm/io.h> since *_relaxed are arm specific.

>>> +
>>> +#include "hwspinlock_internal.h"
>>> +
>>> +#define SPINLOCK_ID_APPS_PROC	1
>>> +#define BASE_ID			0
>>> +
>>> +static int msm_hwspinlock_trylock(struct hwspinlock *lock)
>>> +{
>>> +	void __iomem *lock_addr = lock->priv;
>>> +
>>> +	writel_relaxed(SPINLOCK_ID_APPS_PROC, lock_addr);
>>> +	smp_mb();
> 
> Are you sure you don't want mb() instead? What is this barrier
> for? Comment please.

Hopefully, Eric or Jeff can comment.

>>> +	return readl_relaxed(lock_addr) == SPINLOCK_ID_APPS_PROC;
>>> +}
>>> +
>>> +static void msm_hwspinlock_unlock(struct hwspinlock *lock)
>>> +{
>>> +	int lock_owner;
>>> +	void __iomem *lock_addr = lock->priv;
>>> +
>>> +	lock_owner = readl_relaxed(lock_addr);
>>> +	if (lock_owner != SPINLOCK_ID_APPS_PROC) {
>>> +		pr_err("%s: spinlock not owned by Apps (actual owner is %d)\n",
>>> +				__func__, lock_owner);
>>> +	}
>>> +
>>> +	writel_relaxed(0, lock_addr);
>>> +	smp_mb();
> 
> Same here. What is smp_mb() for?

Hopefully, Eric or Jeff can comment.

> 
>>> +}
>>> +
>>> +static const struct hwspinlock_ops msm_hwspinlock_ops = {
>>> +	.trylock	= msm_hwspinlock_trylock,
>>> +	.unlock		= msm_hwspinlock_unlock,
>>> +};
>>> +
>>> +static struct of_device_id msm_hwspinlock_of_match[];
> 
> Why not just put the match table here then? Also, can it be
> const?

Will change and make const

> 
>>> +static int msm_hwspinlock_probe(struct platform_device *pdev)
>>> +{
>>> +	int ret, i, stride;
>>> +	u32 num_locks;
>>> +	struct hwspinlock_device *bank;
>>> +	struct hwspinlock *hwlock;
>>> +	struct resource *res;
>>> +	void __iomem *iobase;
>>> +	struct device_node *node = pdev->dev.of_node;
>>> +	const struct of_device_id *match;
>>> +
>>> +	match = of_match_device(msm_hwspinlock_of_match, &pdev->dev);
>>> +	if (!match)
>>> +		return -EINVAL;
>>> +
>>> +	ret = of_property_read_u32(node, "qcom,num-locks", &num_locks);
>>> +	if (ret || (num_locks == 0))
> 
> Drop useless ().

done

> 
>>> +		return -ENODEV;
>>> +
>>> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mutex-base");
>>> +	iobase = devm_ioremap_resource(&pdev->dev, res);
>>> +	if (IS_ERR(iobase))
>>> +		return PTR_ERR(iobase);
>>> +
>>> +	bank = devm_kzalloc(&pdev->dev,
>>> +		 sizeof(*bank) + num_locks * sizeof(*hwlock), GFP_KERNEL);
>>> +	if (!bank)
>>> +		return -ENOMEM;
>>> +
> 
> Style Nit: Maybe we could grow a local variable to get this to be
> one line.
> 
> 	size_t array_size;
> 
> 	array_size = num_lock * sizeof(*hwlock);
> 	bank = devm_kzalloc(&pdev->dev, sizeof(*bank) + array_size, GFP_KERNEL);

done

- k

> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

