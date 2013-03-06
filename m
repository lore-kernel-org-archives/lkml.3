Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab3CFXwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:52:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab3CFXwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:52:35 -0500
Date: Wed, 6 Mar 2013 15:52:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-Id: <20130306155233.3598a39ef5a99c4daf4fbc81@linux-foundation.org>
In-Reply-To: <20130304141051.a630590df1007f2d349a2d8a@canb.auug.org.au>
References: <20130304141051.a630590df1007f2d349a2d8a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013 14:10:51 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> arch/sparc/built-in.o: In function `setup_arch':
> (.init.text+0xc38): undefined reference to `early_console'
> arch/sparc/built-in.o: In function `setup_arch':
> (.init.text+0xc44): undefined reference to `early_console'
> 
> Caused by commit 16ac99bd7acd ("early_printk: consolidate random copies
> of identical code").  This build does not have CONFIG_EARLY_PRINTK defined.

Yes, it looks like some ifdeffing is needed in
arch/sparc/kernel/setup_32.c and in arch/sparc/kernel/setup_64.c.  And
I suspect arch/powerpc/kernel/udbg.c will break with
CONFIG_EARLY_PRINTK=n.

> I have reverted that commit for today.

I had a shot at fixing it all but I'm not very confident in the result,
so I guess I'll drop it as well.

diff -puN arch/powerpc/kernel/udbg.c~early_printk-consolidate-random-copies-of-identical-code-fix arch/powerpc/kernel/udbg.c
--- a/arch/powerpc/kernel/udbg.c~early_printk-consolidate-random-copies-of-identical-code-fix
+++ a/arch/powerpc/kernel/udbg.c
@@ -162,9 +162,10 @@ static struct console udbg_console = {
  */
 void __init register_early_udbg_console(void)
 {
+#ifdef CONFIG_EARLY_PRINTK
 	if (early_console)
 		return;
-
+#endif
 	if (!udbg_putc)
 		return;
 
diff -puN arch/sparc/kernel/setup_32.c~early_printk-consolidate-random-copies-of-identical-code-fix arch/sparc/kernel/setup_32.c
--- a/arch/sparc/kernel/setup_32.c~early_printk-consolidate-random-copies-of-identical-code-fix
+++ a/arch/sparc/kernel/setup_32.c
@@ -108,6 +108,7 @@ unsigned long cmdline_memory_size __init
 /* which CPU booted us (0xff = not set) */
 unsigned char boot_cpu_id = 0xff; /* 0xff will make it into DATA section... */
 
+#ifdef CONFIG_EARLY_PRINTK
 static void
 prom_console_write(struct console *con, const char *s, unsigned n)
 {
@@ -120,6 +121,7 @@ static struct console prom_early_console
 	.flags =	CON_PRINTBUFFER | CON_BOOT,
 	.index =	-1,
 };
+#endif
 
 /* 
  * Process kernel command line switches that are specific to the
@@ -138,7 +140,9 @@ static void __init process_switch(char c
 		prom_halt();
 		break;
 	case 'p':
+#ifdef CONFIG_EARLY_PRINTK
 		prom_early_console.flags &= ~CON_BOOT;
+#endif
 		break;
 	default:
 		printk("Unknown boot switch (-%c)\n", c);
@@ -309,8 +313,10 @@ void __init setup_arch(char **cmdline_p)
 
 	boot_flags_init(*cmdline_p);
 
+#ifdef CONFIG_EARLY_PRINTK
 	early_console = &prom_early_console;
 	register_console(&prom_early_console);
+#endif
 
 	printk("ARCH: ");
 	switch(sparc_cpu_model) {
diff -puN arch/sparc/kernel/setup_64.c~early_printk-consolidate-random-copies-of-identical-code-fix arch/sparc/kernel/setup_64.c
--- a/arch/sparc/kernel/setup_64.c~early_printk-consolidate-random-copies-of-identical-code-fix
+++ a/arch/sparc/kernel/setup_64.c
@@ -75,21 +75,23 @@ struct screen_info screen_info = {
 	16                      /* orig-video-points */
 };
 
+/* Exported for mm/init.c:paging_init. */
+unsigned long cmdline_memory_size = 0;
+
+#ifdef CONFIG_EARLY_PRINTK
 static void
 prom_console_write(struct console *con, const char *s, unsigned n)
 {
 	prom_write(s, n);
 }
 
-/* Exported for mm/init.c:paging_init. */
-unsigned long cmdline_memory_size = 0;
-
 static struct console prom_early_console = {
 	.name =		"earlyprom",
 	.write =	prom_console_write,
 	.flags =	CON_PRINTBUFFER | CON_BOOT | CON_ANYTIME,
 	.index =	-1,
 };
+#endif
 
 /* 
  * Process kernel command line switches that are specific to the
@@ -106,7 +108,9 @@ static void __init process_switch(char c
 		prom_halt();
 		break;
 	case 'p':
+#ifdef CONFIG_EARLY_PRINTK
 		prom_early_console.flags &= ~CON_BOOT;
+#endif
 		break;
 	case 'P':
 		/* Force UltraSPARC-III P-Cache on. */
@@ -551,11 +555,17 @@ static void __init init_sparc64_elf_hwca
 		pause_patch();
 }
 
+#ifdef CONFIG_EARLY_PRINTK
 static inline void register_prom_console(void)
 {
 	early_console = &prom_early_console;
 	register_console(&prom_early_console);
 }
+#else
+static inline void register_prom_console(void)
+{
+}
+#endif
 
 void __init setup_arch(char **cmdline_p)
 {
_

