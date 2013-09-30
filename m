Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab3I3KSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:18:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43792 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab3I3KNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 089/104] powerpc: Default arch idle could cede processor on pseries
Date: Mon, 30 Sep 2013 11:11:06 +0100
Message-Id: <1380535881-9239-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

commit 363edbe2614aa90df706c0f19ccfa2a6c06af0be upstream.

When adding cpuidle support to pSeries, we introduced two
regressions:

  - The new cpuidle backend driver only works under hypervisors
    supporting the "SLPLAR" option, which isn't the case of the
    old POWER4 hypervisor and the HV "light" used on js2x blades

  - The cpuidle driver registers fairly late, meaning that for
    a significant portion of the boot process, we end up having
    all threads spinning. This slows down the boot process and
    increases the overall resource usage if the hypervisor has
    shared processors.

This fixes both by implementing a "default" idle that will cede
to the hypervisor when possible, in a very simple way without
all the bells and whisles of cpuidle.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Acked-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/pseries/setup.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 51ecac9..1e09357 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -352,7 +352,7 @@ static int alloc_dispatch_log_kmem_cache(void)
 }
 early_initcall(alloc_dispatch_log_kmem_cache);
 
-static void pSeries_idle(void)
+static void pseries_lpar_idle(void)
 {
 	/* This would call on the cpuidle framework, and the back-end pseries
 	 * driver to  go to idle states
@@ -360,10 +360,22 @@ static void pSeries_idle(void)
 	if (cpuidle_idle_call()) {
 		/* On error, execute default handler
 		 * to go into low thread priority and possibly
-		 * low power mode.
+		 * low power mode by cedeing processor to hypervisor
 		 */
-		HMT_low();
-		HMT_very_low();
+
+		/* Indicate to hypervisor that we are idle. */
+		get_lppaca()->idle = 1;
+
+		/*
+		 * Yield the processor to the hypervisor.  We return if
+		 * an external interrupt occurs (which are driven prior
+		 * to returning here) or if a prod occurs from another
+		 * processor. When returning here, external interrupts
+		 * are enabled.
+		 */
+		cede_processor();
+
+		get_lppaca()->idle = 0;
 	}
 }
 
@@ -395,15 +407,14 @@ static void __init pSeries_setup_arch(void)
 
 	pSeries_nvram_init();
 
-	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
+	if (firmware_has_feature(FW_FEATURE_LPAR)) {
 		vpa_init(boot_cpuid);
-		ppc_md.power_save = pSeries_idle;
-	}
-
-	if (firmware_has_feature(FW_FEATURE_LPAR))
+		ppc_md.power_save = pseries_lpar_idle;
 		ppc_md.enable_pmcs = pseries_lpar_enable_pmcs;
-	else
+	} else {
+		/* No special idle routine */
 		ppc_md.enable_pmcs = power4_enable_pmcs;
+	}
 }
 
 static int __init pSeries_init_panel(void)
-- 
1.8.3.2

