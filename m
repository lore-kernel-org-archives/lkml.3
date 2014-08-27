Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829AbaH0PbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:31:16 -0400
Received: from david.siemens.de ([192.35.17.14]:39488 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935220AbaH0PWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:15 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v9 03/23] scripts/gdb: Add container_of helper and convenience function
Date: Wed, 27 Aug 2014 17:21:18 +0200
Message-Id: <e73c33139bb6c43901862b24c7dc0599087bb1ca.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an internal helper with container_of semantics. As type lookups
are very slow in gdb-python and we need a type "long" for this, cache
the reference to this type object. Then export the helper also as a
convenience function form use at the gdb command line.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/utils.py | 35 +++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |  2 ++
 2 files changed, 37 insertions(+)

diff --git a/scripts/gdb/linux/utils.py b/scripts/gdb/linux/utils.py
index f883611..c9d705b 100644
--- a/scripts/gdb/linux/utils.py
+++ b/scripts/gdb/linux/utils.py
@@ -32,3 +32,38 @@ class CachedType:
             if hasattr(gdb, 'events') and hasattr(gdb.events, 'new_objfile'):
                 gdb.events.new_objfile.connect(self._new_objfile_handler)
         return self._type
+
+
+long_type = CachedType("long")
+
+
+def get_long_type():
+    global long_type
+    return long_type.get_type()
+
+
+def offset_of(typeobj, field):
+    element = gdb.Value(0).cast(typeobj)
+    return int(str(element[field].address).split()[0], 16)
+
+
+def container_of(ptr, typeobj, member):
+    return (ptr.cast(get_long_type()) -
+            offset_of(typeobj, member)).cast(typeobj)
+
+
+class ContainerOf(gdb.Function):
+    """Return pointer to containing data structure.
+
+$container_of(PTR, "TYPE", "ELEMENT"): Given PTR, return a pointer to the
+data structure of the type TYPE in which PTR is the address of ELEMENT.
+Note that TYPE and ELEMENT have to be quoted as strings."""
+
+    def __init__(self):
+        super(ContainerOf, self).__init__("container_of")
+
+    def invoke(self, ptr, typename, elementname):
+        return container_of(ptr, gdb.lookup_type(typename.string()).pointer(),
+                            elementname.string())
+
+ContainerOf()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index c1d90ce..6495841 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -21,3 +21,5 @@ try:
 except:
     gdb.write("NOTE: gdb 7.2 or later required for Linux helper scripts to "
               "work.\n")
+else:
+    import linux.utils
-- 
1.8.1.1.298.ge7eed54

