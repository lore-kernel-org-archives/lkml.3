Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaCUVKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:10:03 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:64267 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaCUVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:09:51 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh@kernel.org>
Subject: [PATCH 7/8] tty/serial: add arm64 semihosting earlycon
Date: Fri, 21 Mar 2014 16:08:47 -0500
Message-Id: <1395436128-11244-8-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Add earlycon support for the arm64 semihosting debug serial interface.
This allows enabling a debug console when early_params are processed.
This is based on the arm64 earlyprintk smh support and is intended to
replace it.

This is named arm rather than arm64 in hopes it will be used for both,
but only arm64 is supported ATM.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
---
 Documentation/kernel-parameters.txt        |  1 +
 drivers/tty/serial/Kconfig                 | 17 +++++++++---
 drivers/tty/serial/Makefile                |  1 +
 drivers/tty/serial/earlycon-arm-semihost.c | 44 ++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 4 deletions(-)
 create mode 100644 drivers/tty/serial/earlycon-arm-semihost.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 81bdd52..e96e2ba 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -888,6 +888,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 		uart[8250],mmio,<addr>[,options]
 		uart[8250],mmio32,<addr>[,options]
 		pl011,<addr>
+		smh
 			Start an early, polled-mode console on a serial port
 			at the specified I/O port or MMIO address. 8250
 			MMIO inter-register address stride is either 8-bit
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 1685189..8b8f40e 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -14,6 +14,15 @@ config SERIAL_EARLYCON
 	  the console before standard serial driver is probed. The console is
 	  enabled when early_param is processed.
 
+config SERIAL_EARLYCON_ARM_SEMIHOST
+	bool "Early console using ARM64 semihosting"
+	depends on ARM64
+	help
+	  Support for early debug console using ARM64 semihosting. This enables
+	  the console before standard serial driver is probed. This is enabled
+	  with "earlycon=smh" on the kernel command line. The console is
+	  enabled when early_param is processed.
+
 source "drivers/tty/serial/8250/Kconfig"
 
 comment "Non-8250 serial port support"
@@ -230,7 +239,7 @@ config SERIAL_SAMSUNG_UARTS
 	help
 	  Select the number of available UART ports for the Samsung S3C
 	  serial driver
-	
+
 config SERIAL_SAMSUNG_DEBUG
 	bool "Samsung SoC serial debug"
 	depends on SERIAL_SAMSUNG && DEBUG_LL
@@ -666,8 +675,8 @@ config PDC_CONSOLE
 	depends on PARISC && !SERIAL_MUX && VT
 	default n
 	help
-	  Saying Y here will enable the software based PDC console to be 
-	  used as the system console.  This is useful for machines in 
+	  Saying Y here will enable the software based PDC console to be
+	  used as the system console.  This is useful for machines in
 	  which the hardware based console has not been written yet.  The
 	  following steps must be competed to use the PDC console:
 
@@ -858,7 +867,7 @@ config SERIAL_CPM
 	depends on CPM2 || 8xx
 	select SERIAL_CORE
 	help
-	  This driver supports the SCC and SMC serial ports on Motorola 
+	  This driver supports the SCC and SMC serial ports on Motorola
 	  embedded PowerPC that contain a CPM1 (8xx) or CPM2 (8xxx)
 
 config SERIAL_CPM_CONSOLE
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index 8af1415..9965b65 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_SERIAL_CORE) += serial_core.o
 obj-$(CONFIG_SERIAL_21285) += 21285.o
 
 obj-$(CONFIG_SERIAL_EARLYCON) += earlycon.o
+obj-$(CONFIG_SERIAL_EARLYCON_ARM_SEMIHOST) += earlycon-arm-semihost.o
 
 # These Sparc drivers have to appear before others such as 8250
 # which share ttySx minor node space.  Otherwise console device
diff --git a/drivers/tty/serial/earlycon-arm-semihost.c b/drivers/tty/serial/earlycon-arm-semihost.c
new file mode 100644
index 0000000..fecec9a
--- /dev/null
+++ b/drivers/tty/serial/earlycon-arm-semihost.c
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ * Author: Catalin Marinas <catalin.marinas@arm.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/kernel.h>
+#include <linux/console.h>
+#include <linux/init.h>
+#include <linux/serial_core.h>
+
+/*
+ * Semihosting-based debug console
+ */
+static void smh_putc(struct uart_port *port, int c)
+{
+	asm volatile("mov  x1, %0\n"
+		     "mov  x0, #3\n"
+		     "hlt  0xf000\n"
+		     : : "r" (&c) : "x0", "x1", "memory");
+}
+
+static void smh_write(struct console *con, const char *s, unsigned n)
+{
+	struct earlycon_device *dev = con->data;
+	uart_console_write(&dev->port, s, n, smh_putc);
+}
+
+int __init early_smh_setup(struct earlycon_device *device, const char *opt)
+{
+	device->con->write = smh_write;
+	return 0;
+}
+EARLYCON_DECLARE(smh, early_smh_setup);
-- 
1.8.3.2

