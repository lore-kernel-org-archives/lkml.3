Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbaCTTcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:32:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53502 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbaCTTcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:32:07 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <peter@hurleysoftware.com>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 10/11] Revert "serial: omap: unlock the port lock"
Date: Thu, 20 Mar 2014 14:30:06 -0500
Message-ID: <1395343807-21618-10-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395343807-21618-1-git-send-email-balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 0324a821029e1f54e7a7f8fed48693cfce42dc0e.

That commit tried to fix a deadlock problem when using
hci_ldisc, but it turns out the bug was in hci_ldsic
all along where it was calling ->write() from within
->write_wakeup() callback.

The problem is that ->write_wakeup() was called with
port lock held and ->write() tried to grab the same
port lock.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index b092d3d..be10e7e 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -380,11 +380,8 @@ static void transmit_chars(struct uart_omap_port *up, unsigned int lsr)
 			break;
 	} while (--count > 0);
 
-	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS) {
-		spin_unlock(&up->port.lock);
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&up->port);
-		spin_lock(&up->port.lock);
-	}
 
 	if (uart_circ_empty(xmit))
 		serial_omap_stop_tx(&up->port);
-- 
1.9.1.286.g5172cb3

