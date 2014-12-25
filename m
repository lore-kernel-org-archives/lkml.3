Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaLYR5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 12:57:36 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33489 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaLYR5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 12:57:07 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jaedon.shin@gmail.com, abrestic@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V6 05/25] MIPS: bcm3384: Rename "bcm3384" target to "bmips"
Date: Thu, 25 Dec 2014 09:49:00 -0800
Message-Id: <1419529760-9520-6-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
References: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform is configured primarily through device tree, and we can
reuse the same code to support a bunch of other chips.  Change the name
to reflect this.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/Kbuild.platforms                                   |  2 +-
 arch/mips/Kconfig                                            | 12 ++++++------
 arch/mips/bcm3384/Platform                                   |  7 -------
 arch/mips/{bcm3384 => bmips}/Makefile                        |  0
 arch/mips/bmips/Platform                                     |  7 +++++++
 arch/mips/{bcm3384 => bmips}/dma.c                           |  0
 arch/mips/{bcm3384 => bmips}/irq.c                           |  0
 arch/mips/{bcm3384 => bmips}/setup.c                         |  2 +-
 arch/mips/boot/dts/brcm/Makefile                             |  2 +-
 arch/mips/configs/{bcm3384_defconfig => bmips_be_defconfig}  |  2 +-
 .../include/asm/{mach-bcm3384 => mach-bmips}/dma-coherence.h |  6 +++---
 11 files changed, 20 insertions(+), 20 deletions(-)
 delete mode 100644 arch/mips/bcm3384/Platform
 rename arch/mips/{bcm3384 => bmips}/Makefile (100%)
 create mode 100644 arch/mips/bmips/Platform
 rename arch/mips/{bcm3384 => bmips}/dma.c (100%)
 rename arch/mips/{bcm3384 => bmips}/irq.c (100%)
 rename arch/mips/{bcm3384 => bmips}/setup.c (98%)
 rename arch/mips/configs/{bcm3384_defconfig => bmips_be_defconfig} (98%)
 rename arch/mips/include/asm/{mach-bcm3384 => mach-bmips}/dma-coherence.h (90%)

diff --git a/arch/mips/Kbuild.platforms b/arch/mips/Kbuild.platforms
index e5fc463..a4d1e4f 100644
--- a/arch/mips/Kbuild.platforms
+++ b/arch/mips/Kbuild.platforms
@@ -4,9 +4,9 @@ platforms += alchemy
 platforms += ar7
 platforms += ath25
 platforms += ath79
-platforms += bcm3384
 platforms += bcm47xx
 platforms += bcm63xx
+platforms += bmips
 platforms += cavium-octeon
 platforms += cobalt
 platforms += dec
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 3289969..31bbec0 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -130,8 +130,8 @@ config ATH79
 	help
 	  Support for the Atheros AR71XX/AR724X/AR913X SoCs.
 
-config BCM3384
-	bool "Broadcom BCM3384 based boards"
+config BMIPS_GENERIC
+	bool "Broadcom Generic BMIPS kernel"
 	select BOOT_RAW
 	select NO_EXCEPT_FILL
 	select USE_OF
@@ -151,10 +151,10 @@ config BCM3384
 	select USB_OHCI_BIG_ENDIAN_DESC
 	select USB_OHCI_BIG_ENDIAN_MMIO
 	help
-	  Support for BCM3384 based boards.  BCM3384/BCM33843 is a cable modem
-	  chipset with a Linux application processor that is often used to
-	  provide Samba services, a CUPS print server, and/or advanced routing
-	  features.
+	  Build a generic DT-based kernel image that boots on select
+	  BCM33xx cable modem chips, BCM63xx DSL chips, and BCM7xxx set-top
+	  box chips.  Note that CONFIG_CPU_BIG_ENDIAN/CONFIG_CPU_LITTLE_ENDIAN
+	  must be set appropriately for your board.
 
 config BCM47XX
 	bool "Broadcom BCM47XX based boards"
diff --git a/arch/mips/bcm3384/Platform b/arch/mips/bcm3384/Platform
deleted file mode 100644
index 8e1ca08..0000000
diff --git a/arch/mips/bcm3384/Makefile b/arch/mips/bmips/Makefile
similarity index 100%
rename from arch/mips/bcm3384/Makefile
rename to arch/mips/bmips/Makefile
diff --git a/arch/mips/bmips/Platform b/arch/mips/bmips/Platform
new file mode 100644
index 0000000..5f127fd
--- /dev/null
+++ b/arch/mips/bmips/Platform
@@ -0,0 +1,7 @@
+#
+# Broadcom Generic BMIPS kernel
+#
+platform-$(CONFIG_BMIPS_GENERIC)	+= bmips/
+cflags-$(CONFIG_BMIPS_GENERIC)		+=				\
+		-I$(srctree)/arch/mips/include/asm/mach-bmips/
+load-$(CONFIG_BMIPS_GENERIC)		:= 0xffffffff80010000
diff --git a/arch/mips/bcm3384/dma.c b/arch/mips/bmips/dma.c
similarity index 100%
rename from arch/mips/bcm3384/dma.c
rename to arch/mips/bmips/dma.c
diff --git a/arch/mips/bcm3384/irq.c b/arch/mips/bmips/irq.c
similarity index 100%
rename from arch/mips/bcm3384/irq.c
rename to arch/mips/bmips/irq.c
diff --git a/arch/mips/bcm3384/setup.c b/arch/mips/bmips/setup.c
similarity index 98%
rename from arch/mips/bcm3384/setup.c
rename to arch/mips/bmips/setup.c
index d84b840..5099109 100644
--- a/arch/mips/bcm3384/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -33,7 +33,7 @@ void __init prom_free_prom_memory(void)
 
 const char *get_system_type(void)
 {
-	return "BCM3384";
+	return "Generic BMIPS kernel";
 }
 
 void __init plat_time_init(void)
diff --git a/arch/mips/boot/dts/brcm/Makefile b/arch/mips/boot/dts/brcm/Makefile
index a353d4e..530ed23 100644
--- a/arch/mips/boot/dts/brcm/Makefile
+++ b/arch/mips/boot/dts/brcm/Makefile
@@ -1,4 +1,4 @@
-dtb-$(CONFIG_BCM3384)		+= bcm93384wvg.dtb
+dtb-$(CONFIG_BMIPS_GENERIC)	+= bcm93384wvg.dtb
 
 obj-y				+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
 
diff --git a/arch/mips/configs/bcm3384_defconfig b/arch/mips/configs/bmips_be_defconfig
similarity index 98%
rename from arch/mips/configs/bcm3384_defconfig
rename to arch/mips/configs/bmips_be_defconfig
index 88711c2..36af5af 100644
--- a/arch/mips/configs/bcm3384_defconfig
+++ b/arch/mips/configs/bmips_be_defconfig
@@ -1,4 +1,4 @@
-CONFIG_BCM3384=y
+CONFIG_BMIPS_GENERIC=y
 CONFIG_HIGHMEM=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=4
diff --git a/arch/mips/include/asm/mach-bcm3384/dma-coherence.h b/arch/mips/include/asm/mach-bmips/dma-coherence.h
similarity index 90%
rename from arch/mips/include/asm/mach-bcm3384/dma-coherence.h
rename to arch/mips/include/asm/mach-bmips/dma-coherence.h
index a3be8e5..65e95b0 100644
--- a/arch/mips/include/asm/mach-bcm3384/dma-coherence.h
+++ b/arch/mips/include/asm/mach-bmips/dma-coherence.h
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  */
 
-#ifndef __ASM_MACH_BCM3384_DMA_COHERENCE_H
-#define __ASM_MACH_BCM3384_DMA_COHERENCE_H
+#ifndef __ASM_MACH_BMIPS_DMA_COHERENCE_H
+#define __ASM_MACH_BMIPS_DMA_COHERENCE_H
 
 struct device;
 
@@ -45,4 +45,4 @@ static inline int plat_device_is_coherent(struct device *dev)
 	return 0;
 }
 
-#endif /* __ASM_MACH_BCM3384_DMA_COHERENCE_H */
+#endif /* __ASM_MACH_BMIPS_DMA_COHERENCE_H */
-- 
2.1.1

