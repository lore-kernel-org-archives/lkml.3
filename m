Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaCDMFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 07:05:55 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64781 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbaCDMFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 07:05:52 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-30-5315c19dec07
Message-id: <1393934748.1222.10.camel@AMDC1943>
Subject: Re: [PATCH v2 1/3] power_supply: modelgauge_battery: Maxim ModelGauge
 ICs gauge
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Cc: anton@enomsg.org, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mk7.kang@samsung.com, mark.rutland@arm.com
Date: Tue, 04 Mar 2014 13:05:48 +0100
In-reply-to: <1391293385-27539-2-git-send-email-vladimir.barinov@cogentembedded.com>
References: <1391293385-27539-1-git-send-email-vladimir.barinov@cogentembedded.com>
 <1391293385-27539-2-git-send-email-vladimir.barinov@cogentembedded.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xK7pzD4oGG9zcaWFxcKumxfwj51gt
	Jq6czGxxedccNoul1y8yWXQcaWG06Ou6yO7A7rFm3hpGjwdT/zN5TOj/xOixeYWWR9+WVYwe
	nzfJBbBFcdmkpOZklqUW6dslcGXcuuZUsIC/YuIMqQbG39xdjJwcEgImEn1vXjFB2GISF+6t
	Z+ti5OIQEljKKHF3Sy8zhPOZUeLGpFYWkCpeAX2JvstrwWxhgSiJhVc3gXWzCRhLbF6+hA3E
	FhGwktj1dhIrSDOzwERGiZtPboIlWARUJc5MeswOYnMKhEm0zv7DCrFhPqPErr0drCAJZgF1
	iUnzFjFD3KQksbu9kx0iLi+xec1bZogrBCV+TL7HMoFRYBaSlllIymYhKVvAyLyKUTS1NLmg
	OCk911CvODG3uDQvXS85P3cTIyTYv+xgXHzM6hCjAAejEg+vwxSRYCHWxLLiytxDjBIczEoi
	vIoLRYOFeFMSK6tSi/Lji0pzUosPMTJxcALDsnPJhk+b9seK9FTxOppae13epy2xbm7eo3Mf
	tBZXCs37Yjf9vetzB/3HoU3z/t48wJ+ZvtPt2sQJP22PvOnpzY61vb17wdIF3HzTfu5fkPVB
	zOFcD2vctFPsq/iDvX+VzL/YNLX8W6OS937fiezF1YfjyybuqTttcOu26Kqv86a0Gt82+V6/
	ZoISS3FGoqEWc1FxIgAZDGmTVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And one more comment:

On Sun, 2014-02-02 at 02:23 +0400, Vladimir Barinov wrote:
> +static int modelgauge_get_property(struct power_supply *psy,
> +				   enum power_supply_property psp,
> +				   union power_supply_propval *val)
> +{
> +	struct modelgauge_priv *priv = container_of(psy,
> +						    struct modelgauge_priv,
> +						    battery);
> +	struct regmap *regmap = priv->regmap;
> +	struct modelgauge_platform_data *pdata = priv->pdata;
> +	int reg;
> +	int ret;
> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_STATUS:
> +		if (pdata && pdata->get_charging_status)
> +			val->intval = pdata->get_charging_status();
> +		else
> +			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
> +		break;
> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> +		ret = regmap_read(regmap, MODELGAUGE_VCELL_REG, &reg);
> +		if (ret < 0)
> +			return ret;
> +
> +		val->intval = modelgauge_lsb_to_uvolts(priv, reg);
> +		break;
> +	case POWER_SUPPLY_PROP_VOLTAGE_OCV:
> +		/* Unlock model access */
> +		regmap_write(regmap, MODELGAUGE_UNLOCK_REG,
> +			     MODELGAUGE_UNLOCK_VALUE);
> +		ret = regmap_read(regmap, MODELGAUGE_OCV_REG, &reg);
> +		/* Lock model access */
> +		regmap_write(regmap, MODELGAUGE_UNLOCK_REG, 0);
> +		if (ret < 0)
> +			return ret;
> +
> +		val->intval = modelgauge_lsb_to_uvolts(priv, reg);
> +		break;
> +	case POWER_SUPPLY_PROP_CAPACITY:
> +		ret = regmap_read(regmap, MODELGAUGE_SOC_REG, &reg);
> +		if (ret < 0)
> +			return ret;
> +
> +		val->intval = reg / (1 << priv->soc_shift);
> +		break;
> +	case POWER_SUPPLY_PROP_TEMP:
> +		if (pdata && pdata->get_temperature)
> +			val->intval = pdata->get_temperature();
> +		else
> +			val->intval = 25;

If pdata->get_temperature() is not supplied then probably the driver
should not support POWER_SUPPLY_PROP_TEMP at all. I think it is better
not to report any temperature than to report a wrong one.


Best regards,
Krzysztof

