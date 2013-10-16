Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761865Ab3JPSWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:22:53 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:64590 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761847Ab3JPSWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:22:50 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2013 14:22:50 EDT
Subject: [PATCH 3/5] sched: Fix hrtimer_cancel/rq->lock deadlock
To: peterz@infradead.org, mingo@redhat.com
From: Ben Segall <bsegall@google.com>
Cc: pjt@google.com, linux-kernel@vger.kernel.org
Date: Wed, 16 Oct 2013 11:16:22 -0700
Message-ID: <20131016181622.22647.16643.stgit@sword-of-the-dawn.mtv.corp.google.com>
In-Reply-To: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__start_cfs_bandwidth calls hrtimer_cancel while holding rq->lock,
waiting for the hrtimer to finish. However, if sched_cfs_period_timer
runs for another loop iteration, the hrtimer can attempt to take
rq->lock, resulting in deadlock.

Fix this by ensuring that cfs_b->timer_active is cleared only if the
_latest_ call to do_sched_cfs_period_timer is returning as idle. Then
__start_cfs_bandwidth can just call hrtimer_try_to_cancel and wait for
that to succeed or timer_active == 1.

Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b0eba47..fc44cc3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3234,6 +3234,13 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
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
@@ -3502,11 +3509,11 @@ void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
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

