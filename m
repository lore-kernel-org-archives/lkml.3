Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaILNmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:42:24 -0400
Received: from relay.parallels.com ([195.214.232.42]:35936 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbaILNmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:42:23 -0400
Message-ID: <1410529340.3569.27.camel@tkhai>
Subject: [PATCH 5/5] sched/dl: Simplify pick_dl_task()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <tkhai@yandex.ru>
Date: Fri, 12 Sep 2014 17:42:20 +0400
In-Reply-To: <20140912132709.26840.4893.stgit@tkhai>
References: <20140912132709.26840.4893.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1)Nobody calls pick_dl_task with negative cpu, it's old RT leftover.

2)If p->nr_cpus_allowed is 1, than the affinity has just been changed
in set_cpus_allowed_ptr(); we'll pick it just earlier than migration
thread.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/deadline.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index cc4eb89..aaa5abb 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1121,10 +1121,8 @@ static void set_curr_task_dl(struct rq *rq)
 static int pick_dl_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
-	    (p->nr_cpus_allowed > 1))
+	    cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 		return 1;
-
 	return 0;
 }
 



