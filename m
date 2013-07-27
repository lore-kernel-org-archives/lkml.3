Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab3G0H1V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 03:27:21 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50779 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab3G0H1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 03:27:09 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] cpumask: fix cpumask leak in partition_sched_domains
Date: Sat, 27 Jul 2013 15:26:51 +0800
Message-Id: <1374910011-72985-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.6 (Apple Git-31.1)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If doms_new is NULL, partition_sched_domains() will reset ndoms_cur
to 0, and free old sched domains with free_sched_domains(doms_cur, ndoms_cur).
As ndoms_cur is 0, the cpumask will not be freed.

Signed-off-by: Xiaotian Feng <xtfeng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
---
 kernel/sched/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7c32cb..3d6c57b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6184,8 +6184,9 @@ match1:
 		;
 	}
 
+	n= ndoms_cur;
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
-- 
1.7.9.6 (Apple Git-31.1)

