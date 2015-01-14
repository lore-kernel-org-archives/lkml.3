Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbbANXC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 18:02:27 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51199 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbbANXC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 18:02:26 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Oleksij Rempel <linux@rempel-privat.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1420707567-22760-2-git-send-email-linux@rempel-privat.de>
Cc: "Oleksij Rempel" <linux@rempel-privat.de>
References: <1417187120-23659-1-git-send-email-linux@rempel-privat.de>
 <1420707567-22760-1-git-send-email-linux@rempel-privat.de>
 <1420707567-22760-2-git-send-email-linux@rempel-privat.de>
Message-ID: <20150114230217.22722.88458@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] ARM: clk: add clk-asm9260 driver
Date: Wed, 14 Jan 2015 15:02:17 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleksij Rempel (2015-01-08 00:59:27)
> diff --git a/drivers/clk/clk-asm9260.c b/drivers/clk/clk-asm9260.c
> new file mode 100644
> index 0000000..6b1c220
> --- /dev/null
> +++ b/drivers/clk/clk-asm9260.c

<snip>

> +static const char *clk_names[] = {
> +       [REFCLK]        = "oscillator",
> +       [SYSPLL]        = "pll",
> +       [I2S0_MCLK]     = "i2s0_mclk",
> +       [I2S1_MCLK]     = "i2s1_mclk",
> +       [RTC_OSC]       = "rtc_osc",
> +       [USB_PLL]       = "usb_pll",
> +};

Why keep this list of names? Only clk_names[REFCLK] is used below and it
is overwritten by the name supplied by DT.

<snip>

> +static void __init asm9260_acc_init(struct device_node *np)
> +{
> +       struct clk *clk;
> +       u32 rate;
> +       int n;
> +       u32 accuracy = 0;
> +
> +       base = of_io_request_and_map(np, 0, np->name);
> +       if (!base)
> +               panic("%s: unable to map resource", np->name);
> +
> +       /* register pll */
> +       rate = (ioread32(base + HW_SYSPLLCTRL) & 0xffff) * 1000000;
> +
> +       clk_names[REFCLK] = of_clk_get_parent_name(np, 0);
> +       accuracy = clk_get_accuracy(__clk_lookup(clk_names[REFCLK]));
> +       clk = clk_register_fixed_rate_with_accuracy(NULL, clk_names[SYSPLL],
> +                       clk_names[REFCLK], 0, rate, accuracy);

This is different. Why do the PLLs inherit REFCLKs accuracy? Please see
__clk_recalc_accuracies in drivers/clk/clk.c if you haven't already. We
propagate accuracy through the clock tree already.

> +
> +       if (IS_ERR(clk))
> +               panic("%s: can't register REFCLK. Check DT!", np->name);
> +
> +       for (n = 0; n < ARRAY_SIZE(asm9260_mux_clks); n++) {
> +               const struct asm9260_mux_clock *mc = &asm9260_mux_clks[n];
> +
> +               mc->parent_names[0] = clk_names[REFCLK];
> +               clk = clk_register_mux_table(NULL, mc->name, mc->parent_names,
> +                               mc->num_parents, mc->flags, base + mc->offset,
> +                               0, mc->mask, 0, mc->table, &asm9260_clk_lock);
> +       }
> +
> +       /* clock mux gate cells */
> +       for (n = 0; n < ARRAY_SIZE(asm9260_mux_gates); n++) {
> +               const struct asm9260_gate_data *gd = &asm9260_mux_gates[n];
> +
> +               clk = clk_register_gate(NULL, gd->name,
> +                       gd->parent_name, gd->flags | CLK_SET_RATE_PARENT,
> +                       base + gd->reg, gd->bit_idx, 0, &asm9260_clk_lock);
> +       }
> +
> +       /* clock div cells */
> +       for (n = 0; n < ARRAY_SIZE(asm9260_div_clks); n++) {
> +               const struct asm9260_div_clk *dc = &asm9260_div_clks[n];
> +
> +               clks[dc->idx] = clk_register_divider(NULL, dc->name,
> +                               dc->parent_name, CLK_SET_RATE_PARENT,
> +                               base + dc->reg, 0, 8, CLK_DIVIDER_ONE_BASED,
> +                               &asm9260_clk_lock);
> +       }
> +
> +       /* clock ahb gate cells */
> +       for (n = 0; n < ARRAY_SIZE(asm9260_ahb_gates); n++) {
> +               const struct asm9260_gate_data *gd = &asm9260_ahb_gates[n];
> +
> +               clks[gd->idx] = clk_register_gate(NULL, gd->name,
> +                               gd->parent_name, gd->flags, base + gd->reg,
> +                               gd->bit_idx, 0, &asm9260_clk_lock);
> +       }
> +
> +       /* check for errors on leaf clocks */
> +       for (n = 0; n < MAX_CLKS; n++) {
> +               if (!IS_ERR(clks[n]))
> +                       continue;
> +
> +               pr_err("%s: Unable to register leaf clock %d\n",
> +                               np->full_name, n);
> +               goto fail;
> +       }
> +
> +       /* register clk-provider */
> +       clk_data.clks = clks;
> +       clk_data.clk_num = MAX_CLKS;
> +       of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
> +       return;
> +fail:
> +       iounmap(base);
> +}
> +CLK_OF_DECLARE(asm9260_acc, "alphascale,asm9260-clock-controller",
> +               asm9260_acc_init);

Where is the DT binding definition for this clock provider?

Thanks,
Mike
