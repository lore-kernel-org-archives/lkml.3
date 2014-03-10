Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaCJVl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:41:56 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:54182 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaCJVlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:41:52 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 3/7] tty: xuartps: Refactor read-modify-writes
Date: Mon, 10 Mar 2014 14:40:06 -0700
Message-Id: <1394487610-2419-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1394487610-2419-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1394487610-2419-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of read-modify-write sequences used a one-line statement which
nests a readl() within a writel(). Convert this into code sequences that
make the three steps more obvious.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 52 ++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index b00060052316..a4bd6242e72d 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -437,9 +437,9 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 		spin_lock_irqsave(&xuartps->port->lock, flags);
 
 		/* Disable the TX and RX to set baud rate */
-		xuartps_writel(xuartps_readl(XUARTPS_CR_OFFSET) |
-				(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS),
-				XUARTPS_CR_OFFSET);
+		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
+		ctrl_reg |= XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS;
+		xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
 
 		spin_unlock_irqrestore(&xuartps->port->lock, flags);
 
@@ -464,9 +464,9 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 			spin_lock_irqsave(&xuartps->port->lock, flags);
 
 		/* Set TX/RX Reset */
-		xuartps_writel(xuartps_readl(XUARTPS_CR_OFFSET) |
-				(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST),
-				XUARTPS_CR_OFFSET);
+		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
+		ctrl_reg |= XUARTPS_CR_TXRST | XUARTPS_CR_RXRST;
+		xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
 
 		while (xuartps_readl(XUARTPS_CR_OFFSET) &
 				(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST))
@@ -479,10 +479,9 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 		 */
 		xuartps_writel(rx_timeout, XUARTPS_RXTOUT_OFFSET);
 		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
-		xuartps_writel(
-			(ctrl_reg & ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS)) |
-			(XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN),
-			XUARTPS_CR_OFFSET);
+		ctrl_reg &= ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS);
+		ctrl_reg |= XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN;
+		xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
 
 		spin_unlock_irqrestore(&xuartps->port->lock, flags);
 
@@ -631,9 +630,9 @@ static void xuartps_set_termios(struct uart_port *port,
 	}
 
 	/* Disable the TX and RX to set baud rate */
-	xuartps_writel(xuartps_readl(XUARTPS_CR_OFFSET) |
-			(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS),
-			XUARTPS_CR_OFFSET);
+	ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
+	ctrl_reg |= XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS;
+	xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
 
 	/*
 	 * Min baud rate = 6bps and Max Baud Rate is 10Mbps for 100Mhz clk
@@ -651,20 +650,18 @@ static void xuartps_set_termios(struct uart_port *port,
 	uart_update_timeout(port, termios->c_cflag, baud);
 
 	/* Set TX/RX Reset */
-	xuartps_writel(xuartps_readl(XUARTPS_CR_OFFSET) |
-			(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST),
-			XUARTPS_CR_OFFSET);
-
 	ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
+	ctrl_reg |= XUARTPS_CR_TXRST | XUARTPS_CR_RXRST;
+	xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
 
 	/*
 	 * Clear the RX disable and TX disable bits and then set the TX enable
 	 * bit and RX enable bit to enable the transmitter and receiver.
 	 */
-	xuartps_writel(
-		(ctrl_reg & ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS))
-			| (XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN),
-			XUARTPS_CR_OFFSET);
+	ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
+	ctrl_reg &= ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS);
+	ctrl_reg |= XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN;
+	xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
 
 	xuartps_writel(rx_timeout, XUARTPS_RXTOUT_OFFSET);
 
@@ -1245,9 +1242,9 @@ static int xuartps_resume(struct device *device)
 		spin_lock_irqsave(&port->lock, flags);
 
 		/* Set TX/RX Reset */
-		xuartps_writel(xuartps_readl(XUARTPS_CR_OFFSET) |
-				(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST),
-				XUARTPS_CR_OFFSET);
+		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
+		ctrl_reg |= XUARTPS_CR_TXRST | XUARTPS_CR_RXRST;
+		xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
 		while (xuartps_readl(XUARTPS_CR_OFFSET) &
 				(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST))
 			cpu_relax();
@@ -1256,10 +1253,9 @@ static int xuartps_resume(struct device *device)
 		xuartps_writel(rx_timeout, XUARTPS_RXTOUT_OFFSET);
 		/* Enable Tx/Rx */
 		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
-		xuartps_writel(
-			(ctrl_reg & ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS)) |
-			(XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN),
-			XUARTPS_CR_OFFSET);
+		ctrl_reg &= ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS);
+		ctrl_reg |= XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN;
+		xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
 
 		spin_unlock_irqrestore(&port->lock, flags);
 	} else {
-- 
1.9.0.1.g4196000

