Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaDNJ2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:28:13 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:45771 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaDNJ2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:28:10 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v3] kbuild: move extra gcc checks to scripts/Makefile.extrawarn
Date: Mon, 14 Apr 2014 18:27:10 +0900
Message-Id: <1397467630-16727-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W=... provides extra gcc checks.

Having such code in scripts/Makefile.build results in the same flags
being added to KBUILD_CFLAGS multiple times becuase
scripts/Makefile.build is invoked every time Kbuild descends into
the subdirectories.

Since the top Makefile is already too cluttered, this commit moves
all of extra gcc check stuff to a new file scripts/Makefile.extrawarn,
which is included from the top Makefile.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Michal Marek <mmarek@suse.cz>
CC: Sam Ravnborg <sam@ravnborg.org>
---

Changes in v3:
  - Rebase on v3.15-rc1
     (v2 caused a conflict with Clang stuff.)

Changes in v2:
  - Move the code to a new file scripts/Makefile.extrawarn
  - Move also "KBUILD_ENABLE_EXTRA_GCC_CHECKS" definition


 Makefile                   |  6 ++---
 scripts/Makefile.build     | 61 -----------------------------------------
 scripts/Makefile.extrawarn | 67 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 65 deletions(-)
 create mode 100644 scripts/Makefile.extrawarn

diff --git a/Makefile b/Makefile
index 60ccbfe..8cc826a 100644
--- a/Makefile
+++ b/Makefile
@@ -105,10 +105,6 @@ ifeq ("$(origin O)", "command line")
   KBUILD_OUTPUT := $(O)
 endif
 
-ifeq ("$(origin W)", "command line")
-  export KBUILD_ENABLE_EXTRA_GCC_CHECKS := $(W)
-endif
-
 # That's our default target when none is given on the command line
 PHONY := _all
 _all:
@@ -731,6 +727,8 @@ ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
 	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
 endif
 
+include $(srctree)/scripts/Makefile.extrawarn
+
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 KBUILD_CPPFLAGS += $(KCPPFLAGS)
 KBUILD_AFLAGS += $(KAFLAGS)
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 003bc26..b5e02b6 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -50,67 +50,6 @@ ifeq ($(KBUILD_NOPEDANTIC),)
         endif
 endif
 
-#
-# make W=... settings
-#
-# W=1 - warnings that may be relevant and does not occur too often
-# W=2 - warnings that occur quite often but may still be relevant
-# W=3 - the more obscure warnings, can most likely be ignored
-#
-# $(call cc-option, -W...) handles gcc -W.. options which
-# are not supported by all versions of the compiler
-ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
-warning-  := $(empty)
-
-warning-1 := -Wextra -Wunused -Wno-unused-parameter
-warning-1 += -Wmissing-declarations
-warning-1 += -Wmissing-format-attribute
-warning-1 += $(call cc-option, -Wmissing-prototypes)
-warning-1 += -Wold-style-definition
-warning-1 += $(call cc-option, -Wmissing-include-dirs)
-warning-1 += $(call cc-option, -Wunused-but-set-variable)
-warning-1 += $(call cc-disable-warning, missing-field-initializers)
-
-# Clang
-warning-1 += $(call cc-disable-warning, initializer-overrides)
-warning-1 += $(call cc-disable-warning, unused-value)
-warning-1 += $(call cc-disable-warning, format)
-warning-1 += $(call cc-disable-warning, unknown-warning-option)
-warning-1 += $(call cc-disable-warning, sign-compare)
-warning-1 += $(call cc-disable-warning, format-zero-length)
-warning-1 += $(call cc-disable-warning, uninitialized)
-warning-1 += $(call cc-option, -fcatch-undefined-behavior)
-
-warning-2 := -Waggregate-return
-warning-2 += -Wcast-align
-warning-2 += -Wdisabled-optimization
-warning-2 += -Wnested-externs
-warning-2 += -Wshadow
-warning-2 += $(call cc-option, -Wlogical-op)
-warning-2 += $(call cc-option, -Wmissing-field-initializers)
-
-warning-3 := -Wbad-function-cast
-warning-3 += -Wcast-qual
-warning-3 += -Wconversion
-warning-3 += -Wpacked
-warning-3 += -Wpadded
-warning-3 += -Wpointer-arith
-warning-3 += -Wredundant-decls
-warning-3 += -Wswitch-default
-warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
-warning-3 += $(call cc-option, -Wvla)
-
-warning := $(warning-$(findstring 1, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
-warning += $(warning-$(findstring 2, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
-warning += $(warning-$(findstring 3, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
-
-ifeq ("$(strip $(warning))","")
-        $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
-endif
-
-KBUILD_CFLAGS += $(warning)
-endif
-
 include scripts/Makefile.lib
 
 ifdef host-progs
diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
new file mode 100644
index 0000000..6564350
--- /dev/null
+++ b/scripts/Makefile.extrawarn
@@ -0,0 +1,67 @@
+# ==========================================================================
+#
+# make W=... settings
+#
+# W=1 - warnings that may be relevant and does not occur too often
+# W=2 - warnings that occur quite often but may still be relevant
+# W=3 - the more obscure warnings, can most likely be ignored
+#
+# $(call cc-option, -W...) handles gcc -W.. options which
+# are not supported by all versions of the compiler
+# ==========================================================================
+
+ifeq ("$(origin W)", "command line")
+  export KBUILD_ENABLE_EXTRA_GCC_CHECKS := $(W)
+endif
+
+ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
+warning-  := $(empty)
+
+warning-1 := -Wextra -Wunused -Wno-unused-parameter
+warning-1 += -Wmissing-declarations
+warning-1 += -Wmissing-format-attribute
+warning-1 += $(call cc-option, -Wmissing-prototypes)
+warning-1 += -Wold-style-definition
+warning-1 += $(call cc-option, -Wmissing-include-dirs)
+warning-1 += $(call cc-option, -Wunused-but-set-variable)
+warning-1 += $(call cc-disable-warning, missing-field-initializers)
+
+# Clang
+warning-1 += $(call cc-disable-warning, initializer-overrides)
+warning-1 += $(call cc-disable-warning, unused-value)
+warning-1 += $(call cc-disable-warning, format)
+warning-1 += $(call cc-disable-warning, unknown-warning-option)
+warning-1 += $(call cc-disable-warning, sign-compare)
+warning-1 += $(call cc-disable-warning, format-zero-length)
+warning-1 += $(call cc-disable-warning, uninitialized)
+warning-1 += $(call cc-option, -fcatch-undefined-behavior)
+
+warning-2 := -Waggregate-return
+warning-2 += -Wcast-align
+warning-2 += -Wdisabled-optimization
+warning-2 += -Wnested-externs
+warning-2 += -Wshadow
+warning-2 += $(call cc-option, -Wlogical-op)
+warning-2 += $(call cc-option, -Wmissing-field-initializers)
+
+warning-3 := -Wbad-function-cast
+warning-3 += -Wcast-qual
+warning-3 += -Wconversion
+warning-3 += -Wpacked
+warning-3 += -Wpadded
+warning-3 += -Wpointer-arith
+warning-3 += -Wredundant-decls
+warning-3 += -Wswitch-default
+warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
+warning-3 += $(call cc-option, -Wvla)
+
+warning := $(warning-$(findstring 1, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
+warning += $(warning-$(findstring 2, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
+warning += $(warning-$(findstring 3, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
+
+ifeq ("$(strip $(warning))","")
+        $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
+endif
+
+KBUILD_CFLAGS += $(warning)
+endif
-- 
1.8.3.2

