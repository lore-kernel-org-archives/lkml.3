Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab3KLHQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:16:32 -0500
Received: from goliath.siemens.de ([192.35.17.28]:21325 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3KLHPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:15:23 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v7 19/21] scripts/gdb: Add class to iterate over CPU masks
Date: Tue, 12 Nov 2013 08:14:37 +0100
Message-Id: <e19b62bf6ddfdfd1dfb1a1bc9736abb4a2379670.1384240478.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will be used first to count module references. It is optimized to read
the mask only once per stop.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/cpus.py | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/scripts/gdb/linux/cpus.py b/scripts/gdb/linux/cpus.py
index b683da9..c1441f2 100644
--- a/scripts/gdb/linux/cpus.py
+++ b/scripts/gdb/linux/cpus.py
@@ -50,6 +50,60 @@ def per_cpu(var_ptr, cpu):
     return pointer.cast(var_ptr.type).dereference()
 
 
+cpu_mask = {}
+
+
+def cpu_mask_invalidate(event):
+    global cpu_mask
+    cpu_mask = {}
+    gdb.events.stop.disconnect(cpu_mask_invalidate)
+    if hasattr(gdb.events, 'new_objfile'):
+        gdb.events.new_objfile.disconnect(cpu_mask_invalidate)
+
+
+class CpuList():
+    def __init__(self, mask_name):
+        global cpu_mask
+        self.mask = None
+        if mask_name in cpu_mask:
+            self.mask = cpu_mask[mask_name]
+        if self.mask is None:
+            self.mask = gdb.parse_and_eval(mask_name + ".bits")
+            if hasattr(gdb, 'events'):
+                cpu_mask[mask_name] = self.mask
+                gdb.events.stop.connect(cpu_mask_invalidate)
+                if hasattr(gdb.events, 'new_objfile'):
+                    gdb.events.new_objfile.connect(cpu_mask_invalidate)
+        self.bits_per_entry = self.mask[0].type.sizeof * 8
+        self.num_entries = self.mask.type.sizeof * 8 / self.bits_per_entry
+        self.entry = -1
+        self.bits = 0
+
+    def __iter__(self):
+        return self
+
+    def next(self):
+        while self.bits == 0:
+            self.entry += 1
+            if self.entry == self.num_entries:
+                raise StopIteration
+            self.bits = self.mask[self.entry]
+            if self.bits != 0:
+                self.bit = 0
+                break
+
+        while self.bits & 1 == 0:
+            self.bits >>= 1
+            self.bit += 1
+
+        cpu = self.entry * self.bits_per_entry + self.bit
+
+        self.bits >>= 1
+        self.bit += 1
+
+        return cpu
+
+
 class PerCpu(gdb.Function):
     """Return per-cpu variable.
 
-- 
1.8.1.1.298.ge7eed54

