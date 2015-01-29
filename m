Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbbA2LQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:16:29 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:32528 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbbA2LOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:14:37 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 8/9] MIPS, ttyFDC: Add early FDC console support
Date: Thu, 29 Jan 2015 11:14:13 +0000
Message-ID: <1422530054-7976-9-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422530054-7976-1-git-send-email-james.hogan@imgtec.com>
References: <1422530054-7976-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for early console of MIPS Fast Debug Channel (FDC) on
channel 1 with a call very early from the MIPS setup_arch().

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-mips@linux-mips.org
---
 arch/mips/include/asm/cdmm.h | 11 +++++++++++
 arch/mips/kernel/setup.c     |  2 ++
 drivers/tty/Kconfig          | 13 +++++++++++++
 drivers/tty/mips_ejtag_fdc.c | 20 ++++++++++++++++++++
 4 files changed, 46 insertions(+)

diff --git a/arch/mips/include/asm/cdmm.h b/arch/mips/include/asm/cdmm.h
index b7d520f28d30..16e22ce9719f 100644
--- a/arch/mips/include/asm/cdmm.h
+++ b/arch/mips/include/asm/cdmm.h
@@ -84,4 +84,15 @@ void mips_cdmm_driver_unregister(struct mips_cdmm_driver *);
 	module_driver(__mips_cdmm_driver, mips_cdmm_driver_register, \
 			mips_cdmm_driver_unregister)
 
+/* drivers/tty/mips_ejtag_fdc.c */
+
+#ifdef CONFIG_MIPS_EJTAG_FDC_EARLYCON
+int setup_early_fdc_console(void);
+#else
+static inline int setup_early_fdc_console(void)
+{
+	return -ENODEV;
+}
+#endif
+
 #endif /* __ASM_CDMM_H */
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 058929041368..be73c491182b 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -31,6 +31,7 @@
 #include <asm/bootinfo.h>
 #include <asm/bugs.h>
 #include <asm/cache.h>
+#include <asm/cdmm.h>
 #include <asm/cpu.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
@@ -763,6 +764,7 @@ void __init setup_arch(char **cmdline_p)
 	cpu_probe();
 	prom_init();
 
+	setup_early_fdc_console();
 #ifdef CONFIG_EARLY_PRINTK
 	setup_early_printk();
 #endif
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index 39469ca4231c..e0c18e5b7057 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -437,4 +437,17 @@ config MIPS_EJTAG_FDC_TTY
 
 	  If unsure, say N.
 
+config MIPS_EJTAG_FDC_EARLYCON
+	bool "Early FDC console"
+	depends on MIPS_EJTAG_FDC_TTY
+	help
+	  This registers a console on FDC channel 1 very early during boot (from
+	  MIPS arch code). This is useful for bring-up and debugging early boot
+	  issues.
+
+	  Do not enable unless there is a debug probe attached to drain the FDC
+	  TX FIFO.
+
+	  If unsure, say N.
+
 endif # TTY
diff --git a/drivers/tty/mips_ejtag_fdc.c b/drivers/tty/mips_ejtag_fdc.c
index 51672cfe7e45..8d9bf6f90110 100644
--- a/drivers/tty/mips_ejtag_fdc.c
+++ b/drivers/tty/mips_ejtag_fdc.c
@@ -69,6 +69,9 @@
 #define REG_FDSTAT_TXE			BIT(1)	/* Tx Empty */
 #define REG_FDSTAT_TXF			BIT(0)	/* Tx Full */
 
+/* Default channel for the early console */
+#define CONSOLE_CHANNEL      1
+
 #define NUM_TTY_CHANNELS     16
 
 #define RX_BUF_SIZE 1024
@@ -1124,3 +1127,20 @@ static int __init mips_ejtag_fdc_init_console(void)
 	return mips_ejtag_fdc_console_init(&mips_ejtag_fdc_con);
 }
 console_initcall(mips_ejtag_fdc_init_console);
+
+#ifdef CONFIG_MIPS_EJTAG_FDC_EARLYCON
+static struct mips_ejtag_fdc_console mips_ejtag_fdc_earlycon = {
+	.cons	= {
+		.name	= "early_fdc",
+		.write	= mips_ejtag_fdc_console_write,
+		.flags	= CON_PRINTBUFFER | CON_BOOT,
+		.index	= CONSOLE_CHANNEL,
+	},
+	.lock	= __RAW_SPIN_LOCK_UNLOCKED(mips_ejtag_fdc_earlycon.lock),
+};
+
+int __init setup_early_fdc_console(void)
+{
+	return mips_ejtag_fdc_console_init(&mips_ejtag_fdc_earlycon);
+}
+#endif
-- 
2.0.5

