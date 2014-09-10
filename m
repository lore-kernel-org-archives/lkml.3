Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaIJTJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:09:40 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59192 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753219AbaIJTG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:06:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 02/14] serial: core: Privatize modem status enable flags
Date: Wed, 10 Sep 2014 15:06:24 -0400
Message-Id: <1410375996-4693-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The serial core uses the tty port flags, ASYNC_CTS_FLOW and
ASYNC_CD_CHECK, to track whether CTS and DCD changes should be
ignored or handled. However, the tty port flags are not safe for
atomic bit operations and no lock provides serialized updates.

Introduce the struct uart_port status field to track CTS and DCD
enable states, and serialize access with uart port lock. Substitute
uart_cts_enabled() helper for tty_port_cts_enabled().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/mxs-auart.c   |  2 +-
 drivers/tty/serial/serial_core.c | 29 +++++++++++++++++------------
 include/linux/serial_core.h      | 12 ++++++++++++
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index b5c3292..10c2933 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -408,7 +408,7 @@ static void mxs_auart_set_mctrl(struct uart_port *u, unsigned mctrl)
 
 	ctrl &= ~(AUART_CTRL2_RTSEN | AUART_CTRL2_RTS);
 	if (mctrl & TIOCM_RTS) {
-		if (tty_port_cts_enabled(&u->state->port))
+		if (uart_cts_enabled(u))
 			ctrl |= AUART_CTRL2_RTSEN;
 		else
 			ctrl |= AUART_CTRL2_RTS;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 0567b65..3c62b3f 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -58,6 +58,11 @@ static void uart_change_pm(struct uart_state *state,
 
 static void uart_port_shutdown(struct tty_port *port);
 
+static int uart_dcd_enabled(struct uart_port *uport)
+{
+	return uport->status & UPSTAT_DCD_ENABLE;
+}
+
 /*
  * This routine is used by the interrupt handler to schedule processing in
  * the software interrupt portion of the driver.
@@ -129,7 +134,6 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
 		int init_hw)
 {
 	struct uart_port *uport = state->uart_port;
-	struct tty_port *port = &state->port;
 	unsigned long page;
 	int retval = 0;
 
@@ -175,12 +179,12 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
 				uart_set_mctrl(uport, TIOCM_RTS | TIOCM_DTR);
 		}
 
-		if (tty_port_cts_enabled(port)) {
-			spin_lock_irq(&uport->lock);
+		spin_lock_irq(&uport->lock);
+		if (uart_cts_enabled(uport)) {
 			if (!(uport->ops->get_mctrl(uport) & TIOCM_CTS))
 				tty->hw_stopped = 1;
-			spin_unlock_irq(&uport->lock);
 		}
+		spin_unlock_irq(&uport->lock);
 	}
 
 	/*
@@ -431,7 +435,6 @@ EXPORT_SYMBOL(uart_get_divisor);
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios)
 {
-	struct tty_port *port = &state->port;
 	struct uart_port *uport = state->uart_port;
 	struct ktermios *termios;
 
@@ -446,17 +449,19 @@ static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 	uport->ops->set_termios(uport, termios, old_termios);
 
 	/*
-	 * Set flags based on termios cflag
+	 * Set modem status enables based on termios cflag
 	 */
+	spin_lock_irq(&uport->lock);
 	if (termios->c_cflag & CRTSCTS)
-		set_bit(ASYNCB_CTS_FLOW, &port->flags);
+		uport->status |= UPSTAT_CTS_ENABLE;
 	else
-		clear_bit(ASYNCB_CTS_FLOW, &port->flags);
+		uport->status &= ~UPSTAT_CTS_ENABLE;
 
 	if (termios->c_cflag & CLOCAL)
-		clear_bit(ASYNCB_CHECK_CD, &port->flags);
+		uport->status &= ~UPSTAT_DCD_ENABLE;
 	else
-		set_bit(ASYNCB_CHECK_CD, &port->flags);
+		uport->status |= UPSTAT_DCD_ENABLE;
+	spin_unlock_irq(&uport->lock);
 }
 
 static inline int __uart_put_char(struct uart_port *port,
@@ -2753,7 +2758,7 @@ void uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 
 	uport->icount.dcd++;
 
-	if (port->flags & ASYNC_CHECK_CD) {
+	if (uart_dcd_enabled(uport)) {
 		if (status)
 			wake_up_interruptible(&port->open_wait);
 		else if (tty)
@@ -2778,7 +2783,7 @@ void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
 
 	uport->icount.cts++;
 
-	if (tty_port_cts_enabled(port)) {
+	if (uart_cts_enabled(uport)) {
 		if (tty->hw_stopped) {
 			if (status) {
 				tty->hw_stopped = 0;
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 4a43292..bc70048 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -112,6 +112,7 @@ struct uart_icount {
 };
 
 typedef unsigned int __bitwise__ upf_t;
+typedef unsigned int __bitwise__ upstat_t;
 
 struct uart_port {
 	spinlock_t		lock;			/* port lock */
@@ -188,6 +189,12 @@ struct uart_port {
 #define UPF_CHANGE_MASK		((__force upf_t) (0x17fff))
 #define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY))
 
+	/* status must be updated while holding port lock */
+	upstat_t		status;
+
+#define UPSTAT_CTS_ENABLE	((__force upstat_t) (1 << 0))
+#define UPSTAT_DCD_ENABLE	((__force upstat_t) (1 << 1))
+
 	unsigned int		mctrl;			/* current modem ctrl settings */
 	unsigned int		timeout;		/* character-based timeout */
 	unsigned int		type;			/* port type */
@@ -351,6 +358,11 @@ static inline int uart_tx_stopped(struct uart_port *port)
 	return 0;
 }
 
+static inline bool uart_cts_enabled(struct uart_port *uport)
+{
+	return uport->status & UPSTAT_CTS_ENABLE;
+}
+
 /*
  * The following are helper functions for the low level drivers.
  */
-- 
2.1.0

