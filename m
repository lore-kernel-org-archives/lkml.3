Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaKQWqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:46:11 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51581 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaKQWqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:46:08 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "Jason Cooper" <jason@lakedaemon.net>, "Andrew Lunn" <andrew@lunn.ch>,
        "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>,
        "Gregory Clement" <gregory.clement@free-electrons.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1415978496-9334-9-git-send-email-thomas.petazzoni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, "Tawfik Bayouk" <tawfik@marvell.com>,
        "Nadav Haklai" <nadavh@marvell.com>,
        "Lior Amsalem" <alior@marvell.com>,
        "Ezequiel Garcia" <ezequiel.garcia@free-electrons.com>,
        devicetree@vger.kernel.org,
        "Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org
References: <1415978496-9334-1-git-send-email-thomas.petazzoni@free-electrons.com>
 <1415978496-9334-9-git-send-email-thomas.petazzoni@free-electrons.com>
Message-ID: <20141117224604.25314.96198@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCHv2 08/16] clk: mvebu: add suspend/resume for gatable clocks
Date: Mon, 17 Nov 2014 14:46:04 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Thomas Petazzoni (2014-11-14 07:21:28)
> This commit adds suspend/resume support for the gatable clock driver
> used on Marvell EBU platforms. When getting out of suspend, the
> Marvell EBU platforms go through the bootloader, which re-enables all
> gatable clocks. However, upon resume, the clock framework will not
> disable again all gatable clocks that are not used.
> 
> Therefore, if the clock driver does not save/restore the state of the
> gatable clocks, all gatable clocks that are not claimed by any device
> driver will remain enabled after a resume. This is why this driver
> saves and restores the state of those clocks.

It might be a good idea to call clk_disable_unused() from the clk core
after resuming from suspend.

> 
> Since clocks aren't real devices, we don't have the normal ->suspend()
> and ->resume() of the device model, and have to use the ->suspend()
> and ->resume() hooks of the syscore_ops mechanism. This mechanism has
> the unfortunate idea of not providing a way of passing private data,
> which requires us to change the driver to make the assumption that
> there is only once instance of the gatable clock control structure.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/clk/mvebu/common.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
> index b7fcb46..8799fb8 100644
> --- a/drivers/clk/mvebu/common.c
> +++ b/drivers/clk/mvebu/common.c
> @@ -19,6 +19,7 @@
>  #include <linux/io.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/syscore_ops.h>
>  
>  #include "common.h"
>  
> @@ -177,14 +178,18 @@ struct clk_gating_ctrl {
>         spinlock_t *lock;
>         struct clk **gates;
>         int num_gates;
> +       struct syscore_ops syscore_ops;

You are registering suspend/resume ops per clock. Have you considered
registering a single set of ops for your clock controller driver? See
drivers/clk/samsung/clk-exynos5420.c for an example.

Combined with a table of clocks registered by your driver, centralized
suspend/resume methods might be a cleaner solution.

Regards,
Mike

> +       void __iomem *base;
> +       u32 saved_reg;
>  };
>  
>  #define to_clk_gate(_hw) container_of(_hw, struct clk_gate, hw)
>  
> +static struct clk_gating_ctrl *ctrl;
> +
>  static struct clk *clk_gating_get_src(
>         struct of_phandle_args *clkspec, void *data)
>  {
> -       struct clk_gating_ctrl *ctrl = (struct clk_gating_ctrl *)data;
>         int n;
>  
>         if (clkspec->args_count < 1)
> @@ -199,15 +204,30 @@ static struct clk *clk_gating_get_src(
>         return ERR_PTR(-ENODEV);
>  }
>  
> +static int mvebu_clk_gating_suspend(void)
> +{
> +       ctrl->saved_reg = readl(ctrl->base);
> +       return 0;
> +}
> +
> +static void mvebu_clk_gating_resume(void)
> +{
> +       writel(ctrl->saved_reg, ctrl->base);
> +}
> +
>  void __init mvebu_clk_gating_setup(struct device_node *np,
>                                    const struct clk_gating_soc_desc *desc)
>  {
> -       struct clk_gating_ctrl *ctrl;
>         struct clk *clk;
>         void __iomem *base;
>         const char *default_parent = NULL;
>         int n;
>  
> +       if (ctrl) {
> +               pr_err("mvebu-clk-gating: cannot instantiate more than one gatable clock device\n");
> +               return;
> +       }
> +
>         base = of_iomap(np, 0);
>         if (WARN_ON(!base))
>                 return;
> @@ -225,6 +245,10 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
>         /* lock must already be initialized */
>         ctrl->lock = &ctrl_gating_lock;
>  
> +       ctrl->base = base;
> +       ctrl->syscore_ops.suspend = mvebu_clk_gating_suspend;
> +       ctrl->syscore_ops.resume = mvebu_clk_gating_resume;
> +
>         /* Count, allocate, and register clock gates */
>         for (n = 0; desc[n].name;)
>                 n++;
> @@ -246,6 +270,8 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
>  
>         of_clk_add_provider(np, clk_gating_get_src, ctrl);
>  
> +       register_syscore_ops(&ctrl->syscore_ops);
> +
>         return;
>  gates_out:
>         kfree(ctrl);
> -- 
> 2.1.0
> 
