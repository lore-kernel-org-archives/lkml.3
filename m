Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaA1H0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 02:26:03 -0500
Received: from relay.parallels.com ([195.214.232.42]:48206 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaA1H0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 02:26:01 -0500
Subject: [PATCH v2 -tip] sched/deadline: switched_to_dl() -- skip if task is
 current
To: <linux-kernel@vger.kernel.org>
From: Kirill Tkhai <ktkhai@parallels.com>
CC: <peterz@infradead.org>, <mingo@kernel.org>, <devel@openvz.org>,
        <juri.lelli@gmail.com>
Date: Tue, 28 Jan 2014 11:26:14 +0400
Message-ID: <20140128072421.32315.25300.stgit@tkhai>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: Changed comment

When p is current and it's not of dl class, then there are no other
dl taks in the rq. If we had had pushable tasks in some other rq,
they would have been pushed earlier. So, skip "p == rq->curr" case.

[This is confirmed by Juri Lelli and LKML was CC'ed, but
 unfotunately I can't find direct link on lkml.org]

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Juri Lelli <juri.lelli@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0de2482..dd19d6d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1559,7 +1559,7 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	if (unlikely(p->dl.dl_throttled))
 		return;
 
-	if (p->on_rq || rq->curr != p) {
+	if (p->on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
 			/* Only reschedule if pushing failed */

