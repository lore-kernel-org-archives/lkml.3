Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaCYWvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:51:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49856 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752108AbaCYWs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:48:58 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/14] ARM: mvebu: Allow to power down L2 cache controller in idle mode
Date: Tue, 25 Mar 2014 23:48:20 +0100
Message-Id: <1395787705-31061-10-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds a function which adjusts the PMSU configuration to
automatically power down the L2 and coherency fabric when we enter a
certain idle state.

This feature is part of the Power Management Service Unit of the
Armada 370 and Armada XP SoCs.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/pmsu.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index 865bcb651e01..3cfb56f980f3 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -30,8 +30,15 @@ static void __iomem *pmsu_reset_base;
 #define PMSU_BASE_OFFSET    0x100
 #define PMSU_REG_SIZE	    0x1000
 
-#define PMSU_BOOT_ADDR_REDIRECT_OFFSET(cpu)	((cpu * 0x100) + 0x124)
-#define PMSU_RESET_CTL_OFFSET(cpu)		(cpu * 0x8)
+/* PMSU MP registers */
+#define PMSU_BOOT_ADDR_REDIRECT_OFFSET(cpu) ((cpu * 0x100) + 0x124)
+
+/* PMSU reset registers */
+#define PMSU_RESET_CTL_OFFSET(cpu)	    (cpu * 0x8)
+
+/* PMSU fabric registers */
+#define L2C_NFABRIC_PM_CTL		    0x4
+#define L2C_NFABRIC_PM_CTL_PWR_DOWN		BIT(20)
 
 static struct of_device_id of_pmsu_table[] = {
 	{
@@ -111,4 +118,17 @@ static int __init armada_370_xp_pmsu_init(void)
 	return 0;
 }
 
+static void armada_370_xp_pmsu_enable_l2_powerdown_onidle(void)
+{
+	u32 reg;
+
+	if (pmsu_mp_base == NULL)
+		return;
+
+	/* Enable L2 & Fabric powerdown in Deep-Idle mode - Fabric */
+	reg = readl(pmsu_mp_base + L2C_NFABRIC_PM_CTL);
+	reg |= L2C_NFABRIC_PM_CTL_PWR_DOWN;
+	writel(reg, pmsu_mp_base + L2C_NFABRIC_PM_CTL);
+}
+
 early_initcall(armada_370_xp_pmsu_init);
-- 
1.8.1.2

