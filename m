Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3HUISC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:18:02 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:38382 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3HUISA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <1370521041-32318-22-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
	<1370521041-32318-22-git-send-email-lee.jones@linaro.org>
Date: Wed, 21 Aug 2013 10:17:59 +0200
Message-ID: <CACRpkdY2KOxX=oA7i9GUnzpwRKiK2rXqTBPVpg+zW082f2TJdg@mail.gmail.com>
Subject: Re: [PATCH 21/33] clk: ux500: Add Device Tree support for the PRCC
 Kernel clock
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 2:17 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch enables clocks to be specified from Device Tree via phandles
> to the "prcc-kernel-clock" node.
>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
(...)
>  static struct clk *prcmu_clk[PRCMU_NUM_CLKS];
>  static struct clk *prcc_pclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
> +static struct clk *prcc_kclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
>
>  #define PRCC_SHOW(clk, base, bit) \
>         clk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit]
> @@ -540,110 +541,136 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
>         clk = clk_reg_prcc_kclk("p1_uart0_kclk", "uartclk",
>                         clkrst1_base, BIT(0), CLK_SET_RATE_GATE);
>         clk_register_clkdev(clk, NULL, "uart0");
> +       PRCC_KCLK_STORE(clk, 1, 0);
>
>         clk = clk_reg_prcc_kclk("p1_uart1_kclk", "uartclk",
>                         clkrst1_base, BIT(1), CLK_SET_RATE_GATE);
>         clk_register_clkdev(clk, NULL, "uart1");
> +       PRCC_KCLK_STORE(clk, 1, 1);

(etc)

On device tree boots, clk_register_clkdev() is obviously pointless,
as you're later deleting the AUXDATA connecting that device name
to the clock.

This should not be called at all on the DT boot path.

However this looks cluttered as well:

if (dt_probe)
  clk_register_clkdev(clk, NULL, "uart0");
else
  PRCC_KCLK_STORE(clk, 1, 0);

Isn't it possible to fork a function u8500_clk_init_dt() to add all the
clocks in the DT probe path and keep this function
u8500_clk_init() as it is?

Yours,
Linus Walleij
