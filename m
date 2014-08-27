Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935444AbaH0PYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:24:46 -0400
Received: from goliath.siemens.de ([192.35.17.28]:33817 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935306AbaH0PWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:33 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v9 12/23] scripts/gdb: Add task iteration class
Date: Wed, 27 Aug 2014 17:21:27 +0200
Message-Id: <e0c985f19f2ed5b114630ca8108800efbe6ffeca.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This class allows to iterate over all tasks of the target.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/tasks.py | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 scripts/gdb/linux/tasks.py

diff --git a/scripts/gdb/linux/tasks.py b/scripts/gdb/linux/tasks.py
new file mode 100644
index 0000000..cd25984
--- /dev/null
+++ b/scripts/gdb/linux/tasks.py
@@ -0,0 +1,46 @@
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
+from linux import utils
+
+
+task_type = utils.CachedType("struct task_struct")
+
+
+class TaskList:
+    def __init__(self):
+        global task_type
+        self.task_ptr_type = task_type.get_type().pointer()
+        self.init_task = gdb.parse_and_eval("init_task")
+        self.curr_group = self.init_task.address
+        self.curr_task = None
+
+    def __iter__(self):
+        return self
+
+    def next(self):
+        t = self.curr_task
+        if not t or t == self.curr_group:
+            self.curr_group = \
+                utils.container_of(self.curr_group['tasks']['next'],
+                                   self.task_ptr_type, "tasks")
+            if self.curr_group == self.init_task.address:
+                raise StopIteration
+            t = self.curr_task = self.curr_group
+        else:
+            self.curr_task = \
+                utils.container_of(t['thread_group']['next'],
+                                   self.task_ptr_type, "thread_group")
+        return t
-- 
1.8.1.1.298.ge7eed54

