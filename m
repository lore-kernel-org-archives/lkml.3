Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaFPNYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:24:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55332 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752144AbaFPNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:24:15 -0400
Message-ID: <539EEFFD.3010300@free-electrons.com>
Date: Mon, 16 Jun 2014 15:24:13 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 5/6] regulator: add support for regulator set registration
References: <1401183535-31003-1-git-send-email-boris.brezillon@free-electrons.com> <1401183535-31003-6-git-send-email-boris.brezillon@free-electrons.com> <53970ABD.4030402@free-electrons.com> <20140616080828.GF14323@lee--X1>
In-Reply-To: <20140616080828.GF14323@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16/06/2014 10:08, Lee Jones wrote:
>> Hello Mark,
>>
>> Did you have time to take a look at this patch ?
>>
>> I'd like to post a new version of this series addressing Lee's comments,
>> but it would be great to have your feedback on this patch before posting
>> a new version.
> I wouldn't do that, as you're likely to upset him.
>
> Just fix what you know and resend.
>
> Mark will subsequently review I'm sure.

Okay, I'll send a new version soon.

>
>> Best Regards,
>>
>> Boris
>>
>> On 27/05/2014 11:38, Boris BREZILLON wrote:
>>> PMIC devices often provide several regulators, and these regulators are
>>> all using the same regmap and are all attached to the same device (the
>>> PMIC device).
>>>
>>> Add helper functions (both simple and resource managed versions) to
>>> register and unregister such kind of regulator set.
>>>
>>> This implementation handles self dependency issues where one regulator
>>> provided the PMIC depends on another one provided by the same PMIC.
>>>
>>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>>> ---
>>>  drivers/regulator/core.c         | 106 +++++++++++++++++++++++++++++++++++++++
>>>  drivers/regulator/devres.c       |  68 +++++++++++++++++++++++++
>>>  include/linux/regulator/driver.h |  51 +++++++++++++++++++
>>>  3 files changed, 225 insertions(+)
>>>
>>> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
>>> index 9a09f3c..7703853 100644
>>> --- a/drivers/regulator/core.c
>>> +++ b/drivers/regulator/core.c
>>> @@ -3595,6 +3595,112 @@ void regulator_unregister(struct regulator_dev *rdev)
>>>  EXPORT_SYMBOL_GPL(regulator_unregister);
>>>  
>>>  /**
>>> + * regulator_set_register - register a set of regulators
>>> + * @config: runtime configuration for regulator set
>>> + *
>>> + * Called by regulator drivers to register a set of regulators.
>>> + * Returns a valid pointer to struct regulator_set on success
>>> + * or an ERR_PTR() on error.
>>> + */
>>> +struct regulator_set *
>>> +regulator_set_register(const struct regulator_set_config *config)
>>> +{
>>> +	struct regulator_set *rset;
>>> +	int prev_nregistered = -1;
>>> +	int nregistered = 0;
>>> +	int ret;
>>> +	int i;
>>> +
>>> +	if (!config->descs || !config->nregulators)
>>> +		return ERR_PTR(-EINVAL);
>>> +
>>> +	rset = kzalloc(sizeof(*rset) +
>>> +		       (config->nregulators * sizeof(struct regulator_dev *)),
>>> +		       GFP_KERNEL);
>>> +	if (!rset)
>>> +		return ERR_PTR(-ENOMEM);
>>> +
>>> +	rset->nregulators = config->nregulators;
>>> +
>>> +	while (nregistered < config->nregulators &&
>>> +	       prev_nregistered < nregistered) {
>>> +
>>> +		prev_nregistered = nregistered;
>>> +
>>> +		for (i = 0; i < config->nregulators; i++) {
>>> +			struct regulator_config conf;
>>> +			struct regulator_dev *regulator;
>>> +
>>> +			if (rset->regulators[i])
>>> +				continue;
>>> +
>>> +			memset(&conf, 0, sizeof(conf));
>>> +
>>> +			conf.dev = config->dev;
>>> +			conf.regmap = config->regmap;
>>> +			conf.driver_data = config->driver_data;
>>> +			if (config->matches && config->matches[i].init_data)
>>> +				conf.init_data = config->matches[i].init_data;
>>> +			else if (config->init_data)
>>> +				conf.init_data = config->init_data[i];
>>> +
>>> +			if (config->matches)
>>> +				conf.of_node = config->matches[i].of_node;
>>> +
>>> +			regulator = regulator_register(&config->descs[i],
>>> +						       &conf);
>>> +			if (IS_ERR(regulator)) {
>>> +				ret = PTR_ERR(regulator);
>>> +				if (ret == -EPROBE_DEFER)
>>> +					continue;
>>> +
>>> +				goto err;
>>> +			}
>>> +
>>> +			rset->regulators[i] = regulator;
>>> +			nregistered++;
>>> +		}
>>> +	}
>>> +
>>> +	if (nregistered < config->nregulators) {
>>> +		ret = -EPROBE_DEFER;
>>> +		goto err;
>>> +	}
>>> +
>>> +	return rset;
>>> +
>>> +err:
>>> +	for (i = 0; i < config->nregulators; i++) {
>>> +		if (rset->regulators[i])
>>> +			regulator_unregister(rset->regulators[i]);
>>> +	}
>>> +
>>> +	kfree(rset);
>>> +
>>> +	return ERR_PTR(ret);
>>> +}
>>> +EXPORT_SYMBOL_GPL(regulator_set_register);
>>> +
>>> +/**
>>> + * regulator_set_unregister - unregister regulator set
>>> + * @rset: regulator set to unregister
>>> + *
>>> + * Called by regulator drivers to unregister a regulator set.
>>> + */
>>> +void regulator_set_unregister(struct regulator_set *rset)
>>> +{
>>> +	int i;
>>> +
>>> +	for (i = 0; i < rset->nregulators; i++) {
>>> +		if (rset->regulators[i])
>>> +			regulator_unregister(rset->regulators[i]);
>>> +	}
>>> +
>>> +	kfree(rset);
>>> +}
>>> +EXPORT_SYMBOL_GPL(regulator_set_unregister);
>>> +
>>> +/**
>>>   * regulator_suspend_prepare - prepare regulators for system wide suspend
>>>   * @state: system suspend state
>>>   *
>>> diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
>>> index f44818b..a34f34c 100644
>>> --- a/drivers/regulator/devres.c
>>> +++ b/drivers/regulator/devres.c
>>> @@ -251,6 +251,74 @@ void devm_regulator_unregister(struct device *dev, struct regulator_dev *rdev)
>>>  }
>>>  EXPORT_SYMBOL_GPL(devm_regulator_unregister);
>>>  
>>> +static void devm_rset_release(struct device *dev, void *res)
>>> +{
>>> +	regulator_set_unregister(*(struct regulator_set **)res);
>>> +}
>>> +
>>> +/**
>>> + * devm_regulator_set_register - Resource managed regulator_set_register()
>>> + * @dev: device registering the regulator set
>>> + * @config: runtime configuration for regulator set
>>> + *
>>> + * Called by regulator drivers to register a set of regulators.  Returns a
>>> + * valid pointer to struct regulator_set on success or an ERR_PTR() on
>>> + * error.  The regulator will automatically be released when the device
>>> + * is unbound.
>>> + */
>>> +struct regulator_set *
>>> +devm_regulator_set_register(struct device *dev,
>>> +			    const struct regulator_set_config *config)
>>> +{
>>> +	struct regulator_set **ptr, *rset;
>>> +
>>> +	ptr = devres_alloc(devm_rset_release, sizeof(*ptr),
>>> +			   GFP_KERNEL);
>>> +	if (!ptr)
>>> +		return ERR_PTR(-ENOMEM);
>>> +
>>> +	rset = regulator_set_register(config);
>>> +	if (!IS_ERR(rset)) {
>>> +		*ptr = rset;
>>> +		devres_add(dev, ptr);
>>> +	} else {
>>> +		devres_free(ptr);
>>> +	}
>>> +
>>> +	return rset;
>>> +}
>>> +EXPORT_SYMBOL_GPL(devm_regulator_set_register);
>>> +
>>> +static int devm_rset_match(struct device *dev, void *res, void *data)
>>> +{
>>> +	struct regulator_set **r = res;
>>> +	if (!r || !*r) {
>>> +		WARN_ON(!r || !*r);
>>> +		return 0;
>>> +	}
>>> +	return *r == data;
>>> +}
>>> +
>>> +/**
>>> + * devm_regulator_set_unregister - Resource managed regulator_set_unregister()
>>> + * @dev: device unregistering the regulator set
>>> + * @rset: regulator set to release
>>> + *
>>> + * Unregister a regulator set registered with devm_regulator_set_register().
>>> + * Normally this function will not need to be called and the resource
>>> + * management code will ensure that the resource is freed.
>>> + */
>>> +void devm_regulator_set_unregister(struct device *dev,
>>> +				   struct regulator_set *rset)
>>> +{
>>> +	int rc;
>>> +
>>> +	rc = devres_release(dev, devm_rdev_release, devm_rset_match, rset);
>>> +	if (rc != 0)
>>> +		WARN_ON(rc);
>>> +}
>>> +EXPORT_SYMBOL_GPL(devm_regulator_unregister);
>>> +
>>>  struct regulator_supply_alias_match {
>>>  	struct device *dev;
>>>  	const char *id;
>>> diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
>>> index bbe03a1..b683f68 100644
>>> --- a/include/linux/regulator/driver.h
>>> +++ b/include/linux/regulator/driver.h
>>> @@ -350,6 +350,48 @@ struct regulator_dev {
>>>  	unsigned int ena_gpio_state:1;
>>>  };
>>>  
>>> +/**
>>> + * struct regulator_set_config - Dynamic regulator set descriptor
>>> + *
>>> + * This structure describe a regulator and each regulator in this set
>>> + * will be registered using informations passed through regulator_desc
>>> + * and of_regulator_match tables.
>>> + *
>>> + * @dev: struct device providing the regulator set.
>>> + * @driver_data: private driver data for this regulator set.
>>> + * @regmap: regmap to use for core regmap helpers if dev_get_regulator() is
>>> + *          insufficient.
>>> + * @descs: table of regulator descriptors.
>>> + * @matches: table of DT regulator descriptors. This table should have
>>> + *           been filled by the of_regulator_match function.
>>> + * @init_data: a table of init_data in case matches is NULL or the init_data
>>> + *             of the match entry is NULL.
>>> + * @nregulators: number of regulators in the regulator set.
>>> + */
>>> +struct regulator_set_config {
>>> +	struct device *dev;
>>> +	void *driver_data;
>>> +	struct regmap *regmap;
>>> +	const struct regulator_desc *descs;
>>> +	const struct of_regulator_match *matches;
>>> +	const struct regulator_init_data **init_data;
>>> +	int nregulators;
>>> +};
>>> +
>>> +/*
>>> + * struct regulator_set - Regulator set
>>> + *
>>> + * This structure stores a set of regulator devices provided by a single
>>> + * device (e.g. a PMIC device).
>>> + *
>>> + * @nregulators: number of regulators in the set
>>> + * @regulators: regulators table
>>> + */
>>> +struct regulator_set {
>>> +	int nregulators;
>>> +	struct regulator_dev *regulators[0];
>>> +};
>>> +
>>>  struct regulator_dev *
>>>  regulator_register(const struct regulator_desc *regulator_desc,
>>>  		   const struct regulator_config *config);
>>> @@ -360,6 +402,15 @@ devm_regulator_register(struct device *dev,
>>>  void regulator_unregister(struct regulator_dev *rdev);
>>>  void devm_regulator_unregister(struct device *dev, struct regulator_dev *rdev);
>>>  
>>> +struct regulator_set *
>>> +regulator_set_register(const struct regulator_set_config *config);
>>> +struct regulator_set *
>>> +devm_regulator_set_register(struct device *dev,
>>> +			    const struct regulator_set_config *config);
>>> +void regulator_set_unregister(struct regulator_set *rset);
>>> +void devm_regulator_set_unregister(struct device *dev,
>>> +				   struct regulator_set *rset);
>>> +
>>>  int regulator_notifier_call_chain(struct regulator_dev *rdev,
>>>  				  unsigned long event, void *data);
>>>  

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

