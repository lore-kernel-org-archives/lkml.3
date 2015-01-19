Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbbASGo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 01:44:57 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.109]:26872 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbbASGo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 01:44:56 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-4.tower-193.messagelabs.com!1421649891!19777185!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 19 Jan 2015 07:44:52 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Peter Hurley <peter@hurleysoftware.com>, Jiri Slaby <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH v5] tty: serial: men_z135_uart: Fix driver for changes in hardware
Date: Mon, 19 Jan 2015 07:44:41 +0100
Message-ID: <1421649881-2275-1-git-send-email-johannes.thumshirn@men.de>
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
* Correct men_z135_handle_modem_status(), MSR is stat_reg[15:8] not
  stat_reg[7:0]
* Correct calling of uart_handle_{dcd,cts}_change()
* Reset CLOCAL when CRTSCTS is set

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
Changes to v1:
Incorporated comments of Jiri Slaby:

* Timeout value is documented in module parameter description
* rx_timeout variable is uint
* Changed IRQ handled variable to bool
* Changed if statement for RDA or CTI IRQ

Changes to v2:
* Correct men_z135_handle_modem_status(), MSR is stat_reg[15:8] not stat_reg[7:0]

Changes to v3:
* Correct calling of uart_handle_{dcd,cts}_change()
* Correct handling of hardware's automode

Changes to v4:
* Reset CLOCAL when CRTSCTS is set (suggested by Peter Hurley)


 drivers/tty/serial/men_z135_uart.c | 155 ++++++++++++++++++++++++++-----------
 1 file changed, 109 insertions(+), 46 deletions(-)

diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
index 517cd07..35c5550 100644
--- a/drivers/tty/serial/men_z135_uart.c
+++ b/drivers/tty/serial/men_z135_uart.c
@@ -23,7 +23,6 @@
 #define MEN_Z135_MAX_PORTS		12
 #define MEN_Z135_BASECLK		29491200
 #define MEN_Z135_FIFO_SIZE		1024
-#define MEN_Z135_NUM_MSI_VECTORS	2
 #define MEN_Z135_FIFO_WATERMARK		1020
 
 #define MEN_Z135_STAT_REG		0x0
@@ -34,12 +33,11 @@
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
@@ -94,11 +92,11 @@
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
 
@@ -118,12 +116,18 @@ static int align;
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
 	unsigned char *rxbuf;
 	u32 stat_reg;
 	spinlock_t lock;
+	bool automode;
 };
 #define to_men_z135(port) container_of((port), struct men_z135_port, port)
 
@@ -180,12 +184,16 @@ static inline void men_z135_reg_clr(struct men_z135_port *uart,
  */
 static void men_z135_handle_modem_status(struct men_z135_port *uart)
 {
-	if (uart->stat_reg & MEN_Z135_MSR_DDCD)
+	u8 msr;
+
+	msr = (uart->stat_reg >> 8) & 0xff;
+
+	if (msr & MEN_Z135_MSR_DDCD)
 		uart_handle_dcd_change(&uart->port,
-				uart->stat_reg & ~MEN_Z135_MSR_DCD);
-	if (uart->stat_reg & MEN_Z135_MSR_DCTS)
+				msr & MEN_Z135_MSR_DCD);
+	if (msr & MEN_Z135_MSR_DCTS)
 		uart_handle_cts_change(&uart->port,
-				uart->stat_reg & ~MEN_Z135_MSR_CTS);
+				msr & MEN_Z135_MSR_CTS);
 }
 
 static void men_z135_handle_lsr(struct men_z135_port *uart)
@@ -322,7 +330,8 @@ static void men_z135_handle_tx(struct men_z135_port *uart)
 
 	txfree = MEN_Z135_FIFO_WATERMARK - txc;
 	if (txfree <= 0) {
-		pr_err("Not enough room in TX FIFO have %d, need %d\n",
+		dev_err(&uart->mdev->dev,
+			"Not enough room in TX FIFO have %d, need %d\n",
 			txfree, qlen);
 		goto irq_en;
 	}
@@ -373,43 +382,54 @@ out:
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
+	unsigned long flags;
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
+	spin_lock_irqsave(&port->lock, flags);
+	/* It's save to write to IIR[7:6] RXC[9:8] */
+	iowrite8(irq_id, port->membase + MEN_Z135_STAT_REG);
+
+	if (irq_id & MEN_Z135_IRQ_ID_RLS) {
 		men_z135_handle_lsr(uart);
-		break;
-	default:
-		dev_warn(&uart->mdev->dev, "Unknown IRQ id %d\n", irq_id);
-		return IRQ_NONE;
+		handled = true;
+	}
+
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
 	}
 
-	return IRQ_HANDLED;
+	if (irq_id & MEN_Z135_IRQ_ID_MST) {
+		men_z135_handle_modem_status(uart);
+		handled = true;
+	}
+
+	spin_unlock_irqrestore(&port->lock, flags);
+out:
+	return IRQ_RETVAL(handled);
 }
 
 /**
@@ -464,21 +484,37 @@ static unsigned int men_z135_tx_empty(struct uart_port *port)
  */
 static void men_z135_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct men_z135_port *uart = to_men_z135(port);
-	u32 conf_reg = 0;
+	u32 old;
+	u32 conf_reg;
 
+	conf_reg = old = ioread32(port->membase + MEN_Z135_CONF_REG);
 	if (mctrl & TIOCM_RTS)
 		conf_reg |= MEN_Z135_MCR_RTS;
+	else
+		conf_reg &= ~MEN_Z135_MCR_RTS;
+
 	if (mctrl & TIOCM_DTR)
 		conf_reg |= MEN_Z135_MCR_DTR;
+	else
+		conf_reg &= ~MEN_Z135_MCR_DTR;
+
 	if (mctrl & TIOCM_OUT1)
 		conf_reg |= MEN_Z135_MCR_OUT1;
+	else
+		conf_reg &= ~MEN_Z135_MCR_OUT1;
+
 	if (mctrl & TIOCM_OUT2)
 		conf_reg |= MEN_Z135_MCR_OUT2;
+	else
+		conf_reg &= ~MEN_Z135_MCR_OUT2;
+
 	if (mctrl & TIOCM_LOOP)
 		conf_reg |= MEN_Z135_MCR_LOOP;
+	else
+		conf_reg &= ~MEN_Z135_MCR_LOOP;
 
-	men_z135_reg_set(uart, MEN_Z135_CONF_REG, conf_reg);
+	if (conf_reg != old)
+		iowrite32(conf_reg, port->membase + MEN_Z135_CONF_REG);
 }
 
 /**
@@ -490,12 +526,9 @@ static void men_z135_set_mctrl(struct uart_port *port, unsigned int mctrl)
 static unsigned int men_z135_get_mctrl(struct uart_port *port)
 {
 	unsigned int mctrl = 0;
-	u32 stat_reg;
 	u8 msr;
 
-	stat_reg = ioread32(port->membase + MEN_Z135_STAT_REG);
-
-	msr = ~((stat_reg >> 8) & 0xff);
+	msr = ioread8(port->membase + MEN_Z135_STAT_REG + 1);
 
 	if (msr & MEN_Z135_MSR_CTS)
 		mctrl |= TIOCM_CTS;
@@ -524,6 +557,19 @@ static void men_z135_stop_tx(struct uart_port *port)
 	men_z135_reg_clr(uart, MEN_Z135_CONF_REG, MEN_Z135_IER_TXCIEN);
 }
 
+/*
+ * men_z135_disable_ms() - Disable Modem Status
+ * port: The UART port
+ *
+ * Enable Modem Status IRQ.
+ */
+static void men_z135_disable_ms(struct uart_port *port)
+{
+	struct men_z135_port *uart = to_men_z135(port);
+
+	men_z135_reg_clr(uart, MEN_Z135_CONF_REG, MEN_Z135_IER_MSIEN);
+}
+
 /**
  * men_z135_start_tx() - Start transmitting characters
  * @port: The UART port
@@ -535,6 +581,9 @@ static void men_z135_start_tx(struct uart_port *port)
 {
 	struct men_z135_port *uart = to_men_z135(port);
 
+	if (uart->automode)
+		men_z135_disable_ms(port);
+
 	men_z135_handle_tx(uart);
 }
 
@@ -584,6 +633,9 @@ static int men_z135_startup(struct uart_port *port)
 
 	iowrite32(conf_reg, port->membase + MEN_Z135_CONF_REG);
 
+	if (rx_timeout)
+		iowrite32(rx_timeout, port->membase + MEN_Z135_TIMEOUT);
+
 	return 0;
 }
 
@@ -603,6 +655,7 @@ static void men_z135_set_termios(struct uart_port *port,
 				struct ktermios *termios,
 				struct ktermios *old)
 {
+	struct men_z135_port *uart = to_men_z135(port);
 	unsigned int baud;
 	u32 conf_reg;
 	u32 bd_reg;
@@ -643,6 +696,16 @@ static void men_z135_set_termios(struct uart_port *port,
 	} else
 		lcr |= MEN_Z135_PAR_DIS << MEN_Z135_PEN_SHIFT;
 
+	conf_reg |= MEN_Z135_IER_MSIEN;
+	if (termios->c_cflag & CRTSCTS) {
+		conf_reg |= MEN_Z135_MCR_RCFC;
+		uart->automode = true;
+		termios->c_cflag &= ~CLOCAL;
+	} else {
+		conf_reg &= ~MEN_Z135_MCR_RCFC;
+		uart->automode = false;
+	}
+
 	termios->c_cflag &= ~CMSPAR; /* Mark/Space parity is not supported */
 
 	conf_reg |= lcr << MEN_Z135_LCR_SHIFT;
-- 
1.9.1

