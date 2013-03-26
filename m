Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620Ab3CZQXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:23:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53495 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934669Ab3CZPVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ley Foon Tan <lftan@altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 009/150] tty/serial: Add support for Altera serial port
Date: Tue, 26 Mar 2013 15:18:28 +0000
Message-Id: <1364311249-14454-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ley Foon Tan <lftan@altera.com>

commit e06c93cacb82dd147266fd1bdb2d0a0bd45ff2c1 upstream.

Add support for Altera 8250/16550 compatible serial port.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 .../devicetree/bindings/tty/serial/of-serial.txt    |  3 +++
 drivers/tty/serial/8250/8250.c                      | 21 +++++++++++++++++++++
 drivers/tty/serial/of_serial.c                      |  6 ++++++
 include/linux/serial_core.h                         |  5 ++++-
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
index b8b27b0..3f89cbd 100644
--- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
+++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
@@ -10,6 +10,9 @@ Required properties:
 	- "ns16850"
 	- "nvidia,tegra20-uart"
 	- "ibm,qpace-nwp-serial"
+	- "altr,16550-FIFO32"
+	- "altr,16550-FIFO64"
+	- "altr,16550-FIFO128"
 	- "serial" if the port type is unknown.
 - reg : offset and length of the register set for the device.
 - interrupts : should contain uart interrupt.
diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 5074eb7..d9e2594 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -288,6 +288,27 @@ static const struct serial8250_config uart_config[] = {
 		.tx_loadsz	= 1024,
 		.flags		= UART_CAP_HFIFO,
 	},
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
index 5410c06..6cc4d16 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -208,6 +208,12 @@ static struct of_device_id __devinitdata of_platform_serial_table[] = {
 	{ .compatible = "ns16750",  .data = (void *)PORT_16750, },
 	{ .compatible = "ns16850",  .data = (void *)PORT_16850, },
 	{ .compatible = "nvidia,tegra20-uart", .data = (void *)PORT_TEGRA, },
+	{ .compatible = "altr,16550-FIFO32",
+		.data = (void *)PORT_ALTR_16550_F32, },
+	{ .compatible = "altr,16550-FIFO64",
+		.data = (void *)PORT_ALTR_16550_F64, },
+	{ .compatible = "altr,16550-FIFO128",
+		.data = (void *)PORT_ALTR_16550_F128, },
 #ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
 	{ .compatible = "ibm,qpace-nwp-serial",
 		.data = (void *)PORT_NWPSERIAL, },
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index a3fa4d5..b9d5cd1 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -48,7 +48,10 @@
 #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
 #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
 #define PORT_BRCM_TRUMANAGE	22
-#define PORT_MAX_8250	22	/* max port ID */
+#define PORT_ALTR_16550_F32 23	/* Altera 16550 UART with 32 FIFOs */
+#define PORT_ALTR_16550_F64 24	/* Altera 16550 UART with 64 FIFOs */
+#define PORT_ALTR_16550_F128 25	/* Altera 16550 UART with 128 FIFOs */
+#define PORT_MAX_8250	25	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
-- 
1.8.1.2

