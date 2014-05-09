Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbaEIPa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:30:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58329 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379AbaEIPav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:30:51 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: RE: [PATCH v2] serial: uart: add hw flow control support
 configuration
Thread-Topic: [PATCH v2] serial: uart: add hw flow control support
 configuration
Thread-Index: AQHPZXA8z3C7j2dF7EGLBbHJueLeaJs4a++Q
Date: Fri, 9 May 2014 15:30:02 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B704735082@DFLE11.ent.ti.com>
References: <1398971093-17164-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1398971093-17164-1-git-send-email-m-karicheri2@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Karicheri, Muralidharan
>Sent: Thursday, May 01, 2014 3:05 PM
>To: devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org;
>linux-serial@vger.kernel.org
>Cc: Karicheri, Muralidharan; Rob Herring; Pawel Moll; Mark Rutland; Ian Campbell; Kumar
>Gala; Randy Dunlap; Greg Kroah-Hartman; Jiri Slaby; Shilimkar, Santosh
>Subject: [PATCH v2] serial: uart: add hw flow control support configuration
>
>8250 uart driver currently supports only software assisted hw flow control. The software
>assisted hw flow control maintains a hw_stopped flag in the tty structure to stop and start
>transmission and use modem status interrupt for the event to drive the handshake signals.
>This is not needed if hw has flow control capabilities. This patch adds a DT attribute for
>enabling hw flow control for a uart port. Also skip stop and start if this flag is present in flag
>field of the port structure.
>
>Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>
>CC: Rob Herring <robh+dt@kernel.org>
>CC: Pawel Moll <pawel.moll@arm.com>
>CC: Mark Rutland <mark.rutland@arm.com>
>CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
>CC: Kumar Gala <galak@codeaurora.org>
>CC: Randy Dunlap <rdunlap@infradead.org>
>CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>CC: Jiri Slaby <jslaby@suse.cz>
>CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>---
> .../devicetree/bindings/serial/of-serial.txt       |    1 +
> drivers/tty/serial/8250/8250_core.c                |    6 ++++--
> drivers/tty/serial/of_serial.c                     |    4 ++++
> drivers/tty/serial/serial_core.c                   |   12 +++++++++---
> 4 files changed, 18 insertions(+), 5 deletions(-)
>
>diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt
>b/Documentation/devicetree/bindings/serial/of-serial.txt
>index 1928a3e..7705477 100644
>--- a/Documentation/devicetree/bindings/serial/of-serial.txt
>+++ b/Documentation/devicetree/bindings/serial/of-serial.txt
>@@ -37,6 +37,7 @@ Optional properties:
> - auto-flow-control: one way to enable automatic flow control support. The
>   driver is allowed to detect support for the capability even without this
>   property.
>+- has-hw-flow-control: the hardware has flow control capability.
>
> Example:
>
>diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
>index 0e1bf88..b69aff2 100644
>--- a/drivers/tty/serial/8250/8250_core.c
>+++ b/drivers/tty/serial/8250/8250_core.c
>@@ -2338,9 +2338,11 @@ serial8250_do_set_termios(struct uart_port *port, struct
>ktermios *termios,
> 	 * the trigger, or the MCR RTS bit is cleared.  In the case where
> 	 * the remote UART is not using CTS auto flow control, we must
> 	 * have sufficient FIFO entries for the latency of the remote
>-	 * UART to respond.  IOW, at least 32 bytes of FIFO.
>+	 * UART to respond.  IOW, at least 32 bytes of FIFO. Also enable
>+	 * AFE if hw flow control is supported
> 	 */
>-	if (up->capabilities & UART_CAP_AFE && port->fifosize >= 32) {
>+	if ((up->capabilities & UART_CAP_AFE && (port->fifosize >= 32)) ||
>+	    (port->flags & UPF_HARD_FLOW)) {
> 		up->mcr &= ~UART_MCR_AFE;
> 		if (termios->c_cflag & CRTSCTS)
> 			up->mcr |= UART_MCR_AFE;
>diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c index
>9924660..77ec6a1 100644
>--- a/drivers/tty/serial/of_serial.c
>+++ b/drivers/tty/serial/of_serial.c
>@@ -182,6 +182,10 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
> 					  "auto-flow-control"))
> 			port8250.capabilities |= UART_CAP_AFE;
>
>+		if (of_property_read_bool(ofdev->dev.of_node,
>+					  "has-hw-flow-control"))
>+			port8250.port.flags |= UPF_HARD_FLOW;
>+
> 		ret = serial8250_register_8250_port(&port8250);
> 		break;
> 	}
>diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
>index b68550d..851707a 100644
>--- a/drivers/tty/serial/serial_core.c
>+++ b/drivers/tty/serial/serial_core.c
>@@ -174,8 +174,12 @@ static int uart_port_startup(struct tty_struct *tty, struct
>uart_state *state,
> 			if (tty->termios.c_cflag & CBAUD)
> 				uart_set_mctrl(uport, TIOCM_RTS | TIOCM_DTR);
> 		}
>-
>-		if (tty_port_cts_enabled(port)) {
>+		/*
>+		 * if hw support flow control without software intervention,
>+		 * then skip the below check
>+		 */
>+		if (tty_port_cts_enabled(port) &&
>+		    !(uport->flags & UPF_HARD_FLOW)) {
> 			spin_lock_irq(&uport->lock);
> 			if (!(uport->ops->get_mctrl(uport) & TIOCM_CTS))
> 				tty->hw_stopped = 1;
>@@ -2772,7 +2776,9 @@ void uart_handle_cts_change(struct uart_port *uport, unsigned
>int status)
>
> 	uport->icount.cts++;
>
>-	if (tty_port_cts_enabled(port)) {
>+	/* skip below code if the hw flow control is supported */
>+	if (tty_port_cts_enabled(port) &&
>+	    !(uport->flags & UPF_HARD_FLOW)) {
> 		if (tty->hw_stopped) {
> 			if (status) {
> 				tty->hw_stopped = 0;
>--
>1.7.9.5

Any idea who is going to pick this patch for merge?

Murali
