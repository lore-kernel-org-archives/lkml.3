Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935340AbaH0PWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:22:36 -0400
Received: from goliath.siemens.de ([192.35.17.28]:33829 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935318AbaH0PWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:34 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Pantelis Koukousoulas <pktoss@gmail.com>
Subject: [PATCH v9 22/23] scripts/gdb: Port to python3 / gdb7.7
Date: Wed, 27 Aug 2014 17:21:37 +0200
Message-Id: <ed6169f8904c57410d1931fd370070e01ce02762.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Koukousoulas <pktoss@gmail.com>

I tried to use these scripts in an ubuntu 14.04 host (gdb 7.7 compiled
against python 3.3) but there were several errors.

I believe this patch fixes these issues so that the commands
now work (I tested lx-symbols, lx-dmesg, lx-lsmod).

Main issues that needed to be resolved:

  * In python 2 iterators have a "next()" method. In python 3 it is
    __next__() instead (so let's just add both).

  * In older python versions there was an implicit conversion
    in object.__format__() (used when an object is in string.format())
    where it was converting the object to str first and then
    calling str's __format__(). This has now been removed so
    we must explicitly convert to str the objects for which
    we need to keep this behavior.

  * In dmesg.py: in python 3 log_buf is now a "memoryview" object
    which needs to be converted to a string in order to use string
    methods like "splitlines()". Luckily memoryview exists in
    python 2.7.6 as well, so we can convert log_buf to memoryview
    and use the same code in both python 2 and python 3.

This version of the patch has now been tested with gdb 7.7 and
both python 3.4 and python 2.7.6 (I think asking for at least
python 2.7.6 is a reasonable requirement instead of complicating
the code with version checks etc).

Signed-off-by: Pantelis Koukousoulas <pktoss@gmail.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/cpus.py    | 5 ++++-
 scripts/gdb/linux/dmesg.py   | 3 ++-
 scripts/gdb/linux/modules.py | 9 ++++++---
 scripts/gdb/linux/symbols.py | 4 ++--
 scripts/gdb/linux/tasks.py   | 4 +++-
 scripts/gdb/linux/utils.py   | 2 +-
 6 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/scripts/gdb/linux/cpus.py b/scripts/gdb/linux/cpus.py
index c1441f2..8045871 100644
--- a/scripts/gdb/linux/cpus.py
+++ b/scripts/gdb/linux/cpus.py
@@ -82,7 +82,7 @@ class CpuList():
     def __iter__(self):
         return self
 
-    def next(self):
+    def __next__(self):
         while self.bits == 0:
             self.entry += 1
             if self.entry == self.num_entries:
@@ -103,6 +103,9 @@ class CpuList():
 
         return cpu
 
+    def next(self):
+        return self.__next__()
+
 
 class PerCpu(gdb.Function):
     """Return per-cpu variable.
diff --git a/scripts/gdb/linux/dmesg.py b/scripts/gdb/linux/dmesg.py
index 7650f24..3c947f0 100644
--- a/scripts/gdb/linux/dmesg.py
+++ b/scripts/gdb/linux/dmesg.py
@@ -51,9 +51,10 @@ class LxDmesg(gdb.Command):
                 continue
 
             text_len = utils.read_u16(log_buf[pos + 10:pos + 12])
+            text = log_buf[pos + 16:pos + 16 + text_len]
             time_stamp = utils.read_u64(log_buf[pos:pos + 8])
 
-            for line in log_buf[pos + 16:pos + 16 + text_len].splitlines():
+            for line in memoryview(text).tobytes().splitlines():
                 gdb.write("[{time:12.6f}] {line}\n".format(
                     time=time_stamp / 1000000000.0,
                     line=line))
diff --git a/scripts/gdb/linux/modules.py b/scripts/gdb/linux/modules.py
index e7c99e9..2dbf679 100644
--- a/scripts/gdb/linux/modules.py
+++ b/scripts/gdb/linux/modules.py
@@ -30,7 +30,7 @@ class ModuleList:
     def __iter__(self):
         return self
 
-    def next(self):
+    def __next__(self):
         entry = self.curr_entry
         if entry != self.end_of_list:
             self.curr_entry = entry['next']
@@ -38,6 +38,9 @@ class ModuleList:
         else:
             raise StopIteration
 
+    def next(self):
+        return self.__next__()
+
 
 def find_module_by_name(name):
     for module in ModuleList():
@@ -91,8 +94,8 @@ class LxLsmod(gdb.Command):
             gdb.write("{address} {name:<19} {size:>8}  {ref}".format(
                 address=str(module['module_core']).split()[0],
                 name=module['name'].string(),
-                size=module['core_size'],
-                ref=ref))
+                size=str(module['core_size']),
+                ref=str(ref)))
 
             source_list = module['source_list']
             t = self._module_use_type.get_type().pointer()
diff --git a/scripts/gdb/linux/symbols.py b/scripts/gdb/linux/symbols.py
index 139841f..ae757fd 100644
--- a/scripts/gdb/linux/symbols.py
+++ b/scripts/gdb/linux/symbols.py
@@ -73,7 +73,7 @@ lx-symbols command."""
 
     def _get_module_file(self, module_name):
         module_pattern = ".*/{0}\.ko$".format(
-            string.replace(module_name, "_", r"[_\-]"))
+            module_name.replace("_", r"[_\-]"))
         for name in self.module_files:
             if re.match(module_pattern, name) and os.path.exists(name):
                 return name
@@ -87,7 +87,7 @@ lx-symbols command."""
         attrs = sect_attrs['attrs']
         section_name_to_address = {
             attrs[n]['name'].string() : attrs[n]['address']
-            for n in range(sect_attrs['nsections'])}
+            for n in range(int(sect_attrs['nsections']))}
         args = []
         for section_name in [".data", ".data..read_mostly", ".rodata", ".bss"]:
             address = section_name_to_address.get(section_name)
diff --git a/scripts/gdb/linux/tasks.py b/scripts/gdb/linux/tasks.py
index 63cd6c5..0008e75 100644
--- a/scripts/gdb/linux/tasks.py
+++ b/scripts/gdb/linux/tasks.py
@@ -30,7 +30,7 @@ class TaskList:
     def __iter__(self):
         return self
 
-    def next(self):
+    def __next__(self):
         t = self.curr_task
         if not t or t == self.curr_group:
             self.curr_group = \
@@ -45,6 +45,8 @@ class TaskList:
                                    self.task_ptr_type, "thread_group")
         return t
 
+    def next(self):
+        return self.__next__()
 
 def get_task_by_pid(pid):
     for task in TaskList():
diff --git a/scripts/gdb/linux/utils.py b/scripts/gdb/linux/utils.py
index a4a1640..128c306 100644
--- a/scripts/gdb/linux/utils.py
+++ b/scripts/gdb/linux/utils.py
@@ -83,7 +83,7 @@ def get_target_endianness():
         elif "big endian" in endian:
             target_endianness = BIG_ENDIAN
         else:
-            raise gdb.GdgError("unknown endianness '{0}'".format(endian))
+            raise gdb.GdgError("unknown endianness '{0}'".format(str(endian)))
     return target_endianness
 
 
-- 
1.8.1.1.298.ge7eed54

