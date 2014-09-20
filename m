Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbaITQvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:51:47 -0400
Received: from forward10l.mail.yandex.net ([84.201.143.143]:40887 "EHLO
	forward10l.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757178AbaITQvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:51:43 -0400
X-Yandex-Uniq: 9b88e02b-91df-4ad5-bdbe-18ad38fa216b
Authentication-Results: smtp4h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 5/7] sched: Use rq->rd in sched_setaffinity() under RCU read
 lock
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Sat, 20 Sep 2014 20:51:40 +0400
Message-ID: <20140920165140.16299.45521.stgit@localhost>
In-Reply-To: <20140920165116.16299.1381.stgit@localhost>
References: <20140920165116.16299.1381.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

task_rq(p)->rd and task_rq(p)->rd->span may be used-after-free here.
Probability of NULL pointer derefference isn't zero in this place.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Cc: <stable@vger.kernel.org> # v3.14+
---
 kernel/sched/core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 65655a887..a40d6e1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4015,13 +4015,14 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
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

