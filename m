Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaCGTOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:14:37 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:38471 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaCGTOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:14:33 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC v2 07/11] tty: xuartps: Replace function and symbol prefix
Date: Fri,  7 Mar 2014 11:13:30 -0800
Message-Id: <1394219614-3197-8-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 'CDNS_UART' or 'cdns_uart' instead of 'XUARTPS' and 'xuartps' as
function and symbol prefix. This is essentially doing:
 - s/XUARTPS/CDNS_UART/g
 - s/xuartps/cdns_uart/g
The only exception is PORT_XUARTPS, which stays as is, due to its
exposure to user space.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 882 +++++++++++++++++++------------------
 1 file changed, 444 insertions(+), 438 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 3be1da41c2a8..0b27efef1cb6 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -30,16 +30,16 @@
 #include <linux/of.h>
 #include <linux/module.h>
 
-#define XUARTPS_TTY_NAME	"ttyPS"
-#define XUARTPS_NAME		"cdns-uart"
-#define XUARTPS_MAJOR		0	/* use dynamic node allocation */
-#define XUARTPS_MINOR		0	/* works best with devtmpfs */
-#define XUARTPS_NR_PORTS	2
-#define XUARTPS_FIFO_SIZE	64	/* FIFO size */
-#define XUARTPS_REGISTER_SPACE	0xFFF
+#define CDNS_UART_TTY_NAME	"ttyPS"
+#define CDNS_UART_NAME		"cdns-uart"
+#define CDNS_UART_MAJOR		0	/* use dynamic node allocation */
+#define CDNS_UART_MINOR		0	/* works best with devtmpfs */
+#define CDNS_UART_NR_PORTS	2
+#define CDNS_UART_FIFO_SIZE	64	/* FIFO size */
+#define CDNS_UART_REGISTER_SPACE	0xFFF
 
-#define xuartps_readl(offset)		ioread32(port->membase + offset)
-#define xuartps_writel(val, offset)	iowrite32(val, port->membase + offset)
+#define cdns_uart_readl(offset)		ioread32(port->membase + offset)
+#define cdns_uart_writel(val, offset)	iowrite32(val, port->membase + offset)
 
 /* Rx Trigger level */
 static int rx_trigger_level = 56;
@@ -52,35 +52,35 @@ module_param(rx_timeout, uint, S_IRUGO);
 MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
 
 /* Register offsets for the UART. */
-#define XUARTPS_CR_OFFSET	0x00  /* Control Register */
-#define XUARTPS_MR_OFFSET	0x04  /* Mode Register */
-#define XUARTPS_IER_OFFSET	0x08  /* Interrupt Enable */
-#define XUARTPS_IDR_OFFSET	0x0C  /* Interrupt Disable */
-#define XUARTPS_IMR_OFFSET	0x10  /* Interrupt Mask */
-#define XUARTPS_ISR_OFFSET	0x14  /* Interrupt Status */
-#define XUARTPS_BAUDGEN_OFFSET	0x18  /* Baud Rate Generator */
-#define XUARTPS_RXTOUT_OFFSET	0x1C  /* RX Timeout */
-#define XUARTPS_RXWM_OFFSET	0x20  /* RX FIFO Trigger Level */
-#define XUARTPS_MODEMCR_OFFSET	0x24  /* Modem Control */
-#define XUARTPS_MODEMSR_OFFSET	0x28  /* Modem Status */
-#define XUARTPS_SR_OFFSET	0x2C  /* Channel Status */
-#define XUARTPS_FIFO_OFFSET	0x30  /* FIFO */
-#define XUARTPS_BAUDDIV_OFFSET	0x34  /* Baud Rate Divider */
-#define XUARTPS_FLOWDEL_OFFSET	0x38  /* Flow Delay */
-#define XUARTPS_IRRX_PWIDTH_OFFSET 0x3C /* IR Minimum Received Pulse Width */
-#define XUARTPS_IRTX_PWIDTH_OFFSET 0x40 /* IR Transmitted pulse Width */
-#define XUARTPS_TXWM_OFFSET	0x44  /* TX FIFO Trigger Level */
+#define CDNS_UART_CR_OFFSET		0x00  /* Control Register */
+#define CDNS_UART_MR_OFFSET		0x04  /* Mode Register */
+#define CDNS_UART_IER_OFFSET		0x08  /* Interrupt Enable */
+#define CDNS_UART_IDR_OFFSET		0x0C  /* Interrupt Disable */
+#define CDNS_UART_IMR_OFFSET		0x10  /* Interrupt Mask */
+#define CDNS_UART_ISR_OFFSET		0x14  /* Interrupt Status */
+#define CDNS_UART_BAUDGEN_OFFSET	0x18  /* Baud Rate Generator */
+#define CDNS_UART_RXTOUT_OFFSET		0x1C  /* RX Timeout */
+#define CDNS_UART_RXWM_OFFSET		0x20  /* RX FIFO Trigger Level */
+#define CDNS_UART_MODEMCR_OFFSET	0x24  /* Modem Control */
+#define CDNS_UART_MODEMSR_OFFSET	0x28  /* Modem Status */
+#define CDNS_UART_SR_OFFSET		0x2C  /* Channel Status */
+#define CDNS_UART_FIFO_OFFSET		0x30  /* FIFO */
+#define CDNS_UART_BAUDDIV_OFFSET	0x34  /* Baud Rate Divider */
+#define CDNS_UART_FLOWDEL_OFFSET	0x38  /* Flow Delay */
+#define CDNS_UART_IRRX_PWIDTH_OFFSET	0x3C  /* IR Min Received Pulse Width */
+#define CDNS_UART_IRTX_PWIDTH_OFFSET	0x40  /* IR Transmitted pulse Width */
+#define CDNS_UART_TXWM_OFFSET		0x44  /* TX FIFO Trigger Level */
 
 /* Control Register Bit Definitions */
-#define XUARTPS_CR_STOPBRK	0x00000100  /* Stop TX break */
-#define XUARTPS_CR_STARTBRK	0x00000080  /* Set TX break */
-#define XUARTPS_CR_TX_DIS	0x00000020  /* TX disabled. */
-#define XUARTPS_CR_TX_EN	0x00000010  /* TX enabled */
-#define XUARTPS_CR_RX_DIS	0x00000008  /* RX disabled. */
-#define XUARTPS_CR_RX_EN	0x00000004  /* RX enabled */
-#define XUARTPS_CR_TXRST	0x00000002  /* TX logic reset */
-#define XUARTPS_CR_RXRST	0x00000001  /* RX logic reset */
-#define XUARTPS_CR_RST_TO	0x00000040  /* Restart Timeout Counter */
+#define CDNS_UART_CR_STOPBRK	0x00000100  /* Stop TX break */
+#define CDNS_UART_CR_STARTBRK	0x00000080  /* Set TX break */
+#define CDNS_UART_CR_TX_DIS	0x00000020  /* TX disabled. */
+#define CDNS_UART_CR_TX_EN	0x00000010  /* TX enabled */
+#define CDNS_UART_CR_RX_DIS	0x00000008  /* RX disabled. */
+#define CDNS_UART_CR_RX_EN	0x00000004  /* RX enabled */
+#define CDNS_UART_CR_TXRST	0x00000002  /* TX logic reset */
+#define CDNS_UART_CR_RXRST	0x00000001  /* RX logic reset */
+#define CDNS_UART_CR_RST_TO	0x00000040  /* Restart Timeout Counter */
 
 /*
  * Mode Register:
@@ -88,22 +88,22 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
  * format. If this register is modified during transmission or reception,
  * data validity cannot be guaranteed.
  */
-#define XUARTPS_MR_CLKSEL		0x00000001  /* Pre-scalar selection */
-#define XUARTPS_MR_CHMODE_L_LOOP	0x00000200  /* Local loop back mode */
-#define XUARTPS_MR_CHMODE_NORM		0x00000000  /* Normal mode */
+#define CDNS_UART_MR_CLKSEL		0x00000001  /* Pre-scalar selection */
+#define CDNS_UART_MR_CHMODE_L_LOOP	0x00000200  /* Local loop back mode */
+#define CDNS_UART_MR_CHMODE_NORM	0x00000000  /* Normal mode */
 
-#define XUARTPS_MR_STOPMODE_2_BIT	0x00000080  /* 2 stop bits */
-#define XUARTPS_MR_STOPMODE_1_BIT	0x00000000  /* 1 stop bit */
+#define CDNS_UART_MR_STOPMODE_2_BIT	0x00000080  /* 2 stop bits */
+#define CDNS_UART_MR_STOPMODE_1_BIT	0x00000000  /* 1 stop bit */
 
-#define XUARTPS_MR_PARITY_NONE		0x00000020  /* No parity mode */
-#define XUARTPS_MR_PARITY_MARK		0x00000018  /* Mark parity mode */
-#define XUARTPS_MR_PARITY_SPACE		0x00000010  /* Space parity mode */
-#define XUARTPS_MR_PARITY_ODD		0x00000008  /* Odd parity mode */
-#define XUARTPS_MR_PARITY_EVEN		0x00000000  /* Even parity mode */
+#define CDNS_UART_MR_PARITY_NONE	0x00000020  /* No parity mode */
+#define CDNS_UART_MR_PARITY_MARK	0x00000018  /* Mark parity mode */
+#define CDNS_UART_MR_PARITY_SPACE	0x00000010  /* Space parity mode */
+#define CDNS_UART_MR_PARITY_ODD		0x00000008  /* Odd parity mode */
+#define CDNS_UART_MR_PARITY_EVEN	0x00000000  /* Even parity mode */
 
-#define XUARTPS_MR_CHARLEN_6_BIT	0x00000006  /* 6 bits data */
-#define XUARTPS_MR_CHARLEN_7_BIT	0x00000004  /* 7 bits data */
-#define XUARTPS_MR_CHARLEN_8_BIT	0x00000000  /* 8 bits data */
+#define CDNS_UART_MR_CHARLEN_6_BIT	0x00000006  /* 6 bits data */
+#define CDNS_UART_MR_CHARLEN_7_BIT	0x00000004  /* 7 bits data */
+#define CDNS_UART_MR_CHARLEN_8_BIT	0x00000000  /* 8 bits data */
 
 /*
  * Interrupt Registers:
@@ -116,20 +116,20 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
  * Reading either IER or IDR returns 0x00.
  * All four registers have the same bit definitions.
  */
-#define XUARTPS_IXR_TOUT	0x00000100 /* RX Timeout error interrupt */
-#define XUARTPS_IXR_PARITY	0x00000080 /* Parity error interrupt */
-#define XUARTPS_IXR_FRAMING	0x00000040 /* Framing error interrupt */
-#define XUARTPS_IXR_OVERRUN	0x00000020 /* Overrun error interrupt */
-#define XUARTPS_IXR_TXFULL	0x00000010 /* TX FIFO Full interrupt */
-#define XUARTPS_IXR_TXEMPTY	0x00000008 /* TX FIFO empty interrupt */
-#define XUARTPS_ISR_RXEMPTY	0x00000002 /* RX FIFO empty interrupt */
-#define XUARTPS_IXR_RXTRIG	0x00000001 /* RX FIFO trigger interrupt */
-#define XUARTPS_IXR_RXFULL	0x00000004 /* RX FIFO full interrupt. */
-#define XUARTPS_IXR_RXEMPTY	0x00000002 /* RX FIFO empty interrupt. */
-#define XUARTPS_IXR_MASK	0x00001FFF /* Valid bit mask */
+#define CDNS_UART_IXR_TOUT	0x00000100 /* RX Timeout error interrupt */
+#define CDNS_UART_IXR_PARITY	0x00000080 /* Parity error interrupt */
+#define CDNS_UART_IXR_FRAMING	0x00000040 /* Framing error interrupt */
+#define CDNS_UART_IXR_OVERRUN	0x00000020 /* Overrun error interrupt */
+#define CDNS_UART_IXR_TXFULL	0x00000010 /* TX FIFO Full interrupt */
+#define CDNS_UART_IXR_TXEMPTY	0x00000008 /* TX FIFO empty interrupt */
+#define CDNS_UART_ISR_RXEMPTY	0x00000002 /* RX FIFO empty interrupt */
+#define CDNS_UART_IXR_RXTRIG	0x00000001 /* RX FIFO trigger interrupt */
+#define CDNS_UART_IXR_RXFULL	0x00000004 /* RX FIFO full interrupt. */
+#define CDNS_UART_IXR_RXEMPTY	0x00000002 /* RX FIFO empty interrupt. */
+#define CDNS_UART_IXR_MASK	0x00001FFF /* Valid bit mask */
 
 /* Goes in read_status_mask for break detection as the HW doesn't do it*/
-#define XUARTPS_IXR_BRK		0x80000000
+#define CDNS_UART_IXR_BRK	0x80000000
 
 /*
  * Channel Status Register:
@@ -137,41 +137,42 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
  * to monitor the status of bits in the channel interrupt status register,
  * even if these are masked out by the interrupt mask register.
  */
-#define XUARTPS_SR_RXEMPTY	0x00000002 /* RX FIFO empty */
-#define XUARTPS_SR_TXEMPTY	0x00000008 /* TX FIFO empty */
-#define XUARTPS_SR_TXFULL	0x00000010 /* TX FIFO full */
-#define XUARTPS_SR_RXTRIG	0x00000001 /* Rx Trigger */
+#define CDNS_UART_SR_RXEMPTY	0x00000002 /* RX FIFO empty */
+#define CDNS_UART_SR_TXEMPTY	0x00000008 /* TX FIFO empty */
+#define CDNS_UART_SR_TXFULL	0x00000010 /* TX FIFO full */
+#define CDNS_UART_SR_RXTRIG	0x00000001 /* Rx Trigger */
 
 /* baud dividers min/max values */
-#define XUARTPS_BDIV_MIN	4
-#define XUARTPS_BDIV_MAX	255
-#define XUARTPS_CD_MAX		65535
+#define CDNS_UART_BDIV_MIN	4
+#define CDNS_UART_BDIV_MAX	255
+#define CDNS_UART_CD_MAX	65535
 
 /**
- * struct xuartps - device data
+ * struct cdns_uart - device data
  * @port:		Pointer to the UART port
  * @uartclk:		Reference clock
  * @pclk:		APB clock
  * @baud:		Current baud rate
  * @clk_rate_change_nb:	Notifier block for clock changes
  */
-struct xuartps {
+struct cdns_uart {
 	struct uart_port	*port;
 	struct clk		*uartclk;
 	struct clk		*pclk;
 	unsigned int		baud;
 	struct notifier_block	clk_rate_change_nb;
 };
-#define to_xuartps(_nb) container_of(_nb, struct xuartps, clk_rate_change_nb);
+#define to_cdns_uart(_nb) container_of(_nb, struct cdns_uart, \
+		clk_rate_change_nb);
 
 /**
- * xuartps_isr - Interrupt handler
+ * cdns_uart_isr - Interrupt handler
  * @irq: Irq number
  * @dev_id: Id of the port
  *
  * Return: IRQHANDLED
  */
-static irqreturn_t xuartps_isr(int irq, void *dev_id)
+static irqreturn_t cdns_uart_isr(int irq, void *dev_id)
 {
 	struct uart_port *port = (struct uart_port *)dev_id;
 	unsigned long flags;
@@ -184,42 +185,42 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
 	/* Read the interrupt status register to determine which
 	 * interrupt(s) is/are active.
 	 */
-	isrstatus = xuartps_readl(XUARTPS_ISR_OFFSET);
+	isrstatus = cdns_uart_readl(CDNS_UART_ISR_OFFSET);
 
 	/*
 	 * There is no hardware break detection, so we interpret framing
 	 * error with all-zeros data as a break sequence. Most of the time,
 	 * there's another non-zero byte at the end of the sequence.
 	 */
-	if (isrstatus & XUARTPS_IXR_FRAMING) {
-		while (!(xuartps_readl(XUARTPS_SR_OFFSET) &
-					XUARTPS_SR_RXEMPTY)) {
-			if (!xuartps_readl(XUARTPS_FIFO_OFFSET)) {
-				port->read_status_mask |= XUARTPS_IXR_BRK;
-				isrstatus &= ~XUARTPS_IXR_FRAMING;
+	if (isrstatus & CDNS_UART_IXR_FRAMING) {
+		while (!(cdns_uart_readl(CDNS_UART_SR_OFFSET) &
+					CDNS_UART_SR_RXEMPTY)) {
+			if (!cdns_uart_readl(CDNS_UART_FIFO_OFFSET)) {
+				port->read_status_mask |= CDNS_UART_IXR_BRK;
+				isrstatus &= ~CDNS_UART_IXR_FRAMING;
 			}
 		}
-		xuartps_writel(XUARTPS_IXR_FRAMING, XUARTPS_ISR_OFFSET);
+		cdns_uart_writel(CDNS_UART_IXR_FRAMING, CDNS_UART_ISR_OFFSET);
 	}
 
 	/* drop byte with parity error if IGNPAR specified */
-	if (isrstatus & port->ignore_status_mask & XUARTPS_IXR_PARITY)
-		isrstatus &= ~(XUARTPS_IXR_RXTRIG | XUARTPS_IXR_TOUT);
+	if (isrstatus & port->ignore_status_mask & CDNS_UART_IXR_PARITY)
+		isrstatus &= ~(CDNS_UART_IXR_RXTRIG | CDNS_UART_IXR_TOUT);
 
 	isrstatus &= port->read_status_mask;
 	isrstatus &= ~port->ignore_status_mask;
 
-	if ((isrstatus & XUARTPS_IXR_TOUT) ||
-		(isrstatus & XUARTPS_IXR_RXTRIG)) {
+	if ((isrstatus & CDNS_UART_IXR_TOUT) ||
+		(isrstatus & CDNS_UART_IXR_RXTRIG)) {
 		/* Receive Timeout Interrupt */
-		while ((xuartps_readl(XUARTPS_SR_OFFSET) &
-			XUARTPS_SR_RXEMPTY) != XUARTPS_SR_RXEMPTY) {
-			data = xuartps_readl(XUARTPS_FIFO_OFFSET);
+		while ((cdns_uart_readl(CDNS_UART_SR_OFFSET) &
+			CDNS_UART_SR_RXEMPTY) != CDNS_UART_SR_RXEMPTY) {
+			data = cdns_uart_readl(CDNS_UART_FIFO_OFFSET);
 
 			/* Non-NULL byte after BREAK is garbage (99%) */
 			if (data && (port->read_status_mask &
-						XUARTPS_IXR_BRK)) {
-				port->read_status_mask &= ~XUARTPS_IXR_BRK;
+						CDNS_UART_IXR_BRK)) {
+				port->read_status_mask &= ~CDNS_UART_IXR_BRK;
 				port->icount.brk++;
 				if (uart_handle_break(port))
 					continue;
@@ -243,17 +244,17 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
 
 			port->icount.rx++;
 
-			if (isrstatus & XUARTPS_IXR_PARITY) {
+			if (isrstatus & CDNS_UART_IXR_PARITY) {
 				port->icount.parity++;
 				status = TTY_PARITY;
-			} else if (isrstatus & XUARTPS_IXR_FRAMING) {
+			} else if (isrstatus & CDNS_UART_IXR_FRAMING) {
 				port->icount.frame++;
 				status = TTY_FRAME;
-			} else if (isrstatus & XUARTPS_IXR_OVERRUN) {
+			} else if (isrstatus & CDNS_UART_IXR_OVERRUN) {
 				port->icount.overrun++;
 			}
 
-			uart_insert_char(port, isrstatus, XUARTPS_IXR_OVERRUN,
+			uart_insert_char(port, isrstatus, CDNS_UART_IXR_OVERRUN,
 					data, status);
 		}
 		spin_unlock(&port->lock);
@@ -262,10 +263,10 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
 	}
 
 	/* Dispatch an appropriate handler */
-	if ((isrstatus & XUARTPS_IXR_TXEMPTY) == XUARTPS_IXR_TXEMPTY) {
+	if ((isrstatus & CDNS_UART_IXR_TXEMPTY) == CDNS_UART_IXR_TXEMPTY) {
 		if (uart_circ_empty(&port->state->xmit)) {
-			xuartps_writel(XUARTPS_IXR_TXEMPTY,
-						XUARTPS_IDR_OFFSET);
+			cdns_uart_writel(CDNS_UART_IXR_TXEMPTY,
+						CDNS_UART_IDR_OFFSET);
 		} else {
 			numbytes = port->fifosize;
 			/* Break if no more data available in the UART buffer */
@@ -273,12 +274,12 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
 				if (uart_circ_empty(&port->state->xmit))
 					break;
 				/* Get the data from the UART circular buffer
-				 * and write it to the xuartps's TX_FIFO
+				 * and write it to the cdns_uart's TX_FIFO
 				 * register.
 				 */
-				xuartps_writel(
+				cdns_uart_writel(
 					port->state->xmit.buf[port->state->xmit.
-					tail], XUARTPS_FIFO_OFFSET);
+					tail], CDNS_UART_FIFO_OFFSET);
 
 				port->icount.tx++;
 
@@ -296,7 +297,7 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
 		}
 	}
 
-	xuartps_writel(isrstatus, XUARTPS_ISR_OFFSET);
+	cdns_uart_writel(isrstatus, CDNS_UART_ISR_OFFSET);
 
 	/* be sure to release the lock and tty before leaving */
 	spin_unlock_irqrestore(&port->lock, flags);
@@ -305,7 +306,7 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
 }
 
 /**
- * xuartps_calc_baud_divs - Calculate baud rate divisors
+ * cdns_uart_calc_baud_divs - Calculate baud rate divisors
  * @clk: UART module input clock
  * @baud: Desired baud rate
  * @rbdiv: BDIV value (return value)
@@ -324,8 +325,8 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
  *			baud rate generate register
  *			baud rate clock divisor register
  */
-static unsigned int xuartps_calc_baud_divs(unsigned int clk, unsigned int baud,
-		u32 *rbdiv, u32 *rcd, int *div8)
+static unsigned int cdns_uart_calc_baud_divs(unsigned int clk,
+		unsigned int baud, u32 *rbdiv, u32 *rcd, int *div8)
 {
 	u32 cd, bdiv;
 	unsigned int calc_baud;
@@ -333,16 +334,16 @@ static unsigned int xuartps_calc_baud_divs(unsigned int clk, unsigned int baud,
 	unsigned int bauderror;
 	unsigned int besterror = ~0;
 
-	if (baud < clk / ((XUARTPS_BDIV_MAX + 1) * XUARTPS_CD_MAX)) {
+	if (baud < clk / ((CDNS_UART_BDIV_MAX + 1) * CDNS_UART_CD_MAX)) {
 		*div8 = 1;
 		clk /= 8;
 	} else {
 		*div8 = 0;
 	}
 
-	for (bdiv = XUARTPS_BDIV_MIN; bdiv <= XUARTPS_BDIV_MAX; bdiv++) {
+	for (bdiv = CDNS_UART_BDIV_MIN; bdiv <= CDNS_UART_BDIV_MAX; bdiv++) {
 		cd = DIV_ROUND_CLOSEST(clk, baud * (bdiv + 1));
-		if (cd < 1 || cd > XUARTPS_CD_MAX)
+		if (cd < 1 || cd > CDNS_UART_CD_MAX)
 			continue;
 
 		calc_baud = clk / (cd * (bdiv + 1));
@@ -367,47 +368,47 @@ static unsigned int xuartps_calc_baud_divs(unsigned int clk, unsigned int baud,
 }
 
 /**
- * xuartps_set_baud_rate - Calculate and set the baud rate
+ * cdns_uart_set_baud_rate - Calculate and set the baud rate
  * @port: Handle to the uart port structure
  * @baud: Baud rate to set
  * Return: baud rate, requested baud when possible, or actual baud when there
  *	   was too much error, zero if no valid divisors are found.
  */
-static unsigned int xuartps_set_baud_rate(struct uart_port *port,
+static unsigned int cdns_uart_set_baud_rate(struct uart_port *port,
 		unsigned int baud)
 {
 	unsigned int calc_baud;
 	u32 cd = 0, bdiv = 0;
 	u32 mreg;
 	int div8;
-	struct xuartps *xuartps = port->private_data;
+	struct cdns_uart *cdns_uart = port->private_data;
 
-	calc_baud = xuartps_calc_baud_divs(port->uartclk, baud, &bdiv, &cd,
+	calc_baud = cdns_uart_calc_baud_divs(port->uartclk, baud, &bdiv, &cd,
 			&div8);
 
 	/* Write new divisors to hardware */
-	mreg = xuartps_readl(XUARTPS_MR_OFFSET);
+	mreg = cdns_uart_readl(CDNS_UART_MR_OFFSET);
 	if (div8)
-		mreg |= XUARTPS_MR_CLKSEL;
+		mreg |= CDNS_UART_MR_CLKSEL;
 	else
-		mreg &= ~XUARTPS_MR_CLKSEL;
-	xuartps_writel(mreg, XUARTPS_MR_OFFSET);
-	xuartps_writel(cd, XUARTPS_BAUDGEN_OFFSET);
-	xuartps_writel(bdiv, XUARTPS_BAUDDIV_OFFSET);
-	xuartps->baud = baud;
+		mreg &= ~CDNS_UART_MR_CLKSEL;
+	cdns_uart_writel(mreg, CDNS_UART_MR_OFFSET);
+	cdns_uart_writel(cd, CDNS_UART_BAUDGEN_OFFSET);
+	cdns_uart_writel(bdiv, CDNS_UART_BAUDDIV_OFFSET);
+	cdns_uart->baud = baud;
 
 	return calc_baud;
 }
 
 #ifdef CONFIG_COMMON_CLK
 /**
- * xuartps_clk_notitifer_cb - Clock notifier callback
+ * cdns_uart_clk_notitifer_cb - Clock notifier callback
  * @nb:		Notifier block
  * @event:	Notify event
  * @data:	Notifier data
  * Return:	NOTIFY_OK or NOTIFY_DONE on success, NOTIFY_BAD on error.
  */
-static int xuartps_clk_notifier_cb(struct notifier_block *nb,
+static int cdns_uart_clk_notifier_cb(struct notifier_block *nb,
 		unsigned long event, void *data)
 {
 	u32 ctrl_reg;
@@ -415,9 +416,9 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 	int locked = 0;
 	struct clk_notifier_data *ndata = data;
 	unsigned long flags = 0;
-	struct xuartps *xuartps = to_xuartps(nb);
+	struct cdns_uart *cdns_uart = to_cdns_uart(nb);
 
-	port = xuartps->port;
+	port = cdns_uart->port;
 	if (port->suspended)
 		return NOTIFY_OK;
 
@@ -431,20 +432,20 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 		 * Find out if current baud-rate can be achieved with new clock
 		 * frequency.
 		 */
-		if (!xuartps_calc_baud_divs(ndata->new_rate, xuartps->baud,
+		if (!cdns_uart_calc_baud_divs(ndata->new_rate, cdns_uart->baud,
 					&bdiv, &cd, &div8)) {
 			dev_warn(port->dev, "clock rate change rejected\n");
 			return NOTIFY_BAD;
 		}
 
-		spin_lock_irqsave(&xuartps->port->lock, flags);
+		spin_lock_irqsave(&cdns_uart->port->lock, flags);
 
 		/* Disable the TX and RX to set baud rate */
-		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
-		ctrl_reg |= XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS;
-		xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
+		ctrl_reg = cdns_uart_readl(CDNS_UART_CR_OFFSET);
+		ctrl_reg |= CDNS_UART_CR_TX_DIS | CDNS_UART_CR_RX_DIS;
+		cdns_uart_writel(ctrl_reg, CDNS_UART_CR_OFFSET);
 
-		spin_unlock_irqrestore(&xuartps->port->lock, flags);
+		spin_unlock_irqrestore(&cdns_uart->port->lock, flags);
 
 		return NOTIFY_OK;
 	}
@@ -454,25 +455,25 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 		 * frequency.
 		 */
 
-		spin_lock_irqsave(&xuartps->port->lock, flags);
+		spin_lock_irqsave(&cdns_uart->port->lock, flags);
 
 		locked = 1;
 		port->uartclk = ndata->new_rate;
 
-		xuartps->baud = xuartps_set_baud_rate(xuartps->port,
-				xuartps->baud);
+		cdns_uart->baud = cdns_uart_set_baud_rate(cdns_uart->port,
+				cdns_uart->baud);
 		/* fall through */
 	case ABORT_RATE_CHANGE:
 		if (!locked)
-			spin_lock_irqsave(&xuartps->port->lock, flags);
+			spin_lock_irqsave(&cdns_uart->port->lock, flags);
 
 		/* Set TX/RX Reset */
-		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
-		ctrl_reg |= XUARTPS_CR_TXRST | XUARTPS_CR_RXRST;
-		xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
+		ctrl_reg = cdns_uart_readl(CDNS_UART_CR_OFFSET);
+		ctrl_reg |= CDNS_UART_CR_TXRST | CDNS_UART_CR_RXRST;
+		cdns_uart_writel(ctrl_reg, CDNS_UART_CR_OFFSET);
 
-		while (xuartps_readl(XUARTPS_CR_OFFSET) &
-				(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST))
+		while (cdns_uart_readl(CDNS_UART_CR_OFFSET) &
+				(CDNS_UART_CR_TXRST | CDNS_UART_CR_RXRST))
 			cpu_relax();
 
 		/*
@@ -480,13 +481,13 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 		 * enable bit and RX enable bit to enable the transmitter and
 		 * receiver.
 		 */
-		xuartps_writel(rx_timeout, XUARTPS_RXTOUT_OFFSET);
-		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
-		ctrl_reg &= ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS);
-		ctrl_reg |= XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN;
-		xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
+		cdns_uart_writel(rx_timeout, CDNS_UART_RXTOUT_OFFSET);
+		ctrl_reg = cdns_uart_readl(CDNS_UART_CR_OFFSET);
+		ctrl_reg &= ~(CDNS_UART_CR_TX_DIS | CDNS_UART_CR_RX_DIS);
+		ctrl_reg |= CDNS_UART_CR_TX_EN | CDNS_UART_CR_RX_EN;
+		cdns_uart_writel(ctrl_reg, CDNS_UART_CR_OFFSET);
 
-		spin_unlock_irqrestore(&xuartps->port->lock, flags);
+		spin_unlock_irqrestore(&cdns_uart->port->lock, flags);
 
 		return NOTIFY_OK;
 	default:
@@ -496,35 +497,35 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 #endif
 
 /**
- * xuartps_start_tx -  Start transmitting bytes
+ * cdns_uart_start_tx -  Start transmitting bytes
  * @port: Handle to the uart port structure
  */
-static void xuartps_start_tx(struct uart_port *port)
+static void cdns_uart_start_tx(struct uart_port *port)
 {
 	unsigned int status, numbytes = port->fifosize;
 
 	if (uart_circ_empty(&port->state->xmit) || uart_tx_stopped(port))
 		return;
 
-	status = xuartps_readl(XUARTPS_CR_OFFSET);
+	status = cdns_uart_readl(CDNS_UART_CR_OFFSET);
 	/* Set the TX enable bit and clear the TX disable bit to enable the
 	 * transmitter.
 	 */
-	xuartps_writel((status & ~XUARTPS_CR_TX_DIS) | XUARTPS_CR_TX_EN,
-		XUARTPS_CR_OFFSET);
+	cdns_uart_writel((status & ~CDNS_UART_CR_TX_DIS) | CDNS_UART_CR_TX_EN,
+		CDNS_UART_CR_OFFSET);
 
-	while (numbytes-- && ((xuartps_readl(XUARTPS_SR_OFFSET) &
-				XUARTPS_SR_TXFULL)) != XUARTPS_SR_TXFULL) {
+	while (numbytes-- && ((cdns_uart_readl(CDNS_UART_SR_OFFSET) &
+				CDNS_UART_SR_TXFULL)) != CDNS_UART_SR_TXFULL) {
 		/* Break if no more data available in the UART buffer */
 		if (uart_circ_empty(&port->state->xmit))
 			break;
 
 		/* Get the data from the UART circular buffer and
-		 * write it to the xuartps's TX_FIFO register.
+		 * write it to the cdns_uart's TX_FIFO register.
 		 */
-		xuartps_writel(
+		cdns_uart_writel(
 			port->state->xmit.buf[port->state->xmit.tail],
-			XUARTPS_FIFO_OFFSET);
+			CDNS_UART_FIFO_OFFSET);
 		port->icount.tx++;
 
 		/* Adjust the tail of the UART buffer and wrap
@@ -533,90 +534,90 @@ static void xuartps_start_tx(struct uart_port *port)
 		port->state->xmit.tail = (port->state->xmit.tail + 1) &
 					(UART_XMIT_SIZE - 1);
 	}
-	xuartps_writel(XUARTPS_IXR_TXEMPTY, XUARTPS_ISR_OFFSET);
+	cdns_uart_writel(CDNS_UART_IXR_TXEMPTY, CDNS_UART_ISR_OFFSET);
 	/* Enable the TX Empty interrupt */
-	xuartps_writel(XUARTPS_IXR_TXEMPTY, XUARTPS_IER_OFFSET);
+	cdns_uart_writel(CDNS_UART_IXR_TXEMPTY, CDNS_UART_IER_OFFSET);
 
 	if (uart_circ_chars_pending(&port->state->xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 }
 
 /**
- * xuartps_stop_tx - Stop TX
+ * cdns_uart_stop_tx - Stop TX
  * @port: Handle to the uart port structure
  */
-static void xuartps_stop_tx(struct uart_port *port)
+static void cdns_uart_stop_tx(struct uart_port *port)
 {
 	unsigned int regval;
 
-	regval = xuartps_readl(XUARTPS_CR_OFFSET);
-	regval |= XUARTPS_CR_TX_DIS;
+	regval = cdns_uart_readl(CDNS_UART_CR_OFFSET);
+	regval |= CDNS_UART_CR_TX_DIS;
 	/* Disable the transmitter */
-	xuartps_writel(regval, XUARTPS_CR_OFFSET);
+	cdns_uart_writel(regval, CDNS_UART_CR_OFFSET);
 }
 
 /**
- * xuartps_stop_rx - Stop RX
+ * cdns_uart_stop_rx - Stop RX
  * @port: Handle to the uart port structure
  */
-static void xuartps_stop_rx(struct uart_port *port)
+static void cdns_uart_stop_rx(struct uart_port *port)
 {
 	unsigned int regval;
 
-	regval = xuartps_readl(XUARTPS_CR_OFFSET);
-	regval |= XUARTPS_CR_RX_DIS;
+	regval = cdns_uart_readl(CDNS_UART_CR_OFFSET);
+	regval |= CDNS_UART_CR_RX_DIS;
 	/* Disable the receiver */
-	xuartps_writel(regval, XUARTPS_CR_OFFSET);
+	cdns_uart_writel(regval, CDNS_UART_CR_OFFSET);
 }
 
 /**
- * xuartps_tx_empty -  Check whether TX is empty
+ * cdns_uart_tx_empty -  Check whether TX is empty
  * @port: Handle to the uart port structure
  *
  * Return: TIOCSER_TEMT on success, 0 otherwise
  */
-static unsigned int xuartps_tx_empty(struct uart_port *port)
+static unsigned int cdns_uart_tx_empty(struct uart_port *port)
 {
 	unsigned int status;
 
-	status = xuartps_readl(XUARTPS_ISR_OFFSET) & XUARTPS_IXR_TXEMPTY;
+	status = cdns_uart_readl(CDNS_UART_ISR_OFFSET) & CDNS_UART_IXR_TXEMPTY;
 	return status ? TIOCSER_TEMT : 0;
 }
 
 /**
- * xuartps_break_ctl - Based on the input ctl we have to start or stop
+ * cdns_uart_break_ctl - Based on the input ctl we have to start or stop
  *			transmitting char breaks
  * @port: Handle to the uart port structure
  * @ctl: Value based on which start or stop decision is taken
  */
-static void xuartps_break_ctl(struct uart_port *port, int ctl)
+static void cdns_uart_break_ctl(struct uart_port *port, int ctl)
 {
 	unsigned int status;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
 
-	status = xuartps_readl(XUARTPS_CR_OFFSET);
+	status = cdns_uart_readl(CDNS_UART_CR_OFFSET);
 
 	if (ctl == -1)
-		xuartps_writel(XUARTPS_CR_STARTBRK | status,
-					XUARTPS_CR_OFFSET);
+		cdns_uart_writel(CDNS_UART_CR_STARTBRK | status,
+					CDNS_UART_CR_OFFSET);
 	else {
-		if ((status & XUARTPS_CR_STOPBRK) == 0)
-			xuartps_writel(XUARTPS_CR_STOPBRK | status,
-					 XUARTPS_CR_OFFSET);
+		if ((status & CDNS_UART_CR_STOPBRK) == 0)
+			cdns_uart_writel(CDNS_UART_CR_STOPBRK | status,
+					 CDNS_UART_CR_OFFSET);
 	}
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /**
- * xuartps_set_termios - termios operations, handling data length, parity,
+ * cdns_uart_set_termios - termios operations, handling data length, parity,
  *				stop bits, flow control, baud rate
  * @port: Handle to the uart port structure
  * @termios: Handle to the input termios structure
  * @old: Values of the previously saved termios structure
  */
-static void xuartps_set_termios(struct uart_port *port,
+static void cdns_uart_set_termios(struct uart_port *port,
 				struct ktermios *termios, struct ktermios *old)
 {
 	unsigned int cval = 0;
@@ -627,25 +628,26 @@ static void xuartps_set_termios(struct uart_port *port,
 	spin_lock_irqsave(&port->lock, flags);
 
 	/* Empty the receive FIFO 1st before making changes */
-	while ((xuartps_readl(XUARTPS_SR_OFFSET) &
-		 XUARTPS_SR_RXEMPTY) != XUARTPS_SR_RXEMPTY) {
-		xuartps_readl(XUARTPS_FIFO_OFFSET);
+	while ((cdns_uart_readl(CDNS_UART_SR_OFFSET) &
+		 CDNS_UART_SR_RXEMPTY) != CDNS_UART_SR_RXEMPTY) {
+		cdns_uart_readl(CDNS_UART_FIFO_OFFSET);
 	}
 
 	/* Disable the TX and RX to set baud rate */
-	ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
-	ctrl_reg |= XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS;
-	xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
+	ctrl_reg = cdns_uart_readl(CDNS_UART_CR_OFFSET);
+	ctrl_reg |= CDNS_UART_CR_TX_DIS | CDNS_UART_CR_RX_DIS;
+	cdns_uart_writel(ctrl_reg, CDNS_UART_CR_OFFSET);
 
 	/*
 	 * Min baud rate = 6bps and Max Baud Rate is 10Mbps for 100Mhz clk
 	 * min and max baud should be calculated here based on port->uartclk.
 	 * this way we get a valid baud and can safely call set_baud()
 	 */
-	minbaud = port->uartclk / ((XUARTPS_BDIV_MAX + 1) * XUARTPS_CD_MAX * 8);
-	maxbaud = port->uartclk / (XUARTPS_BDIV_MIN + 1);
+	minbaud = port->uartclk /
+			((CDNS_UART_BDIV_MAX + 1) * CDNS_UART_CD_MAX * 8);
+	maxbaud = port->uartclk / (CDNS_UART_BDIV_MIN + 1);
 	baud = uart_get_baud_rate(port, termios, old, minbaud, maxbaud);
-	baud = xuartps_set_baud_rate(port, baud);
+	baud = cdns_uart_set_baud_rate(port, baud);
 	if (tty_termios_baud_rate(termios))
 		tty_termios_encode_baud_rate(termios, baud, baud);
 
@@ -653,52 +655,52 @@ static void xuartps_set_termios(struct uart_port *port,
 	uart_update_timeout(port, termios->c_cflag, baud);
 
 	/* Set TX/RX Reset */
-	ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
-	ctrl_reg |= XUARTPS_CR_TXRST | XUARTPS_CR_RXRST;
-	xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
+	ctrl_reg = cdns_uart_readl(CDNS_UART_CR_OFFSET);
+	ctrl_reg |= CDNS_UART_CR_TXRST | CDNS_UART_CR_RXRST;
+	cdns_uart_writel(ctrl_reg, CDNS_UART_CR_OFFSET);
 
 	/*
 	 * Clear the RX disable and TX disable bits and then set the TX enable
 	 * bit and RX enable bit to enable the transmitter and receiver.
 	 */
-	ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
-	ctrl_reg &= ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS);
-	ctrl_reg |= XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN;
-	xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
+	ctrl_reg = cdns_uart_readl(CDNS_UART_CR_OFFSET);
+	ctrl_reg &= ~(CDNS_UART_CR_TX_DIS | CDNS_UART_CR_RX_DIS);
+	ctrl_reg |= CDNS_UART_CR_TX_EN | CDNS_UART_CR_RX_EN;
+	cdns_uart_writel(ctrl_reg, CDNS_UART_CR_OFFSET);
 
-	xuartps_writel(rx_timeout, XUARTPS_RXTOUT_OFFSET);
+	cdns_uart_writel(rx_timeout, CDNS_UART_RXTOUT_OFFSET);
 
-	port->read_status_mask = XUARTPS_IXR_TXEMPTY | XUARTPS_IXR_RXTRIG |
-			XUARTPS_IXR_OVERRUN | XUARTPS_IXR_TOUT;
+	port->read_status_mask = CDNS_UART_IXR_TXEMPTY | CDNS_UART_IXR_RXTRIG |
+			CDNS_UART_IXR_OVERRUN | CDNS_UART_IXR_TOUT;
 	port->ignore_status_mask = 0;
 
 	if (termios->c_iflag & INPCK)
-		port->read_status_mask |= XUARTPS_IXR_PARITY |
-		XUARTPS_IXR_FRAMING;
+		port->read_status_mask |= CDNS_UART_IXR_PARITY |
+		CDNS_UART_IXR_FRAMING;
 
 	if (termios->c_iflag & IGNPAR)
-		port->ignore_status_mask |= XUARTPS_IXR_PARITY |
-			XUARTPS_IXR_FRAMING | XUARTPS_IXR_OVERRUN;
+		port->ignore_status_mask |= CDNS_UART_IXR_PARITY |
+			CDNS_UART_IXR_FRAMING | CDNS_UART_IXR_OVERRUN;
 
 	/* ignore all characters if CREAD is not set */
 	if ((termios->c_cflag & CREAD) == 0)
-		port->ignore_status_mask |= XUARTPS_IXR_RXTRIG |
-			XUARTPS_IXR_TOUT | XUARTPS_IXR_PARITY |
-			XUARTPS_IXR_FRAMING | XUARTPS_IXR_OVERRUN;
+		port->ignore_status_mask |= CDNS_UART_IXR_RXTRIG |
+			CDNS_UART_IXR_TOUT | CDNS_UART_IXR_PARITY |
+			CDNS_UART_IXR_FRAMING | CDNS_UART_IXR_OVERRUN;
 
-	mode_reg = xuartps_readl(XUARTPS_MR_OFFSET);
+	mode_reg = cdns_uart_readl(CDNS_UART_MR_OFFSET);
 
 	/* Handling Data Size */
 	switch (termios->c_cflag & CSIZE) {
 	case CS6:
-		cval |= XUARTPS_MR_CHARLEN_6_BIT;
+		cval |= CDNS_UART_MR_CHARLEN_6_BIT;
 		break;
 	case CS7:
-		cval |= XUARTPS_MR_CHARLEN_7_BIT;
+		cval |= CDNS_UART_MR_CHARLEN_7_BIT;
 		break;
 	default:
 	case CS8:
-		cval |= XUARTPS_MR_CHARLEN_8_BIT;
+		cval |= CDNS_UART_MR_CHARLEN_8_BIT;
 		termios->c_cflag &= ~CSIZE;
 		termios->c_cflag |= CS8;
 		break;
@@ -706,133 +708,135 @@ static void xuartps_set_termios(struct uart_port *port,
 
 	/* Handling Parity and Stop Bits length */
 	if (termios->c_cflag & CSTOPB)
-		cval |= XUARTPS_MR_STOPMODE_2_BIT; /* 2 STOP bits */
+		cval |= CDNS_UART_MR_STOPMODE_2_BIT; /* 2 STOP bits */
 	else
-		cval |= XUARTPS_MR_STOPMODE_1_BIT; /* 1 STOP bit */
+		cval |= CDNS_UART_MR_STOPMODE_1_BIT; /* 1 STOP bit */
 
 	if (termios->c_cflag & PARENB) {
 		/* Mark or Space parity */
 		if (termios->c_cflag & CMSPAR) {
 			if (termios->c_cflag & PARODD)
-				cval |= XUARTPS_MR_PARITY_MARK;
+				cval |= CDNS_UART_MR_PARITY_MARK;
 			else
-				cval |= XUARTPS_MR_PARITY_SPACE;
+				cval |= CDNS_UART_MR_PARITY_SPACE;
 		} else {
 			if (termios->c_cflag & PARODD)
-				cval |= XUARTPS_MR_PARITY_ODD;
+				cval |= CDNS_UART_MR_PARITY_ODD;
 			else
-				cval |= XUARTPS_MR_PARITY_EVEN;
+				cval |= CDNS_UART_MR_PARITY_EVEN;
 		}
 	} else {
-		cval |= XUARTPS_MR_PARITY_NONE;
+		cval |= CDNS_UART_MR_PARITY_NONE;
 	}
 	cval |= mode_reg & 1;
-	xuartps_writel(cval, XUARTPS_MR_OFFSET);
+	cdns_uart_writel(cval, CDNS_UART_MR_OFFSET);
 
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /**
- * xuartps_startup - Called when an application opens a xuartps port
+ * cdns_uart_startup - Called when an application opens a cdns_uart port
  * @port: Handle to the uart port structure
  *
  * Return: 0 on success, negative errno otherwise
  */
-static int xuartps_startup(struct uart_port *port)
+static int cdns_uart_startup(struct uart_port *port)
 {
 	unsigned int retval = 0, status = 0;
 
-	retval = request_irq(port->irq, xuartps_isr, 0, XUARTPS_NAME,
+	retval = request_irq(port->irq, cdns_uart_isr, 0, CDNS_UART_NAME,
 								(void *)port);
 	if (retval)
 		return retval;
 
 	/* Disable the TX and RX */
-	xuartps_writel(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS,
-						XUARTPS_CR_OFFSET);
+	cdns_uart_writel(CDNS_UART_CR_TX_DIS | CDNS_UART_CR_RX_DIS,
+						CDNS_UART_CR_OFFSET);
 
 	/* Set the Control Register with TX/RX Enable, TX/RX Reset,
 	 * no break chars.
 	 */
-	xuartps_writel(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST,
-				XUARTPS_CR_OFFSET);
+	cdns_uart_writel(CDNS_UART_CR_TXRST | CDNS_UART_CR_RXRST,
+				CDNS_UART_CR_OFFSET);
 
-	status = xuartps_readl(XUARTPS_CR_OFFSET);
+	status = cdns_uart_readl(CDNS_UART_CR_OFFSET);
 
 	/* Clear the RX disable and TX disable bits and then set the TX enable
 	 * bit and RX enable bit to enable the transmitter and receiver.
 	 */
-	xuartps_writel((status & ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS))
-			| (XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN |
-			XUARTPS_CR_STOPBRK), XUARTPS_CR_OFFSET);
+	cdns_uart_writel((status & ~(CDNS_UART_CR_TX_DIS | CDNS_UART_CR_RX_DIS))
+			| (CDNS_UART_CR_TX_EN | CDNS_UART_CR_RX_EN |
+			CDNS_UART_CR_STOPBRK), CDNS_UART_CR_OFFSET);
 
 	/* Set the Mode Register with normal mode,8 data bits,1 stop bit,
 	 * no parity.
 	 */
-	xuartps_writel(XUARTPS_MR_CHMODE_NORM | XUARTPS_MR_STOPMODE_1_BIT
-		| XUARTPS_MR_PARITY_NONE | XUARTPS_MR_CHARLEN_8_BIT,
-		 XUARTPS_MR_OFFSET);
+	cdns_uart_writel(CDNS_UART_MR_CHMODE_NORM | CDNS_UART_MR_STOPMODE_1_BIT
+		| CDNS_UART_MR_PARITY_NONE | CDNS_UART_MR_CHARLEN_8_BIT,
+		 CDNS_UART_MR_OFFSET);
 
 	/*
 	 * Set the RX FIFO Trigger level to use most of the FIFO, but it
 	 * can be tuned with a module parameter
 	 */
-	xuartps_writel(rx_trigger_level, XUARTPS_RXWM_OFFSET);
+	cdns_uart_writel(rx_trigger_level, CDNS_UART_RXWM_OFFSET);
 
 	/*
 	 * Receive Timeout register is enabled but it
 	 * can be tuned with a module parameter
 	 */
-	xuartps_writel(rx_timeout, XUARTPS_RXTOUT_OFFSET);
+	cdns_uart_writel(rx_timeout, CDNS_UART_RXTOUT_OFFSET);
 
 	/* Clear out any pending interrupts before enabling them */
-	xuartps_writel(xuartps_readl(XUARTPS_ISR_OFFSET), XUARTPS_ISR_OFFSET);
+	cdns_uart_writel(cdns_uart_readl(CDNS_UART_ISR_OFFSET),
+			CDNS_UART_ISR_OFFSET);
 
 	/* Set the Interrupt Registers with desired interrupts */
-	xuartps_writel(XUARTPS_IXR_TXEMPTY | XUARTPS_IXR_PARITY |
-		XUARTPS_IXR_FRAMING | XUARTPS_IXR_OVERRUN |
-		XUARTPS_IXR_RXTRIG | XUARTPS_IXR_TOUT, XUARTPS_IER_OFFSET);
+	cdns_uart_writel(CDNS_UART_IXR_TXEMPTY | CDNS_UART_IXR_PARITY |
+		CDNS_UART_IXR_FRAMING | CDNS_UART_IXR_OVERRUN |
+		CDNS_UART_IXR_RXTRIG | CDNS_UART_IXR_TOUT,
+		CDNS_UART_IER_OFFSET);
 
 	return retval;
 }
 
 /**
- * xuartps_shutdown - Called when an application closes a xuartps port
+ * cdns_uart_shutdown - Called when an application closes a cdns_uart port
  * @port: Handle to the uart port structure
  */
-static void xuartps_shutdown(struct uart_port *port)
+static void cdns_uart_shutdown(struct uart_port *port)
 {
 	int status;
 
 	/* Disable interrupts */
-	status = xuartps_readl(XUARTPS_IMR_OFFSET);
-	xuartps_writel(status, XUARTPS_IDR_OFFSET);
+	status = cdns_uart_readl(CDNS_UART_IMR_OFFSET);
+	cdns_uart_writel(status, CDNS_UART_IDR_OFFSET);
 
 	/* Disable the TX and RX */
-	xuartps_writel(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS,
-				 XUARTPS_CR_OFFSET);
+	cdns_uart_writel(CDNS_UART_CR_TX_DIS | CDNS_UART_CR_RX_DIS,
+				 CDNS_UART_CR_OFFSET);
 	free_irq(port->irq, port);
 }
 
 /**
- * xuartps_type - Set UART type to xuartps port
+ * cdns_uart_type - Set UART type to cdns_uart port
  * @port: Handle to the uart port structure
  *
  * Return: string on success, NULL otherwise
  */
-static const char *xuartps_type(struct uart_port *port)
+static const char *cdns_uart_type(struct uart_port *port)
 {
-	return port->type == PORT_XUARTPS ? XUARTPS_NAME : NULL;
+	return port->type == PORT_XUARTPS ? CDNS_UART_NAME : NULL;
 }
 
 /**
- * xuartps_verify_port - Verify the port params
+ * cdns_uart_verify_port - Verify the port params
  * @port: Handle to the uart port structure
  * @ser: Handle to the structure whose members are compared
  *
  * Return: 0 on success, negative errno otherwise.
  */
-static int xuartps_verify_port(struct uart_port *port,
+static int cdns_uart_verify_port(struct uart_port *port,
 					struct serial_struct *ser)
 {
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_XUARTPS)
@@ -849,167 +853,167 @@ static int xuartps_verify_port(struct uart_port *port,
 }
 
 /**
- * xuartps_request_port - Claim the memory region attached to xuartps port,
- *				called when the driver adds a xuartps port via
+ * cdns_uart_request_port - Claim the memory region attached to cdns_uart port,
+ *				called when the driver adds a cdns_uart port via
  *				uart_add_one_port()
  * @port: Handle to the uart port structure
  *
  * Return: 0 on success, negative errno otherwise.
  */
-static int xuartps_request_port(struct uart_port *port)
+static int cdns_uart_request_port(struct uart_port *port)
 {
-	if (!request_mem_region(port->mapbase, XUARTPS_REGISTER_SPACE,
-					 XUARTPS_NAME)) {
+	if (!request_mem_region(port->mapbase, CDNS_UART_REGISTER_SPACE,
+					 CDNS_UART_NAME)) {
 		return -ENOMEM;
 	}
 
-	port->membase = ioremap(port->mapbase, XUARTPS_REGISTER_SPACE);
+	port->membase = ioremap(port->mapbase, CDNS_UART_REGISTER_SPACE);
 	if (!port->membase) {
 		dev_err(port->dev, "Unable to map registers\n");
-		release_mem_region(port->mapbase, XUARTPS_REGISTER_SPACE);
+		release_mem_region(port->mapbase, CDNS_UART_REGISTER_SPACE);
 		return -ENOMEM;
 	}
 	return 0;
 }
 
 /**
- * xuartps_release_port - Release UART port
+ * cdns_uart_release_port - Release UART port
  * @port: Handle to the uart port structure
  *
- * Release the memory region attached to a xuartps port. Called when the
- * driver removes a xuartps port via uart_remove_one_port().
+ * Release the memory region attached to a cdns_uart port. Called when the
+ * driver removes a cdns_uart port via uart_remove_one_port().
  */
-static void xuartps_release_port(struct uart_port *port)
+static void cdns_uart_release_port(struct uart_port *port)
 {
-	release_mem_region(port->mapbase, XUARTPS_REGISTER_SPACE);
+	release_mem_region(port->mapbase, CDNS_UART_REGISTER_SPACE);
 	iounmap(port->membase);
 	port->membase = NULL;
 }
 
 /**
- * xuartps_config_port - Configure UART port
+ * cdns_uart_config_port - Configure UART port
  * @port: Handle to the uart port structure
  * @flags: If any
  */
-static void xuartps_config_port(struct uart_port *port, int flags)
+static void cdns_uart_config_port(struct uart_port *port, int flags)
 {
-	if (flags & UART_CONFIG_TYPE && xuartps_request_port(port) == 0)
+	if (flags & UART_CONFIG_TYPE && cdns_uart_request_port(port) == 0)
 		port->type = PORT_XUARTPS;
 }
 
 /**
- * xuartps_get_mctrl - Get the modem control state
+ * cdns_uart_get_mctrl - Get the modem control state
  * @port: Handle to the uart port structure
  *
  * Return: The modem control state
  */
-static unsigned int xuartps_get_mctrl(struct uart_port *port)
+static unsigned int cdns_uart_get_mctrl(struct uart_port *port)
 {
 	return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
 }
 
-static void xuartps_set_mctrl(struct uart_port *port, unsigned int mctrl)
+static void cdns_uart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	/* N/A */
 }
 
-static void xuartps_enable_ms(struct uart_port *port)
+static void cdns_uart_enable_ms(struct uart_port *port)
 {
 	/* N/A */
 }
 
 #ifdef CONFIG_CONSOLE_POLL
-static int xuartps_poll_get_char(struct uart_port *port)
+static int cdns_uart_poll_get_char(struct uart_port *port)
 {
 	u32 imr;
 	int c;
 
 	/* Disable all interrupts */
-	imr = xuartps_readl(XUARTPS_IMR_OFFSET);
-	xuartps_writel(imr, XUARTPS_IDR_OFFSET);
+	imr = cdns_uart_readl(CDNS_UART_IMR_OFFSET);
+	cdns_uart_writel(imr, CDNS_UART_IDR_OFFSET);
 
 	/* Check if FIFO is empty */
-	if (xuartps_readl(XUARTPS_SR_OFFSET) & XUARTPS_SR_RXEMPTY)
+	if (cdns_uart_readl(CDNS_UART_SR_OFFSET) & CDNS_UART_SR_RXEMPTY)
 		c = NO_POLL_CHAR;
 	else /* Read a character */
-		c = (unsigned char) xuartps_readl(XUARTPS_FIFO_OFFSET);
+		c = (unsigned char) cdns_uart_readl(CDNS_UART_FIFO_OFFSET);
 
 	/* Enable interrupts */
-	xuartps_writel(imr, XUARTPS_IER_OFFSET);
+	cdns_uart_writel(imr, CDNS_UART_IER_OFFSET);
 
 	return c;
 }
 
-static void xuartps_poll_put_char(struct uart_port *port, unsigned char c)
+static void cdns_uart_poll_put_char(struct uart_port *port, unsigned char c)
 {
 	u32 imr;
 
 	/* Disable all interrupts */
-	imr = xuartps_readl(XUARTPS_IMR_OFFSET);
-	xuartps_writel(imr, XUARTPS_IDR_OFFSET);
+	imr = cdns_uart_readl(CDNS_UART_IMR_OFFSET);
+	cdns_uart_writel(imr, CDNS_UART_IDR_OFFSET);
 
 	/* Wait until FIFO is empty */
-	while (!(xuartps_readl(XUARTPS_SR_OFFSET) & XUARTPS_SR_TXEMPTY))
+	while (!(cdns_uart_readl(CDNS_UART_SR_OFFSET) & CDNS_UART_SR_TXEMPTY))
 		cpu_relax();
 
 	/* Write a character */
-	xuartps_writel(c, XUARTPS_FIFO_OFFSET);
+	cdns_uart_writel(c, CDNS_UART_FIFO_OFFSET);
 
 	/* Wait until FIFO is empty */
-	while (!(xuartps_readl(XUARTPS_SR_OFFSET) & XUARTPS_SR_TXEMPTY))
+	while (!(cdns_uart_readl(CDNS_UART_SR_OFFSET) & CDNS_UART_SR_TXEMPTY))
 		cpu_relax();
 
 	/* Enable interrupts */
-	xuartps_writel(imr, XUARTPS_IER_OFFSET);
+	cdns_uart_writel(imr, CDNS_UART_IER_OFFSET);
 
 	return;
 }
 #endif
 
-static struct uart_ops xuartps_ops = {
-	.set_mctrl	= xuartps_set_mctrl,
-	.get_mctrl	= xuartps_get_mctrl,
-	.enable_ms	= xuartps_enable_ms,
-	.start_tx	= xuartps_start_tx,
-	.stop_tx	= xuartps_stop_tx,
-	.stop_rx	= xuartps_stop_rx,
-	.tx_empty	= xuartps_tx_empty,
-	.break_ctl	= xuartps_break_ctl,
-	.set_termios	= xuartps_set_termios,
-	.startup	= xuartps_startup,
-	.shutdown	= xuartps_shutdown,
-	.type		= xuartps_type,
-	.verify_port	= xuartps_verify_port,
-	.request_port	= xuartps_request_port,
-	.release_port	= xuartps_release_port,
-	.config_port	= xuartps_config_port,
+static struct uart_ops cdns_uart_ops = {
+	.set_mctrl	= cdns_uart_set_mctrl,
+	.get_mctrl	= cdns_uart_get_mctrl,
+	.enable_ms	= cdns_uart_enable_ms,
+	.start_tx	= cdns_uart_start_tx,
+	.stop_tx	= cdns_uart_stop_tx,
+	.stop_rx	= cdns_uart_stop_rx,
+	.tx_empty	= cdns_uart_tx_empty,
+	.break_ctl	= cdns_uart_break_ctl,
+	.set_termios	= cdns_uart_set_termios,
+	.startup	= cdns_uart_startup,
+	.shutdown	= cdns_uart_shutdown,
+	.type		= cdns_uart_type,
+	.verify_port	= cdns_uart_verify_port,
+	.request_port	= cdns_uart_request_port,
+	.release_port	= cdns_uart_release_port,
+	.config_port	= cdns_uart_config_port,
 #ifdef CONFIG_CONSOLE_POLL
-	.poll_get_char	= xuartps_poll_get_char,
-	.poll_put_char	= xuartps_poll_put_char,
+	.poll_get_char	= cdns_uart_poll_get_char,
+	.poll_put_char	= cdns_uart_poll_put_char,
 #endif
 };
 
-static struct uart_port xuartps_port[2];
+static struct uart_port cdns_uart_port[2];
 
 /**
- * xuartps_get_port - Configure the port from the platform device resource info
+ * cdns_uart_get_port - Configure the port from platform device resource info
  *
  * Return: Pointer to a uart_port or NULL for failure
  */
-static struct uart_port *xuartps_get_port(void)
+static struct uart_port *cdns_uart_get_port(void)
 {
 	struct uart_port *port;
 	int id;
 
 	/* Find the next unused port */
-	for (id = 0; id < XUARTPS_NR_PORTS; id++)
-		if (xuartps_port[id].mapbase == 0)
+	for (id = 0; id < CDNS_UART_NR_PORTS; id++)
+		if (cdns_uart_port[id].mapbase == 0)
 			break;
 
-	if (id >= XUARTPS_NR_PORTS)
+	if (id >= CDNS_UART_NR_PORTS)
 		return NULL;
 
-	port = &xuartps_port[id];
+	port = &cdns_uart_port[id];
 
 	/* At this point, we've got an empty uart_port struct, initialize it */
 	spin_lock_init(&port->lock);
@@ -1019,8 +1023,8 @@ static struct uart_port *xuartps_get_port(void)
 	port->type	= PORT_UNKNOWN;
 	port->iotype	= UPIO_MEM32;
 	port->flags	= UPF_BOOT_AUTOCONF;
-	port->ops	= &xuartps_ops;
-	port->fifosize	= XUARTPS_FIFO_SIZE;
+	port->ops	= &cdns_uart_ops;
+	port->fifosize	= CDNS_UART_FIFO_SIZE;
 	port->line	= id;
 	port->dev	= NULL;
 	return port;
@@ -1028,37 +1032,37 @@ static struct uart_port *xuartps_get_port(void)
 
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 /**
- * xuartps_console_wait_tx - Wait for the TX to be full
+ * cdns_uart_console_wait_tx - Wait for the TX to be full
  * @port: Handle to the uart port structure
  */
-static void xuartps_console_wait_tx(struct uart_port *port)
+static void cdns_uart_console_wait_tx(struct uart_port *port)
 {
-	while ((xuartps_readl(XUARTPS_SR_OFFSET) & XUARTPS_SR_TXEMPTY)
-				!= XUARTPS_SR_TXEMPTY)
+	while ((cdns_uart_readl(CDNS_UART_SR_OFFSET) & CDNS_UART_SR_TXEMPTY)
+				!= CDNS_UART_SR_TXEMPTY)
 		barrier();
 }
 
 /**
- * xuartps_console_putchar - write the character to the FIFO buffer
+ * cdns_uart_console_putchar - write the character to the FIFO buffer
  * @port: Handle to the uart port structure
  * @ch: Character to be written
  */
-static void xuartps_console_putchar(struct uart_port *port, int ch)
+static void cdns_uart_console_putchar(struct uart_port *port, int ch)
 {
-	xuartps_console_wait_tx(port);
-	xuartps_writel(ch, XUARTPS_FIFO_OFFSET);
+	cdns_uart_console_wait_tx(port);
+	cdns_uart_writel(ch, CDNS_UART_FIFO_OFFSET);
 }
 
 /**
- * xuartps_console_write - perform write operation
+ * cdns_uart_console_write - perform write operation
  * @co: Handle to the console
  * @s: Pointer to character array
  * @count: No of characters
  */
-static void xuartps_console_write(struct console *co, const char *s,
+static void cdns_uart_console_write(struct console *co, const char *s,
 				unsigned int count)
 {
-	struct uart_port *port = &xuartps_port[co->index];
+	struct uart_port *port = &cdns_uart_port[co->index];
 	unsigned long flags;
 	unsigned int imr, ctrl;
 	int locked = 1;
@@ -1069,45 +1073,45 @@ static void xuartps_console_write(struct console *co, const char *s,
 		spin_lock_irqsave(&port->lock, flags);
 
 	/* save and disable interrupt */
-	imr = xuartps_readl(XUARTPS_IMR_OFFSET);
-	xuartps_writel(imr, XUARTPS_IDR_OFFSET);
+	imr = cdns_uart_readl(CDNS_UART_IMR_OFFSET);
+	cdns_uart_writel(imr, CDNS_UART_IDR_OFFSET);
 
 	/*
 	 * Make sure that the tx part is enabled. Set the TX enable bit and
 	 * clear the TX disable bit to enable the transmitter.
 	 */
-	ctrl = xuartps_readl(XUARTPS_CR_OFFSET);
-	xuartps_writel((ctrl & ~XUARTPS_CR_TX_DIS) | XUARTPS_CR_TX_EN,
-		XUARTPS_CR_OFFSET);
+	ctrl = cdns_uart_readl(CDNS_UART_CR_OFFSET);
+	cdns_uart_writel((ctrl & ~CDNS_UART_CR_TX_DIS) | CDNS_UART_CR_TX_EN,
+		CDNS_UART_CR_OFFSET);
 
-	uart_console_write(port, s, count, xuartps_console_putchar);
-	xuartps_console_wait_tx(port);
+	uart_console_write(port, s, count, cdns_uart_console_putchar);
+	cdns_uart_console_wait_tx(port);
 
-	xuartps_writel(ctrl, XUARTPS_CR_OFFSET);
+	cdns_uart_writel(ctrl, CDNS_UART_CR_OFFSET);
 
 	/* restore interrupt state */
-	xuartps_writel(imr, XUARTPS_IER_OFFSET);
+	cdns_uart_writel(imr, CDNS_UART_IER_OFFSET);
 
 	if (locked)
 		spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /**
- * xuartps_console_setup - Initialize the uart to default config
+ * cdns_uart_console_setup - Initialize the uart to default config
  * @co: Console handle
  * @options: Initial settings of uart
  *
  * Return: 0 on success, negative errno otherwise.
  */
-static int __init xuartps_console_setup(struct console *co, char *options)
+static int __init cdns_uart_console_setup(struct console *co, char *options)
 {
-	struct uart_port *port = &xuartps_port[co->index];
+	struct uart_port *port = &cdns_uart_port[co->index];
 	int baud = 9600;
 	int bits = 8;
 	int parity = 'n';
 	int flow = 'n';
 
-	if (co->index < 0 || co->index >= XUARTPS_NR_PORTS)
+	if (co->index < 0 || co->index >= CDNS_UART_NR_PORTS)
 		return -EINVAL;
 
 	if (!port->mapbase) {
@@ -1121,53 +1125,53 @@ static int __init xuartps_console_setup(struct console *co, char *options)
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
 
-static struct uart_driver xuartps_uart_driver;
+static struct uart_driver cdns_uart_uart_driver;
 
-static struct console xuartps_console = {
-	.name	= XUARTPS_TTY_NAME,
-	.write	= xuartps_console_write,
+static struct console cdns_uart_console = {
+	.name	= CDNS_UART_TTY_NAME,
+	.write	= cdns_uart_console_write,
 	.device	= uart_console_device,
-	.setup	= xuartps_console_setup,
+	.setup	= cdns_uart_console_setup,
 	.flags	= CON_PRINTBUFFER,
 	.index	= -1, /* Specified on the cmdline (e.g. console=ttyPS ) */
-	.data	= &xuartps_uart_driver,
+	.data	= &cdns_uart_uart_driver,
 };
 
 /**
- * xuartps_console_init - Initialization call
+ * cdns_uart_console_init - Initialization call
  *
  * Return: 0 on success, negative error otherwise.
  */
-static int __init xuartps_console_init(void)
+static int __init cdns_uart_console_init(void)
 {
-	register_console(&xuartps_console);
+	register_console(&cdns_uart_console);
 	return 0;
 }
 
-console_initcall(xuartps_console_init);
+console_initcall(cdns_uart_console_init);
 
 #endif /* CONFIG_SERIAL_XILINX_PS_UART_CONSOLE */
 
-static struct uart_driver xuartps_uart_driver = {
+static struct uart_driver cdns_uart_uart_driver = {
 	.owner		= THIS_MODULE,
-	.driver_name	= XUARTPS_NAME,
-	.dev_name	= XUARTPS_TTY_NAME,
-	.major		= XUARTPS_MAJOR,
-	.minor		= XUARTPS_MINOR,
-	.nr		= XUARTPS_NR_PORTS,
+	.driver_name	= CDNS_UART_NAME,
+	.dev_name	= CDNS_UART_TTY_NAME,
+	.major		= CDNS_UART_MAJOR,
+	.minor		= CDNS_UART_MINOR,
+	.nr		= CDNS_UART_NR_PORTS,
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
-	.cons		= &xuartps_console,
+	.cons		= &cdns_uart_console,
 #endif
 };
 
 #ifdef CONFIG_PM_SLEEP
 /**
- * xuartps_suspend - suspend event
+ * cdns_uart_suspend - suspend event
  * @device: Pointer to the device structure
  *
  * Return: 0
  */
-static int xuartps_suspend(struct device *device)
+static int cdns_uart_suspend(struct device *device)
 {
 	struct uart_port *port = dev_get_drvdata(device);
 	struct tty_struct *tty;
@@ -1186,23 +1190,24 @@ static int xuartps_suspend(struct device *device)
 	 * Call the API provided in serial_core.c file which handles
 	 * the suspend.
 	 */
-	uart_suspend_port(&xuartps_uart_driver, port);
+	uart_suspend_port(&cdns_uart_uart_driver, port);
 	if (console_suspend_enabled && !may_wake) {
-		struct xuartps *xuartps = port->private_data;
+		struct cdns_uart *cdns_uart = port->private_data;
 
-		clk_disable(xuartps->uartclk);
-		clk_disable(xuartps->pclk);
+		clk_disable(cdns_uart->uartclk);
+		clk_disable(cdns_uart->pclk);
 	} else {
 		unsigned long flags = 0;
 
 		spin_lock_irqsave(&port->lock, flags);
 		/* Empty the receive FIFO 1st before making changes */
-		while (!(xuartps_readl(XUARTPS_SR_OFFSET) & XUARTPS_SR_RXEMPTY))
-			xuartps_readl(XUARTPS_FIFO_OFFSET);
+		while (!(cdns_uart_readl(CDNS_UART_SR_OFFSET) &
+					CDNS_UART_SR_RXEMPTY))
+			cdns_uart_readl(CDNS_UART_FIFO_OFFSET);
 		/* set RX trigger level to 1 */
-		xuartps_writel(1, XUARTPS_RXWM_OFFSET);
+		cdns_uart_writel(1, CDNS_UART_RXWM_OFFSET);
 		/* disable RX timeout interrups */
-		xuartps_writel(XUARTPS_IXR_TOUT, XUARTPS_IDR_OFFSET);
+		cdns_uart_writel(CDNS_UART_IXR_TOUT, CDNS_UART_IDR_OFFSET);
 		spin_unlock_irqrestore(&port->lock, flags);
 	}
 
@@ -1210,12 +1215,12 @@ static int xuartps_suspend(struct device *device)
 }
 
 /**
- * xuartps_resume - Resume after a previous suspend
+ * cdns_uart_resume - Resume after a previous suspend
  * @device: Pointer to the device structure
  *
  * Return: 0
  */
-static int xuartps_resume(struct device *device)
+static int cdns_uart_resume(struct device *device)
 {
 	struct uart_port *port = dev_get_drvdata(device);
 	unsigned long flags = 0;
@@ -1233,91 +1238,92 @@ static int xuartps_resume(struct device *device)
 	}
 
 	if (console_suspend_enabled && !may_wake) {
-		struct xuartps *xuartps = port->private_data;
+		struct cdns_uart *cdns_uart = port->private_data;
 
-		clk_enable(xuartps->pclk);
-		clk_enable(xuartps->uartclk);
+		clk_enable(cdns_uart->pclk);
+		clk_enable(cdns_uart->uartclk);
 
 		spin_lock_irqsave(&port->lock, flags);
 
 		/* Set TX/RX Reset */
-		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
-		ctrl_reg |= XUARTPS_CR_TXRST | XUARTPS_CR_RXRST;
-		xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
-		while (xuartps_readl(XUARTPS_CR_OFFSET) &
-				(XUARTPS_CR_TXRST | XUARTPS_CR_RXRST))
+		ctrl_reg = cdns_uart_readl(CDNS_UART_CR_OFFSET);
+		ctrl_reg |= CDNS_UART_CR_TXRST | CDNS_UART_CR_RXRST;
+		cdns_uart_writel(ctrl_reg, CDNS_UART_CR_OFFSET);
+		while (cdns_uart_readl(CDNS_UART_CR_OFFSET) &
+				(CDNS_UART_CR_TXRST | CDNS_UART_CR_RXRST))
 			cpu_relax();
 
 		/* restore rx timeout value */
-		xuartps_writel(rx_timeout, XUARTPS_RXTOUT_OFFSET);
+		cdns_uart_writel(rx_timeout, CDNS_UART_RXTOUT_OFFSET);
 		/* Enable Tx/Rx */
-		ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
-		ctrl_reg &= ~(XUARTPS_CR_TX_DIS | XUARTPS_CR_RX_DIS);
-		ctrl_reg |= XUARTPS_CR_TX_EN | XUARTPS_CR_RX_EN;
-		xuartps_writel(ctrl_reg, XUARTPS_CR_OFFSET);
+		ctrl_reg = cdns_uart_readl(CDNS_UART_CR_OFFSET);
+		ctrl_reg &= ~(CDNS_UART_CR_TX_DIS | CDNS_UART_CR_RX_DIS);
+		ctrl_reg |= CDNS_UART_CR_TX_EN | CDNS_UART_CR_RX_EN;
+		cdns_uart_writel(ctrl_reg, CDNS_UART_CR_OFFSET);
 
 		spin_unlock_irqrestore(&port->lock, flags);
 	} else {
 		spin_lock_irqsave(&port->lock, flags);
 		/* restore original rx trigger level */
-		xuartps_writel(rx_trigger_level, XUARTPS_RXWM_OFFSET);
+		cdns_uart_writel(rx_trigger_level, CDNS_UART_RXWM_OFFSET);
 		/* enable RX timeout interrupt */
-		xuartps_writel(XUARTPS_IXR_TOUT, XUARTPS_IER_OFFSET);
+		cdns_uart_writel(CDNS_UART_IXR_TOUT, CDNS_UART_IER_OFFSET);
 		spin_unlock_irqrestore(&port->lock, flags);
 	}
 
-	return uart_resume_port(&xuartps_uart_driver, port);
+	return uart_resume_port(&cdns_uart_uart_driver, port);
 }
 #endif /* ! CONFIG_PM_SLEEP */
 
-static SIMPLE_DEV_PM_OPS(xuartps_dev_pm_ops, xuartps_suspend, xuartps_resume);
+static SIMPLE_DEV_PM_OPS(cdns_uart_dev_pm_ops, cdns_uart_suspend,
+		cdns_uart_resume);
 
 /**
- * xuartps_probe - Platform driver probe
+ * cdns_uart_probe - Platform driver probe
  * @pdev: Pointer to the platform device structure
  *
  * Return: 0 on success, negative error otherwise.
  */
-static int xuartps_probe(struct platform_device *pdev)
+static int cdns_uart_probe(struct platform_device *pdev)
 {
 	int rc;
 	struct uart_port *port;
 	struct resource *res, *res2;
-	struct xuartps *xuartps_data;
+	struct cdns_uart *cdns_uart_data;
 
-	xuartps_data = devm_kzalloc(&pdev->dev, sizeof(*xuartps_data),
+	cdns_uart_data = devm_kzalloc(&pdev->dev, sizeof(*cdns_uart_data),
 			GFP_KERNEL);
-	if (!xuartps_data)
+	if (!cdns_uart_data)
 		return -ENOMEM;
 
-	xuartps_data->pclk = devm_clk_get(&pdev->dev, "pclk");
-	if (IS_ERR(xuartps_data->pclk)) {
-		xuartps_data->pclk = devm_clk_get(&pdev->dev, "aper_clk");
-		if (!IS_ERR(xuartps_data->pclk))
+	cdns_uart_data->pclk = devm_clk_get(&pdev->dev, "pclk");
+	if (IS_ERR(cdns_uart_data->pclk)) {
+		cdns_uart_data->pclk = devm_clk_get(&pdev->dev, "aper_clk");
+		if (!IS_ERR(cdns_uart_data->pclk))
 			dev_err(&pdev->dev, "clock name 'aper_clk' is deprecated.\n");
 	}
-	if (IS_ERR(xuartps_data->pclk)) {
+	if (IS_ERR(cdns_uart_data->pclk)) {
 		dev_err(&pdev->dev, "pclk clock not found.\n");
-		return PTR_ERR(xuartps_data->pclk);
+		return PTR_ERR(cdns_uart_data->pclk);
 	}
 
-	xuartps_data->uartclk = devm_clk_get(&pdev->dev, "uart_clk");
-	if (IS_ERR(xuartps_data->uartclk)) {
-		xuartps_data->uartclk = devm_clk_get(&pdev->dev, "ref_clk");
-		if (!IS_ERR(xuartps_data->uartclk))
+	cdns_uart_data->uartclk = devm_clk_get(&pdev->dev, "uart_clk");
+	if (IS_ERR(cdns_uart_data->uartclk)) {
+		cdns_uart_data->uartclk = devm_clk_get(&pdev->dev, "ref_clk");
+		if (!IS_ERR(cdns_uart_data->uartclk))
 			dev_err(&pdev->dev, "clock name 'ref_clk' is deprecated.\n");
 	}
-	if (IS_ERR(xuartps_data->uartclk)) {
+	if (IS_ERR(cdns_uart_data->uartclk)) {
 		dev_err(&pdev->dev, "uart_clk clock not found.\n");
-		return PTR_ERR(xuartps_data->uartclk);
+		return PTR_ERR(cdns_uart_data->uartclk);
 	}
 
-	rc = clk_prepare_enable(xuartps_data->pclk);
+	rc = clk_prepare_enable(cdns_uart_data->pclk);
 	if (rc) {
 		dev_err(&pdev->dev, "Unable to enable pclk clock.\n");
 		return rc;
 	}
-	rc = clk_prepare_enable(xuartps_data->uartclk);
+	rc = clk_prepare_enable(cdns_uart_data->uartclk);
 	if (rc) {
 		dev_err(&pdev->dev, "Unable to enable device clock.\n");
 		goto err_out_clk_dis_pclk;
@@ -1336,15 +1342,15 @@ static int xuartps_probe(struct platform_device *pdev)
 	}
 
 #ifdef CONFIG_COMMON_CLK
-	xuartps_data->clk_rate_change_nb.notifier_call =
-			xuartps_clk_notifier_cb;
-	if (clk_notifier_register(xuartps_data->uartclk,
-				&xuartps_data->clk_rate_change_nb))
+	cdns_uart_data->clk_rate_change_nb.notifier_call =
+			cdns_uart_clk_notifier_cb;
+	if (clk_notifier_register(cdns_uart_data->uartclk,
+				&cdns_uart_data->clk_rate_change_nb))
 		dev_warn(&pdev->dev, "Unable to register clock notifier.\n");
 #endif
 
 	/* Initialize the port structure */
-	port = xuartps_get_port();
+	port = cdns_uart_get_port();
 
 	if (!port) {
 		dev_err(&pdev->dev, "Cannot get uart_port structure\n");
@@ -1358,11 +1364,11 @@ static int xuartps_probe(struct platform_device *pdev)
 		port->mapbase = res->start;
 		port->irq = res2->start;
 		port->dev = &pdev->dev;
-		port->uartclk = clk_get_rate(xuartps_data->uartclk);
-		port->private_data = xuartps_data;
-		xuartps_data->port = port;
+		port->uartclk = clk_get_rate(cdns_uart_data->uartclk);
+		port->private_data = cdns_uart_data;
+		cdns_uart_data->port = port;
 		platform_set_drvdata(pdev, port);
-		rc = uart_add_one_port(&xuartps_uart_driver, port);
+		rc = uart_add_one_port(&cdns_uart_uart_driver, port);
 		if (rc) {
 			dev_err(&pdev->dev,
 				"uart_add_one_port() failed; err=%i\n", rc);
@@ -1373,88 +1379,88 @@ static int xuartps_probe(struct platform_device *pdev)
 
 err_out_notif_unreg:
 #ifdef CONFIG_COMMON_CLK
-	clk_notifier_unregister(xuartps_data->uartclk,
-			&xuartps_data->clk_rate_change_nb);
+	clk_notifier_unregister(cdns_uart_data->uartclk,
+			&cdns_uart_data->clk_rate_change_nb);
 #endif
 err_out_clk_disable:
-	clk_disable_unprepare(xuartps_data->uartclk);
+	clk_disable_unprepare(cdns_uart_data->uartclk);
 err_out_clk_dis_pclk:
-	clk_disable_unprepare(xuartps_data->pclk);
+	clk_disable_unprepare(cdns_uart_data->pclk);
 
 	return rc;
 }
 
 /**
- * xuartps_remove - called when the platform driver is unregistered
+ * cdns_uart_remove - called when the platform driver is unregistered
  * @pdev: Pointer to the platform device structure
  *
  * Return: 0 on success, negative error otherwise.
  */
-static int xuartps_remove(struct platform_device *pdev)
+static int cdns_uart_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct xuartps *xuartps_data = port->private_data;
+	struct cdns_uart *cdns_uart_data = port->private_data;
 	int rc;
 
-	/* Remove the xuartps port from the serial core */
+	/* Remove the cdns_uart port from the serial core */
 #ifdef CONFIG_COMMON_CLK
-	clk_notifier_unregister(xuartps_data->uartclk,
-			&xuartps_data->clk_rate_change_nb);
+	clk_notifier_unregister(cdns_uart_data->uartclk,
+			&cdns_uart_data->clk_rate_change_nb);
 #endif
-	rc = uart_remove_one_port(&xuartps_uart_driver, port);
+	rc = uart_remove_one_port(&cdns_uart_uart_driver, port);
 	port->mapbase = 0;
-	clk_disable_unprepare(xuartps_data->uartclk);
-	clk_disable_unprepare(xuartps_data->pclk);
+	clk_disable_unprepare(cdns_uart_data->uartclk);
+	clk_disable_unprepare(cdns_uart_data->pclk);
 	return rc;
 }
 
 /* Match table for of_platform binding */
-static struct of_device_id xuartps_of_match[] = {
-	{ .compatible = "xlnx,xuartps", },
+static struct of_device_id cdns_uart_of_match[] = {
+	{ .compatible = "xlnx,cdns_uart", },
 	{ .compatible = "cdns,uart-r1p8", },
 	{}
 };
-MODULE_DEVICE_TABLE(of, xuartps_of_match);
+MODULE_DEVICE_TABLE(of, cdns_uart_of_match);
 
-static struct platform_driver xuartps_platform_driver = {
-	.probe   = xuartps_probe,
-	.remove  = xuartps_remove,
+static struct platform_driver cdns_uart_platform_driver = {
+	.probe   = cdns_uart_probe,
+	.remove  = cdns_uart_remove,
 	.driver  = {
 		.owner = THIS_MODULE,
-		.name = XUARTPS_NAME,
-		.of_match_table = xuartps_of_match,
-		.pm = &xuartps_dev_pm_ops,
+		.name = CDNS_UART_NAME,
+		.of_match_table = cdns_uart_of_match,
+		.pm = &cdns_uart_dev_pm_ops,
 		},
 };
 
-static int __init xuartps_init(void)
+static int __init cdns_uart_init(void)
 {
 	int retval = 0;
 
-	/* Register the xuartps driver with the serial core */
-	retval = uart_register_driver(&xuartps_uart_driver);
+	/* Register the cdns_uart driver with the serial core */
+	retval = uart_register_driver(&cdns_uart_uart_driver);
 	if (retval)
 		return retval;
 
 	/* Register the platform driver */
-	retval = platform_driver_register(&xuartps_platform_driver);
+	retval = platform_driver_register(&cdns_uart_platform_driver);
 	if (retval)
-		uart_unregister_driver(&xuartps_uart_driver);
+		uart_unregister_driver(&cdns_uart_uart_driver);
 
 	return retval;
 }
 
-static void __exit xuartps_exit(void)
+static void __exit cdns_uart_exit(void)
 {
 	/* Unregister the platform driver */
-	platform_driver_unregister(&xuartps_platform_driver);
+	platform_driver_unregister(&cdns_uart_platform_driver);
 
-	/* Unregister the xuartps driver */
-	uart_unregister_driver(&xuartps_uart_driver);
+	/* Unregister the cdns_uart driver */
+	uart_unregister_driver(&cdns_uart_uart_driver);
 }
 
-module_init(xuartps_init);
-module_exit(xuartps_exit);
+module_init(cdns_uart_init);
+module_exit(cdns_uart_exit);
 
 MODULE_DESCRIPTION("Driver for Cadence UART");
 MODULE_AUTHOR("Xilinx Inc.");
-- 
1.9.0.1.g4196000

