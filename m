Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbaGCNXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:23:15 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:50934 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834AbaGCNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:23:10 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH v2 03/11] MIPS: Alchemy: platform: use clk framework for uarts
Date: Thu,  3 Jul 2014 15:22:34 +0200
Message-Id: <1404393762-858019-4-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
References: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the clock framework to get the rate of the peripheral clock.
Remove the now obsolete get_uart_baud_base function.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
v2: initial version, taken from original patch #2

 arch/mips/alchemy/common/clocks.c          | 19 -------------------
 arch/mips/alchemy/common/platform.c        | 13 ++++++++++++-
 arch/mips/include/asm/mach-au1x00/au1000.h |  2 --
 3 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/arch/mips/alchemy/common/clocks.c b/arch/mips/alchemy/common/clocks.c
index 35db35b..e77fa9b 100644
--- a/arch/mips/alchemy/common/clocks.c
+++ b/arch/mips/alchemy/common/clocks.c
@@ -38,7 +38,6 @@
 #define AU1000_SRC_CLK	12000000
 
 static unsigned int au1x00_clock; /*  Hz */
-static unsigned long uart_baud_base;
 
 /*
  * Set the au1000_clock
@@ -55,21 +54,6 @@ unsigned int get_au1x00_speed(void)
 EXPORT_SYMBOL(get_au1x00_speed);
 
 /*
- * The UART baud base is not known at compile time ... if
- * we want to be able to use the same code on different
- * speed CPUs.
- */
-unsigned long get_au1x00_uart_baud_base(void)
-{
-	return uart_baud_base;
-}
-
-void set_au1x00_uart_baud_base(unsigned long new_baud_base)
-{
-	uart_baud_base = new_baud_base;
-}
-
-/*
  * We read the real processor speed from the PLL.  This is important
  * because it is more accurate than computing it from the 32 KHz
  * counter, if it exists.  If we don't have an accurate processor
@@ -96,9 +80,6 @@ unsigned long au1xxx_calc_clock(void)
 
 	/* On Alchemy CPU:counter ratio is 1:1 */
 	mips_hpt_frequency = cpu_speed;
-	/* Equation: Baudrate = CPU / (SD * 2 * CLKDIV * 16) */
-	set_au1x00_uart_baud_base(cpu_speed /
-		(2 * ((AU1X_RDSYS(AU1000_SYS_POWERCTRL) & 0x03) + 2) * 16));
 
 	set_au1x00_speed(cpu_speed);
 
diff --git a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
index 4cdc8fd..e70d5c1 100644
--- a/arch/mips/alchemy/common/platform.c
+++ b/arch/mips/alchemy/common/platform.c
@@ -11,6 +11,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -99,10 +100,20 @@ static struct platform_device au1xx0_uart_device = {
 
 static void __init alchemy_setup_uarts(int ctype)
 {
-	unsigned int uartclk = get_au1x00_uart_baud_base() * 16;
+	long uartclk;
 	int s = sizeof(struct plat_serial8250_port);
 	int c = alchemy_get_uarts(ctype);
 	struct plat_serial8250_port *ports;
+	struct clk *clk = clk_get(NULL, ALCHEMY_PERIPH_CLK);
+
+	if (IS_ERR(clk))
+		return;
+	if (clk_prepare_enable(clk)) {
+		clk_put(clk);
+		return;
+	}
+	uartclk = clk_get_rate(clk);
+	clk_put(clk);
 
 	ports = kzalloc(s * (c + 1), GFP_KERNEL);
 	if (!ports) {
diff --git a/arch/mips/include/asm/mach-au1x00/au1000.h b/arch/mips/include/asm/mach-au1x00/au1000.h
index 734b4ac..46ce1fe 100644
--- a/arch/mips/include/asm/mach-au1x00/au1000.h
+++ b/arch/mips/include/asm/mach-au1x00/au1000.h
@@ -829,8 +829,6 @@ static inline int alchemy_get_macs(int type)
 /* arch/mips/au1000/common/clocks.c */
 extern void set_au1x00_speed(unsigned int new_freq);
 extern unsigned int get_au1x00_speed(void);
-extern void set_au1x00_uart_baud_base(unsigned long new_baud_base);
-extern unsigned long get_au1x00_uart_baud_base(void);
 extern unsigned long au1xxx_calc_clock(void);
 
 /* PM: arch/mips/alchemy/common/sleeper.S, power.c, irq.c */
-- 
2.0.0

