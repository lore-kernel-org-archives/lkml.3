Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab3HMPy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:54:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38047 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321Ab3HMPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:54:58 -0400
Message-ID: <520A56CE.3000901@codeaurora.org>
Date: Tue, 13 Aug 2013 09:54:54 -0600
From: Jeffrey Hugo <jhugo@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Kumar Gala <galak@codeaurora.org>, ohad@wizery.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, Eric Holmberg <eholmber@codeaurora.org>
Subject: Re: [PATCH v2] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex
 block
References: <1375135257-17222-1-git-send-email-galak@codeaurora.org> <52090EE9.7030602@codeaurora.org>
In-Reply-To: <52090EE9.7030602@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/2013 10:35 AM, Stephen Boyd wrote:
> On 07/29/13 15:00, Kumar Gala wrote:
>> diff --git a/drivers/hwspinlock/msm_hwspinlock.c b/drivers/hwspinlock/msm_hwspinlock.c
>> new file mode 100644
>> index 0000000..dbd9a69
>> --- /dev/null
>> +++ b/drivers/hwspinlock/msm_hwspinlock.c
>> @@ -0,0 +1,150 @@
>> +/*
>> + * Copyright (c) 2013, The Linux Foundation. All rights reserved.
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/device.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_device.h>
>> +#include <linux/hwspinlock.h>
>> +#include <linux/io.h>
>> +
>> +#include "hwspinlock_internal.h"
>> +
>> +#define SPINLOCK_ID_APPS_PROC	1
>
> Is this id only for the apps processor? What about hexagon? Does it need
> a different number?

Yes, hexagon would need a different id based on what job that particular 
hexagon processor is doing.  I'm not currently aware of a hexagon 
usecase, but I believe modifying the DT binding in the future would 
cover the usecase if it comes up.

>
>> +#define BASE_ID			0
>> +
>> +static int msm_hwspinlock_trylock(struct hwspinlock *lock)
>> +{
>> +	void __iomem *lock_addr = lock->priv;
>> +
>> +	writel_relaxed(SPINLOCK_ID_APPS_PROC, lock_addr);
>> +	smp_mb();
>> +	return readl_relaxed(lock_addr) == SPINLOCK_ID_APPS_PROC;
>> +}
>> +
>> +static void msm_hwspinlock_unlock(struct hwspinlock *lock)
>> +{
>> +	int lock_owner;
>
> This should probably be u32 to be explicit about the size of the register.
>
>> +	void __iomem *lock_addr = lock->priv;
>> +
>> +	lock_owner = readl_relaxed(lock_addr);
>> +	if (lock_owner != SPINLOCK_ID_APPS_PROC) {
>> +		pr_err("%s: spinlock not owned by Apps (actual owner is %d)\n",
>
> Maybe you should just say "spinlock not owned by us (actual owner is
> %d)" so that this driver is agnostic to the processor it runs on?
>
>> +				__func__, lock_owner);
>> +	}
>> +
>> +	writel_relaxed(0, lock_addr);
>> +	smp_mb();
>> +}
>>
>


Jeffrey Hugo
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation.
