Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3AXLOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:14:22 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:42994 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3AXLOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:14:03 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 64/71] ARC: [Review] Multi-platform image #4: Isolate platform headers
Date: Thu, 24 Jan 2013 16:36:24 +0530
Message-ID: <1359025589-22277-41-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Top level ARC makefile removes -I for platform headers
-asm/irq.h no longer includes plat/irq.h

-platform makefile adds -I for it's specfic platform headers
-platform code to directly include it's plat/irq.h

-Linker script needed plat/memmap.h for CCM info, already in .config

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/Makefile                |   16 +---------------
 arch/arc/include/asm/irq.h       |    1 -
 arch/arc/kernel/vmlinux.lds.S    |    1 -
 arch/arc/plat-arcfpga/Makefile   |    2 ++
 arch/arc/plat-arcfpga/irq.c      |    2 +-
 arch/arc/plat-arcfpga/platform.c |    2 +-
 arch/arc/plat-arcfpga/smp.c      |    3 ++-
 7 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 0b041d5..c7d4999 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -10,14 +10,6 @@ UTS_MACHINE := arc
 
 KBUILD_DEFCONFIG := fpga_defconfig
 
-# For ARC FPGA Platforms
-platform-$(CONFIG_ARC_PLAT_FPGA_LEGACY)	:= arcfpga
-#New platform adds here
-
-PLATFORM := $(platform-y)
-export PLATFORM
-
-cflags-y	+= -Iarch/arc/plat-$(PLATFORM)/include
 cflags-y	+= -mA7 -fno-common -pipe -fno-builtin -D__linux__
 
 LINUXINCLUDE	+=  -include ${src}/arch/arc/include/asm/defines.h
@@ -86,9 +78,6 @@ KBUILD_CFLAGS	+= $(cflags-y)
 KBUILD_AFLAGS	+= $(KBUILD_CFLAGS)
 LDFLAGS		+= $(ldflags-y)
 
-# Needed for Linker script preprocessing
-KBUILD_CPPFLAGS	+= -Iarch/arc/plat-$(PLATFORM)/include
-
 head-y		:= arch/arc/kernel/head.o
 
 # See arch/arc/Kbuild for content of core part of the kernel
@@ -97,10 +86,7 @@ core-y		+= arch/arc/
 # w/o this dtb won't embed into kernel binary
 core-y		+= arch/arc/boot/dts/
 
-# w/o this ifneq, make ARCH=arc clean was crapping out
-ifneq ($(platform-y),)
-core-y		+= arch/arc/plat-$(PLATFORM)/
-endif
+core-$(CONFIG_ARC_PLAT_FPGA_LEGACY)	+= arch/arc/plat-arcfpga/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/arc/oprofile/
 
diff --git a/arch/arc/include/asm/irq.h b/arch/arc/include/asm/irq.h
index f1b318d..20aaab8 100644
--- a/arch/arc/include/asm/irq.h
+++ b/arch/arc/include/asm/irq.h
@@ -13,7 +13,6 @@
 #define TIMER0_IRQ      3
 #define TIMER1_IRQ      4
 
-#include <plat/irq.h>		/* Board Specific IRQ assignments */
 #include <asm-generic/irq.h>
 
 extern void __init arc_init_IRQ(void);
diff --git a/arch/arc/kernel/vmlinux.lds.S b/arch/arc/kernel/vmlinux.lds.S
index 622d8b6..d3c92f5 100644
--- a/arch/arc/kernel/vmlinux.lds.S
+++ b/arch/arc/kernel/vmlinux.lds.S
@@ -10,7 +10,6 @@
 #include <asm/cache.h>
 #include <asm/page.h>
 #include <asm/thread_info.h>
-#include <plat/memmap.h>
 
 OUTPUT_ARCH(arc)
 ENTRY(_stext)
diff --git a/arch/arc/plat-arcfpga/Makefile b/arch/arc/plat-arcfpga/Makefile
index 2a828be..a44e22e 100644
--- a/arch/arc/plat-arcfpga/Makefile
+++ b/arch/arc/plat-arcfpga/Makefile
@@ -6,5 +6,7 @@
 # published by the Free Software Foundation.
 #
 
+KBUILD_CFLAGS	+= -Iarch/arc/plat-arcfpga/include
+
 obj-y := platform.o irq.o
 obj-$(CONFIG_SMP)		+= smp.o
diff --git a/arch/arc/plat-arcfpga/irq.c b/arch/arc/plat-arcfpga/irq.c
index 0ea43c2..d2215fd 100644
--- a/arch/arc/plat-arcfpga/irq.c
+++ b/arch/arc/plat-arcfpga/irq.c
@@ -9,7 +9,7 @@
  */
 
 #include <linux/interrupt.h>
-#include <asm/irq.h>
+#include <plat/irq.h>
 
 void __init plat_fpga_init_IRQ(void)
 {
diff --git a/arch/arc/plat-arcfpga/platform.c b/arch/arc/plat-arcfpga/platform.c
index ac85d69..4024f10 100644
--- a/arch/arc/plat-arcfpga/platform.c
+++ b/arch/arc/plat-arcfpga/platform.c
@@ -16,11 +16,11 @@
 #include <linux/console.h>
 #include <linux/of_platform.h>
 #include <asm/setup.h>
-#include <asm/irq.h>
 #include <asm/clk.h>
 #include <asm/mach_desc.h>
 #include <plat/memmap.h>
 #include <plat/smp.h>
+#include <plat/irq.h>
 
 /*-----------------------BVCI Latency Unit -----------------------------*/
 
diff --git a/arch/arc/plat-arcfpga/smp.c b/arch/arc/plat-arcfpga/smp.c
index fec1879..68a53b1 100644
--- a/arch/arc/plat-arcfpga/smp.c
+++ b/arch/arc/plat-arcfpga/smp.c
@@ -12,7 +12,8 @@
  */
 
 #include <linux/smp.h>
-#include <asm/irq.h>
+#include <linux/irq.h>
+#include <plat/irq.h>
 #include <plat/smp.h>
 
 static char smp_cpuinfo_buf[128];
-- 
1.7.4.1

