Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3HTCiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:38:00 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51224 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3HTCh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:37:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] rcu: Fix rcu_barrier() documentation
Date: Mon, 19 Aug 2013 19:37:45 -0700
Message-Id: <1376966267-29949-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130820023717.GA29357@linux.vnet.ibm.com>
References: <20130820023717.GA29357@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-5406-0000-0000-00000B9B2DAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

There was a time when rcu_barrier() was guaranteed to wait for at least
a grace period, but that time ended due to energy-efficiency concerns.
So now rcu_barrier() is a no-op if there are no RCU callbacks queued in
the system.  This commit updates the documentation to reflect this change.

Now, rcu_barrier() often does wait for a grace period, so, one could
imagine some modification to rcu_barrier() to more efficiently handle
cases where both rcu_barrier() and a grace period are needed.  But this
must wait until someone shows a real-world need for a change.

Reported-by: Bob Copeland <bob@cozybit.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/RCU/rcubarrier.txt | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/RCU/rcubarrier.txt b/Documentation/RCU/rcubarrier.txt
index 2e319d1..b10cfe7 100644
--- a/Documentation/RCU/rcubarrier.txt
+++ b/Documentation/RCU/rcubarrier.txt
@@ -70,10 +70,14 @@ in realtime kernels in order to avoid excessive scheduling latencies.
 
 rcu_barrier()
 
-We instead need the rcu_barrier() primitive. This primitive is similar
-to synchronize_rcu(), but instead of waiting solely for a grace
-period to elapse, it also waits for all outstanding RCU callbacks to
-complete. Pseudo-code using rcu_barrier() is as follows:
+We instead need the rcu_barrier() primitive.  Rather than waiting for
+a grace period to elapse, rcu_barrier() waits for all outstanding RCU
+callbacks to complete.  Please note that rcu_barrier() does -not- imply
+synchronize_rcu(), in particular, if there are no RCU callbacks queued
+anywhere, rcu_barrier() is within its rights to return immediately,
+without waiting for a grace period to elapse.
+
+Pseudo-code using rcu_barrier() is as follows:
 
    1. Prevent any new RCU callbacks from being posted.
    2. Execute rcu_barrier().
-- 
1.8.1.5

