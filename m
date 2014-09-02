Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaIBNHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:07:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54027 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaIBNHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:07:38 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH v11 19/19] serial: imx: Add support for KGDB's FIQ/NMI mode
Date: Tue,  2 Sep 2014 14:00:53 +0100
Message-Id: <1409662853-29313-20-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it possible to use the imx uart with KGDB's FIQ/NMI
mode.

Main changes are:

.poll_init() will, if KGDB+FIQ are enabled, perform deeper hardware
initialization to ensure the serial port is always active (required
otherwise FIQ is not triggered by UART activity). This has an impact on
power usage so it is conservatively enabled.

imx_put_poll_char() has been simplified to remove the code to disable
interrupts. The present code can corrupt register state when re-entered
from FIQ handler.

Both imx_put_poll_char() and imx_get_poll_char() adopt _relaxed()
MMIO functions (which are safe for polled I/O and needed to avoid taking
spin locks).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Acked-by: Dirk Behme <dirk.behme@de.bosch.com>
---
 drivers/tty/serial/imx.c | 71 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 983668a..a201c61 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -49,6 +49,7 @@
 #include <linux/of_device.h>
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
+#include <linux/kgdb.h>
 
 #include <asm/irq.h>
 #include <linux/platform_data/serial-imx.h>
@@ -1505,44 +1506,73 @@ imx_verify_port(struct uart_port *port, struct serial_struct *ser)
 }
 
 #if defined(CONFIG_CONSOLE_POLL)
+
+#if defined(CONFIG_KGDB_FIQ)
+/*
+ * Prepare the UART to be used from kgdb's NMI support.
+ */
+static int imx_poll_init(struct uart_port *port)
+{
+	struct imx_port *sport = (struct imx_port *)port;
+	unsigned long flags;
+	unsigned long temp;
+	int retval;
+
+	retval = clk_prepare_enable(sport->clk_ipg);
+	if (retval)
+		return retval;
+	retval = clk_prepare_enable(sport->clk_per);
+	if (retval)
+		clk_disable_unprepare(sport->clk_ipg);
+
+	imx_setup_ufcr(sport, 0);
+
+	spin_lock_irqsave(&sport->port.lock, flags);
+
+	temp = readl(sport->port.membase + UCR1);
+	if (is_imx1_uart(sport))
+		temp |= IMX1_UCR1_UARTCLKEN;
+	temp |= UCR1_UARTEN | UCR1_RRDYEN;
+	temp &= ~(UCR1_TXMPTYEN | UCR1_RTSDEN);
+	writel(temp, sport->port.membase + UCR1);
+
+	temp = readl(sport->port.membase + UCR2);
+	temp |= UCR2_RXEN;
+	writel(temp, sport->port.membase + UCR2);
+
+	spin_unlock_irqrestore(&sport->port.lock, flags);
+
+	/* register the FIQ with kgdb */
+	kgdb_register_fiq(sport->port.irq);
+
+	return 0;
+}
+#endif /* CONFIG_KGDB_FIQ */
+
 static int imx_poll_get_char(struct uart_port *port)
 {
-	if (!(readl(port->membase + USR2) & USR2_RDR))
+	if (!(readl_relaxed(port->membase + USR2) & USR2_RDR))
 		return NO_POLL_CHAR;
 
-	return readl(port->membase + URXD0) & URXD_RX_DATA;
+	return readl_relaxed(port->membase + URXD0) & URXD_RX_DATA;
 }
 
 static void imx_poll_put_char(struct uart_port *port, unsigned char c)
 {
-	struct imx_port_ucrs old_ucr;
 	unsigned int status;
 
-	/* save control registers */
-	imx_port_ucrs_save(port, &old_ucr);
-
-	/* disable interrupts */
-	writel(UCR1_UARTEN, port->membase + UCR1);
-	writel(old_ucr.ucr2 & ~(UCR2_ATEN | UCR2_RTSEN | UCR2_ESCI),
-	       port->membase + UCR2);
-	writel(old_ucr.ucr3 & ~(UCR3_DCD | UCR3_RI | UCR3_DTREN),
-	       port->membase + UCR3);
-
 	/* drain */
 	do {
-		status = readl(port->membase + USR1);
+		status = readl_relaxed(port->membase + USR1);
 	} while (~status & USR1_TRDY);
 
 	/* write */
-	writel(c, port->membase + URTX0);
+	writel_relaxed(c, port->membase + URTX0);
 
 	/* flush */
 	do {
-		status = readl(port->membase + USR2);
+		status = readl_relaxed(port->membase + USR2);
 	} while (~status & USR2_TXDC);
-
-	/* restore control registers */
-	imx_port_ucrs_restore(port, &old_ucr);
 }
 #endif
 
@@ -1563,6 +1593,9 @@ static struct uart_ops imx_pops = {
 	.config_port	= imx_config_port,
 	.verify_port	= imx_verify_port,
 #if defined(CONFIG_CONSOLE_POLL)
+#if defined(CONFIG_KGDB_FIQ)
+	.poll_init      = imx_poll_init,
+#endif
 	.poll_get_char  = imx_poll_get_char,
 	.poll_put_char  = imx_poll_put_char,
 #endif
-- 
1.9.3

