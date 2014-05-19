Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaESS1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:27:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49274 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaESS1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:27:53 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] printk: Use symbolic defines for console loglevels
Date: Mon, 19 May 2014 20:27:32 +0200
Message-Id: <1400524052-25625-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... instead of naked numbers.

Stuff in sysrq.c used to set it to 8 which is supposed to mean above
default level so set it to DEBUG instead as we're terminating/killing
all tasks and we want to be verbose there.

There should be no functionality change resulting from this patch.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: x86@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net
Cc: Hedi Berriche <hedi@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head64.c      |  2 +-
 arch/x86/platform/uv/uv_nmi.c |  2 +-
 drivers/nubus/nubus.c         | 18 +++++++++---------
 drivers/tty/sysrq.c           |  8 ++++----
 include/linux/printk.h        | 15 +++++++++++++--
 init/main.c                   |  4 ++--
 kernel/debug/kdb/kdb_bt.c     |  2 +-
 kernel/debug/kdb/kdb_io.c     |  2 +-
 kernel/debug/kdb/kdb_main.c   |  2 +-
 kernel/printk/printk.c        | 13 +++----------
 10 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 068054f4bf20..eda1a865641e 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -172,7 +172,7 @@ asmlinkage __visible void __init x86_64_start_kernel(char * real_mode_data)
 	 */
 	load_ucode_bsp();
 
-	if (console_loglevel == 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		early_printk("Kernel alive\n");
 
 	clear_page(init_level4_pgt);
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index be27da60dc8f..c89c93320c12 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -85,7 +85,7 @@ static cpumask_var_t uv_nmi_cpu_mask;
  * Default is all stack dumps go to the console and buffer.
  * Lower level to send to log buffer only.
  */
-static int uv_nmi_loglevel = 7;
+static int uv_nmi_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
 module_param_named(dump_loglevel, uv_nmi_loglevel, int, 0644);
 
 /*
diff --git a/drivers/nubus/nubus.c b/drivers/nubus/nubus.c
index 43926cd25ae8..5066a7ef7b6c 100644
--- a/drivers/nubus/nubus.c
+++ b/drivers/nubus/nubus.c
@@ -473,7 +473,7 @@ static struct nubus_dev* __init
 	if (slot == 0 && (unsigned long)dir.base % 2)
 		dir.base += 1;
 	
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_functional_resource: parent is 0x%p, dir is 0x%p\n",
 		       parent->base, dir.base);
 
@@ -568,7 +568,7 @@ static int __init nubus_get_vidnames(struct nubus_board* board,
 
 	printk(KERN_INFO "    video modes supported:\n");
 	nubus_get_subdir(parent, &dir);
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_vidnames: parent is 0x%p, dir is 0x%p\n",
 		       parent->base, dir.base);
 
@@ -629,7 +629,7 @@ static int __init nubus_get_vendorinfo(struct nubus_board* board,
 
 	printk(KERN_INFO "    vendor info:\n");
 	nubus_get_subdir(parent, &dir);
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_vendorinfo: parent is 0x%p, dir is 0x%p\n",
 		       parent->base, dir.base);
 
@@ -654,7 +654,7 @@ static int __init nubus_get_board_resource(struct nubus_board* board, int slot,
 	struct nubus_dirent ent;
 	
 	nubus_get_subdir(parent, &dir);
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_board_resource: parent is 0x%p, dir is 0x%p\n",
 		       parent->base, dir.base);
 
@@ -753,19 +753,19 @@ static void __init nubus_find_rom_dir(struct nubus_board* board)
 	if (nubus_readdir(&dir, &ent) == -1)
 		goto badrom;
 
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_INFO "nubus_get_rom_dir: entry %02x %06x\n", ent.type, ent.data);
 	/* This one takes us to where we want to go. */
 	if (nubus_readdir(&dir, &ent) == -1) 
 		goto badrom;
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_rom_dir: entry %02x %06x\n", ent.type, ent.data);
 	nubus_get_subdir(&ent, &dir);
 
 	/* Resource ID 01, also an "Unknown Macintosh" */
 	if (nubus_readdir(&dir, &ent) == -1) 
 		goto badrom;
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_rom_dir: entry %02x %06x\n", ent.type, ent.data);
 
 	/* FIXME: the first one is *not* always the right one.  We
@@ -780,7 +780,7 @@ static void __init nubus_find_rom_dir(struct nubus_board* board)
 	   path to that address... */
 	if (nubus_readdir(&dir, &ent) == -1)
 		goto badrom;
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_rom_dir: entry %02x %06x\n", ent.type, ent.data);
 	
 	/* Bwahahahaha... */
@@ -816,7 +816,7 @@ static struct nubus_board* __init nubus_add_board(int slot, int bytelanes)
 	board->fblock = rp;
 
 	/* Dump the format block for debugging purposes */
-	if (console_loglevel >= 10) {
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG) {
 		int i;
 		printk(KERN_DEBUG "Slot %X, format block at 0x%p\n",
 		       slot, rp);
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index ce396ecdf412..b767a64e49d9 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -88,7 +88,7 @@ static void sysrq_handle_loglevel(int key)
 	int i;
 
 	i = key - '0';
-	console_loglevel = 7;
+	console_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
 	printk("Loglevel set to %d\n", i);
 	console_loglevel = i;
 }
@@ -343,7 +343,7 @@ static void send_sig_all(int sig)
 static void sysrq_handle_term(int key)
 {
 	send_sig_all(SIGTERM);
-	console_loglevel = 8;
+	console_loglevel = CONSOLE_LOGLEVEL_DEBUG;
 }
 static struct sysrq_key_op sysrq_term_op = {
 	.handler	= sysrq_handle_term,
@@ -387,7 +387,7 @@ static struct sysrq_key_op sysrq_thaw_op = {
 static void sysrq_handle_kill(int key)
 {
 	send_sig_all(SIGKILL);
-	console_loglevel = 8;
+	console_loglevel = CONSOLE_LOGLEVEL_DEBUG;
 }
 static struct sysrq_key_op sysrq_kill_op = {
 	.handler	= sysrq_handle_kill,
@@ -520,7 +520,7 @@ void __handle_sysrq(int key, bool check_mask)
 	 * routing in the consumers of /proc/kmsg.
 	 */
 	orig_log_level = console_loglevel;
-	console_loglevel = 7;
+	console_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
 	printk(KERN_INFO "SysRq : ");
 
         op_p = __sysrq_get_key_op(key);
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
 
diff --git a/kernel/debug/kdb/kdb_bt.c b/kernel/debug/kdb/kdb_bt.c
index b03e0e814e43..fe15fff5df53 100644
--- a/kernel/debug/kdb/kdb_bt.c
+++ b/kernel/debug/kdb/kdb_bt.c
@@ -21,7 +21,7 @@
 static void kdb_show_stack(struct task_struct *p, void *addr)
 {
 	int old_lvl = console_loglevel;
-	console_loglevel = 15;
+	console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
 	kdb_trap_printk++;
 	kdb_set_current_task(p);
 	if (addr) {
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 14ff4849262c..7c70812caea5 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -710,7 +710,7 @@ kdb_printit:
 	}
 	if (logging) {
 		saved_loglevel = console_loglevel;
-		console_loglevel = 0;
+		console_loglevel = CONSOLE_LOGLEVEL_SILENT;
 		printk(KERN_INFO "%s", kdb_buffer);
 	}
 
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 0b097c8a1e50..2f7c760305ca 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1091,7 +1091,7 @@ static int kdb_reboot(int argc, const char **argv)
 static void kdb_dumpregs(struct pt_regs *regs)
 {
 	int old_lvl = console_loglevel;
-	console_loglevel = 15;
+	console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
 	kdb_trap_printk++;
 	show_regs(regs);
 	kdb_trap_printk--;
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
1.9.0

