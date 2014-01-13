Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaAMQVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:21:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53600 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbaAMQEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Segall <bsegall@google.com>, Peter Zijlstra <peterz@infradead.org>,
        pjt@google.com, Ingo Molnar <mingo@kernel.org>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 157/208] sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining
Date: Mon, 13 Jan 2014 15:59:58 +0000
Message-Id: <1389628849-1614-158-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Segall <bsegall@google.com>

commit db06e78cc13d70f10877e0557becc88ab3ad2be8 upstream.

hrtimer_expires_remaining does not take internal hrtimer locks and thus
must be guarded against concurrent __hrtimer_start_range_ns (but
returning HRTIMER_RESTART is safe). Use cfs_b->lock to make it safe.

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: pjt@google.com
Link: http://lkml.kernel.org/r/20131016181617.22647.73829.stgit@sword-of-the-dawn.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/fair.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 78a904d..260f98ec 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2519,7 +2519,13 @@ static const u64 min_bandwidth_expiration = 2 * NSEC_PER_MSEC;
 /* how long we wait to gather additional slack before distributing */
 static const u64 cfs_bandwidth_slack_period = 5 * NSEC_PER_MSEC;
 
-/* are we near the end of the current quota period? */
+/*
+ * Are we near the end of the current quota period?
+ *
+ * Requires cfs_b->lock for hrtimer_expires_remaining to be safe against the
+ * hrtimer base being cleared by __hrtimer_start_range_ns. In the case of
+ * migrate_hrtimers, base is never cleared, so we are fine.
+ */
 static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 {
 	struct hrtimer *refresh_timer = &cfs_b->period_timer;
@@ -2595,10 +2601,12 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
 	u64 expires;
 
 	/* confirm we're still not at a refresh boundary */
-	if (runtime_refresh_within(cfs_b, min_bandwidth_expiration))
+	raw_spin_lock(&cfs_b->lock);
+	if (runtime_refresh_within(cfs_b, min_bandwidth_expiration)) {
+		raw_spin_unlock(&cfs_b->lock);
 		return;
+	}
 
-	raw_spin_lock(&cfs_b->lock);
 	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice) {
 		runtime = cfs_b->runtime;
 		cfs_b->runtime = 0;
-- 
1.8.3.2

