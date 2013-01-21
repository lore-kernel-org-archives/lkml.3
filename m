Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab3AURYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:24:50 -0500
Received: from david.siemens.de ([192.35.17.14]:21668 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246Ab3AURYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:24:48 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH v4 10/13] scripts/gdb: Add internal helper and convenience function to retrieve thread_info
Date: Mon, 21 Jan 2013 18:06:17 +0100
Message-Id: <84d53bb35efce297ea2d654260cfa5937edb214e.1358787929.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the internal helper get_thread_info that calculated the thread_info
from a given task variable. Also export this service as a convenience
function.

Note: ia64 version is untested.

CC: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
CC: linux-ia64@vger.kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/task.py |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/task.py b/scripts/gdb/task.py
index 93e6c0c..0a45b3c 100644
--- a/scripts/gdb/task.py
+++ b/scripts/gdb/task.py
@@ -67,3 +67,42 @@ class LxTaskByPidFunc(gdb.Function):
 			raise gdb.GdbError("No task of PID " + str(pid))
 
 LxTaskByPidFunc()
+
+
+thread_info_ptr_type = None
+
+def get_thread_info_ptr_type():
+	global thread_info_ptr_type
+	if thread_info_ptr_type == None:
+		thread_info_ptr_type = get_type('struct thread_info').pointer()
+	return thread_info_ptr_type
+
+ia64_task_size = None
+
+def get_thread_info(task):
+	if is_target_arch("ia64"):
+		global ia64_task_size
+		if ia64_task_size == None:
+			ia64_task_size = gdb.parse_and_eval(
+						"sizeof(struct task_struct)")
+		thread_info_addr = task.address + ia64_task_size
+		thread_info = thread_info_addr.cast(get_thread_info_ptr_type())
+	else:
+		thread_info = task['stack'].cast(get_thread_info_ptr_type())
+	return thread_info.dereference()
+
+
+class LxThreadInfoFunc (gdb.Function):
+	# Calculate Linux thread_info from task variable.
+	__doc__ = "Calculate Linux thread_info from task variable.\n" \
+		  "\n" \
+		  "$lx_thread_info(TASK): Given TASK, return the corresponding thread_info\n" \
+		  "variable.\n"
+
+	def __init__(self):
+		super(LxThreadInfoFunc, self).__init__("lx_thread_info")
+
+	def invoke(self, task):
+		return get_thread_info(task)
+
+LxThreadInfoFunc()
-- 
1.7.3.4

