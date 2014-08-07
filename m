Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbaHGW1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:27:24 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:15456 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbaHGW1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:27:03 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 4/7] locking/rwsem: more aggressive use of optimistic spinning
Date: Thu,  7 Aug 2014 18:26:45 -0400
Message-Id: <1407450408-11679-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rwsem_can_spin_on_owner() function currently allows optimistic
spinning only if the owner field is defined and is running. That is
too conservative as it will cause some tasks to miss the opportunity
of doing spinning in case the readers own the lock, the owner hasn't
been able to set the owner field in time or the lock has just become
available. With threshold limited spinning for readers, spinning
while lock owners are running should be less a concern.

This patch enables more aggressive use of optimistic spinning by
assuming that the lock is spinnable unless proved otherwise.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/rwsem-xadd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index c8887ba..1281de8 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -333,7 +333,7 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
 static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 {
 	struct task_struct *owner;
-	bool on_cpu = false;
+	bool on_cpu = true;
 
 	if (need_resched())
 		return false;
-- 
1.7.1

