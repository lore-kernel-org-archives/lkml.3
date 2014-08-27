Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935565AbaH0P3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:29:50 -0400
Received: from goliath.siemens.de ([192.35.17.28]:33739 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935246AbaH0PWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:24 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v9 04/23] scripts/gdb: Add module iteration class
Date: Wed, 27 Aug 2014 17:21:19 +0200
Message-Id: <b41b9d9d1ab58d8cc2cc58952b245a15fc4ab1f4.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
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

