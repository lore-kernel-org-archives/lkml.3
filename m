Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3AURSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:18:43 -0500
Received: from goliath.siemens.de ([192.35.17.28]:19848 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab3AURSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:18:39 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Kay Sievers <kay@vrfy.org>
Subject: [PATCH v4 06/13] scripts/gdb: Add lx-dmesg command
Date: Mon, 21 Jan 2013 18:06:13 +0100
Message-Id: <40443e3682bae5c8227434f945f7297d49af4afb.1358787929.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pokes into the log buffer of the debugged kernel, dumping it to the
gdb console. Helping in case the target should or can no longer execute
dmesg itself.

CC: Kay Sievers <kay@vrfy.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/dmesg.py       |   63 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 2 files changed, 64 insertions(+), 0 deletions(-)
 create mode 100644 scripts/gdb/dmesg.py

diff --git a/scripts/gdb/dmesg.py b/scripts/gdb/dmesg.py
new file mode 100644
index 0000000..1bc3368
--- /dev/null
+++ b/scripts/gdb/dmesg.py
@@ -0,0 +1,63 @@
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
+from utils import *
+
+class LinuxDmesg(gdb.Command):
+	__doc__ = "Print Linux kernel log buffer."
+
+	def __init__(self):
+		super(LinuxDmesg, self).__init__("lx-dmesg", gdb.COMMAND_DATA)
+
+	def invoke(self, arg, from_tty):
+		log_buf_addr = \
+			int(str(gdb.parse_and_eval("log_buf")).split()[0], 16)
+		log_first_idx = int(gdb.parse_and_eval("log_first_idx"))
+		log_next_idx = int(gdb.parse_and_eval("log_next_idx"))
+		log_buf_len = int(gdb.parse_and_eval("log_buf_len"))
+
+		inf = gdb.inferiors()[0]
+		start = log_buf_addr + log_first_idx
+		if log_first_idx < log_next_idx:
+			log_buf_2nd_half = -1
+			length = log_next_idx - log_first_idx
+			log_buf = inf.read_memory(start, length)
+		else:
+			log_buf_2nd_half = log_buf_len - log_first_idx
+			log_buf = inf.read_memory(start, log_buf_2nd_half) + \
+				  inf.read_memory(log_buf_addr, log_next_idx)
+
+		pos = 0
+		while pos < log_buf.__len__():
+			length = read_u16(log_buf[pos + 8 : pos + 10])
+			if length == 0:
+				if log_buf_2nd_half == -1:
+					print "Corrupted log buffer!"
+					break
+				pos = log_buf_2nd_half
+				continue
+
+			text_len = read_u16(log_buf[pos + 10 : pos + 12])
+			time_stamp = read_u64(log_buf[pos : pos + 8])
+
+			for line in log_buf[pos + 16 :
+					    pos + 16 + text_len].splitlines():
+				print "[%13.6f] " % \
+				      (time_stamp / 1000000000.0) + line
+
+			pos += length
+
+LinuxDmesg()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index 3553b7d..47f296d 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -23,3 +23,4 @@ if gdb_version < "7.1":
 else:
 	import utils
 	import symbols
+	import dmesg
-- 
1.7.3.4

