Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843AbaH0PbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:31:18 -0400
Received: from david.siemens.de ([192.35.17.14]:39482 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935216AbaH0PWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:15 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH v9 17/23] scripts/gdb: Add internal helper and convenience function for per-cpu lookup
Date: Wed, 27 Aug 2014 17:21:32 +0200
Message-Id: <e9da1aec72a8d874f7190d8faf491ec095980bd0.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
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
 scripts/gdb/linux/cpus.py  | 68 ++++++++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |  1 +
 2 files changed, 69 insertions(+)
 create mode 100644 scripts/gdb/linux/cpus.py

diff --git a/scripts/gdb/linux/cpus.py b/scripts/gdb/linux/cpus.py
new file mode 100644
index 0000000..18337e0
--- /dev/null
+++ b/scripts/gdb/linux/cpus.py
@@ -0,0 +1,68 @@
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
+from linux import tasks, utils
+
+
+MAX_CPUS = 4096
+
+
+def get_current_cpu():
+    if utils.get_gdbserver_type() == utils.GDBSERVER_QEMU:
+        return gdb.selected_thread().num - 1
+    elif utils.get_gdbserver_type() == utils.GDBSERVER_KGDB:
+        tid = gdb.selected_thread().ptid[2]
+        if tid > (0x100000000 - MAX_CPUS - 2):
+            return 0x100000000 - tid - 2
+        else:
+            return tasks.get_thread_info(tasks.get_task_by_pid(tid))['cpu']
+    else:
+        raise gdb.GdbError("Sorry, obtaining the current CPU is not yet "
+                           "supported with this gdb server.")
+
+
+def per_cpu(var_ptr, cpu):
+    if cpu == -1:
+        cpu = get_current_cpu()
+    if utils.is_target_arch("sparc:v9"):
+        offset = gdb.parse_and_eval(
+            "trap_block[{0}].__per_cpu_base".format(str(cpu)))
+    else:
+        try:
+            offset = gdb.parse_and_eval(
+                "__per_cpu_offset[{0}]".format(str(cpu)))
+        except gdb.error:
+            # !CONFIG_SMP case
+            offset = 0
+    pointer = var_ptr.cast(utils.get_long_type()) + offset
+    return pointer.cast(var_ptr.type).dereference()
+
+
+class PerCpu(gdb.Function):
+    """Return per-cpu variable.
+
+$lx_per_cpu("VAR"[, CPU]): Return the per-cpu variable called VAR for the
+given CPU number. If CPU is omitted, the CPU of the current context is used.
+Note that VAR has to be quoted as string."""
+
+    def __init__(self):
+        super(PerCpu, self).__init__("lx_per_cpu")
+
+    def invoke(self, var_name, cpu=-1):
+        var_ptr = gdb.parse_and_eval("&" + var_name.string())
+        return per_cpu(var_ptr, cpu)
+
+
+PerCpu()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index 4d7eb2c..4848928 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -27,3 +27,4 @@ else:
     import linux.modules
     import linux.dmesg
     import linux.tasks
+    import linux.cpus
-- 
1.8.1.1.298.ge7eed54

