Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3K0Nz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:55:29 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55057 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab3K0NzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:55:24 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/2] perf: fix PERF_EVENT_IOC_PERIOD to force-reset the period
Date: Wed, 27 Nov 2013 13:54:38 +0000
Message-Id: <1385560479-11014-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Vince Weaver reports that, on all architectures apart from ARM,
PERF_EVENT_IOC_PERIOD doesn't actually update the period until the next
event fires. This is counter-intuitive behaviour and is better dealt
with in the core code.

This patch ensures that the period is forcefully reset when dealing with
such a request in the core code. A subsequent patch removes the
equivalent hack from the ARM back-end.

Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

Peter -- I didn't want this to get lost, so I picked it up, fixed a typo
         and wrote a commit message. Could I add your SoB please?

	 Cheers,
		Will

 kernel/events/core.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d724e7757cd1..1c626b923ddf 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3527,7 +3527,7 @@ static void perf_event_for_each(struct perf_event *event,
 static int perf_event_period(struct perf_event *event, u64 __user *arg)
 {
 	struct perf_event_context *ctx = event->ctx;
-	int ret = 0;
+	int ret = 0, active;
 	u64 value;
 
 	if (!is_sampling_event(event))
@@ -3551,6 +3551,20 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
 		event->attr.sample_period = value;
 		event->hw.sample_period = value;
 	}
+
+	active = (event->state == PERF_EVENT_STATE_ACTIVE);
+	if (active) {
+		perf_pmu_disable(ctx->pmu);
+		event->pmu->stop(event, PERF_EF_UPDATE);
+	}
+
+	local64_set(&event->hw.period_left, 0);
+
+	if (active) {
+		event->pmu->start(event, PERF_EF_RELOAD);
+		perf_pmu_enable(ctx->pmu);
+	}
+
 unlock:
 	raw_spin_unlock_irq(&ctx->lock);
 
-- 
1.8.2.2

