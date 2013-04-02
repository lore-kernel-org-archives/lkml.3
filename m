Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3DBXmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:42:10 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:41949 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3DBXmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:42:08 -0400
Message-ID: <515B6CCD.9060703@gmail.com>
Date: Tue, 02 Apr 2013 18:42:05 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: linus.walleij@linaro.org, vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        swarren@wwwdotorg.org
Subject: Re: [PATCHv4 1/6] of: Add support for reading a u32 from a multi-value
 property.
References: <1364877661-26086-1-git-send-email-linux@prisktech.co.nz> <1364877661-26086-2-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1364877661-26086-2-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 11:40 PM, Tony Prisk wrote:
> This patch adds an of_property_read_u32_index() function to allow
> reading a single indexed u32 value from a property containing multiple
> u32 values.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/of/base.c  |   33 +++++++++++++++++++++++++++++++++
>  include/linux/of.h |    9 +++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 321d3ef..f6c89ed 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -746,6 +746,39 @@ struct device_node *of_find_node_by_phandle(phandle handle)
>  EXPORT_SYMBOL(of_find_node_by_phandle);
>  
>  /**
> + * of_property_read_u32_index - Find and read a u32 from a multi-value property.
> + *
> + * @np:		device node from which the property value is to be read.
> + * @propname:	name of the property to be searched.
> + * @index:	index of the u32 in the list of values
> + * @out_value:	pointer to return value, modified only if no error.
> + *
> + * Search for a property in a device node and read nth 32-bit value from
> + * it. Returns 0 on success, -EINVAL if the property does not exist,
> + * -ENODATA if property does not have a value, and -EOVERFLOW if the
> + * property data isn't large enough.
> + *
> + * The out_value is modified only if a valid u32 value can be decoded.
> + */
> +int of_property_read_u32_index(const struct device_node *np,
> +				       const char *propname,
> +				       u32 index, u32 *out_value)
> +{
> +	struct property *prop = of_find_property(np, propname, NULL);
> +
> +	if (!prop)
> +		return -EINVAL;
> +	if (!prop->value)
> +		return -ENODATA;
> +	if (((index + 1) * sizeof(*out_value)) > prop->length)
> +		return -EOVERFLOW;

Yet another copy of almost the same code...

Can you re-factor things to do something like this:

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 321d3ef..482d29c 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -745,6 +745,21 @@ struct device_node *of_find_node_by_phandle(phandle handle)
 }
 EXPORT_SYMBOL(of_find_node_by_phandle);
 
+static void *of_find_property_value_of_size(const struct device_node *np,
+			const char *propname, u32 len)
+{
+	struct property *prop = of_find_property(np, propname, NULL);
+
+	if (!prop)
+		return -EINVAL;
+	if (!prop->value)
+		return -ENODATA;
+	if (len > prop->length)
+		return -EOVERFLOW;
+
+	return prop->value;
+}
+
 /**
  * of_property_read_u8_array - Find and read an array of u8 from a property.
  *
@@ -766,17 +781,11 @@ EXPORT_SYMBOL(of_find_node_by_phandle);
 int of_property_read_u8_array(const struct device_node *np,
 			const char *propname, u8 *out_values, size_t sz)
 {
-	struct property *prop = of_find_property(np, propname, NULL);
-	const u8 *val;
+	const u8 *val = of_find_property_value_of_size(np, propname, sz * sizeof(*out_values));
 
-	if (!prop)
-		return -EINVAL;
-	if (!prop->value)
-		return -ENODATA;
-	if ((sz * sizeof(*out_values)) > prop->length)
-		return -EOVERFLOW;
+	if (IS_ERR(val))
+		return PTR_ERR(val);
 
-	val = prop->value;
 	while (sz--)
 		*out_values++ = *val++;
 	return 0;


> +	*out_value = be32_to_cpup(((__be32 *)prop->value) + index);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_property_read_u32_index);
> +
> +/**
>   * of_property_read_u8_array - Find and read an array of u8 from a property.
>   *
>   * @np:		device node from which the property value is to be read.
> diff --git a/include/linux/of.h b/include/linux/of.h
> index a0f1292..c0747a4 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -235,6 +235,9 @@ extern struct device_node *of_find_node_with_property(
>  extern struct property *of_find_property(const struct device_node *np,
>  					 const char *name,
>  					 int *lenp);
> +extern int of_property_read_u32_index(const struct device_node *np,
> +				       const char *propname,
> +				       u32 index, u32 *out_value);
>  extern int of_property_read_u8_array(const struct device_node *np,
>  			const char *propname, u8 *out_values, size_t sz);
>  extern int of_property_read_u16_array(const struct device_node *np,
> @@ -394,6 +397,12 @@ static inline struct device_node *of_find_compatible_node(
>  	return NULL;
>  }
>  
> +static inline int of_property_read_u32_index(const struct device_node *np,
> +			const char *propname, u32 index, u32 *out_value)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline int of_property_read_u8_array(const struct device_node *np,
>  			const char *propname, u8 *out_values, size_t sz)
>  {
> 

