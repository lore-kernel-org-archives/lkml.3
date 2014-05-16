Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbaEPRtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:49:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54091 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbaEPRth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:49:37 -0400
Date: Fri, 16 May 2014 19:49:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: lkml <linux-kernel@vger.kernel.org>
Cc: x86-ml <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Cleanup console loglevels
Message-ID: <20140516174921.GA18778@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so I was staring at

12544697f12e ("x86_64: be less annoying on boot, v2")

and how naked numbers mean sh*t and how I have to grep sources to find
out what this 10 thing means. So how about the following cleanup? We can
do it this way, we can do accessors and stuff, whatever. But the naked
numbers are plain misleading.

So how about it? I'm asking whether it makes sense first before I go
and replace all tests of console_loglevel with naked numbers around the
tree.

Thanks.

---
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 068054f4bf20..0029d974e431 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -172,7 +172,7 @@ asmlinkage __visible void __init x86_64_start_kernel(char * real_mode_data)
 	 */
 	load_ucode_bsp();
 
-	if (console_loglevel == 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_QUIET)
 		early_printk("Kernel alive\n");
 
 	clear_page(init_level4_pgt);
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 8752f7595b27..0325b231d100 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -30,6 +30,17 @@ static inline const char *printk_skip_level(const char *buffer)
 	return buffer;
 }
 
+/* printk's without a loglevel use this.. */
+#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
+
+/* We show everything that is MORE important than this.. */
+#define CONSOLE_LOGLEVEL_SILENT  0 /* Mum's the word */
+#define CONSOLE_LOGLEVEL_MIN	 1 /* Minimum loglevel we let people use */
+#define CONSOLE_LOGLEVEL_QUIET	 4 /* Shhh ..., when booted with "quiet" */
+#define CONSOLE_LOGLEVEL_DEFAULT 7 /* anything MORE serious than KERN_DEBUG */
+#define CONSOLE_LOGLEVEL_DEBUG	10 /* issue debug messages */
+#define CONSOLE_LOGLEVEL_MOTORMOUTH 15	/* You can't shut this one up */
+
 extern int console_printk[];
 
 #define console_loglevel (console_printk[0])
@@ -39,13 +50,13 @@ extern int console_printk[];
 
 static inline void console_silent(void)
 {
-	console_loglevel = 0;
+	console_loglevel = CONSOLE_LOGLEVEL_SILENT;
 }
 
 static inline void console_verbose(void)
 {
 	if (console_loglevel)
-		console_loglevel = 15;
+		console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
 }
 
 struct va_format {
diff --git a/init/main.c b/init/main.c
index eb0ea86aefde..46923e7e1668 100644
--- a/init/main.c
+++ b/init/main.c
@@ -203,13 +203,13 @@ EXPORT_SYMBOL(loops_per_jiffy);
 
 static int __init debug_kernel(char *str)
 {
-	console_loglevel = 10;
+	console_loglevel = CONSOLE_LOGLEVEL_DEBUG;
 	return 0;
 }
 
 static int __init quiet_kernel(char *str)
 {
-	console_loglevel = 4;
+	console_loglevel = CONSOLE_LOGLEVEL_QUIET;
 	return 0;
 }
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7228258b85ec..9cef0425bdcf 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -54,18 +54,11 @@
 #include "console_cmdline.h"
 #include "braille.h"
 
-/* printk's without a loglevel use this.. */
-#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
-
-/* We show everything that is MORE important than this.. */
-#define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
-#define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
-
 int console_printk[4] = {
-	DEFAULT_CONSOLE_LOGLEVEL,	/* console_loglevel */
+	CONSOLE_LOGLEVEL_DEFAULT,	/* console_loglevel */
 	DEFAULT_MESSAGE_LOGLEVEL,	/* default_message_loglevel */
-	MINIMUM_CONSOLE_LOGLEVEL,	/* minimum_console_loglevel */
-	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
+	CONSOLE_LOGLEVEL_MIN,		/* minimum_console_loglevel */
+	CONSOLE_LOGLEVEL_DEFAULT,	/* default_console_loglevel */
 };
 
 /*

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
