Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaGaMfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:35:00 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:56123 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaGaMe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:34:56 -0400
Message-ID: <53DA37EA.7010306@gmail.com>
Date: Thu, 31 Jul 2014 14:34:50 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Humberto Silva Naves <hsnaves@gmail.com>,
        linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCHv2 1/5] clk: samsung: exynos5410: Add NULL pointer checks
 in clock init
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com> <1406805732-17372-2-git-send-email-hsnaves@gmail.com>
In-Reply-To: <1406805732-17372-2-git-send-email-hsnaves@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Humberto,

Please see my comments inline.

On 31.07.2014 13:22, Humberto Silva Naves wrote:
> Added NULL pointer checks for device_node input parameter and
> for the samsung_clk_provider context returned by samsung_clk_init.
> Even though the *current* samsung_clk_init function never returns
> a NULL pointer, it is good to keep this check in place to avoid
> possible problems in the future due to changes in implementation.
> That way, we also improve the consistency of the code that performs
> clock initialization across the different SoCs.
> 
> Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
> ---
>  drivers/clk/samsung/clk-exynos5410.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/samsung/clk-exynos5410.c b/drivers/clk/samsung/clk-exynos5410.c
> index 231475b..bf57c80 100644
> --- a/drivers/clk/samsung/clk-exynos5410.c
> +++ b/drivers/clk/samsung/clk-exynos5410.c
> @@ -188,11 +188,17 @@ static void __init exynos5410_clk_init(struct device_node *np)
>  	struct samsung_clk_provider *ctx;
>  	void __iomem *reg_base;
>  
> -	reg_base = of_iomap(np, 0);
> -	if (!reg_base)
> -		panic("%s: failed to map registers\n", __func__);
> +	if (np) {

Since all Exynos-based boards are always booted using DT, this function
will never be called if there is no node for the clock controller and so
there is no way this pointer can end up being NULL. I don't see a point
in complicating this code with useless checks.

> +		reg_base = of_iomap(np, 0);
> +		if (!reg_base)
> +			panic("%s: failed to map registers\n", __func__);
> +	} else {
> +		panic("%s: unable to determine soc\n", __func__);
> +	}

As a side note, since panic() does not return, the code above could be
changed to follow rest of checks in this function:

	if (!np)
		panic("%s: unable to determine soc\n", __func__);

	reg_base = of_iomap(np, 0);
	...

leading to more readable code with less indentation and less changes to
existing code.

>  
>  	ctx = samsung_clk_init(np, reg_base, CLK_NR_CLKS);
> +	if (!ctx)
> +		panic("%s: unable to allocate context.\n", __func__);

samsung_clk_init() already panics on any error, although now as I think
of it, it probably should be changed with a patch to just error out and
let the caller handle the error. However callers don't need to be
changed before this is done.

Best regards,
Tomasz
