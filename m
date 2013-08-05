Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3HEM7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 08:59:09 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:61525 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3HEM7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 08:59:07 -0400
Message-ID: <51FFA195.6080903@gmail.com>
Date: Mon, 05 Aug 2013 07:59:01 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org, grant.likely@linaro.org
Subject: Re: [PATCH 1/2] OF: Add helper for matching against linux,stdout-path
References: <1375706445-15375-1-git-send-email-s.hauer@pengutronix.de> <1375706445-15375-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1375706445-15375-2-git-send-email-s.hauer@pengutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 07:40 AM, Sascha Hauer wrote:
> devicetrees may have a linux,stdout-path property in the chosen
> node describing the console device. This adds a helper function
> to match a device against this property so a driver can call
> add_preferred_console for a matching device.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: Rob Herring <rob.herring@calxeda.com>

There are no existing users that could take advantage of this?

Rob

> ---
>  drivers/of/base.c  | 26 ++++++++++++++++++++++++++
>  include/linux/of.h |  7 +++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 5c54279..1c3c79c 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -32,6 +32,7 @@ struct device_node *of_allnodes;
>  EXPORT_SYMBOL(of_allnodes);
>  struct device_node *of_chosen;
>  struct device_node *of_aliases;
> +static struct device_node *of_stdout;
>  
>  DEFINE_MUTEX(of_aliases_mutex);
>  
> @@ -1595,6 +1596,15 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>  	of_chosen = of_find_node_by_path("/chosen");
>  	if (of_chosen == NULL)
>  		of_chosen = of_find_node_by_path("/chosen@0");
> +
> +	if (of_chosen) {
> +		const char *name;
> +
> +		name = of_get_property(of_chosen, "linux,stdout-path", NULL);
> +		if (name)
> +			of_stdout = of_find_node_by_path(name);
> +	}
> +
>  	of_aliases = of_find_node_by_path("/aliases");
>  	if (!of_aliases)
>  		return;
> @@ -1703,3 +1713,19 @@ const char *of_prop_next_string(struct property *prop, const char *cur)
>  	return curv;
>  }
>  EXPORT_SYMBOL_GPL(of_prop_next_string);
> +
> +/**
> + * of_device_is_stdout_path - check if a device node matches the
> + *                            linux,stdout-path property
> + *
> + * Check if this device node matches the linux,stdout-path property
> + * in the chosen node. return true if yes, false otherwise.
> + */
> +int of_device_is_stdout_path(struct device_node *dn)
> +{
> +	if (!of_stdout)
> +		return false;
> +
> +	return of_stdout == dn;
> +}
> +EXPORT_SYMBOL_GPL(of_device_is_stdout_path);
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 1fd08ca..429e168 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -343,6 +343,8 @@ const char *of_prop_next_string(struct property *prop, const char *cur);
>  		s;						\
>  		s = of_prop_next_string(prop, s))
>  
> +int of_device_is_stdout_path(struct device_node *dn);
> +
>  #else /* CONFIG_OF */
>  
>  static inline const char* of_node_full_name(struct device_node *np)
> @@ -505,6 +507,11 @@ static inline int of_machine_is_compatible(const char *compat)
>  	return 0;
>  }
>  
> +static inline int of_device_is_stdout_path(struct device_node *dn)
> +{
> +	return 0;
> +}
> +
>  #define of_match_ptr(_ptr)	NULL
>  #define of_match_node(_matches, _node)	NULL
>  #define of_property_for_each_u32(np, propname, prop, p, u) \
> 

