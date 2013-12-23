Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab3LWQYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:24:20 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39671 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869Ab3LWQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:10 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC 14/18] ARM: vexpress: remove redundant vexpress_dt_cpus_num to get cpu count
Date: Mon, 23 Dec 2013 16:23:46 +0000
Message-Id: <1387815830-8794-15-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:07.0587 (UTC) FILETIME=[6755BF30:01CEFFFB]
X-MC-Unique: 113122316240809201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGOTfN026587

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

arm_dt_init_cpu_maps parses the device tree, validates and sets the
cpu_possible_mask appropriately. It is unnecessary to do another DT
parse to get the number of cpus, use num_possible_cpus instead.

This patch also removes setting cpu_present_mask as platforms should
only re-initialize it in smp_prepare_cpus() if present != possible.

Acked-by: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
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


