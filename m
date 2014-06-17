Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965260AbaFQVX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:23:27 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:42855 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976AbaFQVXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:23:24 -0400
MIME-Version: 1.0
In-Reply-To: <1403016777-15121-6-git-send-email-wens@csie.org>
References: <1403016777-15121-1-git-send-email-wens@csie.org> <1403016777-15121-6-git-send-email-wens@csie.org>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 17 Jun 2014 16:23:02 -0500
Message-ID: <CAL_JsqLyXwQzd9Oxj9pb49fWqzMjV9=1Nx3i+9bN-rwfEMqwcQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/20] clk: sunxi: Support factor clocks with N
 multiplier factor starting from 1
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-sunxi@googlegroups.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 9:52 AM, Chen-Yu Tsai <wens@csie.org> wrote:
> The PLLs on newer Allwinner SoC's, such as the A31 and A23, have a
> N multiplier factor that starts from 1, not 0.
>
> This patch adds an option to the clock driver's config data structures
> to define the difference.
>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/clk/sunxi/clk-factors.c | 5 ++++-
>  drivers/clk/sunxi/clk-factors.h | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-factors.c
> index 3806d97..399cf4d 100644
> --- a/drivers/clk/sunxi/clk-factors.c
> +++ b/drivers/clk/sunxi/clk-factors.c
> @@ -62,7 +62,10 @@ static unsigned long clk_factors_recalc_rate(struct clk_hw *hw,
>                 p = FACTOR_GET(config->pshift, config->pwidth, reg);
>
>         /* Calculate the rate */
> -       rate = (parent_rate * n * (k + 1) >> p) / (m + 1);
> +       if (config->n_from_one)
> +               rate = (parent_rate * (n + 1) * (k + 1) >> p) / (m + 1);
> +       else
> +               rate = (parent_rate * n * (k + 1) >> p) / (m + 1);

This can be simplified and support any base with:

rate = (parent_rate * (n + config->n_base) * (k + 1) >> p) / (m + 1);
