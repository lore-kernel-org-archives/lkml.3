Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaFDVo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:44:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38170 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbaFDVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:44:25 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com, maria.n.dimakopoulou@gmail.com
Subject: [PATCH 8/9] perf/x86: fix intel_get_event_constraints() for dynamic constraints
Date: Wed,  4 Jun 2014 23:34:17 +0200
Message-Id: <1401917658-26065-9-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401917658-26065-1-git-send-email-eranian@google.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dynamic constraint, we need to restart from the static
constraints each time the intel_get_event_constraints() is called.

Reviewed-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index b1a2684..4fb4fe6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1849,20 +1849,25 @@ intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
 static struct event_constraint *
 intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
-	struct event_constraint *c = event->hw.constraint;
+	struct event_constraint *c1 = event->hw.constraint;
+	struct event_constraint *c2;
 
 	/*
 	 * first time only
 	 * - static constraint: no change across incremental scheduling calls
 	 * - dynamic constraint: handled by intel_get_excl_constraints()
 	 */
-	if (!c)
-		c = __intel_get_event_constraints(cpuc, event);
+	c2 = __intel_get_event_constraints(cpuc, event);
+	if (c1 && (c1->flags & PERF_X86_EVENT_DYNAMIC)) {
+		bitmap_copy(c1->idxmsk, c2->idxmsk, X86_PMC_IDX_MAX);
+		c1->weight = c2->weight;
+		c2 = c1;
+	}
 
 	if (cpuc->excl_cntrs)
-		return intel_get_excl_constraints(cpuc, event, c);
+		return intel_get_excl_constraints(cpuc, event, c2);
 
-	return c;
+	return c2;
 }
 
 static void intel_put_excl_constraints(struct cpu_hw_events *cpuc,
-- 
1.7.9.5

