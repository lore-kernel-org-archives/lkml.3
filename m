Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaFPNTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:19:53 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54839 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753127AbaFPNRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:17:46 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 04/22] tty: Document locking for tty_port_block_til_ready()
Date: Mon, 16 Jun 2014 09:17:01 -0400
Message-Id: <1402924639-5164-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty lock is held when the tty driver's open() method is called
(from tty_open()). The call-tree audit [1] of tty_port_block_til_ready()
is a closed graph of the callers of tty_port_block_til_ready();
ie., all callers originate only from tty_open().

Of these callers, none drop the tty lock.

Also, document tty_port_block_til_ready() may drop and reacquire
the tty lock when blocking, which means the tty or tty_port may have
changed state.

[1]
Call-tree audit of tty_port_block_til_ready()
* does not include call tree of tty_port_open() which is already
  documented in 'tty: Document locking from tty_port_open()'

tty_open()
  tty->ops->open() --+
                     |
        cy_open():drivers/tty/cyclades.c
        rp_open():drivers/tty/rocket.c
        rs_open():drivers/tty/amiserial.c
        moxa_open():drivers/tty/moxa.c
        gsmtty_open():drivers/tty/n_gsm.c
        rs_open():drivers/tty/serial/68328serial.c
        uart_open():drivers/tty/serial/serial_core.c
        isdn_tty_open():drivers/isdn/i4l/isdn_tty.c
        mgslpc_open():drivers/char/pcmcia/synclink_cs.c
                     |
                     +- tty_port_block_til_ready()

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_port.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index f469869..69e072b 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -348,6 +348,11 @@ EXPORT_SYMBOL(tty_port_lower_dtr_rts);
  *	do carrier detect and the dtr_rts method if it supports software
  *	management of these lines. Note that the dtr/rts raise is done each
  *	iteration as a hangup may have previously dropped them while we wait.
+ *
+ *	Caller holds tty lock.
+ *
+ *      NB: May drop and reacquire tty lock when blocking, so tty and tty_port
+ *      may have changed state (eg., may have been hung up).
  */
 
 int tty_port_block_til_ready(struct tty_port *port,
-- 
2.0.0

