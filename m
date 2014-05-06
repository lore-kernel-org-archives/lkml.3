Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbaEFNGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:06:20 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:51500 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbaEFNEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:04:45 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH v4 4/9] kdb: Rename kdb_register_repeat() to kdb_register_flags()
Date: Tue,  6 May 2014 14:03:44 +0100
Message-Id: <1399381429-16194-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
References: <1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>
 <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton.vorontsov@linaro.org>

We're about to add more options for commands behaviour, so let's give
a more generic name to the low-level kdb command registration function.

There are just various renames, no functional changes.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 include/linux/kdb.h         | 10 +++---
 kernel/debug/kdb/kdb_bp.c   | 14 ++++----
 kernel/debug/kdb/kdb_main.c | 86 ++++++++++++++++++++++-----------------------
 kernel/trace/trace_kdb.c    |  2 +-
 4 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index e650f79..32d2f40 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -146,17 +146,17 @@ static inline const char *kdb_walk_kallsyms(loff_t *pos)
 
 /* Dynamic kdb shell command registration */
 extern int kdb_register(char *, kdb_func_t, char *, char *, short);
-extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
-			       short, kdb_cmdflags_t);
+extern int kdb_register_flags(char *, kdb_func_t, char *, char *,
+			      short, kdb_cmdflags_t);
 extern int kdb_unregister(char *);
 #else /* ! CONFIG_KGDB_KDB */
 static inline __printf(1, 2) int kdb_printf(const char *fmt, ...) { return 0; }
 static inline void kdb_init(int level) {}
 static inline int kdb_register(char *cmd, kdb_func_t func, char *usage,
 			       char *help, short minlen) { return 0; }
-static inline int kdb_register_repeat(char *cmd, kdb_func_t func, char *usage,
-				      char *help, short minlen,
-				      kdb_cmdflags_t flags) { return 0; }
+static inline int kdb_register_flags(char *cmd, kdb_func_t func, char *usage,
+				     char *help, short minlen,
+				     kdb_cmdflags_t flags) { return 0; }
 static inline int kdb_unregister(char *cmd) { return 0; }
 #endif	/* CONFIG_KGDB_KDB */
 enum {
diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
index 70a5046..7be2c5d 100644
--- a/kernel/debug/kdb/kdb_bp.c
+++ b/kernel/debug/kdb/kdb_bp.c
@@ -531,21 +531,21 @@ void __init kdb_initbptab(void)
 	for (i = 0, bp = kdb_breakpoints; i < KDB_MAXBPT; i++, bp++)
 		bp->bp_free = 1;
 
-	kdb_register_repeat("bp", kdb_bp, "[<vaddr>]",
+	kdb_register_flags("bp", kdb_bp, "[<vaddr>]",
 		"Set/Display breakpoints", 0, KDB_REPEAT_NO_ARGS);
-	kdb_register_repeat("bl", kdb_bp, "[<vaddr>]",
+	kdb_register_flags("bl", kdb_bp, "[<vaddr>]",
 		"Display breakpoints", 0, KDB_REPEAT_NO_ARGS);
 	if (arch_kgdb_ops.flags & KGDB_HW_BREAKPOINT)
-		kdb_register_repeat("bph", kdb_bp, "[<vaddr>]",
+		kdb_register_flags("bph", kdb_bp, "[<vaddr>]",
 		"[datar [length]|dataw [length]]   Set hw brk", 0, KDB_REPEAT_NO_ARGS);
-	kdb_register_repeat("bc", kdb_bc, "<bpnum>",
+	kdb_register_flags("bc", kdb_bc, "<bpnum>",
 		"Clear Breakpoint", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("be", kdb_bc, "<bpnum>",
+	kdb_register_flags("be", kdb_bc, "<bpnum>",
 		"Enable Breakpoint", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("bd", kdb_bc, "<bpnum>",
+	kdb_register_flags("bd", kdb_bc, "<bpnum>",
 		"Disable Breakpoint", 0, KDB_REPEAT_NONE);
 
-	kdb_register_repeat("ss", kdb_ss, "",
+	kdb_register_flags("ss", kdb_ss, "",
 		"Single Step", 1, KDB_REPEAT_NO_ARGS);
 	/*
 	 * Architecture dependent initialization.
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 5b7b13a..626c6d2 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2636,7 +2636,7 @@ static int kdb_grep_help(int argc, const char **argv)
 }
 
 /*
- * kdb_register_repeat - This function is used to register a kernel
+ * kdb_register_flags - This function is used to register a kernel
  * 	debugger command.
  * Inputs:
  *	cmd	Command name
@@ -2648,12 +2648,12 @@ static int kdb_grep_help(int argc, const char **argv)
  *	zero for success, one if a duplicate command.
  */
 #define kdb_command_extend 50	/* arbitrary */
-int kdb_register_repeat(char *cmd,
-			kdb_func_t func,
-			char *usage,
-			char *help,
-			short minlen,
-			kdb_cmdflags_t flags)
+int kdb_register_flags(char *cmd,
+		       kdb_func_t func,
+		       char *usage,
+		       char *help,
+		       short minlen,
+		       kdb_cmdflags_t flags)
 {
 	int i;
 	kdbtab_t *kp;
@@ -2706,13 +2706,13 @@ int kdb_register_repeat(char *cmd,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kdb_register_repeat);
+EXPORT_SYMBOL_GPL(kdb_register_flags);
 
 
 /*
  * kdb_register - Compatibility register function for commands that do
  *	not need to specify a repeat state.  Equivalent to
- *	kdb_register_repeat with KDB_REPEAT_NONE.
+ *	kdb_register_flags with KDB_REPEAT_NONE.
  * Inputs:
  *	cmd	Command name
  *	func	Function to execute the command
@@ -2727,8 +2727,8 @@ int kdb_register(char *cmd,
 	     char *help,
 	     short minlen)
 {
-	return kdb_register_repeat(cmd, func, usage, help, minlen,
-				   KDB_REPEAT_NONE);
+	return kdb_register_flags(cmd, func, usage, help, minlen,
+				  KDB_REPEAT_NONE);
 }
 EXPORT_SYMBOL_GPL(kdb_register);
 
@@ -2770,79 +2770,79 @@ static void __init kdb_inittab(void)
 	for_each_kdbcmd(kp, i)
 		kp->cmd_name = NULL;
 
-	kdb_register_repeat("md", kdb_md, "<vaddr>",
+	kdb_register_flags("md", kdb_md, "<vaddr>",
 	  "Display Memory Contents, also mdWcN, e.g. md8c1", 1,
 			    KDB_REPEAT_NO_ARGS);
-	kdb_register_repeat("mdr", kdb_md, "<vaddr> <bytes>",
+	kdb_register_flags("mdr", kdb_md, "<vaddr> <bytes>",
 	  "Display Raw Memory", 0, KDB_REPEAT_NO_ARGS);
-	kdb_register_repeat("mdp", kdb_md, "<paddr> <bytes>",
+	kdb_register_flags("mdp", kdb_md, "<paddr> <bytes>",
 	  "Display Physical Memory", 0, KDB_REPEAT_NO_ARGS);
-	kdb_register_repeat("mds", kdb_md, "<vaddr>",
+	kdb_register_flags("mds", kdb_md, "<vaddr>",
 	  "Display Memory Symbolically", 0, KDB_REPEAT_NO_ARGS);
-	kdb_register_repeat("mm", kdb_mm, "<vaddr> <contents>",
+	kdb_register_flags("mm", kdb_mm, "<vaddr> <contents>",
 	  "Modify Memory Contents", 0, KDB_REPEAT_NO_ARGS);
-	kdb_register_repeat("go", kdb_go, "[<vaddr>]",
+	kdb_register_flags("go", kdb_go, "[<vaddr>]",
 	  "Continue Execution", 1, KDB_REPEAT_NONE);
-	kdb_register_repeat("rd", kdb_rd, "",
+	kdb_register_flags("rd", kdb_rd, "",
 	  "Display Registers", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("rm", kdb_rm, "<reg> <contents>",
+	kdb_register_flags("rm", kdb_rm, "<reg> <contents>",
 	  "Modify Registers", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("ef", kdb_ef, "<vaddr>",
+	kdb_register_flags("ef", kdb_ef, "<vaddr>",
 	  "Display exception frame", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("bt", kdb_bt, "[<vaddr>]",
+	kdb_register_flags("bt", kdb_bt, "[<vaddr>]",
 	  "Stack traceback", 1, KDB_REPEAT_NONE);
-	kdb_register_repeat("btp", kdb_bt, "<pid>",
+	kdb_register_flags("btp", kdb_bt, "<pid>",
 	  "Display stack for process <pid>", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("bta", kdb_bt, "[D|R|S|T|C|Z|E|U|I|M|A]",
+	kdb_register_flags("bta", kdb_bt, "[D|R|S|T|C|Z|E|U|I|M|A]",
 	  "Backtrace all processes matching state flag", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("btc", kdb_bt, "",
+	kdb_register_flags("btc", kdb_bt, "",
 	  "Backtrace current process on each cpu", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("btt", kdb_bt, "<vaddr>",
+	kdb_register_flags("btt", kdb_bt, "<vaddr>",
 	  "Backtrace process given its struct task address", 0,
 			    KDB_REPEAT_NONE);
-	kdb_register_repeat("env", kdb_env, "",
+	kdb_register_flags("env", kdb_env, "",
 	  "Show environment variables", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("set", kdb_set, "",
+	kdb_register_flags("set", kdb_set, "",
 	  "Set environment variables", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("help", kdb_help, "",
+	kdb_register_flags("help", kdb_help, "",
 	  "Display Help Message", 1, KDB_REPEAT_NONE);
-	kdb_register_repeat("?", kdb_help, "",
+	kdb_register_flags("?", kdb_help, "",
 	  "Display Help Message", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("cpu", kdb_cpu, "<cpunum>",
+	kdb_register_flags("cpu", kdb_cpu, "<cpunum>",
 	  "Switch to new cpu", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("kgdb", kdb_kgdb, "",
+	kdb_register_flags("kgdb", kdb_kgdb, "",
 	  "Enter kgdb mode", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("ps", kdb_ps, "[<flags>|A]",
+	kdb_register_flags("ps", kdb_ps, "[<flags>|A]",
 	  "Display active task list", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("pid", kdb_pid, "<pidnum>",
+	kdb_register_flags("pid", kdb_pid, "<pidnum>",
 	  "Switch to another task", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("reboot", kdb_reboot, "",
+	kdb_register_flags("reboot", kdb_reboot, "",
 	  "Reboot the machine immediately", 0, KDB_REPEAT_NONE);
 #if defined(CONFIG_MODULES)
-	kdb_register_repeat("lsmod", kdb_lsmod, "",
+	kdb_register_flags("lsmod", kdb_lsmod, "",
 	  "List loaded kernel modules", 0, KDB_REPEAT_NONE);
 #endif
 #if defined(CONFIG_MAGIC_SYSRQ)
-	kdb_register_repeat("sr", kdb_sr, "<key>",
+	kdb_register_flags("sr", kdb_sr, "<key>",
 	  "Magic SysRq key", 0, KDB_REPEAT_NONE);
 #endif
 #if defined(CONFIG_PRINTK)
-	kdb_register_repeat("dmesg", kdb_dmesg, "[lines]",
+	kdb_register_flags("dmesg", kdb_dmesg, "[lines]",
 	  "Display syslog buffer", 0, KDB_REPEAT_NONE);
 #endif
 	if (arch_kgdb_ops.enable_nmi) {
-		kdb_register_repeat("disable_nmi", kdb_disable_nmi, "",
+		kdb_register_flags("disable_nmi", kdb_disable_nmi, "",
 		  "Disable NMI entry to KDB", 0, KDB_REPEAT_NONE);
 	}
-	kdb_register_repeat("defcmd", kdb_defcmd, "name \"usage\" \"help\"",
+	kdb_register_flags("defcmd", kdb_defcmd, "name \"usage\" \"help\"",
 	  "Define a set of commands, down to endefcmd", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("kill", kdb_kill, "<-signal> <pid>",
+	kdb_register_flags("kill", kdb_kill, "<-signal> <pid>",
 	  "Send a signal to a process", 0, KDB_REPEAT_NONE);
-	kdb_register_repeat("summary", kdb_summary, "",
+	kdb_register_flags("summary", kdb_summary, "",
 	  "Summarize the system", 4, KDB_REPEAT_NONE);
-	kdb_register_repeat("per_cpu", kdb_per_cpu, "<sym> [<bytes>] [<cpu>]",
+	kdb_register_flags("per_cpu", kdb_per_cpu, "<sym> [<bytes>] [<cpu>]",
 	  "Display per_cpu variables", 3, KDB_REPEAT_NONE);
-	kdb_register_repeat("grephelp", kdb_grep_help, "",
+	kdb_register_flags("grephelp", kdb_grep_help, "",
 	  "Display help on | grep", 0, KDB_REPEAT_NONE);
 }
 
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index bd90e1b..1e3b36c 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -127,7 +127,7 @@ static int kdb_ftdump(int argc, const char **argv)
 
 static __init int kdb_ftrace_register(void)
 {
-	kdb_register_repeat("ftdump", kdb_ftdump, "[skip_#lines] [cpu]",
+	kdb_register_flags("ftdump", kdb_ftdump, "[skip_#lines] [cpu]",
 			    "Dump ftrace log", 0, KDB_REPEAT_NONE);
 	return 0;
 }
-- 
1.9.0

