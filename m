Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbaIBVkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:40:08 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:58056 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754164AbaIBVkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:40:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 01/26] Revert "serial: uart: add hw flow control support configuration"
Date: Tue,  2 Sep 2014 17:39:10 -0400
Message-Id: <1409693975-1028-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 06aa82e498c144c7784a6f3d3b55458b272d6146.
This commit purports to enable auto CTS flow control for the 8250
UART driver. However, the 8250 UART driver already supports auto
CTS flow control via UART_CAP_AFE and UART_CAP_EFR. Indeed, this
patch introduces another DT attribute for which an existing firmware
flag already exists ("auto-flow-control"). Furthermore, the use of
UPF_HARD_FLOW requires the UART driver to define .throttle and
.unthrottle methods, neither of which are defined for the 8250 UART
driver (which will result in a NULL ptr dereference). Finally, this patch
supposes to fix existing bugs in the serial core for auto CTS-enabled
hardware, but does not include the class of hardware for which these
bugs exist.

CC: Murali Karicheri <m-karicheri2@ti.com>
CC: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 Documentation/devicetree/bindings/serial/of-serial.txt |  1 -
 drivers/tty/serial/8250/8250_core.c                    |  6 ++----
 drivers/tty/serial/of_serial.c                         |  4 ----
 drivers/tty/serial/serial_core.c                       | 12 +++---------
 4 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/of-serial.txt
index 7705477..1928a3e 100644
--- a/Documentation/devicetree/bindings/serial/of-serial.txt
+++ b/Documentation/devicetree/bindings/serial/of-serial.txt
@@ -37,7 +37,6 @@ Optional properties:
 - auto-flow-control: one way to enable automatic flow control support. The
   driver is allowed to detect support for the capability even without this
   property.
-- has-hw-flow-control: the hardware has flow control capability.
 
 Example:
 
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 7a91c6d..109da60 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2333,11 +2333,9 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * the trigger, or the MCR RTS bit is cleared.  In the case where
 	 * the remote UART is not using CTS auto flow control, we must
 	 * have sufficient FIFO entries for the latency of the remote
-	 * UART to respond.  IOW, at least 32 bytes of FIFO. Also enable
-	 * AFE if hw flow control is supported
+	 * UART to respond.  IOW, at least 32 bytes of FIFO.
 	 */
-	if ((up->capabilities & UART_CAP_AFE && (port->fifosize >= 32)) ||
-	    (port->flags & UPF_HARD_FLOW)) {
+	if (up->capabilities & UART_CAP_AFE && port->fifosize >= 32) {
 		up->mcr &= ~UART_MCR_AFE;
 		if (termios->c_cflag & CRTSCTS)
 			up->mcr |= UART_MCR_AFE;
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 68d4455..27981e2 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -183,10 +183,6 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
 					  "auto-flow-control"))
 			port8250.capabilities |= UART_CAP_AFE;
 
-		if (of_property_read_bool(ofdev->dev.of_node,
-					  "has-hw-flow-control"))
-			port8250.port.flags |= UPF_HARD_FLOW;
-
 		ret = serial8250_register_8250_port(&port8250);
 		break;
 	}
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c2f90ec..261e49e 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -174,12 +174,8 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
 			if (tty->termios.c_cflag & CBAUD)
 				uart_set_mctrl(uport, TIOCM_RTS | TIOCM_DTR);
 		}
-		/*
-		 * if hw support flow control without software intervention,
-		 * then skip the below check
-		 */
-		if (tty_port_cts_enabled(port) &&
-		    !(uport->flags & UPF_HARD_FLOW)) {
+
+		if (tty_port_cts_enabled(port)) {
 			spin_lock_irq(&uport->lock);
 			if (!(uport->ops->get_mctrl(uport) & TIOCM_CTS))
 				tty->hw_stopped = 1;
@@ -2777,9 +2773,7 @@ void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
 
 	uport->icount.cts++;
 
-	/* skip below code if the hw flow control is supported */
-	if (tty_port_cts_enabled(port) &&
-	    !(uport->flags & UPF_HARD_FLOW)) {
+	if (tty_port_cts_enabled(port)) {
 		if (tty->hw_stopped) {
 			if (status) {
 				tty->hw_stopped = 0;
-- 
2.1.0

