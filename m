Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbaDMRcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:32:19 -0400
Received: from mout.gmx.net ([212.227.15.19]:55896 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbaDMRcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:32:18 -0400
From: xypron.glpk@gmx.de
To: linux@arm.linux.org.uk
Cc: nicolas.pitre@linaro.org, santosh.shilimkar@ti.com, pawel.moll@arm.com,
        dave.martin@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] arm/mach-vexpress: array accessed out of bounds
Date: Sun, 13 Apr 2014 19:31:51 +0200
Message-Id: <1397410311-8313-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:c0pE6lnJwEN0TMva0fCfMgERnd/OKAFnB/JZgRcvrF2jRc2eStw
 ZQo7p6wE5L186bHc0/A4G3exzFmDTYWV89NhV01LRFWdzOc249OifXWpOCB1/aoL9jvAS/t
 Su+4JG/GDaG54eTXYaJPhY7vEg247gEEQoHysPkBvV6mHVgzKmAf7mMT2nWyeiqDI8HTvAX
 nFR80CpsH18Wo2w71+DZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

dcscb_allcpus_mask is an array of size 2.

The index variable cluster has to be checked against this limit
before accessing the array.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 arch/arm/mach-vexpress/dcscb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-vexpress/dcscb.c b/arch/arm/mach-vexpress/dcscb.c
index 14d4996..5cbf7fa 100644
--- a/arch/arm/mach-vexpress/dcscb.c
+++ b/arch/arm/mach-vexpress/dcscb.c
@@ -51,12 +51,14 @@ static int dcscb_allcpus_mask[2];
 static int dcscb_power_up(unsigned int cpu, unsigned int cluster)
 {
 	unsigned int rst_hold, cpumask = (1 << cpu);
-	unsigned int all_mask = dcscb_allcpus_mask[cluster];
+	unsigned int all_mask;
 
 	pr_debug("%s: cpu %u cluster %u\n", __func__, cpu, cluster);
 	if (cpu >= 4 || cluster >= 2)
 		return -EINVAL;
 
+	all_mask = dcscb_allcpus_mask[cluster];
+
 	/*
 	 * Since this is called with IRQs enabled, and no arch_spin_lock_irq
 	 * variant exists, we need to disable IRQs manually here.
@@ -101,11 +103,12 @@ static void dcscb_power_down(void)
 	cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
 	cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
 	cpumask = (1 << cpu);
-	all_mask = dcscb_allcpus_mask[cluster];
 
 	pr_debug("%s: cpu %u cluster %u\n", __func__, cpu, cluster);
 	BUG_ON(cpu >= 4 || cluster >= 2);
 
+	all_mask = dcscb_allcpus_mask[cluster];
+
 	__mcpm_cpu_going_down(cpu, cluster);
 
 	arch_spin_lock(&dcscb_lock);
-- 
1.7.10.4

