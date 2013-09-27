Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3I0RO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:14:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56061 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab3I0ROX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:14:23 -0400
Subject: Re: [PATCHv2 1/9] hwspinlock/core: add common dt bindings and OF helpers
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <5245B6F9.7030505@ti.com>
Date: Fri, 27 Sep 2013 12:14:19 -0500
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>, Paul Walmsley <paul@pwsan.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <3C582FCF-7A24-48AC-B98B-AF1D18C1E22B@codeaurora.org>
References: <cover.1379445653.git.s-anna@ti.com> <4df03ac30dcc79132e3acc2e586d0ca99b431258.1379445653.git.s-anna@ti.com> <14DB8294-1148-446A-A6D3-34E66BA8732C@codeaurora.org> <5245B6F9.7030505@ti.com>
To: Suman Anna <s-anna@ti.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 27, 2013, at 11:48 AM, Suman Anna wrote:

> Kumar,
> 
> On 09/27/2013 11:04 AM, Kumar Gala wrote:
>> 
>> On Sep 17, 2013, at 2:30 PM, Suman Anna wrote:
>> 
>>> All the platform-specific hwlock driver implementations need the
>>> number of locks and the associated base id for registering the
>>> locks present within a hwspinlock device with the driver core.
>>> These two variables are represented by 'hwlock-num-locks' and
>>> 'hwlock-base-id' properties. The documentation and OF helpers to
>>> retrieve these common properties have been added to the driver core.
>>> 
>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>> ---
>>> .../devicetree/bindings/hwlock/hwlock.txt          | 26 +++++++++
>>> drivers/hwspinlock/hwspinlock_core.c               | 61 +++++++++++++++++++++-
>>> include/linux/hwspinlock.h                         | 11 ++--
>>> 3 files changed, 93 insertions(+), 5 deletions(-)
>>> create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
>>> 
>>> diff --git a/Documentation/devicetree/bindings/hwlock/hwlock.txt b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>>> new file mode 100644
>>> index 0000000..789930e
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>>> @@ -0,0 +1,26 @@
>>> +Generic hwlock bindings
>>> +=======================
>>> +
>>> +Generic bindings that are common to all the hwlock platform specific driver
>>> +implementations, the retrieved values are used for registering the device
>>> +specific parameters with the hwspinlock core.
>>> +
>>> +The validity and need of these common properties may vary from one driver
>>> +implementation to another. Look through the individual hwlock driver
>>> +binding documentations for identifying which are mandatory and which are
>>> +optional for that specific driver.
>>> +
>>> +Common properties:
>>> +- hwlock-base-id:	Base Id for the locks for a particular hwlock device.
>>> +			This property is used for representing a set of locks
>>> +			present in a hwlock device with a unique base id in
>>> +			the driver core. This property is mandatory ONLY if a
>>> +			SoC has several hwlock devices.
>>> +
>>> +			See documentation on struct hwspinlock_pdata in
>>> +			linux/hwspinlock.h for more details.
>>> +
>>> +- hwlock-num-locks:	Number of locks present in a hwlock device. This
>>> +			property is needed on hwlock devices, where the number
>>> +			of supported locks within a hwlock device cannot be
>>> +			read from a register.

Was meaning to say this before, another reason for hwlock-num-locks is to limit the # of locks available to the processors running linux vs what other processors in the SoC might be using.


>>> diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
>>> index 461a0d7..aec32e7 100644
>>> --- a/drivers/hwspinlock/hwspinlock_core.c
>>> +++ b/drivers/hwspinlock/hwspinlock_core.c
>>> @@ -1,7 +1,7 @@
>>> /*
>>> * Hardware spinlock framework
>>> *
>>> - * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com
>>> + * Copyright (C) 2010-2013 Texas Instruments Incorporated - http://www.ti.com
>>> *
>>> * Contact: Ohad Ben-Cohen <ohad@wizery.com>
>>> *
>>> @@ -27,6 +27,7 @@
>>> #include <linux/hwspinlock.h>
>>> #include <linux/pm_runtime.h>
>>> #include <linux/mutex.h>
>>> +#include <linux/of.h>
>>> 
>>> #include "hwspinlock_internal.h"
>>> 
>>> @@ -308,6 +309,64 @@ out:
>>> }
>>> 
>>> /**
>>> + * of_hwspin_lock_get_base_id() - OF helper to retrieve base id
>>> + * @dn: device node pointer
>>> + *
>>> + * This is an OF helper function that can be called by the underlying
>>> + * platform-specific implementations, to retrieve the base id for the
>>> + * set of locks present within a hwspinlock device instance.
>>> + *
>>> + * Returns the base id value on success, -ENODEV on generic failure or
>>> + * an appropriate error code as returned by the OF layer
>>> + */
>>> +int of_hwspin_lock_get_base_id(struct device_node *dn)
>>> +{
>>> +	unsigned int val;
>>> +	int ret = -ENODEV;
>>> +
>>> +#ifdef CONFIG_OF
>>> +	if (!dn)
>>> +		return -ENODEV;
>> 
>> Checking !dn is done in of_property_read_u32, so you don't need to duplicate
> 
> I have added this specifically since my intention is to differentiate
> the validity of the node vs the presence of the property within a node.
> This property may be optional for some platforms and a must for some
> others, and differentiating would allow the individual driver
> implementations to make the distinction.

Maybe add a comment for both cases.

> 
>> 
>>> +
>>> +	ret = of_property_read_u32(dn, "hwlock-base-id", &val);
>>> +	if (!ret)
>>> +		ret = val;
>>> +#endif
>>> +
>>> +	return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(of_hwspin_lock_get_base_id);
>>> +
>>> +/**
>>> + * of_hwspin_lock_get_num_locks() - OF helper to retrieve number of locks
>>> + * @dn: device node pointer
>>> + *
>>> + * This is an OF helper function that can be called by the underlying
>>> + * platform-specific implementations, to retrieve the number of locks
>>> + * present within a hwspinlock device instance.
>>> + *
>>> + * Returns a positive number of locks on success, -ENODEV on generic
>>> + * failure or an appropriate error code as returned by the OF layer
>>> + */
>>> +int of_hwspin_lock_get_num_locks(struct device_node *dn)
>>> +{
>>> +	unsigned int val;
>>> +	int ret = -ENODEV;
>>> +
>>> +#ifdef CONFIG_OF
>>> +	if (!dn)
>>> +		return -ENODEV;
>> 
>> Checking !dn is done in of_property_read_u32, so you don't need to duplicate
> 
> Same comment as above.
> 
> regards
> Suman
> 
>> 
>>> +
>>> +	ret = of_property_read_u32(dn, "hwlock-num-locks", &val);
>>> +	if (!ret)
>>> +		ret = val ? val : -ENODEV;
>>> +#endif
>>> +
>>> +	return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(of_hwspin_lock_get_num_locks);
>>> +
>>> +/**
>>> * hwspin_lock_register() - register a new hw spinlock device
>>> * @bank: the hwspinlock device, which usually provides numerous hw locks
>>> * @dev: the backing device
>>> diff --git a/include/linux/hwspinlock.h b/include/linux/hwspinlock.h
>>> index 3343298..1f6a5b8 100644
>>> --- a/include/linux/hwspinlock.h
>>> +++ b/include/linux/hwspinlock.h
>>> @@ -1,7 +1,7 @@
>>> /*
>>> * Hardware spinlock public header
>>> *
>>> - * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com
>>> + * Copyright (C) 2010-2013 Texas Instruments Incorporated - http://www.ti.com
>>> *
>>> * Contact: Ohad Ben-Cohen <ohad@wizery.com>
>>> *
>>> @@ -26,6 +26,7 @@
>>> #define HWLOCK_IRQ	0x02	/* Disable interrupts, don't save state */
>>> 
>>> struct device;
>>> +struct device_node;
>>> struct hwspinlock;
>>> struct hwspinlock_device;
>>> struct hwspinlock_ops;
>>> @@ -60,6 +61,8 @@ struct hwspinlock_pdata {
>>> 
>>> #if defined(CONFIG_HWSPINLOCK) || defined(CONFIG_HWSPINLOCK_MODULE)
>>> 
>>> +int of_hwspin_lock_get_base_id(struct device_node *dn);
>>> +int of_hwspin_lock_get_num_locks(struct device_node *dn);
>>> int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
>>> 		const struct hwspinlock_ops *ops, int base_id, int num_locks);
>>> int hwspin_lock_unregister(struct hwspinlock_device *bank);
>>> @@ -80,9 +83,9 @@ void __hwspin_unlock(struct hwspinlock *, int, unsigned long *);
>>> * code path get compiled away. This way, if CONFIG_HWSPINLOCK is not
>>> * required on a given setup, users will still work.
>>> *
>>> - * The only exception is hwspin_lock_register/hwspin_lock_unregister, with which
>>> - * we _do_ want users to fail (no point in registering hwspinlock instances if
>>> - * the framework is not available).
>>> + * The only exception is hwspin_lock_register/hwspin_lock_unregister and
>>> + * associated OF helpers, with which we _do_ want users to fail (no point
>>> + * in registering hwspinlock instances if the framework is not available).
>>> *
>>> * Note: ERR_PTR(-ENODEV) will still be considered a success for NULL-checking
>>> * users. Others, which care, can still check this with IS_ERR.
>>> -- 
>>> 1.8.3.3
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

