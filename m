Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaFZWny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:43:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38396 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbaFZWnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:43:47 -0400
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
Subject: [PATCH 2/5] ARM: smp_scu: Add the enable speculative linefills operation
Date: Fri, 27 Jun 2014 00:43:25 +0200
Message-Id: <1403822608-31158-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
References: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quotin the ARM datasheet "When set, coherent linefill requests are
sent speculatively to the L2C-310 in parallel with the tag look-up. If
the tag look-up misses, the confirmed linefill is sent to the L2C-310
and gets RDATA earlier because the data request was already initiated
by the speculative request. "

Some SoC (such as the Armada 375/38x) can benefit of this feature. As
this is something related to the Cortex A9 and not specific to a SoC,
we can expose it in a common place.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/include/asm/smp_scu.h |  3 +++
 arch/arm/kernel/smp_scu.c      | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/arm/include/asm/smp_scu.h b/arch/arm/include/asm/smp_scu.h
index 0393fbab8dd5..d9650dce48c7 100644
--- a/arch/arm/include/asm/smp_scu.h
+++ b/arch/arm/include/asm/smp_scu.h
@@ -26,6 +26,7 @@ static inline unsigned long scu_a9_get_base(void)
 #ifdef CONFIG_HAVE_ARM_SCU
 unsigned int scu_get_core_count(void __iomem *);
 int scu_power_mode(void __iomem *, unsigned int);
+void scu_spec_linefills_enable(void __iomem *scu_base, bool enable);
 #else
 static inline unsigned int scu_get_core_count(void __iomem *scu_base)
 {
@@ -35,6 +36,8 @@ static inline int scu_power_mode(void __iomem *scu_base, unsigned int mode)
 {
 	return -EINVAL;
 }
+static inline void scu_spec_linefills_enable(void __iomem *scu_base,
+					bool enable) {}
 #endif
 
 #if defined(CONFIG_SMP) && defined(CONFIG_HAVE_ARM_SCU)
diff --git a/arch/arm/kernel/smp_scu.c b/arch/arm/kernel/smp_scu.c
index cfea41b41ad0..3fd21a495028 100644
--- a/arch/arm/kernel/smp_scu.c
+++ b/arch/arm/kernel/smp_scu.c
@@ -18,6 +18,7 @@
 
 #define SCU_CTRL		0x00
 #define SCU_CTRL_ENABLE		    BIT(1)
+#define SCU_CTRL_SPEC_LINEFILLS	    BIT(3)
 #define SCU_CONFIG		0x04
 #define SCU_CPU_STATUS		0x08
 #define SCU_INVALIDATE		0x0c
@@ -88,3 +89,24 @@ int scu_power_mode(void __iomem *scu_base, unsigned int mode)
 
 	return 0;
 }
+
+/*
+ * When enabled, coherent linefill requests are sent speculatively to
+ * the L2C-310 in parallel with the tag look-up
+ *
+ */
+void scu_spec_linefills_enable(void __iomem *scu_base, bool enable)
+{
+	u32 scu_ctrl;
+
+	scu_ctrl = readl_relaxed(scu_base + SCU_CTRL);
+	/* already enabled? */
+	if (scu_ctrl & SCU_CTRL_ENABLE)
+		return;
+	if (enable)
+		scu_ctrl |= SCU_CTRL_SPEC_LINEFILLS;
+	else
+		scu_ctrl &= ~SCU_CTRL_SPEC_LINEFILLS;
+
+	writel_relaxed(scu_ctrl, scu_base + SCU_CTRL);
+}
-- 
1.8.1.2

