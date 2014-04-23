Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbaDWRE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:04:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37382 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaDWREY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:04:24 -0400
Date: Wed, 23 Apr 2014 19:04:19 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, venkateshs@google.com, bp@alien8.de,
        ak@linux.intel.com, zheng.z.yan@intel.com
Subject: [PATCH] perf/x86: fix RAPL rdmsrl_safe() usage
Message-ID: <20140423170418.GA12767@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a bug introduced by commit 24223657.

The rdmsrl_safe() function returns 0 on success.
The current code was failing to detect the RAPL PMU
on real hardware  (missing /sys/devices/power) because
the return value of rdmsrl_safe() was misinterpreted.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 7c87424..619f769 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -543,7 +543,8 @@ static int rapl_cpu_prepare(int cpu)
 	if (phys_id < 0)
 		return -1;
 
-	if (!rdmsrl_safe(MSR_RAPL_POWER_UNIT, &msr_rapl_power_unit_bits))
+	/* protect rdmsrl() to handle virtualization */
+	if (rdmsrl_safe(MSR_RAPL_POWER_UNIT, &msr_rapl_power_unit_bits))
 		return -1;
 
 	pmu = kzalloc_node(sizeof(*pmu), GFP_KERNEL, cpu_to_node(cpu));
