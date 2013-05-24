Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3EXQW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:22:28 -0400
Received: from multi.imgtec.com ([194.200.65.239]:59976 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726Ab3EXQWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:22:24 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 2/9] metag: minimal TZ1090 (Comet) SoC infrastructure
Date: Fri, 24 May 2013 17:21:09 +0100
Message-ID: <1369412476-14245-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_24_17_22_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add really minimal support for Toumaz Xenif TZ1090 SoC (A.K.A. Comet).
This consists of minimal build infrastructure, device tree files, and a
defconfig based on meta2_defconfig.

This SoC contains a 2-threaded HTP (Meta 2) as the main application
processor, and is found in a number of development boards and digital
radios, such as the Minimorph Development Platform.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-doc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
---
Changes in v2:
 - removed arch/metag/soc/ directory

 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/metag/Kconfig.soc                             |  9 +++++
 arch/metag/Makefile                                |  2 +-
 arch/metag/boot/dts/Makefile                       |  2 ++
 arch/metag/boot/dts/tz1090.dtsi                    | 29 +++++++++++++++
 arch/metag/boot/dts/tz1090_generic.dts             | 10 ++++++
 arch/metag/configs/tz1090_defconfig                | 42 ++++++++++++++++++++++
 7 files changed, 94 insertions(+), 1 deletion(-)
 create mode 100644 arch/metag/boot/dts/tz1090.dtsi
 create mode 100644 arch/metag/boot/dts/tz1090_generic.dts
 create mode 100644 arch/metag/configs/tz1090_defconfig

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 6931c43..be80992 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -57,6 +57,7 @@ snps 	Synopsys, Inc.
 st	STMicroelectronics
 ste	ST-Ericsson
 stericsson	ST-Ericsson
+toumaz	Toumaz
 ti	Texas Instruments
 toshiba	Toshiba Corporation
 via	VIA Technologies, Inc.
diff --git a/arch/metag/Kconfig.soc b/arch/metag/Kconfig.soc
index ec079cf..653b479 100644
--- a/arch/metag/Kconfig.soc
+++ b/arch/metag/Kconfig.soc
@@ -14,6 +14,15 @@ config META21_FPGA
 	help
 	  This is a Meta 2.1 FPGA bitstream, just a bare CPU.
 
+config SOC_TZ1090
+	bool "Toumaz Xenif TZ1090 SoC (Comet)"
+	select METAG_LNKGET_AROUND_CACHE
+	select METAG_META21
+	select METAG_SMP_WRITE_REORDERING
+	help
+	  This is a Toumaz Technology Xenif TZ1090 (A.K.A. Comet) SoC containing
+	  a 2-threaded HTP.
+
 endchoice
 
 menu "SoC configuration"
diff --git a/arch/metag/Makefile b/arch/metag/Makefile
index b566116..9739857 100644
--- a/arch/metag/Makefile
+++ b/arch/metag/Makefile
@@ -20,7 +20,7 @@ checkflags-$(CONFIG_METAG_META12)	+= -DMETAC_1_2
 checkflags-$(CONFIG_METAG_META21)	+= -DMETAC_2_1
 CHECKFLAGS				+= -D__metag__ $(checkflags-y)
 
-KBUILD_DEFCONFIG			:= meta2_defconfig
+KBUILD_DEFCONFIG			:= tz1090_defconfig
 
 sflags-$(CONFIG_METAG_META12)		+= -mmetac=1.2
 ifeq ($(CONFIG_METAG_META12),y)
diff --git a/arch/metag/boot/dts/Makefile b/arch/metag/boot/dts/Makefile
index dbd9521..72c1218 100644
--- a/arch/metag/boot/dts/Makefile
+++ b/arch/metag/boot/dts/Makefile
@@ -1,7 +1,9 @@
 dtb-y	+= skeleton.dtb
+dtb-y	+= tz1090_generic.dtb
 
 # Built-in dtb
 builtindtb-y				:= skeleton
+builtindtb-$(CONFIG_SOC_TZ1090)		:= tz1090_generic
 
 ifneq ($(CONFIG_METAG_BUILTIN_DTB_NAME),"")
 	builtindtb-y			:= $(patsubst "%",%,$(CONFIG_METAG_BUILTIN_DTB_NAME))
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
new file mode 100644
index 0000000..ca057f0
--- /dev/null
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2012 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	compatible = "toumaz,tz1090", "img,meta";
+
+	interrupt-parent = <&intc>;
+
+	intc: interrupt-controller {
+		compatible = "img,meta-intc";
+		interrupt-controller;
+		#interrupt-cells = <2>;
+		num-banks = <2>;
+	};
+
+	soc {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+	};
+};
diff --git a/arch/metag/boot/dts/tz1090_generic.dts b/arch/metag/boot/dts/tz1090_generic.dts
new file mode 100644
index 0000000..aa826cb
--- /dev/null
+++ b/arch/metag/boot/dts/tz1090_generic.dts
@@ -0,0 +1,10 @@
+/*
+ * Copyright (C) 2012 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/dts-v1/;
+
+/include/ "tz1090.dtsi"
diff --git a/arch/metag/configs/tz1090_defconfig b/arch/metag/configs/tz1090_defconfig
new file mode 100644
index 0000000..9f9316a
--- /dev/null
+++ b/arch/metag/configs/tz1090_defconfig
@@ -0,0 +1,42 @@
+# CONFIG_LOCALVERSION_AUTO is not set
+# CONFIG_SWAP is not set
+CONFIG_SYSVIPC=y
+CONFIG_SYSFS_DEPRECATED=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_KALLSYMS_ALL=y
+# CONFIG_ELF_CORE is not set
+CONFIG_SLAB=y
+# CONFIG_BLK_DEV_BSG is not set
+CONFIG_PARTITION_ADVANCED=y
+# CONFIG_MSDOS_PARTITION is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+# CONFIG_IOSCHED_CFQ is not set
+CONFIG_FLATMEM_MANUAL=y
+CONFIG_SOC_TZ1090=y
+CONFIG_METAG_HALT_ON_PANIC=y
+# CONFIG_METAG_FPU is not set
+CONFIG_METAG_DA=y
+CONFIG_HZ_100=y
+CONFIG_DEVTMPFS=y
+# CONFIG_STANDALONE is not set
+# CONFIG_PREVENT_FIRMWARE_BUILD is not set
+# CONFIG_FW_LOADER is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=1
+CONFIG_BLK_DEV_RAM_SIZE=16384
+# CONFIG_INPUT is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+# CONFIG_LEGACY_PTYS is not set
+CONFIG_DA_TTY=y
+CONFIG_DA_CONSOLE=y
+# CONFIG_DEVKMEM is not set
+# CONFIG_HW_RANDOM is not set
+CONFIG_GPIOLIB=y
+# CONFIG_HWMON is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_DNOTIFY is not set
+CONFIG_TMPFS=y
+# CONFIG_MISC_FILESYSTEMS is not set
+# CONFIG_SCHED_DEBUG is not set
+CONFIG_DEBUG_INFO=y
-- 
1.8.1.2


