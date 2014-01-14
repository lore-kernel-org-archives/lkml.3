Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbaANAxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:53:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaANA1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Segall <bsegall@google.com>, Peter Zijlstra <peterz@infradead.org>,
        pjt@google.com, Ingo Molnar <mingo@kernel.org>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH 3.10 60/62] sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining
Date: Mon, 13 Jan 2014 16:27:25 -0800
Message-Id: <20140114002712.179289965@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2470,7 +2470,13 @@ static const u64 min_bandwidth_expiratio
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
@@ -2546,10 +2552,12 @@ static void do_sched_cfs_slack_timer(str
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


