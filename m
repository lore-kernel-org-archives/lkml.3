Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3HPSsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:48:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40420 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab3HPSsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:48:24 -0400
Date: Fri, 16 Aug 2013 11:47:56 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-5ec4c599a52362896c3e7c6a31ba6145dca9c6f5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20130802191630.GT27162@twins.programming.kicks-ass.net>
References: <20130802191630.GT27162@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Do not compute time values unnecessarily
Git-Commit-ID: 5ec4c599a52362896c3e7c6a31ba6145dca9c6f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Aug 2013 11:48:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ec4c599a52362896c3e7c6a31ba6145dca9c6f5
Gitweb:     http://git.kernel.org/tip/5ec4c599a52362896c3e7c6a31ba6145dca9c6f5
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 2 Aug 2013 21:16:30 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Aug 2013 17:55:52 +0200

perf: Do not compute time values unnecessarily

We should not be calling calc_timer_values() for events that do not actually
have an mmap()'ed userpage.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130802191630.GT27162@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2e675e8..928fae7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3670,6 +3670,10 @@ void perf_event_update_userpage(struct perf_event *event)
 	u64 enabled, running, now;
 
 	rcu_read_lock();
+	rb = rcu_dereference(event->rb);
+	if (!rb)
+		goto unlock;
+
 	/*
 	 * compute total_time_enabled, total_time_running
 	 * based on snapshot values taken when the event
@@ -3680,12 +3684,8 @@ void perf_event_update_userpage(struct perf_event *event)
 	 * NMI context
 	 */
 	calc_timer_values(event, &now, &enabled, &running);
-	rb = rcu_dereference(event->rb);
-	if (!rb)
-		goto unlock;
 
 	userpg = rb->user_page;
-
 	/*
 	 * Disable preemption so as to not let the corresponding user-space
 	 * spin too long if we get preempted.
