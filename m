Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab3G0BXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 21:23:50 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55794 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab3G0BXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 21:23:46 -0400
Date: Fri, 26 Jul 2013 18:23:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>, curtw@google.com,
        Jens Axboe <jaxboe@fusionio.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH RFC fs] v2 Make sync() satisfy many requests with one
 invocation
Message-ID: <20130727012339.GA26694@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130726232852.GA15147@linux.vnet.ibm.com>
 <CA+55aFx_+hLT8Ze2Aihjow660vxyfnqCL9T+xQRw-mbmdA39xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx_+hLT8Ze2Aihjow660vxyfnqCL9T+xQRw-mbmdA39xA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072701-7182-0000-0000-000007E189E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 05:29:44PM -0700, Linus Torvalds wrote:
> On Fri, Jul 26, 2013 at 4:28 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > +
> > +       snap = ACCESS_ONCE(sync_seq);
> > +       smp_mb();  /* Prevent above from bleeding into critical section. */
> > +       mutex_lock(&sync_mutex);
> > +       snap_done = ACCESS_ONCE(sync_seq);
> > +       if (ULONG_CMP_GE(snap_done, ((snap + 1) & ~0x1) + 2)) {
> 
> Ugh. I dislike this RCU'ism. It's bad code. It doesn't just look ugly
> and complex, it's also not even clever.
> 
> It is possible that the compiler can fix up this horrible stuff and
> turn it into the nice clever stuff, but I dunno.
> 
> The two things that make me go "Eww":
> 
>  - "((snap + 1) & ~0x1) + 2" just isn't the smart way of doing things.
> Afaik, "(snap+3)&~1" gives the same answer with a simpler arithmetic.

You are right, this is a better approach, and I have changed this
patch to use it.

I will also apply it to the similar code in RCU.

>  - that ULONG_CMP_GE() macro is disgusting. What's wrong with doing it
> the sane way, which is how (for example) the time comparison functions
> do it (see time_before() and friends): Just do it
> 
>      ((long)(a-b) >= 0)
> 
>    which doesn't need large constants.

True, and I used to use this approach, but it can result in signed integer
overflow, which is undefined in C.  (Yes, we use -fno-strict-overflow,
but there might come a day when we don't want to.)  And ULONG_CMP_GE()
generated exactly the same code as ((long)(a-b) >= 0) last I tried it.

> And yeah, a smart compiler will hopefully do one or both of those, but
> what annoys me about the source code is that it actually isn't even
> any more readable despite being more complicated and needing more
> compiler tricks for good code generation.
> 
> So that one line is (a) totally undocumented, (b) not obvious and (c)
> not very clever.

For (a), how about I add the following comment?

	/*
	 * If the value in snap is odd, we need to wait for the current
	 * do_sync() to complete, then wait for the next one, in other
	 * words, we need the value of snap_done to be three larger than
	 * the value of snap.  On the other hand, if the value in snap is
	 * even, we only have to wait for the next request to complete,
	 * in other words, we need the value of snap_done to be only two
	 * greater than the value of snap.  The "(snap + 3) & 0x1" computes
	 * this for us.
	 */

Hopefully, this helps with (b).  For (c), I now use the expression
you suggested above.

Does that help, or is more needed.

> I'm also not a huge believer in those two WARN_ON_ONCE's you have. The
> sequence count is *only* updated in this place, it is *only* updated
> inside a lock, and dammit, if those tests ever trigger, we have bigger
> problems than that piece of code. Those warnings may make sense in
> code when you write it the first time (because you're thinking things
> through), but they do *not* make sense at the point where that code is
> actually committed to the project. I notice that you have those
> warnings in the RCU code itself, and I don't really think they make
> sense there either.

I agree that the fact that this variable is updated only in this one
place in sys_sync() makes these warning less than useful in production.
I will therefore remove them once this patch get beyond RFC status.

However, the similar warnings in RCU have been very helpful in spotting
bugs in the callers of rcu_idle_enter() and friends, so I would very
much prefer to keep them.

> Finally, the ACCESS_ONCE() is also only correct in the one place where
> you do the access speculatively outside the lock. Inside the lock,
> there is no excuse/reason for them, since the value is stable, and you
> need the memory barriers anyway, so there's no way the compiler could
> migrate things regardless. So the other two ACCESS_ONCE calls are
> actually misleading and wrong, and only likely to make the compiler
> generate much worse code.
> 
> In fact, the ACCESS_ONCE() is pretty much *guaranteed* to cause the
> compiler to unnecessarily generate worse code, since there is
> absolutely no reason why the compiler couldn't reuse the "snap_done"
> value it reads when it then does the "sync_seq++". There's no way the
> value could possible have changed from the "snap_done" value earlier,
> since we're inside the lock, so why force the compiler to reload it?

Good point, I have removed the second ACCESS_ONCE().

> In short, I think the code does too much. I'm sure it works, but I
> think it might make people believe that the extra work (like those
> later ACCESS_ONCE ones) is meaningful, when it isn't. It's just
> make-believe, afaik.
> 
> But maybe I'm missing something, and there actually *is* reason for
> the extra work/complexity?

Only for the ULONG_CMP_GE().  On the rest, you are quite right, and
the updated patch is as follows.  

But I will believe it works only if it helps Dave Jones's tests.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

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

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Curt Wohlgemuth <curtw@google.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-fsdevel@vger.kernel.org
[ paulmck: Updated based on Linus Torvalds feedback. ]

diff --git a/fs/sync.c b/fs/sync.c
index 905f3f6..174ad9b 100644
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
 
@@ -111,6 +111,60 @@ SYSCALL_DEFINE0(sync)
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
+	snap_done = sync_seq;
+
+	/*
+	 * If the value in snap is odd, we need to wait for the current
+	 * do_sync() to complete, then wait for the next one, in other
+	 * words, we need the value of snap_done to be three larger than
+	 * the value of snap.  On the other hand, if the value in snap is
+	 * even, we only have to wait for the next request to complete,
+	 * in other words, we need the value of snap_done to be only two
+	 * greater than the value of snap.  The "(snap + 3) & 0x1" computes
+	 * this for us (thank you, Linus!).
+	 */
+	if (ULONG_CMP_GE(snap_done, (snap + 3) & ~0x1)) {
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
 

