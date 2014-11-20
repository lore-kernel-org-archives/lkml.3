Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbaKTRCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:02:49 -0500
Received: from thoth.sbs.de ([192.35.17.2]:43615 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334AbaKTRCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:02:42 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v10 20/27] scripts/gdb: Add lx-lsmod command
Date: Thu, 20 Nov 2014 18:01:57 +0100
Message-Id: <1a9300902f11cf131c60a04b90f06279f0556b27.1416502923.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
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
1.8.4.5

