Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbaIILC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:02:59 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:49096 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129AbaIILCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:02:32 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kbuild: handle C=... and M=... after entering into build directory
Date: Tue,  9 Sep 2014 20:02:24 +0900
Message-Id: <1410260544-22657-4-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit avoids processing C=... and M=... twice
when O=... is also given.

Besides, we can also remove KBUILD_EXTMOD="$(KBUILD_EXTMOD)"
in the sub-make target.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 Makefile | 60 +++++++++++++++++++++++++++++-------------------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/Makefile b/Makefile
index 105919a..48c8ee1 100644
--- a/Makefile
+++ b/Makefile
@@ -95,34 +95,6 @@ endif
 
 export quiet Q KBUILD_VERBOSE
 
-# Call a source code checker (by default, "sparse") as part of the
-# C compilation.
-#
-# Use 'make C=1' to enable checking of only re-compiled files.
-# Use 'make C=2' to enable checking of *all* source files, regardless
-# of whether they are re-compiled or not.
-#
-# See the file "Documentation/sparse.txt" for more details, including
-# where to get the "sparse" utility.
-
-ifeq ("$(origin C)", "command line")
-  KBUILD_CHECKSRC = $(C)
-endif
-ifndef KBUILD_CHECKSRC
-  KBUILD_CHECKSRC = 0
-endif
-
-# Use make M=dir to specify directory of external module to build
-# Old syntax make ... SUBDIRS=$PWD is still supported
-# Setting the environment variable KBUILD_EXTMOD take precedence
-ifdef SUBDIRS
-  KBUILD_EXTMOD ?= $(SUBDIRS)
-endif
-
-ifeq ("$(origin M)", "command line")
-  KBUILD_EXTMOD := $(M)
-endif
-
 # kbuild supports saving output files in a separate directory.
 # To locate output files in a separate directory two syntaxes are supported.
 # In both cases the working directory must be the root of the kernel src.
@@ -138,7 +110,6 @@ endif
 # The O= assignment takes precedence over the KBUILD_OUTPUT environment
 # variable.
 
-
 # KBUILD_SRC is set on invocation of make in OBJ directory
 # KBUILD_SRC is not intended to be used by the regular user (for now)
 ifeq ($(KBUILD_SRC),)
@@ -172,8 +143,7 @@ $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
 
 sub-make: FORCE
 	$(Q)$(MAKE) -C $(KBUILD_OUTPUT) KBUILD_SRC=$(CURDIR) \
-	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \
-	$(filter-out _all sub-make,$(MAKECMDGOALS))
+	-f $(CURDIR)/Makefile $(filter-out _all sub-make,$(MAKECMDGOALS))
 
 # Leave processing to above invocation of make
 skip-makefile := 1
@@ -188,6 +158,34 @@ ifeq ($(skip-makefile),)
 # so that IDEs/editors are able to understand relative filenames.
 MAKEFLAGS += --no-print-directory
 
+# Call a source code checker (by default, "sparse") as part of the
+# C compilation.
+#
+# Use 'make C=1' to enable checking of only re-compiled files.
+# Use 'make C=2' to enable checking of *all* source files, regardless
+# of whether they are re-compiled or not.
+#
+# See the file "Documentation/sparse.txt" for more details, including
+# where to get the "sparse" utility.
+
+ifeq ("$(origin C)", "command line")
+  KBUILD_CHECKSRC = $(C)
+endif
+ifndef KBUILD_CHECKSRC
+  KBUILD_CHECKSRC = 0
+endif
+
+# Use make M=dir to specify directory of external module to build
+# Old syntax make ... SUBDIRS=$PWD is still supported
+# Setting the environment variable KBUILD_EXTMOD take precedence
+ifdef SUBDIRS
+  KBUILD_EXTMOD ?= $(SUBDIRS)
+endif
+
+ifeq ("$(origin M)", "command line")
+  KBUILD_EXTMOD := $(M)
+endif
+
 # If building an external module we do not care about the all: rule
 # but instead _all depend on modules
 PHONY += all
-- 
1.9.1

