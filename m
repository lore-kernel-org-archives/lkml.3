Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302Ab3GaPmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:42:55 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:2599
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234Ab3GaPmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:42:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Wed, 31 Jul 2013 23:47:17 +0800
From: Robin Gong <b38343@freescale.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: pfuze100: Simplify pfuze100_set_ramp_delay
 implementation
Message-ID: <20130731154716.GA8123@Robin-OptiPlex-780>
References: <1375195664.11289.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1375195664.11289.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From software view this patch looks better, although original code match better
with the data sheet. Thanks Axel.

Reviewed-by: Robin Gong <b38343@freescale.com>
Thanks.
On Tue, Jul 30, 2013 at 10:47:44PM +0800, Axel Lin wrote:
> Simplify the equation to calculate ramp_delay.
> Below equations are equivalent:
>   ramp_delay = 25000 / (2 * ramp_delay);
>   ramp_delay = 50000 / (4 * ramp_delay);
>   ramp_delay = 25000 / (2 * ramp_delay);
>   ramp_delay = 12500 / ramp_delay;
> So we don't need to read BIT6 of rdev->desc->vsel_reg for applying different
> equations.
> 
> Also use rdev->desc->vsel_reg instead of run-time calculate register address.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/pfuze100-regulator.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> index e02d9b9..bda5561 100644
> --- a/drivers/regulator/pfuze100-regulator.c
> +++ b/drivers/regulator/pfuze100-regulator.c
> @@ -93,26 +93,15 @@ static int pfuze100_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
>  {
>  	struct pfuze_chip *pfuze100 = rdev_get_drvdata(rdev);
>  	int id = rdev->desc->id;
> -	unsigned int val, ramp_bits, reg;
> +	unsigned int ramp_bits;
>  	int ret;
>  
>  	if (id < PFUZE100_SWBST) {
> -		if (id == PFUZE100_SW1AB)
> -			reg = PFUZE100_SW1ABVOL;
> -		else
> -			reg = PFUZE100_SW1CVOL + (id - PFUZE100_SW1C) * 7;
> -		regmap_read(pfuze100->regmap, reg, &val);
> -
> -		if (id <= PFUZE100_SW1C)
> -			ramp_delay = 25000 / (2 * ramp_delay);
> -		else if (val & 0x40)
> -			ramp_delay = 50000 / (4 * ramp_delay);
> -		else
> -			ramp_delay = 25000 / (2 * ramp_delay);
> -
> +		ramp_delay = 12500 / ramp_delay;
>  		ramp_bits = (ramp_delay >> 1) - (ramp_delay >> 3);
> -		ret = regmap_update_bits(pfuze100->regmap, reg + 4 , 0xc0,
> -				ramp_bits << 6);
> +		ret = regmap_update_bits(pfuze100->regmap,
> +					 rdev->desc->vsel_reg + 4,
> +					 0xc0, ramp_bits << 6);
>  		if (ret < 0)
>  			dev_err(pfuze100->dev, "ramp failed, err %d\n", ret);
>  	} else
> -- 
> 1.8.1.2
> 
> 
> 
> 

