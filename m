Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3JCEFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:05:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47455 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab3JCEFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:05:10 -0400
Message-ID: <524CECBF.2070805@ti.com>
Date: Wed, 2 Oct 2013 23:04:15 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Kumar Gala <galak@codeaurora.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>, Paul Walmsley <paul@pwsan.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2 1/9] hwspinlock/core: add common dt bindings and OF
 helpers
References: <cover.1379445653.git.s-anna@ti.com> <4df03ac30dcc79132e3acc2e586d0ca99b431258.1379445653.git.s-anna@ti.com> <14DB8294-1148-446A-A6D3-34E66BA8732C@codeaurora.org> <20131001083602.GG22259@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131001083602.GG22259@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 10/01/2013 03:36 AM, Mark Rutland wrote:
> Hi Suman,
> 
> Apologies for replying to a subthread, due to an earlier mistake on my
> part I don't have the original to hand.

No issues, thanks for your review.

> 
> On Fri, Sep 27, 2013 at 05:04:22PM +0100, Kumar Gala wrote:
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
> 
> I don't like this, as it seems to be encoding a Linux implementation
> detail (the ID of the lock, which means that we have to have a numeric
> representation of each hwlock) in the device tree.
> 
> I don't see why the ID within Linux should be a concern of the device
> tree binding. I think that whatever internal identifier we have in Linux
> (be it an integer or struct) should be allocated by Linux. If a driver
> needs to request specific hwlocks, then we should have a phandle + args
> representation for referring to a specific hwlock that bidnings can use,
> and some code for parsing that and returning a Linux-internal
> identifier/struct as we do with interrupts and clocks.

This is based on gathering the information required by the platform
implementation drivers for registering with the driver core. The driver
core currently maintains all the locks from different instances as a
radix tree, as it is simpler to manage when granting locks to users.
The current version is based on allowing the platform implementation
drivers to retrieve the required data for registering with the
hwspinlock driver core.

The users would either get a lock dynamically by requesting any free one
(and extract the id thereafter to share with others), or a specific one
which is currently by id. I agree that the phandle + args approach is
best suited for requesting a specific one through DT, but I would think
that the args would still have to be a relative lock number from 0 w.r.t
a phandle. I will look into the feasibility of such an approach
retaining the radix tree implementation, as this requires new OF
friendly registration and request functions.

> 
>>> +
>>> +- hwlock-num-locks:	Number of locks present in a hwlock device. This
>>> +			property is needed on hwlock devices, where the number
>>> +			of supported locks within a hwlock device cannot be
>>> +			read from a register.
> 
> Hmm... this seems generic, but it doesn't allow for sparse ID spaces on
> the hwlock module. It should probably be common for the moment, but if
> we encounter a hwlock module with a sparse ID space, we'll need to come
> up with a way of handling sparse IDs (that might be device-specific).

Agreed.

> 
>>> diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
>>> index 461a0d7..aec32e7 100644
>>> --- a/drivers/hwspinlock/hwspinlock_core.c
>>> +++ b/drivers/hwspinlock/hwspinlock_core.c
>>> @@ -1,7 +1,7 @@
>>> /*
>>>  * Hardware spinlock framework
>>>  *
>>> - * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com
>>> + * Copyright (C) 2010-2013 Texas Instruments Incorporated - http://www.ti.com
>>>  *
>>>  * Contact: Ohad Ben-Cohen <ohad@wizery.com>
>>>  *
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
>>
>>> +
>>> +	ret = of_property_read_u32(dn, "hwlock-base-id", &val);
>>> +	if (!ret)
>>> +		ret = val;
>>> +#endif
> 
> Do we need the CONFIG_OF check? of_property_read_u32 is defined to
> return -ENOSYS if CONFIG_OF isn't defined. Or would that confuse a
> higher layer?

These are primarily OF helpers and provided for the SoC implementation
drivers, and I have used the CONFIG_OF check within the function to
streamline the function prototypes and behavior in the common
hwspinlock.h header file between combinations of CONFIG_HWSPINLOCK and
CONFIG_OF.

The check for !dn is done deliberately to help the implementation drivers.

regards
Suman
