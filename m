Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3IRTL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:11:29 -0400
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:49836 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751494Ab3IRTL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:11:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:5007:6119:7652:10004:10400:10848:11026:11232:11473:
X-HE-Tag: queen22_468621ae68c38
X-Filterd-Recvd-Size: 3090
Message-ID: <1379531483.1787.55.camel@joe-AO722>
Subject: Re: [PATCHv3 02/16] drivers: thermal: introduce device tree parser
From: Joe Perches <joe@perches.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: swarren@wwwdotorg.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob.herring@calxeda.com, linux@roeck-us.net,
        rui.zhang@intel.com, wni@nvidia.com, grant.likely@linaro.org,
        durgadoss.r@intel.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Sep 2013 12:11:23 -0700
In-Reply-To: <1379530923-29268-1-git-send-email-eduardo.valentin@ti.com>
References: <5239F6D8.1020907@ti.com>
	 <1379530923-29268-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 15:02 -0400, Eduardo Valentin wrote:
> This patch introduces a device tree bindings for
> describing the hardware thermal behavior and limits.
> Also a parser to read and interpret the data and feed
> it in the thermal framework is presented.

trivial notes:

> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
[]
> +static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
> +				enum thermal_trend *trend)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +	long dev_trend;
> +	int r;
> +
> +	if (!data->get_trend)
> +		return -EINVAL;
> +
> +	r = data->get_trend(data->sensor_data, &dev_trend);
> +	if (r)
> +		return r;
> +
> +	if (dev_trend > 0)
> +		*trend = THERMAL_TREND_RAISING;
> +	else if (dev_trend < 0)
> +		*trend = THERMAL_TREND_DROPPING;
> +	else
> +		*trend = THERMAL_TREND_STABLE;
> +
> +	return 0;
> +}

If readings are within some non zero noise level,
perhaps stable should be returned.

> +static struct __thermal_zone *
> +thermal_of_build_thermal_zone(struct device_node *np)
> +{
> +	struct device_node *child, *gchild;
> +	struct __thermal_zone *tz;
> +	int ret, i;
> +	u32 prop;
> +
> +	if (!np) {
> +		pr_err("no thermal zone np\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	tz = kzalloc(sizeof(*tz), GFP_KERNEL);
> +	if (!tz) {
> +		pr_err("not enough memory for thermal of zone\n");

Unnecessary OOM message.
All allocs without GFP_NOWARN get a dump_stack()

> +int __init of_parse_thermal_zones(void)
> +{
[]
> +		ops = kzalloc(sizeof(*ops), GFP_KERNEL);
> +		if (!ops) {
> +			pr_err("no memory available for thermal ops\n");
> +			return 0;
> +		}
> +		memcpy(ops, &of_thermal_ops, sizeof(*ops));
> +
> +		tzp = kzalloc(sizeof(*tzp), GFP_KERNEL);
> +		if (!ops) {
> +			pr_err("no memory available for thermal zone params\n");
> +			return 0;
> +		}

a couple more OOMs.


