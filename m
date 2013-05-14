Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab3ENBZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:25:12 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33669 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3ENBTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:09 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 04/21] Generic percpu refcounting
Date: Mon, 13 May 2013 18:18:41 -0700
Message-Id: <1368494338-7069-5-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
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
 include/linux/percpu-refcount.h | 118 +++++++++++++++++++++++++++++++++
 lib/Makefile                    |   2 +-
 lib/percpu-refcount.c           | 140 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 259 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/percpu-refcount.h
 create mode 100644 lib/percpu-refcount.c

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
new file mode 100644
index 0000000..5bd35c7
--- /dev/null
+++ b/include/linux/percpu-refcount.h
@@ -0,0 +1,118 @@
+/*
+ * Dynamic percpu refcounts:
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
+struct percpu_ref {
+	atomic_t		count;
+	unsigned __percpu	*pcpu_count;
+};
+
+int percpu_ref_init(struct percpu_ref *ref);
+int percpu_ref_tryget(struct percpu_ref *ref);
+int percpu_ref_put_initial_ref(struct percpu_ref *ref);
+
+/**
+ * percpu_ref_get - increment a dynamic percpu refcount
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
+	if (pcpu_count)
+		__this_cpu_inc(*pcpu_count);
+	else
+		atomic_inc(&ref->count);
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
+	unsigned __percpu *pcpu_count;
+	int ret = 0;
+
+	preempt_disable();
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	if (pcpu_count)
+		__this_cpu_dec(*pcpu_count);
+	else
+		ret = atomic_dec_and_test(&ref->count);
+
+	preempt_enable();
+
+	return ret;
+}
+
+unsigned percpu_ref_count(struct percpu_ref *ref);
+int percpu_ref_kill(struct percpu_ref *ref);
+
+/**
+ * percpu_ref_dead - check if a dynamic percpu refcount is shutting down
+ *
+ * Returns true if percpu_ref_kill() has been called on @ref, false otherwise.
+ */
+static inline int percpu_ref_dead(struct percpu_ref *ref)
+{
+	return ref->pcpu_count == NULL;
+}
+
+#endif
diff --git a/lib/Makefile b/lib/Makefile
index e9c52e1..25a0ce1 100644
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
index 0000000..4a0155b
--- /dev/null
+++ b/lib/percpu-refcount.c
@@ -0,0 +1,140 @@
+#define pr_fmt(fmt) "%s: " fmt "\n", __func__
+
+#include <linux/kernel.h>
+#include <linux/percpu-refcount.h>
+
+/*
+ * The trick to implementing percpu refcounts is shutdown. We can't detect the
+ * ref hitting 0 on every put - this would require global synchronization and
+ * defeat the whole purpose of using percpu refs.
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
+#define PCPU_COUNT_BIAS		(1ULL << 31)
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
+	unsigned __percpu *pcpu_count;
+	unsigned count = 0;
+	int cpu;
+
+	preempt_disable();
+
+	count = atomic_read(&ref->count);
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	if (pcpu_count)
+		for_each_possible_cpu(cpu)
+			count += *per_cpu_ptr(pcpu_count, cpu);
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
+int percpu_ref_init(struct percpu_ref *ref)
+{
+	atomic_set(&ref->count, 1 + PCPU_COUNT_BIAS);
+
+	ref->pcpu_count = alloc_percpu(unsigned);
+	if (!ref->pcpu_count)
+		return -ENOMEM;
+
+	return 0;
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
+	unsigned __percpu *pcpu_count;
+	unsigned __percpu *old;
+	unsigned count = 0;
+	int cpu;
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	do {
+		if (!pcpu_count)
+			return 0;
+
+		old = pcpu_count;
+		pcpu_count = cmpxchg(&ref->pcpu_count, old, NULL);
+	} while (pcpu_count != old);
+
+	synchronize_sched();
+
+	for_each_possible_cpu(cpu)
+		count += *per_cpu_ptr(pcpu_count, cpu);
+
+	free_percpu(pcpu_count);
+
+	pr_debug("global %lli pcpu %i",
+		 (int64_t) atomic_read(&ref->count), (int) count);
+
+	atomic_add((int) count - PCPU_COUNT_BIAS, &ref->count);
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
+		WARN_ON(1);
+		return 0;
+	}
+}
-- 
1.8.2.1

