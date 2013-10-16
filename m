Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935441Ab3JPSQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:16:20 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:54912 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934807Ab3JPSQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:16:18 -0400
Subject: [PATCH 2/5] sched: Fix cfs_bandwidth misuse of
 hrtimer_expires_remaining
To: peterz@infradead.org, mingo@redhat.com
From: Ben Segall <bsegall@google.com>
Cc: pjt@google.com, linux-kernel@vger.kernel.org
Date: Wed, 16 Oct 2013 11:16:17 -0700
Message-ID: <20131016181617.22647.73829.stgit@sword-of-the-dawn.mtv.corp.google.com>
In-Reply-To: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_expires_remaining does not take internal hrtimer locks and thus
must be guarded against concurrent __hrtimer_start_range_ns (but
returning HRTIMER_RESTART is safe). Use cfs_b->lock to make it safe.

Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 67c9ecf..b0eba47 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3294,7 +3294,13 @@ static const u64 min_bandwidth_expiration = 2 * NSEC_PER_MSEC;
 /* how long we wait to gather additional slack before distributing */
 static const u64 cfs_bandwidth_slack_period = 5 * NSEC_PER_MSEC;
 
-/* are we near the end of the current quota period? */
+/*
+ * Are we near the end of the current quota period?
+ *
+ * Requires cfs_b->lock for hrtimer_expires_remaining to be safe against the
+ * hrtimer base being cleared by __hrtimer_start_range_ns. This is possibly
+ * incorrect if we ever built with CPU_HOTPLUG.
+ */
 static int runtime_refresh_within(struct cfs_bandwidth *cfs_b, u64 min_expire)
 {
 	struct hrtimer *refresh_timer = &cfs_b->period_timer;
@@ -3370,10 +3376,12 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
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

