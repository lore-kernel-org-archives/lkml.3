Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaFFRYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:24:18 -0400
Received: from thoth.sbs.de ([192.35.17.2]:51997 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbaFFRTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:19:38 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v8 02/22] scripts/gdb: Add cache for type objects
Date: Fri,  6 Jun 2014 19:18:43 +0200
Message-Id: <d501ee0a92f9d10f6c27dbdd4b2664b4bf6c5ba5.1402075139.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1402075136.git.jan.kiszka@siemens.com>
References: <cover.1402075136.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1402075136.git.jan.kiszka@siemens.com>
References: <cover.1402075136.git.jan.kiszka@siemens.com>
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
1.8.1.1.298.ge7eed54

