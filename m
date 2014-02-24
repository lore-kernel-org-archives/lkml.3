Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaBXKrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:47:17 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:41960 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXKrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:47:16 -0500
From: Juri Lelli <juri.lelli@gmail.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, rostedt@goodmis.org,
        Juri Lelli <juri.lelli@gmail.com>
Subject: [PATCH] sched/deadline: Switch CPU's presence test order
Date: Mon, 24 Feb 2014 11:47:12 +0100
Message-Id: <1393238832-9100-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 82b9580 (sched/deadline: Test for CPU's presence explicitly)
changed how we check if a CPU returned by cpudeadline machinery is
valid. But, we don't want to call cpu_present() if best_cpu is
equal to -1. So, switch the order of tests inside WARN_ON().

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/cpudeadline.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 5b8838b..5b9bb42 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -70,7 +70,7 @@ static void cpudl_heapify(struct cpudl *cp, int idx)
 
 static void cpudl_change_key(struct cpudl *cp, int idx, u64 new_dl)
 {
-	WARN_ON(!cpu_present(idx) || idx == IDX_INVALID);
+	WARN_ON(idx == IDX_INVALID || !cpu_present(idx));
 
 	if (dl_time_before(new_dl, cp->elements[idx].dl)) {
 		cp->elements[idx].dl = new_dl;
@@ -117,7 +117,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	}
 
 out:
-	WARN_ON(!cpu_present(best_cpu) && best_cpu != -1);
+	WARN_ON(best_cpu != -1 && !cpu_present(best_cpu));
 
 	return best_cpu;
 }
-- 
1.7.9.5

