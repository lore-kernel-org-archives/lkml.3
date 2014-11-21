Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbaKUPQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:16:57 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47558 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaKUPQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:16:55 -0500
Subject: Re: [PATCH v8 6/8] OF: i2c: Add OF notifier handler
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20141121150837.20DC4C40D85@trevor.secretlab.ca>
Date: Fri, 21 Nov 2014 17:11:15 +0200
Cc: Guenter Roeck <linux@roeck-us.net>, Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
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
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E28022BF-F72E-4BD9-9F95-4DB091EA7981@konsulko.com>
References: <1414528565-10907-1-git-send-email-pantelis.antoniou@konsulko.com> <1414528565-10907-7-git-send-email-pantelis.antoniou@konsulko.com> <20141121015335.99BF2C413E8@trevor.secretlab.ca> <546E9D75.3000208@roeck-us.net> <20141121150837.20DC4C40D85@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

> On Nov 21, 2014, at 17:08 , Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> On Thu, 20 Nov 2014 18:03:33 -0800
> , Guenter Roeck <linux@roeck-us.net>
> wrote:
>> On 11/20/2014 05:53 PM, Grant Likely wrote:
>>> On Tue, 28 Oct 2014 22:36:03 +0200
>>> , Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>>>  wrote:
>>>> Add OF notifier handler needed for creating/destroying i2c devices
>>>> according to dynamic runtime changes in the DT live tree.
>>>> 
>>>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>>>> ---
>>>>  drivers/i2c/i2c-core.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++-
>>>>  1 file changed, 78 insertions(+), 1 deletion(-)
>>>> 
>>>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>>>> index e6da9d3..e751b78 100644
>>>> --- a/drivers/i2c/i2c-core.c
>>>> +++ b/drivers/i2c/i2c-core.c
>>>> @@ -1470,6 +1470,7 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
>>>>  	return i2c_verify_adapter(dev);
>>>>  }
>>>>  EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
>>>> +
>>>>  #else
>>>>  static void of_i2c_register_devices(struct i2c_adapter *adap) { }
>>>>  #endif /* CONFIG_OF */
>>>> @@ -1955,6 +1956,71 @@ void i2c_clients_command(struct i2c_adapter *adap, unsigned int cmd, void *arg)
>>>>  }
>>>>  EXPORT_SYMBOL(i2c_clients_command);
>>>> 
>>>> +#if IS_ENABLED(CONFIG_OF)
>>>> +
>>>> +static int of_i2c_notify(struct notifier_block *nb,
>>>> +				unsigned long action, void *arg)
>>>> +{
>>>> +	struct device_node *dn;
>>>> +	struct i2c_adapter *adap;
>>>> +	struct i2c_client *client;
>>>> +	int state;
>>>> +
>>>> +	state = of_reconfig_get_state_change(action, arg);
>>>> +	if (state == -1)
>>>> +		return NOTIFY_OK;
>>>> +
>>>> +	switch (action) {
>>>> +	case OF_RECONFIG_ATTACH_NODE:
>>>> +	case OF_RECONFIG_DETACH_NODE:
>>>> +		dn = arg;
>>>> +		break;
>>>> +	case OF_RECONFIG_ADD_PROPERTY:
>>>> +	case OF_RECONFIG_REMOVE_PROPERTY:
>>>> +	case OF_RECONFIG_UPDATE_PROPERTY:
>>>> +		dn = ((struct of_prop_reconfig *)arg)->dn;
>>>> +		break;
>>>> +	default:
>>>> +		return NOTIFY_OK;
>>>> +	}
>>>> +
>>>> +	if (state) {
>>>> +
>>>> +		adap = of_find_i2c_adapter_by_node(dn->parent);
>>>> +		if (adap == NULL)
>>>> +			return NOTIFY_OK;	/* not for us */
>>>> +
>>>> +		client = of_i2c_register_device(adap, dn);
>>>> +		put_device(&adap->dev);
>>>> +
>>>> +		if (IS_ERR(client)) {
>>>> +			pr_err("%s: failed to create for '%s'\n",
>>>> +					__func__, dn->full_name);
>>>> +			return notifier_from_errno(PTR_ERR(client));
>>>> +		}
>>>> +
>>>> +	} else {
>>>> +
>>>> +		/* find our device by node */
>>>> +		client = of_find_i2c_device_by_node(dn);
>>>> +		if (client == NULL)
>>>> +			return NOTIFY_OK;	/* no? not meant for us */
>>>> +
>>>> +		/* unregister takes one ref away */
>>>> +		i2c_unregister_device(client);
>>>> +
>>>> +		/* and put the reference of the find */
>>>> +		put_device(&client->dev);
>>>> +
>>>> +	}
>>> 
>>> Nit: odd whitespace
>>> 
>>>> +
>>>> +	return NOTIFY_OK;
>>>> +}
>>>> +
>>>> +static struct notifier_block i2c_of_notifier;
>>>> +
>>>> +#endif
>>>> +
>>>>  static int __init i2c_init(void)
>>>>  {
>>>>  	int retval;
>>>> @@ -1972,8 +2038,19 @@ static int __init i2c_init(void)
>>>>  	retval = i2c_add_driver(&dummy_driver);
>>>>  	if (retval)
>>>>  		goto class_err;
>>>> -	return 0;
>>>> 
>>>> +#if IS_ENABLED(CONFIG_OF)
>>>> +	i2c_of_notifier.notifier_call = of_i2c_notify;
>> 
>> Wouldn't it be easier to just initialize i2c_of_notifier above instead of
>> here in the code ? Or is there a reason for doing it here ?
> 
> Yes, absolutely. This code should also depend on CONFIG_OF_DYNAMIC too,
> not merely CONFIG_OF.
> 
>> 

No reason; it just seemed like the most opportune place to put it at the time.

>> Thanks,
>> Guenter
>> 
>>>> +	retval = of_reconfig_notifier_register(&i2c_of_notifier);
>>>> +	if (retval)
>>>> +		goto notifier_err;
>>>> +#endif
> 
> We can also get rid of the ugly #ifdef in the body by creating empty
> stubs for of_reconfig_notify_{register,unregister}() and doing the
> following:
> 
> 	if (IS_ENABLED(CONFIG_OF_DYNAMIC))
> 		WARN_ON(of_reconfig_notifier_register(&i2c_of_notifier))
> 
> I picked up the patch into my tree and made the above changes because
> they're pretty trivial. If Wolfram is okay with it then I can take the
> whole series through my tree. Otherwise I'll put the of_reconfig_* empty
> stubs into a separate branch that he and broonie can both pull.
> 

I’m fine with doing this if you’d like, it’s pretty simple.

Regards

— Pantelis

> g.
> 
>>>> +
>>>> +	return 0;
>>>> +#if IS_ENABLED(CONFIG_OF)
>>>> +notifier_err:
>>>> +	i2c_del_driver(&dummy_driver);
>>>> +#endif
>>> 
>>> Similar to my comment on the platform bus, don't break the entire bus if
>>> registration of the notifier fails. I would drop the error case and just
>>> do a WARN_ON() if it fails.
>>> 
>>> Otherwise:
>>> 
>>> Acked-by: Grant Likely <grant.likely@linaro.org>
>>> 
>>>>  class_err:
>>>>  #ifdef CONFIG_I2C_COMPAT
>>>>  	class_compat_unregister(i2c_adapter_compat_class);
>>>> --
>>>> 1.7.12
>>>> 
>>> 
>>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

