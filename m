Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161225AbaJ3Uen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:34:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:25863 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513AbaJ3Uem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:34:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="408714544"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        patrick.lu@intel.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>, alexei.starovoitov@gmail.com
Subject: [PATCH] perf, x86, uncore: Disable SBOX driver on Haswell EP
Date: Thu, 30 Oct 2014 13:34:35 -0700
Message-Id: <1414701275-5980-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

There were several reports that enabling the freeze and reset
counter bits for the SBOX pmu on Haswell EP causes #GPs at boot,
preventing successfull boot. It only happens on some systems
(not on mine)

The problem is still under investigation.

For now just disable the SBOX uncore PMU. We can reenable it later
once it works everywhere.

Thanks to Alexei Starovoitov for debugging.

Cc: alexei.starovoitov@gmail.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 30 ----------------------
 1 file changed, 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index 286c692..54b877b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -1923,35 +1923,6 @@ static struct intel_uncore_type hswep_uncore_cbox = {
 	.format_group		= &hswep_uncore_cbox_format_group,
 };
 
-static struct attribute *hswep_uncore_sbox_formats_attr[] = {
-	&format_attr_event.attr,
-	&format_attr_umask.attr,
-	&format_attr_edge.attr,
-	&format_attr_tid_en.attr,
-	&format_attr_inv.attr,
-	&format_attr_thresh8.attr,
-	NULL,
-};
-
-static struct attribute_group hswep_uncore_sbox_format_group = {
-	.name = "format",
-	.attrs = hswep_uncore_sbox_formats_attr,
-};
-
-static struct intel_uncore_type hswep_uncore_sbox = {
-	.name			= "sbox",
-	.num_counters		= 4,
-	.num_boxes		= 4,
-	.perf_ctr_bits		= 44,
-	.event_ctl		= HSWEP_S0_MSR_PMON_CTL0,
-	.perf_ctr		= HSWEP_S0_MSR_PMON_CTR0,
-	.event_mask		= HSWEP_S_MSR_PMON_RAW_EVENT_MASK,
-	.box_ctl		= HSWEP_S0_MSR_PMON_BOX_CTL,
-	.msr_offset		= HSWEP_SBOX_MSR_OFFSET,
-	.ops			= &snbep_uncore_msr_ops,
-	.format_group		= &hswep_uncore_sbox_format_group,
-};
-
 static int hswep_pcu_hw_config(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -1990,7 +1961,6 @@ static struct intel_uncore_type hswep_uncore_pcu = {
 static struct intel_uncore_type *hswep_msr_uncores[] = {
 	&hswep_uncore_ubox,
 	&hswep_uncore_cbox,
-	&hswep_uncore_sbox,
 	&hswep_uncore_pcu,
 	NULL,
 };
-- 
1.9.3

