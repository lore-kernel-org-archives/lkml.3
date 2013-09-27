Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3I0T0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:26:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60733 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab3I0T0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:26:45 -0400
Message-ID: <5245DBC8.4050304@ti.com>
Date: Fri, 27 Sep 2013 14:26:00 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>, Paul Walmsley <paul@pwsan.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2 1/9] hwspinlock/core: add common dt bindings and OF
 helpers
References: <cover.1379445653.git.s-anna@ti.com> <4df03ac30dcc79132e3acc2e586d0ca99b431258.1379445653.git.s-anna@ti.com> <14DB8294-1148-446A-A6D3-34E66BA8732C@codeaurora.org> <5245B6F9.7030505@ti.com> <3C582FCF-7A24-48AC-B98B-AF1D18C1E22B@codeaurora.org>
In-Reply-To: <3C582FCF-7A24-48AC-B98B-AF1D18C1E22B@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar,

>>
>> On 09/27/2013 11:04 AM, Kumar Gala wrote:
>>>
>>> On Sep 17, 2013, at 2:30 PM, Suman Anna wrote:
>>>
>>>> All the platform-specific hwlock driver implementations need the
>>>> number of locks and the associated base id for registering the
>>>> locks present within a hwspinlock device with the driver core.
>>>> These two variables are represented by 'hwlock-num-locks' and
>>>> 'hwlock-base-id' properties. The documentation and OF helpers to
>>>> retrieve these common properties have been added to the driver core.
>>>>
>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>> ---
>>>> .../devicetree/bindings/hwlock/hwlock.txt          | 26 +++++++++
>>>> drivers/hwspinlock/hwspinlock_core.c               | 61 +++++++++++++++++++++-
>>>> include/linux/hwspinlock.h                         | 11 ++--
>>>> 3 files changed, 93 insertions(+), 5 deletions(-)
>>>> create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/hwlock/hwlock.txt b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>>>> new file mode 100644
>>>> index 0000000..789930e
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>>>> @@ -0,0 +1,26 @@
>>>> +Generic hwlock bindings
>>>> +=======================
>>>> +
>>>> +Generic bindings that are common to all the hwlock platform specific driver
>>>> +implementations, the retrieved values are used for registering the device
>>>> +specific parameters with the hwspinlock core.
>>>> +
>>>> +The validity and need of these common properties may vary from one driver
>>>> +implementation to another. Look through the individual hwlock driver
>>>> +binding documentations for identifying which are mandatory and which are
>>>> +optional for that specific driver.
>>>> +
>>>> +Common properties:
>>>> +- hwlock-base-id:	Base Id for the locks for a particular hwlock device.
>>>> +			This property is used for representing a set of locks
>>>> +			present in a hwlock device with a unique base id in
>>>> +			the driver core. This property is mandatory ONLY if a
>>>> +			SoC has several hwlock devices.
>>>> +
>>>> +			See documentation on struct hwspinlock_pdata in
>>>> +			linux/hwspinlock.h for more details.
>>>> +
>>>> +- hwlock-num-locks:	Number of locks present in a hwlock device. This
>>>> +			property is needed on hwlock devices, where the number
>>>> +			of supported locks within a hwlock device cannot be
>>>> +			read from a register.
> 
> Was meaning to say this before, another reason for hwlock-num-locks is to limit the # of locks available to the processors running linux vs what other processors in the SoC might be using.

Yes, I understand the usecase/scenario since we had a similar need on
our product. That said, I guess this should be left to the individual
driver implementation/integration/documentation since this can be
achieved in different ways and depends on how you partition the
resources on your system (static partition vs resource reservation at
linux init time). Mentioning that here begs the question if you are
gonna use the starting 'n' locks, ending 'n' locks or range of 'n' locks
beginning in the middle. It would also imply it has to work together
with the hwlock-base-id as well in the last case. I would prefer to keep
the documentation generic here.

> 
> 
>>>> diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
>>>> index 461a0d7..aec32e7 100644
>>>> --- a/drivers/hwspinlock/hwspinlock_core.c
>>>> +++ b/drivers/hwspinlock/hwspinlock_core.c
>>>> @@ -1,7 +1,7 @@
>>>> /*
>>>> * Hardware spinlock framework
>>>> *
>>>> - * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com
>>>> + * Copyright (C) 2010-2013 Texas Instruments Incorporated - http://www.ti.com
>>>> *
>>>> * Contact: Ohad Ben-Cohen <ohad@wizery.com>
>>>> *
>>>> @@ -27,6 +27,7 @@
>>>> #include <linux/hwspinlock.h>
>>>> #include <linux/pm_runtime.h>
>>>> #include <linux/mutex.h>
>>>> +#include <linux/of.h>
>>>>
>>>> #include "hwspinlock_internal.h"
>>>>
>>>> @@ -308,6 +309,64 @@ out:
>>>> }
>>>>
>>>> /**
>>>> + * of_hwspin_lock_get_base_id() - OF helper to retrieve base id
>>>> + * @dn: device node pointer
>>>> + *
>>>> + * This is an OF helper function that can be called by the underlying
>>>> + * platform-specific implementations, to retrieve the base id for the
>>>> + * set of locks present within a hwspinlock device instance.
>>>> + *
>>>> + * Returns the base id value on success, -ENODEV on generic failure or
>>>> + * an appropriate error code as returned by the OF layer
>>>> + */
>>>> +int of_hwspin_lock_get_base_id(struct device_node *dn)
>>>> +{
>>>> +	unsigned int val;
>>>> +	int ret = -ENODEV;
>>>> +
>>>> +#ifdef CONFIG_OF
>>>> +	if (!dn)
>>>> +		return -ENODEV;
>>>
>>> Checking !dn is done in of_property_read_u32, so you don't need to duplicate
>>
>> I have added this specifically since my intention is to differentiate
>> the validity of the node vs the presence of the property within a node.
>> This property may be optional for some platforms and a must for some
>> others, and differentiating would allow the individual driver
>> implementations to make the distinction.
> 
> Maybe add a comment for both cases.

OK, will do.

regards
Suman

