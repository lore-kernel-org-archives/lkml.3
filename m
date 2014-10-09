Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbaJIQgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:36:47 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38494 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448AbaJIQgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:36:20 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v2 09/12] perf/x86: fix intel_get_event_constraints() for dynamic constraints
Date: Thu,  9 Oct 2014 18:34:43 +0200
Message-Id: <1412872486-2930-10-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412872486-2930-1-git-send-email-eranian@google.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dynamic constraint, we need to restart from the static
constraints each time the intel_get_event_constraints() is called.

Reviewed-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 041dec7..674f296 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1989,20 +1989,25 @@ static struct event_constraint *
 intel_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
 			    struct perf_event *event)
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
-		c = __intel_get_event_constraints(cpuc, idx, event);
+	c2 = __intel_get_event_constraints(cpuc, idx, event);
+	if (c1 && (c1->flags & PERF_X86_EVENT_DYNAMIC)) {
+		bitmap_copy(c1->idxmsk, c2->idxmsk, X86_PMC_IDX_MAX);
+		c1->weight = c2->weight;
+		c2 = c1;
+	}
 
 	if (cpuc->excl_cntrs)
-		return intel_get_excl_constraints(cpuc, event, idx, c);
+		return intel_get_excl_constraints(cpuc, event, idx, c2);
 
-	return c;
+	return c2;
 }
 
 static void intel_put_excl_constraints(struct cpu_hw_events *cpuc,
-- 
1.9.1

