Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965388AbaKNO2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:28:31 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:46999 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964875AbaKNO22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:28:28 -0500
From: Aleksey Makarov <feumilieu@gmail.com>
X-Google-Original-From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: linux-serial@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: 8250_dw: Use 64-bit access for OCTEON.
Date: Fri, 14 Nov 2014 17:26:19 +0300
Message-Id: <1415975244-10824-1-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Although the existing code appears to work on most hardware, the
hardware designers tell us that 8-bit access to the registers is not
guaranteed to be reliable.  Also the OCTEON simulation environments
prohibit 8-bit accesses.

For these reasons, we use __raw_readq/__raw_writeq for OCTEON.  This
code is protected with #ifdef CONFIG_64BIT so it still builds under
configurations lacking readq/writeq.

We can get rid of the #ifdef __BIG_ENDIAN, as under 64-bit accesses,
OCTEON is byte order invariant.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 drivers/tty/serial/8250/8250_dw.c | 55 +++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index beea6ca..6232d15 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -122,13 +122,44 @@ static unsigned int dw8250_serial_in(struct uart_port *p, int offset)
 	return dw8250_modify_msr(p, offset, value);
 }
 
-/* Read Back (rb) version to ensure register access ording. */
-static void dw8250_serial_out_rb(struct uart_port *p, int offset, int value)
+#ifdef CONFIG_64BIT
+static unsigned int dw8250_serial_inq(struct uart_port *p, int offset)
 {
-	dw8250_serial_out(p, offset, value);
-	dw8250_serial_in(p, UART_LCR);
+	unsigned int value;
+
+	value = (u8)__raw_readq(p->membase + (offset << p->regshift));
+
+	return dw8250_modify_msr(p, offset, value);
 }
 
+static void dw8250_serial_outq(struct uart_port *p, int offset, int value)
+{
+	struct dw8250_data *d = p->private_data;
+
+	if (offset == UART_MCR)
+		d->last_mcr = value;
+
+	value &= 0xff;
+	__raw_writeq(value, p->membase + (offset << p->regshift));
+	/* Read back to ensure register write ordering. */
+	__raw_readq(p->membase + (UART_LCR << p->regshift));
+
+	/* Make sure LCR write wasn't ignored */
+	if (offset == UART_LCR) {
+		int tries = 1000;
+		while (tries--) {
+			unsigned int lcr = p->serial_in(p, UART_LCR);
+			if ((value & ~UART_LCR_SPAR) == (lcr & ~UART_LCR_SPAR))
+				return;
+			dw8250_force_idle(p);
+			__raw_writeq(value & 0xff,
+				     p->membase + (UART_LCR << p->regshift));
+		}
+		dev_err(p->dev, "Couldn't set LCR to %d\n", value);
+	}
+}
+#endif /* CONFIG_64BIT */
+
 static void dw8250_serial_out32(struct uart_port *p, int offset, int value)
 {
 	struct dw8250_data *d = p->private_data;
@@ -259,21 +290,17 @@ static int dw8250_probe_of(struct uart_port *p,
 	u32			val;
 	bool has_ucv = true;
 
+#ifdef CONFIG_64BIT
 	if (of_device_is_compatible(np, "cavium,octeon-3860-uart")) {
-#ifdef __BIG_ENDIAN
-		/*
-		 * Low order bits of these 64-bit registers, when
-		 * accessed as a byte, are 7 bytes further down in the
-		 * address space in big endian mode.
-		 */
-		p->membase += 7;
-#endif
-		p->serial_out = dw8250_serial_out_rb;
+		p->serial_in = dw8250_serial_inq;
+		p->serial_out = dw8250_serial_outq;
 		p->flags = UPF_SKIP_TEST | UPF_SHARE_IRQ | UPF_FIXED_TYPE;
 		p->type = PORT_OCTEON;
 		data->usr_reg = 0x27;
 		has_ucv = false;
-	} else if (!of_property_read_u32(np, "reg-io-width", &val)) {
+	} else
+#endif
+	if (!of_property_read_u32(np, "reg-io-width", &val)) {
 		switch (val) {
 		case 1:
 			break;
-- 
2.1.3

