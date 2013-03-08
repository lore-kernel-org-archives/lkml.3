Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934339Ab3CHQNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:13:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:49296 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759797Ab3CHQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:13:21 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH v3] early_printk: consolidate random copies of identical code
Date: Fri, 8 Mar 2013 11:11:20 -0500
Message-ID: <1362759080-26098-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <alpine.LFD.2.02.1303072330520.22263@ionos>
References: <alpine.LFD.2.02.1303072330520.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The early console implementations are the same all over the place.  Move
the print function to kernel/printk and get rid of the copies.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Weinberger <richard@nod.at>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[v3: drop sparc bits as suggested by tglx, redo build tests on sparc
 sparc32, Randy's randconfig, ppc, mips, arm...]

[v2: essentially unchanged since v1, so I've left the acked/reviewed
 tags.  There was a compile fail[1] for a randconfig with EARLY_PRINTK=y
 and PRINTK=n, because the early_console struct and early_printk calls
 were nested within an #ifdef CONFIG_PRINTK -- moving that whole block
 exactly as-is to be outside the #ifdef CONFIG_PRINTK fixes the randconfig
 and still works for everyday sane configs too.]
 [1] http://marc.info/?l=linux-next&m=136219350914998&w=2   


 arch/arm/kernel/early_printk.c        | 17 +++--------------
 arch/blackfin/kernel/early_printk.c   |  2 --
 arch/microblaze/kernel/early_printk.c | 26 ++++----------------------
 arch/mips/kernel/early_printk.c       | 11 +++++------
 arch/powerpc/kernel/udbg.c            |  6 ++----
 arch/sh/kernel/sh_bios.c              |  2 --
 arch/tile/kernel/early_printk.c       | 27 +++++----------------------
 arch/um/kernel/early_printk.c         |  8 +++++---
 arch/unicore32/kernel/early_printk.c  | 12 ++++--------
 arch/x86/kernel/early_printk.c        | 21 ++-------------------
 include/linux/console.h               |  1 +
 include/linux/printk.h                |  6 ++++++
 kernel/printk.c                       | 30 +++++++++++++++++++++++-------
 13 files changed, 60 insertions(+), 109 deletions(-)

diff --git a/arch/arm/kernel/early_printk.c b/arch/arm/kernel/early_printk.c
index 85aa2b2..4307653 100644
--- a/arch/arm/kernel/early_printk.c
+++ b/arch/arm/kernel/early_printk.c
@@ -29,28 +29,17 @@ static void early_console_write(struct console *con, const char *s, unsigned n)
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
 
diff --git a/arch/blackfin/kernel/early_printk.c b/arch/blackfin/kernel/early_printk.c
index 84ed837..61fbd2d 100644
--- a/arch/blackfin/kernel/early_printk.c
+++ b/arch/blackfin/kernel/early_printk.c
@@ -25,8 +25,6 @@ extern struct console *bfin_earlyserial_init(unsigned int port,
 extern struct console *bfin_jc_early_init(void);
 #endif
 
-static struct console *early_console;
-
 /* Default console */
 #define DEFAULT_PORT 0
 #define DEFAULT_CFLAG CS8|B57600
diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
index 60dcacc..365f2d5 100644
--- a/arch/microblaze/kernel/early_printk.c
+++ b/arch/microblaze/kernel/early_printk.c
@@ -21,7 +21,6 @@
 #include <asm/setup.h>
 #include <asm/prom.h>
 
-static u32 early_console_initialized;
 static u32 base_addr;
 
 #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
@@ -109,27 +108,11 @@ static struct console early_serial_uart16550_console = {
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
 	pr_info("early_printk_console remapping from 0x%x to ", base_addr);
 	base_addr = (u32) ioremap(base_addr, PAGE_SIZE);
@@ -194,9 +176,9 @@ void __init remap_early_printk(void)
 
 void __init disable_early_printk(void)
 {
-	if (!early_console_initialized || !early_console)
+	if (!early_console)
 		return;
 	pr_warn("disabling early console\n");
 	unregister_console(early_console);
-	early_console_initialized = 0;
+	early_console = NULL;
 }
diff --git a/arch/mips/kernel/early_printk.c b/arch/mips/kernel/early_printk.c
index 9e6440e..21150cd 100644
--- a/arch/mips/kernel/early_printk.c
+++ b/arch/mips/kernel/early_printk.c
@@ -8,6 +8,7 @@
  *   written by Ralf Baechle (ralf@linux-mips.org)
  */
 #include <linux/console.h>
+#include <linux/printk.h>
 #include <linux/init.h>
 
 #include <asm/setup.h>
@@ -24,20 +25,18 @@ static void early_console_write(struct console *con, const char *s, unsigned n)
 	}
 }
 
-static struct console early_console = {
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
diff --git a/arch/powerpc/kernel/udbg.c b/arch/powerpc/kernel/udbg.c
index f974849..13b8670 100644
--- a/arch/powerpc/kernel/udbg.c
+++ b/arch/powerpc/kernel/udbg.c
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
@@ -174,7 +172,7 @@ void __init register_early_udbg_console(void)
 		printk(KERN_INFO "early console immortal !\n");
 		udbg_console.flags &= ~CON_BOOT;
 	}
-	early_console_initialized = 1;
+	early_console = &udbg_console;
 	register_console(&udbg_console);
 }
 
diff --git a/arch/sh/kernel/sh_bios.c b/arch/sh/kernel/sh_bios.c
index 47475cc..a5b51b9 100644
--- a/arch/sh/kernel/sh_bios.c
+++ b/arch/sh/kernel/sh_bios.c
@@ -144,8 +144,6 @@ static struct console bios_console = {
 	.index		= -1,
 };
 
-static struct console *early_console;
-
 static int __init setup_early_printk(char *buf)
 {
 	int keep_early = 0;
diff --git a/arch/tile/kernel/early_printk.c b/arch/tile/kernel/early_printk.c
index afb9c9a..34d72a1 100644
--- a/arch/tile/kernel/early_printk.c
+++ b/arch/tile/kernel/early_printk.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/irqflags.h>
+#include <linux/printk.h>
 #include <asm/setup.h>
 #include <hv/hypervisor.h>
 
@@ -33,25 +34,8 @@ static struct console early_hv_console = {
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
@@ -85,12 +68,12 @@ static int __init setup_early_printk(char *str)
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
diff --git a/arch/um/kernel/early_printk.c b/arch/um/kernel/early_printk.c
index 49480f0..4a0800b 100644
--- a/arch/um/kernel/early_printk.c
+++ b/arch/um/kernel/early_printk.c
@@ -16,7 +16,7 @@ static void early_console_write(struct console *con, const char *s, unsigned int
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
 
diff --git a/arch/unicore32/kernel/early_printk.c b/arch/unicore32/kernel/early_printk.c
index 3922255..9be0d5d 100644
--- a/arch/unicore32/kernel/early_printk.c
+++ b/arch/unicore32/kernel/early_printk.c
@@ -33,21 +33,17 @@ static struct console early_ocd_console = {
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
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 9b9f18b..d15f575 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -169,25 +169,9 @@ static struct console early_serial_console = {
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
@@ -207,9 +191,8 @@ static int __init setup_early_printk(char *buf)
 	if (!buf)
 		return 0;
 
-	if (early_console_initialized)
+	if (early_console)
 		return 0;
-	early_console_initialized = 1;
 
 	keep = (strstr(buf, "keep") != NULL);
 
diff --git a/include/linux/console.h b/include/linux/console.h
index 29680a8..73bab0f 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -141,6 +141,7 @@ struct console {
 	for (con = console_drivers; con != NULL; con = con->next)
 
 extern int console_set_on_cmdline;
+extern struct console *early_console;
 
 extern int add_preferred_console(char *name, int idx, char *options);
 extern int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options);
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 1249a54..b846afd 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
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
 
 #ifdef CONFIG_PRINTK
 asmlinkage __printf(5, 0)
diff --git a/kernel/printk.c b/kernel/printk.c
index 0b31715..7664e49 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -49,13 +49,6 @@
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
 
@@ -1724,6 +1717,29 @@ static size_t cont_print_text(char *text, size_t size) { return 0; }
 
 #endif /* CONFIG_PRINTK */
 
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
 static int __add_preferred_console(char *name, int idx, char *options,
 				   char *brl_options)
 {
-- 
1.8.1.2

