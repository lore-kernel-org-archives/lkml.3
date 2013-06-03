Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab3FCPtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:49:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60071 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3FCPtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:49:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        ulf.hansson@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 21/21] clk: ux500: Supply provider look-up functionality to support Device Tree
Date: Mon, 03 Jun 2013 17:49:54 +0200
Message-ID: <2458719.gboIs9CIQE@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370266965-7901-22-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org> <1370266965-7901-22-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4xFORhHjLskqlcKnbB23ITRHJ0PP1KqptZbvZHqmkGJ
 IkcITRkR7RG4wEedB/Ug7pBEhm8wuRzNSdvfOrYpnOh5yABjxF
 SNFspwwYsDP6Gdk1xUg2eIT5LjkfHk08HQWMNlx8fJsT0ZQqjY
 NS3X08BSU4+LP3Anv0QLtopoa+41ArSFluF0QXbdi7Rz6rQ3ja
 2ETkQRNIFBKqyX12k63mEovzLaXWq18ek1ubTcAAz7Xx588WM4
 lUZlv5QFmyu+RhtS1Urgv27kNqRLhXLtqTg91E4OpVKs2jq5s5
 iE3d88YdwgBe9IuDvC/St8eKCUUTRbsZRZA6Q/9Idcj9MT2N0r
 m99slXKm4fX04GUbRdA8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 14:42:45 Lee Jones wrote:
> In this patch we're populating a clk_data array, one clock per element to
> act as a clk look-up using indexes supplied from Device Tree.

This is the first time I actually take a closer look at clock bindings.
It feels odd to have a single index when you have multiple clock
providers in hardware.

> +struct clk *clks[CLK_MAX];
> +
> +const static struct of_device_id u8500_clk_of_match[] = {
> +	{ .compatible = "stericsson,u8500-clk", },
> +	{ },
> +};

>From the code in drivers/clk/ux500, I would have expected two separate
clock nodes: the prcmu and the prcc, each with their own number
space.

>  void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
>  		    u32 clkrst5_base, u32 clkrst6_base)
>  {
>  	struct prcmu_fw_version *fw_version;
>  	const char *sgaclk_parent = NULL;
> +	static struct clk_onecell_data clk_data;
> +	struct device_node *np = NULL;
>  	struct clk *clk;
>  
>  	/* Clock sources */
>  	clk = clk_reg_prcmu_gate("soc0_pll", NULL, PRCMU_PLLSOC0,
>  				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
>  	clk_register_clkdev(clk, "soc0_pll", NULL);
> +	clks[soc0_pll] = clk;
>  
>  	clk = clk_reg_prcmu_gate("soc1_pll", NULL, PRCMU_PLLSOC1,
>  				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
>  	clk_register_clkdev(clk, "soc1_pll", NULL);
> +	clks[soc1_pll] = clk;
>  
>  	clk = clk_reg_prcmu_gate("ddr_pll", NULL, PRCMU_PLLDDR,
>  				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
>  	clk_register_clkdev(clk, "ddr_pll", NULL);
> +	clks[ddr_pll] = clk;

It seems the actual numbers for the PCRMU clocks are defined
in drivers/mfd/dbx500-prcmu-regs.h, at PRCM_ACLK_MGT through
PRCM_MSP1CLK_MGT, where each clock has its own register.

> @@ -218,106 +296,130 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
>  	clk = clk_reg_prcc_pclk("p1_pclk0", "per1clk", clkrst1_base,
>  				BIT(0), 0);
>  	clk_register_clkdev(clk, "apb_pclk", "uart0");
> +	clks[uart0] = clk;
>  
>  	clk = clk_reg_prcc_pclk("p1_pclk1", "per1clk", clkrst1_base,
>  				BIT(1), 0);
>  	clk_register_clkdev(clk, "apb_pclk", "uart1");
> +	clks[uart1] = clk;
>  
>  	clk = clk_reg_prcc_pclk("p1_pclk2", "per1clk", clkrst1_base,
>  				BIT(2), 0);
>  	clk_register_clkdev(clk, "apb_pclk", "nmk-i2c.1");
> +	clks[nmk_i2c1] = clk;

The prcc clocks are inherently numbered, there is a set of six
registers with 8 bits each, so the number you use can simply
be the index from 0 to 48, or use #clock-cells=<2> and pass both.
Using the same numbers as the hardware in the binding is much less
ambiguous than making up your own number space that you have to
then document in the binding and update every time a new chip
gets released.

	Arnd
