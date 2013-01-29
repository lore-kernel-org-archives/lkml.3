Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3A2MjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:39:05 -0500
Received: from thoth.sbs.de ([192.35.17.2]:23354 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab3A2MjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:39:02 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 19/20] scripts/gdb: Add lx-lsmod command
Date: Tue, 29 Jan 2013 13:38:02 +0100
Message-Id: <e592cdaed1fcfd4abe425d72a6a46ab761774194.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a lsmod-like command to list all currently loaded modules of
the target.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/module.py |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/module.py b/scripts/gdb/module.py
index 333729a..101d2e0 100644
--- a/scripts/gdb/module.py
+++ b/scripts/gdb/module.py
@@ -15,6 +15,7 @@ import gdb
 import os
 import string
 
+from percpu import *
 from utils import *
 
 module_type = CachedType("struct module")
@@ -104,3 +105,45 @@ class LxModvar(gdb.Function):
 		return var_addr.cast(var.type.pointer()).dereference()
 
 LxModvar()
+
+
+class LinuxLsmod(gdb.Command):
+	__doc__ = "List currently loaded modules."
+
+	_module_use_type = CachedType("struct module_use")
+
+	def __init__(self):
+		super(LinuxLsmod, self).__init__("lx-lsmod", gdb.COMMAND_DATA)
+
+	def invoke(self, arg, from_tty):
+		def print_module(module, arg):
+			def collect_ref(cpu, arg):
+				refptr = per_cpu(arg['refptr'], cpu)
+				arg['ref'] += refptr['incs']
+				arg['ref'] -= refptr['decs']
+
+			arg = { 'refptr': module['refptr'], 'ref': 0 }
+			for_each_cpu("cpu_possible_mask", collect_ref, arg)
+
+			print "%s" % module['module_core'] + \
+			      " %-19s" % module['name'].string() + \
+			      " %8s" % module['core_size'] + \
+			      "  %d" % arg['ref'],
+
+			source_list = module['source_list']
+			t = self._module_use_type.get_type().pointer()
+			entry = source_list['next']
+			first = True
+			while entry != source_list.address:
+				use = container_of(entry, t, "source_list")
+				gdb.write((" " if first else ",") + \
+					  use['source']['name'].string())
+				first = False
+				entry = entry['next']
+			print
+
+		print "Address%s    Module                  Size  Used by" % \
+		      "        " if get_long_type().sizeof == 8 else ""
+		for_each_module(print_module)
+
+LinuxLsmod()
-- 
1.7.3.4

