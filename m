Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab3FKUDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:03:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab3FKUDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ross Lagerwall <rosslagerwall@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 28/79] acpi-cpufreq: set current frequency based on target P-State
Date: Tue, 11 Jun 2013 13:02:54 -0700
Message-Id: <20130611195316.181645955@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/acpi-cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -347,11 +347,11 @@ static u32 get_cur_val(const struct cpum
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


