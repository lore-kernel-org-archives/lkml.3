Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3GXKCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:02:48 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:36777
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab3GXKCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:02:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dI1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h17326ah1de097h1de096h8275bhz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Wed, 24 Jul 2013 18:07:18 +0800
From: Robin Gong <b38343@freescale.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <broonie@kernel.org>, <shawn.guo@linaro.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <lgirdwood@gmail.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] regulator: pfuze100: add pfuze100 regulator driver
Message-ID: <20130724100717.GA7786@Robin-OptiPlex-780>
References: <1374398247-11384-1-git-send-email-b38343@freescale.com>
 <20130724083041.GC4332@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130724083041.GC4332@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:30:41AM +0200, Steffen Trumtrar wrote:
> Hi!
> 
> I tested your patch and had to change two things to actually make it
> work. See below...
> 
> On Sun, Jul 21, 2013 at 05:17:27PM +0800, Robin Gong wrote:
> > Add pfuze100 regulator driver.
> > 
> > Signed-off-by: Robin Gong <b38343@freescale.com>
> 
> (...)
> 
> > ---
> 
> > diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> > new file mode 100644
> > index 0000000..fd259ef
> > --- /dev/null
> > +++ b/drivers/regulator/pfuze100-regulator.c
> > @@ -0,0 +1,462 @@
> 
> (...)
> 
> > +static struct regulator_ops pfuze100_ldo_regulator_ops = {
> > +	.enable = regulator_enable_regmap,
> > +	.disable = regulator_disable_regmap,
> > +	.is_enabled = regulator_is_enabled_regmap,
> > +	.list_voltage = regulator_list_voltage_linear,
> > +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
> > +	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> > +};
> > +
> > +static struct regulator_ops pfuze100_fixed_regulator_ops = {
> > +	.list_voltage = regulator_list_voltage_linear,
> > +};
> 
> 
> This needs:
> 
> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> index 07d5a54..d0d67b4 100644
> --- a/drivers/regulator/pfuze100-regulator.c
> +++ b/drivers/regulator/pfuze100-regulator.c
> @@ -133,6 +133,7 @@ static struct regulator_ops pfuze100_ldo_regulator_ops = {
> 
>  static struct regulator_ops pfuze100_fixed_regulator_ops = {
> 	.list_voltage = regulator_list_voltage_linear,
> +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
>  };
> 
>  static struct regulator_ops pfuze100_sw_regulator_ops = {
> 
> 
> Otherwise the fixed_regulator VDDR isn't registered and the driver then unloads
> completely. This is at least the case for v3.10. I haven't had the chance to test
> it on v3.11-rcX. If the _regulator_do_set_voltage logic changes, then scratch this.
> 
Thanks firstly for you test with the patch. I have test it on v3.10 just now,
and can't reproduce what you saw that VDDR regulator can't be registered
successfully. I don't think fixed regulator need <set_voltage_sel>.
> > +
> > +static struct regulator_ops pfuze100_sw_regulator_ops = {
> > +	.list_voltage = regulator_list_voltage_linear,
> > +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
> > +	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> > +	.set_voltage_time_sel = regulator_set_voltage_time_sel,
> > +	.set_ramp_delay = pfuze100_set_ramp_delay,
> > +};
> > +
> > +static struct regulator_ops pfuze100_swb_regulator_ops = {
> > +	.list_voltage = regulator_list_voltage_table,
> > +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
> > +	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> > +
> > +};
> > +
> > +#define PFUZE100_FIXED_REG(_name, base, voltage)	\
> > +{	\
> > +	[PFUZE100_ ## _name] = {	\
> > +		.desc = {	\
> > +			.name = #_name,	\
> > +			.n_voltages = 1,	\
> > +			.ops = &pfuze100_fixed_regulator_ops,	\
> > +			.type = REGULATOR_VOLTAGE,	\
> > +			.id = PFUZE100_ ## _name,	\
> > +			.owner = THIS_MODULE,	\
> > +			.min_uV = (voltage),	\
> > +			.enable_reg = (base),	\
> > +			.enable_mask = 0x10,	\
> > +		},	\
> > +	}	\
> > +}
> > +
> 
> With this and the following defines I had to remove the first and last
> curly braces. It didn't compile with them. I'm not that into the preprocessor,
> to fully understand if it is valid C syntax or not.
> Other drivers (e.g. mc13xxx) seem to also ommit these.
> 
Thanks your finding, I have noticed it after I send the V4 patch. I modify this
to eliminate the errors which found by checkpatch, such as"ERROR: Macros with
complex values should be enclosed in parenthesis". I notice some driver use
brace here, and modify this, sorry for sending quickly without building and
testing again.... I will keep it as V3 and before version on these macro define

> > +#define PFUZE100_SW_REG(_name, base, min, max, step)	\
> > +{	\
> > +	[PFUZE100_ ## _name] = {	\
> > +		.desc = {	\
> > +			.name = #_name,\
> > +			.n_voltages = ((max) - (min)) / (step) + 1,	\
> > +			.ops = &pfuze100_sw_regulator_ops,	\
> > +			.type = REGULATOR_VOLTAGE,	\
> > +			.id = PFUZE100_ ## _name,	\
> > +			.owner = THIS_MODULE,	\
> > +			.min_uV = (min),	\
> > +			.uV_step = (step),	\
> > +			.vsel_reg = (base) + PFUZE100_VOL_OFFSET,	\
> > +			.vsel_mask = 0x3f,	\
> > +		},	\
> > +		.stby_reg = (base) + PFUZE100_STANDBY_OFFSET,	\
> > +		.stby_mask = 0x3f,	\
> > +	}	\
> > +}
> > +
> > +#define PFUZE100_SWB_REG(_name, base, mask, voltages)	\
> > +{	\
> > +	[PFUZE100_ ## _name] = {	\
> > +		.desc = {	\
> > +			.name = #_name,	\
> > +			.n_voltages = ARRAY_SIZE(voltages),	\
> > +			.ops = &pfuze100_swb_regulator_ops,	\
> > +			.type = REGULATOR_VOLTAGE,	\
> > +			.id = PFUZE100_ ## _name,	\
> > +			.owner = THIS_MODULE,	\
> > +			.volt_table = voltages,	\
> > +			.vsel_reg = (base),	\
> > +			.vsel_mask = (mask),	\
> > +		},	\
> > +	}	\
> > +}
> > +
> > +#define PFUZE100_VGEN_REG(_name, base, min, max, step)	\
> > +{	\
> > +	[PFUZE100_ ## _name] = {	\
> > +		.desc = {	\
> > +			.name = #_name,	\
> > +			.n_voltages = ((max) - (min)) / (step) + 1,	\
> > +			.ops = &pfuze100_ldo_regulator_ops,	\
> > +			.type = REGULATOR_VOLTAGE,	\
> > +			.id = PFUZE100_ ## _name,	\
> > +			.owner = THIS_MODULE,	\
> > +			.min_uV = (min),	\
> > +			.uV_step = (step),	\
> > +			.vsel_reg = (base),	\
> > +			.vsel_mask = 0xf,	\
> > +			.enable_reg = (base),	\
> > +			.enable_mask = 0x10,	\
> > +		},	\
> > +		.stby_reg = (base),	\
> > +		.stby_mask = 0x20,	\
> > +	}	\
> > +}
> > +
> 
> Thanks,
> Steffen
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 

