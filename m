Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaGGX6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:58:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaGGXzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tim Kryger <tim.kryger@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>, Wang Nan <wangnan0@huawei.com>
Subject: [PATCH 3.10 46/53] serial: 8250_dw: Report CTS asserted for auto flow
Date: Mon,  7 Jul 2014 16:58:31 -0700
Message-Id: <20140707235830.683218399@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
References: <20140707235829.281783607@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Kryger <tim.kryger@linaro.org>

commit 33acbb82695f84e9429c1f7fbdeb4588dea12ffa upstream.

When a serial port is configured for RTS/CTS flow control, serial core
will disable the transmitter if it observes CTS is de-asserted. This is
perfectly reasonable and appropriate when the UART lacks the ability to
automatically perform CTS flow control.

However, if the UART hardware can manage flow control automatically, it
is important that software not get involved.  When the DesignWare UART
enables 16C750 style auto-RTS/CTS it stops generating interrupts for
changes in CTS state so software mostly stays out of the way.  However,
it does report the true state of CTS in the MSR so software may notice
it is de-asserted and respond by improperly disabling the transmitter.
Once this happens the transmitter will be blocked forever.

To avoid this situation, we simply lie to the 8250 and serial core by
reporting that CTS is asserted whenever auto-RTS/CTS mode is enabled.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_dw.c |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -55,10 +55,24 @@
 
 struct dw8250_data {
 	int		last_lcr;
+	int		last_mcr;
 	int		line;
 	struct clk	*clk;
 };
 
+static inline int dw8250_modify_msr(struct uart_port *p, int offset, int value)
+{
+	struct dw8250_data *d = p->private_data;
+
+	/* If reading MSR, report CTS asserted when auto-CTS/RTS enabled */
+	if (offset == UART_MSR && d->last_mcr & UART_MCR_AFE) {
+		value |= UART_MSR_CTS;
+		value &= ~UART_MSR_DCTS;
+	}
+
+	return value;
+}
+
 static void dw8250_serial_out(struct uart_port *p, int offset, int value)
 {
 	struct dw8250_data *d = p->private_data;
@@ -66,15 +80,17 @@ static void dw8250_serial_out(struct uar
 	if (offset == UART_LCR)
 		d->last_lcr = value;
 
-	offset <<= p->regshift;
-	writeb(value, p->membase + offset);
+	if (offset == UART_MCR)
+		d->last_mcr = value;
+
+	writeb(value, p->membase + (offset << p->regshift));
 }
 
 static unsigned int dw8250_serial_in(struct uart_port *p, int offset)
 {
-	offset <<= p->regshift;
+	unsigned int value = readb(p->membase + (offset << p->regshift));
 
-	return readb(p->membase + offset);
+	return dw8250_modify_msr(p, offset, value);
 }
 
 static void dw8250_serial_out32(struct uart_port *p, int offset, int value)
@@ -84,15 +100,17 @@ static void dw8250_serial_out32(struct u
 	if (offset == UART_LCR)
 		d->last_lcr = value;
 
-	offset <<= p->regshift;
-	writel(value, p->membase + offset);
+	if (offset == UART_MCR)
+		d->last_mcr = value;
+
+	writel(value, p->membase + (offset << p->regshift));
 }
 
 static unsigned int dw8250_serial_in32(struct uart_port *p, int offset)
 {
-	offset <<= p->regshift;
+	unsigned int value = readl(p->membase + (offset << p->regshift));
 
-	return readl(p->membase + offset);
+	return dw8250_modify_msr(p, offset, value);
 }
 
 static int dw8250_handle_irq(struct uart_port *p)


