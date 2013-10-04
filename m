Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3JDRcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:32:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58690 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3JDRcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:32:19 -0400
Date: Fri, 4 Oct 2013 10:31:37 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-mkj72lxagw1z8fvjm648iznw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix perf_pmu_migrate_context
Git-Commit-ID: 9886167d20c0720dcfb01e62cdff4d906b226f43
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:31:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9886167d20c0720dcfb01e62cdff4d906b226f43
Gitweb:     http://git.kernel.org/tip/9886167d20c0720dcfb01e62cdff4d906b226f43
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 3 Oct 2013 16:02:23 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 09:58:53 +0200

perf: Fix perf_pmu_migrate_context

While auditing the list_entry usage due to a trinity bug I found that
perf_pmu_migrate_context violates the rules for
perf_event::event_entry.

The problem is that perf_event::event_entry is a RCU list element, and
hence we must wait for a full RCU grace period before re-using the
element after deletion.

Therefore the usage in perf_pmu_migrate_context() which re-uses the
entry immediately is broken. For now introduce another list_head into
perf_event for this specific usage.

This doesn't actually fix the trinity report because that never goes
through this code.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-mkj72lxagw1z8fvjm648iznw@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h | 24 +++++++++++++++++++++++-
 kernel/events/core.c       |  6 +++---
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 866e85c..c8ba627 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -294,9 +294,31 @@ struct ring_buffer;
  */
 struct perf_event {
 #ifdef CONFIG_PERF_EVENTS
-	struct list_head		group_entry;
+	/*
+	 * entry onto perf_event_context::event_list;
+	 *   modifications require ctx->lock
+	 *   RCU safe iterations.
+	 */
 	struct list_head		event_entry;
+
+	/*
+	 * XXX: group_entry and sibling_list should be mutually exclusive;
+	 * either you're a sibling on a group, or you're the group leader.
+	 * Rework the code to always use the same list element.
+	 *
+	 * Locked for modification by both ctx->mutex and ctx->lock; holding
+	 * either sufficies for read.
+	 */
+	struct list_head		group_entry;
 	struct list_head		sibling_list;
+
+	/*
+	 * We need storage to track the entries in perf_pmu_migrate_context; we
+	 * cannot use the event_entry because of RCU and we want to keep the
+	 * group in tact which avoids us using the other two entries.
+	 */
+	struct list_head		migrate_entry;
+
 	struct hlist_node		hlist_entry;
 	int				nr_siblings;
 	int				group_flags;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index cb4238e..d49a9d2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7234,15 +7234,15 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 		perf_remove_from_context(event);
 		unaccount_event_cpu(event, src_cpu);
 		put_ctx(src_ctx);
-		list_add(&event->event_entry, &events);
+		list_add(&event->migrate_entry, &events);
 	}
 	mutex_unlock(&src_ctx->mutex);
 
 	synchronize_rcu();
 
 	mutex_lock(&dst_ctx->mutex);
-	list_for_each_entry_safe(event, tmp, &events, event_entry) {
-		list_del(&event->event_entry);
+	list_for_each_entry_safe(event, tmp, &events, migrate_entry) {
+		list_del(&event->migrate_entry);
 		if (event->state >= PERF_EVENT_STATE_OFF)
 			event->state = PERF_EVENT_STATE_INACTIVE;
 		account_event_cpu(event, dst_cpu);
