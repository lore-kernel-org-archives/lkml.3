Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab3EaW1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:27:18 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34366 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab3EaW1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:27:07 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Generic percpu refcounting
Date: Fri, 31 May 2013 15:26:45 -0700
Message-Id: <1370039205-14071-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a refcount with similar semantics to
atomic_get()/atomic_dec_and_test() - but percpu.

It also implements two stage shutdown, as we need it to tear down the
percpu counts.  Before dropping the initial refcount, you must call
percpu_ref_kill(); this puts the refcount in "shutting down mode" and
switches back to a single atomic refcount with the appropriate barriers
(synchronize_rcu()).

It's also legal to call percpu_ref_kill() multiple times - it only returns
true once, so callers don't have to reimplement shutdown synchronization.

[akpm@linux-foundation.org: fix build]
[akpm@linux-foundation.org: coding-style tweak]
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/percpu-refcount.h | 122 ++++++++++++++++++++++++++++++++++++++
 lib/Makefile                    |   2 +-
 lib/percpu-refcount.c           | 128 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 251 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/percpu-refcount.h
 create mode 100644 lib/percpu-refcount.c

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
new file mode 100644
index 0000000..24b31ef
--- /dev/null
+++ b/include/linux/percpu-refcount.h
@@ -0,0 +1,122 @@
+/*
+ * Percpu refcounts:
+ * (C) 2012 Google, Inc.
+ * Author: Kent Overstreet <koverstreet@google.com>
+ *
+ * This implements a refcount with similar semantics to atomic_t - atomic_inc(),
+ * atomic_dec_and_test() - but percpu.
+ *
+ * There's one important difference between percpu refs and normal atomic_t
+ * refcounts; you have to keep track of your initial refcount, and then when you
+ * start shutting down you call percpu_ref_kill() _before_ dropping the initial
+ * refcount.
+ *
+ * The refcount will have a range of 0 to ((1U << 31) - 1), i.e. one bit less
+ * than an atomic_t - this is because of the way shutdown works, see
+ * percpu_ref_kill()/PCPU_COUNT_BIAS.
+ *
+ * Before you call percpu_ref_kill(), percpu_ref_put() does not check for the
+ * refcount hitting 0 - it can't, if it was in percpu mode. percpu_ref_kill()
+ * puts the ref back in single atomic_t mode, collecting the per cpu refs and
+ * issuing the appropriate barriers, and then marks the ref as shutting down so
+ * that percpu_ref_put() will check for the ref hitting 0.  After it returns,
+ * it's safe to drop the initial ref.
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
+struct percpu_ref;
+typedef void (percpu_ref_release)(struct percpu_ref *);
+
+struct percpu_ref {
+	atomic_t		count;
+	/*
+	 * The low bit of the pointer indicates whether the ref is in percpu
+	 * mode; if set, then get/put will manipulate the atomic_t (this is a
+	 * hack because we need to keep the pointer around for
+	 * percpu_ref_kill_rcu())
+	 */
+	unsigned __percpu	*pcpu_count;
+	percpu_ref_release	*release;
+	struct rcu_head		rcu;
+};
+
+int percpu_ref_init(struct percpu_ref *, percpu_ref_release *);
+void percpu_ref_kill(struct percpu_ref *ref);
+
+#define PCPU_STATUS_BITS	2
+#define PCPU_STATUS_MASK	((1 << PCPU_STATUS_BITS) - 1)
+#define PCPU_REF_PTR		0
+#define PCPU_REF_DEAD		1
+
+#define REF_STATUS(count)	(((unsigned long) count) & PCPU_STATUS_MASK)
+
+/**
+ * percpu_ref_get - increment a percpu refcount
+ *
+ * Analagous to atomic_inc().
+  */
+static inline void percpu_ref_get(struct percpu_ref *ref)
+{
+	unsigned __percpu *pcpu_count;
+
+	preempt_disable();
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
+		__this_cpu_inc(*pcpu_count);
+	else
+		atomic_inc(&ref->count);
+
+	preempt_enable();
+}
+
+/**
+ * percpu_ref_put - decrement a percpu refcount
+ *
+ * Decrement the refcount, and if 0, call the release function (which was passed
+ * to percpu_ref_init())
+ */
+static inline void percpu_ref_put(struct percpu_ref *ref)
+{
+	unsigned __percpu *pcpu_count;
+
+	preempt_disable();
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
+		__this_cpu_dec(*pcpu_count);
+	else if (unlikely(atomic_dec_and_test(&ref->count)))
+		ref->release(ref);
+
+	preempt_enable();
+}
+
+#endif
diff --git a/lib/Makefile b/lib/Makefile
index c55a037..386db4b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o
+	 earlycpio.o percpu-refcount.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
new file mode 100644
index 0000000..6f0ffd7
--- /dev/null
+++ b/lib/percpu-refcount.c
@@ -0,0 +1,128 @@
+#define pr_fmt(fmt) "%s: " fmt "\n", __func__
+
+#include <linux/kernel.h>
+#include <linux/percpu-refcount.h>
+
+/*
+ * Initially, a percpu refcount is just a set of percpu counters. Initially, we
+ * don't try to detect the ref hitting 0 - which means that get/put can just
+ * increment or decrement the local counter. Note that the counter on a
+ * particular cpu can (and will) wrap - this is fine, when we go to shutdown the
+ * percpu counters will all sum to the correct value
+ *
+ * (More precisely: because moduler arithmatic is commutative the sum of all the
+ * pcpu_count vars will be equal to what it would have been if all the gets and
+ * puts were done to a single integer, even if some of the percpu integers
+ * overflow or underflow).
+ *
+ * The real trick to implementing percpu refcounts is shutdown. We can't detect
+ * the ref hitting 0 on every put - this would require global synchronization
+ * and defeat the whole purpose of using percpu refs.
+ *
+ * What we do is require the user to keep track of the initial refcount; we know
+ * the ref can't hit 0 before the user drops the initial ref, so as long as we
+ * convert to non percpu mode before the initial ref is dropped everything
+ * works.
+ *
+ * Converting to non percpu mode is done with some RCUish stuff in
+ * percpu_ref_kill. Additionally, we need a bias value so that the atomic_t
+ * can't hit 0 before we've added up all the percpu refs.
+ */
+
+#define PCPU_COUNT_BIAS		(1U << 31)
+
+/**
+ * percpu_ref_init - initialize a percpu refcount
+ * @ref:	ref to initialize
+ * @release:	function which will be called when refcount hits 0
+ *
+ * Initializes the refcount in single atomic counter mode with a refcount of 1;
+ * analagous to atomic_set(ref, 1).
+ *
+ * Note that @release must not sleep - it may potentially be called from RCU
+ * callback context by percpu_ref_kill().
+ */
+int percpu_ref_init(struct percpu_ref *ref, percpu_ref_release *release)
+{
+	atomic_set(&ref->count, 1 + PCPU_COUNT_BIAS);
+
+	ref->pcpu_count = alloc_percpu(unsigned);
+	if (!ref->pcpu_count)
+		return -ENOMEM;
+
+	ref->release = release;
+	return 0;
+}
+
+static void percpu_ref_kill_rcu(struct rcu_head *rcu)
+{
+	struct percpu_ref *ref = container_of(rcu, struct percpu_ref, rcu);
+	unsigned __percpu *pcpu_count;
+	unsigned count = 0;
+	int cpu;
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	/* Mask out PCPU_REF_DEAD */
+	pcpu_count = (unsigned __percpu *)
+		(((unsigned long) pcpu_count) & ~PCPU_STATUS_MASK);
+
+	for_each_possible_cpu(cpu)
+		count += *per_cpu_ptr(pcpu_count, cpu);
+
+	free_percpu(pcpu_count);
+
+	pr_debug("global %i pcpu %i", atomic_read(&ref->count), (int) count);
+
+	/*
+	 * It's crucial that we sum the percpu counters _before_ adding the sum
+	 * to &ref->count; since gets could be happening on one cpu while puts
+	 * happen on another, adding a single cpu's count could cause
+	 * @ref->count to hit 0 before we've got a consistent value - but the
+	 * sum of all the counts will be consistent and correct.
+	 *
+	 * Subtracting the bias value then has to happen _after_ adding count to
+	 * &ref->count; we need the bias value to prevent &ref->count from
+	 * reaching 0 before we add the percpu counts. But doing it at the same
+	 * time is equivalent and saves us atomic operations:
+	 */
+
+	atomic_add((int) count - PCPU_COUNT_BIAS, &ref->count);
+
+	/*
+	 * Now we're in single atomic_t mode with a consistent refcount, so it's
+	 * safe to drop our initial ref:
+	 */
+	percpu_ref_put(ref);
+}
+
+/**
+ * percpu_ref_kill - safely drop initial ref
+ *
+ * Must be used to drop the initial ref on a percpu refcount; must be called
+ * precisely once before shutdown.
+ *
+ * Puts @ref in non percpu mode, then does a call_rcu() before gathering up the
+ * percpu counters and dropping the initial ref.
+ */
+void percpu_ref_kill(struct percpu_ref *ref)
+{
+	unsigned __percpu *pcpu_count, *old, *new;
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	do {
+		if (REF_STATUS(pcpu_count) == PCPU_REF_DEAD) {
+			WARN(1, "percpu_ref_kill() called more than once!\n");
+			return;
+		}
+
+		old = pcpu_count;
+		new = (unsigned __percpu *)
+			(((unsigned long) pcpu_count)|PCPU_REF_DEAD);
+
+		pcpu_count = cmpxchg(&ref->pcpu_count, old, new);
+	} while (pcpu_count != old);
+
+	call_rcu(&ref->rcu, percpu_ref_kill_rcu);
+}
-- 
1.8.2.1

