Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab3GZX3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:29:38 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42004 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760295Ab3GZX33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:29:29 -0400
Date: Fri, 26 Jul 2013 16:28:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: davej@redhat.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, hch@lst.de, jack@suse.cz, curtw@google.com,
        jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org
Subject: [PATCH RFC fs] v2 Make sync() satisfy many requests with one
 invocation
Message-ID: <20130726232852.GA15147@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072623-7408-0000-0000-0000125F39AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones reported RCU stalls, overly long hrtimer interrupts, and
amazingly long NMI handlers from a trinity-induced workload involving
lots of concurrent sync() calls (https://lkml.org/lkml/2013/7/23/369).
There are any number of things that one might do to make sync() behave
better under high levels of contention, but it is also the case that
multiple concurrent sync() system calls can be satisfied by a single
sys_sync() invocation.

Given that this situation is reminiscent of rcu_barrier(), this commit
applies the rcu_barrier() approach to sys_sync().  This approach uses
a global mutex and a sequence counter.  The mutex is held across the
sync() operation, which eliminates contention between concurrent sync()
operations.  The counter is incremented at the beginning and end of
each sync() operation, so that it is odd while a sync() operation is in
progress and even otherwise, just like sequence locks.

The code that used to be in sys_sync() is now in do_sync(), and sys_sync()
now handles the concurrency.  The sys_sync() function first takes a
snapshot of the counter, then acquires the mutex, and then takes another
snapshot of the counter.  If the values of the two snapshots indicate that
a full do_sync() executed during the mutex acquisition, the sys_sync()
function releases the mutex and returns ("Our work is done!").  Otherwise,
sys_sync() increments the counter, invokes do_sync(), and increments
the counter again.

This approach allows a single call to do_sync() to satisfy an arbitrarily
large number of sync() system calls, which should eliminate issues due
to large numbers of concurrent invocations of the sync() system call.

Changes since v1 (https://lkml.org/lkml/2013/7/24/683):

o	Add a pair of memory barriers to keep the increments from
	bleeding into the do_sync() code.  (The failure probability
	is insanely low, but when you have several hundred million
	devices running Linux, you can expect several hundred instances
	of one-in-a-million failures.)

o	Actually CC some people who have experience in this area.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Curt Wohlgemuth <curtw@google.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-fsdevel@vger.kernel.org

 b/fs/sync.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/fs/sync.c b/fs/sync.c
index 905f3f6..6e851db 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -99,7 +99,7 @@ static void fdatawait_one_bdev(struct block_device *bdev, void *arg)
  * just write metadata (such as inodes or bitmaps) to block device page cache
  * and do not sync it on their own in ->sync_fs().
  */
-SYSCALL_DEFINE0(sync)
+static void do_sync(void)
 {
 	int nowait = 0, wait = 1;
 
@@ -111,6 +111,49 @@ SYSCALL_DEFINE0(sync)
 	iterate_bdevs(fdatawait_one_bdev, NULL);
 	if (unlikely(laptop_mode))
 		laptop_sync_completion();
+	return;
+}
+
+static DEFINE_MUTEX(sync_mutex);	/* One do_sync() at a time. */
+static unsigned long sync_seq;		/* Many sync()s from one do_sync(). */
+					/*  Overflow harmless, extra wait. */
+
+/*
+ * Only allow one task to do sync() at a time, and further allow
+ * concurrent sync() calls to be satisfied by a single do_sync()
+ * invocation.
+ */
+SYSCALL_DEFINE0(sync)
+{
+	unsigned long snap;
+	unsigned long snap_done;
+
+	snap = ACCESS_ONCE(sync_seq);
+	smp_mb();  /* Prevent above from bleeding into critical section. */
+	mutex_lock(&sync_mutex);
+	snap_done = ACCESS_ONCE(sync_seq);
+	if (ULONG_CMP_GE(snap_done, ((snap + 1) & ~0x1) + 2)) {
+		/*
+		 * A full do_sync() executed between our two fetches from
+		 * sync_seq, so our work is done!
+		 */
+		smp_mb(); /* Order test with caller's subsequent code. */
+		mutex_unlock(&sync_mutex);
+		return 0;
+	}
+
+	/* Record the start of do_sync(). */
+	ACCESS_ONCE(sync_seq)++;
+	WARN_ON_ONCE((sync_seq & 0x1) != 1);
+	smp_mb(); /* Keep prior increment out of do_sync(). */
+
+	do_sync();
+
+	/* Record the end of do_sync(). */
+	smp_mb(); /* Keep subsequent increment out of do_sync(). */
+	ACCESS_ONCE(sync_seq)++;
+	WARN_ON_ONCE((sync_seq & 0x1) != 0);
+	mutex_unlock(&sync_mutex);
 	return 0;
 }
 

