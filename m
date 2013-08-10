Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888Ab3HJN6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 09:58:12 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:52441
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933743Ab3HJN6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 09:58:11 -0400
Message-ID: <520646F0.9010801@newflow.co.uk>
Date: Sat, 10 Aug 2013 14:58:08 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [RFC] OMAP: allow GPIO pin to enable/disable external UART driver
 chip.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a UART transmitter is connected to (eg) a RS485 driver, it is
necessary to turn the driver on/off as quickly as possible.  This is
best achieved in the serial driver itself (rather than in userspace
where the latency can be quite large).

This patch allows the GPIO pin to be defined (via DT) that controls
the enabling of the driver at the start of a message, and disables
the driver when the message has been completed.

Still to do:-
Allow userspace to turn this feature on/off
Do the same for the receiver (useful for 2 wire RS485)

Signed-off-by: Mark Jackson <mpfj@newflow.co.uk>
---
 drivers/tty/serial/omap-serial.c |   57 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index b6d1728..1d3d117 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -40,9 +40,12 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_data/serial-omap.h>
 
+#include <dt-bindings/gpio/gpio.h>
+
 #define OMAP_MAX_HSUART_PORTS	6
 
 #define UART_BUILD_REVISION(x, y)	(((x) << 8) | (y))
@@ -156,6 +159,10 @@ struct uart_omap_port {
 	int			DTR_inverted;
 	int			DTR_active;
 
+	int			txen_gpio;
+	int			txen_inverted;
+	int			txen_active;
+
 	struct pm_qos_request	pm_qos_request;
 	u32			latency;
 	u32			calc_latency;
@@ -272,8 +279,25 @@ static void serial_omap_enable_ms(struct uart_port *port)
 static void serial_omap_stop_tx(struct uart_port *port)
 {
 	struct uart_omap_port *up = to_uart_omap_port(port);
+	struct circ_buf *xmit = &up->port.state->xmit;
 
 	pm_runtime_get_sync(up->dev);
+
+	// if txen currently active
+	if (up->txen_active) {
+		// do nothing if current tx not yet completed
+		int res = serial_in(up, UART_LSR) & UART_LSR_TEMT;
+		if (!res)
+			return;
+
+		// if there's no more data to send, turn off txen
+		if (uart_circ_empty(xmit)) {
+			gpio_set_value(up->txen_gpio,
+					   up->txen_active == up->txen_inverted);
+			up->txen_active = 0;
+		}
+	}
+
 	if (up->ier & UART_IER_THRI) {
 		up->ier &= ~UART_IER_THRI;
 		serial_out(up, UART_IER, up->ier);
@@ -300,6 +324,16 @@ static void transmit_chars(struct uart_omap_port *up, unsigned int lsr)
 	struct circ_buf *xmit = &up->port.state->xmit;
 	int count;
 
+	// if txen in use
+	if (gpio_is_valid(up->txen_gpio)) {
+		// turn on txen ?
+		if (!uart_circ_empty(xmit) && (!up->txen_active)) {
+			gpio_set_value(up->txen_gpio,
+				       up->txen_active == up->txen_inverted);
+			up->txen_active = 1;
+		}
+	}
+
 	if (up->port.x_char) {
 		serial_out(up, UART_TX, up->port.x_char);
 		up->port.icount.tx++;
@@ -1468,6 +1502,28 @@ static int serial_omap_probe(struct platform_device *pdev)
 		goto err_port_line;
 	}
 
+	// init tx enable signal
+	up->txen_gpio = -EINVAL;
+	up->txen_inverted = 0;
+	up->txen_active = 0;
+	if (pdev->dev.of_node)
+	{
+		enum of_gpio_flags flags;
+		up->txen_gpio = of_get_named_gpio_flags(pdev->dev.of_node,
+							"txen-gpio", 0, &flags);
+		up->txen_inverted = (flags == GPIO_ACTIVE_LOW);
+		if (gpio_is_valid(up->txen_gpio)) {
+			ret = gpio_request(up->txen_gpio, "omap-serial");
+			if (ret < 0)
+				goto err_txen;
+			ret = gpio_direction_output(up->txen_gpio,
+						    up->txen_inverted);
+			if (ret < 0)
+				goto err_txen;
+		} else
+			up->txen_gpio = -EINVAL;
+	}
+
 	up->pins = devm_pinctrl_get_select_default(&pdev->dev);
 	if (IS_ERR(up->pins)) {
 		dev_warn(&pdev->dev, "did not get pins for uart%i error: %li\n",
@@ -1529,6 +1585,7 @@ err_add_port:
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 err_ioremap:
+err_txen:
 err_port_line:
 	dev_err(&pdev->dev, "[UART%d]: failure [%s]: %d\n",
 				pdev->id, __func__, ret);
-- 
1.7.9.5

