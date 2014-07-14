Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbaGNR2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:28:55 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:58758 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbaGNR2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:28:40 -0400
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Waiman Long <waiman.long@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott Norton <scott.norton@hp.com>, Dave Chinner <david@fromorbit.com>,
        Jason Low <jason.low2@hp.com>
Subject: [PATCH v2 4/5] MCS spinlocks: Micro-optimize osq_unlock()
Date: Mon, 14 Jul 2014 10:27:51 -0700
Message-Id: <1405358872-3732-5-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405358872-3732-1-git-send-email-jason.low2@hp.com>
References: <1405358872-3732-1-git-send-email-jason.low2@hp.com>
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
index 32fc16c..be9ee15 100644
--- a/kernel/locking/mcs_spinlock.c
+++ b/kernel/locking/mcs_spinlock.c
@@ -182,8 +182,7 @@ unqueue:
 
 void osq_unlock(struct optimistic_spin_queue *lock)
 {
-	struct optimistic_spin_node *node = this_cpu_ptr(&osq_node);
-	struct optimistic_spin_node *next;
+	struct optimistic_spin_node *node, *next;
 	int curr = encode_cpu(smp_processor_id());
 
 	/*
@@ -195,6 +194,7 @@ void osq_unlock(struct optimistic_spin_queue *lock)
 	/*
 	 * Second most likely case.
 	 */
+	node = this_cpu_ptr(&osq_node);
 	next = xchg(&node->next, NULL);
 	if (next) {
 		ACCESS_ONCE(next->locked) = 1;
-- 
1.7.1

