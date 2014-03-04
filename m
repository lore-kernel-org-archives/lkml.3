Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbaCDU4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:56:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbaCDUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Drew Richardson <drew.richardson@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.13 142/172] perf: Fix hotplug splat
Date: Tue,  4 Mar 2014 12:03:46 -0800
Message-Id: <20140304200304.249605791@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7833,14 +7833,14 @@ static void perf_pmu_rotate_stop(struct
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
@@ -7864,11 +7864,11 @@ static void perf_event_exit_cpu(int cpu)
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


