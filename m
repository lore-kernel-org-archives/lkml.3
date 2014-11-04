Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaKDBA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:00:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:44356 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaKDBAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:00:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,310,1413270000"; 
   d="scan'208";a="616484633"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] perf, x86, uncore: Fix SBOX PMU on Haswell-EP to fix boot crash
Date: Mon,  3 Nov 2014 17:00:28 -0800
Message-Id: <1415062828-19759-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415062828-19759-1-git-send-email-andi@firstfloor.org>
References: <1415062828-19759-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

There were several reports that on some systems writing the SBOX0 PMU
initialization MSR would #GP at boot. This did not happen on all
systems -- my two test systems booted fine.

Writing the three initialization bits bit-by-bit seems to avoid the
problem. So add a special callback to do just that.

This replaces an earlier patch that disabled the SBOX.

Tested-by: patrick.lu@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 33 ++++++++++++++++++++--
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index 04e9a83..236dde2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -490,14 +490,17 @@ static struct attribute_group snbep_uncore_qpi_format_group = {
 	.attrs = snbep_uncore_qpi_formats_attr,
 };
 
-#define SNBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
-	.init_box	= snbep_uncore_msr_init_box,		\
+#define __SNBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
 	.disable_box	= snbep_uncore_msr_disable_box,		\
 	.enable_box	= snbep_uncore_msr_enable_box,		\
 	.disable_event	= snbep_uncore_msr_disable_event,	\
 	.enable_event	= snbep_uncore_msr_enable_event,	\
 	.read_counter	= uncore_msr_read_counter
 
+#define SNBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
+	__SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),			\
+	.init_box	= snbep_uncore_msr_init_box		\
+
 static struct intel_uncore_ops snbep_uncore_msr_ops = {
 	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
 };
@@ -1923,6 +1926,30 @@ static struct intel_uncore_type hswep_uncore_cbox = {
 	.format_group		= &hswep_uncore_cbox_format_group,
 };
 
+/*
+ * Write SBOX Initialization register bit by bit to avoid spurious #GPs
+ */
+static void hswep_uncore_sbox_msr_init_box(struct intel_uncore_box *box)
+{
+	unsigned msr = uncore_msr_box_ctl(box);
+
+	if (msr) {
+		u64 init = SNBEP_PMON_BOX_CTL_INT;
+		u64 flags = 0;
+		int i;
+
+		for_each_set_bit (i, (unsigned long *)&init, 64) {
+			flags |= (1ULL << i);
+			wrmsrl(msr, flags);
+		}
+	}
+}
+
+static struct intel_uncore_ops hswep_uncore_sbox_msr_ops = {
+	__SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
+	.init_box		= hswep_uncore_sbox_msr_init_box
+};
+
 static struct attribute *hswep_uncore_sbox_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
@@ -1948,7 +1975,7 @@ static struct intel_uncore_type hswep_uncore_sbox = {
 	.event_mask		= HSWEP_S_MSR_PMON_RAW_EVENT_MASK,
 	.box_ctl		= HSWEP_S0_MSR_PMON_BOX_CTL,
 	.msr_offset		= HSWEP_SBOX_MSR_OFFSET,
-	.ops			= &snbep_uncore_msr_ops,
+	.ops			= &hswep_uncore_sbox_msr_ops,
 	.format_group		= &hswep_uncore_sbox_format_group,
 };
 
-- 
1.9.3

