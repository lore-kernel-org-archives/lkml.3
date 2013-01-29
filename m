Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3A2Mir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:38:47 -0500
Received: from thoth.sbs.de ([192.35.17.2]:23213 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609Ab3A2Mio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:38:44 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 06/20] scripts/gdb: Add internal helper and convenience function to look up a module
Date: Tue, 29 Jan 2013 13:37:49 +0100
Message-Id: <5c1a7b110bb2be463e979528d67a0ff7f1d54096.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the internal helper get_module_by_name to obtain the module
structure corresponding to the given name. Also export this service as a
convenience function.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/module.py      |   30 ++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/module.py b/scripts/gdb/module.py
index 01b23df..e309c0a 100644
--- a/scripts/gdb/module.py
+++ b/scripts/gdb/module.py
@@ -26,3 +26,33 @@ def for_each_module(func, arg = None):
 		module = container_of(entry, module_ptr_type, "list")
 		func(module, arg)
 		entry = entry['next']
+
+def find_module_by_name(name):
+	def match_name(module, arg):
+		if module['name'].string() == arg['name']:
+			arg['module'] = module
+
+	arg = { 'name': name, 'module': None }
+	for_each_module(match_name, arg)
+
+	return arg['module']
+
+
+class LxModule(gdb.Function):
+	__doc__ = "Find module by name and return the module variable.\n" \
+		  "\n" \
+		  "$lx_module(MODULE): Given the name MODULE, iterate over all loaded modules of\n" \
+		  "the target and return that module variable which MODULE matches."
+
+	def __init__(self):
+		super(LxModule, self).__init__("lx_module")
+
+	def invoke(self, mod_name):
+		mod_name = mod_name.string()
+		module = find_module_by_name(mod_name)
+		if module:
+			return module.dereference()
+		else:
+			raise gdb.GdbError("Unable to find MODULE " + mod_name)
+
+LxModule()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index 3553b7d..2a466a0 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -23,3 +23,4 @@ if gdb_version < "7.1":
 else:
 	import utils
 	import symbols
+	import module
-- 
1.7.3.4

