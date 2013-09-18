Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3IRUo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:44:57 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:41252 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751635Ab3IRUo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:44:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3874:4321:4605:5007:6119:7652:7875:7903:10004:10400:10848:11026:11233:11658:11914:12043:12438:12517:12519:12740:13069:13311:1
X-HE-Tag: cry09_d680bde6c654
X-Filterd-Recvd-Size: 3077
Message-ID: <1379537090.1787.67.camel@joe-AO722>
Subject: Re: [PATCHv4 02/16] drivers: thermal: introduce device tree parser
From: Joe Perches <joe@perches.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: swarren@wwwdotorg.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob.herring@calxeda.com, linux@roeck-us.net,
        rui.zhang@intel.com, wni@nvidia.com, grant.likely@linaro.org,
        durgadoss.r@intel.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Wed, 18 Sep 2013 13:44:50 -0700
In-Reply-To: <1379536310-30000-1-git-send-email-eduardo.valentin@ti.com>
References: <1379530923-29268-1-git-send-email-eduardo.valentin@ti.com>
	 <1379536310-30000-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 16:31 -0400, Eduardo Valentin wrote:

> +/**
> + * of_parse_thermal_zones - parse device tree thermal data
> + *
> + * Initialization function that can be called by machine initialization
> + * code to parse thermal data and populate the thermal framework
> + * with hardware thermal zones info. This function only parses thermal zones.
> + * Cooling devices and sensor devices nodes are supposed to be parsed
> + * by their respective drivers.
> + *
> + * Return: 0 on success, proper error code otherwise
> + *
> + */
> +int __init of_parse_thermal_zones(void)
> +{
> +	struct device_node *np, *child;
> +	struct __thermal_zone *tz;
> +	struct thermal_zone_device_ops *ops;
> +
> +	np = of_find_node_by_name(NULL, "thermal-zones");
> +	if (!np) {
> +		pr_err("unable to find thermal zones\n");
> +		return 0;

return 0? This is success?

> +	}
> +
> +	for_each_child_of_node(np, child) {
> +		struct thermal_zone_device *zone;
> +		struct thermal_zone_params *tzp;
> +
> +		tz = thermal_of_build_thermal_zone(child);
> +		if (IS_ERR(tz)) {
> +			pr_err("failed to build thermal zone %ld\n",
> +			       PTR_ERR(tz));
> +			return 0;
> +		}
> +
> +		ops = kzalloc(sizeof(*ops), GFP_KERNEL);
> +		if (!ops)
> +			return 0;
> +
> +		memcpy(ops, &of_thermal_ops, sizeof(*ops));

kmemdup instead of alloc/memcpy

> +		tzp = kzalloc(sizeof(*tzp), GFP_KERNEL);
> +		if (!ops)
> +			return 0;
> +
> +		/* No hwmon because there might be hwmon drivers registering */
> +		tzp->no_hwmon = true;
> +
> +		zone = thermal_zone_device_register(child->name, tz->ntrips,
> +						    0, tz,
> +						    ops, tzp,
> +						    tz->passive_delay,
> +						    tz->polling_delay);
> +		if (IS_ERR(zone))
> +			pr_err("Failed to build %s zone %ld\n", child->name,
> +			       PTR_ERR(zone));
> +	}
> +	return 0;
> +}

All returns are 0, always successful?


