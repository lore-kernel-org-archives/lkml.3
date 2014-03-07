Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaCGG0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:26:52 -0500
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:46389 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750830AbaCGG0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:26:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:69:152:327:355:379:421:541:599:960:966:968:973:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2538:2559:2562:2693:2729:2737:2895:2904:2911:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4225:4250:4321:4385:4425:4605:5007:6238:7576:7652:7875:7903:8603:8957:9121:9592:10004:10848:11026:11232:11233:11914:12043:12291:12294:12296:12438:12517:12519:12555:12663:12679:12683:12740:13137:13150:13230:13231:13894:13972:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: frog35_5876c7a9df52c
X-Filterd-Recvd-Size: 33220
Message-ID: <1394173606.16156.51.camel@joe-AO722>
Subject: Re: [PATCH] RFC: WIP: sc16is7xx.c
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: jon@ringle.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jon Ringle <jringle@gridpoint.com>
Date: Thu, 06 Mar 2014 22:26:46 -0800
In-Reply-To: <20140307055231.GA32019@kroah.com>
References: <1394159746-1729-1-git-send-email-jon@ringle.org>
	 <20140307055231.GA32019@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 21:52 -0800, Greg KH wrote:
> On Thu, Mar 06, 2014 at 09:35:46PM -0500, jon@ringle.org wrote:
> > From: Jon Ringle <jringle@gridpoint.com>
> > 
> > I am requesting comments on this serial driver.
> > I am currently having some latency issues with it where I experience
> > packet loss at speed of 19200.
> > 
> > I welcome any and all comments.
> 
> The basic coding style problems make it hard to read to be able to help
> review it, sorry.
> 
> Yes, brains have patterns, you want to follow the same patterns as
> others, it matters.

Here's a patternizing patch on top of this...

It's an extended version of what I sent Jon privately.

Mostly whitespace but some other neatening too.
Brace removals, tabifying, 80 column comments,
spelling typos, pr_<level>, c90 comments, etc.

I don't care that's it does a lot of things in
a single patch because this hasn't ever been
submitted before and I hope Jon rolls it into
his next submission.

---
 drivers/tty/serial/sc16is7xx.c | 485 +++++++++++++++++++++--------------------
 1 file changed, 253 insertions(+), 232 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 5daed84..045241e 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1,28 +1,34 @@
 /*
- * The SC16IS740/750/760 is a slave I2C-bus/SPI interface to a single-channel high
- * performance UART. The SC16IS740/750/760’s internal register set is backward-compatible
- * with the widely used and widely popular 16C450. The SC16IS740/750/760 also provides
- * additional advanced features such as auto hardware and software flow control, automatic
- * RS-485 support, and software reset.
- *
- * Copyright (C) 2014 GridPoint
+ * SC16IS740/750/760 tty serial driver - Copyright (C) 2014 GridPoint
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
+ * The SC16IS740/750/760 is a slave I2C-bus/SPI interface to a single-channel
+ * high performance UART. The SC16IS740/750/760’s internal register set is
+ * backward-compatible with the widely used and widely popular 16C450.
+ *
+ * The SC16IS740/750/760 also provides additional advanced features such as
+ * auto hardware and software flow control, automatic RS-485 support, and
+ * software reset.
+ *
  * Notes:
+ *
  * The sc16is740 driver is used for the GPEC RS485 Half duplex communication.
- * In the EC1K board the sc16is740 RTS line is connected to the SN65HVD1780DR chip and which
- * is used to signal the RS485 diretion. When the RTS is low the RS485 direction is set to
- * output from the CPU.
- * To set the RS485 diretion we use the sc16is740 internal RS485 feature where the chip drives
- * the RTS line when the data is written to the TX FIFO (see the spec note for the EFCR[4] bit
- * configuration).
  *
+ * In the EC1K board the sc16is740 RTS line is connected to a SN65HVD1780DR
+ * chip which is used to signal the RS485 direction.
+ * When RTS is low, the RS485 direction is set to output from the CPU.
+ *
+ * To set the RS485 direction we use the sc16is740 internal RS485 feature
+ * where the chip drives the RTS line when the data is written to the TX FIFO
+ * (see the spec note for the EFCR[4] bit configuration).
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/gpio.h>
@@ -39,116 +45,139 @@
 #include <linux/tty_flip.h>
 #include <linux/wait.h>
 
-#define DRV_VERSION 		"0.3"
-#define DRV_NAME            "sc16is7xx"
-#define DEV_NAME            "ttySC"
-#define SC16IS7XX_MAJOR 	204  /* Take place of the /dev/ttySC0 SCI serial port 0 */
-#define SC16IS7XX_MINOR  	8
+#define DRV_VERSION	"0.3"
+#define DRV_NAME	"sc16is7xx"
+#define DEV_NAME	"ttySC"
+
+#define SC16IS7XX_MAJOR	204	/* Take place of the /dev/ttySC0
+				 * SCI serial port 0
+				 */
+#define SC16IS7XX_MINOR	8
 
 /*
  * Software Definitions
  */
 /* Commands sent from the uart callbacks to the work handler */
-#define SC16IS7XX_CMND_STOP_RX       (0) /* Disable the RX interrupt */
-#define SC16IS7XX_CMND_START_TX      (1) /* Enable  the TX holding register empty interrupt */
-#define SC16IS7XX_CMND_STOP_TX       (2) /* Disable the TX holding register empty interrupt */
-#define SC16IS7XX_CMND_NEW_TERMIOS   (3) /* Apply new termios configuration */
-#define SC16IS7XX_CMND_BREAK_CTRL    (4)
-#define SC16IS7XX_CMND_TX_RX         (5)
-
-#define SC16IS7XX_CLEAR_FIFO_ON_TX   /* If defined controller will clear tx fifo before it transmits chars */
+#define SC16IS7XX_CMND_STOP_RX		(0) /* Disable the RX interrupt */
+#define SC16IS7XX_CMND_START_TX		(1) /* Enable  the TX holding register
+					     * empty interrupt
+					     */
+#define SC16IS7XX_CMND_STOP_TX		(2) /* Disable the TX holding register
+					     * empty interrupt
+					     */
+#define SC16IS7XX_CMND_NEW_TERMIOS	(3) /* Apply termios configuration */
+#define SC16IS7XX_CMND_BREAK_CTRL	(4)
+#define SC16IS7XX_CMND_TX_RX		(5)
+
+#define SC16IS7XX_CLEAR_FIFO_ON_TX   /* If defined controller will clear
+				      * tx fifo before it transmits chars
+				      */
 
 /*
  * SC16IS7XX Hardware Definitions
  */
-#define DA850_RS485_INT_PIN  GPIO_TO_PIN(0,4)
+#define DA850_RS485_INT_PIN	GPIO_TO_PIN(0, 4)
 
-#define SC16IS7XX_CLK          		7372800 /* crystal clock connected to the SC16IS7XX chip */
-#define SC16IS7XX_DEFAULT_BAUDRATE     19200
+#define SC16IS7XX_CLK		7372800 /* crystal clock connected
+					 * to the SC16IS7XX chip
+					 */
+#define SC16IS7XX_DEFAULT_BAUDRATE	19200
 
 /* General registers set */
-#define SC16IS7XX_TCR 0x06
-#define SC16IS7XX_TLR 0x07
-#define SC16IS7XX_TXLVL  0x08
-#define SC16IS7XX_RXLVL  0x09
-#define SC16IS7XX_EFCR   0x0F
+#define SC16IS7XX_TCR		0x06
+#define SC16IS7XX_TLR		0x07
+#define SC16IS7XX_TXLVL		0x08
+#define SC16IS7XX_RXLVL		0x09
+#define SC16IS7XX_EFCR		0x0F
 
 /* LCR / MCR configurations */
-#define UART_LCR_8N1	UART_LCR_WLEN8
+#define UART_LCR_8N1		UART_LCR_WLEN8
 
-#define SC16IS7XX_LCRVAL UART_LCR_8N1           /* 8 data, 1 stop, no parity */
-#define SC16IS7XX_MCRVAL (UART_MCR_DTR|UART_MCR_RTS) /* clock divisor = 1,UART mode,lpback disabled,RTS/DTR are set,TCR/TLR disabled */
+#define SC16IS7XX_LCRVAL	UART_LCR_8N1	/* 8 data, 1 stop, no parity */
+#define SC16IS7XX_MCRVAL	(UART_MCR_DTR | UART_MCR_RTS)
+						/* clock divisor = 1,
+						 * UART mode,
+						 * loopback disabled,
+						 * RTS/DTR are set,
+						 * TCR/TLR disabled
+						 */
 
 /* SC16IS7XX Internal register address translation */
-#define REG_TO_I2C_ADDR(reg) (((reg) & 0x0f) << 3)
-
-#define SC16IS7XX_FIFO_SIZE 	  64  /* Rx fifo size */
+#define REG_TO_I2C_ADDR(reg)	(((reg) & 0x0f) << 3)
 
-#define SC16IS7XX_LOAD_SIZE       64  /* Tx fifo size */
+#define SC16IS7XX_FIFO_SIZE	64	/* Rx fifo size */
+#define SC16IS7XX_LOAD_SIZE	64	/* Tx fifo size */
 
 struct uart_sc16is7xx_port {
 	struct uart_port port;
 
 	/* private to the driver */
-	struct i2c_client* client; /* I2C client handle */
+	struct i2c_client *client;	/* I2C client handle */
 
-	int tx_empty;		/* last TX empty bit */
+	int tx_empty;			/* last TX empty bit */
 
-	unsigned long command;  /* Command to the work executed from the workqueue */
+	unsigned long command;		/* Command to the work executed
+					 * from the workqueue
+					 */
 
-	struct ktermios* termios_new;
-	struct ktermios* termios_old;
+	struct ktermios *termios_new;
+	struct ktermios *termios_old;
 
 	int break_state;
 
-	char ier; /* cache Interrupt Enable Register to manage the interrupt from the work */
+	char ier;	/* cache Interrupt Enable Register to
+			 * manage the interrupt from the work
+			 */
 	char lcr;
-	char fcr; /* cache the FIFO control register to hold write only values of that register */
+	char fcr;	/* cache the FIFO control register to
+			 * hold write only values of that register
+			 */
 
 	spinlock_t lock;
 
 	/* set to 1 to make the workhandler exit as soon as possible */
-	int  force_end_work;
+	int force_end_work;
 };
 
-static inline unsigned char sc16is7xx_read_reg(struct uart_sc16is7xx_port* up, unsigned char reg)
+static inline unsigned char sc16is7xx_read_reg(struct uart_sc16is7xx_port *up,
+					       unsigned char reg)
 {
 	int rc;
 	u8 val = 0;
-
 	u8 sc_reg = REG_TO_I2C_ADDR(reg);
 
 	rc = i2c_master_send(up->client, &sc_reg, 1);
-	if(rc < 0)
-	{
-		dev_err(&up->client->dev,"%s I2C error writing the i2c client rc = %d\n",__FUNCTION__, rc);
+	if (rc < 0) {
+		dev_err(&up->client->dev,
+			"%s I2C error writing the i2c client rc = %d\n",
+			__func__, rc);
 		goto out;
 	}
 
 	rc = i2c_master_recv(up->client, &val, 1);
-	if(rc < 0)
-	{
-		dev_err(&up->client->dev,"%s I2C error reading from the i2c client rc = %d\n",__FUNCTION__, rc);
-	}
+	if (rc < 0)
+		dev_err(&up->client->dev,
+			"%s I2C error reading from the i2c client rc = %d\n",
+			__func__, rc);
 
 out:
 	return val;
 }
 
-static inline void sc16is7xx_write_reg(struct uart_sc16is7xx_port *up, unsigned char reg, unsigned char value)
+static inline void sc16is7xx_write_reg(struct uart_sc16is7xx_port *up,
+				       unsigned char reg, unsigned char value)
 {
 	int rc;
-
 	u8 msg[2];
 
 	msg[0] = REG_TO_I2C_ADDR(reg);
 	msg[1] = value;
 
 	rc = i2c_master_send(up->client, msg, 2);
-	if(rc < 0)
-	{
-		dev_err(&up->client->dev,"%s I2C error writing the i2c client rc = %d\n",__FUNCTION__, rc);
-	}
+	if (rc < 0)
+		dev_err(&up->client->dev,
+			"%s I2C error writing the i2c client rc = %d\n",
+			__func__, rc);
 }
 
 static void sc16is7xx_enable_irq(struct uart_sc16is7xx_port *up, int mask)
@@ -163,45 +192,54 @@ static void sc16is7xx_disable_irq(struct uart_sc16is7xx_port *up, int mask)
 	sc16is7xx_write_reg(up, UART_IER, up->ier);
 }
 
-
-static void sc16is7xx_set_baudrate(struct uart_sc16is7xx_port* up, int baudrate)
+static void sc16is7xx_set_baudrate(struct uart_sc16is7xx_port *up, int baudrate)
 {
 	u8 lcr, ier;
 	u32 divisor;
 
 	ier = sc16is7xx_read_reg(up, UART_IER);
 	lcr = sc16is7xx_read_reg(up, UART_LCR);
-	sc16is7xx_write_reg(up, UART_IER, 0x00); // Disable interrupts
 
-	sc16is7xx_write_reg(up, SC16IS7XX_EFCR, 0x06 ); // Disable TX/RX
+	/* Disable interrupts */
+	sc16is7xx_write_reg(up, UART_IER, 0x00);
+
+	/* Disable TX/RX */
+	sc16is7xx_write_reg(up, SC16IS7XX_EFCR, 0x06);
 
-	sc16is7xx_write_reg(up, UART_LCR, UART_LCR_CONF_MODE_B);   // Open the LCR divisors for configuration
+	/* Open the LCR divisors for configuration */
+	sc16is7xx_write_reg(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
-	sc16is7xx_write_reg(up, UART_EFR, 0x10);   // Enable enhanced features and internal clock divider
+	/* Enable enhanced features and internal clock divider */
+	sc16is7xx_write_reg(up, UART_EFR, 0x10);
 
-	sc16is7xx_write_reg(up, UART_MCR, UART_MCR_CLKSEL|4);  // Set the input clock divisor to 1
+	/* Set the input clock divisor to 1 */
+	sc16is7xx_write_reg(up, UART_MCR, UART_MCR_CLKSEL|4);
 
 	/* Get the baudrate divisor from the upper port layer */
 	divisor = uart_get_divisor(&up->port, baudrate);
 
-	sc16is7xx_write_reg(up, UART_DLL, divisor & 0xff );      // Write the new divisor
+	/* Write the new divisor */
+	sc16is7xx_write_reg(up, UART_DLL, divisor & 0xff);
 	sc16is7xx_write_reg(up, UART_DLM, (divisor >> 8) & 0xff);
 
-	sc16is7xx_write_reg(up, UART_LCR, lcr);   // Put LCR back to the normal mode
+	/* Put LCR back to the normal mode */
+	sc16is7xx_write_reg(up, UART_LCR, lcr);
 
 	sc16is7xx_write_reg(up, SC16IS7XX_TLR, 0x0f);
+
+	/* Enable the FIFOs */
 	up->fcr = UART_FCR_ENABLE_FIFO;
-	sc16is7xx_write_reg(up, UART_FCR, up->fcr);   // Enable the FIFOs
+	sc16is7xx_write_reg(up, UART_FCR, up->fcr);
 
-	sc16is7xx_write_reg(up, SC16IS7XX_EFCR, 0x10); // Enable the Rx and Tx and  control the RTS (RS485_DIR) line
+	/* Enable the Rx and Tx and  control the RTS (RS485_DIR) line */
+	sc16is7xx_write_reg(up, SC16IS7XX_EFCR, 0x10);
 
-	sc16is7xx_write_reg(up, UART_IER, ier); // Restore the interrupts configuration
+	/* Restore the interrupts configuration */
+	sc16is7xx_write_reg(up, UART_IER, ier);
 }
 
-/*
- * The function actually delivers the Tx characters to the HW
- */
-static void sc16is7xx_transmit_chars(struct uart_sc16is7xx_port* up)
+/* deliver the Tx characters to the HW */
+static void sc16is7xx_transmit_chars(struct uart_sc16is7xx_port *up)
 {
 	struct circ_buf *xmit = &up->port.state->xmit;
 	int count;
@@ -215,6 +253,7 @@ static void sc16is7xx_transmit_chars(struct uart_sc16is7xx_port* up)
 		up->port.x_char = 0;
 		return;
 	}
+
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&up->port)) {
 		up->ier &= ~UART_IER_THRI;
 		return;
@@ -235,15 +274,13 @@ static void sc16is7xx_transmit_chars(struct uart_sc16is7xx_port* up)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&up->port);
 
-	if (uart_circ_empty(xmit)) {
+	if (uart_circ_empty(xmit))
 		up->ier &= ~UART_IER_THRI;
-	}
 }
 
-/*
- * The function actually receives the characters from the HW and transfers them up to the TTY layer.
- */
-static inline void sc16is7xx_receive_chars(struct uart_sc16is7xx_port *up, int *status)
+/* receives characters from the HW and transfer themto the TTY layer */
+static inline void sc16is7xx_receive_chars(struct uart_sc16is7xx_port *up,
+					   int *status)
 {
 	unsigned int ch, flag;
 	int chars = 0;
@@ -252,15 +289,13 @@ static inline void sc16is7xx_receive_chars(struct uart_sc16is7xx_port *up, int *
 	dev_dbg(&up->client->dev, "%s\n", __func__);
 
 	do {
-		if (likely(*status & UART_LSR_DR)) {
+		if (likely(*status & UART_LSR_DR))
 			ch = sc16is7xx_read_reg(up, UART_RX);
-		} else {
+		else
 			ch = 0xffff;
-		}
 
-		if (*status & up->port.ignore_status_mask) {
+		if (*status & up->port.ignore_status_mask)
 			goto ignore_char;
-		}
 
 		flag = TTY_NORMAL;
 		up->port.icount.rx++;
@@ -273,64 +308,56 @@ static inline void sc16is7xx_receive_chars(struct uart_sc16is7xx_port *up, int *
 				*status &= ~(UART_LSR_FE | UART_LSR_PE);
 				up->port.icount.brk++;
 				/*
-				 * We do the SysRQ and SAK checking
-				 * here because otherwise the break
-				 * may get masked by ignore_status_mask
-				 * or read_status_mask.
+				 * We do the SysRQ and SAK checking here
+				 * because otherwise the break may get masked
+				 * by ignore_status_mask or read_status_mask
 				 */
-				if (uart_handle_break(&up->port)) {
+				if (uart_handle_break(&up->port))
 					goto ignore_char;
-				}
 			} else if (*status & UART_LSR_PE) {
 				up->port.icount.parity++;
 			} else if (*status & UART_LSR_FE) {
 				up->port.icount.frame++;
 			}
-			if (*status & UART_LSR_OE) {
+			if (*status & UART_LSR_OE)
 				up->port.icount.overrun++;
-			}
 
-			/*
-			 * Mask off conditions which should be ignored.
-			 */
+			/* Mask off conditions which should be ignored */
 			*status &= up->port.read_status_mask;
 
-			if (*status & UART_LSR_BI) {
+			if (*status & UART_LSR_BI)
 				flag = TTY_BREAK;
-			} else if (*status & UART_LSR_PE) {
+			else if (*status & UART_LSR_PE)
 				flag = TTY_PARITY;
-			} else if (*status & UART_LSR_FE) {
+			else if (*status & UART_LSR_FE)
 				flag = TTY_FRAME;
-			}
 		}
 
-		if (unlikely(0xffff == ch)) {
+		if (unlikely(0xffff == ch))
 			goto ignore_char;
-		}
 
-		if (uart_handle_sysrq_char(&up->port, ch)) {
+		if (uart_handle_sysrq_char(&up->port, ch))
 			goto ignore_char;
-		}
 
 		uart_insert_char(&up->port, *status, UART_LSR_OE, ch, flag);
 		chars++;
 
 ignore_char:
 		*status = sc16is7xx_read_reg(up, UART_LSR);
-	} while ((*status & (UART_LSR_DR | UART_LSR_BI)) && (max_count-- > 0) && !up->force_end_work);
+	} while ((*status & (UART_LSR_DR | UART_LSR_BI)) &&
+		 (max_count-- > 0) && !up->force_end_work);
 
-	dev_dbg(&up->client->dev, "%s RX:%d chars oe:%d\n", __func__, chars, up->port.icount.overrun);
+	dev_dbg(&up->client->dev, "%s RX:%d chars oe:%d\n",
+		__func__, chars, up->port.icount.overrun);
 
-	if (chars > 0) {
+	if (chars > 0)
 		tty_flip_buffer_push(&(up->port.state->port));
-	}
 }
 
-static void
-sc16is7xx_set_termios_work(struct uart_sc16is7xx_port *up)
+static void sc16is7xx_set_termios_work(struct uart_sc16is7xx_port *up)
 {
-	struct ktermios* termios = up->termios_new;
-	struct ktermios* old = up->termios_old;
+	struct ktermios *termios = up->termios_new;
+	struct ktermios *old = up->termios_old;
 	unsigned long flags;
 	unsigned char cval;
 	unsigned int baud;
@@ -347,8 +374,8 @@ sc16is7xx_set_termios_work(struct uart_sc16is7xx_port *up)
 	case CS7:
 		cval = UART_LCR_WLEN7;
 		break;
-	default:
 	case CS8:
+	default:
 		cval = UART_LCR_WLEN8;
 		break;
 	}
@@ -362,29 +389,22 @@ sc16is7xx_set_termios_work(struct uart_sc16is7xx_port *up)
 
 	sc16is7xx_write_reg(up, UART_LCR, cval);
 
-	/*
-	 * Ask the core to calculate the divisor for us.
-	 */
+	/* Ask the core to calculate the divisor for us */
 	baud = uart_get_baud_rate(&up->port, termios, old, 9600, 115200);
 	sc16is7xx_set_baudrate(up, baud);
 
-	up->port.state->port.low_latency = 1; // Low latency since we Tx from the work queue
+	/* Low latency since we Tx from the work queue */
+	up->port.state->port.low_latency = 1;
 
-	/*
-	 * Update the per-port timeout.
-	 */
+	/* Update the per-port timeout */
 	uart_update_timeout(&up->port, termios->c_cflag, baud);
 
-	/*
-	 * ignore all characters if CREAD is not set
-	 */
+	/* ignore all characters if CREAD is not set */
 	if ((termios->c_cflag & CREAD) == 0)
 		up->port.ignore_status_mask |= UART_LSR_DR;
 
-	if(tty_termios_baud_rate(termios))
-	{
-		tty_termios_encode_baud_rate(termios,baud,baud);
-	}
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, baud, baud);
 
 	spin_unlock_irqrestore(&up->lock, flags);
 }
@@ -395,53 +415,59 @@ static void sc16is7xx_work(struct uart_sc16is7xx_port *up)
 
 	up->ier = sc16is7xx_read_reg(up, UART_IER);
 
-	/* We cannot handle the interrupts while in the work queue so we disable the RX interrupt.
-	 * It is ok because of during the reception of the characters we check the status of the
+	/*
+	 * We cannot handle the interrupts while in the work queue so we
+	 * disable the RX interrupt.  It is ok because of during the
+	 * reception of the characters we check the status of the
 	 * interrupt register and process all incoming packets
 	 */
 	sc16is7xx_write_reg(up, UART_IER, 0x00);
 
-	dev_dbg(&up->client->dev, "%s: start work  command:%04lx ier:0x%02x\n", __func__, up->command, (int)up->ier);
+	dev_dbg(&up->client->dev, "%s: start work - command:%04lx ier:0x%02x\n",
+		__func__, up->command, (int)up->ier);
 
-	if(test_and_clear_bit(SC16IS7XX_CMND_NEW_TERMIOS, &up->command)) {
+	if (test_and_clear_bit(SC16IS7XX_CMND_NEW_TERMIOS, &up->command)) {
 		dev_dbg(&up->client->dev, "CMND_NEW_TERMIOS\n");
 		/* User requested the changes in the Terminal Configurations */
 		sc16is7xx_set_termios_work(up);
 	}
 
-	if(test_and_clear_bit(SC16IS7XX_CMND_BREAK_CTRL, &up->command)) {
-		if (up->break_state == -1) {
+	if (test_and_clear_bit(SC16IS7XX_CMND_BREAK_CTRL, &up->command)) {
+		if (up->break_state == -1)
 			up->lcr |= UART_LCR_SBC;
-		} else {
+		else
 			up->lcr &= ~UART_LCR_SBC;
-		}
 		sc16is7xx_write_reg(up, UART_LCR, up->lcr);
 	}
 
-	if(test_and_clear_bit(SC16IS7XX_CMND_START_TX, &up->command)) {
+	if (test_and_clear_bit(SC16IS7XX_CMND_START_TX, &up->command)) {
 		dev_dbg(&up->client->dev, "CMND_START_TX\n");
 		/* Enable the Tx holding register empty interrupt */
 		up->ier |= UART_IER_THRI;
 
 #ifdef SC16IS7XX_CLEAR_FIFO_ON_TX
 		/* Clear Tx Fifo to remove the junk characters if any */
-		if(up->fcr & UART_FCR_ENABLE_FIFO) {
+		if (up->fcr & UART_FCR_ENABLE_FIFO) {
 			/* Fifo is enabled */
-			sc16is7xx_write_reg(up, UART_FCR, up->fcr & UART_FCR_CLEAR_XMIT);
+			sc16is7xx_write_reg(up, UART_FCR,
+					    up->fcr & UART_FCR_CLEAR_XMIT);
 			dev_dbg(&up->client->dev, "Clear FIFO\n");
 		}
 #endif
 	}
 
-	if(test_and_clear_bit(SC16IS7XX_CMND_STOP_TX, &up->command)) {
+	if (test_and_clear_bit(SC16IS7XX_CMND_STOP_TX, &up->command)) {
 		dev_dbg(&up->client->dev, "CMND_STOP_TX\n");
 		/* Disable the Tx holding register interrupt  */
 		up->ier &= ~UART_IER_THRI;
 	}
 
-	if(test_and_clear_bit(SC16IS7XX_CMND_STOP_RX, &up->command)) {
+	if (test_and_clear_bit(SC16IS7XX_CMND_STOP_RX, &up->command)) {
 		dev_dbg(&up->client->dev, "CMND_STOP_RX\n");
-		/* User requested to stop the RX interrupt so we clear the interrupt enable register */
+		/*
+		 * User requested to stop the RX interrupt so we clear the
+		 * interrupt enable register
+		 */
 		up->ier &= ~UART_IER_RDI;
 	}
 
@@ -449,35 +475,33 @@ static void sc16is7xx_work(struct uart_sc16is7xx_port *up)
 	lsr = sc16is7xx_read_reg(up, UART_LSR);
 	if ((lsr & (UART_LSR_DR | UART_LSR_BI)) && (up->ier & UART_IER_RDI)) {
 		sc16is7xx_receive_chars(up, &lsr);
-		if (lsr & (UART_LSR_DR | UART_LSR_BI)) {
-			/* There is more to receive */
+		/* check if there is more to receive */
+		if (lsr & (UART_LSR_DR | UART_LSR_BI))
 			set_bit(SC16IS7XX_CMND_TX_RX, &up->command);
-		}
 	}
 
-	if ((lsr & UART_LSR_THRE) && (up->ier & UART_IER_THRI)) {
+	if ((lsr & UART_LSR_THRE) && (up->ier & UART_IER_THRI))
 		sc16is7xx_transmit_chars(up);
-	}
 
-	if(sc16is7xx_read_reg(up, UART_LSR) & UART_LSR_THRE)
-	{
-		dev_dbg(&up->client->dev, "%s: TX_EMPTY\n", __FUNCTION__);
+	if (sc16is7xx_read_reg(up, UART_LSR) & UART_LSR_THRE) {
+		dev_dbg(&up->client->dev, "%s: TX_EMPTY\n", __func__);
 		up->tx_empty = TIOCSER_TEMT;
-	}
-	else
-	{
-		dev_dbg(&up->client->dev, "%s: TX_NOT_EMPTY\n", __FUNCTION__);
-		up->tx_empty = 0; /* port is not ready to accept  the new TX characters */
+	} else {
+		/* port is not ready to accept the new TX characters */
+		dev_dbg(&up->client->dev, "%s: TX_NOT_EMPTY\n", __func__);
+		up->tx_empty = 0;
 	}
 
-	dev_dbg(&up->client->dev, "%s: end work ier 0x%02X\n", __func__, (int)up->ier);
+	dev_dbg(&up->client->dev, "%s: end work - ier 0x%02X\n",
+		__func__, (int)up->ier);
 
-	sc16is7xx_write_reg(up, UART_IER, up->ier); /* Restore the interrupts */
+	/* Restore the interrupts */
+	sc16is7xx_write_reg(up, UART_IER, up->ier);
 }
 
-static irqreturn_t sc16is7xx_ist(int irq, void* dev_id)
+static irqreturn_t sc16is7xx_ist(int irq, void *dev_id)
 {
-	struct uart_sc16is7xx_port* up = (struct uart_sc16is7xx_port *)dev_id;
+	struct uart_sc16is7xx_port *up = (struct uart_sc16is7xx_port *)dev_id;
 	unsigned long flags;
 
 	spin_lock_irqsave(&up->lock, flags);
@@ -491,18 +515,25 @@ static unsigned int sc16is7xx_tx_empty(struct uart_port *port)
 {
 	struct uart_sc16is7xx_port *up = (struct uart_sc16is7xx_port *)port;
 
-	dev_dbg(&up->client->dev, "%s:(%d)\n", __FUNCTION__, up->tx_empty);
+	dev_dbg(&up->client->dev, "%s:(%d)\n", __func__, up->tx_empty);
+
 	return up->tx_empty;
 }
 
 static void sc16is7xx_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	/* Just a placeholder. We do not have modem control lines in our RS485 port */
+	/*
+	 * Just a placeholder
+	 * We do not have modem control lines in our RS485 port
+	 */
 }
 
 static unsigned int sc16is7xx_get_mctrl(struct uart_port *port)
 {
-	/* Just a placeholder. We do not have modem control lines in our RS485 port */
+	/*
+	 * Just a placeholder
+	 * We do not have modem control lines in our RS485 port
+	 */
 	return TIOCM_CAR | TIOCM_RNG | TIOCM_DSR | TIOCM_CTS;
 }
 
@@ -548,7 +579,7 @@ static void sc16is7xx_stop_tx(struct uart_port *port)
 	spin_unlock_irqrestore(&up->lock, flags);
 }
 
-static void sc16is7xxs_enable_ms(struct uart_port* port)
+static void sc16is7xxs_enable_ms(struct uart_port *port)
 {
 	/* Do nothing */
 }
@@ -560,7 +591,7 @@ static void sc16is7xx_break_ctl(struct uart_port *port, int break_state)
 
 	spin_lock_irqsave(&up->lock, flags);
 
-	dev_dbg(&up->client->dev, "%s:(%d)\n", __FUNCTION__, break_state);
+	dev_dbg(&up->client->dev, "%s:(%d)\n", __func__, break_state);
 	up->break_state = break_state;
 	set_bit(SC16IS7XX_CMND_BREAK_CTRL, &up->command);
 	sc16is7xx_work(up);
@@ -577,18 +608,15 @@ static void sc16is7xx_shutdown(struct uart_port *port)
 
 	dev_dbg(&up->client->dev, "%s\n", __func__);
 
-	/*
-	 * Disable interrupts from this port
-	 */
+	/* Disable interrupts from this port */
 	sc16is7xx_disable_irq(up, UART_IER_THRI | UART_IER_RDI);
 
-	/*
-	 * Disable break condition and FIFOs
-	 */
-	sc16is7xx_write_reg(up, UART_LCR, sc16is7xx_read_reg(up, UART_LCR) & ~UART_LCR_SBC);
-	sc16is7xx_write_reg(up, UART_FCR, UART_FCR_ENABLE_FIFO |
-			    UART_FCR_CLEAR_RCVR |
-			    UART_FCR_CLEAR_XMIT);
+	/* Disable break condition and FIFOs */
+	sc16is7xx_write_reg(up, UART_LCR,
+			    sc16is7xx_read_reg(up, UART_LCR) & ~UART_LCR_SBC);
+	sc16is7xx_write_reg(up, UART_FCR,
+			    (UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR |
+			     UART_FCR_CLEAR_XMIT));
 	sc16is7xx_write_reg(up, UART_FCR, 0);
 
 	spin_unlock_irqrestore(&up->lock, flags);
@@ -610,37 +638,37 @@ static int sc16is7xx_startup(struct uart_port *port)
 	up->break_state = -1;
 	up->tx_empty = TIOCSER_TEMT;
 
-	// Disable IRQs to configure
+	/* Disable IRQs to configure */
 	sc16is7xx_write_reg(up, UART_IER, 0);
 
-	/*
-	 * Now, initialize the UART
-	 */
+	/* Now, initialize the UART */
 	sc16is7xx_write_reg(up, UART_LCR, UART_LCR_8N1);
 
 	/*
-	 * Clear the FIFO buffers and disable them.
+	 * Clear the FIFO buffers and disable them
 	 * (they will be reenabled in set_termios())
 	 */
-	while(sc16is7xx_read_reg(up, UART_LSR) & (UART_LSR_DR | UART_LSR_BI))
-	{
-		/* Empty the RX holding register to prevent printing stale characters on the screen */
+	while (sc16is7xx_read_reg(up, UART_LSR) & (UART_LSR_DR | UART_LSR_BI)) {
+		/*
+		 * Empty the RX holding register to prevent printing
+		 * stale characters on the screen
+		 */
 		sc16is7xx_read_reg(up, UART_RX);
 	}
 
-	/*
-	 * Finally, enable interrupts.
-	 */
+	/* Finally, enable interrupts */
 	sc16is7xx_enable_irq(up, UART_IER_RDI);
 
 	spin_unlock_irqrestore(&up->lock, flags);
+
 	return 0;
 }
 
-static void
-sc16is7xx_set_termios(struct uart_port* port, struct ktermios* termios, struct ktermios* old)
+static void sc16is7xx_set_termios(struct uart_port *port,
+				  struct ktermios *termios,
+				  struct ktermios *old)
 {
-	struct uart_sc16is7xx_port * up = (struct uart_sc16is7xx_port *)port;
+	struct uart_sc16is7xx_port *up = (struct uart_sc16is7xx_port *)port;
 	unsigned long flags;
 
 	spin_lock_irqsave(&up->lock, flags);
@@ -678,15 +706,14 @@ static void sc16is7xx_config_port(struct uart_port *port, int flags)
 		up->port.type = PORT_SC16IS7XX;
 }
 
-static int sc16is7xx_verify_port(struct uart_port *port, struct serial_struct *ser)
+static int sc16is7xx_verify_port(struct uart_port *port,
+				 struct serial_struct *ser)
 {
-	int ret = -EINVAL;
-
 	if (ser->type == PORT_UNKNOWN || ser->type == PORT_SC16IS7XX)
-		ret = 0;
-	return ret;
-}
+		return 0;
 
+	return -EINVAL;
+}
 
 static struct uart_ops sc16is7xx_ops = {
 	.tx_empty	= sc16is7xx_tx_empty,
@@ -701,65 +728,61 @@ static struct uart_ops sc16is7xx_ops = {
 	.shutdown	= sc16is7xx_shutdown,
 	.set_termios	= sc16is7xx_set_termios,
 	.type		= sc16is7xx_type,
-	.release_port   = sc16is7xx_release_port,
-	.request_port   = sc16is7xx_request_port,
+	.release_port	= sc16is7xx_release_port,
+	.request_port	= sc16is7xx_request_port,
 	.config_port	= sc16is7xx_config_port,
 	.verify_port	= sc16is7xx_verify_port,
 };
 
 static struct uart_driver sc16is7xx_uart_driver = {
 	.owner		= THIS_MODULE,
-	.driver_name = DRV_NAME,
-	.dev_name    = DEV_NAME,
-	.major       = SC16IS7XX_MAJOR,
-	.minor       = SC16IS7XX_MINOR,
-	.nr          = 1,
+	.driver_name	= DRV_NAME,
+	.dev_name	= DEV_NAME,
+	.major		= SC16IS7XX_MAJOR,
+	.minor		= SC16IS7XX_MINOR,
+	.nr		= 1,
 };
-static int uart_driver_registered = 0;
+
+static int uart_driver_registered;
 
 static int sc16is7xx_probe(struct i2c_client *client,
 			   const struct i2c_device_id *id)
 {
 	int retval;
-	struct uart_sc16is7xx_port* up = NULL; /* user port */
+	struct uart_sc16is7xx_port *up = NULL; /* user port */
 
 	if (!uart_driver_registered) {
 		retval = uart_register_driver(&sc16is7xx_uart_driver);
 		if (retval) {
-			printk(KERN_ERR "Couldn't register sc16is7xx uart driver\n");
+			pr_err("Couldn't register sc16is7xx uart driver\n");
 			return retval;
 		}
 		uart_driver_registered = 1;
 	}
 
-	up = kzalloc(sizeof(struct uart_sc16is7xx_port), GFP_KERNEL);
-	if (!up) {
-		dev_warn(&client->dev,
-			 "kmalloc for sc16is7xx structure failed!\n");
+	up = kzalloc(sizeof(*up), GFP_KERNEL);
+	if (!up)
 		return -ENOMEM;
-	}
 
 	/* First check if adaptor is OK and it supports our I2C functionality */
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-	{
-		dev_err(&client->dev,"Can't find the sc16is7xx chip\n");
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "Can't find the sc16is7xx chip\n");
 		retval = -ENODEV;
 		goto exit;
 	}
 
-	dev_info(&client->dev,"chip found, driver version " DRV_VERSION "\n");
+	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
 	/* Configure the GPIO IRQ line */
 	retval = gpio_request(DA850_RS485_INT_PIN, "SC16IS7xx INT");
-
-	if(retval)
-	{
-		dev_err(&client->dev,"Can't request gpio interrupt pin \n");
+	if (retval) {
+		dev_err(&client->dev, "Can't request gpio interrupt pin\n");
 		retval = -EIO;
 		goto exit;
 	}
 
-	gpio_direction_input(DA850_RS485_INT_PIN); // Set GPIO IRQ pin to be input
+	/* Set GPIO IRQ pin to be input */
+	gpio_direction_input(DA850_RS485_INT_PIN);
 
 	up->client = client;
 
@@ -768,8 +791,8 @@ static int sc16is7xx_probe(struct i2c_client *client,
 	up->port.uartclk = SC16IS7XX_CLK;
 	up->port.fifosize = SC16IS7XX_FIFO_SIZE;
 	up->port.ops = &sc16is7xx_ops;
-	up->port.iotype   = UPIO_PORT;
-	up->port.flags    = UPF_FIXED_TYPE | UPF_FIXED_PORT;
+	up->port.iotype = UPIO_PORT;
+	up->port.flags = UPF_FIXED_TYPE | UPF_FIXED_PORT;
 	up->port.line = 0;
 	up->port.type = PORT_SC16IS7XX;
 	up->port.dev = &client->dev;
@@ -780,7 +803,7 @@ static int sc16is7xx_probe(struct i2c_client *client,
 			 "uart_add_one_port failed with error %d\n",
 			 retval);
 
-	i2c_set_clientdata(client,up);
+	i2c_set_clientdata(client, up);
 
 	/* Disable interrupts */
 	up->ier = 0;
@@ -790,7 +813,8 @@ static int sc16is7xx_probe(struct i2c_client *client,
 				      NULL, sc16is7xx_ist,
 				      IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				      DRV_NAME, up) < 0) {
-		dev_err(&up->client->dev, "cannot allocate irq %d\n", up->port.irq);
+		dev_err(&up->client->dev, "cannot allocate irq %d\n",
+			up->port.irq);
 		return -EBUSY;
 	}
 
@@ -805,10 +829,8 @@ static int sc16is7xx_remove(struct i2c_client *client)
 {
 	struct uart_sc16is7xx_port *up = i2c_get_clientdata(client);
 
-	if(!uart_driver_registered)
-	{
+	if (!uart_driver_registered)
 		return 0;
-	}
 
 	devm_free_irq(&client->dev, up->port.irq, up);
 
@@ -816,7 +838,6 @@ static int sc16is7xx_remove(struct i2c_client *client)
 	dev_dbg(&client->dev, "%s: removing port\n", __func__);
 	uart_remove_one_port(&sc16is7xx_uart_driver, &up->port);
 	kfree(up);
-	up = NULL;
 
 	pr_debug("removing sc16is7xx driver\n");
 	uart_unregister_driver(&sc16is7xx_uart_driver);
@@ -827,7 +848,7 @@ static int sc16is7xx_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id sc16is7xx_i2c_id[] = {
-	{ "sc16is7xx",0},
+	{ "sc16is7xx", 0},
 	{ }
 };
 


