Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbaEFNEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:04:54 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55442 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaEFNEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:04:50 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: [PATCH v4 7/9] kdb: Categorize kdb commands (similar to SysRq categorization)
Date: Tue,  6 May 2014 14:03:47 +0100
Message-Id: <1399381429-16194-8-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
References: <1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>
 <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces several new flags to collect kdb commands into
groups (later allowing them to be optionally disabled).

This follows similar prior art to enable/disable magic sysrq
commands.

The commands have been categorized as follows:

Always on:  go (w/o args), env, set, help, ?, cpu (w/o args), sr,
            dmesg, disable_nmi, defcmd, summary, grephelp
Mem read:   md, mdr, mdp, mds, ef, bt (with args), per_cpu
Mem write:  mm
Reg read:   rd
Reg write:  go (with args), rm
Inspect:    bt (w/o args), btp, bta, btc, btt, ps, pid, lsmod
Flow ctrl:  bp, bl, bph, bc, be, bd, ss
Signal:     kill
Reboot:     reboot
All:        cpu, kgdb, (and all of the above), nmi_console

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 include/linux/kdb.h         |  68 +++++++++++++++++++++++++++++-
 kernel/debug/kdb/kdb_bp.c   |  21 ++++++----
 kernel/debug/kdb/kdb_main.c | 100 +++++++++++++++++++++++++++++---------------
 kernel/trace/trace_kdb.c    |   2 +-
 4 files changed, 148 insertions(+), 43 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 39b44b3..08f9875 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -13,11 +13,75 @@
  * Copyright (C) 2009 Jason Wessel <jason.wessel@windriver.com>
  */
 
+/* Shifted versions of the command enable bits are be used if the command
+ * has no arguments (see kdb_check_flags). This allows commands, such as
+ * go, to have different permissions depending upon whether it is called
+ * with an argument.
+ */
+#define KDB_ENABLE_NO_ARGS_SHIFT 10
+
 typedef enum {
-	KDB_REPEAT_NO_ARGS	= 0x1, /* Repeat the command w/o arguments */
-	KDB_REPEAT_WITH_ARGS	= 0x2, /* Repeat the command w/ its arguments */
+	KDB_ENABLE_ALL = (1 << 0), /* Enable everything */
+	KDB_ENABLE_MEM_READ = (1 << 1),
+	KDB_ENABLE_MEM_WRITE = (1 << 2),
+	KDB_ENABLE_REG_READ = (1 << 3),
+	KDB_ENABLE_REG_WRITE = (1 << 4),
+	KDB_ENABLE_INSPECT = (1 << 5),
+	KDB_ENABLE_FLOW_CTRL = (1 << 6),
+	KDB_ENABLE_SIGNAL = (1 << 7),
+	KDB_ENABLE_REBOOT = (1 << 8),
+	/* User exposed values stop here, all remaining flags are
+	 * exclusively used to describe a commands behaviour.
+	 */
+
+	KDB_ENABLE_ALWAYS_SAFE = (1 << 9),
+	KDB_ENABLE_MASK = (1 << KDB_ENABLE_NO_ARGS_SHIFT) - 1,
+
+	KDB_ENABLE_ALL_NO_ARGS = KDB_ENABLE_ALL << KDB_ENABLE_NO_ARGS_SHIFT,
+	KDB_ENABLE_MEM_READ_NO_ARGS = KDB_ENABLE_MEM_READ
+				      << KDB_ENABLE_NO_ARGS_SHIFT,
+	KDB_ENABLE_MEM_WRITE_NO_ARGS = KDB_ENABLE_MEM_WRITE
+				       << KDB_ENABLE_NO_ARGS_SHIFT,
+	KDB_ENABLE_REG_READ_NO_ARGS = KDB_ENABLE_REG_READ
+				      << KDB_ENABLE_NO_ARGS_SHIFT,
+	KDB_ENABLE_REG_WRITE_NO_ARGS = KDB_ENABLE_REG_WRITE
+				       << KDB_ENABLE_NO_ARGS_SHIFT,
+	KDB_ENABLE_INSPECT_NO_ARGS = KDB_ENABLE_INSPECT
+				     << KDB_ENABLE_NO_ARGS_SHIFT,
+	KDB_ENABLE_FLOW_CTRL_NO_ARGS = KDB_ENABLE_FLOW_CTRL
+				       << KDB_ENABLE_NO_ARGS_SHIFT,
+	KDB_ENABLE_SIGNAL_NO_ARGS = KDB_ENABLE_SIGNAL
+				    << KDB_ENABLE_NO_ARGS_SHIFT,
+	KDB_ENABLE_REBOOT_NO_ARGS = KDB_ENABLE_REBOOT
+				    << KDB_ENABLE_NO_ARGS_SHIFT,
+	KDB_ENABLE_ALWAYS_SAFE_NO_ARGS = KDB_ENABLE_ALWAYS_SAFE
+					 << KDB_ENABLE_NO_ARGS_SHIFT,
+	KDB_ENABLE_MASK_NO_ARGS = KDB_ENABLE_MASK << KDB_ENABLE_NO_ARGS_SHIFT,
+
+	KDB_REPEAT_NO_ARGS = 0x40000000, /* Repeat the command w/o arguments */
+	KDB_REPEAT_WITH_ARGS = 0x80000000, /* Repeat the command with args */
 } kdb_cmdflags_t;
 
+/*
+ * Check whether the flags of the current command and the permissions
+ * of the kdb console has allow a command to be run.
+ */
+static inline bool kdb_check_flags(kdb_cmdflags_t flags, int permissions,
+				   bool no_args)
+{
+	/* permissions comes from userspace so needs massaging slightly */
+	permissions &= KDB_ENABLE_MASK;
+	permissions |= KDB_ENABLE_ALWAYS_SAFE;
+
+	/* some commands change group when launched with no arguments */
+	if (no_args)
+		permissions |= permissions << KDB_ENABLE_NO_ARGS_SHIFT;
+
+	flags |= KDB_ENABLE_ALL;
+
+	return permissions & flags;
+}
+
 typedef int (*kdb_func_t)(int, const char **);
 
 #ifdef	CONFIG_KGDB_KDB
diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
index 87343f0..f5b3d89 100644
--- a/kernel/debug/kdb/kdb_bp.c
+++ b/kernel/debug/kdb/kdb_bp.c
@@ -532,21 +532,28 @@ void __init kdb_initbptab(void)
 		bp->bp_free = 1;
 
 	kdb_register_flags("bp", kdb_bp, "[<vaddr>]",
-		"Set/Display breakpoints", 0, KDB_REPEAT_NO_ARGS);
+		"Set/Display breakpoints", 0,
+		KDB_ENABLE_FLOW_CTRL | KDB_REPEAT_NO_ARGS);
 	kdb_register_flags("bl", kdb_bp, "[<vaddr>]",
-		"Display breakpoints", 0, KDB_REPEAT_NO_ARGS);
+		"Display breakpoints", 0,
+		KDB_ENABLE_FLOW_CTRL | KDB_REPEAT_NO_ARGS);
 	if (arch_kgdb_ops.flags & KGDB_HW_BREAKPOINT)
 		kdb_register_flags("bph", kdb_bp, "[<vaddr>]",
-		"[datar [length]|dataw [length]]   Set hw brk", 0, KDB_REPEAT_NO_ARGS);
+		"[datar [length]|dataw [length]]   Set hw brk", 0,
+		KDB_ENABLE_FLOW_CTRL | KDB_REPEAT_NO_ARGS);
 	kdb_register_flags("bc", kdb_bc, "<bpnum>",
-		"Clear Breakpoint", 0, 0);
+		"Clear Breakpoint", 0,
+		KDB_ENABLE_FLOW_CTRL);
 	kdb_register_flags("be", kdb_bc, "<bpnum>",
-		"Enable Breakpoint", 0, 0);
+		"Enable Breakpoint", 0,
+		KDB_ENABLE_FLOW_CTRL);
 	kdb_register_flags("bd", kdb_bc, "<bpnum>",
-		"Disable Breakpoint", 0, 0);
+		"Disable Breakpoint", 0,
+		KDB_ENABLE_FLOW_CTRL);
 
 	kdb_register_flags("ss", kdb_ss, "",
-		"Single Step", 1, KDB_REPEAT_NO_ARGS);
+		"Single Step", 1,
+		KDB_ENABLE_FLOW_CTRL | KDB_REPEAT_NO_ARGS);
 	/*
 	 * Architecture dependent initialization.
 	 */
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 41dac47..dcf45a9 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -641,8 +641,13 @@ static int kdb_defcmd2(const char *cmdstr, const char *argv0)
 		if (!s->count)
 			s->usable = 0;
 		if (s->usable)
-			kdb_register(s->name, kdb_exec_defcmd,
-				     s->usage, s->help, 0);
+			/* macros are always safe because when executed each
+			 * internal command re-enters kdb_parse() and is
+			 * safety checked individually.
+			 */
+			kdb_register_flags(s->name, kdb_exec_defcmd, s->usage,
+					   s->help, 0,
+					   KDB_ENABLE_ALWAYS_SAFE);
 		return 0;
 	}
 	if (!s->usable)
@@ -2764,78 +2769,107 @@ static void __init kdb_inittab(void)
 
 	kdb_register_flags("md", kdb_md, "<vaddr>",
 	  "Display Memory Contents, also mdWcN, e.g. md8c1", 1,
-			    KDB_REPEAT_NO_ARGS);
+	  KDB_ENABLE_MEM_READ | KDB_REPEAT_NO_ARGS);
 	kdb_register_flags("mdr", kdb_md, "<vaddr> <bytes>",
-	  "Display Raw Memory", 0, KDB_REPEAT_NO_ARGS);
+	  "Display Raw Memory", 0,
+	  KDB_ENABLE_MEM_READ | KDB_REPEAT_NO_ARGS);
 	kdb_register_flags("mdp", kdb_md, "<paddr> <bytes>",
-	  "Display Physical Memory", 0, KDB_REPEAT_NO_ARGS);
+	  "Display Physical Memory", 0,
+	  KDB_ENABLE_MEM_READ | KDB_REPEAT_NO_ARGS);
 	kdb_register_flags("mds", kdb_md, "<vaddr>",
-	  "Display Memory Symbolically", 0, KDB_REPEAT_NO_ARGS);
+	  "Display Memory Symbolically", 0,
+	  KDB_ENABLE_MEM_READ | KDB_REPEAT_NO_ARGS);
 	kdb_register_flags("mm", kdb_mm, "<vaddr> <contents>",
-	  "Modify Memory Contents", 0, KDB_REPEAT_NO_ARGS);
+	  "Modify Memory Contents", 0,
+	  KDB_ENABLE_MEM_WRITE | KDB_REPEAT_NO_ARGS);
 	kdb_register_flags("go", kdb_go, "[<vaddr>]",
-	  "Continue Execution", 1, 0);
+	  "Continue Execution", 1,
+	  KDB_ENABLE_REG_WRITE | KDB_ENABLE_ALWAYS_SAFE_NO_ARGS);
 	kdb_register_flags("rd", kdb_rd, "",
-	  "Display Registers", 0, 0);
+	  "Display Registers", 0,
+	  KDB_ENABLE_REG_READ);
 	kdb_register_flags("rm", kdb_rm, "<reg> <contents>",
-	  "Modify Registers", 0, 0);
+	  "Modify Registers", 0,
+	  KDB_ENABLE_REG_WRITE);
 	kdb_register_flags("ef", kdb_ef, "<vaddr>",
-	  "Display exception frame", 0, 0);
+	  "Display exception frame", 0,
+	  KDB_ENABLE_MEM_READ);
 	kdb_register_flags("bt", kdb_bt, "[<vaddr>]",
-	  "Stack traceback", 1, 0);
+	  "Stack traceback", 1,
+	  KDB_ENABLE_MEM_READ | KDB_ENABLE_INSPECT_NO_ARGS);
 	kdb_register_flags("btp", kdb_bt, "<pid>",
-	  "Display stack for process <pid>", 0, 0);
+	  "Display stack for process <pid>", 0,
+	  KDB_ENABLE_INSPECT);
 	kdb_register_flags("bta", kdb_bt, "[D|R|S|T|C|Z|E|U|I|M|A]",
-	  "Backtrace all processes matching state flag", 0, 0);
+	  "Backtrace all processes matching state flag", 0,
+	  KDB_ENABLE_INSPECT);
 	kdb_register_flags("btc", kdb_bt, "",
-	  "Backtrace current process on each cpu", 0, 0);
+	  "Backtrace current process on each cpu", 0,
+	  KDB_ENABLE_INSPECT);
 	kdb_register_flags("btt", kdb_bt, "<vaddr>",
 	  "Backtrace process given its struct task address", 0,
-			    0);
+	  KDB_ENABLE_MEM_READ | KDB_ENABLE_INSPECT_NO_ARGS);
 	kdb_register_flags("env", kdb_env, "",
-	  "Show environment variables", 0, 0);
+	  "Show environment variables", 0,
+	  KDB_ENABLE_ALWAYS_SAFE);
 	kdb_register_flags("set", kdb_set, "",
-	  "Set environment variables", 0, 0);
+	  "Set environment variables", 0,
+	  KDB_ENABLE_ALWAYS_SAFE);
 	kdb_register_flags("help", kdb_help, "",
-	  "Display Help Message", 1, 0);
+	  "Display Help Message", 1,
+	  KDB_ENABLE_ALWAYS_SAFE);
 	kdb_register_flags("?", kdb_help, "",
-	  "Display Help Message", 0, 0);
+	  "Display Help Message", 0,
+	  KDB_ENABLE_ALWAYS_SAFE);
 	kdb_register_flags("cpu", kdb_cpu, "<cpunum>",
-	  "Switch to new cpu", 0, 0);
+	  "Switch to new cpu", 0,
+	  KDB_ENABLE_ALWAYS_SAFE_NO_ARGS);
 	kdb_register_flags("kgdb", kdb_kgdb, "",
 	  "Enter kgdb mode", 0, 0);
 	kdb_register_flags("ps", kdb_ps, "[<flags>|A]",
-	  "Display active task list", 0, 0);
+	  "Display active task list", 0,
+	  KDB_ENABLE_INSPECT);
 	kdb_register_flags("pid", kdb_pid, "<pidnum>",
-	  "Switch to another task", 0, 0);
+	  "Switch to another task", 0,
+	  KDB_ENABLE_INSPECT);
 	kdb_register_flags("reboot", kdb_reboot, "",
-	  "Reboot the machine immediately", 0, 0);
+	  "Reboot the machine immediately", 0,
+	  KDB_ENABLE_REBOOT);
 #if defined(CONFIG_MODULES)
 	kdb_register_flags("lsmod", kdb_lsmod, "",
-	  "List loaded kernel modules", 0, 0);
+	  "List loaded kernel modules", 0,
+	  KDB_ENABLE_INSPECT);
 #endif
 #if defined(CONFIG_MAGIC_SYSRQ)
 	kdb_register_flags("sr", kdb_sr, "<key>",
-	  "Magic SysRq key", 0, 0);
+	  "Magic SysRq key", 0,
+	  KDB_ENABLE_ALWAYS_SAFE);
 #endif
 #if defined(CONFIG_PRINTK)
 	kdb_register_flags("dmesg", kdb_dmesg, "[lines]",
-	  "Display syslog buffer", 0, 0);
+	  "Display syslog buffer", 0,
+	  KDB_ENABLE_ALWAYS_SAFE);
 #endif
 	if (arch_kgdb_ops.enable_nmi) {
 		kdb_register_flags("disable_nmi", kdb_disable_nmi, "",
-		  "Disable NMI entry to KDB", 0, 0);
+		  "Disable NMI entry to KDB", 0,
+		  KDB_ENABLE_ALWAYS_SAFE);
 	}
 	kdb_register_flags("defcmd", kdb_defcmd, "name \"usage\" \"help\"",
-	  "Define a set of commands, down to endefcmd", 0, 0);
+	  "Define a set of commands, down to endefcmd", 0,
+	  KDB_ENABLE_ALWAYS_SAFE);
 	kdb_register_flags("kill", kdb_kill, "<-signal> <pid>",
-	  "Send a signal to a process", 0, 0);
+	  "Send a signal to a process", 0,
+	  KDB_ENABLE_SIGNAL);
 	kdb_register_flags("summary", kdb_summary, "",
-	  "Summarize the system", 4, 0);
+	  "Summarize the system", 4,
+	  KDB_ENABLE_ALWAYS_SAFE);
 	kdb_register_flags("per_cpu", kdb_per_cpu, "<sym> [<bytes>] [<cpu>]",
-	  "Display per_cpu variables", 3, 0);
+	  "Display per_cpu variables", 3,
+	  KDB_ENABLE_MEM_READ);
 	kdb_register_flags("grephelp", kdb_grep_help, "",
-	  "Display help on | grep", 0, 0);
+	  "Display help on | grep", 0,
+	  KDB_ENABLE_ALWAYS_SAFE);
 }
 
 /* Execute any commands defined in kdb_cmds.  */
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index 3da7e30..1058f6b 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -128,7 +128,7 @@ static int kdb_ftdump(int argc, const char **argv)
 static __init int kdb_ftrace_register(void)
 {
 	kdb_register_flags("ftdump", kdb_ftdump, "[skip_#lines] [cpu]",
-			    "Dump ftrace log", 0, 0);
+			    "Dump ftrace log", 0, KDB_ENABLE_ALWAYS_SAFE);
 	return 0;
 }
 
-- 
1.9.0

