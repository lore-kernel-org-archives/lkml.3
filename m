Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaIVScf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:32:35 -0400
Received: from forward8l.mail.yandex.net ([84.201.143.141]:54398 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbaIVScd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:32:33 -0400
X-Yandex-Uniq: b284365d-6dfe-4afa-b63e-7f5b1ab265f9
Authentication-Results: smtp4o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v2 5/6] sched: Use rq->rd in sched_setaffinity() under RCU
 read lock
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Mon, 22 Sep 2014 22:32:28 +0400
Message-ID: <20140922183228.10761.72219.stgit@localhost>
In-Reply-To: <20140922183202.10761.6682.stgit@localhost>
References: <20140922183202.10761.6682.stgit@localhost>
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
index 3b07710..643ee99 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4023,13 +4023,14 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
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

