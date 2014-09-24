Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaIXO61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:58:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59715 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaIXO6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:58:24 -0400
Date: Wed, 24 Sep 2014 07:57:33 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-f1e3a0932f3a9554371792a7daaf1e0eb19f66d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20140922183636.11015.83611.stgit@localhost>
References: <20140922183636.11015.83611.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use rq->rd in sched_setaffinity()
  under RCU read lock
Git-Commit-ID: f1e3a0932f3a9554371792a7daaf1e0eb19f66d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1e3a0932f3a9554371792a7daaf1e0eb19f66d5
Gitweb:     http://git.kernel.org/tip/f1e3a0932f3a9554371792a7daaf1e0eb19f66d5
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Mon, 22 Sep 2014 22:36:36 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:47:11 +0200

sched: Use rq->rd in sched_setaffinity() under RCU read lock

Probability of use-after-free isn't zero in this place.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org> # v3.14+
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140922183636.11015.83611.stgit@localhost
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 316127a..b5349fe 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4049,13 +4049,14 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
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
 			goto out_free_new_mask;
 		}
+		rcu_read_unlock();
 	}
 #endif
 again:
