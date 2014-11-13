Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934732AbaKMX3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:29:51 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48338 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934582AbaKMX3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:29:48 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v8 4/8] OF: platform: Add OF notifier handler
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1414528565-10907-5-git-send-email-pantelis.antoniou@konsulko.com>
References: <1414528565-10907-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1414528565-10907-5-git-send-email-pantelis.antoniou@konsulko.com>
Date: Thu, 13 Nov 2014 23:29:44 +0000
Message-Id: <20141113232944.1F136C40B52@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 22:36:01 +0200
, Pantelis Antoniou <pantelis.antoniou@konsulko.com>
 wrote:
> Add OF notifier handler needed for creating/destroying platform devices
> according to dynamic runtime changes in the DT live tree.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

Hi Pantelis,

Some comments below. Feel free to send me fixup patches instead of
respinning.

g.

> ---
>  drivers/base/platform.c     | 18 +++++++++--
>  drivers/of/platform.c       | 78 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_platform.h | 10 ++++++
>  3 files changed, 103 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index b2afc29..282bfec 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -1002,10 +1002,22 @@ int __init platform_bus_init(void)
>  
>  	error = device_register(&platform_bus);
>  	if (error)
> -		return error;
> -	error =  bus_register(&platform_bus_type);
> +		goto err_out;
> +
> +	error = bus_register(&platform_bus_type);
> +	if (error)
> +		goto err_unreg_dev;
> +
> +	error = of_platform_register_reconfig_notifier();
>  	if (error)
> -		device_unregister(&platform_bus);
> +		goto err_unreg_bus;

We really don't want to fail out here. If the notifier registration fails, it
doesn't make sense to cause the entire boot to fail.

Instead of refactoring the function, just add the call to
of_platform_register_reconfig_notifier(), and WARN_ON() failure without
bailing.

(Actually, you don't need to send me a fixup for this; I've gone ahead
and fixed it up in my tree)

> +
> +	return 0;
> +err_unreg_bus:
> +	bus_unregister(&platform_bus_type);
> +err_unreg_dev:
> +	device_unregister(&platform_bus);
> +err_out:
>  	return error;
>  }
>  
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 3b64d0b..aa8db92 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -546,4 +546,82 @@ void of_platform_depopulate(struct device *parent)
>  }
>  EXPORT_SYMBOL_GPL(of_platform_depopulate);
>  
> +#ifdef CONFIG_OF_DYNAMIC
> +
> +static struct notifier_block platform_of_notifier;
> +
> +static int of_platform_notify(struct notifier_block *nb,
> +				unsigned long action, void *arg)
> +{
> +	struct platform_device *pdev_parent, *pdev;
> +	struct device_node *dn;
> +	int state;
> +	bool children_left;
> +
> +	state = of_reconfig_get_state_change(action, arg);
> +
> +	/* no change? */
> +	if (state == -1)
> +		return NOTIFY_OK;
> +
> +	switch (action) {
> +	case OF_RECONFIG_ATTACH_NODE:
> +	case OF_RECONFIG_DETACH_NODE:
> +		dn = arg;
> +		break;
> +	case OF_RECONFIG_ADD_PROPERTY:
> +	case OF_RECONFIG_REMOVE_PROPERTY:
> +	case OF_RECONFIG_UPDATE_PROPERTY:
> +		dn = ((struct of_prop_reconfig *)arg)->dn;
> +		break;
> +	default:
> +		return NOTIFY_OK;
> +	}
> +
> +	if (state) {
> +
> +		/* verify that the parent is a bus */
> +		if (!of_match_node(of_default_bus_match_table, dn->parent))
> +			return NOTIFY_OK;	/* not for us */

This doesn't work reliably. Not all callers of of_platform_populate use
the of_default_bus_match_table. The code needs to actively track the
nodes that were used to create child devices. We've got a flag in the
device node now that you can use for that; OF_POPULATED_BUS.

> +
> +		/* pdev_parent may be NULL when no bus platform device */
> +		pdev_parent = of_find_device_by_node(dn->parent);
> +		pdev = of_platform_device_create(dn, NULL,
> +				pdev_parent ? &pdev_parent->dev : NULL);
> +		of_dev_put(pdev_parent);
> +
> +		if (pdev == NULL) {
> +			pr_err("%s: failed to create for '%s'\n",
> +					__func__, dn->full_name);
> +			/* of_platform_device_create tosses the error code */
> +			return notifier_from_errno(-EINVAL);
> +		}
> +
> +	} else {
> +
> +		/* find our device by node */
> +		pdev = of_find_device_by_node(dn);
> +		if (pdev == NULL)
> +			return NOTIFY_OK;	/* no? not meant for us */
> +
> +		/* unregister takes one ref away */
> +		of_platform_device_destroy(&pdev->dev, &children_left);
> +
> +		/* and put the reference of the find */
> +		of_dev_put(pdev);
> +
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +int of_platform_register_reconfig_notifier(void)
> +{
> +	platform_of_notifier.notifier_call = of_platform_notify;
> +	return of_reconfig_notifier_register(&platform_of_notifier);
> +}
> +EXPORT_SYMBOL_GPL(of_platform_register_reconfig_notifier);
> +
> +#endif
> +
>  #endif /* CONFIG_OF_ADDRESS */
> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
> index c2b0627..01fe5d6 100644
> --- a/include/linux/of_platform.h
> +++ b/include/linux/of_platform.h
> @@ -84,4 +84,14 @@ static inline int of_platform_populate(struct device_node *root,
>  static inline void of_platform_depopulate(struct device *parent) { }
>  #endif
>  
> +#ifdef CONFIG_OF_DYNAMIC
> +extern int of_platform_register_reconfig_notifier(void);
> +#else
> +static inline int of_platform_register_reconfig_notifier(void)
> +{
> +	return 0;
> +}
> +#endif
> +
> +
>  #endif	/* _LINUX_OF_PLATFORM_H */
> -- 
> 1.7.12
> 

