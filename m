Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbaENO4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:56:01 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:49880 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbaENOz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:55:58 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Jiri Slaby <jslaby@suse.cz>,
        Kumar Gala <galak@kernel.crashing.org>,
        Pantelis Antoniou <panto@intracom.gr>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Joe Schultz <jschultz@xes-inc.com>,
        Loic Poulain <loic.poulain@intel.com>,
        Kyle McMartin <kyle@infradead.org>,
        Stephen Warren <swarren@nvidia.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 1/4] serial: core: Consistent LF handling for poll_put_char
Date: Wed, 14 May 2014 15:55:32 +0100
Message-Id: <1400079335-32125-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400079335-32125-1-git-send-email-daniel.thompson@linaro.org>
References: <1400079335-32125-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The behaviour of the UART poll_put_char infrastructure is inconsistent
with respect to linefeed conversions. This in turn leads to difficulty
using kdb on serial ports that are not also consoles
(e.g. console=ttyAMA0,115200 kgdboc=ttyAMA1,115200).

The following drivers automatically convert '\n' to '\r\n' inside their
own poll functions but the remaining seventeen do not:

    serial8250, cpm, pch_uart, serial_pxa, serial_txx9,

This can be made fully consistent but performing the conversion in
uart_poll_put_char(). A similar conversion is already made inside
uart_console_write() but it is optional for drivers to use this
function. Fortunately we can be confident the translation is safe
because the (very common) 8250 already does this translation.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Pantelis Antoniou <panto@intracom.gr>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Joe Schultz <jschultz@xes-inc.com>
Cc: Loic Poulain <loic.poulain@intel.com>
Cc: Kyle McMartin <kyle@infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/tty/serial/8250/8250_core.c         | 5 -----
 drivers/tty/serial/cpm_uart/cpm_uart_core.c | 8 ++++----
 drivers/tty/serial/pch_uart.c               | 5 -----
 drivers/tty/serial/pxa.c                    | 5 -----
 drivers/tty/serial/serial_core.c            | 2 ++
 drivers/tty/serial/serial_txx9.c            | 5 -----
 6 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 2d4bd39..053c200 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1926,13 +1926,8 @@ static void serial8250_put_poll_char(struct uart_port *port,
 	wait_for_xmitr(up, BOTH_EMPTY);
 	/*
 	 *	Send the character out.
-	 *	If a LF, also do CR...
 	 */
 	serial_port_out(port, UART_TX, c);
-	if (c == 10) {
-		wait_for_xmitr(up, BOTH_EMPTY);
-		serial_port_out(port, UART_TX, 13);
-	}
 
 	/*
 	 *	Finally, wait for transmitter to become empty
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index 7d76214..aa60e6d 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -971,7 +971,7 @@ static void cpm_uart_config_port(struct uart_port *port, int flags)
  * Note that this is called with interrupts already disabled
  */
 static void cpm_uart_early_write(struct uart_cpm_port *pinfo,
-		const char *string, u_int count)
+		const char *string, u_int count, bool handle_linefeed)
 {
 	unsigned int i;
 	cbd_t __iomem *bdp, *bdbase;
@@ -1013,7 +1013,7 @@ static void cpm_uart_early_write(struct uart_cpm_port *pinfo,
 			bdp++;
 
 		/* if a LF, also do CR... */
-		if (*string == 10) {
+		if (handle_linefeed && *string == 10) {
 			while ((in_be16(&bdp->cbd_sc) & BD_SC_READY) != 0)
 				;
 
@@ -1111,7 +1111,7 @@ static void cpm_put_poll_char(struct uart_port *port,
 	static char ch[2];
 
 	ch[0] = (char)c;
-	cpm_uart_early_write(pinfo, ch, 1);
+	cpm_uart_early_write(pinfo, ch, 1, false);
 }
 #endif /* CONFIG_CONSOLE_POLL */
 
@@ -1275,7 +1275,7 @@ static void cpm_uart_console_write(struct console *co, const char *s,
 		spin_lock_irqsave(&pinfo->port.lock, flags);
 	}
 
-	cpm_uart_early_write(pinfo, s, count);
+	cpm_uart_early_write(pinfo, s, count, true);
 
 	if (unlikely(nolock)) {
 		local_irq_restore(flags);
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 0931b3f..11e631d 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1588,13 +1588,8 @@ static void pch_uart_put_poll_char(struct uart_port *port,
 	wait_for_xmitr(priv, UART_LSR_THRE);
 	/*
 	 * Send the character out.
-	 * If a LF, also do CR...
 	 */
 	iowrite8(c, priv->membase + PCH_UART_THR);
-	if (c == 10) {
-		wait_for_xmitr(priv, UART_LSR_THRE);
-		iowrite8(13, priv->membase + PCH_UART_THR);
-	}
 
 	/*
 	 * Finally, wait for transmitter to become empty
diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index f9f20f3..9e7ee39 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -711,13 +711,8 @@ static void serial_pxa_put_poll_char(struct uart_port *port,
 	wait_for_xmitr(up);
 	/*
 	 *	Send the character out.
-	 *	If a LF, also do CR...
 	 */
 	serial_out(up, UART_TX, c);
-	if (c == 10) {
-		wait_for_xmitr(up);
-		serial_out(up, UART_TX, 13);
-	}
 
 	/*
 	 *	Finally, wait for transmitter to become empty
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index b68550d..50167bf 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2239,6 +2239,8 @@ static void uart_poll_put_char(struct tty_driver *driver, int line, char ch)
 		return;
 
 	port = state->uart_port;
+	if (ch == '\n')
+		port->ops->poll_put_char(port, '\r');
 	port->ops->poll_put_char(port, ch);
 }
 #endif
diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index 90a080b..60f49b9 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -535,13 +535,8 @@ static void serial_txx9_put_poll_char(struct uart_port *port, unsigned char c)
 	wait_for_xmitr(up);
 	/*
 	 *	Send the character out.
-	 *	If a LF, also do CR...
 	 */
 	sio_out(up, TXX9_SITFIFO, c);
-	if (c == 10) {
-		wait_for_xmitr(up);
-		sio_out(up, TXX9_SITFIFO, 13);
-	}
 
 	/*
 	 *	Finally, wait for transmitter to become empty
-- 
1.9.0

