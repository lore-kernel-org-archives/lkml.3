Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbaCQNLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:11:09 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:34369 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaCQNLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:11:05 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 2/2] [RFC] serial_core: Avoid NULL pointer dereference in uart_close()
Date: Mon, 17 Mar 2014 14:10:59 +0100
Message-Id: <1395061859-15295-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395061859-15295-1-git-send-email-geert@linux-m68k.org>
References: <1395061859-15295-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

When unbinding a serial driver that's being used as a serial console,
the kernel may crash with a NULL pointer dereference in a uart_*() function
called from uart_close () (e.g. uart_flush_buffer() or
uart_chars_in_buffer()).

To fix this, let uart_close() check for port->count == 0. If this is the
case, bail out early. Else tty_port_close_start() will make the port
counts inconsistent, printing out warnings like

    tty_port_close_start: tty->count = 1 port count = 0.

and

    tty_port_close_start: count = -1

and once uport == NULL, it will also crash.

Also fix the related crash in pr_debug() by checking for a non-NULL uport
first.

Detailed description:

On driver unbind, uart_remove_one_port() is called. Basically it;
  - marks the port dead,
  - calls tty_vhangup(),
  - sets state->uart_port = NULL.

What will happen depends on whether the port is just in use by e.g. getty,
or was also opened as a console.

A. If the tty was not opened as a console:

  - tty_vhangup() will (in __tty_hangup()):
      - mark all file descriptors for this tty hung up by pointing them to
	hung_up_tty_fops,
      - call uart_hangup(), which sets port->count to 0.

  - A subsequent uart_open() (this may be through /dev/ttyS*, or through
    /dev/console if this is a serial console) will fail with -ENXIO as the
    port was marked dead,
  - uart_close() after the failed uart_open() will return early, as
    tty_hung_up_p() (called from tty_port_close_start()) will notice it was
    hung up.

B. If the tty was also opened as a console:

  - tty_vhangup() will (in __tty_hangup()):
      - mark non-console file descriptors for this tty hung up by pointing
	them to hung_up_tty_fops,
      - NOT call uart_hangup(), but instead call uart_close() for every
        non-console file descriptor, so port->count will still have a
	non-zero value afterwards.

  - A subsequent uart_open() will fail with -ENXIO as the port was
    marked dead,
  - uart_close() after the failed uart_open() starts to misbehave:
      - tty_hung_up_p() will not notice it was hung up,
      - As port->count is non-zero, tty_port_close_start() will decrease
        port->count, making the tty and port counts inconsistent. Later,
	warnings like these will be printed:

	    tty_port_close_start: tty->count = 1 port count = 0.

	and
	    tty_port_close_start: count = -1

      - If all of this happens after state->uart_port was set to zero, a
        NULL pointer dereference will happen.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
This still doesn't fix everything, but avoids the NULL pointer dereference.

In case B, port->count is still non-zero after tty_vhangup().  Hence when
uart_close() is called after a failed uart_open(), it will decrement
port->count, and, on reaching zero, it will close the port for real (incl.
calling uart_shutdown()).  This doesn't seem to cause any harm, though.
Besides, if uart_close() wouldn't do that, who else would shut down the
port?

As tty_open() always calls tty_release() on failure of ->open(),
->close() is always called.
How can uart_close() after a failed uart_open() know it should not do
anything? Set a (new) flag in its port structure?
---
 drivers/tty/serial/serial_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 21084f0b8ea4..56dda84f82a5 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1319,9 +1319,9 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	uport = state->uart_port;
 	port = &state->port;
 
-	pr_debug("uart_close(%d) called\n", uport->line);
+	pr_debug("uart_close(%d) called\n", uport ? uport->line : -1);
 
-	if (tty_port_close_start(port, tty, filp) == 0)
+	if (!port->count || tty_port_close_start(port, tty, filp) == 0)
 		return;
 
 	/*
-- 
1.7.9.5

