Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaHRMfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:35:54 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:44862 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaHRMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:35:52 -0400
Message-ID: <53F14C80.1010308@gmail.com>
Date: Sun, 17 Aug 2014 19:44:48 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
CC: Aaron Lu <aaron.lu@intel.com>, Max Eliaser <max.eliaser@intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/9] of: Add property_ops callback for devices with
 of_node
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com> <1408255459-17625-5-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1408255459-17625-5-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2014 01:04 AM, Mika Westerberg wrote:
> From: Aaron Lu <aaron.lu@intel.com>
> 
> With the unified device properties interface in place, add device tree support.
> By adding the dev_prop_ops for of_node devices, drivers can access properties
> from ACPI or Device Tree in a generic way.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Reviewed-by: Darren Hart <dvhart@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/of/base.c        | 194 ++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/of/platform.c    |   4 +-
>  include/linux/property.h |   4 +
>  3 files changed, 200 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index b9864806e9b8..527004d01423 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -20,7 +20,7 @@
>  #include <linux/ctype.h>
>  #include <linux/cpu.h>
>  #include <linux/module.h>
> -#include <linux/of.h>
> +#include <linux/property.h>
>  #include <linux/of_graph.h>
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
> @@ -1343,6 +1343,39 @@ int of_property_read_u64(const struct device_node *np, const char *propname,
>  EXPORT_SYMBOL_GPL(of_property_read_u64);
>  
>  /**
> + * of_property_read_u64_array - Find and read an array of 64 bit integers
> + * from a property.
> + *
> + * @np:		device node from which the property value is to be read.
> + * @propname:	name of the property to be searched.
> + * @out_values:	pointer to return value, modified only if return value is 0.
> + * @sz:		number of array elements to read
> + *
> + * Search for a property in a device node and read 64-bit value(s) from
> + * it. Returns 0 on success, -EINVAL if the property does not exist,
> + * -ENODATA if property does not have a value, and -EOVERFLOW if the
> + * property data isn't large enough.
> + *
> + * The out_values is modified only if a valid u64 value can be decoded.
> + */
> +int of_property_read_u64_array(const struct device_node *np,
> +			       const char *propname, u64 *out_values,
> +			       size_t sz)

Quite frequently the array functions have turned out to be less useful
as you often don't know how many elements you have upfront. So you end
up parsing the property twice. Using for_each iterators has been a
better fit for most users, so I'd like to see them here. We may need
both, but read_*_array can be a wrapper around for_each.

Rob

