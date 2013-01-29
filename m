Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3A2Miv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:38:51 -0500
Received: from david.siemens.de ([192.35.17.14]:29348 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab3A2Mio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:38:44 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 11/20] scripts/gdb: Add task iteration helper
Date: Tue, 29 Jan 2013 13:37:54 +0100
Message-Id: <05a9f93b3ea301f67c87dd7a69b32d5bf69a81e7.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The internal helper for_each_task iterates over all tasks of the target,
calling the provided function on each.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/task.py |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 scripts/gdb/task.py

diff --git a/scripts/gdb/task.py b/scripts/gdb/task.py
new file mode 100644
index 0000000..6b73dbf
--- /dev/null
+++ b/scripts/gdb/task.py
@@ -0,0 +1,35 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  task & thread tools
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
+
+task_type = CachedType("struct task_struct")
+
+def for_each_task(func, arg = None):
+	global task_type
+	task_ptr_type = task_type.get_type().pointer()
+	init_task = gdb.parse_and_eval("init_task")
+	g = init_task.address
+	while True:
+		g =  container_of(g['tasks']['next'], task_ptr_type, "tasks")
+		if g == init_task.address:
+			break;
+		t = g
+		while True:
+			func(t, arg)
+			t = container_of(t['thread_group']['next'],
+					 task_ptr_type, "thread_group")
+			if t == g:
+				break
-- 
1.7.3.4

