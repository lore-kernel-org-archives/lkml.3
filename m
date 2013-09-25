Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3IYBWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:22:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3IYAP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:15:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 006/110] powerpc: Default arch idle could cede processor on pseries
Date: Tue, 24 Sep 2013 17:14:04 -0700
Message-Id: <20130925001324.078826874@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/setup.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -354,7 +354,7 @@ static int alloc_dispatch_log_kmem_cache
 }
 early_initcall(alloc_dispatch_log_kmem_cache);
 
-static void pSeries_idle(void)
+static void pseries_lpar_idle(void)
 {
 	/* This would call on the cpuidle framework, and the back-end pseries
 	 * driver to  go to idle states
@@ -362,10 +362,22 @@ static void pSeries_idle(void)
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
 
@@ -456,15 +468,14 @@ static void __init pSeries_setup_arch(vo
 
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
 
 	ppc_md.pcibios_root_bridge_prepare = pseries_root_bridge_prepare;
 


