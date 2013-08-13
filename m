Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3HMQjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:39:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758169Ab3HMQjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:39:42 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf x86: Make intel_pmu_enable_all to enable only active events
Date: Tue, 13 Aug 2013 18:39:11 +0200
Message-Id: <1376411952-16718-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1376411952-16718-1-git-send-email-jolsa@redhat.com>
References: <1376411952-16718-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the intel_pmu_enable_all enables all possible
events, which is not allways desired. One case (there'll
be probably more) is:

  - event hits throttling threshold
  - NMI stops event
  - intel_pmu_enable_all starts it back on the NMI exit

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a45d8d4..360e7a0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -912,11 +912,13 @@ static void intel_pmu_disable_all(void)
 static void intel_pmu_enable_all(int added)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 active_mask = *((u64*) cpuc->active_mask);
 
 	intel_pmu_pebs_enable_all();
 	intel_pmu_lbr_enable_all();
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL,
-			x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask);
+			x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask
+			& active_mask);
 
 	if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
 		struct perf_event *event =
-- 
1.7.11.7

