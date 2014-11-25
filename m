Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbaKYLf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:35:28 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33529 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbaKYLfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:35:25 -0500
MIME-Version: 1.0
In-Reply-To: <1416842312-4405-3-git-send-email-k.kozlowski@samsung.com>
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
	<1416842312-4405-3-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 25 Nov 2014 20:35:25 +0900
Message-ID: <CA+Ln22FTJ8AwNOq+jrA6dK=4ziGFwFT+Ofjr2zE4z=8B4f3QJw@mail.gmail.com>
Subject: Re: [RFC 2/2] clk: samsung: Fix clock disable failure because domain
 being gated
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

Please see my comments inline.

2014-11-25 0:18 GMT+09:00 Krzysztof Kozlowski <k.kozlowski@samsung.com>:
> +static int audss_clk_gate_enable(struct clk_hw *hw)
> +{
> +       int ret;
> +
> +       if (!IS_ERR(pll_in))
> +               clk_prepare_enable(pll_in);

Calling clk_prepare_enable() from enable() callback doesn't look like
a good idea, because enabling is not supposed to sleep, while
preparing might do so.

I guess you have to pre-prepare this clock in probe and then only call
enable here.

> +       ret = clk_gate_ops.enable(hw);
> +       if (!IS_ERR(pll_in))
> +               clk_disable_unprepare(pll_in);
> +
> +       return ret;
> +}

[snip]

> +/* TODO: Also mux and div */
> +const struct clk_ops audss_clk_gate_ops = {

nit: static const probably?

> +       .enable = audss_clk_gate_enable,
> +       .disable = audss_clk_gate_disable,
> +       .is_enabled = audss_clk_gate_is_enabled,
> +};

As for the approach itself, maybe you should simply register fully
custom clocks with clk_register(), without altering
clk_register_gate() at all and simply calling gate ops whenever
necessary? I don't know, just a loose idea.

By the way, this issue could be probably solved by integrating generic
clocks with regmap API, since regmap-mmio can automatically control a
clock.

Best regards,
Tomasz
