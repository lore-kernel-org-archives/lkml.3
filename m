Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaC1LOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:14:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35396 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751968AbaC1LO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:14:26 -0400
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
Subject: [PATCH v6 07/11] ARM: mvebu: Allow to power down L2 cache controller in idle mode
Date: Fri, 28 Mar 2014 12:13:27 +0100
Message-Id: <1396005211-15573-8-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1396005211-15573-1-git-send-email-gregory.clement@free-electrons.com>
References: <1396005211-15573-1-git-send-email-gregory.clement@free-electrons.com>
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
 arch/arm/mach-mvebu/pmsu.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index 8361281f9180..db5011f98df3 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -33,7 +33,12 @@ static void __iomem *pmsu_mp_base;
 #define PMSU_BASE_OFFSET    0x100
 #define PMSU_REG_SIZE	    0x1000
 
-#define PMSU_BOOT_ADDR_REDIRECT_OFFSET(cpu)	((cpu * 0x100) + 0x124)
+/* PMSU MP registers */
+#define PMSU_BOOT_ADDR_REDIRECT_OFFSET(cpu) ((cpu * 0x100) + 0x124)
+
+/* PMSU fabric registers */
+#define L2C_NFABRIC_PM_CTL		    0x4
+#define L2C_NFABRIC_PM_CTL_PWR_DOWN		BIT(20)
 
 static struct of_device_id of_pmsu_table[] = {
 	{ .compatible = "marvell,armada-370-pmsu", },
@@ -115,4 +120,17 @@ static int __init armada_370_xp_pmsu_init(void)
 	return ret;
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

