Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3JBLcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:32:48 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12680 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3JBLcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:32:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 02 Oct 2013 04:28:53 -0700
Message-ID: <524C09F4.1090906@nvidia.com>
Date: Wed, 2 Oct 2013 17:26:36 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>,
        Florian Lobmaier <florian.lobmaier@ams.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT][PATCH 1/2] regulator: as3722: Fix equation to calculate
 max_uV in regulator_lin_range macro
References: <1380641628.19681.3.camel@phoenix>
In-Reply-To: <1380641628.19681.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 October 2013 09:03 PM, Axel Lin wrote:
> Fix off-by-one in the equation to calculate max_uV.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi,
> I don't have the datasheet and h/w.
> Just found this issue while reading the code. (Only compile test).
>
> Axel
>   drivers/regulator/as3722-regulator.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
> index 16a5d26..c6a1fc6 100644
> --- a/drivers/regulator/as3722-regulator.c
> +++ b/drivers/regulator/as3722-regulator.c
> @@ -441,7 +441,7 @@ static struct regulator_ops as3722_ldo3_extcntrl_ops = {
>   		.max_sel = _max_sel,					\
>   		.uV_step = _step_uV,					\
>   		.min_uV = _min_uV,					\
> -		.max_uV = _min_uV + (_max_sel - _min_sel + 1) * _step_uV, \
> +		.max_uV = _min_uV + (_max_sel - _min_sel) * _step_uV,	\
>   	}
>   
>   static const struct regulator_linear_range as3722_ldo_ranges[] = {
The datasheet says:

The voltage select bits set the LDO output voltage 0.825V...3.3V, 25mV steps
   ....00h : LDO off
   01h-24h : V_LDO4=0.8V+ldo4_vsel*25mV
   25h-3Fh : do not use
   40h-7Fh : V_LDO4=1.725V+(ldo4_vsel-40h)*25mV

And put the linear range as
regulator_lin_range(0x01, 0x24,  800000, 25000),
regulator_lin_range(0x40, 0x7F, 1725000, 25000),


So as per datasheet, value 0x24 is equal to 1700mV.
                                      and 0x7F equal to 3300

I created equation based on first entry which is wrong for second entry 
and your equation is correct for second entry but break first one.

I think your equation is correct with following change:
regulator_lin_range(0x01, 0x24,  825000, 25000),


So it need to re-spin this patch.



