Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbaCaNfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:35:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35770 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaCaNYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ross Lagerwall <rosslagerwall@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Shatil Rafiullah <srafiullah@twopensource.com>,
        Vinson Lee <vlee@twitter.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 52/71] acpi-cpufreq: set current frequency based on target P-State
Date: Mon, 31 Mar 2014 14:22:58 +0100
Message-Id: <1396272197-13394-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Lagerwall <rosslagerwall@gmail.com>

commit 8673b83bf2f013379453b4779047bf3c6ae387e4 upstream.

Commit 4b31e774 (Always set P-state on initialization) fixed bug
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
[ srafiullah: Backported to <= 3.6:
  - SYSTEM_AMD_MSR_CAPABLE does not exist. ]
Tested-by: Shatil Rafiullah <srafiullah@twopensource.com>
Signed-off-by: Shatil Rafiullah <srafiullah@twopensource.com>
Signed-off-by: Vinson Lee <vlee@twitter.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/acpi-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 56c6c6b..227a316 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -215,7 +215,7 @@ static u32 get_cur_val(const struct cpumask *mask)
 	switch (per_cpu(acfreq_data, cpumask_first(mask))->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
-		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
+		cmd.addr.msr.reg = MSR_IA32_PERF_CTL;
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
-- 
1.9.1

