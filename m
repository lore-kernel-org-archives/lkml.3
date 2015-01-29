Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbbA2HNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:13:49 -0500
Received: from goliath.siemens.de ([192.35.17.28]:35488 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbbA2HNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:13:32 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH v11 26/28] scripts/gdb: Convert CpuList to generator function
Date: Thu, 29 Jan 2015 07:46:45 +0100
Message-Id: <aefbfe800ee8e5da8702cf8b079a64b24a933462.1422514006.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yet another code simplification.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/cpus.py    | 71 ++++++++++++++++++++------------------------
 scripts/gdb/linux/modules.py |  2 +-
 2 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/scripts/gdb/linux/cpus.py b/scripts/gdb/linux/cpus.py
index 8045871..4297b83 100644
--- a/scripts/gdb/linux/cpus.py
+++ b/scripts/gdb/linux/cpus.py
@@ -61,50 +61,43 @@ def cpu_mask_invalidate(event):
         gdb.events.new_objfile.disconnect(cpu_mask_invalidate)
 
 
-class CpuList():
-    def __init__(self, mask_name):
-        global cpu_mask
-        self.mask = None
-        if mask_name in cpu_mask:
-            self.mask = cpu_mask[mask_name]
-        if self.mask is None:
-            self.mask = gdb.parse_and_eval(mask_name + ".bits")
-            if hasattr(gdb, 'events'):
-                cpu_mask[mask_name] = self.mask
-                gdb.events.stop.connect(cpu_mask_invalidate)
-                if hasattr(gdb.events, 'new_objfile'):
-                    gdb.events.new_objfile.connect(cpu_mask_invalidate)
-        self.bits_per_entry = self.mask[0].type.sizeof * 8
-        self.num_entries = self.mask.type.sizeof * 8 / self.bits_per_entry
-        self.entry = -1
-        self.bits = 0
-
-    def __iter__(self):
-        return self
-
-    def __next__(self):
-        while self.bits == 0:
-            self.entry += 1
-            if self.entry == self.num_entries:
-                raise StopIteration
-            self.bits = self.mask[self.entry]
-            if self.bits != 0:
-                self.bit = 0
+def cpu_list(mask_name):
+    global cpu_mask
+    mask = None
+    if mask_name in cpu_mask:
+        mask = cpu_mask[mask_name]
+    if mask is None:
+        mask = gdb.parse_and_eval(mask_name + ".bits")
+        if hasattr(gdb, 'events'):
+            cpu_mask[mask_name] = mask
+            gdb.events.stop.connect(cpu_mask_invalidate)
+            if hasattr(gdb.events, 'new_objfile'):
+                gdb.events.new_objfile.connect(cpu_mask_invalidate)
+    bits_per_entry = mask[0].type.sizeof * 8
+    num_entries = mask.type.sizeof * 8 / bits_per_entry
+    entry = -1
+    bits = 0
+
+    while True:
+        while bits == 0:
+            entry += 1
+            if entry == num_entries:
+                return
+            bits = mask[entry]
+            if bits != 0:
+                bit = 0
                 break
 
-        while self.bits & 1 == 0:
-            self.bits >>= 1
-            self.bit += 1
-
-        cpu = self.entry * self.bits_per_entry + self.bit
+        while bits & 1 == 0:
+            bits >>= 1
+            bit += 1
 
-        self.bits >>= 1
-        self.bit += 1
+        cpu = entry * bits_per_entry + bit
 
-        return cpu
+        bits >>= 1
+        bit += 1
 
-    def next(self):
-        return self.__next__()
+        yield cpu
 
 
 class PerCpu(gdb.Function):
diff --git a/scripts/gdb/linux/modules.py b/scripts/gdb/linux/modules.py
index 6d49722..a1504c4 100644
--- a/scripts/gdb/linux/modules.py
+++ b/scripts/gdb/linux/modules.py
@@ -75,7 +75,7 @@ class LxLsmod(gdb.Command):
         for module in module_list():
             ref = 0
             module_refptr = module['refptr']
-            for cpu in cpus.CpuList("cpu_possible_mask"):
+            for cpu in cpus.cpu_list("cpu_possible_mask"):
                 refptr = cpus.per_cpu(module_refptr, cpu)
                 ref += refptr['incs']
                 ref -= refptr['decs']
-- 
2.1.4

