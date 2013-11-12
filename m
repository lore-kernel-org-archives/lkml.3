Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab3KLHSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:18:51 -0500
Received: from david.siemens.de ([192.35.17.14]:27491 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab3KLHPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:15:14 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH v7 01/21] scripts/gdb: Add infrastructure
Date: Tue, 12 Nov 2013 08:14:19 +0100
Message-Id: <6f0bae20cfc5e65583ff3d40a6e04a0b2b44d026.1384240478.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
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
 Makefile                      |  5 ++++-
 lib/Kconfig.debug             | 11 +++++++++++
 scripts/Makefile              |  3 ++-
 scripts/gdb/Makefile          | 11 +++++++++++
 scripts/gdb/linux/Makefile    |  9 +++++++++
 scripts/gdb/linux/__init__.py |  0
 scripts/gdb/vmlinux-gdb.py    | 23 +++++++++++++++++++++++
 7 files changed, 60 insertions(+), 2 deletions(-)
 create mode 100644 scripts/gdb/Makefile
 create mode 100644 scripts/gdb/linux/Makefile
 create mode 100644 scripts/gdb/linux/__init__.py
 create mode 100644 scripts/gdb/vmlinux-gdb.py

diff --git a/Makefile b/Makefile
index 67077ad..9196097 100644
--- a/Makefile
+++ b/Makefile
@@ -778,6 +778,9 @@ endif
 ifdef CONFIG_BUILD_DOCSRC
 	$(Q)$(MAKE) $(build)=Documentation
 endif
+ifdef CONFIG_GDB_SCRIPTS
+	$(Q)ln -fsn $(srctree)/scripts/gdb/vmlinux-gdb.py
+endif
 	+$(call if_changed,link-vmlinux)
 
 # The actual objects are generated when descending, 
@@ -1026,7 +1029,7 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
 		  signing_key.priv signing_key.x509 x509.genkey		\
 		  extra_certificates signing_key.x509.keyid		\
-		  signing_key.x509.signer
+		  signing_key.x509.signer vmlinux-gdb.py
 
 # clean - Delete most, but leave enough to build external modules
 #
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ebef88f..fb15d00 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -143,6 +143,17 @@ config DEBUG_INFO_REDUCED
 	  DEBUG_INFO build and compile times are reduced too.
 	  Only works with newer gcc versions.
 
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
index 01e7adb..672f65d 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -37,6 +37,7 @@ subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
 subdir-$(CONFIG_DTC)         += dtc
+subdir-$(CONFIG_GDB_SCRIPTS) += gdb
 
 # Let clean descend into subdirs
-subdir-	+= basic kconfig package selinux
+subdir-	+= basic kconfig package selinux gdb
diff --git a/scripts/gdb/Makefile b/scripts/gdb/Makefile
new file mode 100644
index 0000000..c0e2fd3
--- /dev/null
+++ b/scripts/gdb/Makefile
@@ -0,0 +1,11 @@
+subdir-y := linux
+
+always := gdb-scripts
+
+$(obj)/gdb-scripts:
+ifneq ($(KBUILD_SRC),)
+	$(Q)ln -fsn $(srctree)/$(obj)/*.py $(objtree)/$(obj)
+endif
+	@:
+
+clean-files := *.pyc $(if $(KBUILD_SRC),*.py)
diff --git a/scripts/gdb/linux/Makefile b/scripts/gdb/linux/Makefile
new file mode 100644
index 0000000..34ccd06
--- /dev/null
+++ b/scripts/gdb/linux/Makefile
@@ -0,0 +1,9 @@
+always := gdb-scripts
+
+$(obj)/gdb-scripts:
+ifneq ($(KBUILD_SRC),)
+	$(Q)ln -fsn $(srctree)/$(obj)/*.py $(objtree)/$(obj)
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

