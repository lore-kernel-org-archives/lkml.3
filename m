Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3JJIoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:44:03 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:46708 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3JJIoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:44:00 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-serial@vger.kernel.org>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] tty/serial: at91: add a fallback option to determine uart/usart property
Date: Thu, 10 Oct 2013 10:43:32 +0200
Message-ID: <64f8f1db6f888456be8ee410a7e9bb9851d070a5.1381394411.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <a58fe8bc7fdd128a2f9cf60785f81ebde4c0c247.1381394411.git.nicolas.ferre@atmel.com>
References: <a58fe8bc7fdd128a2f9cf60785f81ebde4c0c247.1381394411.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On older SoC, the "name" field is not filled in the register map.
Fix the way to figure out if the serial port is an uart or an usart for these
older products (with corresponding properties).

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/tty/serial/atmel_serial.c | 19 ++++++++++++++++++-
 include/linux/atmel_serial.h      |  1 +
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 6b0f75e..c7d99af 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -99,6 +99,7 @@ static void atmel_stop_rx(struct uart_port *port);
 #define UART_PUT_RTOR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_RTOR)
 #define UART_PUT_TTGR(port, v)	__raw_writel(v, (port)->membase + ATMEL_US_TTGR)
 #define UART_GET_IP_NAME(port)	__raw_readl((port)->membase + ATMEL_US_NAME)
+#define UART_GET_IP_VERSION(port) __raw_readl((port)->membase + ATMEL_US_VERSION)
 
  /* PDC registers */
 #define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
@@ -1503,6 +1504,7 @@ static void atmel_get_ip_name(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	int name = UART_GET_IP_NAME(port);
+	u32 version;
 	int usart, uart;
 	/* usart and uart ascii */
 	usart = 0x55534152;
@@ -1517,7 +1519,22 @@ static void atmel_get_ip_name(struct uart_port *port)
 		dev_dbg(port->dev, "This is uart\n");
 		atmel_port->is_usart = false;
 	} else {
-		dev_err(port->dev, "Not supported ip name, set to uart\n");
+		/* fallback for older SoCs: use version field */
+		version = UART_GET_IP_VERSION(port);
+		switch (version) {
+		case 0x302:
+		case 0x10213:
+			dev_dbg(port->dev, "This version is usart\n");
+			atmel_port->is_usart = true;
+			break;
+		case 0x203:
+		case 0x10202:
+			dev_dbg(port->dev, "This version is uart\n");
+			atmel_port->is_usart = false;
+			break;
+		default:
+			dev_err(port->dev, "Not supported ip name nor version, set to uart\n");
+		}
 	}
 }
 
diff --git a/include/linux/atmel_serial.h b/include/linux/atmel_serial.h
index be201ca..00beddf 100644
--- a/include/linux/atmel_serial.h
+++ b/include/linux/atmel_serial.h
@@ -125,5 +125,6 @@
 #define ATMEL_US_IF		0x4c			/* IrDA Filter Register */
 
 #define ATMEL_US_NAME		0xf0			/* Ip Name */
+#define ATMEL_US_VERSION	0xfc			/* Ip Version */
 
 #endif
-- 
1.8.2.2

