Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3KLHP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:15:27 -0500
Received: from thoth.sbs.de ([192.35.17.2]:21485 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab3KLHPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:15:13 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v7 03/21] scripts/gdb: Add container_of helper and convenience function
Date: Tue, 12 Nov 2013 08:14:21 +0100
Message-Id: <5fc26dad5482a915391dc3a7bc43e1b1698785ec.1384240478.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
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

