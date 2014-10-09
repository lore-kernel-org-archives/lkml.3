Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaJIWoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 18:44:54 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:41433 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaJIWoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 18:44:46 -0400
X-IronPort-AV: E=Sophos;i="5.04,688,1406617200"; 
   d="scan'208";a="47707197"
From: Scott Branden <sbranden@broadcom.com>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>
CC: JD Zheng <jdzheng@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Jonathan Richardson <jonathar@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>
Subject: [PATCH V4 1/7] ARM: cygnus: Initial support for Broadcom Cygnus SoC
Date: Thu, 9 Oct 2014 15:44:25 -0700
Message-ID: <1412894671-5921-2-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412894671-5921-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1412894671-5921-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Richardson <jonathar@broadcom.com>

Adds initial support for the Cygnus SoC based on Broadcom’s iProc series.
Move ARCH_BCM_5301x under the ARCH_BCM_IPROC architecture.

Reviewed-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Desmond Liu <desmondl@broadcom.com>
Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
Tested-by: Jonathan Richardson <jonathar@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 arch/arm/Kconfig.debug         |    2 +-
 arch/arm/mach-bcm/Kconfig      |   68 +++++++++++++++++++++++++++-------------
 arch/arm/mach-bcm/Makefile     |    3 ++
 arch/arm/mach-bcm/bcm_cygnus.c |   26 +++++++++++++++
 4 files changed, 77 insertions(+), 22 deletions(-)
 create mode 100644 arch/arm/mach-bcm/bcm_cygnus.c

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index b11ad54..85363de 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1051,7 +1051,7 @@ config DEBUG_UART_PL01X
 
 # Compatibility options for 8250
 config DEBUG_UART_8250
-	def_bool ARCH_DOVE || ARCH_EBSA110 || \
+	def_bool ARCH_BCM_IPROC || ARCH_DOVE || ARCH_EBSA110 || \
 		(FOOTBRIDGE && !DEBUG_DC21285_PORT) || \
 		ARCH_GEMINI || ARCH_IOP13XX || ARCH_IOP32X || \
 		ARCH_IOP33X || ARCH_IXP4XX || \
diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index fc93800..b2b6752 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -5,6 +5,53 @@ menuconfig ARCH_BCM
 
 if ARCH_BCM
 
+menu "iProc SoC based Machine types"
+	config ARCH_BCM_IPROC
+		bool "Broadcom ARMv7 iProc boards" if ARCH_MULTI_V7
+		depends on ARCH_BCM_CYGNUS || ARCH_BCM_5301X
+		select ARM_GIC
+		select CACHE_L2X0
+		select HAVE_ARM_SCU if SMP
+		select HAVE_ARM_TWD if SMP
+		select ARM_GLOBAL_TIMER
+
+		select CLKSRC_MMIO
+		select ARCH_REQUIRE_GPIOLIB
+		select ARM_AMBA
+		select PINCTRL
+		help
+		  This enables support for systems based on Broadcom IPROC architected SoCs.
+		  The IPROC complex contains one or more ARM CPUs along with common
+		  core periperals. Application specific SoCs are created by adding a
+		  uArchitecture containing peripherals outside of the IPROC complex.
+		  Currently supported SoCs are Cygnus.
+
+	config ARCH_BCM_CYGNUS
+		bool "Broadcom Cygnus Support" if ARCH_MULTI_V7
+		select ARCH_BCM_IPROC
+		help
+			Enable support for the Cygnus family,
+			which includes the following variants:
+			BCM11300, BCM11320, BCM11350, BCM11360,
+			BCM58300, BCM58302, BCM58303, BCM58305.
+
+	config ARCH_BCM_5301X
+		bool "Broadcom BCM470X / BCM5301X ARM SoC" if ARCH_MULTI_V7
+		select ARCH_BCM_IPROC
+		help
+		  Support for Broadcom BCM470X and BCM5301X SoCs with ARM CPU cores.
+
+		  This is a network SoC line mostly used in home routers and
+		  wifi access points, it's internal name is Northstar.
+		  This inclused the following SoC: BCM53010, BCM53011, BCM53012,
+		  BCM53014, BCM53015, BCM53016, BCM53017, BCM53018, BCM4707,
+		  BCM4708 and BCM4709.
+
+		  Do not confuse this with the BCM4760 which is a totally
+		  different SoC or with the older BCM47XX and BCM53XX based
+		  network SoC using a MIPS CPU, they are supported by arch/mips/bcm47xx
+endmenu
+
 config ARCH_BCM_MOBILE
 	bool "Broadcom Mobile SoC Support" if ARCH_MULTI_V7
 	select ARCH_REQUIRE_GPIOLIB
@@ -78,27 +125,6 @@ config ARCH_BCM2835
 	  This enables support for the Broadcom BCM2835 SoC. This SoC is
 	  used in the Raspberry Pi and Roku 2 devices.
 
-config ARCH_BCM_5301X
-	bool "Broadcom BCM470X / BCM5301X ARM SoC" if ARCH_MULTI_V7
-	select ARM_GIC
-	select CACHE_L2X0
-	select HAVE_ARM_SCU if SMP
-	select HAVE_ARM_TWD if SMP
-	select ARM_GLOBAL_TIMER
-	select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
-	help
-	  Support for Broadcom BCM470X and BCM5301X SoCs with ARM CPU cores.
-
-	  This is a network SoC line mostly used in home routers and
-	  wifi access points, it's internal name is Northstar.
-	  This inclused the following SoC: BCM53010, BCM53011, BCM53012,
-	  BCM53014, BCM53015, BCM53016, BCM53017, BCM53018, BCM4707,
-	  BCM4708 and BCM4709.
-
-	  Do not confuse this with the BCM4760 which is a totally
-	  different SoC or with the older BCM47XX and BCM53XX based
-	  network SoC using a MIPS CPU, they are supported by arch/mips/bcm47xx
-
 config ARCH_BRCMSTB
 	bool "Broadcom BCM7XXX based boards" if ARCH_MULTI_V7
 	depends on MMU
diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index b19a396..46e092a 100644
--- a/arch/arm/mach-bcm/Makefile
+++ b/arch/arm/mach-bcm/Makefile
@@ -10,6 +10,9 @@
 # of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 
+# Cygnus
+obj-$(CONFIG_ARCH_BCM_CYGNUS) +=  bcm_cygnus.o
+
 # BCM281XX
 obj-$(CONFIG_ARCH_BCM_281XX)	+= board_bcm281xx.o
 
diff --git a/arch/arm/mach-bcm/bcm_cygnus.c b/arch/arm/mach-bcm/bcm_cygnus.c
new file mode 100644
index 0000000..41b4933
--- /dev/null
+++ b/arch/arm/mach-bcm/bcm_cygnus.c
@@ -0,0 +1,26 @@
+/*
+ * Copyright 2014 Broadcom Corporation.  All rights reserved.
+ *
+ * Unless you and Broadcom execute a separate written software license
+ * agreement governing use of this software, this software is licensed to you
+ * under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <asm/mach/arch.h>
+
+static const char const *bcm_cygnus_dt_compat[] = {
+	"brcm,cygnus",
+	NULL,
+};
+
+DT_MACHINE_START(BCM_CYGNUS_DT, "Broadcom Cygnus SoC")
+	.l2c_aux_val	= 0,
+	.l2c_aux_mask	= ~0,
+	.dt_compat = bcm_cygnus_dt_compat,
+MACHINE_END
-- 
1.7.9.5

