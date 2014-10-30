Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbaJ3BrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 21:47:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35292 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbaJ3BrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 21:47:05 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: [PATCH] tty: serial: msm: Reset uartdm after baud rate change
Date: Wed, 29 Oct 2014 18:47:01 -0700
Message-Id: <1414633621-8225-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to issue a reset if we ever change the value of the IPR
register on DM hardware. If we don't reset the hardware the RX
stale interrupt never triggers and the only way to trigger an RX
handling event is by filling up the fifo. This causes things like
getty to not work so well considering it might change the baud
rate a few times. Fix this by moving the reset on startup and any
reprogramming required after the reset to be after we change the
baud rate.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

This is based on my latest two patches to fix the break handling in this
driver[1]. The only conflict is the break start interrupt bit so it could
be moved off that patch if desired. This doesn't seem to affect non-DM
hardware one way or the other, but I also can't get a getty to work on
non-DM hardware right now. I need to debug that more some time.

[1] http://lkml.kernel.org/r/1414606478-13709-1-git-send-email-sboyd@codeaurora.org

 drivers/tty/serial/msm_serial.c | 49 ++++++++++-------------------------------
 1 file changed, 12 insertions(+), 37 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index d44c04976f7a..b507f5a16c1c 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -427,9 +427,6 @@ static int msm_set_baud_rate(struct uart_port *port, unsigned int baud)
 
 	entry = msm_find_best_baud(port, baud);
 
-	if (msm_port->is_uartdm)
-		msm_write(port, UART_CR_CMD_RESET_RX, UART_CR);
-
 	msm_write(port, entry->code, UART_CSR);
 
 	/* RX stale watermark */
@@ -446,6 +443,18 @@ static int msm_set_baud_rate(struct uart_port *port, unsigned int baud)
 	/* set TX watermark */
 	msm_write(port, 10, UART_TFWR);
 
+	msm_write(port, UART_CR_CMD_PROTECTION_EN, UART_CR);
+	msm_reset(port);
+
+	/* Enable RX and TX */
+	msm_write(port, UART_CR_TX_ENABLE | UART_CR_RX_ENABLE, UART_CR);
+
+	/* turn on RX and CTS interrupts */
+	msm_port->imr = UART_IMR_RXLEV | UART_IMR_RXSTALE |
+			UART_IMR_CURRENT_CTS | UART_IMR_RXBREAK_START;
+
+	msm_write(port, msm_port->imr, UART_IMR);
+
 	if (msm_port->is_uartdm) {
 		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
 		msm_write(port, 0xFFFFFF, UARTDM_DMRX);
@@ -492,40 +501,6 @@ static int msm_startup(struct uart_port *port)
 	data |= UART_MR1_AUTO_RFR_LEVEL1 & (rfr_level << 2);
 	data |= UART_MR1_AUTO_RFR_LEVEL0 & rfr_level;
 	msm_write(port, data, UART_MR1);
-
-	/* make sure that RXSTALE count is non-zero */
-	data = msm_read(port, UART_IPR);
-	if (unlikely(!data)) {
-		data |= UART_IPR_RXSTALE_LAST;
-		data |= UART_IPR_STALE_LSB;
-		msm_write(port, data, UART_IPR);
-	}
-
-	data = 0;
-	if (!port->cons || (port->cons && !(port->cons->flags & CON_ENABLED))) {
-		msm_write(port, UART_CR_CMD_PROTECTION_EN, UART_CR);
-		msm_reset(port);
-		data = UART_CR_TX_ENABLE;
-	}
-
-	data |= UART_CR_RX_ENABLE;
-	msm_write(port, data, UART_CR);	/* enable TX & RX */
-
-	/* Make sure IPR is not 0 to start with*/
-	if (msm_port->is_uartdm)
-		msm_write(port, UART_IPR_STALE_LSB, UART_IPR);
-
-	/* turn on RX and CTS interrupts */
-	msm_port->imr = UART_IMR_RXLEV | UART_IMR_RXSTALE |
-			UART_IMR_CURRENT_CTS | UART_IMR_RXBREAK_START;
-
-	if (msm_port->is_uartdm) {
-		msm_write(port, 0xFFFFFF, UARTDM_DMRX);
-		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
-		msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
-	}
-
-	msm_write(port, msm_port->imr, UART_IMR);
 	return 0;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

