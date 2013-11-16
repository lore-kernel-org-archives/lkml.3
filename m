Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3KPAKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:10:55 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:38553 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab3KPAKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:10:38 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] documentation: Fix circular-buffer example.
Date: Fri, 15 Nov 2013 16:10:29 -0800
Message-Id: <1384560630-28719-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384560630-28719-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116001005.GA28191@linux.vnet.ibm.com>
 <1384560630-28719-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1344-0000-0000-0000034C7DA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The code sample in Documentation/circular-buffers.txt appears to have a
few ordering bugs.  This patch therefore applies the needed fixes.

Reported-by: Lech Fomicki <lfomicki@poczta.fm>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/circular-buffers.txt | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/Documentation/circular-buffers.txt b/Documentation/circular-buffers.txt
index 8117e5bf6065..a36bed3db4ee 100644
--- a/Documentation/circular-buffers.txt
+++ b/Documentation/circular-buffers.txt
@@ -170,7 +170,7 @@ The producer will look something like this:
 
 		smp_wmb(); /* commit the item before incrementing the head */
 
-		buffer->head = (head + 1) & (buffer->size - 1);
+		ACCESS_ONCE(buffer->head) = (head + 1) & (buffer->size - 1);
 
 		/* wake_up() will make sure that the head is committed before
 		 * waking anyone up */
@@ -183,9 +183,14 @@ This will instruct the CPU that the contents of the new item must be written
 before the head index makes it available to the consumer and then instructs the
 CPU that the revised head index must be written before the consumer is woken.
 
-Note that wake_up() doesn't have to be the exact mechanism used, but whatever
-is used must guarantee a (write) memory barrier between the update of the head
-index and the change of state of the consumer, if a change of state occurs.
+Note that wake_up() does not guarantee any sort of barrier unless something
+is actually awakened.  We therefore cannot rely on it for ordering.  However,
+there is always one element of the array left empty.  Therefore, the
+producer must produce two elements before it could possibly corrupt the
+element currently being read by the consumer.  Therefore, the unlock-lock
+pair between consecutive invocations of the consumer provides the necessary
+ordering between the read of the index indicating that the consumer has
+vacated a given element and the write by the producer to that same element.
 
 
 THE CONSUMER
@@ -200,7 +205,7 @@ The consumer will look something like this:
 
 	if (CIRC_CNT(head, tail, buffer->size) >= 1) {
 		/* read index before reading contents at that index */
-		smp_read_barrier_depends();
+		smp_rmb();
 
 		/* extract one item from the buffer */
 		struct item *item = buffer[tail];
@@ -209,7 +214,7 @@ The consumer will look something like this:
 
 		smp_mb(); /* finish reading descriptor before incrementing tail */
 
-		buffer->tail = (tail + 1) & (buffer->size - 1);
+		ACCESS_ONCE(buffer->tail) = (tail + 1) & (buffer->size - 1);
 	}
 
 	spin_unlock(&consumer_lock);
@@ -223,7 +228,10 @@ Note the use of ACCESS_ONCE() in both algorithms to read the opposition index.
 This prevents the compiler from discarding and reloading its cached value -
 which some compilers will do across smp_read_barrier_depends().  This isn't
 strictly needed if you can be sure that the opposition index will _only_ be
-used the once.
+used the once.  Similarly, ACCESS_ONCE() is used in both algorithms to
+write the thread's index.  This documents the fact that we are writing
+to something that can be read concurrently and also prevents the compiler
+from tearing the store.
 
 
 ===============
-- 
1.8.1.5

