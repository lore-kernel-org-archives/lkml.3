Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaDRWVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:21:32 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:55412 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaDRWUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:20:22 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v2 5/7] tty/serial: add arm/arm64 semihosting earlycon
Date: Fri, 18 Apr 2014 17:19:58 -0500
Message-Id: <1397859600-11507-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Add earlycon support for the arm/arm64 semihosting debug serial
interface. This allows enabling a debug console when early_params are
processed. This is based on the arm64 earlyprintk smh support and is
intended to replace it.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
---
v2:
- Add support for ARM32 semihosting
- Rework the kernel-parameters.txt description
- Update copyright per Catalin.

 Documentation/kernel-parameters.txt        |  2 +
 drivers/tty/serial/Kconfig                 | 10 +++++
 drivers/tty/serial/Makefile                |  1 +
 drivers/tty/serial/earlycon-arm-semihost.c | 61 ++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+)
 create mode 100644 drivers/tty/serial/earlycon-arm-semihost.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 15b5fcca..9e9935a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -906,6 +906,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			must already be setup and configured. Options are not
 			yet supported.
 
+		smh	Use ARM semihosting calls for early console.
+
 	earlyprintk=	[X86,SH,BLACKFIN,ARM]
 			earlyprintk=vga
 			earlyprintk=efi
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index b1b23c2..8cce654 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -73,6 +73,16 @@ config SERIAL_AMBA_PL011_CONSOLE
 	  your boot loader (lilo or loadlin) about how to pass options to the
 	  kernel at boot time.)
 
+config SERIAL_EARLYCON_ARM_SEMIHOST
+	bool "Early console using ARM semihosting"
+	depends on ARM64 || ARM
+	select SERIAL_EARLYCON
+	help
+	  Support for early debug console using ARM semihosting. This enables
+	  the console before standard serial driver is probed. This is enabled
+	  with "earlycon=smh" on the kernel command line. The console is
+	  enabled when early_param is processed.
+
 config SERIAL_SB1250_DUART
 	tristate "BCM1xxx on-chip DUART serial support"
 	depends on SIBYTE_SB1xxx_SOC=y
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
index 0000000..383db10
--- /dev/null
+++ b/drivers/tty/serial/earlycon-arm-semihost.c
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * Adapted for ARM and earlycon:
+ * Copyright (C) 2014 Linaro Ltd.
+ * Author: Rob Herring <robh@kernel.org>
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
+#ifdef CONFIG_THUMB2_KERNEL
+#define SEMIHOST_SWI	"0xab"
+#else
+#define SEMIHOST_SWI	"0x123456"
+#endif
+
+/*
+ * Semihosting-based debug console
+ */
+static void smh_putc(struct uart_port *port, int c)
+{
+#ifdef CONFIG_ARM64
+	asm volatile("mov  x1, %0\n"
+		     "mov  x0, #3\n"
+		     "hlt  0xf000\n"
+		     : : "r" (&c) : "x0", "x1", "memory");
+#else
+	asm volatile("mov  r1, %0\n"
+		     "mov  r0, #3\n"
+		     "svc  " SEMIHOST_SWI "\n"
+		     : : "r" (&c) : "r0", "r1", "memory");
+#endif
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
1.9.1

