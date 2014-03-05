Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbaCEOkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:40:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306AbaCEOil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 59/62] perf: Fix hotplug splat
Date: Wed,  5 Mar 2014 14:37:03 +0000
Message-Id: <1394030226-26652-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit e3703f8cdfcf39c25c4338c3ad8e68891cca3731 upstream.

Drew Richardson reported that he could make the kernel go *boom* when hotplugging
while having perf events active.

It turned out that when you have a group event, the code in
__perf_event_exit_context() fails to remove the group siblings from
the context.

We then proceed with destroying and freeing the event, and when you
re-plug the CPU and try and add another event to that CPU, things go
*boom* because you've still got dead entries there.

Reported-by: Drew Richardson <drew.richardson@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Link: http://lkml.kernel.org/n/tip-k6v5wundvusvcseqj1si0oz0@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/events/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3ea14c1..9e13b2d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7148,14 +7148,14 @@ static void perf_pmu_rotate_stop(struct pmu *pmu)
 static void __perf_event_exit_context(void *__info)
 {
 	struct perf_event_context *ctx = __info;
-	struct perf_event *event, *tmp;
+	struct perf_event *event;
 
 	perf_pmu_rotate_stop(ctx->pmu);
 
-	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
-		__perf_remove_from_context(event);
-	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups, group_entry)
+	rcu_read_lock();
+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry)
 		__perf_remove_from_context(event);
+	rcu_read_unlock();
 }
 
 static void perf_event_exit_cpu_context(int cpu)
@@ -7179,11 +7179,11 @@ static void perf_event_exit_cpu(int cpu)
 {
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
+	perf_event_exit_cpu_context(cpu);
+
 	mutex_lock(&swhash->hlist_mutex);
 	swevent_hlist_release(swhash);
 	mutex_unlock(&swhash->hlist_mutex);
-
-	perf_event_exit_cpu_context(cpu);
 }
 #else
 static inline void perf_event_exit_cpu(int cpu) { }
-- 
1.9.0

