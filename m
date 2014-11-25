Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaKYLZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:25:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58650 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaKYKmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 129/254] serial: msm_serial: Fix kgdb continue
Date: Tue, 25 Nov 2014 10:37:59 +0000
Message-Id: <1416912004-5928-130-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit 8b374399468da1c25db5b5d436b167aafc10fbdc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.0

