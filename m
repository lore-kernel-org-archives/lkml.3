Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaHQNxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 09:53:38 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49936 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaHQNxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 09:53:02 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH 4/9] of: Add property_ops callback for devices with
 of_node
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Max Eliaser <max.eliaser@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1408255459-17625-5-git-send-email-mika.westerberg@linux.intel.com>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
	<1408255459-17625-5-git-send-email-mika.westerberg@linux.intel.com>
Date: Sun, 17 Aug 2014 13:54:16 +0100
Message-Id: <20140817125416.348C0C41368@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2014 09:04:14 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> From: Aaron Lu <aaron.lu@intel.com>
> 
> With the unified device properties interface in place, add device tree support.
> By adding the dev_prop_ops for of_node devices, drivers can access properties
> from ACPI or Device Tree in a generic way.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Reviewed-by: Darren Hart <dvhart@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Hi Mika,

As commented on patch 3, the new API currently throws away type
information so the compiler won't warn on an error. That needs to be
fixed and this patch reworked accordingly.

g.

---
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
> +{
> +	const __be32 *val = of_find_property_value_of_size(np, propname,
> +						(sz * sizeof(*out_values)));
> +
> +	if (IS_ERR(val))
> +		return PTR_ERR(val);
> +
> +	while (sz--) {
> +		*out_values++ = of_read_number(val, 2);
> +		val += 2;
> +	};
> +	return 0;
> +}

Considering we don't even have a user of u64 arrays in all of the DT
drivers, do we even need this type hook in the generic API?

> +
> +/**
>   * of_property_read_string - Find and read a string from a property
>   * @np:		device node from which the property value is to be read.
>   * @propname:	name of the property to be searched.
> @@ -1490,6 +1523,47 @@ int of_property_count_strings(struct device_node *np, const char *propname)
>  }
>  EXPORT_SYMBOL_GPL(of_property_count_strings);
>  
> +/**
> + * of_property_read_string_array - Find and read an array of strings
> + * from a multiple strings property.
> + * @np:		device node from which the property value is to be read.
> + * @propname:	name of the property to be searched.
> + * @out_string:	pointer to null terminated return string, modified only if
> + *		return value is 0.
> + * @sz:		number of array elements to read
> + *
> + * Search for a property in a device tree node and retrieve a list of
> + * terminated string value (pointer to data, not a copy) in that property.
> + * Returns 0 on success, -EINVAL if the property does not exist, -ENODATA if
> + * property does not have a value, and -EILSEQ if the string is not
> + * null-terminated within the length of the property data.
> + *
> + * The out_string pointer is modified only if a valid string can be decoded.
> + */
> +int of_property_read_string_array(struct device_node *np, const char *propname,
> +				  char **output, size_t sz)
> +{
> +	struct property *prop = of_find_property(np, propname, NULL);
> +	int i = 0;
> +	size_t l = 0, total = 0;
> +	char *p;
> +
> +	if (!prop)
> +		return -EINVAL;
> +	if (!prop->value)
> +		return -ENODATA;
> +	if (strnlen(prop->value, prop->length) >= prop->length)
> +		return -EILSEQ;
> +
> +	p = prop->value;
> +
> +	for (i = 0; total < prop->length; total += l, p += l) {
> +		output[i++] = p;
> +		l = strlen(p) + 1;
> +	}
> +	return 0;
> +}
> +
>  void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
>  {
>  	int i;
> @@ -2376,3 +2450,121 @@ struct device_node *of_graph_get_remote_port(const struct device_node *node)
>  	return of_get_next_parent(np);
>  }
>  EXPORT_SYMBOL(of_graph_get_remote_port);
> +
> +static int of_dev_prop_get(struct device *dev, const char *propname,
> +			   void **valptr)
> +{
> +	struct property *pp = of_find_property(dev->of_node, propname, NULL);
> +
> +	if (!pp)
> +		return -ENODATA;
> +
> +	if (valptr)
> +		*valptr = pp->value;
> +	return 0;
> +}
> +
> +static int of_dev_prop_read(struct device *dev, const char *propname,
> +			    enum dev_prop_type proptype, void *val)
> +{
> +	void *value;
> +	int ret = of_dev_prop_get(dev, propname, &value);
> +
> +	if (ret)
> +		return ret;
> +
> +	if (proptype >= DEV_PROP_U8 && proptype <= DEV_PROP_U64) {
> +		switch (proptype) {
> +		case DEV_PROP_U8:
> +			*(u8 *)val = *(u8 *)value;
> +			break;
> +		case DEV_PROP_U16:
> +			*(u16 *)val = *(u16 *)value;
> +			break;
> +		case DEV_PROP_U32:
> +			*(u32 *)val = *(u32 *)value;
> +			break;
> +		default:
> +			*(u64 *)val = *(u64 *)value;
> +			break;
> +		}
> +	} else if (proptype == DEV_PROP_STRING) {
> +		*(char **)val = value;
> +	}
> +	return ret;
> +
> +}
> +
> +static int of_dev_prop_read_array(struct device *dev, const char *propname,
> +				  enum dev_prop_type proptype, void *val,
> +				  size_t nval)
> +{
> +	int ret, elem_size;
> +
> +	if (!val) {
> +		switch (proptype) {
> +		case DEV_PROP_U8:
> +			elem_size = sizeof(u8);
> +			break;
> +		case DEV_PROP_U16:
> +			elem_size = sizeof(u16);
> +			break;
> +		case DEV_PROP_U32:
> +			elem_size = sizeof(u32);
> +			break;
> +		case DEV_PROP_U64:
> +			elem_size = sizeof(u64);
> +			break;
> +		case DEV_PROP_STRING:
> +			return of_property_count_strings(dev->of_node,
> +							 propname);
> +		default:
> +			return -EINVAL;
> +		}
> +		return of_property_count_elems_of_size(dev->of_node, propname,
> +						       elem_size);
> +	}
> +
> +	switch (proptype) {
> +	case DEV_PROP_U8:
> +		ret = of_property_read_u8_array(dev->of_node, propname,
> +						(u8 *)val, nval);
> +		break;
> +	case DEV_PROP_U16:
> +		ret = of_property_read_u16_array(dev->of_node, propname,
> +						 (u16 *)val, nval);
> +		break;
> +	case DEV_PROP_U32:
> +		ret = of_property_read_u32_array(dev->of_node, propname,
> +						 (u32 *)val, nval);
> +		break;
> +	case DEV_PROP_U64:
> +		ret = of_property_read_u64_array(dev->of_node, propname,
> +						 (u64 *)val, nval);
> +		break;
> +	case DEV_PROP_STRING:
> +		ret = of_property_read_string_array(dev->of_node, propname,
> +						    (char **)val, nval);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static int of_dev_get_child_count(struct device *dev)
> +{
> +	struct device_node *node = dev->of_node;
> +
> +	if (!node)
> +		return -EINVAL;
> +	return of_get_child_count(node);
> +}
> +
> +struct dev_prop_ops of_property_ops = {
> +	.get = of_dev_prop_get,
> +	.read = of_dev_prop_read,
> +	.read_array = of_dev_prop_read_array,
> +	.child_count = of_dev_get_child_count,
> +};
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 500436f9be7f..3113d3704eff 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -14,7 +14,7 @@
>  #include <linux/errno.h>
>  #include <linux/module.h>
>  #include <linux/amba/bus.h>
> -#include <linux/device.h>
> +#include <linux/property.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
>  #include <linux/of_address.h>
> @@ -138,6 +138,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  	}
>  
>  	dev->dev.of_node = of_node_get(np);
> +	dev->dev.property_ops = &of_property_ops;
>  	dev->dev.parent = parent;
>  
>  	if (bus_id)
> @@ -293,6 +294,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
>  	/* setup generic device info */
>  	dev->dev.coherent_dma_mask = ~0;
>  	dev->dev.of_node = of_node_get(node);
> +	dev->dev.property_ops = &of_property_ops;
>  	dev->dev.parent = parent;
>  	dev->dev.platform_data = platform_data;
>  	if (bus_id)
> diff --git a/include/linux/property.h b/include/linux/property.h
> index 52ea7fe7fe09..a840c1784c82 100644
> --- a/include/linux/property.h
> +++ b/include/linux/property.h
> @@ -38,6 +38,10 @@ struct dev_prop_ops {
>  extern struct dev_prop_ops acpi_property_ops;
>  #endif
>  
> +#ifdef CONFIG_OF
> +extern struct dev_prop_ops of_property_ops;
> +#endif
> +
>  int device_property_get(struct device *dev, const char *propname,
>  			void **valptr);
>  int device_property_read(struct device *dev, const char *propname,
> -- 
> 2.1.0.rc1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

