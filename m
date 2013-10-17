Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762936Ab3JQVJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:09:05 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48100 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762886Ab3JQVJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:09:00 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 09/10] tty: xuartps: Implement suspend/resume callbacks
Date: Thu, 17 Oct 2013 14:08:12 -0700
Message-Id: <1382044093-29905-10-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement suspend and resume callbacks in order to support system
suspend/hibernation.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 114 +++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 82195040e906..9ecd8ea4f3ae 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1198,6 +1198,119 @@ console_initcall(xuartps_console_init);
 
 #endif /* CONFIG_SERIAL_XILINX_PS_UART_CONSOLE */
 
+#ifdef CONFIG_PM_SLEEP
+/**
+ * xuartps_suspend - suspend event
+ * @device: Pointer to the device structure
+ *
+ * Returns 0
+ */
+static int xuartps_suspend(struct device *device)
+{
+	struct uart_port *port = dev_get_drvdata(device);
+	struct tty_struct *tty;
+	struct device *tty_dev;
+	int may_wake = 0;
+
+	/* Get the tty which could be NULL so don't assume it's valid */
+	tty = tty_port_tty_get(&port->state->port);
+	if (tty) {
+		tty_dev = tty->dev;
+		may_wake = device_may_wakeup(tty_dev);
+		tty_kref_put(tty);
+	}
+
+	/*
+	 * Call the API provided in serial_core.c file which handles
+	 * the suspend.
+	 */
+	uart_suspend_port(&xuartps_uart_driver, port);
+	if (console_suspend_enabled && !may_wake) {
+		struct xuartps *xuartps = port->private_data;
+
+		clk_disable(xuartps->refclk);
+		clk_disable(xuartps->aperclk);
+	} else {
+		unsigned long flags = 0;
+
+		spin_lock_irqsave(&port->lock, flags);
+		/* Empty the receive FIFO 1st before making changes */
+		while (!(xuartps_readl(XUARTPS_SR_OFFSET) & XUARTPS_SR_RXEMPTY))
+			xuartps_readl(XUARTPS_FIFO_OFFSET);
+		/* set RX trigger level to 1 */
+		xuartps_writel(1, XUARTPS_RXWM_OFFSET);
+		/* disable RX timeout interrups */
+		xuartps_writel(XUARTPS_IXR_TOUT, XUARTPS_IDR_OFFSET);
+		spin_unlock_irqrestore(&port->lock, flags);
+	}
+
+	return 0;
+}
+
+/**
+ * xuartps_resume - Resume after a previous suspend
+ * @device: Pointer to the device structure
+ *
+ * Returns 0
+ */
+static int xuartps_resume(struct device *device)
+{
+	struct uart_port *port = dev_get_drvdata(device);
+	unsigned long flags = 0;
+	u32 ctrl_reg;
+	struct tty_struct *tty;
+	struct device *tty_dev;
+	int may_wake = 0;
+
+	/* Get the tty which could be NULL so don't assume it's valid */
+	tty = tty_port_tty_get(&port->state->port);
+	if (tty) {
+		tty_dev = tty->dev;
+		may_wake = device_may_wakeup(tty_dev);
+		tty_kref_put(tty);
+	}
+
+	if (console_suspend_enabled && !may_wake) {
+		struct xuartps *xuartps = port->private_data;
+
+		clk_enable(xuartps->aperclk);
+		clk_enable(xuartps->refclk);
+
+		spin_lock_irqsave(&port->lock, flags);
+
+		/* Set TX/RX Reset */
+		xuartps_writel(xuartps_readl(XUARTPS_CR_OFFSET) |
+				(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST),
+				XUARTPS_CR_OFFSET);
+		while (xuartps_readl(XUARTPS_CR_OFFSET) &
+				(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST))
+			cpu_relax();
+
+		/* restore rx timeout value */
+		xuartps_writel(rx_timeout, XUARTPS_RXTOUT_OFFSET);
+		/* Enable Tx/Rx */
+		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
+		xuartps_writel(
+			(ctrl_reg & ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS)) |
+			(XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN),
+			XUARTPS_CR_OFFSET);
+
+		spin_unlock_irqrestore(&port->lock, flags);
+	} else {
+		spin_lock_irqsave(&port->lock, flags);
+		/* restore original rx trigger level */
+		xuartps_writel(rx_trigger_level, XUARTPS_RXWM_OFFSET);
+		/* enable RX timeout interrupt */
+		xuartps_writel(XUARTPS_IXR_TOUT, XUARTPS_IER_OFFSET);
+		spin_unlock_irqrestore(&port->lock, flags);
+	}
+
+	return uart_resume_port(&xuartps_uart_driver, port);
+}
+#endif /* ! CONFIG_PM_SLEEP */
+
+static SIMPLE_DEV_PM_OPS(xuartps_dev_pm_ops, xuartps_suspend, xuartps_resume);
+
 /** Structure Definitions
  */
 static struct uart_driver xuartps_uart_driver = {
@@ -1348,6 +1461,7 @@ static struct platform_driver xuartps_platform_driver = {
 		.owner = THIS_MODULE,
 		.name = XUARTPS_NAME,		/* Driver name */
 		.of_match_table = xuartps_of_match,
+		.pm = &xuartps_dev_pm_ops,
 		},
 };
 
-- 
1.8.4.1

