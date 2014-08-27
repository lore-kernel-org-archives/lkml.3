Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935573AbaH0PaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:30:05 -0400
Received: from thoth.sbs.de ([192.35.17.2]:40295 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935244AbaH0PWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:23 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v9 13/23] scripts/gdb: Add helper and convenience function to look up tasks
Date: Wed, 27 Aug 2014 17:21:28 +0200
Message-Id: <b341f909530d1046f456172b1b642d8e62201dac.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the helper task_by_pid that can look up a task by its PID. Also
export it as a convenience function.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/tasks.py | 27 +++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |  1 +
 2 files changed, 28 insertions(+)

diff --git a/scripts/gdb/linux/tasks.py b/scripts/gdb/linux/tasks.py
index cd25984..13bb97c 100644
--- a/scripts/gdb/linux/tasks.py
+++ b/scripts/gdb/linux/tasks.py
@@ -44,3 +44,30 @@ class TaskList:
                 utils.container_of(t['thread_group']['next'],
                                    self.task_ptr_type, "thread_group")
         return t
+
+
+def get_task_by_pid(pid):
+    for task in TaskList():
+        if int(task['pid']) == pid:
+            return task
+    return None
+
+
+class LxTaskByPidFunc(gdb.Function):
+    """Find Linux task by PID and return the task_struct variable.
+
+$lx_task_by_pid(PID): Given PID, iterate over all tasks of the target and
+return that task_struct variable which PID matches."""
+
+    def __init__(self):
+        super(LxTaskByPidFunc, self).__init__("lx_task_by_pid")
+
+    def invoke(self, pid):
+        task = get_task_by_pid(pid)
+        if task:
+            return task.dereference()
+        else:
+            raise gdb.GdbError("No task of PID " + str(pid))
+
+
+LxTaskByPidFunc()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index fa66d23..4d7eb2c 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -26,3 +26,4 @@ else:
     import linux.symbols
     import linux.modules
     import linux.dmesg
+    import linux.tasks
-- 
1.8.1.1.298.ge7eed54

