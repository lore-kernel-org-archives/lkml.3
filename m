Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaBKRLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:11:49 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25702 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752189AbaBKRK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:10:56 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 10/12] ARM: vexpress: remove redundant vexpress_dt_cpus_num to get cpu count
Date: Tue, 11 Feb 2014 17:10:34 +0000
Message-Id: <1392138636-29240-11-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

arm_dt_init_cpu_maps parses the device tree, validates and sets the
cpu_possible_mask appropriately. It is unnecessary to do another DT
parse to get the number of cpus, use num_possible_cpus instead.

This patch also removes setting cpu_present_mask as platforms should
only re-initialize it in smp_prepare_cpus() if present != possible.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 arch/arm/mach-vexpress/platsmp.c | 31 +------------------------------
 1 file changed, 1 insertion(+), 30 deletions(-)

diff --git a/arch/arm/mach-vexpress/platsmp.c b/arch/arm/mach-vexpress/platsmp.c
index 993c9ae..12a8751 100644
--- a/arch/arm/mach-vexpress/platsmp.c
+++ b/arch/arm/mach-vexpress/platsmp.c
@@ -77,39 +77,13 @@ void __init vexpress_dt_smp_map_io(void)
 		WARN_ON(of_scan_flat_dt(vexpress_dt_find_scu, NULL));
 }
 
-static int __init vexpress_dt_cpus_num(unsigned long node, const char *uname,
-		int depth, void *data)
-{
-	static int prev_depth = -1;
-	static int nr_cpus = -1;
-
-	if (prev_depth > depth && nr_cpus > 0)
-		return nr_cpus;
-
-	if (nr_cpus < 0 && strcmp(uname, "cpus") == 0)
-		nr_cpus = 0;
-
-	if (nr_cpus >= 0) {
-		const char *device_type = of_get_flat_dt_prop(node,
-				"device_type", NULL);
-
-		if (device_type && strcmp(device_type, "cpu") == 0)
-			nr_cpus++;
-	}
-
-	prev_depth = depth;
-
-	return 0;
-}
-
 static void __init vexpress_dt_smp_init_cpus(void)
 {
 	int ncores = 0, i;
 
 	switch (vexpress_dt_scu) {
 	case GENERIC_SCU:
-		ncores = of_scan_flat_dt(vexpress_dt_cpus_num, NULL);
-		break;
+		return;
 	case CORTEX_A9_SCU:
 		ncores = scu_get_core_count(vexpress_dt_cortex_a9_scu_base);
 		break;
@@ -133,12 +107,9 @@ static void __init vexpress_dt_smp_init_cpus(void)
 
 static void __init vexpress_dt_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
 
 	switch (vexpress_dt_scu) {
 	case GENERIC_SCU:
-		for (i = 0; i < max_cpus; i++)
-			set_cpu_present(i, true);
 		break;
 	case CORTEX_A9_SCU:
 		scu_enable(vexpress_dt_cortex_a9_scu_base);
-- 
1.8.3.2

