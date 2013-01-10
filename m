Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3AJTvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:51:23 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:38715
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755879Ab3AJTvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:51:19 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MGFDT2-01-9WM-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH RESEND V5 5/6] perf, x86: Allow for architecture specific RDPMC indexes
Date: Thu, 10 Jan 2013 13:50:41 -0600
Message-ID: <1357847443-3878-6-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
References: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to config_base and event_base, allow architecture specific
RDPMC ECX values.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c     |    2 +-
 arch/x86/kernel/cpu/perf_event.h     |    6 ++++++
 arch/x86/kernel/cpu/perf_event_amd.c |    6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4428fd1..b63982b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -835,7 +835,7 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	} else {
 		hwc->config_base = x86_pmu_config_addr(hwc->idx);
 		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
-		hwc->event_base_rdpmc = hwc->idx;
+		hwc->event_base_rdpmc = x86_pmu_rdpmc_index(hwc->idx);
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 4440218..c910657 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -326,6 +326,7 @@ struct x86_pmu {
 	unsigned	eventsel;
 	unsigned	perfctr;
 	int		(*addr_offset)(int index, int eventsel);
+	int		(*rdpmc_index)(int index);
 	u64		(*event_map)(int);
 	int		max_events;
 	int		num_counters;
@@ -459,6 +460,11 @@ static inline unsigned int x86_pmu_event_addr(int index)
 		(x86_pmu.addr_offset ? x86_pmu.addr_offset(index, 0) : index);
 }
 
+static inline int x86_pmu_rdpmc_index(int index)
+{
+	return x86_pmu.rdpmc_index ? x86_pmu.rdpmc_index(index) : index;
+}
+
 int x86_setup_perfctr(struct perf_event *event);
 
 int x86_pmu_hw_config(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index ef1df38..faf9072 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -173,6 +173,11 @@ static inline int amd_pmu_addr_offset(int index, int eventsel)
 	return offset;
 }
 
+static inline int amd_pmu_rdpmc_index(int index)
+{
+	return index;
+}
+
 static int amd_pmu_hw_config(struct perf_event *event)
 {
 	int ret;
@@ -620,6 +625,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
 	.addr_offset            = amd_pmu_addr_offset,
+	.rdpmc_index		= amd_pmu_rdpmc_index,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
 	.num_counters		= AMD64_NUM_COUNTERS,
-- 
1.7.9.5


