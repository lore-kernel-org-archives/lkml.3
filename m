Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3IBHlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:41:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52383 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab3IBHlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:41:04 -0400
Date: Mon, 2 Sep 2013 00:40:11 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-95a79b805b935f4a7b685aa8a117d916c638323e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, iamjoonsoo.kim@lge.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, iamjoonsoo.kim@lge.com
In-Reply-To: <1375778203-31343-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375778203-31343-2-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Remove one division operation in find_busiest_queue()
Git-Commit-ID: 95a79b805b935f4a7b685aa8a117d916c638323e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:40:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95a79b805b935f4a7b685aa8a117d916c638323e
Gitweb:     http://git.kernel.org/tip/95a79b805b935f4a7b685aa8a117d916c638323e
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Tue, 6 Aug 2013 17:36:41 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:26:59 +0200

sched: Remove one division operation in find_busiest_queue()

Remove one division operation in find_busiest_queue() by using
crosswise multiplication:

	wl_i / power_i > wl_j / power_j :=
	wl_i * power_j > wl_j * power_i

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
[ Expanded the changelog. ]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1375778203-31343-2-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f918635..8aa217f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4968,7 +4968,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 				     struct sched_group *group)
 {
 	struct rq *busiest = NULL, *rq;
-	unsigned long max_load = 0;
+	unsigned long busiest_load = 0, busiest_power = 1;
 	int i;
 
 	for_each_cpu(i, sched_group_cpus(group)) {
@@ -4998,11 +4998,15 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * the weighted_cpuload() scaled with the cpu power, so that
 		 * the load can be moved away from the cpu that is potentially
 		 * running at a lower capacity.
+		 *
+		 * Thus we're looking for max(wl_i / power_i), crosswise
+		 * multiplication to rid ourselves of the division works out
+		 * to: wl_i * power_j > wl_j * power_i;  where j is our
+		 * previous maximum.
 		 */
-		wl = (wl * SCHED_POWER_SCALE) / power;
-
-		if (wl > max_load) {
-			max_load = wl;
+		if (wl * busiest_power > busiest_load * power) {
+			busiest_load = wl;
+			busiest_power = power;
 			busiest = rq;
 		}
 	}
