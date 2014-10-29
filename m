Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934665AbaJ2Qiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:38:54 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47197 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934110AbaJ2Qiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:38:51 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>,
        linux-arm-msm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH] serial: msm: Add magic SysRq support in dmmode
Date: Wed, 29 Oct 2014 16:38:32 +0000
Message-Id: <1414600712-20721-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the _dm RX handler detects breaks but does not pass any
characters to uart_handle_sysrq_char().

The _dm optimizations combined with the port's spin lock make if
difficult to pass all characters to the sysrq logic because we cannot
safely call uart_handle_sysrq_char() when the lock is held without
deadlock (the console handler also takes the lock).

Rather than passing all characters via uart_handle_sysrq_char() this patch
only passes the last few characters in the FIFO. This should include all
characters typed as a slow (human) rate. This makes the problem much
simpler and allows us to move the handling of these characters outside
of the port lock. This makes magic SysRq work if there is a human at
the keyboard (or a short delay in a script).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/tty/serial/msm_serial.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 4b6c783..24c4fd1 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -104,6 +104,7 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 	unsigned int sr;
 	int count = 0;
 	struct msm_port *msm_port = UART_TO_MSM(port);
+	unsigned char buf[4];

 	if ((msm_read(port, UART_SR) & UART_SR_OVERRUN)) {
 		port->icount.overrun++;
@@ -125,11 +126,10 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 	port->icount.rx += count;

 	while (count > 0) {
-		unsigned char buf[4];
-
 		sr = msm_read(port, UART_SR);
 		if ((sr & UART_SR_RX_READY) == 0) {
 			msm_port->old_snap_state -= count;
+			count = 0;
 			break;
 		}
 		ioread32_rep(port->membase + UARTDM_RF, buf, 1);
@@ -140,13 +140,33 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 		} else if (sr & UART_SR_PAR_FRAME_ERR)
 			port->icount.frame++;

-		/* TODO: handle sysrq */
+		/* The last few characters receive special processing below. */
+		if (count <= 2)
+			break;
+
 		tty_insert_flip_string(tport, buf, min(count, 4));
 		count -= 4;
 	}

 	spin_unlock(&port->lock);
+
+	/*
+	 * We have deferred the last few characters to be processed
+	 * with the port unlocked. This allows all characters received at
+	 * "human speed" to be passed through the magic SysRq handling.
+	 * The hardware sends us two characters after a break (the second
+	 * of which is \0) so we are forced to process up to two final
+	 * characters rather than just one.
+	 */
+	if (count > 0) {
+		if (!uart_handle_sysrq_char(port, buf[0]))
+			tty_insert_flip_string(tport, buf, count);
+		else if (count > 1 && !uart_handle_sysrq_char(port, buf[1]))
+			tty_insert_flip_char(tport, buf[1], 0);
+	}
+
 	tty_flip_buffer_push(tport);
+
 	spin_lock(&port->lock);

 	if (misr & (UART_IMR_RXSTALE))
--
1.9.3

