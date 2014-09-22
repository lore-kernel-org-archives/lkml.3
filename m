Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaIVSgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:36:42 -0400
Received: from forward9l.mail.yandex.net ([84.201.143.142]:46294 "EHLO
	forward9l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbaIVSgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:36:39 -0400
X-Yandex-Uniq: da3e46f3-fd18-4f1a-b738-b97f49c5b769
Authentication-Results: smtp1o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v3 5/6] sched: Use rq->rd in sched_setaffinity() under RCU
 read lock
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Mon, 22 Sep 2014 22:36:36 +0400
Message-ID: <20140922183636.11015.83611.stgit@localhost>
In-Reply-To: <20140922183612.11015.64200.stgit@localhost>
References: <20140922183612.11015.64200.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

Probability of use-after-free isn't zero in this place.

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

