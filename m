Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbbA2HNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:13:31 -0500
Received: from goliath.siemens.de ([192.35.17.28]:35488 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbbA2HN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:13:28 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH v11 08/28] scripts/gdb: Add internal helper and convenience function to look up a module
Date: Thu, 29 Jan 2015 07:46:27 +0100
Message-Id: <0a8f779c4530c3b2e714734987f421b55ca37426.1422514006.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
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
2.1.4

