Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbaKTREp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:04:45 -0500
Received: from david.siemens.de ([192.35.17.14]:43936 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062AbaKTRCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:02:49 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v10 02/27] scripts/gdb: Add cache for type objects
Date: Thu, 20 Nov 2014 18:01:39 +0100
Message-Id: <2a7e2b3ee8ca62284bac8a8aeeca99aebd7f7bae.1416502923.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
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
1.8.4.5

