Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaDXIEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:04:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50240 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaDXIEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:04:01 -0400
Date: Thu, 24 Apr 2014 01:03:36 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-9f7ff8931e3c5ddc8535476971ec9501e9555c05@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@suse.de,
        venkateshs@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, bp@suse.de,
        venkateshs@google.com
In-Reply-To: <20140423170418.GA12767@quad>
References: <20140423170418.GA12767@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Fix RAPL rdmsrl_safe() usage
Git-Commit-ID: 9f7ff8931e3c5ddc8535476971ec9501e9555c05
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f7ff8931e3c5ddc8535476971ec9501e9555c05
Gitweb:     http://git.kernel.org/tip/9f7ff8931e3c5ddc8535476971ec9501e9555c05
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 23 Apr 2014 19:04:19 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Apr 2014 08:12:41 +0200

perf/x86: Fix RAPL rdmsrl_safe() usage

This patch fixes a bug introduced by:

  24223657806a ("perf/x86/intel: Use rdmsrl_safe() when initializing RAPL PMU")

The rdmsrl_safe() function returns 0 on success.
The current code was failing to detect the RAPL PMU
on real hardware  (missing /sys/devices/power) because
the return value of rdmsrl_safe() was misinterpreted.

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Borislav Petkov <bp@suse.de>
Acked-by: Venkatesh Srinivas <venkateshs@google.com>
Cc: peterz@infradead.org
Cc: zheng.z.yan@intel.com
Link: http://lkml.kernel.org/r/20140423170418.GA12767@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
