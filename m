Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaHFBha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:37:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54885 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaHFBh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:37:28 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Frank Rowand <frank.rowand@sonymobile.com>
Subject: [PATCH] serial: msm_serial: Fix kgdb continue
Date: Tue,  5 Aug 2014 18:37:24 -0700
Message-Id: <1407289044-29344-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank reports that after continuing in kgdb the RX stale event
doesn't occur until after the RX fifo is filled up with exactly
the amount of characters programmed for the RX watermark (in this
case it's 48). To read a single character from the uartdm
hardware we force a stale event so that any characters in the RX
packing buffer are flushed into the RX fifo immediately instead
of waiting for a stale timeout or for the fifo to fill. Forcing
that stale event asserts the stale interrupt but we never clear
that interrupt via UART_CR_CMD_RESET_STALE_INT in the polling
functions. So when kgdb continues the stale interrupt is left
pending in the hardware and we don't timeout with a stale event,
like we usually would if a user typed one character on the
console, until the reset stale interrupt and stale event commands
are sent. Frank could get things working again by running
handle_rx_dm(). By putting enough characters into the fifo he
could trigger a watermark interrupt, and thus cause
handle_rx_dm() to run finally resetting the stale interrupt
and enabling the stale event so that single characters would
cause timeouts again.

The fix is to just do what the interrupt routine was doing all
along and clear the stale interrupt and enable the event again.
Doing this also smooths over any differences in the fifo behavior
between v1.3 and v1.4 hardware allowing us to skip forcing the
uart into single character mode.

Reviewed-by: Frank Rowand <frank.rowand@sonymobile.com>
Tested-by: Frank Rowand <frank.rowand@sonymobile.com>
Fixes: f7e54d7ad743 "msm_serial: Add support for poll_{get,put}_char()"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 72000a6d5af0..5a82ca2f4bad 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -680,17 +680,6 @@ static void msm_power(struct uart_port *port, unsigned int state,
 }
 
 #ifdef CONFIG_CONSOLE_POLL
-static int msm_poll_init(struct uart_port *port)
-{
-	struct msm_port *msm_port = UART_TO_MSM(port);
-
-	/* Enable single character mode on RX FIFO */
-	if (msm_port->is_uartdm >= UARTDM_1P4)
-		msm_write(port, UARTDM_DMEN_RX_SC_ENABLE, UARTDM_DMEN);
-
-	return 0;
-}
-
 static int msm_poll_get_char_single(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
@@ -702,7 +691,7 @@ static int msm_poll_get_char_single(struct uart_port *port)
 		return msm_read(port, rf_reg) & 0xff;
 }
 
-static int msm_poll_get_char_dm_1p3(struct uart_port *port)
+static int msm_poll_get_char_dm(struct uart_port *port)
 {
 	int c;
 	static u32 slop;
@@ -726,6 +715,10 @@ static int msm_poll_get_char_dm_1p3(struct uart_port *port)
 			slop = msm_read(port, UARTDM_RF);
 			c = sp[0];
 			count--;
+			msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
+			msm_write(port, 0xFFFFFF, UARTDM_DMRX);
+			msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE,
+				  UART_CR);
 		} else {
 			c = NO_POLL_CHAR;
 		}
@@ -749,8 +742,8 @@ static int msm_poll_get_char(struct uart_port *port)
 	imr = msm_read(port, UART_IMR);
 	msm_write(port, 0, UART_IMR);
 
-	if (msm_port->is_uartdm == UARTDM_1P3)
-		c = msm_poll_get_char_dm_1p3(port);
+	if (msm_port->is_uartdm)
+		c = msm_poll_get_char_dm(port);
 	else
 		c = msm_poll_get_char_single(port);
 
@@ -809,7 +802,6 @@ static struct uart_ops msm_uart_pops = {
 	.verify_port = msm_verify_port,
 	.pm = msm_power,
 #ifdef CONFIG_CONSOLE_POLL
-	.poll_init = msm_poll_init,
 	.poll_get_char	= msm_poll_get_char,
 	.poll_put_char	= msm_poll_put_char,
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

