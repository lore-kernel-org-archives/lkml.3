Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaESNJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:09:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59348 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaESNJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:09:34 -0400
Date: Mon, 19 May 2014 06:08:31 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-b45cf72cf7e1dd3b4a95947f85659cfdc01dbdad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com, riel@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com, riel@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <20140514114037.2d93266f@annuminas.surriel.com>
References: <20140514114037.2d93266f@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  call select_idle_sibling when not affine_sd
Git-Commit-ID: b45cf72cf7e1dd3b4a95947f85659cfdc01dbdad
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

Commit-ID:  b45cf72cf7e1dd3b4a95947f85659cfdc01dbdad
Gitweb:     http://git.kernel.org/tip/b45cf72cf7e1dd3b4a95947f85659cfdc01dbdad
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Wed, 14 May 2014 11:40:37 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:40 +0900

sched: call select_idle_sibling when not affine_sd

On smaller systems, the top level sched domain will be an affine
domain, and select_idle_sibling is invoked for every SD_WAKE_AFFINE
wakeup. This seems to be working well.

On larger systems, with the node distance between far away NUMA nodes
being > RECLAIM_DISTANCE, select_idle_sibling is only called if the
waker and the wakee are on nodes less than RECLAIM_DISTANCE apart.

This patch leaves in place the policy of not pulling the task across
nodes on such systems, while fixing the issue that select_idle_sibling
is not called at all in certain circumstances.

The code will look for an idle CPU in the same CPU package as the
CPU where the task ran previously.

Cc: morten.rasmussen@arm.com
Cc: mingo@kernel.org
Cc: george.mccollister@gmail.com
Cc: ktkhai@parallels.com
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140514114037.2d93266f@annuminas.surriel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dd3fa14..429164d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4473,10 +4473,10 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 			sd = tmp;
 	}
 
-	if (affine_sd) {
-		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
-			prev_cpu = cpu;
+	if (affine_sd && cpu != prev_cpu && wake_affine(affine_sd, p, sync))
+		prev_cpu = cpu;
 
+	if (sd_flag & SD_BALANCE_WAKE) {
 		new_cpu = select_idle_sibling(p, prev_cpu);
 		goto unlock;
 	}
