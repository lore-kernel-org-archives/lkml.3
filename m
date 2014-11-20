Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbaKTRHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:07:54 -0500
Received: from david.siemens.de ([192.35.17.14]:43868 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544AbaKTRCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:02:43 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [PATCH v10 24/27] scripts/gdb: Use a generator instead of iterator for task list
Date: Thu, 20 Nov 2014 18:02:01 +0100
Message-Id: <bbf3d2410e407282246c21505c93619fb398aeaf.1416502923.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

The iterator does not return any task_struct from the thread_group list
because the first condition in the 'if not t or ...' will only be the
first time None.

Instead of keeping track of the state ourself in the next() function,
we fall back using Python's generator.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/tasks.py | 50 +++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/scripts/gdb/linux/tasks.py b/scripts/gdb/linux/tasks.py
index 0008e75..e2037d9 100644
--- a/scripts/gdb/linux/tasks.py
+++ b/scripts/gdb/linux/tasks.py
@@ -18,38 +18,28 @@ from linux import utils
 
 task_type = utils.CachedType("struct task_struct")
 
-
-class TaskList:
-    def __init__(self):
-        global task_type
-        self.task_ptr_type = task_type.get_type().pointer()
-        self.init_task = gdb.parse_and_eval("init_task")
-        self.curr_group = self.init_task.address
-        self.curr_task = None
-
-    def __iter__(self):
-        return self
-
-    def __next__(self):
-        t = self.curr_task
-        if not t or t == self.curr_group:
-            self.curr_group = \
-                utils.container_of(self.curr_group['tasks']['next'],
-                                   self.task_ptr_type, "tasks")
-            if self.curr_group == self.init_task.address:
-                raise StopIteration
-            t = self.curr_task = self.curr_group
-        else:
-            self.curr_task = \
-                utils.container_of(t['thread_group']['next'],
-                                   self.task_ptr_type, "thread_group")
-        return t
-
-    def next(self):
-        return self.__next__()
+def task_lists():
+    global task_type
+    task_ptr_type = task_type.get_type().pointer()
+    init_task = gdb.parse_and_eval("init_task").address
+    t = g = init_task
+
+    while True:
+        while True:
+            yield t
+
+            t = utils.container_of(t['thread_group']['next'],
+                                   task_ptr_type, "thread_group")
+            if t == g:
+                break
+
+        t = g = utils.container_of(g['tasks']['next'],
+                                   task_ptr_type, "tasks")
+        if t == init_task:
+            return
 
 def get_task_by_pid(pid):
-    for task in TaskList():
+    for task in task_lists():
         if int(task['pid']) == pid:
             return task
     return None
-- 
1.8.4.5

