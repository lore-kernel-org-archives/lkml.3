Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab3CHVq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:46:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab3CHVqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:46:13 -0500
Date: Fri, 8 Mar 2013 13:46:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v3] early_printk: consolidate random copies of identical
 code
Message-Id: <20130308134611.2273ba694f77f6707532485c@linux-foundation.org>
In-Reply-To: <1362759080-26098-1-git-send-email-paul.gortmaker@windriver.com>
References: <alpine.LFD.2.02.1303072330520.22263@ionos>
	<1362759080-26098-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Mar 2013 11:11:20 -0500 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> The early console implementations are the same all over the place.  Move
> the print function to kernel/printk and get rid of the copies.
> 
> ...
> 
> [v3: drop sparc bits as suggested by tglx, redo build tests on sparc
>  sparc32, Randy's randconfig, ppc, mips, arm...]
> 
> [v2: essentially unchanged since v1, so I've left the acked/reviewed
>  tags.  There was a compile fail[1] for a randconfig with EARLY_PRINTK=y
>  and PRINTK=n, because the early_console struct and early_printk calls
>  were nested within an #ifdef CONFIG_PRINTK -- moving that whole block
>  exactly as-is to be outside the #ifdef CONFIG_PRINTK fixes the randconfig
>  and still works for everyday sane configs too.]
>  [1] http://marc.info/?l=linux-next&m=136219350914998&w=2   

I queued the below delta.

I suspect arch/powerpc/kernel/udbg.c is still broken with
CONFIG_EARLY_PRINTK=n?  My powerpc crosscompiler broke and I need to
buy a new one :(

 arch/sparc/kernel/setup_32.c |    1 
 arch/sparc/kernel/setup_64.c |    8 -----
 kernel/printk.c              |   46 ++++++++++++++++-----------------
 3 files changed, 24 insertions(+), 31 deletions(-)

diff -puN arch/sparc/kernel/setup_32.c~early_printk-consolidate-random-copies-of-identical-code-v3 arch/sparc/kernel/setup_32.c
--- a/arch/sparc/kernel/setup_32.c~early_printk-consolidate-random-copies-of-identical-code-v3
+++ a/arch/sparc/kernel/setup_32.c
@@ -309,7 +309,6 @@ void __init setup_arch(char **cmdline_p)
 
 	boot_flags_init(*cmdline_p);
 
-	early_console = &prom_early_console;
 	register_console(&prom_early_console);
 
 	printk("ARCH: ");
diff -puN arch/sparc/kernel/setup_64.c~early_printk-consolidate-random-copies-of-identical-code-v3 arch/sparc/kernel/setup_64.c
--- a/arch/sparc/kernel/setup_64.c~early_printk-consolidate-random-copies-of-identical-code-v3
+++ a/arch/sparc/kernel/setup_64.c
@@ -551,12 +551,6 @@ static void __init init_sparc64_elf_hwca
 		pause_patch();
 }
 
-static inline void register_prom_console(void)
-{
-	early_console = &prom_early_console;
-	register_console(&prom_early_console);
-}
-
 void __init setup_arch(char **cmdline_p)
 {
 	/* Initialize PROM console and command line. */
@@ -568,7 +562,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_EARLYFB
 	if (btext_find_display())
 #endif
-		register_prom_console();
+		register_console(&prom_early_console);
 
 	if (tlb_type == hypervisor)
 		printk("ARCH: SUN4V\n");
diff -puN kernel/printk.c~early_printk-consolidate-random-copies-of-identical-code-v3 kernel/printk.c
--- a/kernel/printk.c~early_printk-consolidate-random-copies-of-identical-code-v3
+++ a/kernel/printk.c
@@ -759,29 +759,6 @@ module_param(ignore_loglevel, bool, S_IR
 MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
 	"print all kernel messages to the console.");
 
-#ifdef CONFIG_EARLY_PRINTK
-struct console *early_console;
-
-void early_vprintk(const char *fmt, va_list ap)
-{
-	if (early_console) {
-		char buf[512];
-		int n = vscnprintf(buf, sizeof(buf), fmt, ap);
-
-		early_console->write(early_console, buf, n);
-	}
-}
-
-asmlinkage void early_printk(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	early_vprintk(fmt, ap);
-	va_end(ap);
-}
-#endif
-
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static int boot_delay; /* msecs delay after each printk during bootup */
@@ -1743,6 +1720,29 @@ static size_t cont_print_text(char *text
 
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
_

