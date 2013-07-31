Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab3GaI40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:56:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3GaI4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:56:23 -0400
Date: Wed, 31 Jul 2013 01:55:28 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-9545m3apw5d93ubyrotrj31y@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        pjt@google.com, peterz@infradead.org, max@gustavus.edu,
        stable@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, pjt@google.com, max@gustavus.edu,
        stable@kernel.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Ensure update_cfs_shares()
  is called for parents of continuously-running tasks
Git-Commit-ID: bf0bd948d1682e3996adc093b43021ed391983e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 01:55:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf0bd948d1682e3996adc093b43021ed391983e6
Gitweb:     http://git.kernel.org/tip/bf0bd948d1682e3996adc093b43021ed391983e6
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 26 Jul 2013 23:48:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Jul 2013 22:14:37 +0200

sched: Ensure update_cfs_shares() is called for parents of continuously-running tasks

We typically update a task_group's shares within the dequeue/enqueue
path.  However, continuously running tasks sharing a CPU are not
subject to these updates as they are only put/picked.  Unfortunately,
when we reverted f269ae046 (in 17bc14b7), we lost the augmenting
periodic update that was supposed to account for this; resulting in a
potential loss of fairness.

To fix this, re-introduce the explicit update in
update_cfs_rq_blocked_load() [called via entity_tick()].

Reported-by: Max Hailperin <max@gustavus.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Paul Turner <pjt@google.com>
Link: http://lkml.kernel.org/n/tip-9545m3apw5d93ubyrotrj31y@git.kernel.org
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 98d1355..06db94b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2032,6 +2032,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 */
 	update_entity_load_avg(curr, 1);
 	update_cfs_rq_blocked_load(cfs_rq, 1);
+	update_cfs_shares(cfs_rq);
 
 #ifdef CONFIG_SCHED_HRTICK
 	/*
