Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaIOGyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 02:54:39 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.169]:58343 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbaIOGyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 02:54:37 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 02:54:37 EDT
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-6.tower-38.messagelabs.com!1410763682!22641754!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 15 Sep 2014 08:48:02 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH v2] tty: serial: men_z135_uart: Fix driver for changes in hardware
Date: Mon, 15 Sep 2014 08:47:56 +0200
Message-ID: <1410763676-30173-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16z135 IP Core has changed so the driver needs to be updated to respect
these changes. The following changes have been made:

* Don't invert the 16z135 modem status register when reading.
* Add module parameter to configure the (baud rate dependent) RX timeout.
  Character timeout in seconds = (timeout_reg * baud_reg * 4)/freq_reg.
* Enable the handling of UART core's automatic flow control feature.
  When AFE is active disable generation of modem status IRQs.
* Rework the handling of IRQs to be conform with newer FPGA versions and
  take precautions not to miss an interrupt because of the destructive read
  of the IIR register.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---

Changes to v1:

Incorporated comments of Jiri Slaby:

* Timeout value is documented in module parameter description
* rx_timeout variable is uint
* Changed IRQ handled variable to bool
* Changed if statement for RDA or CTI IRQ

 drivers/tty/serial/men_z135_uart.c | 88 +++++++++++++++++++++++---------------
 1 file changed, 54 insertions(+), 34 deletions(-)

diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
index 30e9e60..d8be581 100644
--- a/drivers/tty/serial/men_z135_uart.c
+++ b/drivers/tty/serial/men_z135_uart.c
@@ -34,12 +34,11 @@
 #define MEN_Z135_CONF_REG		0x808
 #define MEN_Z135_UART_FREQ		0x80c
 #define MEN_Z135_BAUD_REG		0x810
-#define MENZ135_TIMEOUT			0x814
+#define MEN_Z135_TIMEOUT		0x814

 #define MEN_Z135_MEM_SIZE		0x818

-#define IS_IRQ(x) ((x) & 1)
-#define IRQ_ID(x) (((x) >> 1) & 7)
+#define IRQ_ID(x) ((x) & 0x1f)

 #define MEN_Z135_IER_RXCIEN BIT(0)		/* RX Space IRQ */
 #define MEN_Z135_IER_TXCIEN BIT(1)		/* TX Space IRQ */
@@ -94,11 +93,11 @@
 #define MEN_Z135_LSR_TEXP BIT(6)
 #define MEN_Z135_LSR_RXFIFOERR BIT(7)

-#define MEN_Z135_IRQ_ID_MST 0
-#define MEN_Z135_IRQ_ID_TSA 1
-#define MEN_Z135_IRQ_ID_RDA 2
-#define MEN_Z135_IRQ_ID_RLS 3
-#define MEN_Z135_IRQ_ID_CTI 6
+#define MEN_Z135_IRQ_ID_RLS BIT(0)
+#define MEN_Z135_IRQ_ID_RDA BIT(1)
+#define MEN_Z135_IRQ_ID_CTI BIT(2)
+#define MEN_Z135_IRQ_ID_TSA BIT(3)
+#define MEN_Z135_IRQ_ID_MST BIT(4)

 #define LCR(x) (((x) >> MEN_Z135_LCR_SHIFT) & 0xff)

@@ -118,6 +117,11 @@ static int align;
 module_param(align, int, S_IRUGO);
 MODULE_PARM_DESC(align, "Keep hardware FIFO write pointer aligned, default 0");

+static uint rx_timeout;
+module_param(rx_timeout, uint, S_IRUGO);
+MODULE_PARM_DESC(rx_timeout, "RX timeout. "
+		"Timeout in seconds = (timeout_reg * baud_reg * 4) / freq_reg");
+
 struct men_z135_port {
 	struct uart_port port;
 	struct mcb_device *mdev;
@@ -373,43 +377,47 @@ out:
  * @irq: The IRQ number
  * @data: Pointer to UART port
  *
- * Check IIR register to see which tasklet to start.
+ * Check IIR register to find the cause of the interrupt and handle it.
+ * It is possible that multiple interrupts reason bits are set and reading
+ * the IIR is a destructive read, so we always need to check for all possible
+ * interrupts and handle them.
  */
 static irqreturn_t men_z135_intr(int irq, void *data)
 {
 	struct men_z135_port *uart = (struct men_z135_port *)data;
 	struct uart_port *port = &uart->port;
+	bool handled = false;
 	int irq_id;

 	uart->stat_reg = ioread32(port->membase + MEN_Z135_STAT_REG);
-	/* IRQ pending is low active */
-	if (IS_IRQ(uart->stat_reg))
-		return IRQ_NONE;
-
 	irq_id = IRQ_ID(uart->stat_reg);
-	switch (irq_id) {
-	case MEN_Z135_IRQ_ID_MST:
-		men_z135_handle_modem_status(uart);
-		break;
-	case MEN_Z135_IRQ_ID_TSA:
-		men_z135_handle_tx(uart);
-		break;
-	case MEN_Z135_IRQ_ID_CTI:
-		dev_dbg(&uart->mdev->dev, "Character Timeout Indication\n");
-		/* Fallthrough */
-	case MEN_Z135_IRQ_ID_RDA:
-		/* Reading data clears RX IRQ */
-		men_z135_handle_rx(uart);
-		break;
-	case MEN_Z135_IRQ_ID_RLS:
+
+	if (!irq_id)
+		goto out;
+
+	if (irq_id & MEN_Z135_IRQ_ID_RLS) {
 		men_z135_handle_lsr(uart);
-		break;
-	default:
-		dev_warn(&uart->mdev->dev, "Unknown IRQ id %d\n", irq_id);
-		return IRQ_NONE;
+		handled = true;
 	}

-	return IRQ_HANDLED;
+	if (irq_id & (MEN_Z135_IRQ_ID_RDA | MEN_Z135_IRQ_ID_CTI)) {
+		if (irq_id & MEN_Z135_IRQ_ID_CTI)
+			dev_dbg(&uart->mdev->dev, "Character Timeout Indication\n");
+		men_z135_handle_rx(uart);
+		handled = true;
+	}
+
+	if (irq_id & MEN_Z135_IRQ_ID_TSA) {
+		men_z135_handle_tx(uart);
+		handled = true;
+	}
+
+	if (irq_id & MEN_Z135_IRQ_ID_MST) {
+		men_z135_handle_modem_status(uart);
+		handled = true;
+	}
+out:
+	return IRQ_RETVAL(handled);
 }

 /**
@@ -495,7 +503,7 @@ static unsigned int men_z135_get_mctrl(struct uart_port *port)

 	stat_reg = ioread32(port->membase + MEN_Z135_STAT_REG);

-	msr = ~((stat_reg >> 8) & 0xff);
+	msr = (stat_reg >> 8) & 0xff;

 	if (msr & MEN_Z135_MSR_CTS)
 		mctrl |= TIOCM_CTS;
@@ -584,6 +592,9 @@ static int men_z135_startup(struct uart_port *port)

 	iowrite32(conf_reg, port->membase + MEN_Z135_CONF_REG);

+	if (rx_timeout)
+		iowrite32(rx_timeout, port->membase + MEN_Z135_TIMEOUT);
+
 	return 0;
 }

@@ -603,6 +614,7 @@ static void men_z135_set_termios(struct uart_port *port,
 				struct ktermios *termios,
 				struct ktermios *old)
 {
+	struct men_z135_port *uart = to_men_z135(port);
 	unsigned int baud;
 	u32 conf_reg;
 	u32 bd_reg;
@@ -643,6 +655,14 @@ static void men_z135_set_termios(struct uart_port *port,
 	} else
 		lcr |= MEN_Z135_PAR_DIS << MEN_Z135_PEN_SHIFT;

+	if (termios->c_cflag & CRTSCTS) {
+		conf_reg |= MEN_Z135_MCR_RCFC;
+		men_z135_reg_clr(uart, MEN_Z135_CONF_REG, MEN_Z135_IER_MSIEN);
+	} else {
+		conf_reg &= ~MEN_Z135_MCR_RCFC;
+		men_z135_reg_set(uart, MEN_Z135_CONF_REG, MEN_Z135_IER_MSIEN);
+	}
+
 	termios->c_cflag &= ~CMSPAR; /* Mark/Space parity is not supported */

 	conf_reg |= lcr << MEN_Z135_LCR_SHIFT;
--
1.9.1
