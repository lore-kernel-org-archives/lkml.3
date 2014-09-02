Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaIBRy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:54:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:42811 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaIBRyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:54:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,450,1406617200"; 
   d="scan'208";a="567284923"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] powercap/rapl: change domain detection message
Date: Tue,  2 Sep 2014 02:55:21 -0700
Message-Id: <1409651721-16746-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.0.0.5.gbce14aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many CPUs do not support complete set of RAPL domains, as a
result this detection failed message is very misleading and
can be annoying.

 [    5.082632] intel_rapl: RAPL domain core detection failed
 [    5.088370] intel_rapl: RAPL domain uncore detection failed

So lower the warning message to info and only print out the RAPL
domains that are supported.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/powercap/intel_rapl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index b1cda6f..d32b7a6 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -1166,11 +1166,10 @@ static int rapl_detect_domains(struct rapl_package *rp, int cpu)
 
 	for (i = 0; i < RAPL_DOMAIN_MAX; i++) {
 		/* use physical package id to read counters */
-		if (!rapl_check_domain(cpu, i))
+		if (!rapl_check_domain(cpu, i)) {
 			rp->domain_map |= 1 << i;
-		else
-			pr_warn("RAPL domain %s detection failed\n",
-				rapl_domain_names[i]);
+			pr_info("Found RAPL domain %s\n", rapl_domain_names[i]);
+		}
 	}
 	rp->nr_domains = bitmap_weight(&rp->domain_map,	RAPL_DOMAIN_MAX);
 	if (!rp->nr_domains) {
-- 
2.0.0.5.gbce14aa

