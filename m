Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3A2Mih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:38:37 -0500
Received: from david.siemens.de ([192.35.17.14]:29285 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab3A2Mig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:38:36 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 07/20] scripts/gdb: Add lx_modvar convenience function
Date: Tue, 29 Jan 2013 13:37:50 +0100
Message-Id: <891cf2ac77f548810473403ca7f224ada8ac1d1e.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function looks up and returns global module variables. Gdb is only
aware of their types and section offsets, not their absolute addresses.
The function either searches the symbol table of a specified module or
it derives the module name from the object file of the current frame.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/module.py |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/utils.py  |    7 +++++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/module.py b/scripts/gdb/module.py
index e309c0a..333729a 100644
--- a/scripts/gdb/module.py
+++ b/scripts/gdb/module.py
@@ -12,6 +12,8 @@
 #
 
 import gdb
+import os
+import string
 
 from utils import *
 
@@ -56,3 +58,49 @@ class LxModule(gdb.Function):
 			raise gdb.GdbError("Unable to find MODULE " + mod_name)
 
 LxModule()
+
+
+class LxModvar(gdb.Function):
+	__doc__ = "Return global variable of a module.\n" \
+		  "\n" \
+		  "$lx_modvar(\"VAR\"[, \"MODULE\"]): Return the global variable called VAR that is\n" \
+		  "defined by given MODULE. If MODULE is omitted, the current frame is used to\n" \
+		  "try finding the corresponding module name."
+
+	def __init__(self):
+		super(LxModvar, self).__init__("lx_modvar")
+
+	def _lookup_mod_symbol(self, module, var_name):
+		char_ptr_type = get_char_type().pointer()
+		for i in range(0, int(module['num_symtab'])):
+			symtab_entry = module['symtab'][i]
+			idx = int(symtab_entry['st_name'])
+			synname_addr = module['strtab'][idx].address
+			symname = synname_addr.cast(char_ptr_type)
+			if symname.string() == var_name:
+				return symtab_entry['st_value']
+		return None
+
+	def invoke(self, var_name, mod_name = None):
+		if (mod_name == None):
+			obj = gdb.selected_frame().function().symtab.objfile
+			mod_name = string.replace(
+				os.path.basename(obj.filename), ".ko", "")
+			module = find_module_by_name(mod_name)
+			if module == None:
+				raise gdb.GdbError("Current frame does not " \
+						   "belong to a module")
+		else:
+			mod_name = mod_name.string()
+			module = find_module_by_name(mod_name)
+			if module == None:
+				raise gdb.GdbError("Unable to find MODULE " +
+						   mod_name)
+		var_name = var_name.string()
+		var_addr = self._lookup_mod_symbol(module, var_name)
+		if var_addr == None:
+			raise gdb.GdbError("Unable to find VAR " + var_name)
+		var = gdb.parse_and_eval(var_name)
+		return var_addr.cast(var.type.pointer()).dereference()
+
+LxModvar()
diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index d1f6f12..13f903a 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -45,6 +45,13 @@ def get_long_type():
 	return long_type.get_type()
 
 
+char_type = CachedType("char")
+
+def get_char_type():
+	global char_type
+	return char_type.get_type()
+
+
 def offset_of(typeobj, field):
 	element = gdb.Value(0).cast(typeobj)
 	return int(str(element[field].address).split()[0], 16)
-- 
1.7.3.4

