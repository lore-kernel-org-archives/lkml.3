Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbbA1ACM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:02:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:39631 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603AbbA1ABx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:01:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,477,1418112000"; 
   d="scan'208";a="677052532"
From: Vikas Shivappa <vikas.shivappa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vikas.shivappa@intel.com, vikas.shivappa@linux.intel.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        peterz@infradead.org, matt.fleming@intel.com, will.auld@intel.com
Subject: [PATCH 6/6] x86/intel_cat: Intel haswell CAT enumeration
Date: Tue, 27 Jan 2015 16:00:09 -0800
Message-Id: <1422403209-15533-7-git-send-email-vikas.shivappa@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
References: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAT(Cache Allocation Technology) on hsw needs to be enumerated
separately. CAT is only supported on certain HSW SKUs.  This patch does
a probe test for hsw CPUs by writing a CLOSid into high 32 bits of
IA32_PQR_MSR and see if the bits stick. The probe test is only done
after confirming that the CPU is HSW.

Signed-off-by: Vikas Shivappa <vikas.shivappa@linux.intel.com>
---
 arch/x86/kernel/cpu/intel_cat.c | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel_cat.c b/arch/x86/kernel/cpu/intel_cat.c
index ebd5ed8..becddf0 100644
--- a/arch/x86/kernel/cpu/intel_cat.c
+++ b/arch/x86/kernel/cpu/intel_cat.c
@@ -38,11 +38,53 @@ DEFINE_PER_CPU(unsigned int, x86_cpu_clos);
 #define cat_for_each_child(pos_css, parent_cq)		\
 	css_for_each_child((pos_css), &(parent_cq)->css)
 
+/*
+ * hsw_probetest() - Have to do probe
+ * test for Intel haswell CPUs as it does not have
+ * CPUID enumeration support for CAT.
+ *
+ * Probes by writing to the high 32 bits(CLOSid)
+ * of the IA32_PQR_MSR and testing if the bits stick.
+ * Then hardcode the max CLOS and max bitmask length on hsw.
+ */
+
+static inline bool hsw_probetest(void)
+{
+	u32 l, h_old, h_new, h_tmp;
+
+	if (rdmsr_safe(MSR_IA32_PQR_ASSOC, &l, &h_old))
+		return false;
+
+	/*
+	 * Default value is always 0 if feature is present.
+	 */
+	h_tmp = h_old ^ 0x1U;
+	if (wrmsr_safe(MSR_IA32_PQR_ASSOC, l, h_tmp) ||
+	    rdmsr_safe(MSR_IA32_PQR_ASSOC, &l, &h_new))
+		return false;
+
+	if (h_tmp != h_new)
+		return false;
+
+	wrmsr_safe(MSR_IA32_PQR_ASSOC, l, h_old);
+
+	boot_cpu_data.x86_cat_closs = 4;
+	boot_cpu_data.x86_cat_cbmlength = 20;
+
+	return true;
+}
+
 static inline bool cat_supported(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_CAT_L3))
 		return true;
 
+	/*
+	 * Probe test for Haswell CPUs.
+	 */
+	if (c->x86 == 6 && c->x86_model == 0x3f)
+		return hsw_probetest();
+
 	return false;
 }
 
-- 
1.9.1

