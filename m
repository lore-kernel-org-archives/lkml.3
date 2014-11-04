Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaKDQ31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:29:27 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:54460 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbaKDQ3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:29:25 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/1] of: Add a function to read 64-bit arrays
To: Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
In-Reply-To: <1412287163-10222-1-git-send-email-sakari.ailus@iki.fi>
References: <1412287163-10222-1-git-send-email-sakari.ailus@iki.fi>
Date: Tue, 04 Nov 2014 16:29:16 +0000
Message-Id: <20141104162916.25A6DC423D0@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Oct 2014 00:59:23 +0300
, Sakari Ailus <sakari.ailus@iki.fi>
 wrote:
> Implement of_property_read_u64_array() for reading 64-bit arrays.
> 
> This is needed for e.g. reading the valid link frequencies in the smiapp
> driver.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

A patch that adds this function is alread part of the device properties
API patch series that will be merged for v3.19.

g.

> ---
> Hi,
> 
> While the smiapp (found in drivers/media/i2c/smiapp/) OF support which needs
> this isn't in yet, other drivers such as mt9v032 which would be reading the
> valid link frequency control values will need reading arrays. This might
> make it to v4l2-of.c in the end.
> 
>  drivers/of/base.c  |   44 ++++++++++++++++++++++++++++++++++++--------
>  include/linux/of.h |    3 +++
>  2 files changed, 39 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index d8574ad..35e24f4 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1214,6 +1214,41 @@ int of_property_read_u32_array(const struct device_node *np,
>  EXPORT_SYMBOL_GPL(of_property_read_u32_array);
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
> + * The out_values is modified only if a valid u32 value can be decoded.
> + */
> +int of_property_read_u64_array(const struct device_node *np,
> +			       const char *propname, u64 *out_value, size_t sz)
> +{
> +	const __be32 *val = of_find_property_value_of_size(
> +		np, propname, sz * sizeof(*out_value));
> +
> +	if (IS_ERR(val))
> +		return PTR_ERR(val);
> +
> +	while (sz--) {
> +		*out_value = of_read_number(val, 2);
> +		out_value++;
> +		val += 2;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_property_read_u64_array);
> +
> +/**
>   * of_property_read_u64 - Find and read a 64 bit integer from a property
>   * @np:		device node from which the property value is to be read.
>   * @propname:	name of the property to be searched.
> @@ -1229,14 +1264,7 @@ EXPORT_SYMBOL_GPL(of_property_read_u32_array);
>  int of_property_read_u64(const struct device_node *np, const char *propname,
>  			 u64 *out_value)
>  {
> -	const __be32 *val = of_find_property_value_of_size(np, propname,
> -						sizeof(*out_value));
> -
> -	if (IS_ERR(val))
> -		return PTR_ERR(val);
> -
> -	*out_value = of_read_number(val, 2);
> -	return 0;
> +	return of_property_read_u64_array(np, propname, out_value, 1);
>  }
>  EXPORT_SYMBOL_GPL(of_property_read_u64);
>  
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 6c4363b..e84533f 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -263,6 +263,9 @@ extern int of_property_read_u32_array(const struct device_node *np,
>  				      size_t sz);
>  extern int of_property_read_u64(const struct device_node *np,
>  				const char *propname, u64 *out_value);
> +extern int of_property_read_u64_array(const struct device_node *np,
> +				      const char *propname, u64 *out_value,
> +				      size_t sz);
>  
>  extern int of_property_read_string(struct device_node *np,
>  				   const char *propname,
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

