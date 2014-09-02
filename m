Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbaIBNH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:07:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39561 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaIBNH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:07:27 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH v11 15/19] serial: amba-pl011: Pass FIQ information to KGDB.
Date: Tue,  2 Sep 2014 14:00:49 +0100
Message-Id: <1409662853-29313-16-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Speculatively register a FIQ resource with KGDB. KGDB will only
accept it if the kgdb/fiq feature is enabled (both with compile time and
runtime switches) and the interrupt controller supports FIQ.

By providing this information to KGDB the serial driver offers
"permission" for KGDB to route the UART interrupt signal from the
drivers own handler to KGDBs FIQ handler (which will eventually use the
UART's polled I/O callbacks to interact with the user). This permission
also implies the amba-pl011 driver has already unmasked RX interrupts
(otherwise the FIQ handler will never trigger).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/amba-pl011.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 0b06dcf..63c67b0 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -58,6 +58,7 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/sizes.h>
 #include <linux/io.h>
+#include <linux/kgdb.h>
 
 #define UART_NR			14
 
@@ -1466,6 +1467,18 @@ static int pl011_hwinit(struct uart_port *port)
 
 #ifdef CONFIG_CONSOLE_POLL
 
+static int pl011_poll_init(struct uart_port *port)
+{
+	int retval = pl011_hwinit(port);
+
+#ifdef CONFIG_KGDB_FIQ
+	if (retval == 0)
+		kgdb_register_fiq(port->irq);
+#endif
+
+	return retval;
+}
+
 static void pl011_quiesce_irqs(struct uart_port *port)
 {
 	struct uart_amba_port *uap =
@@ -1905,7 +1918,7 @@ static struct uart_ops amba_pl011_pops = {
 	.config_port	= pl011_config_port,
 	.verify_port	= pl011_verify_port,
 #ifdef CONFIG_CONSOLE_POLL
-	.poll_init     = pl011_hwinit,
+	.poll_init     = pl011_poll_init,
 	.poll_get_char = pl011_get_poll_char,
 	.poll_put_char = pl011_put_poll_char,
 #endif
-- 
1.9.3

