Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab3LKWjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:39:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:34829 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab3LKWja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:39:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,874,1378882800"; 
   d="scan'208";a="423197462"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Cc: Gavin Hindman <gavin.hindman@intel.com>,
        "Triplett, Josh" <josh.triplett@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] powercap/rapl: add support for ValleyView Soc
Date: Wed, 11 Dec 2013 14:39:27 -0800
Message-Id: <1386801567-26661-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for RAPL on Intel ValleyView based SoC
platforms, such as Baytrail.

Besides adding CPU ID, special energy unit encoding is handled
for ValleyView.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/powercap/intel_rapl.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index 2a786c5..3c67683 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -833,6 +833,11 @@ static int rapl_write_data_raw(struct rapl_domain *rd,
 	return 0;
 }
 
+static const struct x86_cpu_id energy_unit_quirk_ids[] = {
+	{ X86_VENDOR_INTEL, 6, 0x37},/* VLV */
+	{}
+};
+
 static int rapl_check_unit(struct rapl_package *rp, int cpu)
 {
 	u64 msr_val;
@@ -853,8 +858,11 @@ static int rapl_check_unit(struct rapl_package *rp, int cpu)
 	 * time unit: 1/time_unit_divisor Seconds
 	 */
 	value = (msr_val & ENERGY_UNIT_MASK) >> ENERGY_UNIT_OFFSET;
-	rp->energy_unit_divisor = 1 << value;
-
+	/* some CPUs have different way to calculate energy unit */
+	if (x86_match_cpu(energy_unit_quirk_ids))
+		rp->energy_unit_divisor = 1000000 / (1 << value);
+	else
+		rp->energy_unit_divisor = 1 << value;
 
 	value = (msr_val & POWER_UNIT_MASK) >> POWER_UNIT_OFFSET;
 	rp->power_unit_divisor = 1 << value;
@@ -941,6 +949,7 @@ static void package_power_limit_irq_restore(int package_id)
 static const struct x86_cpu_id rapl_ids[] = {
 	{ X86_VENDOR_INTEL, 6, 0x2a},/* SNB */
 	{ X86_VENDOR_INTEL, 6, 0x2d},/* SNB EP */
+	{ X86_VENDOR_INTEL, 6, 0x37},/* VLV */
 	{ X86_VENDOR_INTEL, 6, 0x3a},/* IVB */
 	{ X86_VENDOR_INTEL, 6, 0x45},/* HSW */
 	/* TODO: Add more CPU IDs after testing */
-- 
1.8.1.2

