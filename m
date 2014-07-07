Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaGGSxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:53:47 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:54033 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaGGSxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:53:46 -0400
From: Jason Low <jason.low2@hp.com>
To: peterz@infradead.org, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, Waiman.Long@hp.com,
        davidlohr@hp.com, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, riel@redhat.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, hpa@zytor.com, tim.c.chen@linux.intel.com,
        konrad.wilk@oracle.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, jason.low2@hp.com
Subject: [PATCH 3/4] MCS spinlocks: Micro-optimize osq_unlock()
Date: Mon,  7 Jul 2014 11:50:18 -0700
Message-Id: <1404759019-4268-4-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
References: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the unlock function of the cancellable MCS spinlock, the first
thing we do is to retrive the current CPU's osq node. However, due to
the changes made in the previous patch, in the common case where the
lock is not contended, we wouldn't need to access the current CPU's
osq node anymore.

This patch optimizes this by only retriving this CPU's osq node
after we attempt the initial cmpxchg to unlock the osq and found
that its contended.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mcs_spinlock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
index 124a3bb..be7ac24 100644
--- a/kernel/locking/mcs_spinlock.c
+++ b/kernel/locking/mcs_spinlock.c
@@ -180,8 +180,7 @@ unqueue:
 
 void osq_unlock(struct optimistic_spin_queue *lock)
 {
-	struct optimistic_spin_node *node = this_cpu_ptr(&osq_node);
-	struct optimistic_spin_node *next;
+	struct optimistic_spin_node *node, *next;
 	int curr = encode_cpu(smp_processor_id());
 
 	/*
@@ -193,6 +192,7 @@ void osq_unlock(struct optimistic_spin_queue *lock)
 	/*
 	 * Second most likely case.
 	 */
+	node = this_cpu_ptr(&osq_node);
 	next = xchg(&node->next, NULL);
 	if (next) {
 		ACCESS_ONCE(next->locked) = 1;
-- 
1.7.1

