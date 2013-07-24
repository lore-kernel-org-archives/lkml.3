Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3GXIay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:30:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54498 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3GXIax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:30:53 -0400
Date: Wed, 24 Jul 2013 10:30:41 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Robin Gong <b38343@freescale.com>
Cc: broonie@kernel.org, shawn.guo@linaro.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, lgirdwood@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] regulator: pfuze100: add pfuze100 regulator driver
Message-ID: <20130724083041.GC4332@pengutronix.de>
References: <1374398247-11384-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374398247-11384-1-git-send-email-b38343@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:03:39 up 40 days, 20:13, 26 users,  load average: 0.29, 0.31,
 0.19
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I tested your patch and had to change two things to actually make it
work. See below...

On Sun, Jul 21, 2013 at 05:17:27PM +0800, Robin Gong wrote:
> Add pfuze100 regulator driver.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>

(...)

> ---

> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> new file mode 100644
> index 0000000..fd259ef
> --- /dev/null
> +++ b/drivers/regulator/pfuze100-regulator.c
> @@ -0,0 +1,462 @@

(...)

> +static struct regulator_ops pfuze100_ldo_regulator_ops = {
> +	.enable = regulator_enable_regmap,
> +	.disable = regulator_disable_regmap,
> +	.is_enabled = regulator_is_enabled_regmap,
> +	.list_voltage = regulator_list_voltage_linear,
> +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
> +	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> +};
> +
> +static struct regulator_ops pfuze100_fixed_regulator_ops = {
> +	.list_voltage = regulator_list_voltage_linear,
> +};


This needs:

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 07d5a54..d0d67b4 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -133,6 +133,7 @@ static struct regulator_ops pfuze100_ldo_regulator_ops = {

 static struct regulator_ops pfuze100_fixed_regulator_ops = {
	.list_voltage = regulator_list_voltage_linear,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 };

 static struct regulator_ops pfuze100_sw_regulator_ops = {


Otherwise the fixed_regulator VDDR isn't registered and the driver then unloads
completely. This is at least the case for v3.10. I haven't had the chance to test
it on v3.11-rcX. If the _regulator_do_set_voltage logic changes, then scratch this.

> +
> +static struct regulator_ops pfuze100_sw_regulator_ops = {
> +	.list_voltage = regulator_list_voltage_linear,
> +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
> +	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> +	.set_voltage_time_sel = regulator_set_voltage_time_sel,
> +	.set_ramp_delay = pfuze100_set_ramp_delay,
> +};
> +
> +static struct regulator_ops pfuze100_swb_regulator_ops = {
> +	.list_voltage = regulator_list_voltage_table,
> +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
> +	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> +
> +};
> +
> +#define PFUZE100_FIXED_REG(_name, base, voltage)	\
> +{	\
> +	[PFUZE100_ ## _name] = {	\
> +		.desc = {	\
> +			.name = #_name,	\
> +			.n_voltages = 1,	\
> +			.ops = &pfuze100_fixed_regulator_ops,	\
> +			.type = REGULATOR_VOLTAGE,	\
> +			.id = PFUZE100_ ## _name,	\
> +			.owner = THIS_MODULE,	\
> +			.min_uV = (voltage),	\
> +			.enable_reg = (base),	\
> +			.enable_mask = 0x10,	\
> +		},	\
> +	}	\
> +}
> +

With this and the following defines I had to remove the first and last
curly braces. It didn't compile with them. I'm not that into the preprocessor,
to fully understand if it is valid C syntax or not.
Other drivers (e.g. mc13xxx) seem to also ommit these.

> +#define PFUZE100_SW_REG(_name, base, min, max, step)	\
> +{	\
> +	[PFUZE100_ ## _name] = {	\
> +		.desc = {	\
> +			.name = #_name,\
> +			.n_voltages = ((max) - (min)) / (step) + 1,	\
> +			.ops = &pfuze100_sw_regulator_ops,	\
> +			.type = REGULATOR_VOLTAGE,	\
> +			.id = PFUZE100_ ## _name,	\
> +			.owner = THIS_MODULE,	\
> +			.min_uV = (min),	\
> +			.uV_step = (step),	\
> +			.vsel_reg = (base) + PFUZE100_VOL_OFFSET,	\
> +			.vsel_mask = 0x3f,	\
> +		},	\
> +		.stby_reg = (base) + PFUZE100_STANDBY_OFFSET,	\
> +		.stby_mask = 0x3f,	\
> +	}	\
> +}
> +
> +#define PFUZE100_SWB_REG(_name, base, mask, voltages)	\
> +{	\
> +	[PFUZE100_ ## _name] = {	\
> +		.desc = {	\
> +			.name = #_name,	\
> +			.n_voltages = ARRAY_SIZE(voltages),	\
> +			.ops = &pfuze100_swb_regulator_ops,	\
> +			.type = REGULATOR_VOLTAGE,	\
> +			.id = PFUZE100_ ## _name,	\
> +			.owner = THIS_MODULE,	\
> +			.volt_table = voltages,	\
> +			.vsel_reg = (base),	\
> +			.vsel_mask = (mask),	\
> +		},	\
> +	}	\
> +}
> +
> +#define PFUZE100_VGEN_REG(_name, base, min, max, step)	\
> +{	\
> +	[PFUZE100_ ## _name] = {	\
> +		.desc = {	\
> +			.name = #_name,	\
> +			.n_voltages = ((max) - (min)) / (step) + 1,	\
> +			.ops = &pfuze100_ldo_regulator_ops,	\
> +			.type = REGULATOR_VOLTAGE,	\
> +			.id = PFUZE100_ ## _name,	\
> +			.owner = THIS_MODULE,	\
> +			.min_uV = (min),	\
> +			.uV_step = (step),	\
> +			.vsel_reg = (base),	\
> +			.vsel_mask = 0xf,	\
> +			.enable_reg = (base),	\
> +			.enable_mask = 0x10,	\
> +		},	\
> +		.stby_reg = (base),	\
> +		.stby_mask = 0x20,	\
> +	}	\
> +}
> +

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
