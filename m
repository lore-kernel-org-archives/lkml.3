Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3KLHTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:19:11 -0500
Received: from goliath.siemens.de ([192.35.17.28]:21246 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab3KLHPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:15:15 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v7 08/21] scripts/gdb: Add internal helper and convenience function to look up a module
Date: Tue, 12 Nov 2013 08:14:26 +0100
Message-Id: <37b0912dabd0dc7e7d4d4dd33be24e9024f03468.1384240478.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the internal helper get_module_by_name to obtain the module
structure corresponding to the given name. Also export this service as a
convenience function.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/modules.py | 28 ++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py   |  1 +
 2 files changed, 29 insertions(+)

diff --git a/scripts/gdb/linux/modules.py b/scripts/gdb/linux/modules.py
index 8a65c3d..531f763 100644
--- a/scripts/gdb/linux/modules.py
+++ b/scripts/gdb/linux/modules.py
@@ -37,3 +37,31 @@ class ModuleList:
             return utils.container_of(entry, self.module_ptr_type, "list")
         else:
             raise StopIteration
+
+
+def find_module_by_name(name):
+    for module in ModuleList():
+        if module['name'].string() == name:
+            return module
+    return None
+
+
+class LxModule(gdb.Function):
+    """Find module by name and return the module variable.
+
+$lx_module("MODULE"): Given the name MODULE, iterate over all loaded modules
+of the target and return that module variable which MODULE matches."""
+
+    def __init__(self):
+        super(LxModule, self).__init__("lx_module")
+
+    def invoke(self, mod_name):
+        mod_name = mod_name.string()
+        module = find_module_by_name(mod_name)
+        if module:
+            return module.dereference()
+        else:
+            raise gdb.GdbError("Unable to find MODULE " + mod_name)
+
+
+LxModule()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index 0b0faa4..cf2e716 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -24,3 +24,4 @@ except:
 else:
     import linux.utils
     import linux.symbols
+    import linux.modules
-- 
1.8.1.1.298.ge7eed54

