Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaFFRYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:24:52 -0400
Received: from david.siemens.de ([192.35.17.14]:35929 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbaFFRTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:19:37 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v8 04/22] scripts/gdb: Add module iteration class
Date: Fri,  6 Jun 2014 19:18:45 +0200
Message-Id: <c71004d7eb80c4064ce1eab44faa4c02281ed387.1402075139.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1402075136.git.jan.kiszka@siemens.com>
References: <cover.1402075136.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1402075136.git.jan.kiszka@siemens.com>
References: <cover.1402075136.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will soon be used for loading symbols, printing global variables or
listing modules.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/modules.py | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 scripts/gdb/linux/modules.py

diff --git a/scripts/gdb/linux/modules.py b/scripts/gdb/linux/modules.py
new file mode 100644
index 0000000..8a65c3d
--- /dev/null
+++ b/scripts/gdb/linux/modules.py
@@ -0,0 +1,39 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  module tools
+#
+# Copyright (c) Siemens AG, 2013
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
+module_type = utils.CachedType("struct module")
+
+
+class ModuleList:
+    def __init__(self):
+        global module_type
+        self.module_ptr_type = module_type.get_type().pointer()
+        modules = gdb.parse_and_eval("modules")
+        self.curr_entry = modules['next']
+        self.end_of_list = modules.address
+
+    def __iter__(self):
+        return self
+
+    def next(self):
+        entry = self.curr_entry
+        if entry != self.end_of_list:
+            self.curr_entry = entry['next']
+            return utils.container_of(entry, self.module_ptr_type, "list")
+        else:
+            raise StopIteration
-- 
1.8.1.1.298.ge7eed54

