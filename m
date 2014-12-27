Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaL0P3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 10:29:51 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:30786 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaL0P3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 10:29:44 -0500
X-ME-Helo: beldin.home
X-ME-Date: Sat, 27 Dec 2014 16:29:36 +0100
X-ME-IP: 109.222.86.28
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] arm: pxa: change clocks init sequence
Date: Sat, 27 Dec 2014 14:55:25 +0100
Message-Id: <1419688528-760-2-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419688528-760-1-git-send-email-robert.jarzmik@free.fr>
References: <1419688528-760-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since pxa clocks were ported to the clock framework, an ordering issue
appears between clocks and clocksource initialization. As a consequence,
the pxa timer clock cannot be acquired in pxa_timer, and is disabled by
clock framework because it is "unused".

The ordering issue is that in the kernel boot sequence :
  start_kernel()
    ...
    time_init()
      -> pxa_timer()
        -> here the clocksource is initialized
    ...
    rest_init()
      kernel_init()
	initcalls
	  -> here the clocks are initialized

In the current sequence, the clocks are initialized way after pxa_timer,
which cannot acquire the OSTIMER0 clock.

To solve this issue, the clocks initialization is moved to pxa_timer(),
so that clocks are initialized before clocksource for non device-tree.
For device-tree, the standard arm time_init() will take care of the
ordering.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/mach-pxa/generic.c  | 4 ++++
 arch/arm/mach-pxa/generic.h  | 2 ++
 drivers/clk/pxa/clk-pxa27x.c | 3 +--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
index 04b013f..d988c53 100644
--- a/arch/arm/mach-pxa/generic.c
+++ b/arch/arm/mach-pxa/generic.c
@@ -63,6 +63,10 @@ EXPORT_SYMBOL(get_clock_tick_rate);
  */
 void __init pxa_timer_init(void)
 {
+	if (cpu_is_pxa25x())
+		pxa25x_clocks_init();
+	if (cpu_is_pxa27x())
+		pxa27x_clocks_init();
 	pxa_timer_nodt_init(IRQ_OST0, io_p2v(0x40a00000),
 			    get_clock_tick_rate());
 }
diff --git a/arch/arm/mach-pxa/generic.h b/arch/arm/mach-pxa/generic.h
index 7a9fa1a..149087c 100644
--- a/arch/arm/mach-pxa/generic.h
+++ b/arch/arm/mach-pxa/generic.h
@@ -26,11 +26,13 @@ extern void pxa_timer_init(void);
 #define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
 
 #define pxa25x_handle_irq icip_handle_irq
+extern int __init pxa25x_clocks_init(void);
 extern void __init pxa25x_init_irq(void);
 extern void __init pxa25x_map_io(void);
 extern void __init pxa26x_init_irq(void);
 
 #define pxa27x_handle_irq ichp_handle_irq
+extern int __init pxa27x_clocks_init(void);
 extern void __init pxa27x_dt_init_irq(void);
 extern unsigned	pxa27x_get_clk_frequency_khz(int);
 extern void __init pxa27x_init_irq(void);
diff --git a/drivers/clk/pxa/clk-pxa27x.c b/drivers/clk/pxa/clk-pxa27x.c
index 5f9b54b..2b8343a 100644
--- a/drivers/clk/pxa/clk-pxa27x.c
+++ b/drivers/clk/pxa/clk-pxa27x.c
@@ -362,12 +362,11 @@ static void __init pxa27x_base_clocks_init(void)
 	clk_register_clk_pxa27x_lcd_base();
 }
 
-static int __init pxa27x_clocks_init(void)
+int __init pxa27x_clocks_init(void)
 {
 	pxa27x_base_clocks_init();
 	return clk_pxa_cken_init(pxa27x_clocks, ARRAY_SIZE(pxa27x_clocks));
 }
-postcore_initcall(pxa27x_clocks_init);
 
 static void __init pxa27x_dt_clocks_init(struct device_node *np)
 {
-- 
2.1.0

