Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbbA2G5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:57:01 -0500
Received: from david.siemens.de ([192.35.17.14]:58352 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbbA2Gxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:53:52 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH v11 02/28] scripts/gdb: Add cache for type objects
Date: Thu, 29 Jan 2015 07:46:21 +0100
Message-Id: <85e4fd40dd05cb8317e336cefdcd917ec8078c5b.1422514006.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Type lookups are very slow in gdb-python which is often noticeable when
iterating over a number of objects. Introduce the helper class
CachedType that keeps a reference to a gdb.Type object but also
refreshes it after an object file has been loaded.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/utils.py | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 scripts/gdb/linux/utils.py

diff --git a/scripts/gdb/linux/utils.py b/scripts/gdb/linux/utils.py
new file mode 100644
index 0000000..f883611
--- /dev/null
+++ b/scripts/gdb/linux/utils.py
@@ -0,0 +1,34 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  common utilities
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
+
+class CachedType:
+    def __init__(self, name):
+        self._type = None
+        self._name = name
+
+    def _new_objfile_handler(self, event):
+        self._type = None
+        gdb.events.new_objfile.disconnect(self._new_objfile_handler)
+
+    def get_type(self):
+        if self._type is None:
+            self._type = gdb.lookup_type(self._name)
+            if self._type is None:
+                raise gdb.GdbError(
+                    "cannot resolve type '{0}'".format(self._name))
+            if hasattr(gdb, 'events') and hasattr(gdb.events, 'new_objfile'):
+                gdb.events.new_objfile.connect(self._new_objfile_handler)
+        return self._type
-- 
2.1.4

