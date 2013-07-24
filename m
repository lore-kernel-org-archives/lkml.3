Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3GXShk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:37:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44512 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3GXShf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:37:35 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, linux-serial@vger.kernel.org
Subject: [PATCH 1/4] msm_serial: Fix NUL byte output on UARTDM
Date: Wed, 24 Jul 2013 11:37:28 -0700
Message-Id: <1374691051-28544-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.837.g0bde8c0
In-Reply-To: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
References: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UARTDM serial devices require us to wait for the entire TX fifo
to drain before we can change the contents of the NCF_TX
register. Furthermore, if we write any characters to the TX fifo
within the same clock cycle of changing the NCF_TX register the
NCF_TX register won't latch properly.

To fix these issues we should read back the NCF_TX register to
delay any TX fifo accesses by a clock cycle and we should wait
for the TX fifo to drain (instead of just waiting for the fifo to
be ready to receive more characters). Failure to do so leads to
random NUL bytes interspersed in the output.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 14 +++++++++-----
 drivers/tty/serial/msm_serial.h |  1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 2c6cfb3..fa3fc67 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -50,11 +50,14 @@ struct msm_port {
 	unsigned int		old_snap_state;
 };
 
-static inline void wait_for_xmitr(struct uart_port *port, int bits)
+static inline void wait_for_xmitr(struct uart_port *port)
 {
-	if (!(msm_read(port, UART_SR) & UART_SR_TX_EMPTY))
-		while ((msm_read(port, UART_ISR) & bits) != bits)
-			cpu_relax();
+	while (!(msm_read(port, UART_SR) & UART_SR_TX_EMPTY)) {
+		if (msm_read(port, UART_ISR) & UART_ISR_TX_READY)
+			break;
+		udelay(1);
+	}
+	msm_write(port, UART_CR_CMD_RESET_TX_READY, UART_CR);
 }
 
 static void msm_stop_tx(struct uart_port *port)
@@ -194,8 +197,9 @@ static void handle_rx(struct uart_port *port)
 
 static void reset_dm_count(struct uart_port *port)
 {
-	wait_for_xmitr(port, UART_ISR_TX_READY);
+	wait_for_xmitr(port);
 	msm_write(port, 1, UARTDM_NCF_TX);
+	msm_read(port, UARTDM_NCF_TX);
 }
 
 static void handle_tx(struct uart_port *port)
diff --git a/drivers/tty/serial/msm_serial.h b/drivers/tty/serial/msm_serial.h
index e4acef5..15c186e 100644
--- a/drivers/tty/serial/msm_serial.h
+++ b/drivers/tty/serial/msm_serial.h
@@ -71,6 +71,7 @@
 #define UART_CR_CMD_RESET_RFR		(14 << 4)
 #define UART_CR_CMD_PROTECTION_EN	(16 << 4)
 #define UART_CR_CMD_STALE_EVENT_ENABLE	(80 << 4)
+#define UART_CR_CMD_RESET_TX_READY	(3 << 8)
 #define UART_CR_TX_DISABLE		(1 << 3)
 #define UART_CR_TX_ENABLE		(1 << 2)
 #define UART_CR_RX_DISABLE		(1 << 1)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

