Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaFPNTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:19:54 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57189 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753120AbaFPNRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:17:46 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 03/22] tty: Document locking for tty_port_open()
Date: Mon, 16 Jun 2014 09:17:00 -0400
Message-Id: <1402924639-5164-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty lock is held when the tty driver's open method is called
(from the lone call-site, tty_open()). The call-tree audit [1] of
tty_port_open() is a closed graph of the callers of tty_port_open();
ie., all callers originate from only tty_open().

Of these callers, none drop the tty lock.

Also, document that tty_port_block_til_ready() may drop and reacquire
the tty lock when blocking, which means the tty or tty_port may have
changed state.

[1]
Call-tree audit of tty_port_open()

tty_open()
  tty->ops->open() --+
                     |
        rs_open():arch/ia64/hp/sim/simserial.c
       *line_open():arch/um/drivers/line.c
        gdm_tty_open():drivers/staging/gdm724x/gdm_tty.c
        fwtty_open():drivers/staging/fwserial/fwserial.c
        acm_tty_open():drivers/usb/class/cdc-acm.c
        serial_open():drivers/usb/serial/usb-serial.c
        pti_tty_driver_open():drivers/misc/pti.c
        ipoctal_open():drivers/ipack/devices/ipoctal.c
        isicom_open():drivers/tty/isicom.c
        dashtty_open():drivers/tty/metag_da.c
        goldfish_tty_open():drivers/tty/goldfish.c
        ehv_bc_tty_open():drivers/tty/ehv_bytechan.c
        mxser_open():drivers/tty/mxser.c
        kgdb_nmi_tty_open():drivers/tty/serial/kgdb_nmi.c
        ifx_spi_open():drivers/tty/serial/ifx6x60.c
        smd_tty_open():drivers/tty/serial/msm_smd_tty.c
        ntty_open():drivers/tty/nozomi.c
        capinc_tty_open():drivers/isdn/capi/capi.c
        tpk_open():drivers/char/ttyprintk.c
        sdio_uart_open():drivers/mmc/card/sdio_uart.c
        rfcomm_tty_open():net/bluetooth/rfcomm/tty.c
                     |
                     +- tty_port_open()

* line_open() is the .open method for 2 um drivers
  declared in ./arch/um/drivers/stdio_console.c and
  in ./arch/um/drivers/ssl.c, and not called directly

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_port.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index bcc15f7..f469869 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -572,6 +572,14 @@ int tty_port_install(struct tty_port *port, struct tty_driver *driver,
 }
 EXPORT_SYMBOL_GPL(tty_port_install);
 
+/**
+ * tty_port_open
+ *
+ * Caller holds tty lock.
+ *
+ * NB: may drop and reacquire tty lock (in tty_port_block_til_ready()) so
+ * tty and tty_port may have changed state (eg., may be hung up now)
+ */
 int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 							struct file *filp)
 {
-- 
2.0.0

