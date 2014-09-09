Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbaIIPA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:00:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172AbaIIOyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:54:01 -0400
Date: Tue, 9 Sep 2014 07:52:38 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-8236d907ab3411ad452280faa8b26c1347327380@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, pjt@google.com,
        peterz@infradead.org, tim.c.chen@linux.intel.com, yuyang.du@intel.com,
        jason.low2@hp.com, Waiman.Long@hp.com, chegu_vinod@hp.com,
        tglx@linutronix.de, scott.norton@hp.com, aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, pjt@google.com, yuyang.du@intel.com,
        tim.c.chen@linux.intel.com, jason.low2@hp.com, Waiman.Long@hp.com,
        chegu_vinod@hp.com, tglx@linutronix.de, scott.norton@hp.com,
        aswin@hp.com
In-Reply-To: <1409643684.19197.15.camel@j-VirtualBox>
References: <1409643684.19197.15.camel@j-VirtualBox>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Reduce contention in update_cfs_rq_blocked_load()
Git-Commit-ID: 8236d907ab3411ad452280faa8b26c1347327380
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8236d907ab3411ad452280faa8b26c1347327380
Gitweb:     http://git.kernel.org/tip/8236d907ab3411ad452280faa8b26c1347327380
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Tue, 2 Sep 2014 00:41:24 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 9 Sep 2014 06:47:29 +0200

sched: Reduce contention in update_cfs_rq_blocked_load()

When running workloads on 2+ socket systems, based on perf profiles, the
update_cfs_rq_blocked_load() function often shows up as taking up a
noticeable % of run time.

Much of the contention is in __update_cfs_rq_tg_load_contrib() when we
update the tg load contribution stats.  However, it turns out that in many
cases, they don't need to be updated and "tg_contrib" is 0.

This patch adds a check in __update_cfs_rq_tg_load_contrib() to skip updating
tg load contribution stats when nothing needs to be updated. This reduces the
cacheline contention that would be unnecessary.

Reviewed-by: Ben Segall <bsegall@google.com>
Reviewed-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>
Cc: jason.low2@hp.com
Cc: Yuyang Du <yuyang.du@intel.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Cc: Scott J Norton <scott.norton@hp.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409643684.19197.15.camel@j-VirtualBox
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 50d2025..be9e97b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2382,6 +2382,9 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
 	tg_contrib -= cfs_rq->tg_load_contrib;
 
+	if (!tg_contrib)
+		return;
+
 	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
 		atomic_long_add(tg_contrib, &tg->load_avg);
 		cfs_rq->tg_load_contrib += tg_contrib;
