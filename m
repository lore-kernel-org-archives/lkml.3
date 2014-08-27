Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863AbaH0PcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:32:08 -0400
Received: from david.siemens.de ([192.35.17.14]:39472 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934997AbaH0PWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:14 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Kay Sievers <kay@vrfy.org>
Subject: [PATCH v9 11/23] scripts/gdb: Add lx-dmesg command
Date: Wed, 27 Aug 2014 17:21:26 +0200
Message-Id: <6ca3a678687e85f653b5290f29515621c0540458.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pokes into the log buffer of the debugged kernel, dumping it to the
gdb console. Helping in case the target should or can no longer execute
dmesg itself.

CC: Kay Sievers <kay@vrfy.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/dmesg.py | 64 ++++++++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |  1 +
 2 files changed, 65 insertions(+)
 create mode 100644 scripts/gdb/linux/dmesg.py

diff --git a/scripts/gdb/linux/dmesg.py b/scripts/gdb/linux/dmesg.py
new file mode 100644
index 0000000..7650f24
--- /dev/null
+++ b/scripts/gdb/linux/dmesg.py
@@ -0,0 +1,64 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  kernel log buffer dump
+#
+# Copyright (c) Siemens AG, 2011, 2012
+#
+# Authors:
+#  Jan Kiszka <jan.kiszka@siemens.com>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import gdb
+import string
+
+from linux import utils
+
+
+class LxDmesg(gdb.Command):
+    """Print Linux kernel log buffer."""
+
+    def __init__(self):
+        super(LxDmesg, self).__init__("lx-dmesg", gdb.COMMAND_DATA)
+
+    def invoke(self, arg, from_tty):
+        log_buf_addr = int(str(gdb.parse_and_eval("log_buf")).split()[0], 16)
+        log_first_idx = int(gdb.parse_and_eval("log_first_idx"))
+        log_next_idx = int(gdb.parse_and_eval("log_next_idx"))
+        log_buf_len = int(gdb.parse_and_eval("log_buf_len"))
+
+        inf = gdb.inferiors()[0]
+        start = log_buf_addr + log_first_idx
+        if log_first_idx < log_next_idx:
+            log_buf_2nd_half = -1
+            length = log_next_idx - log_first_idx
+            log_buf = inf.read_memory(start, length)
+        else:
+            log_buf_2nd_half = log_buf_len - log_first_idx
+            log_buf = inf.read_memory(start, log_buf_2nd_half) + \
+                inf.read_memory(log_buf_addr, log_next_idx)
+
+        pos = 0
+        while pos < log_buf.__len__():
+            length = utils.read_u16(log_buf[pos + 8:pos + 10])
+            if length == 0:
+                if log_buf_2nd_half == -1:
+                    gdb.write("Corrupted log buffer!\n")
+                    break
+                pos = log_buf_2nd_half
+                continue
+
+            text_len = utils.read_u16(log_buf[pos + 10:pos + 12])
+            time_stamp = utils.read_u64(log_buf[pos:pos + 8])
+
+            for line in log_buf[pos + 16:pos + 16 + text_len].splitlines():
+                gdb.write("[{time:12.6f}] {line}\n".format(
+                    time=time_stamp / 1000000000.0,
+                    line=line))
+
+            pos += length
+
+
+LxDmesg()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index cf2e716..fa66d23 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -25,3 +25,4 @@ else:
     import linux.utils
     import linux.symbols
     import linux.modules
+    import linux.dmesg
-- 
1.8.1.1.298.ge7eed54

