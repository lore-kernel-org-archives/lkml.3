Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3CKMsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 08:48:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63882 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3CKMsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:48:20 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 11 Mar 2013 05:48:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: dg77.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
        dianders@chromium.org, linux-kernel@vger.kernel.org,
        naveenkrishna.ch@gmail.com, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/2] hwmon: ntc: Add DT support to NTC
 thermistor driver
Message-ID: <20130311124819.GC30159@roeck-us.net>
References: <1362967787-22557-1-git-send-email-ch.naveen@samsung.com>
 <20130311122144.GA30159@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311122144.GA30159@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 05:21:44AM -0700, Guenter Roeck wrote:
> On Mon, Mar 11, 2013 at 07:39:46AM +0530, Naveen Krishna Chatradhi wrote:
> > This patch adds the DT support to NTC driver to parse the
> > platform data.
> > 
> > Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> > ---
> >  drivers/hwmon/ntc_thermistor.c |   93 ++++++++++++++++++++++++++++++++--------
> >  1 file changed, 75 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
> > index d92b237..cfedbd3 100644
> > --- a/drivers/hwmon/ntc_thermistor.c
> > +++ b/drivers/hwmon/ntc_thermistor.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/math64.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/err.h>
> > +#include <linux/of.h>
> >  
> >  #include <linux/platform_data/ntc_thermistor.h>
> >  
> > @@ -37,6 +38,41 @@ struct ntc_compensation {
> >  	unsigned int	ohm;
> >  };
> >  
> > +static const struct platform_device_id ntc_thermistor_id[] = {
> > +	{ "ncp15wb473", TYPE_NCPXXWB473 },
> > +	{ "ncp18wb473", TYPE_NCPXXWB473 },
> > +	{ "ncp21wb473", TYPE_NCPXXWB473 },
> > +	{ "ncp03wb473", TYPE_NCPXXWB473 },
> > +	{ "ncp15wl333", TYPE_NCPXXWL333 },
> > +	{ },
> > +};
> > +
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id ntc_match[] = {
> > +	{ .compatible = "ntc,ncp15wb473", .data = (void *)TYPE_NCPXXWB473 },
> > +	{ .compatible = "ntc,ncp18wb473", .data = (void *)TYPE_NCPXXWB473 },
> > +	{ .compatible = "ntc,ncp21wb473", .data = (void *)TYPE_NCPXXWB473 },
> > +	{ .compatible = "ntc,ncp03wb473", .data = (void *)TYPE_NCPXXWB473 },
> > +	{ .compatible = "ntc,ncp15wl333", .data = (void *)TYPE_NCPXXWL333 },
> 
> Better point to ntc_thermistor_id[TYPE_xxx]. See below.
> 
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, ntc_match);
> > +#endif
> > +
> > +/* Get NTC type either from device tree or platform data. */
> > +static enum ntc_thermistor_type thermistor_get_type
> > +				(struct platform_device *pdev)
> > +{
> > +	if (pdev->dev.of_node) {
> > +		const struct of_device_id *match;
> > +		match = of_match_node(of_match_ptr(ntc_match),
> > +						pdev->dev.of_node);
> > +		return (unsigned int)match->data;
> > +	}
> > +
> > +	return platform_get_device_id(pdev)->driver_data;
> > +}
> > +
> >  /*
> >   * A compensation table should be sorted by the values of .ohm
> >   * in descending order.
> > @@ -126,6 +162,27 @@ struct ntc_data {
> >  	char name[PLATFORM_NAME_SIZE];
> >  };
> >  
> > +#ifdef CONFIG_OF
> 
> Please merge the two CONFIG_OF blocks into one.
> 
> > +static void ntc_thermistor_parse_dt(struct ntc_thermistor_platform_data *pdata,
> > +							struct device_node *np)
> > +{
> > +	of_property_read_u32(np, "pullup-uV", &pdata->pullup_uV);
> > +	of_property_read_u32(np, "pullup-ohm", &pdata->pullup_ohm);
> > +	of_property_read_u32(np, "pulldown-ohm", &pdata->pulldown_ohm);
> > +	if (of_find_property(np, "connected-positive", NULL))
> > +		pdata->connect = NTC_CONNECTED_POSITIVE;
> > +	else /* status change should be possible if not always on. */
> > +		pdata->connect = NTC_CONNECTED_GROUND;
> > +}

Forgot to mention: You'll have to add a devicetree bindings file describing the
bindings.

> > +#else
> > +static void
> > +static void ntc_thermistor_parse_dt(struct ntc_thermistor_platform_data *pdata,
> > +							struct device_node *np)
> > +{
> > +	return;
> 
> Unnecessary return statement.
> 
> > +}
> > +#endif
> > +
> >  static inline u64 div64_u64_safe(u64 dividend, u64 divisor)
> >  {
> >  	if (divisor == 0 && dividend == 0)
> > @@ -313,9 +370,19 @@ static const struct attribute_group ntc_attr_group = {
> >  static int ntc_thermistor_probe(struct platform_device *pdev)
> >  {
> >  	struct ntc_data *data;
> > -	struct ntc_thermistor_platform_data *pdata = pdev->dev.platform_data;
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct ntc_thermistor_platform_data *pdata = NULL;
> 
> Unnecessary change. It doesn't hurt if pdata is initialized to non-NULL, and
> initializing it to NULL is unnecessary anyway since it is always assigned below.
> 
> >  	int ret = 0;
> >  
> > +	if (np) {
> > +		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> > +		if (!pdata)
> > +			return -ENOMEM;
> > +
> > +		ntc_thermistor_parse_dt(pdata, np);
> 
> This compiles, but the resulting code would not work as the necessary fields
> in pdata are not all filled out. So I think it would be better to merge the code
> with the next patch, as both don't really work independently.
> 
> > +	} else
> > +		pdata = pdev->dev.platform_data;
> 
> Not necessary if you keep above pre-initialization.
> 
> A better idea would be to move the devm_kzalloc into ntc_thermistor_parse_dt
> and return a pointer to pdata from it. Then you would have
> 
> 	pdata = ntc_thermistor_parse_dt(np);
> 	if (!pdata)
> 		pdata = pdev->dev.platform_data;
> 
> The check for np == NULL could then also be in ntc_thermistor_parse_dt and only
> be executed if CONFIG_OF is defined. This would make the code flow look much nicer. 
> 
> > +
> >  	if (!pdata) {
> >  		dev_err(&pdev->dev, "No platform init data supplied.\n");
> >  		return -ENODEV;
> > @@ -353,9 +420,9 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
> >  	data->dev = &pdev->dev;
> >  	data->pdev = pdev;
> >  	data->pdata = pdata;
> > -	strlcpy(data->name, pdev->id_entry->name, sizeof(data->name));
> > +	strncpy(data->name, dev_name(&pdev->dev), PLATFORM_NAME_SIZE);
> >  
> strlcpy is used to ensure 0 termination.
> sizeof(data->name) is used to ensure object size.
> 
> You should introduce a variable such as pdev_id and either assign pdev->id_entry
> or the result of the of function call to it. Other code does that for example
> with
> 	const struct of_device_id *of_id =
> 	                        of_match_device(of_match_ptr(coda_dt_ids),
> 				&pdev->dev);
> 	const struct platform_device_id *pdev_id;
> 	...
> 	pdev_id = of_id ? of_id->data : platform_get_device_id(pdev);
> 
> and then just use pdev_id. Then you can use
> 	strncpy(data->name, pdev_id->name, sizeof(data->name));
> 
> That requires to change .data in the of_device_id table to point to the
> platform_device_id.
> 
> > -	switch (pdev->id_entry->driver_data) {
> > +	switch (thermistor_get_type(pdev)) {
> 
> And then:
> 	switch (pdev_id) {
> 
> >  	case TYPE_NCPXXWB473:
> >  		data->comp = ncpXXwb473;
> >  		data->n_comp = ARRAY_SIZE(ncpXXwb473);
> > @@ -365,9 +432,8 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
> >  		data->n_comp = ARRAY_SIZE(ncpXXwl333);
> >  		break;
> >  	default:
> > -		dev_err(&pdev->dev, "Unknown device type: %lu(%s)\n",
> > -				pdev->id_entry->driver_data,
> > -				pdev->id_entry->name);
> > +		dev_err(&pdev->dev, "Unknown device type: %u\n",
> > +				thermistor_get_type(pdev));
> 
> 		dev_err(&pdev->dev, "Unknown device type: %lu(%s)\n",
> 			pdev_id->driver_data,
> 			pdev_id->name);
> 
> >  		return -EINVAL;
> >  	}
> >  
> > @@ -386,9 +452,8 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
> >  		goto err_after_sysfs;
> >  	}
> >  
> > -	dev_info(&pdev->dev, "Thermistor %s:%d (type: %s/%lu) successfully probed.\n",
> > -			pdev->name, pdev->id, pdev->id_entry->name,
> > -			pdev->id_entry->driver_data);
> > +	dev_info(&pdev->dev, "Thermistor successfully probed.\n");
> 
> Same here again.
> 	dev_info(&pdev->dev, "Thermistor %s:%d (type: %s/%lu) successfully probed.\n",
> 		 pdev->name, pdev->id, pdev_id->name,
> 		 pdev_id->driver_data);
> 
> Though I would change that to
> 	dev_info(&pdev->dev, "Thermistor type %s successfully probed.\n",
> 		 pdev_id->name);
> 
> since the rest of the output is either redundant (name/id) or internal
> (pdev_id->driver_data).
> 
> > +
> >  	return 0;
> >  err_after_sysfs:
> >  	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
> > @@ -406,19 +471,11 @@ static int ntc_thermistor_remove(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > -static const struct platform_device_id ntc_thermistor_id[] = {
> > -	{ "ncp15wb473", TYPE_NCPXXWB473 },
> > -	{ "ncp18wb473", TYPE_NCPXXWB473 },
> > -	{ "ncp21wb473", TYPE_NCPXXWB473 },
> > -	{ "ncp03wb473", TYPE_NCPXXWB473 },
> > -	{ "ncp15wl333", TYPE_NCPXXWL333 },
> > -	{ },
> > -};
> > -
> >  static struct platform_driver ntc_thermistor_driver = {
> >  	.driver = {
> >  		.name = "ntc-thermistor",
> >  		.owner = THIS_MODULE,
> > +		.of_match_table = of_match_ptr(ntc_match),
> >  	},
> >  	.probe = ntc_thermistor_probe,
> >  	.remove = ntc_thermistor_remove,
> > -- 
> > 1.7.9.5
> > 
> > 
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
> 
