Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3BFUdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:33:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36454 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab3BFUdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:33:11 -0500
Date: Wed, 6 Feb 2013 12:32:49 -0800
From: tip-bot for Jacob Shin <jacob.shin@amd.com>
Message-ID: <tip-0fbdad078a70ed72248c3d30fe32e45e83be00d1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, jacob.shin@amd.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jacob.shin@amd.com, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1360171589-6381-6-git-send-email-jacob.shin@amd.com>
References: <1360171589-6381-6-git-send-email-jacob.shin@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Allow for architecture specific RDPMC indexes
Git-Commit-ID: 0fbdad078a70ed72248c3d30fe32e45e83be00d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 12:32:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fbdad078a70ed72248c3d30fe32e45e83be00d1
Gitweb:     http://git.kernel.org/tip/0fbdad078a70ed72248c3d30fe32e45e83be00d1
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Wed, 6 Feb 2013 11:26:28 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Feb 2013 19:45:24 +0100

perf/x86: Allow for architecture specific RDPMC indexes

Similar to config_base and event_base, allow architecture
specific RDPMC ECX values.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360171589-6381-6-git-send-email-jacob.shin@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c     | 2 +-
 arch/x86/kernel/cpu/perf_event.h     | 6 ++++++
 arch/x86/kernel/cpu/perf_event_amd.c | 6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c0df5ed2..bf0f01a 100644
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
index a7f06a9..7f5c75c 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -326,6 +326,7 @@ struct x86_pmu {
 	unsigned	eventsel;
 	unsigned	perfctr;
 	int		(*addr_offset)(int index, bool eventsel);
+	int		(*rdpmc_index)(int index);
 	u64		(*event_map)(int);
 	int		max_events;
 	int		num_counters;
@@ -459,6 +460,11 @@ static inline unsigned int x86_pmu_event_addr(int index)
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
