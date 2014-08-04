Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaHDCgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 22:36:32 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:43169 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaHDCga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 22:36:30 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 1/7] locking/rwsem: don't resched at the end of optimistic spinning
Date: Sun,  3 Aug 2014 22:36:16 -0400
Message-Id: <1407119782-41119-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a fully preemptive kernel, a call to preempt_enable() could
potentially trigger a task rescheduling event. In the case of rwsem
optimistic spinning, the task has either gotten the lock or is going
to sleep soon. So there is no point to do rescheduling here.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/rwsem-xadd.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index a2391ac..d058946 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -385,7 +385,11 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 	}
 	osq_unlock(&sem->osq);
 done:
-	preempt_enable();
+	/*
+	 * Don't need to do rescheduling here as we either got the lock or
+	 * is going to sleep soon.
+	 */
+	preempt_enable_no_resched();
 	return taken;
 }
 
-- 
1.7.1

