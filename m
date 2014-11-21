Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbaKUBxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:53:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46581 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbaKUBxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:53:44 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v8 6/8] OF: i2c: Add OF notifier handler
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
In-Reply-To: <1414528565-10907-7-git-send-email-pantelis.antoniou@konsulko.com>
References: <1414528565-10907-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1414528565-10907-7-git-send-email-pantelis.antoniou@konsulko.com>
Date: Fri, 21 Nov 2014 01:53:35 +0000
Message-Id: <20141121015335.99BF2C413E8@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 22:36:03 +0200
, Pantelis Antoniou <pantelis.antoniou@konsulko.com>
 wrote:
> Add OF notifier handler needed for creating/destroying i2c devices
> according to dynamic runtime changes in the DT live tree.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> ---
>  drivers/i2c/i2c-core.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 78 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index e6da9d3..e751b78 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -1470,6 +1470,7 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
>  	return i2c_verify_adapter(dev);
>  }
>  EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
> +
>  #else
>  static void of_i2c_register_devices(struct i2c_adapter *adap) { }
>  #endif /* CONFIG_OF */
> @@ -1955,6 +1956,71 @@ void i2c_clients_command(struct i2c_adapter *adap, unsigned int cmd, void *arg)
>  }
>  EXPORT_SYMBOL(i2c_clients_command);
>  
> +#if IS_ENABLED(CONFIG_OF)
> +
> +static int of_i2c_notify(struct notifier_block *nb,
> +				unsigned long action, void *arg)
> +{
> +	struct device_node *dn;
> +	struct i2c_adapter *adap;
> +	struct i2c_client *client;
> +	int state;
> +
> +	state = of_reconfig_get_state_change(action, arg);
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
> +		adap = of_find_i2c_adapter_by_node(dn->parent);
> +		if (adap == NULL)
> +			return NOTIFY_OK;	/* not for us */
> +
> +		client = of_i2c_register_device(adap, dn);
> +		put_device(&adap->dev);
> +
> +		if (IS_ERR(client)) {
> +			pr_err("%s: failed to create for '%s'\n",
> +					__func__, dn->full_name);
> +			return notifier_from_errno(PTR_ERR(client));
> +		}
> +
> +	} else {
> +
> +		/* find our device by node */
> +		client = of_find_i2c_device_by_node(dn);
> +		if (client == NULL)
> +			return NOTIFY_OK;	/* no? not meant for us */
> +
> +		/* unregister takes one ref away */
> +		i2c_unregister_device(client);
> +
> +		/* and put the reference of the find */
> +		put_device(&client->dev);
> +
> +	}

Nit: odd whitespace

> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block i2c_of_notifier;
> +
> +#endif
> +
>  static int __init i2c_init(void)
>  {
>  	int retval;
> @@ -1972,8 +2038,19 @@ static int __init i2c_init(void)
>  	retval = i2c_add_driver(&dummy_driver);
>  	if (retval)
>  		goto class_err;
> -	return 0;
>  
> +#if IS_ENABLED(CONFIG_OF)
> +	i2c_of_notifier.notifier_call = of_i2c_notify;
> +	retval = of_reconfig_notifier_register(&i2c_of_notifier);
> +	if (retval)
> +		goto notifier_err;
> +#endif
> +
> +	return 0;
> +#if IS_ENABLED(CONFIG_OF)
> +notifier_err:
> +	i2c_del_driver(&dummy_driver);
> +#endif

Similar to my comment on the platform bus, don't break the entire bus if
registration of the notifier fails. I would drop the error case and just
do a WARN_ON() if it fails.

Otherwise:

Acked-by: Grant Likely <grant.likely@linaro.org>

>  class_err:
>  #ifdef CONFIG_I2C_COMPAT
>  	class_compat_unregister(i2c_adapter_compat_class);
> -- 
> 1.7.12
> 

