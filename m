Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965801Ab3E2LDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:03:40 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3557 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965732Ab3E2LDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:03:38 -0400
From: Glauber Costa <glommer@openvz.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <devel@openvz.org>,
        Glauber Costa <glommer@openvz.org>
Subject: [PATCH v7 07/11] sched: account guest time per-cgroup as well.
Date: Wed, 29 May 2013 15:03:18 +0400
Message-Id: <1369825402-31046-8-git-send-email-glommer@openvz.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369825402-31046-1-git-send-email-glommer@openvz.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already track multiple tick statistics per-cgroup, using
the task_group_account_field facility. This patch accounts
guest_time in that manner as well.

Signed-off-by: Glauber Costa <glommer@openvz.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>
---
 kernel/sched/cputime.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 74a44ef..e653e52 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -183,8 +183,6 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-
 	/* Add guest time to process. */
 	p->utime += cputime;
 	p->utimescaled += cputime_scaled;
@@ -193,11 +191,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
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
1.8.1.4

