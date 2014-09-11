Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaIKWOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:14:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44846 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaIKWOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:14:07 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>
Subject: [PATCH/RESEND] tty: serial: msm: Add DT based earlycon support
Date: Thu, 11 Sep 2014 15:14:04 -0700
Message-Id: <1410473644-19103-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for DT based early console on platforms with the msm
serial hardware.

Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/Kconfig      |  1 +
 drivers/tty/serial/msm_serial.c | 72 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 26cec64dadd7..903a3277fa60 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1051,6 +1051,7 @@ config SERIAL_MSM_CONSOLE
 	bool "MSM serial console support"
 	depends on SERIAL_MSM=y
 	select SERIAL_CORE_CONSOLE
+	select SERIAL_EARLYCON
 
 config SERIAL_MSM_HS
 	tristate "MSM UART High Speed: Serial Driver"
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index c549110509bb..d68faa2e7a6c 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -856,22 +856,15 @@ static inline struct uart_port *get_port_from_line(unsigned int line)
 }
 
 #ifdef CONFIG_SERIAL_MSM_CONSOLE
-static void msm_console_write(struct console *co, const char *s,
-			      unsigned int count)
+static void __msm_console_write(struct uart_port *port, const char *s,
+				unsigned int count, bool is_uartdm)
 {
 	int i;
-	struct uart_port *port;
-	struct msm_port *msm_port;
 	int num_newlines = 0;
 	bool replaced = false;
 	void __iomem *tf;
 
-	BUG_ON(co->index < 0 || co->index >= UART_NR);
-
-	port = get_port_from_line(co->index);
-	msm_port = UART_TO_MSM(port);
-
-	if (msm_port->is_uartdm)
+	if (is_uartdm)
 		tf = port->membase + UARTDM_TF;
 	else
 		tf = port->membase + UART_TF;
@@ -883,7 +876,7 @@ static void msm_console_write(struct console *co, const char *s,
 	count += num_newlines;
 
 	spin_lock(&port->lock);
-	if (msm_port->is_uartdm)
+	if (is_uartdm)
 		reset_dm_count(port, count);
 
 	i = 0;
@@ -892,7 +885,7 @@ static void msm_console_write(struct console *co, const char *s,
 		unsigned int num_chars;
 		char buf[4] = { 0 };
 
-		if (msm_port->is_uartdm)
+		if (is_uartdm)
 			num_chars = min(count - i, (unsigned int)sizeof(buf));
 		else
 			num_chars = 1;
@@ -921,6 +914,20 @@ static void msm_console_write(struct console *co, const char *s,
 	spin_unlock(&port->lock);
 }
 
+static void msm_console_write(struct console *co, const char *s,
+			      unsigned int count)
+{
+	struct uart_port *port;
+	struct msm_port *msm_port;
+
+	BUG_ON(co->index < 0 || co->index >= UART_NR);
+
+	port = get_port_from_line(co->index);
+	msm_port = UART_TO_MSM(port);
+
+	__msm_console_write(port, s, count, msm_port->is_uartdm);
+}
+
 static int __init msm_console_setup(struct console *co, char *options)
 {
 	struct uart_port *port;
@@ -963,6 +970,47 @@ static int __init msm_console_setup(struct console *co, char *options)
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
 
+static void
+msm_serial_early_write(struct console *con, const char *s, unsigned n)
+{
+	struct earlycon_device *dev = con->data;
+
+	__msm_console_write(&dev->port, s, n, false);
+}
+
+static int __init
+msm_serial_early_console_setup(struct earlycon_device *device, const char *opt)
+{
+	if (!device->port.membase)
+		return -ENODEV;
+
+	device->con->write = msm_serial_early_write;
+	return 0;
+}
+OF_EARLYCON_DECLARE(msm_serial, "qcom,msm-uart",
+		    msm_serial_early_console_setup);
+
+static void
+msm_serial_early_write_dm(struct console *con, const char *s, unsigned n)
+{
+	struct earlycon_device *dev = con->data;
+
+	__msm_console_write(&dev->port, s, n, true);
+}
+
+static int __init
+msm_serial_early_console_setup_dm(struct earlycon_device *device,
+				  const char *opt)
+{
+	if (!device->port.membase)
+		return -ENODEV;
+
+	device->con->write = msm_serial_early_write_dm;
+	return 0;
+}
+OF_EARLYCON_DECLARE(msm_serial_dm, "qcom,msm-uartdm",
+		    msm_serial_early_console_setup_dm);
+
 static struct uart_driver msm_uart_driver;
 
 static struct console msm_console = {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

