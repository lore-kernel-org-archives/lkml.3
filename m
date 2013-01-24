Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3AXPTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:19:13 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:29186 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab3AXPRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:17:38 -0500
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        ccross@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v6 08/12] sched: account guest time per-cgroup as well.
Date: Thu, 24 Jan 2013 19:17:38 +0400
Message-Id: <1359040662-8055-9-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359040662-8055-1-git-send-email-glommer@parallels.com>
References: <1359040662-8055-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>

We already track multiple tick statistics per-cgroup, using
the task_group_account_field facility. This patch accounts
guest_time in that manner as well.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>
---
 kernel/sched/cputime.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index a4332f9..0685e71 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -190,8 +190,6 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-
 	/* Add guest time to process. */
 	p->utime += cputime;
 	p->utimescaled += cputime_scaled;
@@ -200,11 +198,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add guest time to cpustat. */
 	if (TASK_NICE(p) > 0) {
-		cpustat[CPUTIME_NICE] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
+		task_group_account_field(p, CPUTIME_NICE, (__force u64) cputime);
+		task_group_account_field(p, CPUTIME_GUEST, (__force u64) cputime);
 	} else {
-		cpustat[CPUTIME_USER] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST] += (__force u64) cputime;
+		task_group_account_field(p, CPUTIME_USER, (__force u64) cputime);
+		task_group_account_field(p, CPUTIME_GUEST, (__force u64) cputime);
 	}
 }
 
-- 
1.8.1

