Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3JSABL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 20:01:11 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:38672 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3JSABI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 20:01:08 -0400
MIME-Version: 1.0
In-Reply-To: <1382102719-5531-13-git-send-email-pdeschrijver@nvidia.com>
References: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
	<1382102719-5531-13-git-send-email-pdeschrijver@nvidia.com>
Date: Fri, 18 Oct 2013 17:01:05 -0700
X-Google-Sender-Auth: xgJRY6rkhWP7Ygg4Iy-M-ssqd2w
Message-ID: <CAL1qeaHkibgGV07CQZTmBK1pJUYt5CGTBv_jADaNtvy4bS6SDw@mail.gmail.com>
Subject: Re: [PATCH v5 12/15] clk: tegra: move PMC, fixed clocks to common files
From: Andrew Bresticker <abrestic@chromium.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> +       val = readl_relaxed(clk_base + OSC_CTRL);
> +       osc_idx = val >> OSC_CTRL_OSC_FREQ_SHIFT;
> +
> +       if (osc_idx < num)
> +               *osc_freq = input_freqs[osc_idx];

else *osc_freq = 0?

> +       clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
> +                                       CLK_SET_RATE_PARENT, 1, pll_ref_div);

It seems silly to have CLK_SET_RATE_PARENT on a clock that can't have
its rate changed.

> +       /* clk_32k */
> +       dt_clk = tegra_lookup_dt_id(tegra_clk_clk_32k, tegra_clks);
> +       if (dt_clk) {
> +               clk = clk_register_fixed_rate(NULL, "clk_32k", NULL,
> +                                       CLK_IS_ROOT, 32768);
> +               clk_register_clkdev(clk, "clk_32k", NULL);

Like with the audio clocks, I think this will be done tegra_register_devclks().

> +               *dt_clk = clk;
> +       }
> +
> +       /* clk_m_div2 */
> +       dt_clk = tegra_lookup_dt_id(tegra_clk_clk_m_div2, tegra_clks);
> +       if (dt_clk) {
> +               clk = clk_register_fixed_factor(NULL, "clk_m_div2", "clk_m",
> +                                       CLK_SET_RATE_PARENT, 1, 2);
> +               clk_register_clkdev(clk, "clk_m_div2", NULL);

Ditto.

> +               *dt_clk = clk;
> +       }
> +
> +       /* clk_m_div4 */
> +       dt_clk = tegra_lookup_dt_id(tegra_clk_clk_m_div4, tegra_clks);
> +       if (dt_clk) {
> +               clk = clk_register_fixed_factor(NULL, "clk_m_div4", "clk_m",
> +                                       CLK_SET_RATE_PARENT, 1, 4);
> +               clk_register_clkdev(clk, "clk_m_div4", NULL);

Ditto.

> +               clk = clk_register_gate(NULL, data->gate_name, data->mux_name,
> +                                       0, pmc_base + PMC_CLK_OUT_CNTRL,
> +                                       data->gate_shift, 0, &clk_out_lock);
> +               *dt_clk = clk;
> +               clk_register_clkdev(clk, data->dev_name, data->gate_name);

Ditto.

> +       }
> +
> +       /* blink */
> +       clk = clk_register_gate(NULL, "blink_override", "clk_32k", 0,
> +                               pmc_base + PMC_DPD_PADS_ORIDE,
> +                               PMC_DPD_PADS_ORIDE_BLINK_ENB, 0, NULL);
> +
> +       dt_clk = tegra_lookup_dt_id(tegra_clk_blink, tegra_clks);
> +       if (!dt_clk)
> +               return;
> +

In tegra*_pmc_clk_init, there's a write to PMC_BLINK_TIMER here.
Why'd that disappear?

> +       clk = clk_register_gate(NULL, "blink", "blink_override", 0,
> +                               pmc_base + PMC_CTRL,
> +                               PMC_CTRL_BLINK_ENB, 0, NULL);
> +       clk_register_clkdev(clk, "blink", NULL);

Same comment about the other register_clkdev calls above.

> +       *dt_clk = clk;
> +}

Thanks,
Andrew
