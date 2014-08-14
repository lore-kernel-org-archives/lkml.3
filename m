Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaHNCmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:42:10 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40900 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaHNCmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:42:07 -0400
Message-ID: <53EC21FC.4000204@gmail.com>
Date: Wed, 13 Aug 2014 19:42:04 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: frowand.list@gmail.com
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH to be tested] serial: msm_serial: add missing sysrq handling
References: <53E2C573.7090709@gmail.com> <53EAB01B.5030102@codeaurora.org> <53EC1FEA.5070907@gmail.com>
In-Reply-To: <53EC1FEA.5070907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2014 7:33 PM, Frank Rowand wrote:
> On 8/12/2014 5:23 PM, Stephen Boyd wrote:
>> On 08/06/14 17:16, Frank Rowand wrote:

< snip >

> The patches you sent are a little hard to read since they modify further code
> that my patch modified.  So I have redone your patches, as if my patch was
> not previously applied.  Hopefully I did not make any mistakes there.  I will
> reply to this email with each of your redone patches.

< snip >

Stephen's patch alternative number 1:


---
 drivers/tty/serial/msm_serial.c |   44 ++++++++++++++++++++++++++++------------
 drivers/tty/serial/msm_serial.h |    8 +++++++
 2 files changed, 39 insertions(+), 13 deletions(-)

Index: b/drivers/tty/serial/msm_serial.c
===================================================================
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -125,25 +125,28 @@ static void handle_rx_dm(struct uart_por
 	port->icount.rx += count;
 
 	while (count > 0) {
-		unsigned int c;
+		unsigned char buf[4];
+		unsigned char *p = buf;
+		int sysrq, r_count;
 
 		sr = msm_read(port, UART_SR);
 		if ((sr & UART_SR_RX_READY) == 0) {
 			msm_port->old_snap_state -= count;
 			break;
 		}
-		c = msm_read(port, UARTDM_RF);
-		if (sr & UART_SR_RX_BREAK) {
-			port->icount.brk++;
-			if (uart_handle_break(port))
-				continue;
-		} else if (sr & UART_SR_PAR_FRAME_ERR)
-			port->icount.frame++;
+		readsl(port->membase + UARTDM_RF, p, 1);
 
-		/* TODO: handle sysrq */
-		tty_insert_flip_string(tport, (char *)&c,
-				       (count > 4) ? 4 : count);
-		count -= 4;
+		spin_unlock(&port->lock);
+		sysrq = uart_handle_sysrq_char(port, buf[0]);
+		spin_lock(&port->lock);
+		if (sysrq) {
+			p++;
+			count--;
+		}
+		r_count = min_t(int, count, sizeof(buf) - sysrq);
+		if (r_count)
+			tty_insert_flip_string(tport, p, r_count);
+		count -= r_count;
 	}
 
 	spin_unlock(&port->lock);
@@ -285,6 +288,17 @@ static irqreturn_t msm_irq(int irq, void
 	misr = msm_read(port, UART_MISR);
 	msm_write(port, 0, UART_IMR); /* disable interrupt */
 
+	if (misr & UART_IMR_RXBREAK_END) {
+		uart_handle_break(port);
+		port->icount.brk++;
+		msm_write(port, UART_CR_CMD_RESET_RXBREAK_END, UART_CR);
+	}
+
+	if (misr & UART_IMR_PAR_FRAME_ERR) {
+		port->icount.frame++;
+		msm_write(port, UART_CR_CMD_RESET_PAR_FRAME_ERR, UART_CR);
+	}
+
 	if (misr & (UART_IMR_RXLEV | UART_IMR_RXSTALE)) {
 		if (msm_port->is_uartdm)
 			handle_rx_dm(port, misr);
@@ -491,7 +505,8 @@ static int msm_startup(struct uart_port
 
 	/* turn on RX and CTS interrupts */
 	msm_port->imr = UART_IMR_RXLEV | UART_IMR_RXSTALE |
-			UART_IMR_CURRENT_CTS;
+			UART_IMR_CURRENT_CTS | UART_IMR_RXBREAK_END |
+			UART_IMR_PAR_FRAME_ERR;
 
 	if (msm_port->is_uartdm) {
 		msm_write(port, 0xFFFFFF, UARTDM_DMRX);
@@ -566,6 +581,9 @@ static void msm_set_termios(struct uart_
 	else
 		mr |= UART_MR2_STOP_BIT_LEN_ONE;
 
+	mr |= UART_MR2_RX_BREAK_ZERO_CHAR_OFF;
+	mr |= UART_MR2_RX_ERROR_CHAR_OFF;
+
 	/* set parity, bits per char, and stop bit */
 	msm_write(port, mr, UART_MR2);
 
Index: b/drivers/tty/serial/msm_serial.h
===================================================================
--- a/drivers/tty/serial/msm_serial.h
+++ b/drivers/tty/serial/msm_serial.h
@@ -24,6 +24,8 @@
 #define UART_MR1_CTS_CTL       		(1 << 6)
 
 #define UART_MR2			0x0004
+#define UART_MR2_RX_ERROR_CHAR_OFF	(1 << 9)
+#define UART_MR2_RX_BREAK_ZERO_CHAR_OFF	(1 << 8)
 #define UART_MR2_ERROR_MODE		(1 << 6)
 #define UART_MR2_BITS_PER_CHAR		0x30
 #define UART_MR2_BITS_PER_CHAR_5	(0x0 << 4)
@@ -65,6 +67,9 @@
 #define UART_CR_TX_ENABLE		(1 << 2)
 #define UART_CR_RX_DISABLE		(1 << 1)
 #define UART_CR_RX_ENABLE		(1 << 0)
+#define UART_CR_CMD_RESET_RXBREAK_START	((1 << 11) | (2 << 4))
+#define UART_CR_CMD_RESET_RXBREAK_END	((1 << 11) | (3 << 4))
+#define UART_CR_CMD_RESET_PAR_FRAME_ERR	((1 << 11) | (4 << 4))
 
 #define UART_IMR		0x0014
 #define UART_IMR_TXLEV		(1 << 0)
@@ -72,6 +77,9 @@
 #define UART_IMR_RXLEV		(1 << 4)
 #define UART_IMR_DELTA_CTS	(1 << 5)
 #define UART_IMR_CURRENT_CTS	(1 << 6)
+#define UART_IMR_RXBREAK_START	(1 << 10)
+#define UART_IMR_RXBREAK_END	(1 << 11)
+#define UART_IMR_PAR_FRAME_ERR	(1 << 12)
 
 #define UART_IPR_RXSTALE_LAST		0x20
 #define UART_IPR_STALE_LSB		0x1F
