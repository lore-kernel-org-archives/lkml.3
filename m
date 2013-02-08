Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946577Ab3BHPSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:18:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33456 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946278Ab3BHPSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:18:23 -0500
Date: Fri, 8 Feb 2013 07:17:47 -0800
From: tip-bot for Vladimir Davydov <vdavydov@parallels.com>
Message-ID: <tip-0a702bb8af3c1b2dff355fb3c27e7f7d5285e30b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        pjt@google.com, peterz@infradead.org, devel@openvz.org,
        tglx@linutronix.de, vdavydov@parallels.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, pjt@google.com, devel@openvz.org,
        tglx@linutronix.de, vdavydov@parallels.com
In-Reply-To: <1360307446-26978-1-git-send-email-vdavydov@parallels.com>
References: <1360307446-26978-1-git-send-email-vdavydov@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Initialize cfs_rq->
 runtime_remaining to non-zero on cfs bw set
Git-Commit-ID: 0a702bb8af3c1b2dff355fb3c27e7f7d5285e30b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 08 Feb 2013 07:17:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a702bb8af3c1b2dff355fb3c27e7f7d5285e30b
Gitweb:     http://git.kernel.org/tip/0a702bb8af3c1b2dff355fb3c27e7f7d5285e30b
Author:     Vladimir Davydov <vdavydov@parallels.com>
AuthorDate: Fri, 8 Feb 2013 11:10:46 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Feb 2013 15:14:38 +0100

sched: Initialize cfs_rq->runtime_remaining to non-zero on cfs bw set

If cfs_rq->runtime_remaining is <= 0 then either

 - cfs_rq is throttled and waiting for quota redistribution, or
 - cfs_rq is currently executing and will be throttled on put_prev_entity, or
 - cfs_rq is not throttled and has not executed since its quota was set
   (runtime_remaining is set to 0 on cfs bandwidth reconfiguration).

It is obvious that the last case is rather an exception from the
rule "runtime_remaining<=0 iff cfs_rq is throttled or will be
throttled as soon as it finishes its execution".

Moreover, it can lead to a task hang as follows. If
put_prev_task() is called immediately after first pick_next_task
after quota was set, "immediately" meaning rq->clock in both
functions is the same, then the corresponding cfs_rq will be
throttled.

Besides being unfair (the cfs_rq has not executed in fact), the
quota refilling timer can be idle at that time and it won't be
activated on put_prev_task because update_curr calls
account_cfs_rq_runtime, which activates the timer, only if
delta_exec is strictly positive. As a result we can get a task
"running" inside a throttled cfs_rq which will probably never be
unthrottled.

To avoid the problem, the patch makes tg_set_cfs_bandwidth
initialize runtime_remaining of each cfs_rq to 1 instead of 0 so
that the cfs_rq will be throttled only if it has executed for
some positive number of nanoseconds.

Several times we had our customers encountered such hangs inside
a VM (seems something is wrong or rather different in time
accounting there). Analyzing crash dumps revealed that hung
tasks were running inside cfs_rq's, which had the following
setup:

 cfs_rq->throttled=1
 cfs_rq->runtime_enabled=1
 cfs_rq->runtime_remaining=0
 cfs_rq->tg->cfs_bandwidth.idle=1
 cfs_rq->tg->cfs_bandwidth.timer_active=0

which conforms pretty nice to the explanation given above.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: <devel@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>
Link: http://lkml.kernel.org/r/1360307446-26978-1-git-send-email-vdavydov@parallels.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..c7a078f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7686,7 +7686,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 
 		raw_spin_lock_irq(&rq->lock);
 		cfs_rq->runtime_enabled = runtime_enabled;
-		cfs_rq->runtime_remaining = 0;
+		cfs_rq->runtime_remaining = 1;
 
 		if (cfs_rq->throttled)
 			unthrottle_cfs_rq(cfs_rq);
