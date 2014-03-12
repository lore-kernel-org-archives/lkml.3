Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbaCLCKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 22:10:52 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:36605 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbaCLCKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 22:10:14 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/6] cputime: Fix jiffies based cputime assumption on steal accounting
Date: Wed, 12 Mar 2014 03:10:00 +0100
Message-Id: <1394590202-772-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394590202-772-1-git-send-email-fweisbec@gmail.com>
References: <1394590202-772-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The steal guest time accounting code assumes that cputime_t is based on
jiffies. So when CONFIG_NO_HZ_FULL=y, which implies that cputime_t
is based on nsecs, steal_account_process_tick() passes the delta in
jiffies to account_steal_time() which then accounts it as if it's a
value in nsecs.

As a result, accounting 1 second of steal time (with HZ=100 that would
be 100 jiffies) is spuriously accounted as 100 nsecs.

As such /proc/stat may report 0 values of steal time even when two
guests have run concurrently for a few seconds on the same host and
same CPU.

In order to fix this, lets convert the nsecs based steal delta to
cputime instead of jiffies by using the right conversion API.

Given that the steal time is stored in cputime_t and this type can have
a smaller granularity than nsecs, we only account the rounded converted
value and leave the remaining nsecs for the next deltas.

Reported-by: Huiqingding <huding@redhat.com>
Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/cputime.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 9994791..c91b097 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -258,16 +258,22 @@ static __always_inline bool steal_account_process_tick(void)
 {
 #ifdef CONFIG_PARAVIRT
 	if (static_key_false(&paravirt_steal_enabled)) {
-		u64 steal, st = 0;
+		u64 steal;
+		cputime_t steal_ct;
 
 		steal = paravirt_steal_clock(smp_processor_id());
 		steal -= this_rq()->prev_steal_time;
 
-		st = steal_ticks(steal);
-		this_rq()->prev_steal_time += st * TICK_NSEC;
+		/*
+		 * cputime_t may be less precise than nsecs (eg: if it's
+		 * based on jiffies). Lets cast the result to cputime
+		 * granularity and account the rest on the next rounds.
+		 */
+		steal_ct = nsecs_to_cputime(steal);
+		this_rq()->prev_steal_time += cputime_to_nsecs(steal_ct);
 
-		account_steal_time(st);
-		return st;
+		account_steal_time(steal_ct);
+		return steal_ct;
 	}
 #endif
 	return false;
-- 
1.8.3.1

