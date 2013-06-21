Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423011Ab3FUOVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:21:50 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:50036 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422995Ab3FUOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:21:46 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 1/8] perf,x86: disable PEBS-LL in intel_pmu_pebs_disable()
Date: Fri, 21 Jun 2013 16:20:41 +0200
Message-Id: <1371824448-7306-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371824448-7306-1-git-send-email-eranian@google.com>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure intel_pmu_pebs_disable() and intel_pmu_pebs_enable()
are symmetrical w.r.t. PEBS-LL and precise store.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ed3e553..3065c57 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -653,6 +653,12 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 
 	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
+
+	if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_LDLAT)
+		cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
+	else if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_ST)
+		cpuc->pebs_enabled &= ~(1ULL << 63);
+
 	if (cpuc->enabled)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 
-- 
1.8.1.2

