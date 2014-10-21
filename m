Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaJUL5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:57:51 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41202 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaJUL5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:57:49 -0400
Message-ID: <54464A37.6060701@collabora.co.uk>
Date: Tue, 21 Oct 2014 13:57:43 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v2 1/4] regulator: max77686: Replace hard-coded opmode
 values with defines
References: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com> <1413890597-31037-2-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1413890597-31037-2-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

Thanks a lot for the re-spin.

On 10/21/2014 01:23 PM, Krzysztof Kozlowski wrote:
> Add defines for regulator operating modes which should be more readable,
> especially if one does not have Maxim 77686 datasheet.
> 
> The patch does not introduce any functional change.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/regulator/max77686.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> index ef1af2debbd2..cffe0c69d57d 100644
> --- a/drivers/regulator/max77686.c
> +++ b/drivers/regulator/max77686.c
> @@ -45,6 +45,16 @@
>  #define MAX77686_DVS_MINUV	600000
>  #define MAX77686_DVS_UVSTEP	12500
>  
> +/* On/off controlled by PWRREQ */
> +#define MAX77686_OPMODE_OFF_PWRREQ	0x1

Minor nit: maybe this should be called MAX77802_OFF_PWRREQ (without the OPMODE)?
Since afaiu from a conceptual pov the regulators only supports two modes: normal
and low power mode.

If a regulator is disabled or put in low power mode by PWRREQ on suspend, then
is not really an operating mode (the regulator output will still be normal until
suspend) but an enable pin to switch a regulator mode automatically by the SoC.

> +/*
> + * For some regulators this means:
> + *  - forcing low power mode.
> + *  - low power mode controlled by PWRREQ.
> + */
> +#define MAX77686_OPMODE_LOWPOWER	0x2

Can you also add a #define MAX77686_LP_PWRREQ 0x2 and use each one when
appropriate? That will better document when 0x2 means low power by PWRREQ
and when it means change regulator mode to low power.

Also, are you sure that forcing low power mode is 0x2 and not 0x1?

I'm asking because I see in the max77802 data-sheet that regulators that
supports its mode to be low power during runtime are using 0x1:

01b: Output ON in Low Power Mode

Maybe is different in the max77686 or I misunderstood your comment though...

> +#define MAX77686_OPMODE_NORMAL		0x3
> +
>  #define MAX77686_OPMODE_SHIFT	6
>  #define MAX77686_OPMODE_BUCK234_SHIFT	4
>  #define MAX77686_OPMODE_MASK	0x3
> @@ -76,9 +86,10 @@ static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
>  	int ret, id = rdev_get_id(rdev);
>  
>  	if (id == MAX77686_BUCK1)
> -		val = 0x1;
> +		val = MAX77686_OPMODE_OFF_PWRREQ;
>  	else
> -		val = 0x1 << MAX77686_OPMODE_BUCK234_SHIFT;
> +		val = MAX77686_OPMODE_OFF_PWRREQ
> +			<< MAX77686_OPMODE_BUCK234_SHIFT;
>  
>  	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
>  				 rdev->desc->enable_mask, val);
> @@ -103,10 +114,10 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
>  
>  	switch (mode) {
>  	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
> -		val = 0x2 << MAX77686_OPMODE_SHIFT;
> +		val = MAX77686_OPMODE_LOWPOWER << MAX77686_OPMODE_SHIFT;
>  		break;
>  	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
> -		val = 0x3 << MAX77686_OPMODE_SHIFT;
> +		val = MAX77686_OPMODE_NORMAL << MAX77686_OPMODE_SHIFT;
>  		break;
>  	default:
>  		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
> @@ -133,13 +144,13 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
>  
>  	switch (mode) {
>  	case REGULATOR_MODE_STANDBY:			/* switch off */
> -		val = 0x1 << MAX77686_OPMODE_SHIFT;
> +		val = MAX77686_OPMODE_OFF_PWRREQ << MAX77686_OPMODE_SHIFT;
>  		break;
>  	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
> -		val = 0x2 << MAX77686_OPMODE_SHIFT;
> +		val = MAX77686_OPMODE_LOWPOWER << MAX77686_OPMODE_SHIFT;
>  		break;
>  	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
> -		val = 0x3 << MAX77686_OPMODE_SHIFT;
> +		val = MAX77686_OPMODE_NORMAL << MAX77686_OPMODE_SHIFT;
>  		break;
>  	default:
>  		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
> 

If you do those two changes please feel free to add my Reviewed-by.

Best regards,
Javier
