Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3BKL01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:26:27 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:29347 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755876Ab3BKL0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:26:25 -0500
Message-ID: <5118D557.5050606@gaisler.com>
Date: Mon, 11 Feb 2013 12:26:15 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: Create function for counting number of phandles in
 a property
References: <1360540701-23439-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1360540701-23439-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-11 00:58, Grant Likely wrote:
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 2390ddb..e1120a2 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1025,12 +1025,13 @@ EXPORT_SYMBOL(of_parse_phandle);
>    * To get a device_node of the `node2' node you may call this:
>    * of_parse_phandle_with_args(node3, "list", "#list-cells", 1, &args);
>    */
> -int of_parse_phandle_with_args(const struct device_node *np, const char *list_name,
> -				const char *cells_name, int index,
> -				struct of_phandle_args *out_args)
> +static int __of_parse_phandle_with_args(const struct device_node *np,
> +					const char *list_name,
> +					const char *cells_name, int index,
> +					struct of_phandle_args *out_args)
>   {
>   	const __be32 *list, *list_end;
> -	int size, cur_index = 0;
> +	int rc = 0, size, cur_index = 0;
>   	uint32_t count = 0;
>   	struct device_node *node = NULL;
>   	phandle phandle;
> @@ -1059,12 +1060,14 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
>   			if (!node) {
>   				pr_err("%s: could not find phandle\n",
>   					 np->full_name);
> +				rc = -EINVAL;
>   				break;
>   			}
>   			if (of_property_read_u32(node, cells_name, &count)) {
>   				pr_err("%s: could not get %s for %s\n",
>   					 np->full_name, cells_name,
>   					 node->full_name);
> +				rc = -EINVAL;
>   				break;
>   			}
>
> @@ -1075,6 +1078,7 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
>   			if (list + count > list_end) {
>   				pr_err("%s: arguments longer than property\n",
>   					 np->full_name);
> +				rc = -EINVAL;
>   				break;
>   			}
>   		}
> @@ -1086,8 +1090,10 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
>   		 * or return -ENOENT for an empty entry.
>   		 */
>   		if (cur_index == index) {
> -			if (!phandle)
> -				return -ENOENT;
> +			if (!phandle) {
> +				rc = -ENOENT;
> +				break;
> +			}
>
>   			if (out_args) {
>   				int i;
> @@ -1098,22 +1104,54 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
>   				for (i = 0; i < count; i++)
>   					out_args->args[i] = be32_to_cpup(list++);
>   			}
> -			return 0;
> +
> +			rc = 0;
> +			break;
>   		}
>
>   		of_node_put(node);
>   		node = NULL;
>   		list += count;
>   		cur_index++;
> +		rc = cur_index;
>   	}
>
>   	/* Loop exited without finding a valid entry; return an error */
>   	if (node)
>   		of_node_put(node);
> -	return -EINVAL;
> +	return rc;
> +}
> +
> +int of_parse_phandle_with_args(const struct device_node *np, const char *list_name,
> +				const char *cells_name, int index,
> +				struct of_phandle_args *out_args)
> +{
> +	return __of_parse_phandle_with_args(np, list_name, cells_name, index, out_args);
>   }
>   EXPORT_SYMBOL(of_parse_phandle_with_args);

Will this not result in a situation where a call to 
of_parse_phandle_with_args with an out of bounds index returns the 
number of tuples instead of an error code and possibly some caller that 
uses the this count as a phandle instead of handling an error?

Of course of_count_phandle_with_args can be used to make sure that no 
such call is made in the first place, but that is another story.

Related to this is that Case 7 in of_selftest_parse_phandle_with_args 
never gets exercised as far as I can see.


> diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
> index c454f57..bdbe0f3 100644
> --- a/include/linux/of_gpio.h
> +++ b/include/linux/of_gpio.h
> @@ -50,8 +50,28 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
>   extern int of_get_named_gpio_flags(struct device_node *np,
>   		const char *list_name, int index, enum of_gpio_flags *flags);
>
> -extern unsigned int of_gpio_named_count(struct device_node *np,
> -					const char* propname);
> +/**
> + * of_gpio_named_count - Count GPIOs for a device
> + * @np:		device node to count GPIOs for
> + * @propname:	property name containing gpio specifier(s)
> + *
> + * The function returns the count of GPIOs specified for a node.
> + *
> + * Note that the empty GPIO specifiers counts too. For example,
> + *
> + * gpios = <0
> + *          &pio1 1 2
> + *          0
> + *          &pio2 3 4>;
> + *
> + * defines four GPIOs (so this function will return 4), two of which
> + * are not specified. Returns -EINVAL for an incorrectly formed gpios
> + * property.
> + */
> +static int of_gpio_named_count(struct device_node *np, const char* propname)
> +{
> +	return of_count_phandle_with_args(np, propname, "#gpio-cells");
> +}

Should this be static inline int?

I think it would be good to also document that it also returns -ENOENT 
when the propname property is missing, which might be an important case 
to distinguish from the -EINVAL case.


Cheers,
Andreas Larsson

