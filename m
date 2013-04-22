Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab3DVJUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:20:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9774 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3DVJUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:20:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 22 Apr 2013 02:17:55 -0700
Message-ID: <5174FFC3.70603@nvidia.com>
Date: Mon, 22 Apr 2013 14:45:47 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] regulator: palmas: Fix off-by-one for ramp_delay
 and register value mapping
References: <1366563522.10770.1.camel@phoenix>
In-Reply-To: <1366563522.10770.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 April 2013 10:28 PM, Axel Lin wrote:
> In probe(), we have below code to set ramp_delay:
> e.g. When reg is 2, current code set
> pmic->desc[id].ramp_delay = palmas_smps_ramp_delay[reg & 0x3];
>                            = 5000
> which means ramp_delay = 5000 is mapping to reg value = 2;
>
> However, in palmas_smps_set_ramp_delay()
>          ramp_delay = 5000 is mapping to reg value = 1.
>
> This patch fixes the off-by-one value range checking for ramp_delay in
> palmas_smps_set_ramp_delay().
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Laxman,
> I don't have the datasheet, so please check if this fix is correct.
>
> Thanks,
> Axel
>   drivers/regulator/palmas-regulator.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index 8fed60c..e3e8373 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -447,9 +447,9 @@ static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
>   
>   	if (ramp_delay <= 0)
>   		reg = 0;
> -	else if (ramp_delay < 2500)
> +	else if (ramp_delay <= 2500)From 6f6875db93eeff52d39623dd68522e1875cf5ef1 Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@ingics.com>
> Date: Mon, 22 Apr 2013 00:50:55 +0800
> Subject: [PATCH RFT] regulator: palmas: Fix off-by-one for ramp_delay and register value mapping
>
> In probe(), we have below code to set ramp_delay:
> e.g. When reg is 2, current code set
> pmic->desc[id].ramp_delay = palmas_smps_ramp_delay[reg & 0x3];
>                            = 5000
> which means ramp_delay = 5000 is mapping to reg value = 2;
>
> However, in palmas_smps_set_ramp_delay()
>          ramp_delay = 5000 is mapping to reg value = 1.
>
> This patch fixes the off-by-one value range checking for ramp_delay in
> palmas_smps_set_ramp_delay().
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Laxman,
> I don't have the datasheet, so please check if this fix is correct.
>

Datasheet says:
Time Step (TSTEP) selection, when changing the
output voltage, the new value is reached through
successive voltage steps (if not bypassed). The
equivalent programmable slew rate of the output
voltage is:
TSTEP[1:0]: 00 Jump (no slope control)
TSTEP[1:0]: 01 10mV/us
TSTEP[1:0]: 10 5mV/us (default)
TSTEP[1:0]: 11 2.5mV/us

