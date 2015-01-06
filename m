Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbbAFDKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 22:10:17 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:41755 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbbAFDKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 22:10:12 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] serial: 8250: Make ISA ports optional
Date: Mon,  5 Jan 2015 22:09:45 -0500
Message-Id: <1420513785-23660-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some arches have no need to create unprobed 8250 ports; these phantom
ports are primarily required for ISA ports which have no probe
mechanism or to provide non-operational ports for userspace to
configure (via TIOCSSERIAL and TIOCSERCONFIG ioctls).

Provide CONFIG_SERIAL_8250_PHANTOM_UARTS knob to disable phantom port
registration; ie., CONFIG_SERIAL_8250_PHANTOM_UARTS=N only registers
probed ports (ACPI/PNP, "serial8250" platform devices, PCI, etc).

Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250.h      |  6 ++++++
 drivers/tty/serial/8250/8250_core.c | 13 +++++++++++--
 drivers/tty/serial/8250/Kconfig     | 24 +++++++++++++++++++-----
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index b008368..bda82f7 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -96,6 +96,12 @@ struct serial8250_config {
 #define SERIAL8250_SHARE_IRQS 0
 #endif
 
+#ifdef CONFIG_SERIAL_8250_PHANTOM_UARTS
+#define SERIAL8250_PHANTOM_UARTS 1
+#else
+#define SERIAL8250_PHANTOM_UARTS 0
+#endif
+
 static inline int serial_in(struct uart_8250_port *up, int offset)
 {
 	return up->port.serial_in(&up->port, offset);
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 3bfcfdb..1b27b2f 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -52,10 +52,13 @@
  * Configuration:
  *   share_irqs - whether we pass IRQF_SHARED to request_irq().  This option
  *                is unsafe when used on edge-triggered interrupts.
+ *   nr_uarts - max # of ports which can be registered
+ *   phantom_uarts - whether we pre-register "nr_uarts". Required for ISA ports
+ *		     and providing unprobed ports for userspace to configure.
  */
 static unsigned int share_irqs = SERIAL8250_SHARE_IRQS;
-
 static unsigned int nr_uarts = CONFIG_SERIAL_8250_RUNTIME_UARTS;
+static unsigned int phantom_uarts = SERIAL8250_PHANTOM_UARTS;
 
 static struct uart_driver serial8250_reg;
 
@@ -3155,6 +3158,9 @@ serial8250_register_ports(struct uart_driver *drv, struct device *dev)
 {
 	int i;
 
+	if (!phantom_uarts)
+		return;
+
 	for (i = 0; i < nr_uarts; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 
@@ -3662,7 +3668,7 @@ void serial8250_unregister_port(int line)
 
 	mutex_lock(&serial_mutex);
 	uart_remove_one_port(&serial8250_reg, &uart->port);
-	if (serial8250_isa_devs) {
+	if (serial8250_isa_devs && phantom_uarts) {
 		uart->port.flags &= ~UPF_BOOT_AUTOCONF;
 		uart->port.type = PORT_UNKNOWN;
 		uart->port.dev = &serial8250_isa_devs->dev;
@@ -3769,6 +3775,9 @@ MODULE_PARM_DESC(share_irqs, "Share IRQs with other non-8250/16x50 devices"
 module_param(nr_uarts, uint, 0644);
 MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-" __MODULE_STRING(CONFIG_SERIAL_8250_NR_UARTS) ")");
 
+module_param(phantom_uarts, uint, 0644);
+MODULE_PARM_DESC(phantom_uarts, "Enable UARTs with no hardware");
+
 module_param(skip_txen_test, uint, 0644);
 MODULE_PARM_DESC(skip_txen_test, "Skip checking for the TXEN bug at init time");
 
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 0fcbcd2..87e649b 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -145,15 +145,29 @@ config SERIAL_8250_NR_UARTS
 	  via hot-plug, or any ISA multi-port serial cards.
 
 config SERIAL_8250_RUNTIME_UARTS
-	int "Number of 8250/16550 serial ports to register at runtime"
+	int "Maximum number of 8250/16550 serial ports to enable"
 	depends on SERIAL_8250
 	range 0 SERIAL_8250_NR_UARTS
 	default "4"
 	help
-	  Set this to the maximum number of serial ports you want
-	  the kernel to register at boot time.  This can be overridden
-	  with the module parameter "nr_uarts", or boot-time parameter
-	  8250.nr_uarts
+	  Set this to the maximum number of 8250/16550 serial ports you
+	  want the kernel to allow. This can be overridden with the module
+	  parameter "nr_uarts", or boot-time parameter, 8250.nr_uarts,
+	  up to the maximum.
+
+config SERIAL_8250_PHANTOM_UARTS
+	bool
+	prompt "Enable phantom 8250/16550 serial ports" if !ISA
+	depends on SERIAL_8250
+	default y
+	---help---
+	  Say Y here to create all 8250/16550 serial ports at module load time.
+	  Saying N here prevents the creation of unprobed ports, but also
+	  disables userspace probe/configure (since no device node is created
+	  for userspace to open). This can be overridden with the module
+	  parameter "phantom_uarts", or boot-time parameter, 8250.phantom_uarts
+
+	  If unsure, say Y.
 
 config SERIAL_8250_EXTENDED
 	bool "Extended 8250/16550 serial driver options"
-- 
2.2.1

