Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbbA2GyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:54:05 -0500
Received: from david.siemens.de ([192.35.17.14]:58352 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757255AbbA2Gx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:53:57 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH v11 20/28] scripts/gdb: Add lx-lsmod command
Date: Thu, 29 Jan 2015 07:46:39 +0100
Message-Id: <3cd26d0e0533cc2eeb4d0f155b2b315766606fe7.1422514006.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a lsmod-like command to list all currently loaded modules of
the target.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/modules.py | 46 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/modules.py b/scripts/gdb/linux/modules.py
index 531f763..e7c99e9 100644
--- a/scripts/gdb/linux/modules.py
+++ b/scripts/gdb/linux/modules.py
@@ -13,7 +13,7 @@
 
 import gdb
 
-from linux import utils
+from linux import cpus, utils
 
 
 module_type = utils.CachedType("struct module")
@@ -65,3 +65,47 @@ of the target and return that module variable which MODULE matches."""
 
 
 LxModule()
+
+
+class LxLsmod(gdb.Command):
+    """List currently loaded modules."""
+
+    _module_use_type = utils.CachedType("struct module_use")
+
+    def __init__(self):
+        super(LxLsmod, self).__init__("lx-lsmod", gdb.COMMAND_DATA)
+
+    def invoke(self, arg, from_tty):
+        gdb.write(
+            "Address{0}    Module                  Size  Used by\n".format(
+                "        " if utils.get_long_type().sizeof == 8 else ""))
+
+        for module in ModuleList():
+            ref = 0
+            module_refptr = module['refptr']
+            for cpu in cpus.CpuList("cpu_possible_mask"):
+                refptr = cpus.per_cpu(module_refptr, cpu)
+                ref += refptr['incs']
+                ref -= refptr['decs']
+
+            gdb.write("{address} {name:<19} {size:>8}  {ref}".format(
+                address=str(module['module_core']).split()[0],
+                name=module['name'].string(),
+                size=module['core_size'],
+                ref=ref))
+
+            source_list = module['source_list']
+            t = self._module_use_type.get_type().pointer()
+            entry = source_list['next']
+            first = True
+            while entry != source_list.address:
+                use = utils.container_of(entry, t, "source_list")
+                gdb.write("{separator}{name}".format(
+                    separator=" " if first else ",",
+                    name=use['source']['name'].string()))
+                first = False
+                entry = entry['next']
+            gdb.write("\n")
+
+
+LxLsmod()
-- 
2.1.4

