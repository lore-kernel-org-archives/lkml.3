Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab3DBWMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:12:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761137Ab3DBWMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pawel Wieczorkiewicz <wpawel@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 030/124] tty: atmel_serial_probe(): index of atmel_ports[] fix
Date: Tue,  2 Apr 2013 15:10:12 -0700
Message-Id: <20130402221107.654308132@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Wieczorkiewicz <wpawel@gmail.com>

commit 503bded92da283b2f31d87e054c4c6d30c3c2340 upstream.

Index of atmel_ports[ATMEL_MAX_UART] should be smaller
than ATMEL_MAX_UART.

Signed-off-by: Pawel Wieczorkiewicz <wpawel@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/atmel_serial.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -158,7 +158,7 @@ struct atmel_uart_port {
 };
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
-static unsigned long atmel_ports_in_use;
+static DECLARE_BITMAP(atmel_ports_in_use, ATMEL_MAX_UART);
 
 #ifdef SUPPORT_SYSRQ
 static struct console atmel_console;
@@ -1768,15 +1768,14 @@ static int atmel_serial_probe(struct pla
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
@@ -1856,7 +1855,7 @@ static int atmel_serial_remove(struct pl
 
 	/* "port" is allocated statically, so we shouldn't free it */
 
-	clear_bit(port->line, &atmel_ports_in_use);
+	clear_bit(port->line, atmel_ports_in_use);
 
 	clk_put(atmel_port->clk);
 


