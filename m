Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbaKYLWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:22:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58709 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaKYKmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kirill Tkhai <ktkhai@parallels.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 130/254] sched: Use rq->rd in sched_setaffinity() under RCU read lock
Date: Tue, 25 Nov 2014 10:38:00 +0000
Message-Id: <1416912004-5928-131-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <ktkhai@parallels.com>

commit f1e3a0932f3a9554371792a7daaf1e0eb19f66d5 upstream.

Probability of use-after-free isn't zero in this place.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140922183636.11015.83611.stgit@localhost
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ luis: backported to 3.16: used peterz's backport to 3.17 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 169720f46c30..07f41f4fe4db 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3983,13 +3983,14 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	 * root_domain.
 	 */
 #ifdef CONFIG_SMP
-	if (task_has_dl_policy(p)) {
-		const struct cpumask *span = task_rq(p)->rd->span;
-
-		if (dl_bandwidth_enabled() && !cpumask_subset(span, new_mask)) {
+	if (task_has_dl_policy(p) && dl_bandwidth_enabled()) {
+		rcu_read_lock();
+		if (!cpumask_subset(task_rq(p)->rd->span, new_mask)) {
 			retval = -EBUSY;
+			rcu_read_unlock();
 			goto out_unlock;
 		}
+		rcu_read_unlock();
 	}
 #endif
 again:
-- 
2.1.0

