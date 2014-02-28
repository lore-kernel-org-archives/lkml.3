Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaB1RRC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:17:02 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:48058 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaB1RQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:16:59 -0500
Message-ID: <5310C473.7030304@elopez.com.ar>
Date: Fri, 28 Feb 2014 14:16:35 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH v2 2/5] clk: sun6i: Reparent AHB clock on PLL6
References: <1393605440-14643-1-git-send-email-maxime.ripard@free-electrons.com> <1393605440-14643-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1393605440-14643-3-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 28/02/14 13:37, Maxime Ripard escribió:
> In order for the DMA controller to work for SDRAM to devices transfers, the AHB
> clock should be reparented on the PLL6.
>
> Force that parenting in the clock driver.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>   drivers/clk/sunxi/clk-sunxi.c | 18 +++++++++++++++++-
>   1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index f6f61cc..a5c5882 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -1286,7 +1286,7 @@ static void __init of_sunxi_table_clock_setup(const struct of_device_id *clk_mat
>    */
>   static void __init sunxi_clock_protect(void)
>   {
> -	struct clk *clk;
> +	struct clk *clk, *parent;
>
>   	/* memory bus clock - sun5i+ */
>   	clk = clk_get(NULL, "mbus");
> @@ -1307,6 +1307,22 @@ static void __init sunxi_clock_protect(void)
>   	if (!IS_ERR(clk))
>   		clk_prepare_enable(clk);
>
> +	clk = clk_get(NULL, "ahb1_mux");
> +	if (IS_ERR(clk)) {
> +		pr_err("Couldn't get AHB1 Mux\n");
> +		return;
> +	}
> +
> +	parent = clk_get(NULL, "pll6");
> +	if (IS_ERR(clk)) {
> +		pr_err("Couldn't get PLL6\n");
> +		return;
> +	}

Remember this runs on every sunxi, but this bit of magic is sun6i only. 
We'll get bogus messages on the other platforms if this goes as is. You 
could do something like the following:

 > +	clk = clk_get(NULL, "ahb1_mux");
 > +	parent = clk_get(NULL, "pll6");
 > +	if (!IS_ERR(clk) && !IS_ERR(parent))
 > +		clk_set_parent(...)

If these things become more common, we may need to consider a 
per-platform fixup function or something.

Cheers,

Emilio
