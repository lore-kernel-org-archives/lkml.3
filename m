Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3KPALM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:11:12 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:34032 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3KPAKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:10:48 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/4] documentation: Update circular buffer for load-acquire/store-release
Date: Fri, 15 Nov 2013 16:10:30 -0800
Message-Id: <1384560630-28719-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384560630-28719-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116001005.GA28191@linux.vnet.ibm.com>
 <1384560630-28719-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-3532-0000-0000-00000311167E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit replaces full barriers by targeted use of load-acquire and
store-release.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/circular-buffers.txt | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/Documentation/circular-buffers.txt b/Documentation/circular-buffers.txt
index a36bed3db4ee..15e54ff50018 100644
--- a/Documentation/circular-buffers.txt
+++ b/Documentation/circular-buffers.txt
@@ -160,6 +160,7 @@ The producer will look something like this:
 	spin_lock(&producer_lock);
 
 	unsigned long head = buffer->head;
+	/* The spin_unlock() and next spin_lock() provide needed ordering. */
 	unsigned long tail = ACCESS_ONCE(buffer->tail);
 
 	if (CIRC_SPACE(head, tail, buffer->size) >= 1) {
@@ -168,9 +169,8 @@ The producer will look something like this:
 
 		produce_item(item);
 
-		smp_wmb(); /* commit the item before incrementing the head */
-
-		ACCESS_ONCE(buffer->head) = (head + 1) & (buffer->size - 1);
+		smp_store_release(buffer->head,
+				  (head + 1) & (buffer->size - 1));
 
 		/* wake_up() will make sure that the head is committed before
 		 * waking anyone up */
@@ -200,21 +200,18 @@ The consumer will look something like this:
 
 	spin_lock(&consumer_lock);
 
-	unsigned long head = ACCESS_ONCE(buffer->head);
+	unsigned long head = smp_load_acquire(buffer->head);
 	unsigned long tail = buffer->tail;
 
 	if (CIRC_CNT(head, tail, buffer->size) >= 1) {
-		/* read index before reading contents at that index */
-		smp_rmb();
 
 		/* extract one item from the buffer */
 		struct item *item = buffer[tail];
 
 		consume_item(item);
 
-		smp_mb(); /* finish reading descriptor before incrementing tail */
-
-		ACCESS_ONCE(buffer->tail) = (tail + 1) & (buffer->size - 1);
+		smp_store_release(buffer->tail,
+				  (tail + 1) & (buffer->size - 1));
 	}
 
 	spin_unlock(&consumer_lock);
@@ -223,15 +220,17 @@ This will instruct the CPU to make sure the index is up to date before reading
 the new item, and then it shall make sure the CPU has finished reading the item
 before it writes the new tail pointer, which will erase the item.
 
-
-Note the use of ACCESS_ONCE() in both algorithms to read the opposition index.
-This prevents the compiler from discarding and reloading its cached value -
-which some compilers will do across smp_read_barrier_depends().  This isn't
-strictly needed if you can be sure that the opposition index will _only_ be
-used the once.  Similarly, ACCESS_ONCE() is used in both algorithms to
-write the thread's index.  This documents the fact that we are writing
-to something that can be read concurrently and also prevents the compiler
-from tearing the store.
+Note the use of ACCESS_ONCE() and smp_load_acquire() to read the
+opposition index.  This prevents the compiler from discarding and
+reloading its cached value - which some compilers will do across
+smp_read_barrier_depends().  This isn't strictly needed if you can
+be sure that the opposition index will _only_ be used the once.
+The smp_load_acquire() additionally forces the CPU to order against
+subsequent memory references.  Similarly, smp_store_release() is used
+in both algorithms to write the thread's index.  This documents the
+fact that we are writing to something that can be read concurrently,
+prevents the compiler from tearing the store, and enforces ordering
+against previous accesses.
 
 
 ===============
-- 
1.8.1.5

