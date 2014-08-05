Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaHEBGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:06:38 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57657 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaHEBGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:06:35 -0400
Message-ID: <53E02E18.60602@gmail.com>
Date: Mon, 04 Aug 2014 18:06:32 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
CC: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [test patch 3/4] use poll_post_exception in msm_serial
References: <53E02C7C.4090206@gmail.com>
In-Reply-To: <53E02C7C.4090206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@sonymobile.com>


**********************************************************
I need help with this patch - it does not fix the issue.
**********************************************************


Use framework to allow msm_serial driver to fixup state after operating in
polled mode, before returning to interrupt mode.

I do not have complete documentation on the hardware, so this patch is a
set of shots in the dark.  Each experiment can be enabled by enabling
a #define.

The issue I am trying to resolve with this patch is:

   kgdb properly communicates with the dragon board, but
   following the continue command, the serial driver does not get any stale
   (UART_IMR_RXSTALE) interrupts until 48 characters have been read, which
   triggers a high water interrupt.  After the high water interrupt has been
   processed, the driver resumes properly getting stale interrupts.

msm_poll_post_exception() will be called near the tail end of kgdb_cpu_enter(),
via the path invoked by:

   /* Call the I/O driver's post_exception routine */
   if (dbg_io_ops->post_exception)
      dbg_io_ops->post_exception();



Not-signed-off-by-yet: Frank Rowand <frank.rowand@sonymobile.com>

---
 drivers/tty/serial/msm_serial.c |  196 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 196 insertions(+)

Index: b/drivers/tty/serial/msm_serial.c
===================================================================
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -881,6 +881,201 @@ static void msm_poll_put_char(struct uar
 
 	return;
 }
+
+int zzz_poll_put_char_reset;
+static void msm_poll_post_exception(struct uart_port *port)
+{
+	int misr;
+	struct msm_port *msm_port = UART_TO_MSM(port);
+
+	zzz_poll_put_char_reset++;
+
+	msm_port->old_snap_state = 0;
+
+// #define ZZZ_ALT_1
+#ifdef ZZZ_ALT_1
+	/*
+	 * zzz alternate 1 -- trigger high water after continue <---- bad
+	 *        high water count == 48, set old_snap_state = 48
+	 *        then stale total snap == 49, so count == 1    <---- good
+	 *
+	 *     better than alternate 2
+	 */
+	msm_read(port, UARTDM_RX_TOTAL_SNAP);
+
+#if 0
+	misr = msm_read(port, UART_MISR);
+	if (misr & (UART_IMR_RXSTALE))
+#endif
+		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
+	msm_write(port, 0xFFFFFF, UARTDM_DMRX);
+	msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
+#endif /* ZZZ_ALT_1 */
+
+
+// #define ZZZ_ALT_2
+#ifdef ZZZ_ALT_2
+	/*
+	 * zzz alternate 2 -- trigger high water after continue <---- bad
+	 *        high water count == 48, set old_snap_state = 48
+	 *        next total snap == 310
+	 *        then stale total snap == 310, so count == 262 <---- bad
+	 */
+	msm_read(port, UARTDM_RX_TOTAL_SNAP);
+
+	msm_write(port, UART_CR_CMD_FORCE_STALE, UART_CR);
+#endif
+
+
+// #define ZZZ_ALT_3_4
+#ifdef ZZZ_ALT_3_4
+	/*
+	 * zzz alternate 3 -- never trigger after continue <---- bad
+	 */
+	msm_read(port, UARTDM_RX_TOTAL_SNAP);
+
+	msm_write(port, 0xFFFFFF, UARTDM_DMRX);
+	msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
+
+	msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
+	msm_write(port, UART_CR_CMD_FORCE_STALE, UART_CR);
+
+#if 0
+	/*
+	 * zzz alternate 3, #if 1 this block
+	 * zzz alternate 4, #if 0 this block
+	 * zzz alternate 4 -- trigger high water after continue <---- bad
+	 *        high water count == 48, set old_snap_state = 48
+	 *        then stale total snap == 49, so count == 1    <---- good
+	 */
+	misr = msm_read(port, UART_MISR);
+	while (!(misr & (UART_IMR_RXSTALE))) {
+		cpu_relax();
+		misr = msm_read(port, UART_MISR);
+	}
+#endif
+
+#endif /* ZZZ_ALT_3_4 */
+
+
+// #define ZZZ_ALT_5
+#ifdef ZZZ_ALT_5
+	/*
+	 * zzz alternate 5 -- trigger high water after continue <---- bad
+	 *        high water count == 48, set old_snap_state = 48
+	 *        then stale total snap == 49, so count == 1    <---- good
+	 */
+	msm_read(port, UARTDM_RX_TOTAL_SNAP);
+
+#if 0
+	misr = msm_read(port, UART_MISR);
+	if (misr & (UART_IMR_RXSTALE))
+#endif
+		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
+	msm_write(port, 0xFFFFFF, UARTDM_DMRX);
+	msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
+
+	/* zzz should not have to do this, trying anyway */
+	/* restore interrupt */
+	msm_write(port, msm_port->imr, UART_IMR);
+#endif /* ZZZ_ALT_5 */
+
+
+// #define ZZZ_ALT_6
+#ifdef ZZZ_ALT_6
+	/*
+	 * zzz alternate 6 -- trigger high water after continue <---- bad
+	 *        high water count == 48, set old_snap_state = 48
+	 *        then stale total snap == 49, so count == 1    <---- good
+	 */
+	msm_read(port, UARTDM_RX_TOTAL_SNAP);
+
+	msm_write(port, 0, UART_IMR); /* disable interrupt */
+
+	misr = msm_read(port, UART_MISR);
+	if (misr & (UART_IMR_RXSTALE))
+		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
+	msm_write(port, 0xFFFFFF, UARTDM_DMRX);
+	msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
+
+	msm_write(port, UART_CR_CMD_FORCE_STALE, UART_CR);
+
+	/* restore interrupt */
+	msm_write(port, msm_port->imr, UART_IMR);
+
+#endif /* ZZZ_ALT_6 */
+
+
+#define ZZZ_ALT_7
+#ifdef ZZZ_ALT_7
+	/*
+	 * Try to emulate entire interrupt driver read path....
+	 *
+	 * zzzzzz  what is missing that is fixed by the high water irq???
+	 *
+	 * same result for versions A, B, C
+	 * zzz alternate 7 -- trigger high water after continue <---- bad
+	 *        high water count == 48, set old_snap_state = 48
+	 *        then stale total snap == 49, so count == 1    <---- good
+	 */
+
+{
+	int imr_rx_stale;
+	unsigned int sr;
+
+	/*
+	 * zzz Grabbing a lock here will result in a deadlock if a breakpoint
+	 * zzz is hit while the lock is held elsewhere.  It would be best to
+	 * zzz avoid this lock if possible.
+	 *
+	 * zzz It would be better to do a trylock and warn on failure to
+	 * zzz acquire.
+	 */
+	spin_lock(&port->lock);
+
+	misr = msm_read(port, UART_MISR);
+	imr_rx_stale = misr & UART_IMR_RXSTALE;
+
+	msm_write(port, 0, UART_IMR); /* disable interrupt */
+
+	if ((msm_read(port, UART_SR) & UART_SR_OVERRUN))
+		msm_write(port, UART_CR_CMD_RESET_ERR, UART_CR);
+
+
+	/* zzz version A, read _either_ UARTDM_RX_TOTAL_SNAP or UART_RFWR */
+	/* zzz version B, read UARTDM_RX_TOTAL_SNAP and UART_RFWR */
+	/* zzz version C, read UART_RFWR */
+	if (imr_rx_stale)
+		msm_read(port, UARTDM_RX_TOTAL_SNAP);
+	else
+		msm_read(port, UART_RFWR);
+
+	sr = msm_read(port, UART_SR);
+	/* zzz this could be: while (sr & ...) {UARTDM_RF; UART_SR;} */
+	while ((sr & UART_SR_RX_READY) != 0) {
+		msm_read(port, UARTDM_RF);
+		sr = msm_read(port, UART_SR);
+	}
+
+	if (imr_rx_stale)
+		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
+	msm_write(port, 0xFFFFFF, UARTDM_DMRX);
+	msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
+
+	msm_write(port, msm_port->imr, UART_IMR); /* restore interrupt */
+
+	spin_unlock(&port->lock);
+}
+
+#endif /* ZZZ_ALT_7 */
+
+
+
+	return;
+}
+
+
+
 #endif
 
 static struct uart_ops msm_uart_pops = {
@@ -905,6 +1100,7 @@ static struct uart_ops msm_uart_pops = {
 	.poll_init = msm_poll_init,
 	.poll_get_char	= msm_poll_get_char,
 	.poll_put_char	= msm_poll_put_char,
+	.poll_post_exception = msm_poll_post_exception,
 #endif
 };
 
