Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaB0Ndb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:33:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaB0Nd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:33:26 -0500
Date: Thu, 27 Feb 2014 05:32:31 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-k6v5wundvusvcseqj1si0oz0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, peterz@infradead.org, drew.richardson@arm.com,
        stable@vger.kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, peterz@infradead.org, drew.richardson@arm.com,
        stable@vger.kernel.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix hotplug splat
Git-Commit-ID: e3703f8cdfcf39c25c4338c3ad8e68891cca3731
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3703f8cdfcf39c25c4338c3ad8e68891cca3731
Gitweb:     http://git.kernel.org/tip/e3703f8cdfcf39c25c4338c3ad8e68891cca3731
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 24 Feb 2014 12:06:12 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:38:03 +0100

perf: Fix hotplug splat

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
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/n/tip-k6v5wundvusvcseqj1si0oz0@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56003c6..fa0b2d4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7856,14 +7856,14 @@ static void perf_pmu_rotate_stop(struct pmu *pmu)
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
@@ -7887,11 +7887,11 @@ static void perf_event_exit_cpu(int cpu)
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
