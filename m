Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaJOC7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 22:59:18 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:1233 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbaJOC7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 22:59:04 -0400
X-IronPort-AV: E=Sophos;i="5.04,721,1406617200"; 
   d="scan'208";a="48073475"
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
Subject: [PATCH v5 1/6] ARM: cygnus: Initial support for Broadcom Cygnus SoC
Date: Tue, 14 Oct 2014 19:58:51 -0700
Message-ID: <1413341936-17606-2-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413341936-17606-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1413341936-17606-1-git-send-email-sbranden@broadcom.com>
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
 arch/arm/mach-bcm/Kconfig      |   30 ++++++++++++++++++++++++++++++
 arch/arm/mach-bcm/Makefile     |    3 +++
 arch/arm/mach-bcm/bcm_cygnus.c |   26 ++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)
 create mode 100644 arch/arm/mach-bcm/bcm_cygnus.c

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 2abad74..ecc544a 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -5,6 +5,36 @@ menuconfig ARCH_BCM
 
 if ARCH_BCM
 
+menu "iProc SoC based Machine types"
+	config ARCH_BCM_IPROC
+		bool
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
+		  Enable support for the Cygnus family,
+		  which includes the following variants:
+		  BCM11300, BCM11320, BCM11350, BCM11360,
+		  BCM58300, BCM58302, BCM58303, BCM58305.
+endmenu
+
 config ARCH_BCM_MOBILE
 	bool "Broadcom Mobile SoC Support" if ARCH_MULTI_V7
 	select ARCH_REQUIRE_GPIOLIB
diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index 300ae4b..34d45ba 100644
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

