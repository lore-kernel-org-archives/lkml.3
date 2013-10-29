Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab3J2OIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:08:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45876 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab3J2OH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:07:59 -0400
Date: Tue, 29 Oct 2013 07:07:31 -0700
From: tip-bot for Ben Segall <tipbot@zytor.com>
Message-ID: <tip-927b54fccbf04207ec92f669dce6806848cbec7d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20131016181622.22647.16643.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20131016181622.22647.16643.stgit@sword-of-the-dawn.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix hrtimer_cancel()/rq->lock deadlock
Git-Commit-ID: 927b54fccbf04207ec92f669dce6806848cbec7d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:07:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  927b54fccbf04207ec92f669dce6806848cbec7d
Gitweb:     http://git.kernel.org/tip/927b54fccbf04207ec92f669dce6806848cbec7d
Author:     Ben Segall <bsegall@google.com>
AuthorDate: Wed, 16 Oct 2013 11:16:22 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:02:21 +0100

sched: Fix hrtimer_cancel()/rq->lock deadlock

__start_cfs_bandwidth calls hrtimer_cancel while holding rq->lock,
waiting for the hrtimer to finish. However, if sched_cfs_period_timer
runs for another loop iteration, the hrtimer can attempt to take
rq->lock, resulting in deadlock.

Fix this by ensuring that cfs_b->timer_active is cleared only if the
_latest_ call to do_sched_cfs_period_timer is returning as idle. Then
__start_cfs_bandwidth can just call hrtimer_try_to_cancel and wait for
that to succeed or timer_active == 1.

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: pjt@google.com
Link: http://lkml.kernel.org/r/20131016181622.22647.16643.stgit@sword-of-the-dawn.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 897d977..f6308cb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3225,6 +3225,13 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 	if (idle)
 		goto out_unlock;
 
+	/*
+	 * if we have relooped after returning idle once, we need to update our
+	 * status as actually running, so that other cpus doing
+	 * __start_cfs_bandwidth will stop trying to cancel us.
+	 */
+	cfs_b->timer_active = 1;
+
 	__refill_cfs_bandwidth_runtime(cfs_b);
 
 	if (!throttled) {
@@ -3493,11 +3500,11 @@ void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	 * (timer_active==0 becomes visible before the hrtimer call-back
 	 * terminates).  In either case we ensure that it's re-programmed
 	 */
-	while (unlikely(hrtimer_active(&cfs_b->period_timer))) {
+	while (unlikely(hrtimer_active(&cfs_b->period_timer)) &&
+	       hrtimer_try_to_cancel(&cfs_b->period_timer) < 0) {
+		/* bounce the lock to allow do_sched_cfs_period_timer to run */
 		raw_spin_unlock(&cfs_b->lock);
-		/* ensure cfs_b->lock is available while we wait */
-		hrtimer_cancel(&cfs_b->period_timer);
-
+		cpu_relax();
 		raw_spin_lock(&cfs_b->lock);
 		/* if someone else restarted the timer then we're done */
 		if (cfs_b->timer_active)
