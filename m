Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbbA2HOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:14:15 -0500
Received: from goliath.siemens.de ([192.35.17.28]:35488 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbbA2HN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:13:29 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH v11 25/28] scripts/gdb: Convert ModuleList to generator function
Date: Thu, 29 Jan 2015 07:46:44 +0100
Message-Id: <40eb512399db801d14fcc4f12bc97dea8c12a571.1422514006.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Analogously to the task list, convert the module list to a generator
function. It noticeably simplifies the code.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/modules.py | 33 +++++++++++----------------------
 scripts/gdb/linux/symbols.py |  2 +-
 2 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/scripts/gdb/linux/modules.py b/scripts/gdb/linux/modules.py
index 2dbf679..6d49722 100644
--- a/scripts/gdb/linux/modules.py
+++ b/scripts/gdb/linux/modules.py
@@ -19,31 +19,20 @@ from linux import cpus, utils
 module_type = utils.CachedType("struct module")
 
 
-class ModuleList:
-    def __init__(self):
-        global module_type
-        self.module_ptr_type = module_type.get_type().pointer()
-        modules = gdb.parse_and_eval("modules")
-        self.curr_entry = modules['next']
-        self.end_of_list = modules.address
-
-    def __iter__(self):
-        return self
-
-    def __next__(self):
-        entry = self.curr_entry
-        if entry != self.end_of_list:
-            self.curr_entry = entry['next']
-            return utils.container_of(entry, self.module_ptr_type, "list")
-        else:
-            raise StopIteration
+def module_list():
+    global module_type
+    module_ptr_type = module_type.get_type().pointer()
+    modules = gdb.parse_and_eval("modules")
+    entry = modules['next']
+    end_of_list = modules.address
 
-    def next(self):
-        return self.__next__()
+    while entry != end_of_list:
+        yield utils.container_of(entry, module_ptr_type, "list")
+        entry = entry['next']
 
 
 def find_module_by_name(name):
-    for module in ModuleList():
+    for module in module_list():
         if module['name'].string() == name:
             return module
     return None
@@ -83,7 +72,7 @@ class LxLsmod(gdb.Command):
             "Address{0}    Module                  Size  Used by\n".format(
                 "        " if utils.get_long_type().sizeof == 8 else ""))
 
-        for module in ModuleList():
+        for module in module_list():
             ref = 0
             module_refptr = module['refptr']
             for cpu in cpus.CpuList("cpu_possible_mask"):
diff --git a/scripts/gdb/linux/symbols.py b/scripts/gdb/linux/symbols.py
index ae757fd..bf05e45 100644
--- a/scripts/gdb/linux/symbols.py
+++ b/scripts/gdb/linux/symbols.py
@@ -133,7 +133,7 @@ lx-symbols command."""
         gdb.execute("symbol-file vmlinux")
 
         self.loaded_modules = []
-        module_list = modules.ModuleList()
+        module_list = modules.module_list()
         if not module_list:
             gdb.write("no modules found\n")
         else:
-- 
2.1.4

