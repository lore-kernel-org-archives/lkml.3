Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3KSTQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:16:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3KSTQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:16:11 -0500
Date: Tue, 19 Nov 2013 11:15:24 -0800
From: tip-bot for Srikar Dronamraju <tipbot@zytor.com>
Message-ID: <tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20131113151718.GN21461@twins.programming.kicks-ass.net>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Check sched_domain before computing group power
Git-Commit-ID: 9abf24d465180f5f2eb26a43545348262f16b771
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 19 Nov 2013 11:15:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9abf24d465180f5f2eb26a43545348262f16b771
Gitweb:     http://git.kernel.org/tip/9abf24d465180f5f2eb26a43545348262f16b771
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Tue, 12 Nov 2013 22:11:26 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 19 Nov 2013 17:01:15 +0100

sched: Check sched_domain before computing group power

After commit 863bffc80898 ("sched/fair: Fix group power_orig
computation"), we can dereference rq->sd before it is set.

Fix this by falling back to power_of() in this case and add a comment
explaining things.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
[ Added comment and tweaked patch. ]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: mikey@neuling.org
Link: http://lkml.kernel.org/r/20131113151718.GN21461@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e8b652e..fd773ad 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5379,10 +5379,31 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		 */
 
 		for_each_cpu(cpu, sched_group_cpus(sdg)) {
-			struct sched_group *sg = cpu_rq(cpu)->sd->groups;
+			struct sched_group_power *sgp;
+			struct rq *rq = cpu_rq(cpu);
 
-			power_orig += sg->sgp->power_orig;
-			power += sg->sgp->power;
+			/*
+			 * build_sched_domains() -> init_sched_groups_power()
+			 * gets here before we've attached the domains to the
+			 * runqueues.
+			 *
+			 * Use power_of(), which is set irrespective of domains
+			 * in update_cpu_power().
+			 *
+			 * This avoids power/power_orig from being 0 and
+			 * causing divide-by-zero issues on boot.
+			 *
+			 * Runtime updates will correct power_orig.
+			 */
+			if (unlikely(!rq->sd)) {
+				power_orig += power_of(cpu);
+				power += power_of(cpu);
+				continue;
+			}
+
+			sgp = rq->sd->groups->sgp;
+			power_orig += sgp->power_orig;
+			power += sgp->power;
 		}
 	} else  {
 		/*
