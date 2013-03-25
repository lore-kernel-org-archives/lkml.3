Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab3CYSva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:51:30 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55869 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932993Ab3CYSuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:50:10 -0400
Message-Id: <20130325185008.546140384@gulag1.americas.sgi.com>
References: <20130325185007.321022858@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Mar 2013 13:50:15 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 08/15] KDB: Restore call to kdump from KDB
Content-Disposition: inline; filename=kdb-add-kdump-cmd.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restores the capability of calling kdump from inside
KDB.  First it returns to the original CPU that KDB was called
by, and also verifies that the crash_kexec kernel has been loaded.
Both are better than just using the 'sr c' option and possibly
hanging the system.

Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/kdb.h         |    7 +++
 kernel/debug/kdb/kdb_main.c |   79 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

--- linux.orig/include/linux/kdb.h
+++ linux/include/linux/kdb.h
@@ -144,6 +144,13 @@ static inline const char *kdb_walk_kalls
 }
 #endif /* ! CONFIG_KALLSYMS */
 
+#if defined(CONFIG_KEXEC)
+enum {
+	KDB_KDUMP_RESET,
+	KDB_KDUMP_KDUMP,
+};
+#endif
+
 /* Dynamic kdb shell command registration */
 extern int kdb_register(char *, kdb_func_t, char *, char *, short);
 extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
--- linux.orig/kernel/debug/kdb/kdb_main.c
+++ linux/kernel/debug/kdb/kdb_main.c
@@ -42,6 +42,10 @@
 #include <linux/slab.h>
 #include "kdb_private.h"
 
+#if defined(CONFIG_KEXEC)
+#include <linux/kexec.h>
+#endif
+
 /*
  * Kernel debugger state flags
  */
@@ -1052,6 +1056,73 @@ void kdb_set_current_task(struct task_st
 }
 EXPORT_SYMBOL(kdb_set_current_task);
 
+#if defined(CONFIG_KEXEC)
+
+static int kdb_kdump_state = KDB_KDUMP_RESET;	/* KDB kdump state */
+
+static int kdb_cpu(int argc, const char **argv);
+
+/*
+ * kdb_kdump_check
+ *
+ *	This is where the kdump on monarch cpu is handled.
+ *
+ */
+void kdb_kdump_check(struct pt_regs *regs)
+{
+	if (kdb_kdump_state != KDB_KDUMP_RESET) {
+		crash_kexec(regs);
+
+		/*
+		 * If the call above returned then something didn't work
+		 */
+		kdb_printf("kdb_kdump_check: crash_kexec failed!\n");
+		kdb_printf
+		("Please check if the kdump kernel has been properly loaded\n");
+		kdb_kdump_state = KDB_KDUMP_RESET;
+	}
+}
+
+
+/*
+ * kdb_kdump
+ *     This function implements the 'kdump' command.
+ *
+ * Returns:
+ *     zero for success, a kdb diagnostic if error
+ */
+
+static int
+kdb_kdump(int argc, const char **argv)
+{
+	char cpu_id[8];
+	const char *cpu_argv[] = {NULL, cpu_id, NULL};
+	int ret = KDB_CMD_CPU;
+
+	if (!kexec_crash_image) {
+		kdb_printf("kdump error: crash kernel not loaded\n");
+		return KDB_NOTFOUND;
+	}
+
+	kdb_kdump_state = KDB_KDUMP_KDUMP;
+
+	/* Switch back to the initial cpu before process kdump command */
+	if (smp_processor_id() != kdb_initial_cpu) {
+		scnprintf(cpu_id, sizeof(cpu_id), "%d", kdb_initial_cpu);
+		ret = kdb_cpu(1, cpu_argv);
+		if (ret != KDB_CMD_CPU) {
+			kdb_printf
+			("kdump: Failed to switch to initial cpu %d; aborted\n",
+			kdb_initial_cpu);
+			kdb_kdump_state = KDB_KDUMP_RESET;
+		}
+	}
+
+	return ret;
+}
+
+#endif /* CONFIG_KEXEC */
+
 /*
  * kdb_local - The main code for kdb.  This routine is invoked on a
  *	specific processor, it is not global.  The main kdb() routine
@@ -1079,6 +1150,10 @@ static int kdb_local(kdb_reason_t reason
 	struct task_struct *kdb_current =
 		kdb_curr_task(raw_smp_processor_id());
 
+#if defined(CONFIG_KEXEC)
+	kdb_kdump_check(regs);
+#endif
+
 	KDB_DEBUG_STATE("kdb_local 1", reason);
 	kdb_go_count = 0;
 	if (reason == KDB_REASON_DEBUG) {
@@ -2726,6 +2801,10 @@ static void __init kdb_inittab(void)
 	  "Display Help Message", 0, KDB_REPEAT_NONE);
 	kdb_register_repeat("cpu", kdb_cpu, "<cpunum>",
 	  "Switch to new cpu", 0, KDB_REPEAT_NONE);
+#if defined(CONFIG_KEXEC)
+	kdb_register_repeat("kdump", kdb_kdump, "",
+	  "Enter kdump crash kexec", 0, KDB_REPEAT_NONE);
+#endif
 	kdb_register_repeat("kgdb", kdb_kgdb, "",
 	  "Enter kgdb mode", 0, KDB_REPEAT_NONE);
 	kdb_register_repeat("ps", kdb_ps, "[<flags>|A]",

-- 
