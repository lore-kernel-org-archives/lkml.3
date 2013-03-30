Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3C3WpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 18:45:19 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:36769 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab3C3WpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 18:45:16 -0400
Date: Sat, 30 Mar 2013 15:41:17 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Woodhouse <dwmw2@infradead.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [REPOST Patch v1 3/3] power: power_supply_core: Add support for
 supplied_from
Message-ID: <20130330224117.GA24610@lizard>
References: <1364264690-2124-1-git-send-email-rklein@nvidia.com>
 <1364264690-2124-4-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1364264690-2124-4-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 10:24:50PM -0400, Rhyland Klein wrote:
[...]
> +int power_supply_find_supply_from_node(struct device_node *supply_node)
> +{
> +	int error;
> +	struct device *dev;
> +	struct class_dev_iter iter;
> +
> +	/* Use iterator to see if any other device is registered.
> +	 * This is required since class_for_each_device returns 0
> +	 * if there are no devices registered.
> +	 */

Minor nit: can you please adhere to the canonical style for the multiline
comments?

> +	class_dev_iter_init(&iter, power_supply_class, NULL, NULL);
> +	dev = class_dev_iter_next(&iter);
> +
> +	if (!dev)
> +		return -EPROBE_DEFER;
> +
> +	/* we have to treat the return value as inverted, because if
> +	 * we return error on not found, then it won't continue looking.
> +	 * So we trick it by returning error on success to stop looking
> +	 * once the matching device is found.
> +	 */

Ditto.

> +	error = class_for_each_device(power_supply_class, NULL, supply_node,
> +				       __power_supply_find_supply_from_node);
> +
> +	return error ? 0 : -EPROBE_DEFER;
> +}
> +
> +int power_supply_check_supplies(struct power_supply *psy)
> +{
> +	struct device_node *np;
> +	int cnt = 0;
> +	int ret = 0;
> +
> +	/* If there is already a list honor it */
> +	if (psy->supplied_from && psy->num_supplies > 0)
> +		return 0;
> +
> +	/* No device node found, nothing to do */
> +	if (!psy->of_node)
> +		return 0;
> +
> +	do {

You can move 'int ret;' here (without initializer).

> +		np = of_parse_phandle(psy->of_node, "power-supplies", cnt++);
> +		if (!np)
> +			continue;
> +
> +		ret = power_supply_find_supply_from_node(np);
> +		if (ret) {
> +			dev_dbg(psy->dev, "Failed to find supply, defer!\n");
> +			return -EPROBE_DEFER;
> +		}
> +	} while (np);
> +
> +	/* All supplies found, allocate char ** array for filling */
> +	psy->supplied_from = devm_kzalloc(psy->dev, sizeof(psy->supplied_from),
> +					  GFP_KERNEL);
> +	if (!psy->supplied_from) {
> +		dev_err(psy->dev, "Couldn't allocate memory for supply list\n");
> +		return -ENOMEM;
> +	}
> +
> +	*psy->supplied_from = devm_kzalloc(psy->dev, sizeof(char *) * cnt,
> +					   GFP_KERNEL);
> +	if (!*psy->supplied_from) {
> +		dev_err(psy->dev, "Couldn't allocate memory for supply list\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret = power_supply_populate_supplied_from(psy);
> +
> +	return ret;

can be just 'return power_supply_populate_supplied_from(psy);'

> +}
> +#endif
> +
>  static int __power_supply_am_i_supplied(struct device *dev, void *data)
>  {
>  	union power_supply_propval ret = {0,};
> @@ -359,6 +486,14 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
>  
>  	INIT_WORK(&psy->changed_work, power_supply_changed_work);
>  
> +#ifdef CONFIG_OF
> +	rc = power_supply_check_supplies(psy);
> +	if (rc) {
> +		dev_info(dev, "Not all required supplies found, defer probe\n");
> +		goto check_supplies_failed;
> +	}
> +#endif
[...]
> +#ifdef CONFIG_OF
> +check_supplies_failed:
> +#endif

Can you make an empty, static inline stub for
power_supply_check_supplies() for !CONFIG_OF case, so that we won't need
#ifdefs inside this function?

Otherwise it looks great, thanks a lot!

Anton
