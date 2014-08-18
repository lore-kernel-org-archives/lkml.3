Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaHRMo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:44:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:47569 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaHRMo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:44:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,885,1400050800"; 
   d="scan'208";a="589641404"
User-Agent: Microsoft-MacOutlook/14.4.3.140616
Date: Mon, 18 Aug 2014 07:44:45 -0500
Subject: Re: [RFC PATCH 4/9] of: Add property_ops callback for devices with
 of_node
From: Darren Hart <dvhart@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>, <linux-acpi@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <D0175E0D.A1C9E%dvhart@linux.intel.com>
Thread-Topic: [RFC PATCH 4/9] of: Add property_ops callback for devices with
 of_node
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408255459-17625-5-git-send-email-mika.westerberg@linux.intel.com>
 <20140817125416.348C0C41368@trevor.secretlab.ca>
 <20140818092937.GT2462@lahna.fi.intel.com>
In-Reply-To: <20140818092937.GT2462@lahna.fi.intel.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/14, 4:29, "Mika Westerberg" <mika.westerberg@linux.intel.com>
wrote:

>On Sun, Aug 17, 2014 at 01:54:16PM +0100, Grant Likely wrote:
>> On Sun, 17 Aug 2014 09:04:14 +0300, Mika Westerberg
>><mika.westerberg@linux.intel.com> wrote:
>> > From: Aaron Lu <aaron.lu@intel.com>
>> > 
>> > With the unified device properties interface in place, add device
>>tree support.
>> > By adding the dev_prop_ops for of_node devices, drivers can access
>>properties
>> > from ACPI or Device Tree in a generic way.
>> > 
>> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> > Reviewed-by: Darren Hart <dvhart@linux.intel.com>
>> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> 
>> Hi Mika,
>> 
>> As commented on patch 3, the new API currently throws away type
>> information so the compiler won't warn on an error. That needs to be
>> fixed and this patch reworked accordingly.
>
>The compiler should warn when we add static inline property accessor
>functions for each type.
>
>> 
>> g.
>> 
>> ---
>> >  drivers/of/base.c        | 194
>>++++++++++++++++++++++++++++++++++++++++++++++-
>> >  drivers/of/platform.c    |   4 +-
>> >  include/linux/property.h |   4 +
>> >  3 files changed, 200 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/drivers/of/base.c b/drivers/of/base.c
>> > index b9864806e9b8..527004d01423 100644
>> > --- a/drivers/of/base.c
>> > +++ b/drivers/of/base.c
>> > @@ -20,7 +20,7 @@
>> >  #include <linux/ctype.h>
>> >  #include <linux/cpu.h>
>> >  #include <linux/module.h>
>> > -#include <linux/of.h>
>> > +#include <linux/property.h>
>> >  #include <linux/of_graph.h>
>> >  #include <linux/spinlock.h>
>> >  #include <linux/slab.h>
>> > @@ -1343,6 +1343,39 @@ int of_property_read_u64(const struct
>>device_node *np, const char *propname,
>> >  EXPORT_SYMBOL_GPL(of_property_read_u64);
>> >  
>> >  /**
>> > + * of_property_read_u64_array - Find and read an array of 64 bit
>>integers
>> > + * from a property.
>> > + *
>> > + * @np:		device node from which the property value is to be read.
>> > + * @propname:	name of the property to be searched.
>> > + * @out_values:	pointer to return value, modified only if return
>>value is 0.
>> > + * @sz:		number of array elements to read
>> > + *
>> > + * Search for a property in a device node and read 64-bit value(s)
>>from
>> > + * it. Returns 0 on success, -EINVAL if the property does not exist,
>> > + * -ENODATA if property does not have a value, and -EOVERFLOW if the
>> > + * property data isn't large enough.
>> > + *
>> > + * The out_values is modified only if a valid u64 value can be
>>decoded.
>> > + */
>> > +int of_property_read_u64_array(const struct device_node *np,
>> > +			       const char *propname, u64 *out_values,
>> > +			       size_t sz)
>> > +{
>> > +	const __be32 *val = of_find_property_value_of_size(np, propname,
>> > +						(sz * sizeof(*out_values)));
>> > +
>> > +	if (IS_ERR(val))
>> > +		return PTR_ERR(val);
>> > +
>> > +	while (sz--) {
>> > +		*out_values++ = of_read_number(val, 2);
>> > +		val += 2;
>> > +	};
>> > +	return 0;
>> > +}
>> 
>> Considering we don't even have a user of u64 arrays in all of the DT
>> drivers, do we even need this type hook in the generic API?
>
>Indeed, I think we can remove it for now.
>

Keep in mind that existing DT drivers are not the only user of this
interface.

This series enables ACPI systems to make use of such drivers (or lays the
groundwork, each driver does need an update to the new API), but there are
also new drivers being developed today that are ACPI first. While the
DT-space may not need this interface now, I don't see the value in
preventing it from being used in the future by removing it from the
generic interface.

Adding it later, if needed, isn't as trivial as it sounds as we first have
to put developers through the pain of finding the interface doesn't exist
for a valid type, many of whom will decide to work around the limitation
rather than take the discussion to the infamous LKML - resulting in
suboptimal firmware descriptions.

I'd much rather see us enable them to help themselves and then get out of
their way by supporting all the valid types initially.

-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



