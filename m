Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaFPNTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:19:01 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37241 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751679AbaFPNRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:17:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 06/22] tty: Move tty->closing from port lock critical section
Date: Mon, 16 Jun 2014 09:17:03 -0400
Message-Id: <1402924639-5164-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty->closing informs the line discipline that the hardware will
be shutting down imminently, and to disable further input other
than soft flow control (but to still allow additional output).

However, the tty lock is the necessary lock for preventing
concurrent changes to tty->closing. As shown by the call-tree
audit [1] of functions that modify tty->closing, the tty lock
is already held for those functions.

[1]
Call-tree audit of functions that modify tty->closing
* does not include call tree to tty_port_close(), tty_port_close_start(),
  or tty_port_close_end() which is already documented in
  'tty: Document locking for tty_port_close{,start,end}' that shows
  callers to those 3 functions hold the tty lock

tty_release()
  tty->ops->close() --+
                      |
__tty_hangup()        |
  tty->ops->close() --+
                      |
        mp_close():drivers/staging/sb105x/sb_pci_mp.c
        dngc_tty_close():drivers/staging/dgnc/dgnc_tty.c
        dgap_tty_close():drivers/staging/dgap/dgap_tty.c
        dgrp_tty_close():drivers/staging/dgrp/dgrp_tty.c
        rp_close():drivers/tty/rocket.c
        hvsi_close():drivers/tty/hvc/hvsi.c
        rs_close():drivers/tty/serial/68328serial.c
        rs_close():drivers/tty/serial/crisv10.c
        uart_close():drivers/tty/serial/serial_core.c
        isdn_tty_close():drivers/isdn/i4l/isdn_tty.c
        tty3215_close():drivers/s390/char/con3215.c

tty_open()
  tty_ldisc_setup() ----+
                        |
__tty_hangup()          |
  tty_ldisc_hangup() ---+
                        |
tty_set_ldisc() --------+
  tty_ldisc_restore() --+
                        |
                        +- tty_ldisc_open()
                             ld->ops->open() --+
                                               |
                                               +- n_tty_open()

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 2 +-
 drivers/tty/tty_port.c           | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index b68550d..f2febb4 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1356,8 +1356,8 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	tty_ldisc_flush(tty);
 
 	tty_port_tty_set(port, NULL);
-	spin_lock_irqsave(&port->lock, flags);
 	tty->closing = 0;
+	spin_lock_irqsave(&port->lock, flags);
 
 	if (port->blocked_open) {
 		spin_unlock_irqrestore(&port->lock, flags);
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 7309594..9209d63 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -497,9 +497,10 @@ int tty_port_close_start(struct tty_port *port,
 		return 0;
 	}
 	set_bit(ASYNCB_CLOSING, &port->flags);
-	tty->closing = 1;
 	spin_unlock_irqrestore(&port->lock, flags);
 
+	tty->closing = 1;
+
 	if (test_bit(ASYNCB_INITIALIZED, &port->flags)) {
 		/* Don't block on a stalled port, just pull the chain */
 		if (tty->flow_stopped)
@@ -522,9 +523,10 @@ void tty_port_close_end(struct tty_port *port, struct tty_struct *tty)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	tty->closing = 0;
 
+	spin_lock_irqsave(&port->lock, flags);
+
 	if (port->blocked_open) {
 		spin_unlock_irqrestore(&port->lock, flags);
 		if (port->close_delay) {
-- 
2.0.0

