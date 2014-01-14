Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaANAed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:34:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbaANA3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:29:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Segall <bsegall@google.com>, Peter Zijlstra <peterz@infradead.org>,
        pjt@google.com, Ingo Molnar <mingo@kernel.org>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH 3.12 76/77] sched: Fix hrtimer_cancel()/rq->lock deadlock
Date: Mon, 13 Jan 2014 16:28:37 -0800
Message-Id: <20140114002754.646056592@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Segall <bsegall@google.com>

commit 927b54fccbf04207ec92f669dce6806848cbec7d upstream.

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
Cc: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2459,6 +2459,13 @@ static int do_sched_cfs_period_timer(str
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
@@ -2727,11 +2734,11 @@ void __start_cfs_bandwidth(struct cfs_ba
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


