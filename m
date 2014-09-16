Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbaIPAW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:22:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42722 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaIPAWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:22:54 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v2] tty: serial: msm: Add earlycon support
Date: Mon, 15 Sep 2014 17:22:51 -0700
Message-Id: <1410826971-2943-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for DT based and command line based early console on platforms
with the msm serial hardware.

Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Changes since v1:
 * Add kernel commandline support

 Documentation/kernel-parameters.txt | 12 ++++++
 drivers/tty/serial/Kconfig          |  1 +
 drivers/tty/serial/msm_serial.c     | 74 +++++++++++++++++++++++++++++++------
 3 files changed, 75 insertions(+), 12 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5ae8608ca9f5..22302931e9d4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -936,6 +936,18 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			must already be setup and configured. Options are not
 			yet supported.
 
+		msm_serial,<addr>
+			Start an early, polled-mode console on an msm serial
+			port at the specified address. The serial port
+			must already be setup and configured. Options are not
+			yet supported.
+
+		msm_serial_dm,<addr>
+			Start an early, polled-mode console on an msm serial
+			dm port at the specified address. The serial port
+			must already be setup and configured. Options are not
+			yet supported.
+
 		smh	Use ARM semihosting calls for early console.
 
 	earlyprintk=	[X86,SH,BLACKFIN,ARM,M68k]
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 81f6ee7d4223..d609d605f712 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1070,6 +1070,7 @@ config SERIAL_MSM_CONSOLE
 	bool "MSM serial console support"
 	depends on SERIAL_MSM=y
 	select SERIAL_CORE_CONSOLE
+	select SERIAL_EARLYCON
 
 config SERIAL_MSM_HS
 	tristate "MSM UART High Speed: Serial Driver"
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 4f9640d0b1bb..4b6c78331a64 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -845,22 +845,15 @@ static inline struct uart_port *get_port_from_line(unsigned int line)
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
@@ -872,7 +865,7 @@ static void msm_console_write(struct console *co, const char *s,
 	count += num_newlines;
 
 	spin_lock(&port->lock);
-	if (msm_port->is_uartdm)
+	if (is_uartdm)
 		reset_dm_count(port, count);
 
 	i = 0;
@@ -881,7 +874,7 @@ static void msm_console_write(struct console *co, const char *s,
 		unsigned int num_chars;
 		char buf[4] = { 0 };
 
-		if (msm_port->is_uartdm)
+		if (is_uartdm)
 			num_chars = min(count - i, (unsigned int)sizeof(buf));
 		else
 			num_chars = 1;
@@ -910,6 +903,20 @@ static void msm_console_write(struct console *co, const char *s,
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
@@ -952,6 +959,49 @@ static int __init msm_console_setup(struct console *co, char *options)
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
+EARLYCON_DECLARE(msm_serial, msm_serial_early_console_setup);
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
+EARLYCON_DECLARE(msm_serial_dm, msm_serial_early_console_setup_dm);
+OF_EARLYCON_DECLARE(msm_serial_dm, "qcom,msm-uartdm",
+		    msm_serial_early_console_setup_dm);
+
 static struct uart_driver msm_uart_driver;
 
 static struct console msm_console = {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

