Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934620Ab3DGX2B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:28:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46637 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757645Ab3DGX16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:27:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Pawel Wieczorkiewicz" <wpawel@gmail.com>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.242317789@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [12/74] tty: atmel_serial_probe(): index of atmel_ports[] fix
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Wieczorkiewicz <wpawel@gmail.com>

commit 503bded92da283b2f31d87e054c4c6d30c3c2340 upstream.

Index of atmel_ports[ATMEL_MAX_UART] should be smaller
than ATMEL_MAX_UART.

Signed-off-by: Pawel Wieczorkiewicz <wpawel@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/atmel_serial.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -159,7 +159,7 @@ struct atmel_uart_port {
 };
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
-static unsigned long atmel_ports_in_use;
+static DECLARE_BITMAP(atmel_ports_in_use, ATMEL_MAX_UART);
 
 #ifdef SUPPORT_SYSRQ
 static struct console atmel_console;
@@ -1784,15 +1784,14 @@ static int __devinit atmel_serial_probe(
 	if (ret < 0)
 		/* port id not found in platform data nor device-tree aliases:
 		 * auto-enumerate it */
-		ret = find_first_zero_bit(&atmel_ports_in_use,
-				sizeof(atmel_ports_in_use));
+		ret = find_first_zero_bit(atmel_ports_in_use, ATMEL_MAX_UART);
 
-	if (ret > ATMEL_MAX_UART) {
+	if (ret >= ATMEL_MAX_UART) {
 		ret = -ENODEV;
 		goto err;
 	}
 
-	if (test_and_set_bit(ret, &atmel_ports_in_use)) {
+	if (test_and_set_bit(ret, atmel_ports_in_use)) {
 		/* port already in use */
 		ret = -EBUSY;
 		goto err;
@@ -1866,7 +1865,7 @@ static int __devexit atmel_serial_remove
 
 	/* "port" is allocated statically, so we shouldn't free it */
 
-	clear_bit(port->line, &atmel_ports_in_use);
+	clear_bit(port->line, atmel_ports_in_use);
 
 	clk_put(atmel_port->clk);
 

