Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaHEBDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:03:10 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38302 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaHEBDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:03:08 -0400
Message-ID: <53E02D48.1080002@gmail.com>
Date: Mon, 04 Aug 2014 18:03:04 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [test patch 1/4] fix msm_serial for kgdb
References: <53E02C7C.4090206@gmail.com>
In-Reply-To: <53E02C7C.4090206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@sonymobile.com>

f7e54d7ad743 added support for poll_{get,put}_char()
Additional fixes to cope with single character mode on RX FIFO for
qcom,msm-uartdm-v1.4.

With these fixes, kgdb properly communicates with the dragon board, but
following the continue command, the serial driver does not get any stale
(UART_IMR_RXSTALE) interrupts until 48 characters have been read, which
triggers a high water interrupt.  After the high water interrupt has been
processed, the driver resumes properly getting stale interrupts.

Not-signed-off-by-yet: Frank Rowand <frank.rowand@sonymobile.com>

---
 drivers/tty/serial/msm_serial.c |   74 ++++++++++++++++++++++++++++++++--------
 1 file changed, 61 insertions(+), 13 deletions(-)

Index: b/drivers/tty/serial/msm_serial.c
===================================================================
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -54,6 +54,7 @@ struct msm_port {
 	unsigned int		imr;
 	void __iomem		*gsbi_base;
 	int			is_uartdm;
+	int			rx_sc_enabled;
 	unsigned int		old_snap_state;
 };
 
@@ -104,7 +105,10 @@ static void handle_rx_dm(struct uart_por
 	struct tty_port *tport = &port->state->port;
 	unsigned int sr;
 	int count = 0;
+	int imr_rx_stale = misr & UART_IMR_RXSTALE;
 	struct msm_port *msm_port = UART_TO_MSM(port);
+	int res;
+	char *cp;
 
 	if ((msm_read(port, UART_SR) & UART_SR_OVERRUN)) {
 		port->icount.overrun++;
@@ -112,12 +116,14 @@ static void handle_rx_dm(struct uart_por
 		msm_write(port, UART_CR_CMD_RESET_ERR, UART_CR);
 	}
 
-	if (misr & UART_IMR_RXSTALE) {
+	if (imr_rx_stale) {
 		count = msm_read(port, UARTDM_RX_TOTAL_SNAP) -
 			msm_port->old_snap_state;
 		msm_port->old_snap_state = 0;
 	} else {
-		count = 4 * (msm_read(port, UART_RFWR));
+		count = msm_read(port, UART_RFWR);
+		if (!msm_port->rx_sc_enabled)
+			count = 4 * count;
 		msm_port->old_snap_state += count;
 	}
 
@@ -130,28 +136,60 @@ static void handle_rx_dm(struct uart_por
 
 		sr = msm_read(port, UART_SR);
 		if ((sr & UART_SR_RX_READY) == 0) {
-			msm_port->old_snap_state -= count;
+			if (!imr_rx_stale)
+				msm_port->old_snap_state -= count;
 			break;
 		}
+
 		c = msm_read(port, UARTDM_RF);
+
 		if (sr & UART_SR_RX_BREAK) {
 			port->icount.brk++;
-			if (uart_handle_break(port))
-				continue;
+			uart_handle_break(port);
+			if (msm_port->rx_sc_enabled)
+				count -= 1;
+			else
+				count -= 4;
+			continue;
 		} else if (sr & UART_SR_PAR_FRAME_ERR)
 			port->icount.frame++;
 
-		/* TODO: handle sysrq */
-		tty_insert_flip_string(tport, (char *)&c,
-				       (count > 4) ? 4 : count);
-		count -= 4;
+		if (msm_port->rx_sc_enabled) {
+			cp = (char *)&c;
+
+			spin_unlock(&port->lock);
+			res = uart_handle_sysrq_char(port, *cp);
+			spin_lock(&port->lock);
+
+			if (!res)
+				tty_insert_flip_string(tport, cp, 1);
+			count -= 1;
+		} else {
+			cp = (char *)&c;
+
+			spin_unlock(&port->lock);
+			res = uart_handle_sysrq_char(port, *cp);
+			spin_lock(&port->lock);
+
+			if (res) {
+				count -= 1;
+				cp++;
+				tty_insert_flip_string(tport, cp,
+					       (count > 3) ? 3 : count);
+				count -= 3;
+			} else {
+				tty_insert_flip_string(tport, cp,
+						       (count > 4) ? 4 : count);
+				count -= 4;
+			}
+		}
 	}
 
 	spin_unlock(&port->lock);
 	tty_flip_buffer_push(tport);
 	spin_lock(&port->lock);
 
-	if (misr & (UART_IMR_RXSTALE))
+	if (imr_rx_stale)
 		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
 	msm_write(port, 0xFFFFFF, UARTDM_DMRX);
 	msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
@@ -413,8 +451,11 @@ static int msm_set_baud_rate(struct uart
 	watermark |= UART_IPR_STALE_TIMEOUT_MSB & (rxstale << 2);
 	msm_write(port, watermark, UART_IPR);
 
-	/* set RX watermark */
-	watermark = (port->fifosize * 3) / 4;
+	/* set RX watermark (number of words) */
+	if (msm_port->rx_sc_enabled)
+		watermark = (port->fifosize * 3) / 4;  /* 1 byte per word */
+	else
+		watermark = (port->fifosize * 3) / 16;  /* 4 bytes per word */
 	msm_write(port, watermark, UART_RFWR);
 
 	/* set TX watermark */
@@ -728,10 +769,17 @@ static void msm_power(struct uart_port *
 static int msm_poll_init(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
+	unsigned int watermark;
 
 	/* Enable single character mode on RX FIFO */
-	if (msm_port->is_uartdm >= UARTDM_1P4)
+	if (msm_port->is_uartdm >= UARTDM_1P4) {
 		msm_write(port, UARTDM_DMEN_RX_SC_ENABLE, UARTDM_DMEN);
+		msm_port->rx_sc_enabled = 1;
+	}
+
+	/* set RX watermark (number of words) */
+	watermark = (port->fifosize * 3) / 4;  /* 1 byte per word */
+	msm_write(port, watermark, UART_RFWR);
 
 	return 0;
 }
