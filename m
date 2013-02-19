Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab3BSMol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:44:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:60906 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab3BSMok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:44:40 -0500
Message-Id: <20130219124038.365937990@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 19 Feb 2013 12:44:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org
Subject: [patch 1/1] early_printk: Consolidate random copies of identical code
Content-Disposition: inline; filename=early-printk-consolidate.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The early console implementations are the same all over the
place. Move the print function to kernel/printk and get rid of the
copies.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org

---
 arch/arm/kernel/early_printk.c        |   17 +++--------------
 arch/blackfin/kernel/early_printk.c   |    2 --
 arch/microblaze/kernel/early_printk.c |   26 ++++----------------------
 arch/mips/kernel/early_printk.c       |   11 +++++------
 arch/powerpc/kernel/udbg.c            |    6 ++----
 arch/sh/kernel/sh_bios.c              |    2 --
 arch/sparc/kernel/setup_32.c          |    1 +
 arch/sparc/kernel/setup_64.c          |    8 +++++++-
 arch/tile/kernel/early_printk.c       |   27 +++++----------------------
 arch/um/kernel/early_printk.c         |    8 +++++---
 arch/unicore32/kernel/early_printk.c  |   12 ++++--------
 arch/x86/kernel/early_printk.c        |   21 ++-------------------
 include/linux/console.h               |    1 +
 include/linux/printk.h                |    6 ++++++
 kernel/printk.c                       |   30 +++++++++++++++++++++++-------
 15 files changed, 68 insertions(+), 110 deletions(-)

Index: linux-stable/arch/arm/kernel/early_printk.c
===================================================================
--- linux-stable.orig/arch/arm/kernel/early_printk.c
+++ linux-stable/arch/arm/kernel/early_printk.c
@@ -29,28 +29,17 @@ static void early_console_write(struct c
 	early_write(s, n);
 }
 
-static struct console early_console = {
+static struct console early_console_dev = {
 	.name =		"earlycon",
 	.write =	early_console_write,
 	.flags =	CON_PRINTBUFFER | CON_BOOT,
 	.index =	-1,
 };
 
-asmlinkage void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	va_start(ap, fmt);
-	n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_write(buf, n);
-	va_end(ap);
-}
-
 static int __init setup_early_printk(char *buf)
 {
-	register_console(&early_console);
+	early_console = &early_console_dev;
+	register_console(&early_console_dev);
 	return 0;
 }
 
Index: linux-stable/arch/blackfin/kernel/early_printk.c
===================================================================
--- linux-stable.orig/arch/blackfin/kernel/early_printk.c
+++ linux-stable/arch/blackfin/kernel/early_printk.c
@@ -25,8 +25,6 @@ extern struct console *bfin_earlyserial_
 extern struct console *bfin_jc_early_init(void);
 #endif
 
-static struct console *early_console;
-
 /* Default console */
 #define DEFAULT_PORT 0
 #define DEFAULT_CFLAG CS8|B57600
Index: linux-stable/arch/microblaze/kernel/early_printk.c
===================================================================
--- linux-stable.orig/arch/microblaze/kernel/early_printk.c
+++ linux-stable/arch/microblaze/kernel/early_printk.c
@@ -21,7 +21,6 @@
 #include <asm/setup.h>
 #include <asm/prom.h>
 
-static u32 early_console_initialized;
 static u32 base_addr;
 
 #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
@@ -109,27 +108,11 @@ static struct console early_serial_uart1
 };
 #endif /* CONFIG_SERIAL_8250_CONSOLE */
 
-static struct console *early_console;
-
-void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	if (early_console_initialized) {
-		va_start(ap, fmt);
-		n = vscnprintf(buf, 512, fmt, ap);
-		early_console->write(early_console, buf, n);
-		va_end(ap);
-	}
-}
-
 int __init setup_early_printk(char *opt)
 {
 	int version = 0;
 
-	if (early_console_initialized)
+	if (early_console)
 		return 1;
 
 	base_addr = of_early_console(&version);
@@ -159,7 +142,6 @@ int __init setup_early_printk(char *opt)
 		}
 
 		register_console(early_console);
-		early_console_initialized = 1;
 		return 0;
 	}
 	return 1;
@@ -169,7 +151,7 @@ int __init setup_early_printk(char *opt)
  * only for early console because of performance degression */
 void __init remap_early_printk(void)
 {
-	if (!early_console_initialized || !early_console)
+	if (!early_console)
 		return;
 	printk(KERN_INFO "early_printk_console remapping from 0x%x to ",
 								base_addr);
@@ -195,9 +177,9 @@ void __init remap_early_printk(void)
 
 void __init disable_early_printk(void)
 {
-	if (!early_console_initialized || !early_console)
+	if (!early_console)
 		return;
 	printk(KERN_WARNING "disabling early console\n");
 	unregister_console(early_console);
-	early_console_initialized = 0;
+	early_console = NULL;
 }
Index: linux-stable/arch/mips/kernel/early_printk.c
===================================================================
--- linux-stable.orig/arch/mips/kernel/early_printk.c
+++ linux-stable/arch/mips/kernel/early_printk.c
@@ -8,6 +8,7 @@
  *   written by Ralf Baechle (ralf@linux-mips.org)
  */
 #include <linux/console.h>
+#include <linux/printk.h>
 #include <linux/init.h>
 
 #include <asm/setup.h>
@@ -25,20 +26,18 @@ early_console_write(struct console *con,
 	}
 }
 
-static struct console early_console __initdata = {
+static struct console early_console_prom = {
 	.name	= "early",
 	.write	= early_console_write,
 	.flags	= CON_PRINTBUFFER | CON_BOOT,
 	.index	= -1
 };
 
-static int early_console_initialized __initdata;
-
 void __init setup_early_printk(void)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return;
-	early_console_initialized = 1;
+	early_console = &early_console_prom;
 
-	register_console(&early_console);
+	register_console(&early_console_prom);
 }
Index: linux-stable/arch/powerpc/kernel/udbg.c
===================================================================
--- linux-stable.orig/arch/powerpc/kernel/udbg.c
+++ linux-stable/arch/powerpc/kernel/udbg.c
@@ -156,15 +156,13 @@ static struct console udbg_console = {
 	.index	= 0,
 };
 
-static int early_console_initialized;
-
 /*
  * Called by setup_system after ppc_md->probe and ppc_md->early_init.
  * Call it again after setting udbg_putc in ppc_md->setup_arch.
  */
 void __init register_early_udbg_console(void)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return;
 
 	if (!udbg_putc)
@@ -174,7 +172,7 @@ void __init register_early_udbg_console(
 		printk(KERN_INFO "early console immortal !\n");
 		udbg_console.flags &= ~CON_BOOT;
 	}
-	early_console_initialized = 1;
+	early_console = &udbg_console;
 	register_console(&udbg_console);
 }
 
Index: linux-stable/arch/sh/kernel/sh_bios.c
===================================================================
--- linux-stable.orig/arch/sh/kernel/sh_bios.c
+++ linux-stable/arch/sh/kernel/sh_bios.c
@@ -144,8 +144,6 @@ static struct console bios_console = {
 	.index		= -1,
 };
 
-static struct console *early_console;
-
 static int __init setup_early_printk(char *buf)
 {
 	int keep_early = 0;
Index: linux-stable/arch/sparc/kernel/setup_32.c
===================================================================
--- linux-stable.orig/arch/sparc/kernel/setup_32.c
+++ linux-stable/arch/sparc/kernel/setup_32.c
@@ -309,6 +309,7 @@ void __init setup_arch(char **cmdline_p)
 
 	boot_flags_init(*cmdline_p);
 
+	early_console = &prom_early_console;
 	register_console(&prom_early_console);
 
 	printk("ARCH: ");
Index: linux-stable/arch/sparc/kernel/setup_64.c
===================================================================
--- linux-stable.orig/arch/sparc/kernel/setup_64.c
+++ linux-stable/arch/sparc/kernel/setup_64.c
@@ -551,6 +551,12 @@ static void __init init_sparc64_elf_hwca
 		pause_patch();
 }
 
+static inline void register_prom_console(void)
+{
+	early_console = &prom_early_console;
+	register_console(&prom_early_console);
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	/* Initialize PROM console and command line. */
@@ -562,7 +568,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_EARLYFB
 	if (btext_find_display())
 #endif
-		register_console(&prom_early_console);
+		register_prom_console();
 
 	if (tlb_type == hypervisor)
 		printk("ARCH: SUN4V\n");
Index: linux-stable/arch/tile/kernel/early_printk.c
===================================================================
--- linux-stable.orig/arch/tile/kernel/early_printk.c
+++ linux-stable/arch/tile/kernel/early_printk.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/irqflags.h>
+#include <linux/printk.h>
 #include <asm/setup.h>
 #include <hv/hypervisor.h>
 
@@ -33,25 +34,8 @@ static struct console early_hv_console =
 };
 
 /* Direct interface for emergencies */
-static struct console *early_console = &early_hv_console;
-static int early_console_initialized;
 static int early_console_complete;
 
-static void early_vprintk(const char *fmt, va_list ap)
-{
-	char buf[512];
-	int n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_console->write(early_console, buf, n);
-}
-
-void early_printk(const char *fmt, ...)
-{
-	va_list ap;
-	va_start(ap, fmt);
-	early_vprintk(fmt, ap);
-	va_end(ap);
-}
-
 void early_panic(const char *fmt, ...)
 {
 	va_list ap;
@@ -69,14 +53,13 @@ static int __initdata keep_early;
 
 static int __init setup_early_printk(char *str)
 {
-	if (early_console_initialized)
+	if (early_console)
 		return 1;
 
 	if (str != NULL && strncmp(str, "keep", 4) == 0)
 		keep_early = 1;
 
 	early_console = &early_hv_console;
-	early_console_initialized = 1;
 	register_console(early_console);
 
 	return 0;
@@ -85,12 +68,12 @@ static int __init setup_early_printk(cha
 void __init disable_early_printk(void)
 {
 	early_console_complete = 1;
-	if (!early_console_initialized || !early_console)
+	if (!early_console)
 		return;
 	if (!keep_early) {
 		early_printk("disabling early console\n");
 		unregister_console(early_console);
-		early_console_initialized = 0;
+		early_console = NULL;
 	} else {
 		early_printk("keeping early console\n");
 	}
@@ -98,7 +81,7 @@ void __init disable_early_printk(void)
 
 void warn_early_printk(void)
 {
-	if (early_console_complete || early_console_initialized)
+	if (early_console_complete || early_console)
 		return;
 	early_printk("\
 Machine shutting down before console output is fully initialized.\n\
Index: linux-stable/arch/um/kernel/early_printk.c
===================================================================
--- linux-stable.orig/arch/um/kernel/early_printk.c
+++ linux-stable/arch/um/kernel/early_printk.c
@@ -16,7 +16,7 @@ static void early_console_write(struct c
 	um_early_printk(s, n);
 }
 
-static struct console early_console = {
+static struct console early_console_dev = {
 	.name = "earlycon",
 	.write = early_console_write,
 	.flags = CON_BOOT,
@@ -25,8 +25,10 @@ static struct console early_console = {
 
 static int __init setup_early_printk(char *buf)
 {
-	register_console(&early_console);
-
+	if (!early_console) {
+		early_console = &early_console_dev;
+		register_console(&early_console_dev);
+	}
 	return 0;
 }
 
Index: linux-stable/arch/unicore32/kernel/early_printk.c
===================================================================
--- linux-stable.orig/arch/unicore32/kernel/early_printk.c
+++ linux-stable/arch/unicore32/kernel/early_printk.c
@@ -33,21 +33,17 @@ static struct console early_ocd_console 
 	.index =	-1,
 };
 
-/* Direct interface for emergencies */
-static struct console *early_console = &early_ocd_console;
-
-static int __initdata keep_early;
-
 static int __init setup_early_printk(char *buf)
 {
-	if (!buf)
+	int keep_early;
+
+	if (!buf || early_console)
 		return 0;
 
 	if (strstr(buf, "keep"))
 		keep_early = 1;
 
-	if (!strncmp(buf, "ocd", 3))
-		early_console = &early_ocd_console;
+	early_console = &early_ocd_console;
 
 	if (keep_early)
 		early_console->flags &= ~CON_BOOT;
Index: linux-stable/arch/x86/kernel/early_printk.c
===================================================================
--- linux-stable.orig/arch/x86/kernel/early_printk.c
+++ linux-stable/arch/x86/kernel/early_printk.c
@@ -169,25 +169,9 @@ static struct console early_serial_conso
 	.index =	-1,
 };
 
-/* Direct interface for emergencies */
-static struct console *early_console = &early_vga_console;
-static int __initdata early_console_initialized;
-
-asmlinkage void early_printk(const char *fmt, ...)
-{
-	char buf[512];
-	int n;
-	va_list ap;
-
-	va_start(ap, fmt);
-	n = vscnprintf(buf, sizeof(buf), fmt, ap);
-	early_console->write(early_console, buf, n);
-	va_end(ap);
-}
-
 static inline void early_console_register(struct console *con, int keep_early)
 {
-	if (early_console->index != -1) {
+	if (con->index != -1) {
 		printk(KERN_CRIT "ERROR: earlyprintk= %s already used\n",
 		       con->name);
 		return;
@@ -207,9 +191,8 @@ static int __init setup_early_printk(cha
 	if (!buf)
 		return 0;
 
-	if (early_console_initialized)
+	if (early_console)
 		return 0;
-	early_console_initialized = 1;
 
 	keep = (strstr(buf, "keep") != NULL);
 
Index: linux-stable/include/linux/console.h
===================================================================
--- linux-stable.orig/include/linux/console.h
+++ linux-stable/include/linux/console.h
@@ -139,6 +139,7 @@ struct console {
 	for (con = console_drivers; con != NULL; con = con->next)
 
 extern int console_set_on_cmdline;
+extern struct console *early_console;
 
 extern int add_preferred_console(char *name, int idx, char *options);
 extern int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options);
Index: linux-stable/include/linux/printk.h
===================================================================
--- linux-stable.orig/include/linux/printk.h
+++ linux-stable/include/linux/printk.h
@@ -95,8 +95,14 @@ int no_printk(const char *fmt, ...)
 	return 0;
 }
 
+#ifdef CONFIG_EARLY_PRINTK
 extern asmlinkage __printf(1, 2)
 void early_printk(const char *fmt, ...);
+void early_vprintk(const char *fmt, va_list ap);
+#else
+static inline __printf(1, 2) __cold
+void early_printk(const char *s, ...) { }
+#endif
 
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
Index: linux-stable/kernel/printk.c
===================================================================
--- linux-stable.orig/kernel/printk.c
+++ linux-stable/kernel/printk.c
@@ -48,13 +48,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
-/*
- * Architectures can override it:
- */
-void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
-{
-}
-
 /* printk's without a loglevel use this.. */
 #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
@@ -756,6 +749,29 @@ module_param(ignore_loglevel, bool, S_IR
 MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
 	"print all kernel messages to the console.");
 
+#ifdef CONFIG_EARLY_PRINTK
+struct console *early_console;
+
+void early_vprintk(const char *fmt, va_list ap)
+{
+	if (early_console) {
+		char buf[512];
+		int n = vscnprintf(buf, sizeof(buf), fmt, ap);
+
+		early_console->write(early_console, buf, n);
+	}
+}
+
+asmlinkage void early_printk(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	early_vprintk(fmt, ap);
+	va_end(ap);
+}
+#endif
+
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static int boot_delay; /* msecs delay after each printk during bootup */


