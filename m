Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3HRBju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 21:39:50 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37723 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3HRBiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 21:38:08 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/11] rcu: Simplify _rcu_barrier() processing
Date: Sat, 17 Aug 2013 18:37:55 -0700
Message-Id: <1376789876-27594-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130818013735.GA27234@linux.vnet.ibm.com>
 <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081801-7282-0000-0000-00001A8C3A80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit drops an unneeded ACCESS_ONCE() and simplifies an "our work
is done" check in _rcu_barrier().  This applies feedback from Linus
(https://lkml.org/lkml/2013/7/26/777) that he gave to similar code
in an unrelated patch.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c6a064a..612aff1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2817,9 +2817,20 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	 * transition.  The "if" expression below therefore rounds the old
 	 * value up to the next even number and adds two before comparing.
 	 */
-	snap_done = ACCESS_ONCE(rsp->n_barrier_done);
+	snap_done = rsp->n_barrier_done;
 	_rcu_barrier_trace(rsp, "Check", -1, snap_done);
-	if (ULONG_CMP_GE(snap_done, ((snap + 1) & ~0x1) + 2)) {
+
+	/*
+	 * If the value in snap is odd, we needed to wait for the current
+	 * rcu_barrier() to complete, then wait for the next one, in other
+	 * words, we need the value of snap_done to be three larger than
+	 * the value of snap.  On the other hand, if the value in snap is
+	 * even, we only had to wait for the next rcu_barrier() to complete,
+	 * in other words, we need the value of snap_done to be only two
+	 * greater than the value of snap.  The "(snap + 3) & 0x1" computes
+	 * this for us (thank you, Linus!).
+	 */
+	if (ULONG_CMP_GE(snap_done, (snap + 3) & ~0x1)) {
 		_rcu_barrier_trace(rsp, "EarlyExit", -1, snap_done);
 		smp_mb(); /* caller's subsequent code after above check. */
 		mutex_unlock(&rsp->barrier_mutex);
-- 
1.8.1.5

