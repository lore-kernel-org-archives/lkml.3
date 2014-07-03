Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbaGCJha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:37:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52466 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030336AbaGCJYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tim Kryger <tim.kryger@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wang Nan <wangnan0@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 159/198] serial: 8250_dw: Report CTS asserted for auto flow
Date: Thu,  3 Jul 2014 10:20:02 +0100
Message-Id: <1404379241-8590-160-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/8250/8250_dw.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index b8cacb850d96..8b2accbad3d1 100644
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
1.9.1

