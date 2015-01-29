Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbbA2NbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:31:18 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61790 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbbA2NbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:31:15 -0500
MIME-Version: 1.0
In-Reply-To: <1422011024-32283-5-git-send-email-tomeu.vizoso@collabora.com>
References: <1422011024-32283-1-git-send-email-tomeu.vizoso@collabora.com>
	<1422011024-32283-5-git-send-email-tomeu.vizoso@collabora.com>
Date: Thu, 29 Jan 2015 14:31:12 +0100
X-Google-Sender-Auth: fsJXt3B-p_PzKf_aPxLGOQ29APw
Message-ID: <CAMuHMdUGgA70o2SgdJR3X6AkCcMssHU0POLfzppADT-O=BrYDw@mail.gmail.com>
Subject: Re: [PATCH v13 4/6] clk: Add rate constraints to clocks
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Jonathan Corbet <corbet@lwn.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Tero Kristo <t-kristo@ti.com>, Manuel Lauss <manuel.lauss@gmail.com>,
        Alex Elder <elder@linaro.org>, Matt Porter <mporter@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Bintian Wang <bintian.wang@huawei.com>,
        Chao Xie <chao.xie@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomeu, Mike,

On Fri, Jan 23, 2015 at 12:03 PM, Tomeu Vizoso
<tomeu.vizoso@collabora.com> wrote:
> Adds a way for clock consumers to set maximum and minimum rates. This
> can be used for thermal drivers to set minimum rates, or by misc.
> drivers to set maximum rates to assure a minimum performance level.
>
> Changes the signature of the determine_rate callback by adding the
> parameters min_rate and max_rate.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

This is now in clk-next, and causes division by zeroes on all shmobile
platforms that use renesas,cpg-div6-clock (verified on r8a73a4, r8a7740,
r8a7791, sh73a0):

Division by zero in kernel.
CPU: 0 PID: 0 Comm: swapper/0 Not tainted
3.19.0-rc6-koelsch-04360-g48d797d57c5932c8-dirty #792
Hardware name: Generic R8A7791 (Flattened Device Tree)
Backtrace:
[<c001216c>] (dump_backtrace) from [<c001238c>] (show_stack+0x18/0x1c)
 r6:c051b124 r5:00000000 r4:00000000 r3:00200000
[<c0012374>] (show_stack) from [<c03955d0>] (dump_stack+0x78/0x94)
[<c0395558>] (dump_stack) from [<c00122f4>] (__div0+0x18/0x20)
 r4:2e7ddb00 r3:c05093c8
[<c00122dc>] (__div0) from [<c01bdc9c>] (Ldiv0+0x8/0x10)
[<c02d8efc>] (cpg_div6_clock_round_rate) from [<c02d56a0>]
(clk_calc_new_rates+0xc8/0x1d4)
 r4:eec14e00 r3:c03cb52c
[<c02d55d8>] (clk_calc_new_rates) from [<c02d57f4>]
(clk_core_set_rate_nolock+0x48/0x90)
 r9:eec02f40 r8:00000001 r7:c051b0b8 r6:c051b124 r5:00000000 r4:eec14e00
[<c02d57ac>] (clk_core_set_rate_nolock) from [<c02d6848>] (__clk_put+0x78/0xdc)
 r7:c051b0b8 r6:c051b124 r5:eec08100 r4:eec029c0
[<c02d67d0>] (__clk_put) from [<c02d3238>] (clk_put+0x10/0x14)
 r5:eec08100 r4:00000000
[<c02d3228>] (clk_put) from [<c04db4d0>] (of_clk_init+0x144/0x178)
[<c04db38c>] (of_clk_init) from [<c04dbd34>] (rcar_gen2_clocks_init+0x1c/0x24)
 r10:c04ed098 r9:c05023c0 r8:ffffffff r7:19432124 r6:c0502404 r5:00989680
 r4:f0006000
[<c04dbd18>] (rcar_gen2_clocks_init) from [<c04c6a3c>]
(rcar_gen2_timer_init+0x130/0x14c)
[<c04c690c>] (rcar_gen2_timer_init) from [<c04c15b4>] (time_init+0x24/0x38)
 r7:00000000 r6:c0520c80 r5:00000000 r4:ef7fcbc0
[<c04c1590>] (time_init) from [<c04bdb84>] (start_kernel+0x248/0x3bc)
[<c04bd93c>] (start_kernel) from [<40008084>] (0x40008084)
 r10:00000000 r9:413fc0f2 r8:40007000 r7:c0505870 r6:c04ed094 r5:c0502440
 r4:c0521054


> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c

> @@ -2391,25 +2543,24 @@ int __clk_get(struct clk *clk)
>         return 1;
>  }
>
> -static void clk_core_put(struct clk_core *core)
> +void __clk_put(struct clk *clk)
>  {
>         struct module *owner;
>
> -       owner = core->owner;
> +       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> +               return;
>
>         clk_prepare_lock();
> -       kref_put(&core->ref, __clk_release);
> +
> +       hlist_del(&clk->child_node);
> +       clk_core_set_rate_nolock(clk->core, clk->core->req_rate);

At this point, clk->core->req_rate is still zero, causing
cpg_div6_clock_round_rate() to be called with a zero "rate" parameter,
e.g. on r8a7791:

cpg_div6_clock_round_rate: clock sd2 rate 0 parent_rate 780000000 div 1
cpg_div6_clock_round_rate: clock sd1 rate 0 parent_rate 780000000 div 1
cpg_div6_clock_round_rate: clock mmc0 rate 0 parent_rate 780000000 div 1
cpg_div6_clock_round_rate: clock sd1 rate 0 parent_rate 780000000 div 1
cpg_div6_clock_round_rate: clock sd1 rate 0 parent_rate 780000000 div 1
cpg_div6_clock_round_rate: clock sd2 rate 0 parent_rate 780000000 div 1
cpg_div6_clock_round_rate: clock sd2 rate 0 parent_rate 780000000 div 1

and cpg_div6_clock_calc_div() is called to calculate

        div = DIV_ROUND_CLOSEST(parent_rate, rate);

Why was this call to clk_core_set_rate_nolock() in __clk_put() added?
Before, there was no rate setting done at this point, and
cpg_div6_clock_round_rate() was not called.

Have the semantics changed? Should .round_rate() be ready to
accept a "zero" rate, and use e.g. the current rate instead?

> +       owner = clk->core->owner;
> +       kref_put(&clk->core->ref, __clk_release);
> +
>         clk_prepare_unlock();
>
>         module_put(owner);
> -}
> -
> -void __clk_put(struct clk *clk)
> -{
> -       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> -               return;
>
> -       clk_core_put(clk->core);
>         kfree(clk);
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
