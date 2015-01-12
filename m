Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbbALXxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:53:06 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58345 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbbALXxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:53:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Robert Jarzmik <robert.jarzmik@free.fr>, "Daniel Mack" <daniel@zonque.org>,
        "Haojian Zhuang" <haojian.zhuang@gmail.com>,
        "Robert Jarzmik" <robert.jarzmik@free.fr>,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        "Arnd Bergmann" <arnd@arndb.de>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1419688528-760-5-git-send-email-robert.jarzmik@free.fr>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1419688528-760-1-git-send-email-robert.jarzmik@free.fr>
 <1419688528-760-5-git-send-email-robert.jarzmik@free.fr>
Message-ID: <20150112235256.20842.68349@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 4/4] clk: pxa: add missing pxa27x clocks for Irda and sa1100-rtc
Date: Mon, 12 Jan 2015 15:52:56 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Robert Jarzmik (2014-12-27 05:55:28)
> Add 2 clocks which were erronously forgotten by the clock framework
> port, namely :
>  - sa1100-rtc
>  - irda for pxa2xx-ir:UARTCLK
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Acked-by: Michael Turquette <mturquette@linaro.org>

> ---
>  drivers/clk/pxa/clk-pxa27x.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/clk/pxa/clk-pxa27x.c b/drivers/clk/pxa/clk-pxa27x.c
> index 2b8343a..9a31b77 100644
> --- a/drivers/clk/pxa/clk-pxa27x.c
> +++ b/drivers/clk/pxa/clk-pxa27x.c
> @@ -353,6 +353,34 @@ static u8 clk_pxa27x_memory_get_parent(struct clk_hw *hw)
>  PARENTS(clk_pxa27x_memory) = { "osc_13mhz", "system_bus", "run" };
>  MUX_RO_RATE_RO_OPS(clk_pxa27x_memory, "memory");
>  
> +#define DUMMY_CLK(_con_id, _dev_id, _parent) \
> +       { .con_id = _con_id, .dev_id = _dev_id, .parent = _parent }
> +struct dummy_clk {
> +       const char *con_id;
> +       const char *dev_id;
> +       const char *parent;
> +};
> +static struct dummy_clk dummy_clks[] __initdata = {
> +       DUMMY_CLK(NULL, "pxa27x-gpio", "osc_32_768khz"),
> +       DUMMY_CLK(NULL, "sa1100-rtc", "osc_32_768khz"),
> +       DUMMY_CLK("UARTCLK", "pxa2xx-ir", "STUART"),
> +};
> +
> +static void __init pxa27x_dummy_clocks_init(void)
> +{
> +       struct clk *clk;
> +       struct dummy_clk *d;
> +       const char *name;
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(dummy_clks); i++) {
> +               d = &dummy_clks[i];
> +               name = d->dev_id ? d->dev_id : d->con_id;
> +               clk = clk_register_fixed_factor(NULL, name, d->parent, 0, 1, 1);
> +               clk_register_clkdev(clk, d->con_id, d->dev_id);
> +       }
> +}
> +
>  static void __init pxa27x_base_clocks_init(void)
>  {
>         pxa27x_register_plls();
> @@ -365,6 +393,7 @@ static void __init pxa27x_base_clocks_init(void)
>  int __init pxa27x_clocks_init(void)
>  {
>         pxa27x_base_clocks_init();
> +       pxa27x_dummy_clocks_init();
>         return clk_pxa_cken_init(pxa27x_clocks, ARRAY_SIZE(pxa27x_clocks));
>  }
>  
> -- 
> 2.1.0
> 
