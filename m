Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaEVJu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:50:57 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39574 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaEVJu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:50:56 -0400
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, jon.povey@racelogic.co.uk,
        gregkh@linuxfoundation.org, balbi@ti.com,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH] PREEMPT_RT: USB serial gadget: Fix locking issue
Date: Thu, 22 May 2014 11:45:10 +0200
Message-Id: <1400751910-5519-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_PREEMPT_RT_FULL the tty_flip_buffer_push(..) actions are executed
immeditely (same behaviour as if low_latency flag was set). We thus have to
release port_lock before callng tty_flip_buffer_push().

This issue resultst of commits:
44a0c019: USB: g_serial: don't set low_latency flag
dc0cbd1b: serial: 8250: Call flush_to_ldisc when the irq is threaded

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/usb/gadget/u_serial.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index b369292..1c4f404 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -549,12 +549,25 @@ static void gs_rx_push(unsigned long _port)
 		port->read_started--;
 	}
 
-	/* Push from tty to ldisc; without low_latency set this is handled by
-	 * a workqueue, so we won't get callbacks and can hold port_lock
-	 */
-	if (do_push)
+	/* Push from tty to ldisc */
+	if (do_push) {
+#ifndef CONFIG_PREEMPT_RT_FULL
+		/* without low_latency set this is handled by a workqueue, so
+		 * we won't get callbacks and can hold port_lock
+		*/
 		tty_flip_buffer_push(&port->port);
-
+#else
+		/* CONFIG_PREEMPT_RT_FULL makes this a synchronous action. and
+		 * it may trigger synchronous callbacks to this driver. We need
+		 * to release the lock.
+		*/
+		spin_unlock_irq(&port->port_lock);
+		tty_flip_buffer_push(&port->port);
+		spin_lock_irq(&port->port_lock);
+		/* tty may have been closed */
+		tty = port->port_tty;
+#endif
+	}
 
 	/* We want our data queue to become empty ASAP, keeping data
 	 * in the tty and ldisc (not here).  If we couldn't push any
-- 
1.9.2

