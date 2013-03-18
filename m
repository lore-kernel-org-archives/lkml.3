Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3CRQNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:13:21 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:56639 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3CRQNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:13:20 -0400
From: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] h8300, score: fix CROSS_COMPILE setting in arch/xxx/Makefile
Date: Tue, 19 Mar 2013 00:13:07 +0800
Message-Id: <1363623187-4350-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makefiles for h8300 and score architectures unconditionally set
CROSS_COMPILE to a default value, which breaks following cross
compilation command:
ARCH=h8300 CROSS_COMPILE=/ws/tool/h8300-elf/bin/h8300-elf- make arch/h8300/mm/init.o
make: h8300-elf-gcc: Command not found
make: h8300-elf-gcc: Command not found
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      kernel/bounds.s
/bin/sh: 1: h8300-elf-gcc: not found
make[1]: *** [kernel/bounds.s] Error 127
make: *** [prepare0] Error 2

So only set CROSS_COMPILE to the default value if it's has been set yet.

Also fix a typo in arch/h8300/Makefile to change "CROSS-COMPILE" to
"CROSS_COMPILE".

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/h8300/Makefile |    6 ++++--
 arch/score/Makefile |    4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/h8300/Makefile b/arch/h8300/Makefile
index a556447..62a4d08 100644
--- a/arch/h8300/Makefile
+++ b/arch/h8300/Makefile
@@ -38,8 +38,10 @@ KBUILD_CFLAGS += -DUTS_SYSNAME=\"uClinux\"
 KBUILD_AFLAGS += -DPLATFORM=$(PLATFORM) -DMODEL=$(MODEL) $(cflags-y)
 LDFLAGS += $(ldflags-y)
 
-CROSS_COMPILE = h8300-elf-
-LIBGCC := $(shell $(CROSS-COMPILE)$(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
+ifeq ($(CROSS_COMPILE),)
+	CROSS_COMPILE := h8300-elf-
+endif
+LIBGCC := $(shell $(CROSS_COMPILE)$(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 
 head-y := arch/$(ARCH)/platform/$(PLATFORM)/$(BOARD)/crt0_$(MODEL).o
 
diff --git a/arch/score/Makefile b/arch/score/Makefile
index 974aefe..70973bb 100644
--- a/arch/score/Makefile
+++ b/arch/score/Makefile
@@ -7,7 +7,9 @@
 #
 
 KBUILD_DEFCONFIG := spct6600_defconfig
-CROSS_COMPILE := score-linux-
+ifeq ($(CROSS_COMPILE),)
+	CROSS_COMPILE := score-linux-
+endif
 
 #
 # CPU-dependent compiler/assembler options for optimization.
-- 
1.7.9.5

