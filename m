Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab3DTTTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:19:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:30110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab3DTTT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:19:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="298141406"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/15] perf, x86: Support the TSX intx/intx_cp qualifiers v4
Date: Sat, 20 Apr 2013 12:19:14 -0700
Message-Id: <1366485563-16209-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Export the TSX transaction and checkpointed qualifiers in sysfs,
so that they can be used like this

cpu/...,intx=1/

v2: Moved bad hunk. Forbid some bad combinations.
v3: Use EOPNOTSUPP. White space fixes (Stephane Eranian)
v4: Only sysfs code for now
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 3f2afb2..8aa1326 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1697,6 +1697,8 @@ PMU_FORMAT_ATTR(pc,	"config:19"	);
 PMU_FORMAT_ATTR(any,	"config:21"	); /* v3 + */
 PMU_FORMAT_ATTR(inv,	"config:23"	);
 PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+PMU_FORMAT_ATTR(intx,	"config:32"	);
+PMU_FORMAT_ATTR(intx_cp, "config:33"	);
 
 static struct attribute *intel_arch_formats_attr[] = {
 	&format_attr_event.attr,
@@ -1857,6 +1859,24 @@ static struct attribute *intel_arch3_formats_attr[] = {
 	NULL,
 };
 
+/* Arch3 + TSX support */
+static struct attribute *intel_hsw_formats_attr[] __read_mostly = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_pc.attr,
+	&format_attr_any.attr,
+	&format_attr_inv.attr,
+	&format_attr_cmask.attr,
+	&format_attr_intx.attr,
+	&format_attr_intx_cp.attr,
+
+	&format_attr_offcore_rsp.attr, /* XXX do NHM/WSM + SNB breakout */
+	&format_attr_ldlat.attr, /* PEBS load latency */
+	NULL,
+};
+
+
 static __initconst const struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -2247,6 +2267,7 @@ __init int intel_pmu_init(void)
 
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
+		x86_pmu.format_attrs = intel_hsw_formats_attr;
 		x86_pmu.lbr_double_abort = true;
 		pr_cont("Haswell events, ");
 		break;
-- 
1.7.7.6

