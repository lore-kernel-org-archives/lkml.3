Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3FQRff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:35:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50612 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab3FQRfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:35:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ross Lagerwall <rosslagerwall@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 50/84] acpi-cpufreq: set current frequency based on target P-State
Date: Mon, 17 Jun 2013 10:30:54 -0700
Message-Id: <1371490288-23167-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Lagerwall <rosslagerwall@gmail.com>

commit 8673b83bf2f013379453b4779047bf3c6ae387e4 upstream.

Commit 4b31e774 (Always set P-state on initialization) fixed bug
#4634 and caused the driver to always set the target P-State at
least once since the initial P-State may not be the desired one.
Commit 5a1c0228 (cpufreq: Avoid calling cpufreq driver's target()
routine if target_freq == policy->cur) caused a regression in
this behavior.

This fixes the regression by setting policy->cur based on the CPU's
target frequency rather than the CPU's current reported frequency
(which may be different).  This means that the P-State will be set
initially if the CPU's target frequency is different from the
governor's target frequency.

This fixes an issue where setting the default governor to
performance wouldn't correctly enable turbo mode on all cores.

Signed-off-by: Ross Lagerwall <rosslagerwall@gmail.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/acpi-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 7b0d49d..73e273e 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -347,11 +347,11 @@ static u32 get_cur_val(const struct cpumask *mask)
 	switch (per_cpu(acfreq_data, cpumask_first(mask))->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
-		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
+		cmd.addr.msr.reg = MSR_IA32_PERF_CTL;
 		break;
 	case SYSTEM_AMD_MSR_CAPABLE:
 		cmd.type = SYSTEM_AMD_MSR_CAPABLE;
-		cmd.addr.msr.reg = MSR_AMD_PERF_STATUS;
+		cmd.addr.msr.reg = MSR_AMD_PERF_CTL;
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
-- 
1.8.1.2

