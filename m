Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3KZBHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:07:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:43180 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab3KZBH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:07:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,771,1378882800"; 
   d="scan'208";a="433914106"
From: "Ma, Xindong" <xindong.ma@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "ccross@google.com" <ccross@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>
Subject: RE: Add memory barrier when waiting on futex
Thread-Topic: Add memory barrier when waiting on futex
Thread-Index: Ac7puzw8dEee+ztFRV6yZ2v5xXHPX///29EA//7QATA=
Date: Tue, 26 Nov 2013 01:07:25 +0000
Message-ID: <3917C05D9F83184EAA45CE249FF1B1DD0252FBF3@SHSMSX103.ccr.corp.intel.com>
References: <3917C05D9F83184EAA45CE249FF1B1DD0252FAEA@SHSMSX103.ccr.corp.intel.com>
 <20131125143952.GB10022@twins.programming.kicks-ass.net>
In-Reply-To: <20131125143952.GB10022@twins.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Monday, November 25, 2013 10:40 PM
> To: Ma, Xindong
> Cc: stable@vger.kernel.org; stable-commits@vger.kernel.org; Wysocki, Rafael J;
> ccross@google.com; tglx@linutronix.de; dvhart@linux.intel.com;
> mingo@kernel.org; linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org;
> Tu, Xiaobing
> Subject: Re: Add memory barrier when waiting on futex
> 
> On Mon, Nov 25, 2013 at 01:15:17PM +0000, Ma, Xindong wrote:
> > We encountered following panic several times:
> 
> > [   74.671982] BUG: unable to handle kernel NULL pointer dereference at
> 00000008
> > [   74.672101] IP: [<c129bb27>] wake_futex+0x47/0x80
> 
> > [   74.674144]  [<c129bc29>] futex_wake+0xc9/0x110
> > [   74.674195]  [<c129da0b>] do_futex+0xeb/0x950
> > [   74.674484]  [<c129e30b>] SyS_futex+0x9b/0x140
> > [   74.674582]  [<c195a718>] syscall_call+0x7/0xb
> >
> > On smp systems, setting current task to q->task in queue_me() may not
> > visible immediately to another cpu, some times this will cause panic
> > in wake_futex(). Adding memory barrier to avoid this.
> >
> > Signed-off-by: Leon Ma <xindong.ma@intel.com>
> > Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
> > ---
> >  kernel/futex.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/kernel/futex.c b/kernel/futex.c index 80ba086..792cd41
> > 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -1529,6 +1529,7 @@ static inline void queue_me(struct futex_q *q,
> struct futex_hash_bucket *hb)
> >  	plist_node_init(&q->list, prio);
> >  	plist_add(&q->list, &hb->chain);
> >  	q->task = current;
> > +	smp_mb();
> >  	spin_unlock(&hb->lock);
> >  }
> 
> This is wrong, because an uncommented barrier is wrong per definition.
> 
> This is further wrong because wake_futex() is always called with
> hb->lock held, and since queue_me also has hb->lock held, this is in
> fact guaranteed.
> 
> This is even more wrong for adding stable.

Sorry for sending to stable tree.

I've already aware that they've protected by spinlock, this is why I adding a memory barrier to fix it.

I reproduced this issue several times on android which running on IA dual core.
I reproduced with following stress test case running at the same time:
a). glbenchmark 2.7
b). while true; do date; adb wait-for-device; adb shell busybox dd of=/data/tt.txt if=/dev/zero bs=350M count=1; done

To troubleshoot this issue, I constructed following debug patch to see what's the problem:
diff --git a/kernel/futex.c b/kernel/futex.c
index 8996c97..dce00a3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -830,10 +830,17 @@ retry:
 static void __unqueue_futex(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
-
+#if 0
 	if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))
 	    || WARN_ON(plist_node_empty(&q->list)))
 		return;
+#endif
+	if (WARN(!q->lock_ptr, "LEON, lock_ptr null"))
+		return;
+	if (WARN(!spin_is_locked(q->lock_ptr), "LEON, lock_ptr not locked"))
+		return;
+	if (WARN(plist_node_empty(&q->list), "LEON, plist_node_empty"))
+		return;
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
 	plist_del(&q->list, &hb->chain);
@@ -868,7 +875,7 @@ static void wake_futex(struct futex_q *q)
 	 */
 	smp_wmb();
 	q->lock_ptr = NULL;
-
+	trace_printk("waking up:%d..\n", p->pid);
 	wake_up_state(p, TASK_NORMAL);
 	put_task_struct(p);
 }
@@ -980,6 +987,7 @@ double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 /*
  * Wake up waiters matching bitset queued on this futex (uaddr).
  */
+#include <linux/delay.h>
 static int
 futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 {
@@ -987,7 +995,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	struct futex_q *this, *next;
 	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
-	int ret;
+	int ret, should_p = 0;
 
 	if (!bitset)
 		return -EINVAL;
@@ -1010,8 +1018,20 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 			/* Check if one of the bits is set in both bitsets */
 			if (!(this->bitset & bitset))
 				continue;
+			if(this->task)
+				trace_printk("LEON, wake xx, addr:%p, pid:%d\n", uaddr, this->task->pid);
+			else {
+				trace_printk("LEON, wake xx, addr:%p, NULL task\n", uaddr);
+				printk("LEON, wake xx, addr:%p,C%d, NULL task\n", uaddr, smp_processor_id());
+				should_p = 1;
+				for (should_p = 0; should_p < 3; should_p++) {
+					trace_printk("LEON, task:%p\n", this->task);
+					udelay(50);
+				}
+			}
 
 			wake_futex(this);
+			if (should_p) BUG();
 			if (++ret >= nr_wake)
 				break;
 		}
@@ -1528,6 +1548,7 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 
 	plist_node_init(&q->list, prio);
 	plist_add(&q->list, &hb->chain);
+	trace_printk("LEON, q->task => %d\n", current->pid);
 	q->task = current;
 	smp_mb();
 	spin_unlock(&hb->lock);
@@ -1923,7 +1944,7 @@ retry:
 	ret = futex_wait_setup(uaddr, val, flags, &q, &hb);
 	if (ret)
 		goto out;
-
+	trace_printk("LEON, wait ==, addr:%p, pid:%d\n", uaddr, current->pid);
 	/* queue_me and wait for wakeup, timeout, or a signal. */
 	futex_wait_queue_me(hb, &q, to);

I dumped ftrace logs to pstore when panic and got this log:
[ 1038.694685] SharedPr-11272   0.N.1 1035007214873: wake_futex: waking up:11202..
[ 1038.694701] putmetho-11202   1...1 1035007289001: futex_wait: LEON, wait ==, addr:41300384, pid:11202
[ 1038.694716] putmetho-11202   1...1 1035007308860: futex_wait_queue_me: LEON, q->task => 11202
[ 1038.694731] SharedPr-11272   0...1 1035007319703: futex_wake: LEON, wake xx, addr:41300384, NULL task
[ 1038.694746] SharedPr-11272   0.N.1 1035007344036: futex_wake: LEON, task:d6519640
[ 1038.694761] SharedPr-11272   0.N.1 1035007395161: futex_wake: LEON, task:d6519640
[ 1038.694777] SharedPr-11272   0.N.1 1035007445858: futex_wake: LEON, task:d6519640
[ 1038.694792] SharedPr-11272   0.N.1 1035007497555: wake_futex: waking up:11202..

>From the log captured, task 11202 runs on cpu1 and wait on futex and set task to its pid in queue_me(). Then
task 11272 get scheduled on cpu0, it tries to wake up 11202. But the q->task set by cpu1 is not visible at first to
cpu0, after several instructions, it's visible to cpu0 again. So this is the problem maybe in cache or instruction out
of order. After adding memory barrier, the issue does not reproduced anymore.

Besides, I found another similar issue in mutex code. If you confirm this is the problem, I will submit another patch
to fix mutex issue.
