Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3HTQsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:48:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47285 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3HTQsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:48:14 -0400
Message-ID: <52139DC9.4040803@wwwdotorg.org>
Date: Tue, 20 Aug 2013 10:48:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@kernel.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, rob@landley.net,
        lee.jones@linaro.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, kishon@ti.com,
        j-keerthy@ti.com, ian.campbell@citrix.com
Subject: Re: [PATCH V3] regulator: palmas: add support for external control
 of rails
References: <1377004456-26318-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1377004456-26318-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 07:14 AM, Laxman Dewangan wrote:
> Palmas rails like LDOs, SMPSs, REGENs, SYSENs can be enable and disable
> by register programming through I2C communication as well as it can be
> enable/disable with the external control input ENABLE1, ENABLE2 and NSLEEP.
> 
> Add support for configuring these rails to be controlled by external control
> inputs. This is require to configure the rail's control register as well as
> configuration of resource register.
> 
> Provide the external input names through parameter "roof-floor". Updated the
> DT binding document to details different value of the roof-floor.

> diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt

The binding changes look reasonable and backwards-compatible, so they're
good. Just one nit:

(In the example, I assume:)
>  			regulator-always-on;
>  			regulator-boot-on;
>  			ti,warm-reset;
> -			ti,roof-floor;
> +			ti,roof-floor = 0x1; /* ENABLE1 control */

You need <> around the value, so better:

			ti,roof-floor = <0x1>; /* ENABLE1 control */

or better:

			ti,roof-floor = <1>; /* ENABLE1 control */

(even better might be a header file that defines names for those
constants...)

> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c

> @@ -746,9 +854,24 @@ static void palmas_dt_to_pdata(struct device *dev,
>  			of_property_read_bool(palmas_matches[idx].of_node,
>  					     "ti,warm-reset");
>  
> -		pdata->reg_init[idx]->roof_floor =
> -			of_property_read_bool(palmas_matches[idx].of_node,
> -					      "ti,roof-floor");
> +		ret = of_property_read_u32(palmas_matches[idx].of_node,
> +					      "ti,roof-floor", &prop);
> +		/* EINVAL: Property not found */
> +		if (ret != -EINVAL) {
> +			int econtrol;
> +
> +			/* use default value, when no value is specified */
> +			econtrol = PALMAS_EXT_CONTROL_NSLEEP;
> +			if (!ret) {
> +				if (prop == 1)
> +					econtrol = PALMAS_EXT_CONTROL_ENABLE1;
> +				else if (prop == 2)
> +					econtrol = PALMAS_EXT_CONTROL_ENABLE2;
> +				else if (prop == 3)
> +					econtrol = PALMAS_EXT_CONTROL_NSLEEP;

Should probably at least WARN() here if the value is invalid?

> +			}
> +			pdata->reg_init[idx]->roof_floor = econtrol;
> +		}

