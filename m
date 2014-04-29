Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965437AbaD2WgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:36:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:4588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965391AbaD2Wfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:35:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,953,1389772800"; 
   d="scan'208";a="532007951"
From: "David E. Box" <david.e.box@linux.intel.com>
To: david.e.box@linux.intel.com, jacob.jun.pan@linux.intel.com,
        linux-pm@vger.kernel.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, hpa@linux.intel.com
Cc: alan@linux.intel.com, durgadoss.r@intel.com, kristen.c.accardi@intel.com
Subject: [PATCH v2 4/4] powercap/rapl: change floor frequency for vallewview
Date: Tue, 29 Apr 2014 15:33:09 -0700
Message-Id: <1398810789-2301-5-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
References: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

RAPL power limit reduce power by limiting CPU P-state and
other techniques. On Valleyview, RAPL power limit cannot
go to LFM (low frequency mode) if we don't set the floor
frequency via IOSF mailbox.

This patch enables setting of floor frquency such that
RAPL power limit is more effective.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/powercap/intel_rapl.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index b1cda6f..13e4776 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -32,6 +32,7 @@
 
 #include <asm/processor.h>
 #include <asm/cpu_device_id.h>
+#include <asm/iosf_mbi.h>
 
 /* bitmasks for RAPL MSRs, used by primitive access functions */
 #define ENERGY_STATUS_MASK      0xffffffff
@@ -336,11 +337,17 @@ static int find_nr_power_limit(struct rapl_domain *rd)
 	return i;
 }
 
+#define VLV_CPU_POWER_BUDGET_CTL (0x2)
+static const struct x86_cpu_id valleyview_id[] = {
+	{ X86_VENDOR_INTEL, 6, 0x37},
+	{}
+};
+
 static int set_domain_enable(struct powercap_zone *power_zone, bool mode)
 {
 	struct rapl_domain *rd = power_zone_to_rapl_domain(power_zone);
 	int nr_powerlimit;
-
+	u32 mdata = 0;
 	if (rd->state & DOMAIN_STATE_BIOS_LOCKED)
 		return -EACCES;
 	get_online_cpus();
@@ -350,7 +357,16 @@ static int set_domain_enable(struct powercap_zone *power_zone, bool mode)
 	/* always enable clamp such that p-state can go below OS requested
 	 * range. power capping priority over guranteed frequency.
 	 */
-	rapl_write_data_raw(rd, PL1_CLAMP, mode);
+	if (x86_match_cpu(valleyview_id)) {
+		iosf_mbi_read(BT_MBI_UNIT_PMC, BT_MBI_PMC_READ,
+			VLV_CPU_POWER_BUDGET_CTL, &mdata);
+		mdata &= ~(0x7f << 8);
+		mdata |= 1 << 8;
+		iosf_mbi_write(BT_MBI_UNIT_PMC, BT_MBI_PMC_WRITE,
+			VLV_CPU_POWER_BUDGET_CTL, mdata);
+	} else
+		rapl_write_data_raw(rd, PL1_CLAMP, mode);
+
 	/* some domains have pl2 */
 	if (nr_powerlimit > 1) {
 		rapl_write_data_raw(rd, PL2_ENABLE, mode);
@@ -833,11 +849,6 @@ static int rapl_write_data_raw(struct rapl_domain *rd,
 	return 0;
 }
 
-static const struct x86_cpu_id energy_unit_quirk_ids[] = {
-	{ X86_VENDOR_INTEL, 6, 0x37},/* Valleyview */
-	{}
-};
-
 static int rapl_check_unit(struct rapl_package *rp, int cpu)
 {
 	u64 msr_val;
@@ -859,7 +870,7 @@ static int rapl_check_unit(struct rapl_package *rp, int cpu)
 	 */
 	value = (msr_val & ENERGY_UNIT_MASK) >> ENERGY_UNIT_OFFSET;
 	/* some CPUs have different way to calculate energy unit */
-	if (x86_match_cpu(energy_unit_quirk_ids))
+	if (x86_match_cpu(valleyview_id))
 		rp->energy_unit_divisor = 1000000 / (1 << value);
 	else
 		rp->energy_unit_divisor = 1 << value;
-- 
1.7.10.4

