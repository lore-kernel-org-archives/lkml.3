Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaKESNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:13:07 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34256 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751339AbaKESMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:12:02 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 3/5] serial: core: Pass termios to set_ldisc() notifications
Date: Wed,  5 Nov 2014 13:11:43 -0500
Message-Id: <1415211105-16668-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415211105-16668-1-git-send-email-peter@hurleysoftware.com>
References: <1415211105-16668-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UART drivers which enable modem status interrupts when switching
to N_PPS line discipline need to determine if modem status
interrupts should be disabled when switching from N_PPS.
Specifically, the set_ldisc() notification needs to evaluate
UART_ENABLE_MS() which requires termios->c_cflag.

Convert in-tree UART drivers to new interface.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_core.c | 4 ++--
 drivers/tty/serial/amba-pl010.c     | 4 ++--
 drivers/tty/serial/atmel_serial.c   | 4 ++--
 drivers/tty/serial/bfin_uart.c      | 5 +++--
 drivers/tty/serial/clps711x.c       | 5 +++--
 drivers/tty/serial/serial_core.c    | 2 +-
 include/linux/serial_core.h         | 2 +-
 7 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index ca5cfdc..6cfdb7b 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2603,9 +2603,9 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 }
 
 static void
-serial8250_set_ldisc(struct uart_port *port, int new)
+serial8250_set_ldisc(struct uart_port *port, struct ktermios *termios)
 {
-	if (new == N_PPS) {
+	if (termios->c_line == N_PPS) {
 		port->flags |= UPF_HARDPPS_CD;
 		serial8250_enable_ms(port);
 	} else
diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 2064d31..76e40b3 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -468,9 +468,9 @@ pl010_set_termios(struct uart_port *port, struct ktermios *termios,
 	spin_unlock_irqrestore(&uap->port.lock, flags);
 }
 
-static void pl010_set_ldisc(struct uart_port *port, int new)
+static void pl010_set_ldisc(struct uart_port *port, struct ktermios *termios)
 {
-	if (new == N_PPS) {
+	if (termios->c_line == N_PPS) {
 		port->flags |= UPF_HARDPPS_CD;
 		pl010_enable_ms(port);
 	} else
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 8a84034..a2374d9 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2042,9 +2042,9 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
-static void atmel_set_ldisc(struct uart_port *port, int new)
+static void atmel_set_ldisc(struct uart_port *port, struct ktermios *termios)
 {
-	if (new == N_PPS) {
+	if (termios->c_line == N_PPS) {
 		port->flags |= UPF_HARDPPS_CD;
 		atmel_enable_ms(port);
 	} else {
diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 7da9911..44b27ec 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -944,12 +944,13 @@ bfin_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
  * Enable the IrDA function if tty->ldisc.num is N_IRDA.
  * In other cases, disable IrDA function.
  */
-static void bfin_serial_set_ldisc(struct uart_port *port, int ld)
+static void bfin_serial_set_ldisc(struct uart_port *port,
+				  struct ktermios *termios)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
 	unsigned int val;
 
-	switch (ld) {
+	switch (termios->c_line) {
 	case N_IRDA:
 		val = UART_GET_GCTL(uart);
 		val |= (UMOD_IRDA | RPOLC);
diff --git a/drivers/tty/serial/clps711x.c b/drivers/tty/serial/clps711x.c
index acfe317..f963c4c 100644
--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -225,13 +225,14 @@ static void uart_clps711x_break_ctl(struct uart_port *port, int break_state)
 	writel(ubrlcr, port->membase + UBRLCR_OFFSET);
 }
 
-static void uart_clps711x_set_ldisc(struct uart_port *port, int ld)
+static void uart_clps711x_set_ldisc(struct uart_port *port,
+				    struct ktermios *termios)
 {
 	if (!port->line) {
 		struct clps711x_port *s = dev_get_drvdata(port->dev);
 
 		regmap_update_bits(s->syscon, SYSCON_OFFSET, SYSCON1_SIREN,
-				   (ld == N_IRDA) ? SYSCON1_SIREN : 0);
+				   (termios->c_line == N_IRDA) ? SYSCON1_SIREN : 0);
 	}
 }
 
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 5209eaa..c5fb08c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1247,7 +1247,7 @@ static void uart_set_ldisc(struct tty_struct *tty)
 
 	if (uport->ops->set_ldisc) {
 		mutex_lock(&state->port.mutex);
-		uport->ops->set_ldisc(uport, tty->termios.c_line);
+		uport->ops->set_ldisc(uport, &tty->termios);
 		mutex_unlock(&state->port.mutex);
 	}
 }
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index ad93296..40b4cc4 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -63,7 +63,7 @@ struct uart_ops {
 	void		(*flush_buffer)(struct uart_port *);
 	void		(*set_termios)(struct uart_port *, struct ktermios *new,
 				       struct ktermios *old);
-	void		(*set_ldisc)(struct uart_port *, int new);
+	void		(*set_ldisc)(struct uart_port *, struct ktermios *);
 	void		(*pm)(struct uart_port *, unsigned int state,
 			      unsigned int oldstate);
 
-- 
2.1.3

