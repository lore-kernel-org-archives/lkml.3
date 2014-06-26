Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaFZWoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:44:02 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38404 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750974AbaFZWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:43:49 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ARM: smp_scu: Add the enable standby operation
Date: Fri, 27 Jun 2014 00:43:26 +0200
Message-Id: <1403822608-31158-4-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
References: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting the ARM datasheet: "When set, SCU CLK is turned off when all
processors are in WFI mode, there is no pending request on the ACP, if
implemented, and there is no remaining activity in the SCU.

When SCU CLK is off, ARREADYS, AWREADYS and WREADYS on the ACP are
forced LOW. The clock is turned on when any processor leaves WFI mode,
or if there is a new request on the ACP."

This feature is currently used by imx6 SoC. This patch add this
operation inside smp_scu in order to centralized all the access to SCU
in the same place.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/include/asm/smp_scu.h |  2 ++
 arch/arm/kernel/smp_scu.c      | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/arm/include/asm/smp_scu.h b/arch/arm/include/asm/smp_scu.h
index d9650dce48c7..d9694aa7aaf7 100644
--- a/arch/arm/include/asm/smp_scu.h
+++ b/arch/arm/include/asm/smp_scu.h
@@ -27,6 +27,7 @@ static inline unsigned long scu_a9_get_base(void)
 unsigned int scu_get_core_count(void __iomem *);
 int scu_power_mode(void __iomem *, unsigned int);
 void scu_spec_linefills_enable(void __iomem *scu_base, bool enable);
+void scu_standby_enable(void __iomem *scu_base, bool enable);
 #else
 static inline unsigned int scu_get_core_count(void __iomem *scu_base)
 {
@@ -38,6 +39,7 @@ static inline int scu_power_mode(void __iomem *scu_base, unsigned int mode)
 }
 static inline void scu_spec_linefills_enable(void __iomem *scu_base,
 					bool enable) {}
+static inline void scu_standby_enable(void __iomem *scu_base, bool enable) {}
 #endif
 
 #if defined(CONFIG_SMP) && defined(CONFIG_HAVE_ARM_SCU)
diff --git a/arch/arm/kernel/smp_scu.c b/arch/arm/kernel/smp_scu.c
index 3fd21a495028..de68dbf8fc66 100644
--- a/arch/arm/kernel/smp_scu.c
+++ b/arch/arm/kernel/smp_scu.c
@@ -19,6 +19,7 @@
 #define SCU_CTRL		0x00
 #define SCU_CTRL_ENABLE		    BIT(1)
 #define SCU_CTRL_SPEC_LINEFILLS	    BIT(3)
+#define SCU_CTRL_STANDBY_ENABLE	    BIT(5)
 #define SCU_CONFIG		0x04
 #define SCU_CPU_STATUS		0x08
 #define SCU_INVALIDATE		0x0c
@@ -110,3 +111,22 @@ void scu_spec_linefills_enable(void __iomem *scu_base, bool enable)
 
 	writel_relaxed(scu_ctrl, scu_base + SCU_CTRL);
 }
+
+/*
+ * When enabled, SCU CLK is turned off when all processors are in WFI
+ * mode. The clock is turned on when any processor leaves WFI mode.
+ *
+ */
+void scu_standby_enable(void __iomem *scu_base, bool enable)
+{
+	u32 scu_ctrl;
+
+	scu_ctrl = readl_relaxed(scu_base + SCU_CTRL);
+
+	if (enable)
+		scu_ctrl |= SCU_CTRL_STANDBY_ENABLE;
+	else
+		scu_ctrl &= ~SCU_CTRL_STANDBY_ENABLE;
+
+	writel_relaxed(scu_ctrl, scu_base + SCU_CTRL);
+}
-- 
1.8.1.2

