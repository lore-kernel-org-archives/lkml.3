Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab3JQVJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:09:46 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39236 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762906Ab3JQVI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:08:57 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 08/10] tty: xuartps: Dynamically adjust to input frequency changes
Date: Thu, 17 Oct 2013 14:08:11 -0700
Message-Id: <1382044093-29905-9-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a clock notifier to dynamically handle frequency changes of the
input clock by reprogramming the UART in order to keep the baud rate
constant.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 123 +++++++++++++++++++++++++++++++++++--
 1 file changed, 119 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 95e12c216984..82195040e906 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -163,13 +163,20 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
 
 /**
  * struct xuartps - device data
- * @refclk	Reference clock
- * @aperclk	APB clock
+ * @port		Pointer to the UART port
+ * @refclk		Reference clock
+ * @aperclk		APB clock
+ * @baud		Current baud rate
+ * @clk_rate_change_nb	Notifier block for clock changes
  */
 struct xuartps {
+	struct uart_port	*port;
 	struct clk		*refclk;
 	struct clk		*aperclk;
+	unsigned int		baud;
+	struct notifier_block	clk_rate_change_nb;
 };
+#define to_xuartps(_nb) container_of(_nb, struct xuartps, clk_rate_change_nb);
 
 /**
  * xuartps_isr - Interrupt handler
@@ -385,6 +392,7 @@ static unsigned int xuartps_set_baud_rate(struct uart_port *port,
 	u32 cd, bdiv;
 	u32 mreg;
 	int div8;
+	struct xuartps *xuartps = port->private_data;
 
 	calc_baud = xuartps_calc_baud_divs(port->uartclk, baud, &bdiv, &cd,
 			&div8);
@@ -398,10 +406,105 @@ static unsigned int xuartps_set_baud_rate(struct uart_port *port,
 	xuartps_writel(mreg, XUARTPS_MR_OFFSET);
 	xuartps_writel(cd, XUARTPS_BAUDGEN_OFFSET);
 	xuartps_writel(bdiv, XUARTPS_BAUDDIV_OFFSET);
+	xuartps->baud = baud;
 
 	return calc_baud;
 }
 
+/**
+ * xuartps_clk_notitifer_cb - Clock notifier callback
+ * @nb:		Notifier block
+ * @event:	Notify event
+ * @data:	Notifier data
+ * Returns NOTIFY_OK on success, NOTIFY_BAD on error.
+ */
+static int xuartps_clk_notifier_cb(struct notifier_block *nb,
+		unsigned long event, void *data)
+{
+	u32 ctrl_reg;
+	struct uart_port *port;
+	int locked = 0;
+	struct clk_notifier_data *ndata = data;
+	unsigned long flags = 0;
+	struct xuartps *xuartps = to_xuartps(nb);
+
+	port = xuartps->port;
+	if (port->suspended)
+		return NOTIFY_OK;
+
+	switch (event) {
+	case PRE_RATE_CHANGE:
+	{
+		u32 bdiv;
+		u32 cd;
+		int div8;
+
+		/*
+		 * Find out if current baud-rate can be achieved with new clock
+		 * frequency.
+		 */
+		if (!xuartps_calc_baud_divs(ndata->new_rate, xuartps->baud,
+					&bdiv, &cd, &div8))
+			return NOTIFY_BAD;
+
+		spin_lock_irqsave(&xuartps->port->lock, flags);
+
+		/* Disable the TX and RX to set baud rate */
+		xuartps_writel(xuartps_readl(XUARTPS_CR_OFFSET) |
+				(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS),
+				XUARTPS_CR_OFFSET);
+
+		spin_unlock_irqrestore(&xuartps->port->lock, flags);
+
+		return NOTIFY_OK;
+	}
+	case POST_RATE_CHANGE:
+		/*
+		 * Set clk dividers to generate correct baud with new clock
+		 * frequency.
+		 */
+
+		spin_lock_irqsave(&xuartps->port->lock, flags);
+
+		locked = 1;
+		port->uartclk = ndata->new_rate;
+
+		xuartps->baud = xuartps_set_baud_rate(xuartps->port,
+				xuartps->baud);
+		/* fall through */
+	case ABORT_RATE_CHANGE:
+		if (!locked)
+			spin_lock_irqsave(&xuartps->port->lock, flags);
+
+		/* Set TX/RX Reset */
+		xuartps_writel(xuartps_readl(XUARTPS_CR_OFFSET) |
+				(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST),
+				XUARTPS_CR_OFFSET);
+
+		while (xuartps_readl(XUARTPS_CR_OFFSET) &
+				(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST))
+			cpu_relax();
+
+		/*
+		 * Clear the RX disable and TX disable bits and then set the TX
+		 * enable bit and RX enable bit to enable the transmitter and
+		 * receiver.
+		 */
+		xuartps_writel(rx_timeout, XUARTPS_RXTOUT_OFFSET);
+		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
+		xuartps_writel(
+			(ctrl_reg & ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS)) |
+			(XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN),
+			XUARTPS_CR_OFFSET);
+
+		spin_unlock_irqrestore(&xuartps->port->lock, flags);
+
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
 /*----------------------Uart Operations---------------------------*/
 
 /**
@@ -1164,13 +1267,19 @@ static int xuartps_probe(struct platform_device *pdev)
 		goto err_out_clk_disable;
 	}
 
+	xuartps_data->clk_rate_change_nb.notifier_call =
+			xuartps_clk_notifier_cb;
+	if (clk_notifier_register(xuartps_data->refclk,
+				&xuartps_data->clk_rate_change_nb))
+		dev_warn(&pdev->dev, "Unable to register clock notifier.\n");
+
 	/* Initialize the port structure */
 	port = xuartps_get_port();
 
 	if (!port) {
 		dev_err(&pdev->dev, "Cannot get uart_port structure\n");
 		rc = -ENODEV;
-		goto err_out_clk_disable;
+		goto err_out_notif_unreg;
 	} else {
 		/* Register the port.
 		 * This function also registers this device with the tty layer
@@ -1181,16 +1290,20 @@ static int xuartps_probe(struct platform_device *pdev)
 		port->dev = &pdev->dev;
 		port->uartclk = clk_get_rate(xuartps_data->refclk);
 		port->private_data = xuartps_data;
+		xuartps_data->port = port;
 		platform_set_drvdata(pdev, port);
 		rc = uart_add_one_port(&xuartps_uart_driver, port);
 		if (rc) {
 			dev_err(&pdev->dev,
 				"uart_add_one_port() failed; err=%i\n", rc);
-			goto err_out_clk_disable;
+			goto err_out_notif_unreg;
 		}
 		return 0;
 	}
 
+err_out_notif_unreg:
+	clk_notifier_unregister(xuartps_data->refclk,
+			&xuartps_data->clk_rate_change_nb);
 err_out_clk_disable:
 	clk_disable_unprepare(xuartps_data->refclk);
 err_out_clk_dis_aper:
@@ -1212,6 +1325,8 @@ static int xuartps_remove(struct platform_device *pdev)
 	int rc;
 
 	/* Remove the xuartps port from the serial core */
+	clk_notifier_unregister(xuartps_data->refclk,
+			&xuartps_data->clk_rate_change_nb);
 	rc = uart_remove_one_port(&xuartps_uart_driver, port);
 	port->mapbase = 0;
 	clk_disable_unprepare(xuartps_data->refclk);
-- 
1.8.4.1

