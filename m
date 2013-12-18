Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3LRKdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:33:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44714 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3LRKdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:33:16 -0500
Date: Wed, 18 Dec 2013 02:32:30 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-bad7192b842c83e580747ca57104dd51fe08c223@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vincent.weaver@maine.edu, will.deacon@arm.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, will.deacon@arm.com, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <1385560479-11014-1-git-send-email-will.deacon@arm.com>
References: <1385560479-11014-1-git-send-email-will.deacon@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Fix PERF_EVENT_IOC_PERIOD to force-reset the period
Git-Commit-ID: bad7192b842c83e580747ca57104dd51fe08c223
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:32:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bad7192b842c83e580747ca57104dd51fe08c223
Gitweb:     http://git.kernel.org/tip/bad7192b842c83e580747ca57104dd51fe08c223
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 27 Nov 2013 13:54:38 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:21:33 +0100

perf: Fix PERF_EVENT_IOC_PERIOD to force-reset the period

Vince Weaver reports that, on all architectures apart from ARM,
PERF_EVENT_IOC_PERIOD doesn't actually update the period until the next
event fires. This is counter-intuitive behaviour and is better dealt
with in the core code.

This patch ensures that the period is forcefully reset when dealing with
such a request in the core code. A subsequent patch removes the
equivalent hack from the ARM back-end.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Link: http://lkml.kernel.org/r/1385560479-11014-1-git-send-email-will.deacon@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 403b781..89d34f9 100644
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
 
