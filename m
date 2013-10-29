Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab3J2OHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:07:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45866 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3J2OHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:07:53 -0400
Date: Tue, 29 Oct 2013 07:07:22 -0700
From: tip-bot for Ben Segall <tipbot@zytor.com>
Message-ID: <tip-db06e78cc13d70f10877e0557becc88ab3ad2be8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20131016181617.22647.73829.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20131016181617.22647.73829.stgit@sword-of-the-dawn.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Fix cfs_bandwidth misuse of hrtimer_expires_remaining
Git-Commit-ID: db06e78cc13d70f10877e0557becc88ab3ad2be8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:07:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db06e78cc13d70f10877e0557becc88ab3ad2be8
Gitweb:     http://git.kernel.org/tip/db06e78cc13d70f10877e0557becc88ab3ad2be8
Author:     Ben Segall <bsegall@google.com>
AuthorDate: Wed, 16 Oct 2013 11:16:17 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:02:20 +0100

sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining

hrtimer_expires_remaining does not take internal hrtimer locks and thus
must be guarded against concurrent __hrtimer_start_range_ns (but
returning HRTIMER_RESTART is safe). Use cfs_b->lock to make it safe.

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: pjt@google.com
Link: http://lkml.kernel.org/r/20131016181617.22647.73829.stgit@sword-of-the-dawn.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ebd187f..897d977 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3285,7 +3285,13 @@ static const u64 min_bandwidth_expiration = 2 * NSEC_PER_MSEC;
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
@@ -3361,10 +3367,12 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
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
