Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaDGDXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 23:23:39 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:49730 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbaDGDXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 23:23:37 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Masahiro Yamada <yamada.m@jp.panasonic.com>
Subject: [PATCH] Kbuild: move extra gcc check flags to the top Makefile
Date: Mon,  7 Apr 2014 12:22:19 +0900
Message-Id: <1396840939-24512-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If W=... given to the command line, extra gcc check flags are added
to KBUILD_CFLAGS.

If we have such code in scripts/Makefile.build, the same flags are
added to KBUILD_CFLAGS multiple times becuase scripts/Makefile.build
is invoked every time Kbuild descends into the subdirectories.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---
 Makefile               | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++
 scripts/Makefile.build | 51 --------------------------------------------------
 2 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/Makefile b/Makefile
index 00a933b..6588a03 100644
--- a/Makefile
+++ b/Makefile
@@ -579,6 +579,57 @@ endif # $(dot-config)
 # Defaults to vmlinux, but the arch makefile usually adds further targets
 all: vmlinux
 
+#
+# make W=... settings
+#
+# W=1 - warnings that may be relevant and does not occur too often
+# W=2 - warnings that occur quite often but may still be relevant
+# W=3 - the more obscure warnings, can most likely be ignored
+#
+# $(call cc-option, -W...) handles gcc -W.. options which
+# are not supported by all versions of the compiler
+ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
+warning-  := $(empty)
+
+warning-1 := -Wextra -Wunused -Wno-unused-parameter
+warning-1 += -Wmissing-declarations
+warning-1 += -Wmissing-format-attribute
+warning-1 += -Wmissing-prototypes
+warning-1 += -Wold-style-definition
+warning-1 += $(call cc-option, -Wmissing-include-dirs)
+warning-1 += $(call cc-option, -Wunused-but-set-variable)
+warning-1 += $(call cc-disable-warning, missing-field-initializers)
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
+
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
 KBUILD_CFLAGS	+= -Os $(call cc-disable-warning,maybe-uninitialized,)
 else
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 9f0ee22..b5e02b6 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -50,57 +50,6 @@ ifeq ($(KBUILD_NOPEDANTIC),)
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
-warning-1 += -Wmissing-prototypes
-warning-1 += -Wold-style-definition
-warning-1 += $(call cc-option, -Wmissing-include-dirs)
-warning-1 += $(call cc-option, -Wunused-but-set-variable)
-warning-1 += $(call cc-disable-warning, missing-field-initializers)
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
-- 
1.8.3.2

