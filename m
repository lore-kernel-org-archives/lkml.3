Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3AURMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:12:08 -0500
Received: from thoth.sbs.de ([192.35.17.2]:27192 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab3AURMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:12:06 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>
Subject: [PATCH v4 07/13] scripts/gdb: Add task iteration helper
Date: Mon, 21 Jan 2013 18:06:14 +0100
Message-Id: <150b6a984796b0cdf5dd3dda0e7373edd8fdb996.1358787929.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The internal helper for_each_task iterates over all tasks of the target,
calling the provided function on each. For performance reasons, we cache
a reference to the gdb type object of a task.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/task.py |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 scripts/gdb/task.py

diff --git a/scripts/gdb/task.py b/scripts/gdb/task.py
new file mode 100644
index 0000000..ff05aa5
--- /dev/null
+++ b/scripts/gdb/task.py
@@ -0,0 +1,40 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  task & thread tools
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
+
+from utils import *
+
+task_ptr_type = None
+
+def get_task_ptr_type():
+	global task_ptr_type
+	if task_ptr_type == None:
+		task_ptr_type = get_type("struct task_struct").pointer()
+	return task_ptr_type
+
+def for_each_task(func, arg = None):
+	init_task = gdb.parse_and_eval("init_task")
+	g = init_task.address
+	while True:
+		g =  container_of(g['tasks']['next'], get_task_ptr_type(),
+				  "tasks")
+		if g == init_task.address:
+			break;
+		t = g
+		while True:
+			func(t, arg)
+			t = container_of(t['thread_group']['next'],
+					 get_task_ptr_type(), "thread_group")
+			if t == g:
+				break
-- 
1.7.3.4

