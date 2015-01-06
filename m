Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbbAFSNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:13:01 -0500
Received: from down.free-electrons.com ([37.187.137.238]:46524 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752047AbbAFSM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:12:59 -0500
Message-ID: <54AC259A.4060102@free-electrons.com>
Date: Tue, 06 Jan 2015 19:12:42 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?windows-1252?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] ata: libahci: Allow to use multiple regulators
References: <1419676483-10346-1-git-send-email-gregory.clement@free-electrons.com> <1419676483-10346-4-git-send-email-gregory.clement@free-electrons.com> <549EAD01.9070608@redhat.com>
In-Reply-To: <549EAD01.9070608@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On 27/12/2014 13:58, Hans de Goede wrote:
> Hi Gregory,
> 
> Thanks for working on this. Overall the patch-set / concept looks good,
> you can add "Acked-by: Hans de Goede <hdegoede@redhat.com>" to the first
> 2 patches.

Thanks for your review. About the second patch as the change in the regulator
framework didn't have been accepted, I had to change the binding. I will send
a the new binding in the next version.

> 
> I've some comments on this patch, see below.
> 
[...]

>> +int ahci_platform_enable_regulators(struct ahci_host_priv *hpriv)
>> +{
>> +	int rc, i;
>> +
>> +	for (i = 0; i < hpriv->nports; i++) {
>> +		if (!hpriv->target_pwrs[i])
>> +			continue;
>> +
>> +		rc = regulator_enable(hpriv->target_pwrs[i]);
>> +		if (rc)
>> +			goto disable_target_pwrs;
>> +	}
>> +
>> +	return 0;
>> +
>> +disable_target_pwrs:
>> +	while (--i >= 0)
>> +		if (!hpriv->target_pwrs[i])
> 
> I'm pretty sure you want:
> 
> 		if (hpriv->target_pwrs[i])
> 
> here, so without the '!' .
> 
>> +			regulator_disable(hpriv->target_pwrs[i]);

yes you're right.

>> +
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(ahci_platform_enable_regulators);
>> +
>> +/**
>> + * ahci_platform_disable_regulators - Disable regulators
>> + * @hpriv: host private area to store config values
>> + *
>> + * This function disables all regulators found in hpriv->target_pwrs.
>> + */
>> +void ahci_platform_disable_regulators(struct ahci_host_priv *hpriv)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < hpriv->nports; i++) {
>> +		if (!hpriv->target_pwrs[i])
>> +			continue;
>> +		regulator_disable(hpriv->target_pwrs[i]);
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(ahci_platform_disable_regulators);
>> +/**
>>    * ahci_platform_enable_resources - Enable platform resources
>>    * @hpriv: host private area to store config values
>>    *
>> @@ -157,11 +210,9 @@ int ahci_platform_enable_resources(struct ahci_host_priv *hpriv)
>>   {
>>   	int rc;
>>
>> -	if (hpriv->target_pwr) {
>> -		rc = regulator_enable(hpriv->target_pwr);
>> -		if (rc)
>> -			return rc;
>> -	}
>> +	rc = ahci_platform_enable_regulators(hpriv);
>> +	if (rc)
>> +		return rc;
>>
>>   	rc = ahci_platform_enable_clks(hpriv);
>>   	if (rc)
>> @@ -177,8 +228,8 @@ disable_clks:
>>   	ahci_platform_disable_clks(hpriv);
>>
>>   disable_regulator:
>> -	if (hpriv->target_pwr)
>> -		regulator_disable(hpriv->target_pwr);
>> +	ahci_platform_disable_regulators(hpriv);
>> +
>>   	return rc;
>>   }
>>   EXPORT_SYMBOL_GPL(ahci_platform_enable_resources);
>> @@ -199,8 +250,7 @@ void ahci_platform_disable_resources(struct ahci_host_priv *hpriv)
>>
>>   	ahci_platform_disable_clks(hpriv);
>>
>> -	if (hpriv->target_pwr)
>> -		regulator_disable(hpriv->target_pwr);
>> +	ahci_platform_disable_regulators(hpriv);
>>   }
>>   EXPORT_SYMBOL_GPL(ahci_platform_disable_resources);
>>
>> @@ -218,6 +268,59 @@ static void ahci_platform_put_resources(struct device *dev, void *res)
>>   		clk_put(hpriv->clks[c]);
>>   }
>>
>> +static int ahci_platform_get_phy(struct ahci_host_priv *hpriv, u32 port,
>> +				struct device *dev, struct device_node *node)
>> +{
>> +	int rc;
>> +
>> +	hpriv->phys[port] = devm_of_phy_get(dev, node, NULL);
>> +
>> +	if (!IS_ERR(hpriv->phys[port]))
>> +		return 0;
>> +
>> +	rc = PTR_ERR(hpriv->phys[port]);
>> +	switch (rc) {
>> +	case -ENOSYS:
>> +		/* No PHY support. Check if PHY is required. */
>> +		if (of_find_property(node, "phys", NULL)) {
>> +			dev_err(dev,
>> +				"couldn't get PHY in node %s: ENOSYS\n",
>> +				node->name);
>> +			break;
>> +		}
>> +	case -ENODEV:
>> +		/* continue normally */
>> +		hpriv->phys[port] = NULL;
>> +		rc = 0;
>> +		break;
>> +
>> +	default:
>> +		dev_err(dev,
>> +			"couldn't get PHY in node %s: %d\n",
>> +			node->name, rc);
>> +
>> +		break;
>> +	}
>> +
>> +	return rc;
>> +}
>> +
>> +static int ahci_platform_get_regulator(struct ahci_host_priv *hpriv, u32 port,
>> +				struct device *dev, struct device_node *node)
>> +{
>> +	struct regulator *target_pwr;
>> +	int rc = 0;
>> +
>> +	target_pwr = devm_of_regulator_get_optional(dev, "target", node);
>> +
>> +	if (!IS_ERR(target_pwr))
>> +		hpriv->target_pwrs[port] = target_pwr;
>> +	else
>> +		rc = PTR_ERR(target_pwr);
>> +
>> +	return rc;
>> +}
>> +
>>   /**
>>    * ahci_platform_get_resources - Get platform resources
>>    * @pdev: platform device to get resources for
>> @@ -240,7 +343,7 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>>   	struct ahci_host_priv *hpriv;
>>   	struct clk *clk;
>>   	struct device_node *child;
>> -	int i, enabled_ports = 0, rc = -ENOMEM;
>> +	int i, sz, enabled_ports = 0, rc = -ENOMEM;
>>   	u32 mask_port_map = 0;
>>
>>   	if (!devres_open_group(dev, NULL, GFP_KERNEL))
>> @@ -261,14 +364,6 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>>   		goto err_out;
>>   	}
>>
>> -	hpriv->target_pwr = devm_regulator_get_optional(dev, "target");
>> -	if (IS_ERR(hpriv->target_pwr)) {
>> -		rc = PTR_ERR(hpriv->target_pwr);
>> -		if (rc == -EPROBE_DEFER)
>> -			goto err_out;
>> -		hpriv->target_pwr = NULL;
>> -	}
>> -
>>   	for (i = 0; i < AHCI_MAX_CLKS; i++) {
>>   		/*
>>   		 * For now we must use clk_get(dev, NULL) for the first clock,
>> @@ -292,15 +387,24 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>>
>>   	hpriv->nports = of_get_child_count(dev->of_node);
>>
>> -	if (hpriv->nports) {
>> -		hpriv->phys = devm_kzalloc(dev,
>> -					   hpriv->nports * sizeof(*hpriv->phys),
>> -					   GFP_KERNEL);
>> -		if (!hpriv->phys) {
>> -			rc = -ENOMEM;
>> -			goto err_out;
>> -		}
>> +	 /* If no sub-node was found, keep this for device tree compatibility */
>> +	if (!hpriv->nports)
>> +		hpriv->nports = 1;
> 
> So now nports is always >= 1.
> 
>> +
>> +	sz = hpriv->nports * sizeof(*hpriv->phys);
>> +	hpriv->phys = devm_kzalloc(dev, sz, GFP_KERNEL);
>> +	if (!hpriv->phys) {
>> +		rc = -ENOMEM;
>> +		goto err_out;
>> +	}
>> +	sz = hpriv->nports * sizeof(*hpriv->target_pwrs);
>> +	hpriv->target_pwrs = devm_kzalloc(dev, sz, GFP_KERNEL);
>> +	if (!hpriv->target_pwrs) {
>> +		rc = -ENOMEM;
>> +		goto err_out;
>> +	}
>>
>> +	if (hpriv->nports) {
> 
> And this is always true,
> 
>>   		for_each_child_of_node(dev->of_node, child) {
>>   			u32 port;
>>
>> @@ -319,14 +423,14 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>>
>>   			mask_port_map |= BIT(port);
>>
>> -			hpriv->phys[port] = devm_of_phy_get(dev, child, NULL);
>> -			if (IS_ERR(hpriv->phys[port])) {
>> -				rc = PTR_ERR(hpriv->phys[port]);
>> -				dev_err(dev,
>> -					"couldn't get PHY in node %s: %d\n",
>> -					child->name, rc);
>> +			rc = ahci_platform_get_regulator(hpriv, port,
>> +							 dev, child);
>> +			if (rc == -EPROBE_DEFER)
>> +				goto err_out;
>> +
>> +			rc = ahci_platform_get_phy(hpriv, port, dev, child);
>> +			if (rc)
>>   				goto err_out;
>> -			}
>>
>>   			enabled_ports++;
>>   		}
>> @@ -343,38 +447,14 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
>>   		 * If no sub-node was found, keep this for device tree
>>   		 * compatibility
>>   		 */
> 
> And thus the code below (which is in the else) never gets executed, and you've
> broken the case where there are no subnodes.
> 
> I think it is best to fix this by keeping nports == 0 when there are no subnodes
> (because we really do not know nports then, so advertising 1 is sorta wrong anyways),

You are definitely right

> and use something like this to calculate the array sizes:
> 
> sz = (nports ? nports : 1) * sizeof(*hpriv->phys);
> ...
> sz = (nports ? nports : 1) * sizeof(*hpriv->target_pwrs);

I will do it.


Thanks again for your review,

Gregory


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
