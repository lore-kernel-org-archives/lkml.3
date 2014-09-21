Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaIUQ1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:27:37 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:65391 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaIUQ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:27:31 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel@axis.com, Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 1/8] cris: Add support for early console
Date: Sun, 21 Sep 2014 09:27:11 -0700
Message-Id: <1411316838-15135-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
References: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/cris/arch-v32/kernel/debugport.c | 41 +++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/cris/arch-v32/kernel/debugport.c b/arch/cris/arch-v32/kernel/debugport.c
index 610909b..7e46d87 100644
--- a/arch/cris/arch-v32/kernel/debugport.c
+++ b/arch/cris/arch-v32/kernel/debugport.c
@@ -4,6 +4,7 @@
 
 #include <linux/console.h>
 #include <linux/init.h>
+
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/reg_map.h>
 #include <hwregs/ser_defs.h>
@@ -190,12 +191,52 @@ putDebugChar(int val)
 }
 #endif /* CONFIG_ETRAX_KGDB */
 
+static void __init early_putch(int c)
+{
+	reg_ser_r_stat_din stat;
+	/* Wait until transmitter is ready and send. */
+	do
+		stat = REG_RD(ser, port->instance, r_stat_din);
+	while (!stat.tr_rdy);
+	REG_WR_INT(ser, port->instance, rw_dout, c);
+}
+
+static void __init
+early_console_write(struct console *con, const char *s, unsigned n)
+{
+	extern void reset_watchdog(void);
+	int i;
+
+	/* Send data. */
+	for (i = 0; i < n; i++) {
+		/*
+		 * TODO: the '\n' -> '\n\r' translation should be done at the
+		 * receiver. Remove it when the serial driver removes it.
+		 */
+		if (s[i] == '\n')
+			early_putch('\r');
+		early_putch(s[i]);
+		reset_watchdog();
+	}
+}
+
+static struct console early_console_dev __initdata = {
+	.name	= "early",
+	.write	= early_console_write,
+	.flags	= CON_PRINTBUFFER | CON_BOOT,
+	.index	= -1
+};
+
 /* Register console for printk's, etc. */
 int __init
 init_etrax_debug(void)
 {
         start_port(port);
 
+	/* Register an early console if a debug port was chosen */
+	if (port)
+		register_console(&early_console_dev);
+
 #ifdef CONFIG_ETRAX_KGDB
 	start_port(kgdb_port);
 #endif /* CONFIG_ETRAX_KGDB */
-- 
1.9.1

