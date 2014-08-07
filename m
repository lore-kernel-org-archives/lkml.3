Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaHGW1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:27:21 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:21125 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaHGW1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:27:02 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 3/7] locking/rwsem: rwsem_can_spin_on_owner can be called with preemption enabled
Date: Thu,  7 Aug 2014 18:26:44 -0400
Message-Id: <1407450408-11679-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rwsem_can_spin_on_owner() function can be called with preemption
enabled. This patch moves it before preempt_disable() so that it won't
do unnecessary preemption operations when spinning is not possible.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/rwsem-xadd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index ddd56d2..c8887ba 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -404,11 +404,11 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 	bool taken = false;
 	int  spincnt = 0;
 
-	preempt_disable();
-
 	/* sem->wait_lock should not be held when doing optimistic spinning */
 	if (!rwsem_can_spin_on_owner(sem))
-		goto done;
+		return false;
+
+	preempt_disable();
 
 	if (!osq_lock(&sem->osq))
 		goto done;
-- 
1.7.1

