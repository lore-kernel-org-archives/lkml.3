Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbbAENN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:13:59 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:34727 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbbAENN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:13:57 -0500
MIME-Version: 1.0
In-Reply-To: <30876083.4tlAgq9Aak@wasted.cogentembedded.com>
References: <30876083.4tlAgq9Aak@wasted.cogentembedded.com>
Date: Mon, 5 Jan 2015 14:13:55 +0100
X-Google-Sender-Auth: Y6KMRbrXHdTWps1pKUWjZDeBX_M
Message-ID: <CAMuHMdXW=_bYbdUGB2TBPFNfz9gBB+AyD1mWyoKD9eFxebma5w@mail.gmail.com>
Subject: Re: [PATCH v2] clk-rcar-gen2: ADSP clock support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Tue, Dec 30, 2014 at 9:51 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Add the ADSP clock support to the R-Car generation 2 CPG driver.  This clock
> gets derived from  PLL1.  The layout of the ADSPCKCR register is  similar to
> those of the clocks supported by the 'clk-div6' driver but the divider encoding
> is non-linear, so can't be supported by that driver...
>
> Based on the original patch by Konstantin Kozhevnikov
> <konstantin.kozhevnikov@cogentembedded.com>.
>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>
> ---
> The patch is against the 'clk-next' branch of Mike Turquette's 'linux.git' repo
> plus the RCAN clock support patch posted last week.
>
> Changes in version 2:
> - swapped "adsp" and "rcan" in the binding document.

> +++ linux/drivers/clk/shmobile/clk-rcar-gen2.c
> @@ -33,6 +33,7 @@ struct rcar_gen2_cpg {
>  #define CPG_FRQCRC                     0x000000e0
>  #define CPG_FRQCRC_ZFC_MASK            (0x1f << 8)
>  #define CPG_FRQCRC_ZFC_SHIFT           8
> +#define CPG_ADSPCKCR                   0x0000025c
>  #define CPG_RCANCKCR                   0x00000270
>
>  /* -----------------------------------------------------------------------------
> @@ -162,6 +163,51 @@ static struct clk * __init cpg_z_clk_reg
>         return clk;
>  }
>
> +/* ADSP divisors */
> +static const struct clk_div_table cpg_adsp_div_table[] = {
> +       {  1,  3 }, {  2,  4 }, {  3,  6 }, {  4,  8 },
> +       {  5, 12 }, {  6, 16 }, {  7, 18 }, {  8, 24 },
> +       { 10, 36 }, { 11, 48 }, {  0,  0 },
> +};
> +
> +static struct clk * __init cpg_adsp_clk_register(struct rcar_gen2_cpg *cpg)
> +{
> +       const char *parent_name = "pll1";
> +       struct clk_divider *div;
> +       struct clk_gate *gate;
> +       struct clk *clk;
> +
> +       div = kzalloc(sizeof(*div), GFP_KERNEL);
> +       if (!div)
> +               return ERR_PTR(-ENOMEM);
> +
> +       div->reg = cpg->reg + CPG_ADSPCKCR;
> +       div->width = 4;
> +       div->table = cpg_adsp_div_table;
> +       div->lock = &cpg->lock;
> +
> +       gate = kzalloc(sizeof(*gate), GFP_KERNEL);
> +       if (!gate) {
> +               kfree(div);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       gate->reg = cpg->reg + CPG_RCANCKCR;

Shouldn't this be CPG_ADSPCKCR?

> +       gate->bit_idx = 8;
> +       gate->flags = CLK_GATE_SET_TO_DISABLE;
> +       gate->lock = &cpg->lock;
> +
> +       clk = clk_register_composite(NULL, "adsp", &parent_name, 1, NULL, NULL,
> +                                    &div->hw, &clk_divider_ops,
> +                                    &gate->hw, &clk_gate_ops, 0);
> +       if (IS_ERR(clk)) {
> +               kfree(gate);
> +               kfree(div);
> +       }
> +
> +       return clk;
> +}

Please insert the adsp code after the rcan code, to match the clock order
in bindings and #defines.

> +
>  static struct clk * __init cpg_rcan_clk_register(struct rcar_gen2_cpg *cpg,
>                                                  struct device_node *np)
>  {
> @@ -301,6 +347,8 @@ rcar_gen2_cpg_register_clock(struct devi
>                 shift = 0;
>         } else if (!strcmp(name, "z")) {
>                 return cpg_z_clk_register(cpg);
> +       } else if (!strcmp(name, "adsp")) {
> +               return cpg_adsp_clk_register(cpg);

Please insert the adsp code after the rcan code.

>         } else if (!strcmp(name, "rcan")) {
>                 return cpg_rcan_clk_register(cpg, np);
>         } else {

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
