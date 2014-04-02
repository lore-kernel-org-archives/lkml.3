Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbaDBPqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:46:20 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:40490 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758882AbaDBPoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:44:25 -0400
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
Subject: [RFC v2 07/10] kdb: Mark safe commands as KDB_SAFE and KDB_SAFE_NO_ARGS
Date: Wed,  2 Apr 2014 16:43:57 +0100
Message-Id: <1396453440-16445-8-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
References: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton.vorontsov@linaro.org>

This patch introduces two new flags: KDB_SAFE, denotes a safe command,
and KDB_SAFE_NO_ARGS, denotes a safe command when used without arguments.

The word "safe" here used in the sense that the commands cannot be
used to leak sensitive data from the memory, and cannot be used
to change program flow in a predefined manner.

These flags will be used by the "kiosk" mode, i.e. when it is possible
for the ordinary user to enter the KDB (or user can get the access to
KDB after the crash), but we do not allow user to read dump the
memory [and thus read some sensitive data].

The following commands were marked as "safe":

	Display stack for process
	Display stack all processes
	Backtrace current process on each cpu
	Execute cmd for each element in linked list
	Show environment variables
	Set environment variables
	Display Help Message
	Switch to new cpu
	Display active task list
	Switch to another task
	Reboot the machine immediately
	List loaded kernel modules
	Magic SysRq key
	Display syslog buffer
	Define a set of commands, down to endefcmd
	Summarize the system
	Disable NMI entry to KDB
	Macro commands (subject to finer grain checking)

The following commands were marked as safe when issued with no arguments:

	Stack traceback
	Continue Execution

And the following commands are unsafe:

	Display exception frame
	Clear Breakpoint
	Enable Breakpoint
	Disable Breakpoint
	Single step
	Single step to branch/call
	Continue Execution (with address argument)
	Display Memory Contents
	Display Raw Memory
	Display Physical Memory
	Display Memory Symbolically
	Modify Memory Contents
	Display Registers
	Modify Registers
	Backtrace process given its struct task address
	Send a signal to a process
	Enter kgdb mode
	Display per_cpu variables

Note that we mark "display registers" command unsafe, this is because
single stepping + constantly dumping registers in string or memory
functions can be used as a way to read sensitive data (it's actually
trivial to exploit). Later we can do a bit better, i.e. not displaying
general-purpose registers, but printing control registers.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 include/linux/kdb.h         |  2 ++
 kernel/debug/kdb/kdb_main.c | 48 ++++++++++++++++++++++++---------------------
 kernel/trace/trace_kdb.c    |  2 +-
 3 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 4b656d6..784b22f 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -16,6 +16,8 @@
 typedef enum {
 	KDB_REPEAT_NO_ARGS	= 0x1, /* Repeat the command w/o arguments */
 	KDB_REPEAT_WITH_ARGS	= 0x2, /* Repeat the command w/ its arguments */
+	KDB_SAFE		= 0x4, /* Security-wise safe command */
+	KDB_SAFE_NO_ARGS	= 0x8, /* Only safe if run w/o arguments */
 } kdb_cmdflags_t;
 
 typedef int (*kdb_func_t)(int, const char **);
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index a40b05b..0205e4a 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -641,8 +641,12 @@ static int kdb_defcmd2(const char *cmdstr, const char *argv0)
 		if (!s->count)
 			s->usable = 0;
 		if (s->usable)
-			kdb_register(s->name, kdb_exec_defcmd,
-				     s->usage, s->help, 0);
+			/* macros are safe because when executed each
+			 * internal command re-enters kdb_parse() and is
+			 * safety checked individually.
+			 */
+			kdb_register_flags(s->name, kdb_exec_defcmd,
+				     s->usage, s->help, 0, KDB_SAFE);
 		return 0;
 	}
 	if (!s->usable)
@@ -2767,7 +2771,7 @@ static void __init kdb_inittab(void)
 	kdb_register_flags("mm", kdb_mm, "<vaddr> <contents>",
 	  "Modify Memory Contents", 0, KDB_REPEAT_NO_ARGS);
 	kdb_register_flags("go", kdb_go, "[<vaddr>]",
-	  "Continue Execution", 1, 0);
+	  "Continue Execution", 1, KDB_SAFE_NO_ARGS);
 	kdb_register_flags("rd", kdb_rd, "",
 	  "Display Registers", 0, 0);
 	kdb_register_flags("rm", kdb_rm, "<reg> <contents>",
@@ -2775,60 +2779,60 @@ static void __init kdb_inittab(void)
 	kdb_register_flags("ef", kdb_ef, "<vaddr>",
 	  "Display exception frame", 0, 0);
 	kdb_register_flags("bt", kdb_bt, "[<vaddr>]",
-	  "Stack traceback", 1, 0);
+	  "Stack traceback", 1, KDB_SAFE_NO_ARGS);
 	kdb_register_flags("btp", kdb_bt, "<pid>",
-	  "Display stack for process <pid>", 0, 0);
+	  "Display stack for process <pid>", 0, KDB_SAFE);
 	kdb_register_flags("bta", kdb_bt, "[D|R|S|T|C|Z|E|U|I|M|A]",
-	  "Backtrace all processes matching state flag", 0, 0);
+	  "Backtrace all processes matching state flag", 0, KDB_SAFE);
 	kdb_register_flags("btc", kdb_bt, "",
-	  "Backtrace current process on each cpu", 0, 0);
+	  "Backtrace current process on each cpu", 0, KDB_SAFE);
 	kdb_register_flags("btt", kdb_bt, "<vaddr>",
 	  "Backtrace process given its struct task address", 0,
 			    0);
 	kdb_register_flags("env", kdb_env, "",
-	  "Show environment variables", 0, 0);
+	  "Show environment variables", 0, KDB_SAFE);
 	kdb_register_flags("set", kdb_set, "",
-	  "Set environment variables", 0, 0);
+	  "Set environment variables", 0, KDB_SAFE);
 	kdb_register_flags("help", kdb_help, "",
-	  "Display Help Message", 1, 0);
+	  "Display Help Message", 1, KDB_SAFE);
 	kdb_register_flags("?", kdb_help, "",
-	  "Display Help Message", 0, 0);
+	  "Display Help Message", 0, KDB_SAFE);
 	kdb_register_flags("cpu", kdb_cpu, "<cpunum>",
-	  "Switch to new cpu", 0, 0);
+	  "Switch to new cpu", 0, KDB_SAFE);
 	kdb_register_flags("kgdb", kdb_kgdb, "",
 	  "Enter kgdb mode", 0, 0);
 	kdb_register_flags("ps", kdb_ps, "[<flags>|A]",
-	  "Display active task list", 0, 0);
+	  "Display active task list", 0, KDB_SAFE);
 	kdb_register_flags("pid", kdb_pid, "<pidnum>",
-	  "Switch to another task", 0, 0);
+	  "Switch to another task", 0, KDB_SAFE);
 	kdb_register_flags("reboot", kdb_reboot, "",
-	  "Reboot the machine immediately", 0, 0);
+	  "Reboot the machine immediately", 0, KDB_SAFE);
 #if defined(CONFIG_MODULES)
 	kdb_register_flags("lsmod", kdb_lsmod, "",
-	  "List loaded kernel modules", 0, 0);
+	  "List loaded kernel modules", 0, KDB_SAFE);
 #endif
 #if defined(CONFIG_MAGIC_SYSRQ)
 	kdb_register_flags("sr", kdb_sr, "<key>",
-	  "Magic SysRq key", 0, 0);
+	  "Magic SysRq key", 0, KDB_SAFE);
 #endif
 #if defined(CONFIG_PRINTK)
 	kdb_register_flags("dmesg", kdb_dmesg, "[lines]",
-	  "Display syslog buffer", 0, 0);
+	  "Display syslog buffer", 0, KDB_SAFE);
 #endif
 	if (arch_kgdb_ops.enable_nmi) {
 		kdb_register_flags("disable_nmi", kdb_disable_nmi, "",
-		  "Disable NMI entry to KDB", 0, 0);
+		  "Disable NMI entry to KDB", 0, KDB_SAFE);
 	}
 	kdb_register_flags("defcmd", kdb_defcmd, "name \"usage\" \"help\"",
-	  "Define a set of commands, down to endefcmd", 0, 0);
+	  "Define a set of commands, down to endefcmd", 0, KDB_SAFE);
 	kdb_register_flags("kill", kdb_kill, "<-signal> <pid>",
 	  "Send a signal to a process", 0, 0);
 	kdb_register_flags("summary", kdb_summary, "",
-	  "Summarize the system", 4, 0);
+	  "Summarize the system", 4, KDB_SAFE);
 	kdb_register_flags("per_cpu", kdb_per_cpu, "<sym> [<bytes>] [<cpu>]",
 	  "Display per_cpu variables", 3, 0);
 	kdb_register_flags("grephelp", kdb_grep_help, "",
-	  "Display help on | grep", 0, 0);
+	  "Display help on | grep", 0, KDB_SAFE);
 }
 
 /* Execute any commands defined in kdb_cmds.  */
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index 3da7e30..52f9ad6 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -128,7 +128,7 @@ static int kdb_ftdump(int argc, const char **argv)
 static __init int kdb_ftrace_register(void)
 {
 	kdb_register_flags("ftdump", kdb_ftdump, "[skip_#lines] [cpu]",
-			    "Dump ftrace log", 0, 0);
+			    "Dump ftrace log", 0, KDB_SAFE);
 	return 0;
 }
 
-- 
1.9.0

