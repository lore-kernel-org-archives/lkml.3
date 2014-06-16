Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaFPNX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:23:59 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53691 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753536AbaFPNX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:23:57 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 22/22] serial: Fix locking for uart driver set_termios() method
Date: Mon, 16 Jun 2014 09:17:19 -0400
Message-Id: <1402924639-5164-23-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The low-level uart driver may modify termios settings to override
settings that are not compatible with the uart, such as CRTSCTS.
Thus, callers of the low-level uart driver's set_termios() method must
hold termios_rwsem write lock to prevent concurrent access to termios,
in case such override occurs.

The termios_rwsem lock requirement does not extend to console setup
(ie., uart_set_options), as console setup cannot race with tty
operations. Nor does this lock requirement extend to functions which
cannot be concurrent with tty ioctls (ie., uart_port_startup() and
uart_resume_port()).

Further, always claim the port mutex to protect hardware
re-reprogramming in the set_termios() uart driver method. Note this
is unnecessary for console initialization in uart_set_options()
which cannot be concurrent with other uart operations.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 Documentation/serial/driver      | 6 ++++--
 drivers/tty/serial/serial_core.c | 8 +++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/serial/driver b/Documentation/serial/driver
index c3a7689..b1a22d4 100644
--- a/Documentation/serial/driver
+++ b/Documentation/serial/driver
@@ -59,7 +59,9 @@ The core driver uses the info->tmpbuf_sem lock to prevent multi-threaded
 access to the info->tmpbuf bouncebuffer used for port writes.
 
 The port_sem semaphore is used to protect against ports being added/
-removed or reconfigured at inappropriate times.
+removed or reconfigured at inappropriate times. Since v2.6.27, this
+semaphore has been the 'mutex' member of the tty_port struct, and
+commonly referred to as the port mutex (or port->mutex).
 
 
 uart_ops
@@ -246,7 +248,7 @@ hardware.
 	Other flags may be used (eg, xon/xoff characters) if your
 	hardware supports hardware "soft" flow control.
 
-	Locking: none.
+	Locking: caller holds port->mutex
 	Interrupts: caller dependent.
 	This call must not sleep
 
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 15212d7..5ed5a46 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -427,7 +427,7 @@ uart_get_divisor(struct uart_port *port, unsigned int baud)
 
 EXPORT_SYMBOL(uart_get_divisor);
 
-/* FIXME: Consistent locking policy */
+/* Caller holds port mutex */
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios)
 {
@@ -1162,11 +1162,15 @@ uart_ioctl(struct tty_struct *tty, unsigned int cmd,
 		break;
 
 	case TIOCSSERIAL:
+		down_write(&tty->termios_rwsem);
 		ret = uart_set_info_user(tty, state, uarg);
+		up_write(&tty->termios_rwsem);
 		break;
 
 	case TIOCSERCONFIG:
+		down_write(&tty->termios_rwsem);
 		ret = uart_do_autoconfig(tty, state);
+		up_write(&tty->termios_rwsem);
 		break;
 
 	case TIOCSERGWILD: /* obsolete */
@@ -1268,7 +1272,9 @@ static void uart_set_termios(struct tty_struct *tty,
 		return;
 	}
 
+	mutex_lock(&state->port.mutex);
 	uart_change_speed(tty, state, old_termios);
+	mutex_unlock(&state->port.mutex);
 	/* reload cflag from termios; port driver may have overriden flags */
 	cflag = tty->termios.c_cflag;
 
-- 
2.0.0

