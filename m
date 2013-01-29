Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3A2Qju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:39:50 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:48232 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3A2Qjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:39:46 -0500
Date: Tue, 29 Jan 2013 08:39:42 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130129163942.GI26407@google.com>
References: <20130128184933.GC26407@google.com>
 <20130128185552.GD22465@mtj.dyndns.org>
 <20130128202214.GD26407@google.com>
 <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
 <20130128205540.GE26407@google.com>
 <20130128211832.GK22465@mtj.dyndns.org>
 <20130128212407.GF26407@google.com>
 <20130128212814.GL22465@mtj.dyndns.org>
 <20130128214506.GG26407@google.com>
 <20130128215042.GN22465@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128215042.GN22465@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 01:50:42PM -0800, Tejun Heo wrote:
> Hello, Kent.
> 
> On Mon, Jan 28, 2013 at 01:45:06PM -0800, Kent Overstreet wrote:
> > Ahh. Bias value sounds... hacky (i.e. harder to convince myself it's
> > correct) but I see what you're getting at.
> 
> I don't think it's that hacky.  Just push the base point to the
> opposite of zero - LLONG_MAX.  The global counter can start biased so
> that it gets unbiased only once dying is confirmed and everything can
> blindly do atomic64_dec_and_test() and trust the result.

Didn't mean objectively hacky, just my first impression having a clear
model for how my first version works. I think I've come around - I coded
it up last night and it seems to work.

> > Something to consider is wrapping; after we set state to dying but
> > before we've collected the percpu counters, the atomic counter may be
> > negative.
> 
> There's a reason why we use 64bit vars for this type of global
> counting.  They virtually don't wrap.  Here, you'll need 1<<63 for the
> counter to unintentionally reach 0, which we consider practically
> impossible.

It's not the 64 bit counters themselves that mean you don't have to
consider underflow (which was what I meant, not wrapping), it's the bias
value (though I'm not sure that's the best way to think about it... eh,
quibbling with semantics).

Also the bias value is just stealing one bit from the range of the
counter, and I'm implementing a 32 bit refcount, not 64 (since I'm
stealing some of the high bits of the atomic64_t for the get counter...
though I could still use uint64_t for the percpu counters and implement
a 50 bit refcount).

Oh, if this is going to be widely used I should probably have a
different implementation for archs that don't have atomic64_t in
hardware. Don't suppose you know the CONFIG_ macro to test against? I
couldn't find it when I was looking recently.

Started screwing around with converting the module refcount, too. Looks
like the end result will be cleaner and simpler, though there's some
tricky bits of the conversion due to the weird semantics of module
refcounts.

Anyways, here's the new version:

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
new file mode 100644
index 0000000..9e14a09
--- /dev/null
+++ b/include/linux/percpu-refcount.h
@@ -0,0 +1,153 @@
+/*
+ * Dynamic percpu refcounts:
+ * (C) 2012 Google, Inc.
+ * Author: Kent Overstreet <koverstreet@google.com>
+ *
+ * This implements a refcount with similar semantics to atomic_t - atomic_inc(),
+ * atomic_dec_and_test() - but potentially percpu.
+ *
+ * There's one important difference between percpu refs and normal atomic_t
+ * refcounts; you have to keep track of your initial refcount, and then when you
+ * start shutting down you call percpu_ref_kill() _before_ dropping the initial
+ * refcount.
+ *
+ * Before you call percpu_ref_kill(), percpu_ref_put() does not check for the
+ * refcount hitting 0 - it can't, if it was in percpu mode. percpu_ref_kill()
+ * puts the ref back in single atomic_t mode, collecting the per cpu refs and
+ * issuing the appropriate barriers, and then marks the ref as shutting down so
+ * that percpu_ref_put() will check for the ref hitting 0.  After it returns,
+ * it's safe to drop the initial ref.
+ *
+ * BACKGROUND:
+ *
+ * Percpu refcounts are quite useful for performance, but if we blindly
+ * converted all refcounts to percpu counters we'd waste quite a bit of memory.
+ *
+ * Think about all the refcounts embedded in kobjects, files, etc. most of which
+ * aren't used much. These start out as simple atomic counters - a little bigger
+ * than a bare atomic_t, 16 bytes instead of 4 - but if we exceed some arbitrary
+ * number of gets in one second, we then switch to percpu counters.
+ *
+ * This heuristic isn't perfect because it'll fire if the refcount was only
+ * being used on one cpu; ideally we'd be able to count the number of cache
+ * misses on percpu_ref_get() or something similar, but that'd make the non
+ * percpu path significantly heavier/more complex. We can count the number of
+ * gets() without any extra atomic instructions on arches that support
+ * atomic64_t - simply by changing the atomic_inc() to atomic_add_return().
+ *
+ * USAGE:
+ *
+ * See fs/aio.c for some example usage; it's used there for struct kioctx, which
+ * is created when userspaces calls io_setup(), and destroyed when userspace
+ * calls io_destroy() or the process exits.
+ *
+ * In the aio code, kill_ioctx() is called when we wish to destroy a kioctx; it
+ * calls percpu_ref_kill(), then hlist_del_rcu() and sychronize_rcu() to remove
+ * the kioctx from the proccess's list of kioctxs - after that, there can't be
+ * any new users of the kioctx (from lookup_ioctx()) and it's then safe to drop
+ * the initial ref with percpu_ref_put().
+ *
+ * Code that does a two stage shutdown like this often needs some kind of
+ * explicit synchronization to ensure the initial refcount can only be dropped
+ * once - percpu_ref_kill() does this for you, it returns true once and false if
+ * someone else already called it. The aio code uses it this way, but it's not
+ * necessary if the code has some other mechanism to synchronize teardown.
+ *
+ * As mentioned previously, we decide when to convert a ref to percpu counters
+ * in percpu_ref_get(). However, since percpu_ref_get() will often be called
+ * with rcu_read_lock() held, it's not done there - percpu_ref_get() returns
+ * true if the ref should be converted to percpu counters.
+ *
+ * The caller should then call percpu_ref_alloc() after dropping
+ * rcu_read_lock(); if there is an uncommonly used codepath where it's
+ * inconvenient to call percpu_ref_alloc() after get(), it may be safely skipped
+ * and percpu_ref_get() will return true again the next time the counter wraps
+ * around.
+ */
+
+#ifndef _LINUX_PERCPU_REFCOUNT_H
+#define _LINUX_PERCPU_REFCOUNT_H
+
+#include <linux/atomic.h>
+#include <linux/kernel.h>
+#include <linux/percpu.h>
+#include <linux/rcupdate.h>
+
+struct percpu_ref {
+	atomic64_t		count;
+	unsigned long		pcpu_count;
+};
+
+void percpu_ref_init(struct percpu_ref *ref);
+void __percpu_ref_get(struct percpu_ref *ref, unsigned long pcpu_count);
+int __percpu_ref_put(struct percpu_ref *ref, unsigned long pcpu_count);
+int percpu_ref_tryget(struct percpu_ref *ref);
+int percpu_ref_put_initial_ref(struct percpu_ref *ref);
+
+#define PCPU_STATUS_BITS	2
+#define PCPU_STATUS_MASK	((1 << PCPU_STATUS_BITS) - 1)
+
+#define PCPU_REF_PTR		0
+#define PCPU_REF_NONE		1
+#define PCPU_REF_DEAD		2
+
+#define REF_STATUS(count)	(count & PCPU_STATUS_MASK)
+
+/**
+ * percpu_ref_get - increment a dynamic percpu refcount
+ *
+ * Analagous to atomic_inc().
+  */
+static inline void percpu_ref_get(struct percpu_ref *ref)
+{
+	unsigned long pcpu_count;
+
+	preempt_disable();
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
+		/* for rcu - we're not using rcu_dereference() */
+		smp_read_barrier_depends();
+		__this_cpu_inc(*((unsigned __percpu *) pcpu_count));
+	} else {
+		__percpu_ref_get(ref, pcpu_count);
+	}
+
+	preempt_enable();
+}
+
+/**
+ * percpu_ref_put - decrement a dynamic percpu refcount
+ *
+ * Returns true if the result is 0, otherwise false; only checks for the ref
+ * hitting 0 after percpu_ref_kill() has been called. Analagous to
+ * atomic_dec_and_test().
+ */
+static inline int percpu_ref_put(struct percpu_ref *ref)
+{
+	unsigned long pcpu_count;
+	int ret = 0;
+
+	preempt_disable();
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
+		/* for rcu - we're not using rcu_dereference() */
+		smp_read_barrier_depends();
+		__this_cpu_dec(*((unsigned __percpu *) pcpu_count));
+	} else {
+		ret = __percpu_ref_put(ref, pcpu_count);
+	}
+
+	preempt_enable();
+
+	return ret;
+}
+
+unsigned percpu_ref_count(struct percpu_ref *ref);
+int percpu_ref_kill(struct percpu_ref *ref);
+int percpu_ref_dead(struct percpu_ref *ref);
+
+#endif
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
new file mode 100644
index 0000000..bf71d54
--- /dev/null
+++ b/lib/percpu-refcount.c
@@ -0,0 +1,280 @@
+#define pr_fmt(fmt) "%s: " fmt "\n", __func__
+
+#include <linux/jiffies.h>
+#include <linux/percpu-refcount.h>
+
+/*
+ * A percpu refcount can be in 4 different modes. The state is tracked in the
+ * low two bits of percpu_ref->pcpu_count:
+ *
+ * PCPU_REF_NONE - the initial state, no percpu counters allocated.
+ *
+ * PCPU_REF_PTR - using percpu counters for the refcount.
+ *
+ * PCPU_REF_DYING - we're shutting down so get()/put() should use the embedded
+ * atomic counter, but we're not finished updating the atomic counter from the
+ * percpu counters - this means that percpu_ref_put() can't check for the ref
+ * hitting 0 yet.
+ *
+ * PCPU_REF_DEAD - we've finished the teardown sequence, percpu_ref_put() should
+ * now check for the ref hitting 0.
+ *
+ * In PCPU_REF_NONE mode, we need to count the number of times percpu_ref_get()
+ * is called; this is done with the high bits of the raw atomic counter. We also
+ * track the time, in jiffies, when the get count last wrapped - this is done
+ * with the remaining bits of percpu_ref->percpu_count.
+ *
+ * So, when percpu_ref_get() is called it increments the get count and checks if
+ * it wrapped; if it did, it checks if the last time it wrapped was less than
+ * one second ago; if so, we want to allocate percpu counters.
+ *
+ * PCPU_COUNT_BITS determines the threshold where we convert to percpu: of the
+ * raw 64 bit counter, we use PCPU_COUNT_BITS for the refcount, and the
+ * remaining (high) bits to count the number of times percpu_ref_get() has been
+ * called. It's currently (completely arbitrarily) 16384 times in one second.
+ *
+ * Percpu mode (PCPU_REF_PTR):
+ *
+ * In percpu mode all we do on get and put is increment or decrement the cpu
+ * local counter, which is a 32 bit unsigned int.
+ *
+ * Note that all the gets() could be happening on one cpu, and all the puts() on
+ * another - the individual cpu counters can wrap (potentially many times).
+ *
+ * But this is fine because we don't need to check for the ref hitting 0 in
+ * percpu mode; before we set the state to PCPU_REF_DEAD we simply sum up all
+ * the percpu counters and add them to the atomic counter. Since addition and
+ * subtraction in modular arithmatic is still associative, the result will be
+ * correct.
+ */
+
+#define PCPU_COUNT_BITS		50
+#define PCPU_COUNT_MASK		((1LL << PCPU_COUNT_BITS) - 1)
+
+#define PCPU_COUNT_BIAS		(1ULL << 32)
+
+/*
+ * So that we don't have to call alloc_percu() from percpu_ref_get(), we use a
+ * small pool and refill from a workqueue.
+ */
+
+#define PCPU_REF_ALLOC_NR	8
+
+static unsigned __percpu *percpu_ref_pool[PCPU_REF_ALLOC_NR];
+static unsigned percpu_ref_alloc_nr;
+static DEFINE_SPINLOCK(percpu_ref_alloc_lock);
+
+static void percpu_ref_alloc_refill(struct work_struct *work)
+{
+	spin_lock_irq(&percpu_ref_alloc_lock);
+
+	while (percpu_ref_alloc_nr < PCPU_REF_ALLOC_NR) {
+		unsigned __percpu *ref;
+
+		ref = alloc_percpu(unsigned);
+		if (!ref)
+			break;
+
+		percpu_ref_pool[percpu_ref_alloc_nr++] = ref;
+	}
+
+	spin_unlock_irq(&percpu_ref_alloc_lock);
+}
+
+static DECLARE_WORK(percpu_ref_alloc_work, percpu_ref_alloc_refill);
+
+static void percpu_ref_alloc(struct percpu_ref *ref, unsigned long pcpu_count)
+{
+	unsigned long flags, now = jiffies;
+	static unsigned __percpu *new = NULL;
+
+	now <<= PCPU_STATUS_BITS;
+	now |= PCPU_REF_NONE;
+
+	if (now - pcpu_count <= HZ << PCPU_STATUS_BITS) {
+		spin_lock_irqsave(&percpu_ref_alloc_lock, flags);
+
+		if (percpu_ref_alloc_nr)
+			new = percpu_ref_pool[--percpu_ref_alloc_nr];
+
+		if (percpu_ref_alloc_nr < PCPU_REF_ALLOC_NR / 2)
+			schedule_work(&percpu_ref_alloc_work);
+
+		spin_unlock_irqrestore(&percpu_ref_alloc_lock, flags);
+
+		if (!new)
+			goto update_time;
+
+		BUG_ON((unsigned long) new & PCPU_STATUS_MASK);
+
+		if (cmpxchg(&ref->pcpu_count, pcpu_count,
+			    (unsigned long) new) != pcpu_count)
+			free_percpu(new);
+	} else {
+update_time:
+		cmpxchg(&ref->pcpu_count, pcpu_count, now);
+	}
+}
+
+/* Slowpath, i.e. non percpu */
+void __percpu_ref_get(struct percpu_ref *ref, unsigned long pcpu_count)
+{
+	uint64_t v;
+
+	v = atomic64_add_return(1 + (1ULL << PCPU_COUNT_BITS),
+				&ref->count);
+
+	if (unlikely(!(v >> PCPU_COUNT_BITS) &&
+		     REF_STATUS(pcpu_count) == PCPU_REF_NONE)) {
+		percpu_ref_alloc(ref, pcpu_count);
+	}
+}
+
+int __percpu_ref_put(struct percpu_ref *ref, unsigned long pcpu_count)
+{
+	uint64_t v;
+
+	v = atomic64_dec_return(&ref->count);
+	v &= PCPU_COUNT_MASK;
+
+	return v == 0;
+}
+
+int percpu_ref_tryget(struct percpu_ref *ref)
+{
+	int ret = 1;
+
+	preempt_disable();
+
+	if (!percpu_ref_dead(ref))
+		percpu_ref_get(ref);
+	else
+		ret = 0;
+
+	preempt_enable();
+
+	return ret;
+}
+
+unsigned percpu_ref_count(struct percpu_ref *ref)
+{
+	unsigned long pcpu_count;
+	unsigned count = 0;
+	int cpu;
+
+	preempt_disable();
+
+	count = atomic64_read(&ref->count) & PCPU_COUNT_MASK;
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
+		/* for rcu - we're not using rcu_dereference() */
+		smp_read_barrier_depends();
+
+		for_each_possible_cpu(cpu)
+			count += *per_cpu_ptr((unsigned __percpu *) pcpu_count, cpu);
+	}
+
+	preempt_enable();
+
+	return count;
+}
+
+/**
+ * percpu_ref_init - initialize a dynamic percpu refcount
+ *
+ * Initializes the refcount in single atomic counter mode with a refcount of 1;
+ * analagous to atomic_set(ref, 1).
+ */
+void percpu_ref_init(struct percpu_ref *ref)
+{
+	unsigned long now = jiffies;
+
+	atomic64_set(&ref->count, 1 + PCPU_COUNT_BIAS);
+
+	now <<= PCPU_STATUS_BITS;
+	now |= PCPU_REF_NONE;
+
+	ref->pcpu_count = now;
+}
+
+/**
+ * percpu_ref_kill - prepare a dynamic percpu refcount for teardown
+ *
+ * Must be called before dropping the initial ref, so that percpu_ref_put()
+ * knows to check for the refcount hitting 0. If the refcount was in percpu
+ * mode, converts it back to single atomic counter mode.
+ *
+ * The caller must issue a synchronize_rcu()/call_rcu() before calling
+ * percpu_ref_put() to drop the initial ref.
+ *
+ * Returns true the first time called on @ref and false if @ref is already
+ * shutting down, so it may be used by the caller for synchronizing other parts
+ * of a two stage shutdown.
+ */
+int percpu_ref_kill(struct percpu_ref *ref)
+{
+	unsigned long old, status, pcpu_count;
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	do {
+		status = REF_STATUS(pcpu_count);
+
+		if (status == PCPU_REF_DEAD)
+			return 0;
+
+		old = pcpu_count;
+		pcpu_count = cmpxchg(&ref->pcpu_count, old, PCPU_REF_DEAD);
+	} while (pcpu_count != old);
+
+	if (status == PCPU_REF_PTR) {
+		int cpu;
+		unsigned count = 0;
+
+		synchronize_sched();
+
+		for_each_possible_cpu(cpu)
+			count += *per_cpu_ptr((unsigned __percpu *) pcpu_count, cpu);
+
+		free_percpu((unsigned __percpu *) pcpu_count);
+
+		pr_debug("global %lli pcpu %i",
+			 atomic64_read(&ref->count) & PCPU_COUNT_MASK,
+			 (int) count);
+
+		atomic64_add((int) count - PCPU_COUNT_BIAS, &ref->count);
+	}
+
+	return 1;
+}
+
+/**
+ * percpu_ref_put_initial_ref - safely drop the initial ref
+ *
+ * A percpu refcount needs a shutdown sequence before dropping the initial ref,
+ * to put it back into single atomic_t mode with the appropriate barriers so
+ * that percpu_ref_put() can safely check for it hitting 0 - this does so.
+ *
+ * Returns true if @ref hit 0.
+ */
+int percpu_ref_put_initial_ref(struct percpu_ref *ref)
+{
+	if (percpu_ref_kill(ref)) {
+		return percpu_ref_put(ref);
+	} else {
+		__WARN();
+		return 0;
+	}
+}
+
+/**
+ * percpu_ref_dead - check if a dynamic percpu refcount is shutting down
+ *
+ * Returns true if percpu_ref_kill() has been called on @ref, false otherwise.
+ */
+int percpu_ref_dead(struct percpu_ref *ref)
+{
+	return REF_STATUS(ref->pcpu_count) == PCPU_REF_DEAD;
+}
