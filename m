Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab3HWV34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:29:56 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51154 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab3HWV3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:29:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Jisheng Zhang <jszhang@marvell.com>, <jszhang@marvell.com>,
        <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1377225242-5854-4-git-send-email-jszhang@marvell.com>
Cc: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <1377225242-5854-1-git-send-email-jszhang@marvell.com>
 <1377225242-5854-4-git-send-email-jszhang@marvell.com>
Message-ID: <20130823212950.8231.90154@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v2 3/4] clk: mvebu: add missing iounmap
Date: Fri, 23 Aug 2013 14:29:50 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jisheng Zhang (2013-08-22 19:34:01)
> Add missing iounmap to setup error path.
> 
> Change-Id: I4371569d14d7026aa9f90d7cd53f669d365fe26a

Please remove Change-Id's from the commit message for upstream patch
submissions in the future. I can remove this one, this time.

I've taken the patch into clk-next.

Regards,
Mike

> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>  drivers/clk/mvebu/clk-cpu.c |  4 +++-
>  drivers/clk/mvebu/common.c  | 18 ++++++++++++------
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
> index b0fbc07..1466865 100644
> --- a/drivers/clk/mvebu/clk-cpu.c
> +++ b/drivers/clk/mvebu/clk-cpu.c
> @@ -119,7 +119,7 @@ void __init of_cpu_clk_setup(struct device_node *node)
>  
>         cpuclk = kzalloc(ncpus * sizeof(*cpuclk), GFP_KERNEL);
>         if (WARN_ON(!cpuclk))
> -               return;
> +               goto cpuclk_out;
>  
>         clks = kzalloc(ncpus * sizeof(*clks), GFP_KERNEL);
>         if (WARN_ON(!clks))
> @@ -170,6 +170,8 @@ bail_out:
>                 kfree(cpuclk[ncpus].clk_name);
>  clks_out:
>         kfree(cpuclk);
> +cpuclk_out:
> +       iounmap(clock_complex_base);
>  }
>  
>  CLK_OF_DECLARE(armada_xp_cpu_clock, "marvell,armada-xp-cpu-clock",
> diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
> index adaa4a1..25ceccf 100644
> --- a/drivers/clk/mvebu/common.c
> +++ b/drivers/clk/mvebu/common.c
> @@ -45,8 +45,10 @@ void __init mvebu_coreclk_setup(struct device_node *np,
>         clk_data.clk_num = 2 + desc->num_ratios;
>         clk_data.clks = kzalloc(clk_data.clk_num * sizeof(struct clk *),
>                                 GFP_KERNEL);
> -       if (WARN_ON(!clk_data.clks))
> +       if (WARN_ON(!clk_data.clks)) {
> +               iounmap(base);
>                 return;
> +       }
>  
>         /* Register TCLK */
>         of_property_read_string_index(np, "clock-output-names", 0,
> @@ -134,7 +136,7 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
>  
>         ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
>         if (WARN_ON(!ctrl))
> -               return;
> +               goto ctrl_out;
>  
>         spin_lock_init(&ctrl->lock);
>  
> @@ -145,10 +147,8 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
>         ctrl->num_gates = n;
>         ctrl->gates = kzalloc(ctrl->num_gates * sizeof(struct clk *),
>                               GFP_KERNEL);
> -       if (WARN_ON(!ctrl->gates)) {
> -               kfree(ctrl);
> -               return;
> -       }
> +       if (WARN_ON(!ctrl->gates))
> +               goto gates_out;
>  
>         for (n = 0; n < ctrl->num_gates; n++) {
>                 const char *parent =
> @@ -160,4 +160,10 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
>         }
>  
>         of_clk_add_provider(np, clk_gating_get_src, ctrl);
> +
> +       return;
> +gates_out:
> +       kfree(ctrl);
> +ctrl_out:
> +       iounmap(base);
>  }
> -- 
> 1.8.4.rc3
