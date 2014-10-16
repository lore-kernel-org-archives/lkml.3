Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaJPTRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:17:21 -0400
Received: from gloria.sntech.de ([95.129.55.99]:42148 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaJPTRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:17:20 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jianqun <jay.xu@rock-chips.com>
Cc: mturquette@linaro.org, dianders@chromium.org, kever.yang@rock-chips.com,
        dbasehore@chromium.org, mark.yao@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [PATCH v2] clk: rockchip: rk3288: i2s_frac adds flag to set parent's rate
Date: Thu, 16 Oct 2014 21:17:06 +0200
Message-ID: <5441807.rM669MWZMA@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1413161056-10273-1-git-send-email-jay.xu@rock-chips.com>
References: <1412046724-28069-1-git-send-email-jay.xu@rock-chips.com> <1413161056-10273-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianqun,

Am Montag, 13. Oktober 2014, 08:44:16 schrieb Jianqun:
> The relation of i2s nodes as follows:
>           i2s_src               1           1            594000000  0
>              i2s_frac           1           1            11289600   0
>                 i2s_pre         1           1            11289600   0
>                    sclk_i2s0    1           1            11289600   0
>                    i2s0_clkout  0           0            11289600   0
>                       hclk_i2s0 1           1            148500000  0
> 
> "sclk_i2s0" is the master clock, should allow to set its parent's rate.
> Add flag CLK_SET_RATE_PARENT for "i2s_frac", "i2s_pre" and "sclk_i2s0".
> 
> Tested on rk3288 board using max98090, with command "aplay <music.wav>"
> and cat /sys/kernel/debug/clk/clk_summary |grep i2s
> 
> Signed-off-by: Jianqun <jay.xu@rock-chips.com>

It looks like this is already in the mainline kernel [0].

It seems like I didn't catch the "Change-Id" at the time, and it is the 
variant where i2s_clkout can set the parent rates.

Could you do a follow-up patch removing the CLK_SET_RATE_PARENT from 
i2s_clkout again please?


Thanks
Heiko

[0] 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=fc69ed70c16a31d6a77ec47a30a9fe941f763f1e

> ---
> change since v1:
> - no "Change-Id"s in upstream patches, suggested by Heiko
> - to limit i2s0_clkout to select between its two parent without being able
>   influence the core i2s clock, suggested by Heiko
> 
>  drivers/clk/rockchip/clk-rk3288.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3288.c
> b/drivers/clk/rockchip/clk-rk3288.c index b22a2d2..ae32d78 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -238,15 +238,15 @@ static struct rockchip_clk_branch
> rk3288_clk_branches[] __initdata = { COMPOSITE(0, "i2s_src",
> mux_pll_src_cpll_gpll_p, 0,
>  			RK3288_CLKSEL_CON(4), 15, 1, MFLAGS, 0, 7, DFLAGS,
>  			RK3288_CLKGATE_CON(4), 1, GFLAGS),
> -	COMPOSITE_FRAC(0, "i2s_frac", "i2s_src", 0,
> +	COMPOSITE_FRAC(0, "i2s_frac", "i2s_src", CLK_SET_RATE_PARENT,
>  			RK3288_CLKSEL_CON(8), 0,
>  			RK3288_CLKGATE_CON(4), 2, GFLAGS),
> -	MUX(0, "i2s_pre", mux_i2s_pre_p, 0,
> +	MUX(0, "i2s_pre", mux_i2s_pre_p, CLK_SET_RATE_PARENT,
>  			RK3288_CLKSEL_CON(4), 8, 2, MFLAGS),
>  	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, 0,
>  			RK3288_CLKSEL_CON(4), 12, 1, MFLAGS,
>  			RK3288_CLKGATE_CON(4), 0, GFLAGS),
> -	GATE(SCLK_I2S0, "sclk_i2s0", "i2s_pre", 0,
> +	GATE(SCLK_I2S0, "sclk_i2s0", "i2s_pre", CLK_SET_RATE_PARENT,
>  			RK3288_CLKGATE_CON(4), 3, GFLAGS),
> 
>  	MUX(0, "spdif_src", mux_pll_src_cpll_gpll_p, 0,

