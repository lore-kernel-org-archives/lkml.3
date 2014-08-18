Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaHRJ3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:29:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:53404 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaHRJ3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:29:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,885,1400050800"; 
   d="scan'208";a="469802248"
Date: Mon, 18 Aug 2014 12:29:37 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/9] of: Add property_ops callback for devices with
 of_node
Message-ID: <20140818092937.GT2462@lahna.fi.intel.com>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408255459-17625-5-git-send-email-mika.westerberg@linux.intel.com>
 <20140817125416.348C0C41368@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817125416.348C0C41368@trevor.secretlab.ca>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 01:54:16PM +0100, Grant Likely wrote:
> On Sun, 17 Aug 2014 09:04:14 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> > From: Aaron Lu <aaron.lu@intel.com>
> > 
> > With the unified device properties interface in place, add device tree support.
> > By adding the dev_prop_ops for of_node devices, drivers can access properties
> > from ACPI or Device Tree in a generic way.
> > 
> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > Reviewed-by: Darren Hart <dvhart@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Hi Mika,
> 
> As commented on patch 3, the new API currently throws away type
> information so the compiler won't warn on an error. That needs to be
> fixed and this patch reworked accordingly.

The compiler should warn when we add static inline property accessor
functions for each type.

> 
> g.
> 
> ---
> >  drivers/of/base.c        | 194 ++++++++++++++++++++++++++++++++++++++++++++++-
> >  drivers/of/platform.c    |   4 +-
> >  include/linux/property.h |   4 +
> >  3 files changed, 200 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index b9864806e9b8..527004d01423 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -20,7 +20,7 @@
> >  #include <linux/ctype.h>
> >  #include <linux/cpu.h>
> >  #include <linux/module.h>
> > -#include <linux/of.h>
> > +#include <linux/property.h>
> >  #include <linux/of_graph.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/slab.h>
> > @@ -1343,6 +1343,39 @@ int of_property_read_u64(const struct device_node *np, const char *propname,
> >  EXPORT_SYMBOL_GPL(of_property_read_u64);
> >  
> >  /**
> > + * of_property_read_u64_array - Find and read an array of 64 bit integers
> > + * from a property.
> > + *
> > + * @np:		device node from which the property value is to be read.
> > + * @propname:	name of the property to be searched.
> > + * @out_values:	pointer to return value, modified only if return value is 0.
> > + * @sz:		number of array elements to read
> > + *
> > + * Search for a property in a device node and read 64-bit value(s) from
> > + * it. Returns 0 on success, -EINVAL if the property does not exist,
> > + * -ENODATA if property does not have a value, and -EOVERFLOW if the
> > + * property data isn't large enough.
> > + *
> > + * The out_values is modified only if a valid u64 value can be decoded.
> > + */
> > +int of_property_read_u64_array(const struct device_node *np,
> > +			       const char *propname, u64 *out_values,
> > +			       size_t sz)
> > +{
> > +	const __be32 *val = of_find_property_value_of_size(np, propname,
> > +						(sz * sizeof(*out_values)));
> > +
> > +	if (IS_ERR(val))
> > +		return PTR_ERR(val);
> > +
> > +	while (sz--) {
> > +		*out_values++ = of_read_number(val, 2);
> > +		val += 2;
> > +	};
> > +	return 0;
> > +}
> 
> Considering we don't even have a user of u64 arrays in all of the DT
> drivers, do we even need this type hook in the generic API?

Indeed, I think we can remove it for now.
