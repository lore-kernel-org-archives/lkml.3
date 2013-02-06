Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab3BFR0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:26:42 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:37166 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757558Ab3BFR0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:26:36 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
X-WSS-ID: 0MHT746-01-17A-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 5/6] perf, x86: Allow for architecture specific RDPMC indexes
Date: Wed, 6 Feb 2013 11:26:28 -0600
Message-ID: <1360171589-6381-6-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360171589-6381-1-git-send-email-jacob.shin@amd.com>
References: <1360171589-6381-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to config_base and event_base, allow architecture specific
RDPMC ECX values.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Acked-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c     |    2 +-
 arch/x86/kernel/cpu/perf_event.h     |    6 ++++++
 arch/x86/kernel/cpu/perf_event_amd.c |    6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c6ef37a..5ed7a4c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -829,7 +829,7 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 	} else {
 		hwc->config_base = x86_pmu_config_addr(hwc->idx);
 		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
-		hwc->event_base_rdpmc = hwc->idx;
+		hwc->event_base_rdpmc = x86_pmu_rdpmc_index(hwc->idx);
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index c455cba..1a2ea03 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -352,6 +352,7 @@ struct x86_pmu {
 	unsigned	eventsel;
 	unsigned	perfctr;
 	int		(*addr_offset)(int index, bool eventsel);
+	int		(*rdpmc_index)(int index);
 	u64		(*event_map)(int);
 	int		max_events;
 	int		num_counters;
@@ -510,6 +511,11 @@ static inline unsigned int x86_pmu_event_addr(int index)
 				  x86_pmu.addr_offset(index, false) : index);
 }
 
+static inline int x86_pmu_rdpmc_index(int index)
+{
+	return x86_pmu.rdpmc_index ? x86_pmu.rdpmc_index(index) : index;
+}
+
 int x86_setup_perfctr(struct perf_event *event);
 
 int x86_pmu_hw_config(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index b60f31c..05462f0 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -173,6 +173,11 @@ static inline int amd_pmu_addr_offset(int index, bool eventsel)
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


