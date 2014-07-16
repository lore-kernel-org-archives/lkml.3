Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935117AbaGPTXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:23:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934984AbaGPTXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:23:14 -0400
Date: Wed, 16 Jul 2014 12:21:15 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-33ecd2083a9560fbc1ef1b1279ef3ecb4c012a4f@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        peterz@infradead.org, jason.low2@hp.com, riel@redhat.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        david@fromorbit.com, davidlohr@hp.com, scott.norton@hp.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, waiman.long@hp.com,
        tim.c.chen@linux.intel.com, paulmck@linux.vnet.ibm.com, aswin@hp.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        riel@redhat.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        david@fromorbit.com, tglx@linutronix.de, scott.norton@hp.com,
        davidlohr@hp.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        waiman.long@hp.com, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, aswin@hp.com
In-Reply-To: <1405358872-3732-5-git-send-email-jason.low2@hp.com>
References: <1405358872-3732-5-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/urgent] locking/spinlocks/mcs:
  Micro-optimize osq_unlock()
Git-Commit-ID: 33ecd2083a9560fbc1ef1b1279ef3ecb4c012a4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33ecd2083a9560fbc1ef1b1279ef3ecb4c012a4f
Gitweb:     http://git.kernel.org/tip/33ecd2083a9560fbc1ef1b1279ef3ecb4c012a4f
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Mon, 14 Jul 2014 10:27:51 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:28:06 +0200

locking/spinlocks/mcs: Micro-optimize osq_unlock()

In the unlock function of the cancellable MCS spinlock, the first
thing we do is to retrive the current CPU's osq node. However, due to
the changes made in the previous patch, in the common case where the
lock is not contended, we wouldn't need to access the current CPU's
osq node anymore.

This patch optimizes this by only retriving this CPU's osq node
after we attempt the initial cmpxchg to unlock the osq and found
that its contended.

Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Scott Norton <scott.norton@hp.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1405358872-3732-5-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mcs_spinlock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
