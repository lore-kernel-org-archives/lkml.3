Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaC3Xnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706AbaC3Xnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:51 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Drew Richardson" <drew.richardson@arm.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Will Deacon" <will.deacon@arm.com>, "Ingo Molnar" <mingo@kernel.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.83415776@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 151/200] perf: Fix hotplug splat
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7101,14 +7101,14 @@ static void perf_pmu_rotate_stop(struct
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
@@ -7132,11 +7132,11 @@ static void perf_event_exit_cpu(int cpu)
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

