Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaHMAX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:23:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50035 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaHMAX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:23:57 -0400
Message-ID: <53EAB01B.5030102@codeaurora.org>
Date: Tue, 12 Aug 2014 17:23:55 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: frowand.list@gmail.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH to be tested] serial: msm_serial: add missing sysrq handling
References: <53E2C573.7090709@gmail.com>
In-Reply-To: <53E2C573.7090709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/14 17:16, Frank Rowand wrote:
> Stephen,
>
> Can you test this patch on v 1.3 hardware?  It works on my v 1.4.
>
> If you use kdmx2, the way to send a break is '~B'.  The previous
> key pressed must be <enter> for the '~' escape to be recognized.
>
> Thanks!
>
> -Frank
>
>
>
> From: Frank Rowand <frank.rowand@sonymobile.com>
>
> Add missing sysrq handling to msm_serial.
>
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
>
> ---

It works but I have questions.

>  drivers/tty/serial/msm_serial.c |   26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
>
> Index: b/drivers/tty/serial/msm_serial.c
> ===================================================================
> --- a/drivers/tty/serial/msm_serial.c
> +++ b/drivers/tty/serial/msm_serial.c
> @@ -126,6 +126,8 @@ static void handle_rx_dm(struct uart_por
>  
>  	while (count > 0) {
>  		unsigned int c;
> +		unsigned char *cp;
> +		int res;
>  
>  		sr = msm_read(port, UART_SR);
>  		if ((sr & UART_SR_RX_READY) == 0) {
> @@ -135,15 +137,29 @@ static void handle_rx_dm(struct uart_por
>  		c = msm_read(port, UARTDM_RF);
>  		if (sr & UART_SR_RX_BREAK) {
>  			port->icount.brk++;
> -			if (uart_handle_break(port))
> +			if (uart_handle_break(port)) {
> +				count -= 1;
>  				continue;
> +			}

This looks wrong. If it's a break then I think the fifo takes in a break
character indicated by all zeros. We could possibly have 3 other
characters after it in the fifo, or maybe 2 characters in front of it,
or it could be 30 characters in. We can change this behavior by setting
a bit in the MR2 register so that the all zero character doesn't enter
the fifo. The same goes for the parity and frame error conditions, we
can drop those characters too.

I asked the designers how we're supposed to deal with a break in the
middle of the fifo and they recommended using the start/stop rx break
interrupts. Unfortunately, I don't think we can rely on the interrupts
being distinct so that might not work (but see attached patch). There's
also a break interrupt that triggers on the start and stop rx break
events. I don't know how this is useful either because we might get two
interrupts or we might get one.

So perhaps we need to scan through the 4 characters for a zero character
when the SR_RX_BREAK bit it set? The second diff does that.

Add another twist with port->read_status_mask. I guess that's there to
make it so that break characters still enter the tty layer? Is there any
documentation on this stuff? I'm lost on what the tty layer expects.

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index e52a4242b7a1..ba66e487c08a 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -125,41 +125,28 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 	port->icount.rx += count;
 
 	while (count > 0) {
-		unsigned int c;
-		unsigned char *cp;
-		int res;
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
-			if (uart_handle_break(port)) {
-				count -= 1;
-				continue;
-			}
-		} else if (sr & UART_SR_PAR_FRAME_ERR)
-			port->icount.frame++;
+		readsl(port->membase + UARTDM_RF, p, 1);
 
 		spin_unlock(&port->lock);
-		res = uart_handle_sysrq_char(port, c);
+		sysrq = uart_handle_sysrq_char(port, buf[0]);
 		spin_lock(&port->lock);
-
-		cp = (unsigned char *)&c;
-		if (res) {
-			count -= 1;
-			tty_insert_flip_string(tport, cp + 1,
-					       (count > 3) ? 3 : count);
-			count -= (count > 3) ? 3 : count;
-		} else {
-			tty_insert_flip_string(tport, cp,
-					       (count > 4) ? 4 : count);
-			count -= (count > 4) ? 4 : count;
+		if (sysrq) {
+			p++;
+			count--;
 		}
-
+		r_count = min_t(int, count, sizeof(buf) - sysrq);
+		if (r_count)
+			tty_insert_flip_string(tport, p, r_count);
+		count -= r_count;
 	}
 
 	spin_unlock(&port->lock);
@@ -301,6 +288,17 @@ static irqreturn_t msm_irq(int irq, void *dev_id)
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
@@ -507,7 +505,8 @@ static int msm_startup(struct uart_port *port)
 
 	/* turn on RX and CTS interrupts */
 	msm_port->imr = UART_IMR_RXLEV | UART_IMR_RXSTALE |
-			UART_IMR_CURRENT_CTS;
+			UART_IMR_CURRENT_CTS | UART_IMR_RXBREAK_END |
+			UART_IMR_PAR_FRAME_ERR;
 
 	if (msm_port->is_uartdm) {
 		msm_write(port, 0xFFFFFF, UARTDM_DMRX);
@@ -582,6 +581,9 @@ static void msm_set_termios(struct uart_port *port, struct ktermios *termios,
 	else
 		mr |= UART_MR2_STOP_BIT_LEN_ONE;
 
+	mr |= UART_MR2_RX_BREAK_ZERO_CHAR_OFF;
+	mr |= UART_MR2_RX_ERROR_CHAR_OFF;
+
 	/* set parity, bits per char, and stop bit */
 	msm_write(port, mr, UART_MR2);
 
diff --git a/drivers/tty/serial/msm_serial.h b/drivers/tty/serial/msm_serial.h
index d98d45efdf86..c2ffa8ba5a34 100644
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


diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index e52a4242b7a1..dd68ccdad140 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -125,41 +125,40 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 	port->icount.rx += count;
 
 	while (count > 0) {
-		unsigned int c;
-		unsigned char *cp;
-		int res;
+		unsigned char buf[4];
+		int sysrq, r_count, i;
 
 		sr = msm_read(port, UART_SR);
 		if ((sr & UART_SR_RX_READY) == 0) {
 			msm_port->old_snap_state -= count;
 			break;
 		}
-		c = msm_read(port, UARTDM_RF);
-		if (sr & UART_SR_RX_BREAK) {
-			port->icount.brk++;
-			if (uart_handle_break(port)) {
-				count -= 1;
-				continue;
+		readsl(port->membase + UARTDM_RF, buf, 1);
+
+		r_count = min_t(int, count, sizeof(buf));
+
+		for (i = 0; i < r_count; i++) {
+			char flag = TTY_NORMAL;
+
+			if (sr & UART_SR_RX_BREAK) {
+				if (buf[i] == 0) {
+					port->icount.brk++;
+					flag = TTY_BREAK;
+					if (uart_handle_break(port))
+						continue;
+				}
 			}
-		} else if (sr & UART_SR_PAR_FRAME_ERR)
-			port->icount.frame++;
 
-		spin_unlock(&port->lock);
-		res = uart_handle_sysrq_char(port, c);
-		spin_lock(&port->lock);
+			if (!(port->read_status_mask & UART_SR_RX_BREAK))
+				flag = TTY_NORMAL;
 
-		cp = (unsigned char *)&c;
-		if (res) {
-			count -= 1;
-			tty_insert_flip_string(tport, cp + 1,
-					       (count > 3) ? 3 : count);
-			count -= (count > 3) ? 3 : count;
-		} else {
-			tty_insert_flip_string(tport, cp,
-					       (count > 4) ? 4 : count);
-			count -= (count > 4) ? 4 : count;
+			spin_unlock(&port->lock);
+			sysrq = uart_handle_sysrq_char(port, buf[i]);
+			spin_lock(&port->lock);
+			if (!sysrq)
+				tty_insert_flip_char(tport, buf[i], flag);
 		}
-
+		count -= r_count;
 	}
 
 	spin_unlock(&port->lock);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

