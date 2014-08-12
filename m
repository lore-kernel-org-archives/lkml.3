Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaHLOyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:54:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaHLOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:54:04 -0400
Date: Tue, 12 Aug 2014 07:53:05 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-b932c03c34f3b03c7364c06aa8cae5b74609fc41@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1407173008-9334-2-git-send-email-riel@redhat.com>
References: <1407173008-9334-2-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Fix off-by-one in capacity check
Git-Commit-ID: b932c03c34f3b03c7364c06aa8cae5b74609fc41
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

Commit-ID:  b932c03c34f3b03c7364c06aa8cae5b74609fc41
Gitweb:     http://git.kernel.org/tip/b932c03c34f3b03c7364c06aa8cae5b74609fc41
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 4 Aug 2014 13:23:27 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 12 Aug 2014 12:48:22 +0200

sched/numa: Fix off-by-one in capacity check

Commit a43455a1d572daf7b730fe12eb747d1e17411365 ensures that
task_numa_migrate will call task_numa_compare on the preferred
node all the time, even when the preferred node has no free capacity.

This could lead to a performance regression if nr_running == capacity
on both the source and the destination node. This can be avoided by
also checking for nr_running == capacity on the source node, which is
one stricter than checking .has_free_capacity.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: mgorman@suse.de
Cc: vincent.guittot@linaro.org
Cc: Morten.Rasmussen@arm.com
Cc: nicolas.pitre@linaro.org
Cc: efault@gmx.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1407173008-9334-2-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df1ed17..e1cf419 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1206,7 +1206,7 @@ static void task_numa_compare(struct task_numa_env *env,
 
 	if (!cur) {
 		/* Is there capacity at our destination? */
-		if (env->src_stats.has_free_capacity &&
+		if (env->src_stats.nr_running <= env->src_stats.task_capacity &&
 		    !env->dst_stats.has_free_capacity)
 			goto unlock;
 
