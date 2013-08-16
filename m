Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3HPWXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:23:22 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4950 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab3HPWXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:23:19 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Heikki Krogerus" <heikki.krogerus@linux.intel.com>
cc: "Tim Kryger" <tim.kryger@linaro.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH] serial: 8250_dw: Report CTS asserted for auto flow
Date: Fri, 16 Aug 2013 13:50:15 -0700
Message-ID: <1376686215-25686-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
X-WSS-ID: 7E1051C02L875116914-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/tty/serial/8250/8250_dw.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 76a8daa..daf710f 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -57,11 +57,25 @@
 
 struct dw8250_data {
 	int		last_lcr;
+	int		last_mcr;
 	int		line;
 	struct clk	*clk;
 	u8		usr_reg;
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
@@ -69,15 +83,17 @@ static void dw8250_serial_out(struct uart_port *p, int offset, int value)
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
 
 /* Read Back (rb) version to ensure register access ording. */
@@ -94,15 +110,17 @@ static void dw8250_serial_out32(struct uart_port *p, int offset, int value)
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
-- 
1.8.0.1


