Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3A2Mlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:41:50 -0500
Received: from david.siemens.de ([192.35.17.14]:29383 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772Ab3A2Mit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:38:49 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 12/20] scripts/gdb: Add helper and convenience function to look up tasks
Date: Tue, 29 Jan 2013 13:37:55 +0100
Message-Id: <5d6ceee258d1840da142460e86555bc6b9a8d3df.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the helper task_by_pid that can look up a task by its PID. Also
export it as a convenience function.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/task.py        |   29 +++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/task.py b/scripts/gdb/task.py
index 6b73dbf..fe42eb0 100644
--- a/scripts/gdb/task.py
+++ b/scripts/gdb/task.py
@@ -33,3 +33,32 @@ def for_each_task(func, arg = None):
 					 task_ptr_type, "thread_group")
 			if t == g:
 				break
+
+def get_task_by_pid(pid):
+	def match_pid(t, arg):
+		if int(t['pid']) == arg['pid']:
+			arg['task'] = t
+
+	arg = { 'pid': pid, 'task': None }
+	for_each_task(match_pid, arg)
+
+	return arg['task']
+
+
+class LxTaskByPidFunc(gdb.Function):
+	__doc__ = "Find Linux task by PID and return the task_struct variable.\n" \
+		  "\n" \
+		  "$lx_task_by_pid(PID): Given PID, iterate over all tasks of the target and\n" \
+		  "return that task_struct variable which PID matches."
+
+	def __init__(self):
+		super(LxTaskByPidFunc, self).__init__("lx_task_by_pid")
+
+	def invoke(self, pid):
+		task = get_task_by_pid(pid)
+		if task:
+			return task.dereference()
+		else:
+			raise gdb.GdbError("No task of PID " + str(pid))
+
+LxTaskByPidFunc()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index 4a5685b..e1c5dbc 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -25,3 +25,4 @@ else:
 	import symbols
 	import module
 	import dmesg
+	import task
-- 
1.7.3.4

