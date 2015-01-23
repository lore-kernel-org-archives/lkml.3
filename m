Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbbAWNAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:00:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:46860 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbbAWNAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:00:32 -0500
Message-Id: <20150123125834.150481799@infradead.org>
User-Agent: quilt/0.61-1
Date: Fri, 23 Jan 2015 13:52:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: vincent.weaver@maine.edu, eranian@gmail.com, jolsa@redhat.com,
        mark.rutland@arm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org
Subject: [RFC][PATCH 2/3] perf: Add a bit of paranoia
References: <20150123125159.696530128@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-perf-ctx-paranioa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a few WARNs to catch things that should never happen.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/events/core.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1275,6 +1275,8 @@ static void perf_group_attach(struct per
 	if (group_leader == event)
 		return;
 
+	WARN_ON_ONCE(group_leader->ctx != event->ctx);
+
 	if (group_leader->group_flags & PERF_GROUP_SOFTWARE &&
 			!is_software_event(event))
 		group_leader->group_flags &= ~PERF_GROUP_SOFTWARE;
@@ -1296,6 +1298,10 @@ static void
 list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 {
 	struct perf_cpu_context *cpuctx;
+
+	WARN_ON_ONCE(event->ctx != ctx);
+	lockdep_assert_held(&ctx->lock);
+
 	/*
 	 * We can have double detach due to exit/hot-unplug + close.
 	 */
@@ -1380,6 +1386,8 @@ static void perf_group_detach(struct per
 
 		/* Inherit group flags from the previous leader */
 		sibling->group_flags = event->group_flags;
+
+		WARN_ON_ONCE(sibling->ctx != event->ctx);
 	}
 
 out:
@@ -1442,6 +1450,10 @@ event_sched_out(struct perf_event *event
 {
 	u64 tstamp = perf_event_time(event);
 	u64 delta;
+
+	WARN_ON_ONCE(event->ctx != ctx);
+	lockdep_assert_held(&ctx->lock);
+
 	/*
 	 * An event which could not be activated because of
 	 * filter mismatch still needs to have its timings
@@ -7822,14 +7834,19 @@ static void perf_free_event(struct perf_
 
 	put_event(parent);
 
+	raw_spin_lock_irq(&ctx->lock);
 	perf_group_detach(event);
 	list_del_event(event, ctx);
+	raw_spin_unlock_irq(&ctx->lock);
 	free_event(event);
 }
 
 /*
- * free an unexposed, unused context as created by inheritance by
+ * Free an unexposed, unused context as created by inheritance by
  * perf_event_init_task below, used by fork() in case of fail.
+ *
+ * Not all locks are strictly required, but take them anyway to be nice and
+ * help out with the lockdep assertions.
  */
 void perf_event_free_task(struct task_struct *task)
 {


