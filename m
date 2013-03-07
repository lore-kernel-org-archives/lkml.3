Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab3CGTZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 14:25:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab3CGTZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 14:25:38 -0500
Date: Thu, 7 Mar 2013 11:25:36 -0800
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
Subject: Re: [PATCH v2] early_printk: consolidate random copies of identical
 code
Message-Id: <20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
In-Reply-To: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com>
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Mar 2013 14:15:54 -0500 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> [v2: essentially unchanged since v1, so I've left the acked/reviewed
>  tags.  There was a compile fail[1] for a randconfig with EARLY_PRINTK=y
>  and PRINTK=n, because the early_console struct and early_printk calls
>  were nested within an #ifdef CONFIG_PRINTK -- moving that whole block
>  exactly as-is to be outside the #ifdef CONFIG_PRINTK fixes the randconfig
>  and still works for everyday sane configs too.]
>  [1] http://marc.info/?l=linux-next&m=136219350914998&w=2   

You did this:

--- a/kernel/printk.c~early_printk-consolidate-random-copies-of-identical-code-v2
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

Problem is, that won't fix the various compilation problems we've had. 
See yesterday's lkml thread "linux-next: build failure after merge of
the final tree (akpm tree related)"
