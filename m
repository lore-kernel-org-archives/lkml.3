Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3CGC3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:29:10 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:28214
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab3CGC3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:29:08 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Ley Foon Tan <lftan@altera.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Rob Landley <rob@landley.net>
CC: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Ley Foon Tan <lftan@altera.com>
Subject: [PATCH] tty/serial: Add support for Altera serial port
Date: Thu, 7 Mar 2013 10:28:37 +0800
Message-ID: <1362623317-2988-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Altera 8250/16550 compatible serial port.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 .../devicetree/bindings/tty/serial/of-serial.txt   |    3 ++
 drivers/tty/serial/8250/8250.c                     |   23 +++++++++++++++++++-
 drivers/tty/serial/of_serial.c                     |    6 +++++
 include/uapi/linux/serial_core.h                   |    5 +++-
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
index 1e1145c..8f01cb1 100644
--- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
+++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
@@ -11,6 +11,9 @@ Required properties:
 	- "nvidia,tegra20-uart"
 	- "nxp,lpc3220-uart"
 	- "ibm,qpace-nwp-serial"
+	- "altr,16550-FIFO32"
+	- "altr,16550-FIFO64"
+	- "altr,16550-FIFO128"
 	- "serial" if the port type is unknown.
 - reg : offset and length of the register set for the device.
 - interrupts : should contain uart interrupt.
diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 0efc815..661096d 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -301,7 +301,28 @@ static const struct serial8250_config uart_config[] = {
 	},
 	[PORT_8250_CIR] = {
 		.name		= "CIR port"
-	}
+	},
+	[PORT_ALTR_16550_F32] = {
+		.name		= "Altera 16550 FIFO32",
+		.fifo_size	= 32,
+		.tx_loadsz	= 32,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
+	},
+	[PORT_ALTR_16550_F64] = {
+		.name		= "Altera 16550 FIFO64",
+		.fifo_size	= 64,
+		.tx_loadsz	= 64,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
+	},
+	[PORT_ALTR_16550_F128] = {
+		.name		= "Altera 16550 FIFO128",
+		.fifo_size	= 128,
+		.tx_loadsz	= 128,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
+	},
 };
 
 /* Uart divisor latch read */
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index d587460..b025d54 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -241,6 +241,12 @@ static struct of_device_id of_platform_serial_table[] = {
 	{ .compatible = "ns16850",  .data = (void *)PORT_16850, },
 	{ .compatible = "nvidia,tegra20-uart", .data = (void *)PORT_TEGRA, },
 	{ .compatible = "nxp,lpc3220-uart", .data = (void *)PORT_LPC3220, },
+	{ .compatible = "altr,16550-FIFO32",
+		.data = (void *)PORT_ALTR_16550_F32, },
+	{ .compatible = "altr,16550-FIFO64",
+		.data = (void *)PORT_ALTR_16550_F64, },
+	{ .compatible = "altr,16550-FIFO128",
+		.data = (void *)PORT_ALTR_16550_F128, },
 #ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
 	{ .compatible = "ibm,qpace-nwp-serial",
 		.data = (void *)PORT_NWPSERIAL, },
diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
index b6a23a4..74c2bf7 100644
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@ -51,7 +51,10 @@
 #define PORT_8250_CIR	23	/* CIR infrared port, has its own driver */
 #define PORT_XR17V35X	24	/* Exar XR17V35x UARTs */
 #define PORT_BRCM_TRUMANAGE	25
-#define PORT_MAX_8250	25	/* max port ID */
+#define PORT_ALTR_16550_F32 26	/* Altera 16550 UART with 32 FIFOs */
+#define PORT_ALTR_16550_F64 27	/* Altera 16550 UART with 64 FIFOs */
+#define PORT_ALTR_16550_F128 28 /* Altera 16550 UART with 128 FIFOs */
+#define PORT_MAX_8250	28	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
-- 
1.7.7.4


