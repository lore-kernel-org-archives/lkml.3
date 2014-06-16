Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaFPNT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:19:57 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41290 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752624AbaFPNRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:17:46 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 02/22] tty: Document locking for tty_port_close{,start,end}()
Date: Mon, 16 Jun 2014 09:16:59 -0400
Message-Id: <1402924639-5164-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty lock is held when the tty driver's .close method is called
(from the two lone call-sites of tty_release() and __tty_hangup()).
The call-tree audit[1] of tty_port_close(), tty_port_close_start,
and tty_port_close_end() is a closed graph of the callers of these
3 functions; ie., all callers originate from only tty_release()
or __tty_hangup().

Of these callers, none drop the tty lock.

Also, document tty_port_close_start() may drop and reacquire the
tty lock in tty_wait_until_sent_from_close(), which means the tty
or tty_port may have changed state (but not reopened or hung up).

[1]
Call-tree audit of tty_port_close, tty_port_close_start, and tty_port_close_end()

tty_release()
  tty->ops->close() --+
                      |
__tty_hangup()        |
  tty->ops->close() --+
                      |
                      +- rp_close():drivers/tty/rocket.c -------------------+
                      +- uart_close():drivers/tty/serial/serial_core.c -----+
                      |                                                     +- tty_port_close_start()
                      |
                      |
                      +- close():drivers/tty/synclinkmp.c ------------------+
                      +- rs_close():drivers/tty/amiserial.c ----------------+
                      +- gsmtty_close():drivers/tty/n_gsm.c ----------------+
                      +- mxser_close():drivers/tty/mxser.c -----------------+
                      +- close():drivers/tty/synclink_gt.c -----------------+
                      +- mgsl_close():drivers/tty/synclink.c ---------------+
                      +- isdn_tty_close():drivers/isdn/i4l/isdn_tty.c ------+
                      +- mgslpc_close():drivers/char/pcmcia/synclink_cs.c --+
                      +- ircomm_tty_close():net/irda/ircomm/ircomm_tty.c ---+
                      |                                                     |
        rs_close():arch/ia64/hp/sim/simserial.c                             |
       *line_close():arch/um/drivers/line.c                                 |
        gdm_tty_close():drivers/staging/gdm724x/gdm_tty.c
        fwtty_close():drivers/staging/fwserial/fwserial.c
        acm_tty_close():drivers/usb/class/cdc-acm.c
        serial_close():drivers/usb/serial/usb-serial.c
        pti_tty_driver_close():drivers/misc/pti.c
        ipoctal_close():drivers/ipack/devices/ipoctal.c
        cy_close():drivers/tty/cyclades.c
        isicom_close():drivers/tty/isicom.c
        dashtty_close():drivers/tty/metag_da.c
        moxa_close():drivers/tty/moxa.c
        goldfish_tty_close():drivers/tty/goldfish.c
        ehv_bc_tty_close():drivers/tty/ehv_bytechan.c
        kgdb_nmi_tty_close():drivers/tty/serial/kgdb_nmi.c
        ifx_spi_close():drivers/tty/serial/ifx6x60.c
        smd_tty_close():drivers/tty/serial/msm_smd_tty.c
        ntty_close():drivers/tty/nozomi.c
        capinc_tty_close():drivers/isdn/capi/capi.c
        tpk_close():drivers/char/ttyprintk.c
        sdio_uart_close():drivers/mmc/card/sdio_uart.c                      |
        rfcomm_tty_close():net/bluetooth/rfcomm/tty.c                       |
                      |                                                     |
                      +- tty_port_close():drivers/tty/tty_port.c -----------+
                                                                            |
                                                                            +- tty_port_close_start()
                                                                            +- tty_port_close_end()

* line_close() is the .close method for 2 um drivers,
  declared in ./arch/um/drivers/stdio_console.c and
  in ./arch/um/drivers/ssl.c, and not called directly

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_port.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 3f746c8..bcc15f7 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -458,6 +458,10 @@ static void tty_port_drain_delay(struct tty_port *port, struct tty_struct *tty)
 	schedule_timeout_interruptible(timeout);
 }
 
+/* Caller holds tty lock.
+ * NB: may drop and reacquire tty lock (in tty_wait_until_sent_from_close())
+ * so tty and tty port may have changed state (but not hung up or reopened).
+ */
 int tty_port_close_start(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp)
 {
@@ -506,6 +510,7 @@ int tty_port_close_start(struct tty_port *port,
 }
 EXPORT_SYMBOL(tty_port_close_start);
 
+/* Caller holds tty lock */
 void tty_port_close_end(struct tty_port *port, struct tty_struct *tty)
 {
 	unsigned long flags;
@@ -528,6 +533,15 @@ void tty_port_close_end(struct tty_port *port, struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_port_close_end);
 
+/**
+ * tty_port_close
+ *
+ * Caller holds tty lock
+ *
+ * NB: may drop and reacquire tty lock (in tty_port_close_start()->
+ * tty_wait_until_sent_from_close()) so tty and tty_port may have changed
+ * state (but not hung up or reopened).
+ */
 void tty_port_close(struct tty_port *port, struct tty_struct *tty,
 							struct file *filp)
 {
-- 
2.0.0

