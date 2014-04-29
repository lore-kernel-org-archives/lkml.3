Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbaD2RWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:22:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35726 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306AbaD2RWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:22:48 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v1] serial: uart: add hw flow control support configuration
Date: Tue, 29 Apr 2014 13:22:02 -0400
Message-ID: <1398792122-18592-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8250 uart driver currently supports only software assisted hw flow
control. The software assisted hw flow control maintains a hw_stopped
flag in the tty structure to stop and start transmission and use modem
status interrupt for the event to drive the handshake signals. This is
not needed if hw has flow control capabilities. This patch adds a
DT attribute for enabling hw flow control for a uart port. Also skip
stop and start if this flag is present in flag field of the port
structure.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

CC: Rob Herring <robh+dt@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com> 
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Randy Dunlap <rdunlap@infradead.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 - Fixed brackets around port->flags & UPF_HARD_FLOW as per comments 
 .../devicetree/bindings/serial/of-serial.txt       |    2 ++
 drivers/tty/serial/8250/8250_core.c                |    6 ++++--
 drivers/tty/serial/of_serial.c                     |    4 ++++
 drivers/tty/serial/serial_core.c                   |   12 +++++++++---
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/of-serial.txt
index 1928a3e..123de01 100644
--- a/Documentation/devicetree/bindings/serial/of-serial.txt
+++ b/Documentation/devicetree/bindings/serial/of-serial.txt
@@ -37,6 +37,8 @@ Optional properties:
 - auto-flow-control: one way to enable automatic flow control support. The
   driver is allowed to detect support for the capability even without this
   property.
+- hw-flow-control: this enables pure hw flow control and no software
+  intervention needed.
 
 Example:
 
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 81f909c..f145103 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2338,9 +2338,11 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * the trigger, or the MCR RTS bit is cleared.  In the case where
 	 * the remote UART is not using CTS auto flow control, we must
 	 * have sufficient FIFO entries for the latency of the remote
-	 * UART to respond.  IOW, at least 32 bytes of FIFO.
+	 * UART to respond.  IOW, at least 32 bytes of FIFO. Also enable
+	 * AFE if hw flow control is supported
 	 */
-	if (up->capabilities & UART_CAP_AFE && port->fifosize >= 32) {
+	if ((up->capabilities & UART_CAP_AFE && (port->fifosize >= 32)) ||
+	    (port->flags & UPF_HARD_FLOW)) {
 		up->mcr &= ~UART_MCR_AFE;
 		if (termios->c_cflag & CRTSCTS)
 			up->mcr |= UART_MCR_AFE;
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 9924660..1a5f528 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -182,6 +182,10 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
 					  "auto-flow-control"))
 			port8250.capabilities |= UART_CAP_AFE;
 
+		if (of_property_read_bool(ofdev->dev.of_node,
+					  "hw-flow-control"))
+			port8250.port.flags |= UPF_HARD_FLOW;
+
 		ret = serial8250_register_8250_port(&port8250);
 		break;
 	}
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2cf5649..16e3615 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -170,8 +170,12 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
 			if (tty->termios.c_cflag & CBAUD)
 				uart_set_mctrl(uport, TIOCM_RTS | TIOCM_DTR);
 		}
-
-		if (tty_port_cts_enabled(port)) {
+		/*
+		 * if hw support flow control without software intervention,
+		 * then skip the below check
+		 */
+		if (tty_port_cts_enabled(port) &&
+		    !(uport->flags & UPF_HARD_FLOW)) {
 			spin_lock_irq(&uport->lock);
 			if (!(uport->ops->get_mctrl(uport) & TIOCM_CTS))
 				tty->hw_stopped = 1;
@@ -2768,7 +2772,9 @@ void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
 
 	uport->icount.cts++;
 
-	if (tty_port_cts_enabled(port)) {
+	/* skip below code if the hw flow control is supported */
+	if (tty_port_cts_enabled(port) &&
+	    !(uport->flags & UPF_HARD_FLOW)) {
 		if (tty->hw_stopped) {
 			if (status) {
 				tty->hw_stopped = 0;
-- 
1.7.9.5

