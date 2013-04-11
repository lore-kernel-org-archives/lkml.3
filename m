Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936365Ab3DKVDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:03:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935638Ab3DKUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:17 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=R0NAWNexx6EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=r3330XQT_fUA:10 a=pGLkceISAAAA:8 a=jAfPOIUMAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=MSl-tDqOz04A:10 a=gE_ZUhsuebIA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202601.838165823@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Pawel Wieczorkiewicz <wpawel@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 096/171 ] tty: atmel_serial_probe(): index of atmel_ports[] fix
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0096-tty-atmel_serial_probe-index-of-atmel_ports-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Pawel Wieczorkiewicz <wpawel@gmail.com>

[ Upstream commit 503bded92da283b2f31d87e054c4c6d30c3c2340 ]

Index of atmel_ports[ATMEL_MAX_UART] should be smaller
than ATMEL_MAX_UART.

Signed-off-by: Pawel Wieczorkiewicz <wpawel@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/serial/atmel_serial.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 3d7e1ee..ed7cd37 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -159,7 +159,7 @@ struct atmel_uart_port {
 };
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
-static unsigned long atmel_ports_in_use;
+static DECLARE_BITMAP(atmel_ports_in_use, ATMEL_MAX_UART);
 
 #ifdef SUPPORT_SYSRQ
 static struct console atmel_console;
@@ -1785,15 +1785,14 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
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
@@ -1867,7 +1866,7 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
 
 	/* "port" is allocated statically, so we shouldn't free it */
 
-	clear_bit(port->line, &atmel_ports_in_use);
+	clear_bit(port->line, atmel_ports_in_use);
 
 	clk_put(atmel_port->clk);
 
-- 
1.7.10.4


