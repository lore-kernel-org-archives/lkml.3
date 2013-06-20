Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3FTEfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 00:35:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60190 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab3FTEfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 00:35:06 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "J, KEERTHY" <j-keerthy@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH v3 2/4] MFD: Palmas: Add SMPS10_BOOST feature
Thread-Topic: [PATCH v3 2/4] MFD: Palmas: Add SMPS10_BOOST feature
Thread-Index: AQHObLILjlLW/j6cEU6iDfHBoqLR45k+BUNQ
Date: Thu, 20 Jun 2013 04:34:42 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229ECC05@DBDE04.ent.ti.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-3-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1371621470-22279-3-git-send-email-j-keerthy@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Samuel,

> -----Original Message-----
> From: J, KEERTHY
> Sent: Wednesday, June 19, 2013 11:28 AM
> To: linux-omap@vger.kernel.org
> Cc: broonie@kernel.org; J, KEERTHY; ldewangan@nvidia.com;
> sameo@linux.intel.com; grant.likely@secretlab.ca; swarren@nvidia.com;
> linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org; gg@slimlogic.co.uk
> Subject: [PATCH v3 2/4] MFD: Palmas: Add SMPS10_BOOST feature
> 
> From: J Keerthy <j-keerthy@ti.com>
> 
> The SMPS10 regulator is not presesnt in all the variants of the PALMAS
> PMIC family. Hence adding a feature to distingush between them.
> 

Could you please pull this patch?

> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> ---
>  drivers/mfd/palmas.c                 |   27 ++++++++++++++++++++------
> -
>  drivers/regulator/palmas-regulator.c |    3 +++
>  include/linux/mfd/palmas.h           |   14 ++++++++++++++
>  3 files changed, 37 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c index
> b24bee3..1cacc6a 100644
> --- a/drivers/mfd/palmas.c
> +++ b/drivers/mfd/palmas.c
> @@ -231,6 +231,16 @@ static void palmas_dt_to_pdata(struct i2c_client
> *i2c,
>  		palmas_set_pdata_irq_flag(i2c, pdata);  }
> 
> +static unsigned int palmas_features =
> PALMAS_PMIC_FEATURE_SMPS10_BOOST;
> +
> +static const struct of_device_id of_palmas_match_tbl[] = {
> +	{
> +		.compatible = "ti,palmas",
> +		.data = &palmas_features,
> +	},
> +	{ },
> +};
> +
>  static int palmas_i2c_probe(struct i2c_client *i2c,
>  			    const struct i2c_device_id *id)
>  {
> @@ -238,8 +248,9 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>  	struct palmas_platform_data *pdata;
>  	struct device_node *node = i2c->dev.of_node;
>  	int ret = 0, i;
> -	unsigned int reg, addr;
> +	unsigned int reg, addr, *features;
>  	int slave;
> +	const struct of_device_id *match;
> 
>  	pdata = dev_get_platdata(&i2c->dev);
> 
> @@ -261,9 +272,16 @@ static int palmas_i2c_probe(struct i2c_client
> *i2c,
> 
>  	i2c_set_clientdata(i2c, palmas);
>  	palmas->dev = &i2c->dev;
> -	palmas->id = id->driver_data;
>  	palmas->irq = i2c->irq;
> 
> +	match = of_match_device(of_match_ptr(of_palmas_match_tbl), &i2c-
> >dev);
> +
> +	if (!match)
> +		return -ENODATA;
> +
> +	features = (unsigned int *)match->data;
> +	palmas->features = *features;
> +
>  	for (i = 0; i < PALMAS_NUM_CLIENTS; i++) {
>  		if (i == 0)
>  			palmas->i2c_clients[i] = i2c;
> @@ -433,11 +451,6 @@ static const struct i2c_device_id palmas_i2c_id[]
> = {  };  MODULE_DEVICE_TABLE(i2c, palmas_i2c_id);
> 
> -static struct of_device_id of_palmas_match_tbl[] = {
> -	{ .compatible = "ti,palmas", },
> -	{ /* end */ }
> -};
> -
>  static struct i2c_driver palmas_i2c_driver = {
>  	.driver = {
>  		   .name = "palmas",
> diff --git a/drivers/regulator/palmas-regulator.c
> b/drivers/regulator/palmas-regulator.c
> index 3ae44ac..1ae1e83 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -838,6 +838,9 @@ static int palmas_regulators_probe(struct
> platform_device *pdev)
>  				continue;
>  			ramp_delay_support = true;
>  			break;
> +		case PALMAS_REG_SMPS10:
> +			if (!PALMAS_PMIC_HAS(palmas, SMPS10_BOOST))
> +				continue;
>  		}
> 
>  		if ((id == PALMAS_REG_SMPS6) || (id == PALMAS_REG_SMPS8))
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index 8f21daf..98058ca 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -32,6 +32,19 @@
>  			((a) == PALMAS_CHIP_ID))
>  #define is_palmas_charger(a) ((a) == PALMAS_CHIP_CHARGER_ID)
> 
> +/**
> + * Palmas PMIC feature types
> + *
> + * PALMAS_PMIC_FEATURE_SMPS10_BOOST - used when the PMIC provides
> SMPS10_BOOST
> + *	regulator.
> + *
> + * PALMAS_PMIC_HAS(b, f) - macro to check if a bandgap device is
> capable of a
> + *	specific feature (above) or not. Return non-zero, if yes.
> + */
> +#define PALMAS_PMIC_FEATURE_SMPS10_BOOST	BIT(0)
> +#define PALMAS_PMIC_HAS(b, f)			\
> +			((b)->features & PALMAS_PMIC_FEATURE_ ## f)
> +
>  struct palmas_pmic;
>  struct palmas_gpadc;
>  struct palmas_resource;
> @@ -46,6 +59,7 @@ struct palmas {
>  	/* Stored chip id */
>  	int id;
> 
> +	unsigned int features;
>  	/* IRQ Data */
>  	int irq;
>  	u32 irq_mask;
> --
> 1.7.5.4

Regards,
Keerthy
