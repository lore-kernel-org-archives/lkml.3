Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaDEAZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:25:57 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:64174 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbaDEAYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:24:11 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>
Cc: Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Subject: [RESEND PATCH v3 5/9] tty: xuartps: Refactor read-modify-writes
Date: Fri,  4 Apr 2014 17:23:41 -0700
Message-Id: <1396657425-31029-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1.1.gbb9f595
In-Reply-To: <1396657425-31029-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1396657425-31029-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of read-modify-write sequences used a one-line statement which
nests a readl() within a writel(). Convert this into code sequences that
make the three steps more obvious.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Tested-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v3: None
Changes in v2: None

 drivers/tty/serial/xilinx_uartps.c | 52 ++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 814391038abb..b182ab8cfd07 100644
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
 
@@ -1248,9 +1245,9 @@ static int xuartps_resume(struct device *device)
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
@@ -1259,10 +1256,9 @@ static int xuartps_resume(struct device *device)
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
1.9.1.1.gbb9f595

