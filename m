Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789Ab3IDOnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:43:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935061Ab3IDOnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:43:18 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jstancek@redhat.com, keescook@chromium.org, peter.oberparleiter@de.ibm.com,
        rusty@rustcorp.com.au, linux-arch@vger.kernel.org, arnd@arndb.de,
        mgahagan@redhat.com, agospoda@redhat.com, akpm@linux-foundation.org
Subject: [PATCH v2 3/4] gcov: compile specific gcov implementation based on gcc version
Date: Wed,  4 Sep 2013 16:42:55 +0200
Message-Id: <1378305776-3644-4-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile the correct gcov implementation file for the specific gcc version.

v2: - added possibility to explicitly select gcc version during configuration,
      this is based on code provided by Peter Oberparleiter.
    - added a note about gcov format selection to gcov.txt

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
---
 Documentation/gcov.txt |  4 ++++
 kernel/gcov/Kconfig    | 30 ++++++++++++++++++++++++++++++
 kernel/gcov/Makefile   | 32 +++++++++++++++++++++++++++++++-
 3 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/Documentation/gcov.txt b/Documentation/gcov.txt
index e7ca647..7b72778 100644
--- a/Documentation/gcov.txt
+++ b/Documentation/gcov.txt
@@ -50,6 +50,10 @@ Configure the kernel with:
         CONFIG_DEBUG_FS=y
         CONFIG_GCOV_KERNEL=y
 
+select the gcc's gcov format, default is autodetect based on gcc version:
+
+        CONFIG_GCOV_FORMAT_AUTODETECT=y
+
 and to get coverage data for the entire kernel:
 
         CONFIG_GCOV_PROFILE_ALL=y
diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index d4da55d..d04ce8a 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -46,4 +46,34 @@ config GCOV_PROFILE_ALL
 	larger and run slower. Also be sure to exclude files from profiling
 	which are not linked to the kernel image to prevent linker errors.
 
+choice
+	prompt "Specify GCOV format"
+	depends on GCOV_KERNEL
+	default GCOV_FORMAT_AUTODETECT
+	---help---
+	The gcov format is usually determined by the GCC version, but there are
+	exceptions where format changes are integrated in lower-version GCCs.
+	In such a case use this option to adjust the format used in the kernel
+	accordingly.
+
+	If unsure, choose "Autodetect".
+
+config GCOV_FORMAT_AUTODETECT
+	bool "Autodetect"
+	---help---
+	Select this option to use the format that corresponds to your GCC
+	version.
+
+config GCOV_FORMAT_3_4
+	bool "GCC 3.4 format"
+	---help---
+	Select this option to use the format defined by GCC 3.4.
+
+config GCOV_FORMAT_4_7
+	bool "GCC 4.7 format"
+	---help---
+	Select this option to use the format defined by GCC 4.7.
+
+endchoice
+
 endmenu
diff --git a/kernel/gcov/Makefile b/kernel/gcov/Makefile
index e97ca59..52aa7e8 100644
--- a/kernel/gcov/Makefile
+++ b/kernel/gcov/Makefile
@@ -1,3 +1,33 @@
 ccflags-y := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
 
-obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o gcc_3_4.o
+# if-lt
+# Usage VAR := $(call if-lt, $(a), $(b))
+# Returns 1 if (a < b)
+if-lt = $(shell [ $(1) -lt $(2) ] && echo 1)
+
+ifeq ($(CONFIG_GCOV_FORMAT_3_4),y)
+  cc-ver := 0304
+else ifeq ($(CONFIG_GCOV_FORMAT_4_7),y)
+  cc-ver := 0407
+else
+# Use cc-version if available, otherwise set 0
+#
+# scripts/Kbuild.include, which contains cc-version function, is not included
+# during make clean "make -f scripts/Makefile.clean obj=kernel/gcov"
+# Meaning cc-ver is empty causing if-lt test to fail with
+# "/bin/sh: line 0: [: -lt: unary operator expected" error mesage.
+# This has no affect on the clean phase, but the error message could be
+# confusing/annoying. So this dummy workaround sets cc-ver to zero if cc-version
+# is not available. We can probably move if-lt to Kbuild.include, so it's also
+# not defined during clean or to include Kbuild.include in
+# scripts/Makefile.clean. But the following workaround seems least invasive.
+  cc-ver := $(if $(call cc-version),$(call cc-version),0)
+endif
+
+obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o
+
+ifeq ($(call if-lt, $(cc-ver), 0407),1)
+  obj-$(CONFIG_GCOV_KERNEL) += gcc_3_4.o
+else
+  obj-$(CONFIG_GCOV_KERNEL) += gcc_4_7.o
+endif
-- 
1.8.3.1

