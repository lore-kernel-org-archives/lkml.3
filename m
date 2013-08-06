Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab3HFMIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 08:08:10 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52937 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab3HFMII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 08:08:08 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] cpumask: fix cpumask leak in partition_sched_domains
Date: Tue,  6 Aug 2013 20:06:42 +0800
Message-Id: <1375790802-11857-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.6 (Apple Git-31.1)
In-Reply-To: <87d2prqvse.fsf@rustcorp.com.au>
References: <87d2prqvse.fsf@rustcorp.com.au>
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
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
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
-- 
1.7.9.6 (Apple Git-31.1)

