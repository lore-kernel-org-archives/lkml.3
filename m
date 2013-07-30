Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab3G3DSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:18:33 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:5517 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566Ab3G3DSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:18:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z2005kz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Tue, 30 Jul 2013 11:23:11 +0800
From: Robin Gong <b38343@freescale.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] regulator: pfuze100: Fix n_voltages setting for
 SW2~SW4 with high bit set
Message-ID: <20130730032310.GC1430@Robin-OptiPlex-780>
References: <1375152388.4265.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1375152388.4265.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok for me.
On Tue, Jul 30, 2013 at 10:46:28AM +0800, Axel Lin wrote:
> Current code adjust min_uV and uV_step but missed adjusting the n_voltages
> setting.
> 
> When BIT6 is clear:
>         n_voltages = (1975000 - 400000) / 25000 + 1 = 64
> When BIT6 is set:
>         n_voltages = (3300000 - 800000) / 50000 + 1 = 51
> 
> The n_voltages needs update because when BIT6 is set 0x73 ~ 0x7f are reserved.
> When using regulator_list_voltage_linear, the n_voltages does matter here
> because wrong n_voltages setting make the equation return wrong result.
> e.g. if selector is 63, regulator_list_voltage_linear returns
>      800000 + (50000 * 63) = 4000000
>      It should return -EINVAL if the selector is in the range of 51 ~ 63.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/pfuze100-regulator.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> index 2dadc31..a77379b 100644
> --- a/drivers/regulator/pfuze100-regulator.c
> +++ b/drivers/regulator/pfuze100-regulator.c
> @@ -387,8 +387,11 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
>  
>  	for (i = 0; i < PFUZE100_MAX_REGULATOR; i++) {
>  		struct regulator_init_data *init_data;
> +		struct regulator_desc *desc;
>  		int val;
>  
> +		desc = &pfuze_chip->regulator_descs[i].desc;
> +
>  		if (pdata)
>  			init_data = pdata->init_data[i];
>  		else
> @@ -396,13 +399,11 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
>  
>  		/* SW2~SW4 high bit check and modify the voltage value table */
>  		if (i > PFUZE100_SW1C && i < PFUZE100_SWBST) {
> -			regmap_read(pfuze_chip->regmap, PFUZE100_SW2VOL +
> -					(i - PFUZE100_SW2) * 7, &val);
> +			regmap_read(pfuze_chip->regmap, desc->vsel_reg, &val);
>  			if (val & 0x40) {
> -				pfuze_chip->regulator_descs[i].desc.min_uV
> -				= 800000;
> -				pfuze_chip->regulator_descs[i].desc.uV_step
> -				= 50000;
> +				desc->min_uV = 800000;
> +				desc->uV_step = 50000;
> +				desc->n_voltages = 51;
>  			}
>  		}
>  
> @@ -411,8 +412,7 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
>  		config.driver_data = pfuze_chip;
>  		config.of_node = match_of_node(i);
>  
> -		pfuze_chip->regulators[i] = regulator_register(&pfuze_chip
> -			->regulator_descs[i].desc, &config);
> +		pfuze_chip->regulators[i] = regulator_register(desc, &config);
>  		if (IS_ERR(pfuze_chip->regulators[i])) {
>  			dev_err(&client->dev, "register regulator%s failed\n",
>  				pfuze100_regulators[i].desc.name);
> -- 
> 1.8.1.2
> 
> 
> 
> 

