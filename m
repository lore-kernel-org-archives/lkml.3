Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3A2Mmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:42:47 -0500
Received: from thoth.sbs.de ([192.35.17.2]:23159 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613Ab3A2Mij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:38:39 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH v5 16/20] scripts/gdb: Add internal helper and convenience function for per-cpu lookup
Date: Tue, 29 Jan 2013 13:37:59 +0100
Message-Id: <04960fa208fbd9c0962eb4f70aa45d28aec59e8d.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function allows to obtain a per-cpu variable, either of the current
or an explicitly specified CPU.

Note: sparc64 version is untested.

CC: "David S. Miller" <davem@davemloft.net>
CC: sparclinux@vger.kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/percpu.py      |   61 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 2 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 scripts/gdb/percpu.py

diff --git a/scripts/gdb/percpu.py b/scripts/gdb/percpu.py
new file mode 100644
index 0000000..864962c
--- /dev/null
+++ b/scripts/gdb/percpu.py
@@ -0,0 +1,61 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  per-cpu tools
+#
+# Copyright (c) Siemens AG, 2011-2013
+#
+# Authors:
+#  Jan Kiszka <jan.kiszka@siemens.com>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import gdb
+
+from utils import *
+from task import *
+
+MAX_CPUS = 4096
+
+def get_current_cpu():
+	if get_gdbserver_type() == GDBSERVER_QEMU:
+		return gdb.selected_thread().num - 1
+	elif get_gdbserver_type() == GDBSERVER_KGDB:
+		tid = gdb.selected_thread().ptid[2]
+		if tid > (0x100000000 - MAX_CPUS - 2):
+			return 0x100000000 - tid - 2
+		else:
+			return get_thread_info(get_task_by_pid(tid))['cpu']
+	else:
+		raise gdb.GdbError("Sorry, obtaining the current CPU is "
+				   "not yet supported with this gdb server.")
+
+def per_cpu(var_ptr, cpu):
+	if cpu == -1:
+		cpu = get_current_cpu()
+	if is_target_arch("sparc:v9"):
+		offset = gdb.parse_and_eval("trap_block[" + str(cpu) +
+					    "].__per_cpu_base")
+	else:
+		offset = gdb.parse_and_eval("__per_cpu_offset[" + str(cpu) +
+					    "]")
+	pointer = var_ptr.cast(get_long_type()) + offset
+	return pointer.cast(var_ptr.type).dereference()
+
+
+class PerCpu(gdb.Function):
+	__doc__ = "Return per-cpu variable.\n" \
+		  "\n" \
+		  "$lx_per_cpu(\"VAR\"[, CPU]): Return the per-cpu variable called VAR for the\n" \
+		  "given CPU number. If CPU is omitted, the CPU of the current context is used.\n" \
+		  "Note that VAR has to be quoted as string."
+
+	def __init__(self):
+		super(PerCpu, self).__init__("lx_per_cpu")
+
+	def invoke(self, var_name, cpu = -1):
+		var_ptr = gdb.parse_and_eval("&" + var_name.string())
+		return per_cpu(var_ptr, cpu)
+
+PerCpu()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index e1c5dbc..b143808 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -26,3 +26,4 @@ else:
 	import module
 	import dmesg
 	import task
+	import percpu
-- 
1.7.3.4

