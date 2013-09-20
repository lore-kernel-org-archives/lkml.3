Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3ITNrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:47:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3ITNrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:47:36 -0400
Date: Fri, 20 Sep 2013 06:46:59 -0700
From: tip-bot for Vladimir Davydov <tipbot@zytor.com>
Message-ID: <tip-7e3115ef5149fc502e3a2e80719dba54a8e7409d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, tglx@linutronix.de,
        vdavydov@parallels.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, tglx@linutronix.de,
        vdavydov@parallels.com
In-Reply-To: <1379173186-11944-1-git-send-email-vdavydov@parallels.com>
References: <1379173186-11944-1-git-send-email-vdavydov@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/balancing: Fix cfs_rq->
 task_h_load calculation
Git-Commit-ID: 7e3115ef5149fc502e3a2e80719dba54a8e7409d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 06:47:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e3115ef5149fc502e3a2e80719dba54a8e7409d
Gitweb:     http://git.kernel.org/tip/7e3115ef5149fc502e3a2e80719dba54a8e7409d
Author:     Vladimir Davydov <vdavydov@parallels.com>
AuthorDate: Sat, 14 Sep 2013 19:39:46 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 20 Sep 2013 11:59:39 +0200

sched/balancing: Fix cfs_rq->task_h_load calculation

Patch a003a2 (sched: Consider runnable load average in move_tasks())
sets all top-level cfs_rqs' h_load to rq->avg.load_avg_contrib, which is
always 0. This mistype leads to all tasks having weight 0 when load
balancing in a cpu-cgroup enabled setup. There obviously should be sum
of weights of all runnable tasks there instead. Fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1379173186-11944-1-git-send-email-vdavydov@parallels.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2aedacc..7c70201 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4242,7 +4242,7 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
 	}
 
 	if (!se) {
-		cfs_rq->h_load = rq->avg.load_avg_contrib;
+		cfs_rq->h_load = cfs_rq->runnable_load_avg;
 		cfs_rq->last_h_load_update = now;
 	}
 
