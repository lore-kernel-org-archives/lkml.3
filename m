Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaKESM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:12:27 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50110 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751431AbaKESME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:12:04 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH -next 5/5] serial: Test/disable MSIs if switching from N_PPS
Date: Wed,  5 Nov 2014 13:11:45 -0500
Message-Id: <1415211105-16668-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415211105-16668-1-git-send-email-peter@hurleysoftware.com>
References: <1415211105-16668-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switching to the N_PPS line discipline may require enabling
modem status interrupts; conversely switching from N_PPS may
require disabling modem status interrupts.

Affected drivers:
8250
amba-pl010
atmel

Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_core.c | 21 ++++++++++++++++++++-
 drivers/tty/serial/amba-pl010.c     | 18 +++++++++++++++++-
 drivers/tty/serial/atmel_serial.c   |  5 +++++
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 8eb0654..095319b 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1397,6 +1397,19 @@ static void serial8250_stop_rx(struct uart_port *port)
 	serial8250_rpm_put(up);
 }
 
+static void serial8250_disable_ms(struct uart_port *port)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+
+	/* no MSR capabilities */
+	if (up->bugs & UART_BUG_NOMSR)
+		return;
+
+	up->ier &= ~UART_IER_MSI;
+	serial_port_out(port, UART_IER, up->ier);
+}
+
 static void serial8250_enable_ms(struct uart_port *port)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
@@ -2610,8 +2623,14 @@ serial8250_set_ldisc(struct uart_port *port, struct ktermios *termios)
 		spin_lock_irq(&port->lock);
 		serial8250_enable_ms(port);
 		spin_unlock_irq(&port->lock);
-	} else
+	} else {
 		port->flags &= ~UPF_HARDPPS_CD;
+		if (!UART_ENABLE_MS(port, termios->c_cflag)) {
+			spin_lock_irq(&port->lock);
+			serial8250_disable_ms(port);
+			spin_unlock_irq(&port->lock);
+		}
+	}
 }
 
 
diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 04b83bf..6f8464e 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -103,6 +103,16 @@ static void pl010_stop_rx(struct uart_port *port)
 	writel(cr, uap->port.membase + UART010_CR);
 }
 
+static void pl010_disable_ms(struct uart_port *port)
+{
+	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned int cr;
+
+	cr = readb(uap->port.membase + UART010_CR);
+	cr &= ~UART010_CR_MSIE;
+	writel(cr, uap->port.membase + UART010_CR);
+}
+
 static void pl010_enable_ms(struct uart_port *port)
 {
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
@@ -475,8 +485,14 @@ static void pl010_set_ldisc(struct uart_port *port, struct ktermios *termios)
 		spin_lock_irq(&port->lock);
 		pl010_enable_ms(port);
 		spin_unlock_irq(&port->lock);
-	} else
+	} else {
 		port->flags &= ~UPF_HARDPPS_CD;
+		if (!UART_ENABLE_MS(port, termios->c_cflag)) {
+			spin_lock_irq(&port->lock);
+			pl010_disable_ms(port);
+			spin_unlock_irq(&port->lock);
+		}
+	}
 }
 
 static const char *pl010_type(struct uart_port *port)
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index b68dfa5..21380b6 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2051,6 +2051,11 @@ static void atmel_set_ldisc(struct uart_port *port, struct ktermios *termios)
 		spin_unlock_irq(&port->lock);
 	} else {
 		port->flags &= ~UPF_HARDPPS_CD;
+		if (!UART_ENABLE_MS(port, termios->c_cflag)) {
+			spin_lock_irq(&port->lock);
+			atmel_disable_ms(port);
+			spin_unlock_irq(&port->lock);
+		}
 	}
 }
 
-- 
2.1.3

