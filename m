Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3CTQRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:17:36 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51278 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946Ab3CTQRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:17:34 -0400
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH] cpufreq/intel_pstate: Add function to check that all MSR's are valid
Date: Wed, 20 Mar 2013 09:17:24 -0700
Message-Id: <1363796244-6658-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Some VMs seem to try to implement some MSRs but not all the registers
the driver needs.  Check to make sure all the MSR that we need are
available. If any of the required MSRs are not available refuse to
load.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index f6dd1e7..cd9c5f4 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -752,6 +752,29 @@ static struct cpufreq_driver intel_pstate_driver = {
 
 static int __initdata no_load;
 
+static int intel_pstate_msrs_not_valid(void)
+{
+	/* Check that all the msr's we are using are valid. */
+	u64 aperf, mperf, tmp;
+
+	rdmsrl(MSR_IA32_APERF, aperf);
+	rdmsrl(MSR_IA32_MPERF, mperf);
+
+	if (!intel_pstate_min_pstate() ||
+		!intel_pstate_max_pstate() ||
+		!intel_pstate_turbo_pstate())
+		return -ENODEV;
+
+	rdmsrl(MSR_IA32_APERF, tmp);
+	if (!(tmp - aperf))
+		return -ENODEV;
+
+	rdmsrl(MSR_IA32_MPERF, tmp);
+	if (!(tmp - mperf))
+		return -ENODEV;
+
+	return 0;
+}
 static int __init intel_pstate_init(void)
 {
 	int cpu, rc = 0;
@@ -764,6 +787,9 @@ static int __init intel_pstate_init(void)
 	if (!id)
 		return -ENODEV;
 
+	if (intel_pstate_msrs_not_valid())
+		return -ENODEV;
+
 	pr_info("Intel P-state driver initializing.\n");
 
 	all_cpu_data = vmalloc(sizeof(void *) * num_possible_cpus());
-- 
1.7.7.6

