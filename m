Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750750AbaGNIuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:50:08 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33775 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaGNIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:50:01 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-10-53c399b6236f
Message-id: <53C399B4.4040207@samsung.com>
Date: Mon, 14 Jul 2014 10:49:56 +0200
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] regulator: s2mpa01: Optimize the regulator description
 macro
References: <1404822480-31525-1-git-send-email-amit.daniel@samsung.com>
 <1404822480-31525-2-git-send-email-amit.daniel@samsung.com>
In-reply-to: <1404822480-31525-2-git-send-email-amit.daniel@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xK7rbZh4ONph3Scyi4WqIxdSHT9gs
	Xr8wtPh2pYPJ4vKuOWwWM87vY7K4uOILkwO7x85Zd9k9Nq3qZPPo27KK0ePzJrkAligum5TU
	nMyy1CJ9uwSujPYrT5gL9llXPOiLb2B8pt/FyMkhIWAisebDMnYIW0ziwr31bF2MXBxCAksZ
	JW68eMQO4XxmlLj1fiMTSBWvgJbEpN6PYDaLgKpE/4VbjCA2m4CxxOblS9hAbFGBCIkDfc9Y
	IeoFJX5MvscCYosIzGeUWDnXBMRmFnCW+LakGaxeWCBc4v2svVDLWhkl5uzcC5bgFPCQmDtj
	ExNEg5nEo5Z1zBC2vMTmNW+ZJzAKzEKyYxaSsllIyhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L
	10vOz93ECAnsLzsYFx+zOsQowMGoxMNbIXY4WIg1say4MvcQowQHs5IIb7gbUIg3JbGyKrUo
	P76oNCe1+BAjEwenVAOj0XerkgTFMJ7dj/mvRu7sE9PqbUo/PV/rnIf7vpd//9rd8HFrXvt5
	qf3Dp6uuzO9gv7txkfKJu4qbvxypP+UWt+fLvUpdi41LjITVOqYIG0l+mr/p7ezyb2yNqbv7
	1ojXGfS8POf+5kOS1RNHJfnz3xe+b/gcz6XO73L6yDJFFUPJOxHmjZeKlViKMxINtZiLihMB
	PajRcUoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.07.2014 14:27, Amit Daniel Kachhap wrote:
> This patch makes the regulator description macro take minimum and
> steps voltage as parameter. In this way many repeated macros can be
> removed. Now these macros are repeated only if the the LDO/BUCK ctrl
> registers have non-linear positions. The good thing is these ctrl registers
> are mostly linear so they are not passed as parameters.
>
> This patch reduces the code size and also allow easy addition of more
> s2mpxxx PMIC drivers which differs a lot in minimum/step voltages.
>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>   drivers/regulator/s2mpa01.c | 136 ++++++++++++--------------------------------
>   1 file changed, 37 insertions(+), 99 deletions(-)
>
> diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
> index 962c5f1..8073466 100644
> --- a/drivers/regulator/s2mpa01.c
> +++ b/drivers/regulator/s2mpa01.c
> @@ -235,28 +235,14 @@ static struct regulator_ops s2mpa01_buck_ops = {
>   	.set_ramp_delay		= s2mpa01_set_ramp_delay,
>   };
>
> -#define regulator_desc_ldo1(num)	{		\
> +#define regulator_desc_ldo(num, min, step)	{	\

Why adding parameter for the 'min' value? It is always the same for LDOs 
- 800 mV.

The same applies for the s2mps11 regulator driver.

Best regards,
Krzysztof

>   	.name		= "LDO"#num,			\
>   	.id		= S2MPA01_LDO##num,		\
>   	.ops		= &s2mpa01_ldo_ops,		\
>   	.type		= REGULATOR_VOLTAGE,		\
>   	.owner		= THIS_MODULE,			\
> -	.min_uV		= MIN_800_MV,			\
> -	.uV_step	= STEP_50_MV,			\
> -	.n_voltages	= S2MPA01_LDO_N_VOLTAGES,	\
> -	.vsel_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
> -	.vsel_mask	= S2MPA01_LDO_VSEL_MASK,	\
> -	.enable_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
> -	.enable_mask	= S2MPA01_ENABLE_MASK		\
> -}
> -#define regulator_desc_ldo2(num)	{		\
> -	.name		= "LDO"#num,			\
> -	.id		= S2MPA01_LDO##num,		\
> -	.ops		= &s2mpa01_ldo_ops,		\
> -	.type		= REGULATOR_VOLTAGE,		\
> -	.owner		= THIS_MODULE,			\
> -	.min_uV		= MIN_800_MV,			\
> -	.uV_step	= STEP_25_MV,			\
> +	.min_uV		= min,				\
> +	.uV_step	= step,				\
>   	.n_voltages	= S2MPA01_LDO_N_VOLTAGES,	\
>   	.vsel_reg	= S2MPA01_REG_L1CTRL + num - 1,	\
>   	.vsel_mask	= S2MPA01_LDO_VSEL_MASK,	\
> @@ -296,14 +282,14 @@ static struct regulator_ops s2mpa01_buck_ops = {
>   	.enable_mask	= S2MPA01_ENABLE_MASK			\
>   }
>
> -#define regulator_desc_buck6_7(num)	{			\
> +#define regulator_desc_buck6_10(num, min, step)	{		\
>   	.name		= "BUCK"#num,				\
>   	.id		= S2MPA01_BUCK##num,			\
>   	.ops		= &s2mpa01_buck_ops,			\
>   	.type		= REGULATOR_VOLTAGE,			\
>   	.owner		= THIS_MODULE,				\
> -	.min_uV		= MIN_600_MV,				\
> -	.uV_step	= STEP_6_25_MV,				\
> +	.min_uV		= min,					\
> +	.uV_step	= step,					\
>   	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
>   	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
>   	.vsel_reg	= S2MPA01_REG_B6CTRL2 + (num - 6) * 2,	\
> @@ -312,91 +298,43 @@ static struct regulator_ops s2mpa01_buck_ops = {
>   	.enable_mask	= S2MPA01_ENABLE_MASK			\
>   }
>
> -#define regulator_desc_buck8	{				\
> -	.name		= "BUCK8",				\
> -	.id		= S2MPA01_BUCK8,			\
> -	.ops		= &s2mpa01_buck_ops,			\
> -	.type		= REGULATOR_VOLTAGE,			\
> -	.owner		= THIS_MODULE,				\
> -	.min_uV		= MIN_800_MV,				\
> -	.uV_step	= STEP_12_5_MV,				\
> -	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
> -	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
> -	.vsel_reg	= S2MPA01_REG_B8CTRL2,			\
> -	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
> -	.enable_reg	= S2MPA01_REG_B8CTRL1,			\
> -	.enable_mask	= S2MPA01_ENABLE_MASK			\
> -}
> -
> -#define regulator_desc_buck9	{				\
> -	.name		= "BUCK9",				\
> -	.id		= S2MPA01_BUCK9,			\
> -	.ops		= &s2mpa01_buck_ops,			\
> -	.type		= REGULATOR_VOLTAGE,			\
> -	.owner		= THIS_MODULE,				\
> -	.min_uV		= MIN_1500_MV,				\
> -	.uV_step	= STEP_12_5_MV,				\
> -	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
> -	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
> -	.vsel_reg	= S2MPA01_REG_B9CTRL2,			\
> -	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
> -	.enable_reg	= S2MPA01_REG_B9CTRL1,			\
> -	.enable_mask	= S2MPA01_ENABLE_MASK			\
> -}
> -
> -#define regulator_desc_buck10	{				\
> -	.name		= "BUCK10",				\
> -	.id		= S2MPA01_BUCK10,			\
> -	.ops		= &s2mpa01_buck_ops,			\
> -	.type		= REGULATOR_VOLTAGE,			\
> -	.owner		= THIS_MODULE,				\
> -	.min_uV		= MIN_1000_MV,				\
> -	.uV_step	= STEP_12_5_MV,				\
> -	.n_voltages	= S2MPA01_BUCK_N_VOLTAGES,		\
> -	.ramp_delay	= S2MPA01_RAMP_DELAY,			\
> -	.vsel_reg	= S2MPA01_REG_B10CTRL2,			\
> -	.vsel_mask	= S2MPA01_BUCK_VSEL_MASK,		\
> -	.enable_reg	= S2MPA01_REG_B10CTRL1,			\
> -	.enable_mask	= S2MPA01_ENABLE_MASK			\
> -}
> -
>   static struct regulator_desc regulators[] = {
> -	regulator_desc_ldo2(1),
> -	regulator_desc_ldo1(2),
> -	regulator_desc_ldo1(3),
> -	regulator_desc_ldo1(4),
> -	regulator_desc_ldo1(5),
> -	regulator_desc_ldo2(6),
> -	regulator_desc_ldo1(7),
> -	regulator_desc_ldo1(8),
> -	regulator_desc_ldo1(9),
> -	regulator_desc_ldo1(10),
> -	regulator_desc_ldo2(11),
> -	regulator_desc_ldo1(12),
> -	regulator_desc_ldo1(13),
> -	regulator_desc_ldo1(14),
> -	regulator_desc_ldo1(15),
> -	regulator_desc_ldo1(16),
> -	regulator_desc_ldo1(17),
> -	regulator_desc_ldo1(18),
> -	regulator_desc_ldo1(19),
> -	regulator_desc_ldo1(20),
> -	regulator_desc_ldo1(21),
> -	regulator_desc_ldo2(22),
> -	regulator_desc_ldo2(23),
> -	regulator_desc_ldo1(24),
> -	regulator_desc_ldo1(25),
> -	regulator_desc_ldo1(26),
> +	regulator_desc_ldo(1, MIN_800_MV, STEP_25_MV),
> +	regulator_desc_ldo(2, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(3, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(4, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(5, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(6, MIN_800_MV, STEP_25_MV),
> +	regulator_desc_ldo(7, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(8, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(9, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(10, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(11, MIN_800_MV, STEP_25_MV),
> +	regulator_desc_ldo(12, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(13, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(14, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(15, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(16, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(17, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(18, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(19, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(20, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(21, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(22, MIN_800_MV, STEP_25_MV),
> +	regulator_desc_ldo(23, MIN_800_MV, STEP_25_MV),
> +	regulator_desc_ldo(24, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(25, MIN_800_MV, STEP_50_MV),
> +	regulator_desc_ldo(26, MIN_800_MV, STEP_50_MV),
>   	regulator_desc_buck1_4(1),
>   	regulator_desc_buck1_4(2),
>   	regulator_desc_buck1_4(3),
>   	regulator_desc_buck1_4(4),
>   	regulator_desc_buck5,
> -	regulator_desc_buck6_7(6),
> -	regulator_desc_buck6_7(7),
> -	regulator_desc_buck8,
> -	regulator_desc_buck9,
> -	regulator_desc_buck10,
> +	regulator_desc_buck6_10(6, MIN_600_MV, STEP_6_25_MV),
> +	regulator_desc_buck6_10(7, MIN_600_MV, STEP_6_25_MV),
> +	regulator_desc_buck6_10(8, MIN_800_MV, STEP_12_5_MV),
> +	regulator_desc_buck6_10(9, MIN_1500_MV, STEP_12_5_MV),
> +	regulator_desc_buck6_10(10, MIN_1000_MV, STEP_12_5_MV),
>   };
>
>   static int s2mpa01_pmic_probe(struct platform_device *pdev)
>

