Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaIJTdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:33:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:35471 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaIJTdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:33:33 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC PATCH] tty: serial: core: Only invoke ->start_tx() if there is data to send
Date: Wed, 10 Sep 2014 21:33:21 +0200
Message-Id: <1410377601-26794-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that the serial8250_tx_dma() is invoked sometimes while
uart_circ_empty() says that the buffer is empty.

I tracked one occuring down to:

n_tty_write()
	 => O_OPOST(tty))
	   => the while loop did something but neither tty's ->write()
	      nor its ->uart_put_char() callback was invoked().
	   => tty->ops->flush_chars() is invoked with an empty buffer.

For the 8250 uart driver we end up with:
- DMA enabled
  nothing, just return (except there is DMA_TX bug or runtime-PM then we
  behave like in the no DMA case)

- no DMA
  enable THRI interrupt, wait for it, disable THRI interrupt again
  because there is nothing to be done.

While I don't know if it safe to drop that flush in n_tty if the buffer
is empty, it should not do any harm in serial's core part to not invoke
->start_tx() if the buffer is empty.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/serial_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 5a78f6940760..e55724a911d5 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -90,7 +90,8 @@ static void __uart_start(struct tty_struct *tty)
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *port = state->uart_port;
 
-	if (!tty->stopped && !tty->hw_stopped)
+	if (!tty->stopped && !tty->hw_stopped &&
+			!uart_circ_empty(&port->state->xmit))
 		port->ops->start_tx(port);
 }
 
-- 
2.1.0

