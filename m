Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaIJTHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:07:05 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:52578 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753336AbaIJTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:07:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 05/14] usb: serial: Remove unused tty->hw_stopped
Date: Wed, 10 Sep 2014 15:06:27 -0400
Message-Id: <1410375996-4693-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty core does not test tty->hw_stopped; remove from drivers
which don't test it themselves.

cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/usb/serial/digi_acceleport.c  | 7 +------
 drivers/usb/serial/io_ti.c            | 7 +------
 drivers/usb/serial/ti_usb_3410_5052.c | 7 +------
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 8a23c53..12b0e67 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -834,7 +834,6 @@ static void digi_set_termios(struct tty_struct *tty,
 			arg |= DIGI_OUTPUT_FLOW_CONTROL_CTS;
 		} else {
 			arg &= ~DIGI_OUTPUT_FLOW_CONTROL_CTS;
-			tty->hw_stopped = 0;
 		}
 
 		buf[i++] = DIGI_CMD_SET_OUTPUT_FLOW_CONTROL;
@@ -1500,15 +1499,11 @@ static int digi_read_oob_callback(struct urb *urb)
 			if (val & DIGI_READ_INPUT_SIGNALS_CTS) {
 				priv->dp_modem_signals |= TIOCM_CTS;
 				/* port must be open to use tty struct */
-				if (rts) {
-					tty->hw_stopped = 0;
+				if (rts)
 					tty_port_tty_wakeup(&port->port);
-				}
 			} else {
 				priv->dp_modem_signals &= ~TIOCM_CTS;
 				/* port must be open to use tty struct */
-				if (rts)
-					tty->hw_stopped = 1;
 			}
 			if (val & DIGI_READ_INPUT_SIGNALS_DSR)
 				priv->dp_modem_signals |= TIOCM_DSR;
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index c0a42e9..ddbb8fe 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -1456,12 +1456,8 @@ static void handle_new_msr(struct edgeport_port *edge_port, __u8 msr)
 	tty = tty_port_tty_get(&edge_port->port->port);
 	/* handle CTS flow control */
 	if (tty && C_CRTSCTS(tty)) {
-		if (msr & EDGEPORT_MSR_CTS) {
-			tty->hw_stopped = 0;
+		if (msr & EDGEPORT_MSR_CTS)
 			tty_wakeup(tty);
-		} else {
-			tty->hw_stopped = 1;
-		}
 	}
 	tty_kref_put(tty);
 }
@@ -2177,7 +2173,6 @@ static void change_port_settings(struct tty_struct *tty,
 		dev_dbg(dev, "%s - RTS/CTS is enabled\n", __func__);
 	} else {
 		dev_dbg(dev, "%s - RTS/CTS is disabled\n", __func__);
-		tty->hw_stopped = 0;
 		restart_read(edge_port);
 	}
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 3dd3ff8..e9da41d 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -773,7 +773,6 @@ static void ti_set_termios(struct tty_struct *tty,
 			config->wFlags |= TI_UART_ENABLE_RTS_IN;
 		config->wFlags |= TI_UART_ENABLE_CTS_OUT;
 	} else {
-		tty->hw_stopped = 0;
 		ti_restart_read(tport, tty);
 	}
 
@@ -1291,12 +1290,8 @@ static void ti_handle_new_msr(struct ti_port *tport, __u8 msr)
 	/* handle CTS flow control */
 	tty = tty_port_tty_get(&tport->tp_port->port);
 	if (tty && C_CRTSCTS(tty)) {
-		if (msr & TI_MSR_CTS) {
-			tty->hw_stopped = 0;
+		if (msr & TI_MSR_CTS)
 			tty_wakeup(tty);
-		} else {
-			tty->hw_stopped = 1;
-		}
 	}
 	tty_kref_put(tty);
 }
-- 
2.1.0

