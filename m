Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaFFRTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:19:39 -0400
Received: from goliath.siemens.de ([192.35.17.28]:34740 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaFFRTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH v8 07/22] scripts/gdb: Add automatic symbol reloading on module insertion
Date: Fri,  6 Jun 2014 19:18:48 +0200
Message-Id: <1c5080349ff5e084dbf2e123f710e4aaa8b58ca6.1402075139.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1402075136.git.jan.kiszka@siemens.com>
References: <cover.1402075136.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1402075136.git.jan.kiszka@siemens.com>
References: <cover.1402075136.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This installs a silent breakpoint on the do_init_module function. The
breakpoint handler will try to load symbols from the module files found
during lx-symbols execution. This way, breakpoints can be set to module
initialization functions, and there is no need to explicitly call
lx-symbols after (re-)loading a module.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/symbols.py | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/scripts/gdb/linux/symbols.py b/scripts/gdb/linux/symbols.py
index bd21a96..139841f 100644
--- a/scripts/gdb/linux/symbols.py
+++ b/scripts/gdb/linux/symbols.py
@@ -19,6 +19,30 @@ import string
 from linux import modules, utils
 
 
+if hasattr(gdb, 'Breakpoint'):
+    class LoadModuleBreakpoint(gdb.Breakpoint):
+        def __init__(self, spec, gdb_command):
+            super(LoadModuleBreakpoint, self).__init__(spec, internal=True)
+            self.silent = True
+            self.gdb_command = gdb_command
+
+        def stop(self):
+            module = gdb.parse_and_eval("mod")
+            module_name = module['name'].string()
+            cmd = self.gdb_command
+
+            # enforce update if object file is not found
+            cmd.module_files_updated = False
+
+            if module_name in cmd.loaded_modules:
+                gdb.write("refreshing all symbols to reload module "
+                          "'{0}'\n".format(module_name))
+                cmd.load_all_symbols()
+            else:
+                cmd.load_module_symbols(module)
+            return False
+
+
 class LxSymbols(gdb.Command):
     """(Re-)load symbols of Linux kernel and currently loaded modules.
 
@@ -30,6 +54,8 @@ lx-symbols command."""
     module_paths = []
     module_files = []
     module_files_updated = False
+    loaded_modules = []
+    breakpoint = None
 
     def __init__(self):
         super(LxSymbols, self).__init__("lx-symbols", gdb.COMMAND_FILES,
@@ -87,6 +113,8 @@ lx-symbols command."""
                 addr=module_addr,
                 sections=self._section_arguments(module))
             gdb.execute(cmdline, to_string=True)
+            if not module_name in self.loaded_modules:
+                self.loaded_modules.append(module_name)
         else:
             gdb.write("no module object found for '{0}'\n".format(module_name))
 
@@ -104,6 +132,7 @@ lx-symbols command."""
         gdb.execute("symbol-file", to_string=True)
         gdb.execute("symbol-file vmlinux")
 
+        self.loaded_modules = []
         module_list = modules.ModuleList()
         if not module_list:
             gdb.write("no modules found\n")
@@ -123,5 +152,15 @@ lx-symbols command."""
 
         self.load_all_symbols()
 
+        if hasattr(gdb, 'Breakpoint'):
+            if not self.breakpoint is None:
+                self.breakpoint.delete()
+                self.breakpoint = None
+            self.breakpoint = LoadModuleBreakpoint(
+                "kernel/module.c:do_init_module", self)
+        else:
+            gdb.write("Note: symbol update on module loading not supported "
+                      "with this gdb version\n")
+
 
 LxSymbols()
-- 
1.8.1.1.298.ge7eed54

