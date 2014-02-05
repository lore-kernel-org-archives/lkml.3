Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaBEIyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:54:52 -0500
Received: from 9.mo3.mail-out.ovh.net ([87.98.184.141]:44869 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751295AbaBEIyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:54:46 -0500
Message-ID: <52F1FC52.1040205@overkiz.com>
Date: Wed, 05 Feb 2014 09:54:42 +0100
From: Boris BREZILLON <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com,
        mturquette@linaro.org
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jason@lakedaemon.net
Subject: Re: [PATCH v2 4/4] clk: at91: optimization of the determine_rate
 callback
References: <1391589458-28018-1-git-send-email-jjhiblot@traphandler.com> <1391589458-28018-5-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1391589458-28018-5-git-send-email-jjhiblot@traphandler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 18184409397368551513
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JJ,

I guess you're commit message is wrong: you're optimizing set_rate not 
determine_rate.

Best Regards,

Boris

On 05/02/2014 09:37, Jean-Jacques Hiblot wrote:
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>   drivers/clk/at91/clk-programmable.c | 38 ++++++++-----------------------------
>   1 file changed, 8 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
> index 7bcc725..62e2509 100644
> --- a/drivers/clk/at91/clk-programmable.c
> +++ b/drivers/clk/at91/clk-programmable.c
> @@ -139,43 +139,21 @@ static int clk_programmable_set_rate(struct clk_hw *hw, unsigned long rate,
>   	struct clk_programmable *prog = to_clk_programmable(hw);
>   	struct at91_pmc *pmc = prog->pmc;
>   	const struct clk_programmable_layout *layout = prog->layout;
> -	unsigned long best_rate = parent_rate;
> -	unsigned long best_diff;
> -	unsigned long new_diff;
> -	unsigned long cur_rate;
> +	unsigned long div = parent_rate / rate;
>   	int shift = 0;
>   	u32 tmp = pmc_read(pmc, AT91_PMC_PCKR(prog->id)) &
>   		  ~(PROG_PRES_MASK << layout->pres_shift);
>   
> -	if (rate > parent_rate)
> -		return parent_rate;
> -	else
> -		best_diff = parent_rate - rate;
> +	if (!div)
> +		return -EINVAL;
>   
> -	if (!best_diff) {
> -		pmc_write(pmc, AT91_PMC_PCKR(prog->id), tmp | shift);
> -		return 0;
> -	}
> -
> -	for (shift = 1; shift < PROG_PRES_MASK; shift++) {
> -		cur_rate = parent_rate >> shift;
> -
> -		if (cur_rate > rate)
> -			new_diff = cur_rate - rate;
> -		else
> -			new_diff = rate - cur_rate;
> -
> -		if (!new_diff)
> -			break;
> +	shift = fls(div) - 1;
>   
> -		if (new_diff < best_diff) {
> -			best_diff = new_diff;
> -			best_rate = cur_rate;
> -		}
> +	if (div != (1<<shift))
> +		return -EINVAL;
>   
> -		if (rate > cur_rate)
> -			break;
> -	}
> +	if (shift >= PROG_PRES_MASK)
> +		return -EINVAL;
>   
>   	pmc_write(pmc, AT91_PMC_PCKR(prog->id),
>   		  tmp | (shift << layout->pres_shift));

