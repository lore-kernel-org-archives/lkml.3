Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaFPNTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:19:03 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41797 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753208AbaFPNRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:17:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 05/22] tty: Document locking for tty_port_hangup()
Date: Mon, 16 Jun 2014 09:17:02 -0400
Message-Id: <1402924639-5164-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty lock is held when the tty driver's hangup() method is called
(from the lone call-site, __tty_hangup()). The call-tree audit [1]
of tty_port_hangup() is a closed graph of the callers of
tty_port_hangup(); ie., all callers originate only from __tty_hangup().

Of these callers, none drop the tty lock prior to calling
tty_port_hangup().

[1]
Call-tree audit of tty_port_hangup()

__tty_hangup()
  tty->ops->hangup() --+
                       |
        rs_hangup():arch/ia64/hp/sim/simserial.c
        line_hangup():arch/um/drivers/line.c
        gdm_tty_hangup():drivers/staging/gdm724x/gdm_tty.c
        fwtty_hangup():drivers/staging/fwserial/fwserial.c
        acm_tty_hangup():drivers/usb/class/cdc-acm.c
        serial_hangup():drivers/usb/serial/usb-serial.c
        ipoctal_hangup():drivers/ipack/devices/ipoctal.c
        cy_hangup():drivers/tty/cyclades.c
        isicom_hangup():drivers/tty/isicom.c
        rp_hangup():drivers/tty/rocket.c
        dashtty_hangup():drivers/tty/metag_da.c
        moxa_hangup():drivers/tty/moxa.c
        gsmtty_hangup():drivers/tty/n_gsm.c
        goldfish_tty_hangup():drivers/tty/goldfish.c
        ehv_bc_tty_hangup():drivers/tty/ehv_bytechan.c
        mxser_hangup():drivers/tty/mxser.c
        kgdb_nmi_tty_hangup():drivers/tty/serial/kgdb_nmi.c
        ifx_spi_hangup():drivers/tty/serial/ifx6x60.c
        ntty_hangup():drivers/tty/nozomi.c
        capinc_tty_hangup():drivers/isdn/capi/capi.c
        mgslpc_hangup():drivers/char/pcmcia/synclink_cs.c
        sdio_uart_hangup():drivers/mmc/card/sdio_uart.c
        rfcomm_tty_hangup():net/bluetooth/rfcomm/tty.c
                       |
                       +- tty_port_hangup()

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 69e072b..7309594 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -227,6 +227,8 @@ out:
  *
  *	Perform port level tty hangup flag and count changes. Drop the tty
  *	reference.
+ *
+ *	Caller holds tty lock.
  */
 
 void tty_port_hangup(struct tty_port *port)
-- 
2.0.0

