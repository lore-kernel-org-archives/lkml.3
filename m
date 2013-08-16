Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3HPSrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:47:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40340 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3HPSrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:47:06 -0400
Date: Fri, 16 Aug 2013 11:46:25 -0700
From: tip-bot for Xiaotian Feng <tipbot@zytor.com>
Message-ID: <tip-c8d2d47a9cbb4222ae4e993aa0e3703430c8193c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        xtfeng@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        xtfeng@gmail.com
In-Reply-To: <1375790802-11857-1-git-send-email-xtfeng@gmail.com>
References: <1375790802-11857-1-git-send-email-xtfeng@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cpumask:
  Fix cpumask leak in partition_sched_domains()
Git-Commit-ID: c8d2d47a9cbb4222ae4e993aa0e3703430c8193c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Aug 2013 11:46:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8d2d47a9cbb4222ae4e993aa0e3703430c8193c
Gitweb:     http://git.kernel.org/tip/c8d2d47a9cbb4222ae4e993aa0e3703430c8193c
Author:     Xiaotian Feng <xtfeng@gmail.com>
AuthorDate: Tue, 6 Aug 2013 20:06:42 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Aug 2013 17:44:27 +0200

cpumask: Fix cpumask leak in partition_sched_domains()

If doms_new is NULL, partition_sched_domains() will reset ndoms_cur
to 0, and free old sched domains with free_sched_domains(doms_cur, ndoms_cur).
As ndoms_cur is 0, the cpumask will not be freed.

Signed-off-by: Xiaotian Feng <xtfeng@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1375790802-11857-1-git-send-email-xtfeng@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7415cf..cf8f100 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6184,8 +6184,9 @@ match1:
 		;
 	}
 
+	n = ndoms_cur;
 	if (doms_new == NULL) {
-		ndoms_cur = 0;
+		n = 0;
 		doms_new = &fallback_doms;
 		cpumask_andnot(doms_new[0], cpu_active_mask, cpu_isolated_map);
 		WARN_ON_ONCE(dattr_new);
@@ -6193,7 +6194,7 @@ match1:
 
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
-		for (j = 0; j < ndoms_cur && !new_topology; j++) {
+		for (j = 0; j < n && !new_topology; j++) {
 			if (cpumask_equal(doms_new[i], doms_cur[j])
 			    && dattrs_equal(dattr_new, i, dattr_cur, j))
 				goto match2;
