Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906AbaH0PdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:33:07 -0400
Received: from thoth.sbs.de ([192.35.17.2]:40210 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934916AbaH0PWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:13 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v9 20/23] scripts/gdb: Add lx-lsmod command
Date: Wed, 27 Aug 2014 17:21:35 +0200
Message-Id: <a0d3d147017807743cf31235a07ccd7a5f399f94.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
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
1.8.1.1.298.ge7eed54

