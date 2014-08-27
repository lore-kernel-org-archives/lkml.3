Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935290AbaH0PWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:22:30 -0400
Received: from thoth.sbs.de ([192.35.17.2]:40275 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935241AbaH0PWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:21 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH v9 01/23] scripts/gdb: Add infrastructure
Date: Wed, 27 Aug 2014 17:21:16 +0200
Message-Id: <ba953a7332312d3e36421cc8b2dcb3fc33365ee7.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the basic infrastructure to load kernel-specific python
helper scripts when debugging the kernel in gdb.

The loading mechanism is based on gdb loading for <objfile>-gdb.py when
opening <objfile>. Therefore, this places a corresponding link to the
main helper script into the output directory that contains vmlinux.

The main scripts will pull in submodules containing Linux specific gdb
commands and functions. To avoid polluting the source directory with
compiled python modules, we link to them from the object directory.

Due to gdb.parse_and_eval and string redirection for gdb.execute, we
depend on gdb >= 7.2.

This feature is enabled via CONFIG_GDB_SCRIPTS.

CC: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 Makefile                      |  6 +++++-
 lib/Kconfig.debug             | 11 +++++++++++
 scripts/Makefile              |  3 ++-
 scripts/gdb/Makefile          |  1 +
 scripts/gdb/linux/Makefile    | 11 +++++++++++
 scripts/gdb/linux/__init__.py |  0
 scripts/gdb/vmlinux-gdb.py    | 23 +++++++++++++++++++++++
 7 files changed, 53 insertions(+), 2 deletions(-)
 create mode 100644 scripts/gdb/Makefile
 create mode 100644 scripts/gdb/linux/Makefile
 create mode 100644 scripts/gdb/linux/__init__.py
 create mode 100644 scripts/gdb/vmlinux-gdb.py

diff --git a/Makefile b/Makefile
index f64fc78..6cddc6f 100644
--- a/Makefile
+++ b/Makefile
@@ -912,6 +912,9 @@ endif
 ifdef CONFIG_BUILD_DOCSRC
 	$(Q)$(MAKE) $(build)=Documentation
 endif
+ifdef CONFIG_GDB_SCRIPTS
+	$(Q)ln -fsn `cd $(srctree) && /bin/pwd`/scripts/gdb/vmlinux-gdb.py
+endif
 	+$(call if_changed,link-vmlinux)
 
 # The actual objects are generated when descending,
@@ -1167,7 +1170,8 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
 		  signing_key.priv signing_key.x509 x509.genkey		\
 		  extra_certificates signing_key.x509.keyid		\
-		  signing_key.x509.signer include/linux/version.h
+		  signing_key.x509.signer include/linux/version.h	\
+		  vmlinux-gdb.py
 
 # clean - Delete most, but leave enough to build external modules
 #
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 07c2832..ab79d9b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -167,6 +167,17 @@ config DEBUG_INFO_DWARF4
 	  But it significantly improves the success of resolving
 	  variables in gdb on optimized code.
 
+config GDB_SCRIPTS
+	bool "Provide GDB scripts for kernel debugging"
+	select DEBUG_INFO
+	help
+	  This creates the required links to GDB helper scripts in the
+	  build directory. If you load vmlinux into gdb, the helper
+	  scripts will be automatically imported by gdb as well, and
+	  additional functions are available to analyze a Linux kernel
+	  instance. See Documentation/gdb-kernel-debugging.txt for further
+	  details.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y
diff --git a/scripts/Makefile b/scripts/Makefile
index 72902b5..7413b1b 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -36,6 +36,7 @@ subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
 subdir-$(CONFIG_DTC)         += dtc
+subdir-$(CONFIG_GDB_SCRIPTS) += gdb
 
 # Let clean descend into subdirs
-subdir-	+= basic kconfig package
+subdir-	+= basic kconfig package gdb
diff --git a/scripts/gdb/Makefile b/scripts/gdb/Makefile
new file mode 100644
index 0000000..62f5f65
--- /dev/null
+++ b/scripts/gdb/Makefile
@@ -0,0 +1 @@
+subdir-y := linux
diff --git a/scripts/gdb/linux/Makefile b/scripts/gdb/linux/Makefile
new file mode 100644
index 0000000..dcb63ab
--- /dev/null
+++ b/scripts/gdb/linux/Makefile
@@ -0,0 +1,11 @@
+always := gdb-scripts
+
+SRCTREE := $(shell cd $(srctree) && /bin/pwd)
+
+$(obj)/gdb-scripts:
+ifneq ($(KBUILD_SRC),)
+	$(Q)ln -fsn $(SRCTREE)/$(obj)/*.py $(objtree)/$(obj)
+endif
+	@:
+
+clean-files := *.pyc $(if $(KBUILD_SRC),*.py)
diff --git a/scripts/gdb/linux/__init__.py b/scripts/gdb/linux/__init__.py
new file mode 100644
index 0000000..e69de29
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
new file mode 100644
index 0000000..c1d90ce
--- /dev/null
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -0,0 +1,23 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  loader module
+#
+# Copyright (c) Siemens AG, 2012, 2013
+#
+# Authors:
+#  Jan Kiszka <jan.kiszka@siemens.com>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import os
+
+sys.path.insert(0, os.path.dirname(__file__) + "/scripts/gdb")
+
+try:
+    gdb.parse_and_eval("0")
+    gdb.execute("", to_string=True)
+except:
+    gdb.write("NOTE: gdb 7.2 or later required for Linux helper scripts to "
+              "work.\n")
-- 
1.8.1.1.298.ge7eed54

