Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965417AbaD2Wfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:35:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:4588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494AbaD2Wff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:35:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,953,1389772800"; 
   d="scan'208";a="532007942"
From: "David E. Box" <david.e.box@linux.intel.com>
To: david.e.box@linux.intel.com, jacob.jun.pan@linux.intel.com,
        linux-pm@vger.kernel.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, hpa@linux.intel.com
Cc: alan@linux.intel.com, durgadoss.r@intel.com, kristen.c.accardi@intel.com
Subject: [PATCH v2 1/4] powercap/rapl: further relax energy counter checks
Date: Tue, 29 Apr 2014 15:33:06 -0700
Message-Id: <1398810789-2301-2-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
References: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Energy counters may roll slowly for some RAPL domains, checking all
of them can be time consuming and takes unpredictable amount of time.
Therefore, we relax the sanity check by only checking availability of the
MSRs and non-zero value of the energy status counters. It has been shown
sufficient for all the platforms tested to filter out inactive domains.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/powercap/intel_rapl.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index d9a0770..1c987d2 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -1124,8 +1124,7 @@ err_cleanup_package:
 static int rapl_check_domain(int cpu, int domain)
 {
 	unsigned msr;
-	u64 val1, val2 = 0;
-	int retry = 0;
+	u64 val = 0;
 
 	switch (domain) {
 	case RAPL_DOMAIN_PACKAGE:
@@ -1144,26 +1143,13 @@ static int rapl_check_domain(int cpu, int domain)
 		pr_err("invalid domain id %d\n", domain);
 		return -EINVAL;
 	}
-	if (rdmsrl_safe_on_cpu(cpu, msr, &val1))
-		return -ENODEV;
-
-	/* PP1/uncore/graphics domain may not be active at the time of
-	 * driver loading. So skip further checks.
+	/* make sure domain counters are available and contains non-zero
+	 * values, otherwise skip it.
 	 */
-	if (domain == RAPL_DOMAIN_PP1)
-		return 0;
-	/* energy counters roll slowly on some domains */
-	while (++retry < 10) {
-		usleep_range(10000, 15000);
-		rdmsrl_safe_on_cpu(cpu, msr, &val2);
-		if ((val1 & ENERGY_STATUS_MASK) != (val2 & ENERGY_STATUS_MASK))
-			return 0;
-	}
-	/* if energy counter does not change, report as bad domain */
-	pr_info("domain %s energy ctr %llu:%llu not working, skip\n",
-		rapl_domain_names[domain], val1, val2);
+	if (rdmsrl_safe_on_cpu(cpu, msr, &val) || !val)
+		return -ENODEV;
 
-	return -ENODEV;
+	return 0;
 }
 
 /* Detect active and valid domains for the given CPU, caller must
@@ -1180,6 +1166,9 @@ static int rapl_detect_domains(struct rapl_package *rp, int cpu)
 		/* use physical package id to read counters */
 		if (!rapl_check_domain(cpu, i))
 			rp->domain_map |= 1 << i;
+		else
+			pr_warn("RAPL domain %s detection failed\n",
+				rapl_domain_names[i]);
 	}
 	rp->nr_domains = bitmap_weight(&rp->domain_map,	RAPL_DOMAIN_MAX);
 	if (!rp->nr_domains) {
-- 
1.7.10.4

