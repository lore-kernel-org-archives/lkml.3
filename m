Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaAPX4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:56:07 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52297 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaAPXyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:54:09 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 2/8] perf core: export swevent hrtimer helpers
Date: Thu, 16 Jan 2014 15:53:48 -0800
Message-Id: <1389916434-2288-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011623-7182-0000-0000-000009946105
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the swevent hrtimer helpers currently only used in events/core.c
to allow the addition of architecture specific sw-like pmus.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/perf_event.h | 5 ++++-
 kernel/events/core.c       | 8 ++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8646e33..c5bc71a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -558,7 +558,10 @@ extern void perf_pmu_migrate_context(struct pmu *pmu,
 				int src_cpu, int dst_cpu);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
-
+extern void perf_swevent_init_hrtimer(struct perf_event *event);
+extern void perf_swevent_start_hrtimer(struct perf_event *event);
+extern void perf_swevent_cancel_hrtimer(struct perf_event *event);
+extern int perf_swevent_event_idx(struct perf_event *event);
 
 struct perf_sample_data {
 	u64				type;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f574401..d881d1e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5801,7 +5801,7 @@ static int perf_swevent_init(struct perf_event *event)
 	return 0;
 }
 
-static int perf_swevent_event_idx(struct perf_event *event)
+int perf_swevent_event_idx(struct perf_event *event)
 {
 	return 0;
 }
@@ -6030,7 +6030,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	return ret;
 }
 
-static void perf_swevent_start_hrtimer(struct perf_event *event)
+void perf_swevent_start_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	s64 period;
@@ -6052,7 +6052,7 @@ static void perf_swevent_start_hrtimer(struct perf_event *event)
 				HRTIMER_MODE_REL_PINNED, 0);
 }
 
-static void perf_swevent_cancel_hrtimer(struct perf_event *event)
+void perf_swevent_cancel_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
@@ -6064,7 +6064,7 @@ static void perf_swevent_cancel_hrtimer(struct perf_event *event)
 	}
 }
 
-static void perf_swevent_init_hrtimer(struct perf_event *event)
+void perf_swevent_init_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-- 
1.8.5.2

