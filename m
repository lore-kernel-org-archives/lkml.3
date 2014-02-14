Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaBNNoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:44:32 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33430 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbaBNNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:44:29 -0500
Date: Fri, 14 Feb 2014 13:43:49 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marek Belisko <marek@goldelico.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hns@goldelico.com" <hns@goldelico.com>
Subject: Re: [PATCH] power: twl4030_madc_battery: Add device tree support.
Message-ID: <20140214134349.GB17796@e106331-lin.cambridge.arm.com>
References: <1392384259-14311-1-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392384259-14311-1-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 01:24:19PM +0000, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  .../bindings/power_supply/twl4030_madc_battery.txt |  15 +++
>  drivers/power/twl4030_madc_battery.c               | 109 +++++++++++++++++++++
>  2 files changed, 124 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
> 
> diff --git a/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
> new file mode 100644
> index 0000000..bebc876
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
> @@ -0,0 +1,15 @@
> +twl4030_madc_battery
> +
> +Required properties:
> + - compatible : "ti,twl4030-madc-battery"
> + - capacity : battery capacity in uAh
> + - charging-calibration-data : list of voltage(mV):level(%) values for charging calibration (see example)
> + - discharging-calibration-data : list of voltage(mV):level(%) values for discharging calibration (see example)
> +
> +Example:
> +	madc-battery {
> +		compatible = "ti,twl4030-madc-battery";
> +		capacity = <1200000>;
> +		charging-calibration-data = <4200 100 4100 75 4000 55 3900 25 3800 5 3700 2 3600 1 3300 0>;
> +		discharging-calibration-data = <4200 100 4100 95 4000 70 3800 50 3700 10 3600 5 3300 0>;

Please bracket list entries individually.

> +	};
> diff --git a/drivers/power/twl4030_madc_battery.c b/drivers/power/twl4030_madc_battery.c
> index 7ef445a..2843382 100644
> --- a/drivers/power/twl4030_madc_battery.c
> +++ b/drivers/power/twl4030_madc_battery.c
> @@ -19,6 +19,7 @@
>  #include <linux/sort.h>
>  #include <linux/i2c/twl4030-madc.h>
>  #include <linux/power/twl4030_madc_battery.h>
> +#include <linux/of.h>
>  
>  struct twl4030_madc_battery {
>  	struct power_supply psy;
> @@ -188,6 +189,110 @@ static int twl4030_cmp(const void *a, const void *b)
>  		((struct twl4030_madc_bat_calibration *)a)->voltage;
>  }
>  
> +#ifdef CONFIG_OF
> +static struct twl4030_madc_bat_platform_data *
> +	twl4030_madc_dt_probe(struct platform_device *pdev)
> +{
> +	struct twl4030_madc_bat_platform_data *pdata;
> +	struct device_node *np = pdev->dev.of_node;
> +	struct property *prop;
> +	int ret;
> +	int sz, i, j = 0;
> +
> +	pdata = devm_kzalloc(&pdev->dev,
> +			sizeof(struct twl4030_madc_bat_platform_data),
> +			GFP_KERNEL);
> +	if (!pdata)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret = of_property_read_u32(np, "capacity", &pdata->capacity);
> +	if (ret != 0)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* parse and prepare charging data */
> +	prop = of_find_property(np, "charging-calibration-data", &sz);
> +	if (!prop)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (sz % 2) {
> +		dev_warn(&pdev->dev, "Count of charging-calibration-data must be even!\n");
> +		return ERR_PTR(-EINVAL);
> +	}

As sz is in bytes this checks that the property is a multiple of 2
bytes, not that it has an even number of u32 elements.

Heiko Stübner recently added of_property_count_u32_elems [1,2]. Use that
instead.

> +
> +	sz /= sizeof(u32);
> +
> +	{
> +		u32 data[sz];
> +
> +		ret = of_property_read_u32_array(np,
> +				"charging-calibration-data", &data[0], sz);
> +		if (ret)
> +			return ERR_PTR(ret);

Why not just allocate then try to read, possibly having to free if the
read fails?

Otherwise we're trying to put an arbitrarily large value onto the stack
for no good reason.

> +
> +		pdata->charging = devm_kzalloc(&pdev->dev,
> +				sizeof(struct twl4030_madc_bat_calibration) * (sz / 2),
> +				GFP_KERNEL);
> +
> +		for (i = 0; i < sz; i += 2) {
> +			pdata->charging[j].voltage = data[i];
> +			pdata->charging[j].level = data[i+1];
> +			j++;

Why not have (i = 0; i < sz/2; i++), and get rid of j?

> +		}
> +
> +		pdata->charging_size = sz / 2;
> +	}
> +
> +	/* parse and prepare discharging data */
> +	prop = of_find_property(np, "discharging-calibration-data", &sz);
> +	if (!prop)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (sz % 2) {
> +		dev_warn(&pdev->dev, "Count of discharging-calibration-data must be even!\n");
> +		return ERR_PTR(-EINVAL);
> +	}

This has the same issues as with charging-calibration-data.

Thanks,
Mark.

[1] http://www.spinics.net/lists/devicetree/msg21358.html
[2] http://www.spinics.net/lists/devicetree/msg21502.html
