Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab3FNPAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:00:32 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:48678 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3FNPAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:00:31 -0400
Message-ID: <51BB2FFC.8060209@hp.com>
Date: Fri, 14 Jun 2013 11:00:12 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, ????????? <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
References: <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net> <1370974231.9844.212.camel@gandalf.local.home> <1371059401.1746.33.camel@buesod1.americas.hpqcorp.net> <CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com> <1371067399.1746.47.camel@buesod1.americas.hpqcorp.net> <CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com> <20130612233224.GH4165@ZenIV.linux.org.uk> <CA+55aFw2=3ua32vkpWc_9ckCNweFmmH3c0d-VqoaUD86rkR-=w@mail.gmail.com> <20130613002058.GI4165@ZenIV.linux.org.uk> <CA+55aFxEnNvj1SoOL+ChVQqK+ouSNgsM+6cQt+=PpmTGdcFggg@mail.gmail.com> <20130613004941.GJ4165@ZenIV.linux.org.uk> <CA+55aFz-=xewm_6MuxK9JK_GoqyFSo6L-beXyEv83awe+B_rVw@mail.gmail.com>
In-Reply-To: <CA+55aFz-=xewm_6MuxK9JK_GoqyFSo6L-beXyEv83awe+B_rVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 08:59 PM, Linus Torvalds wrote:
> On Wed, Jun 12, 2013 at 5:49 PM, Al Viro<viro@zeniv.linux.org.uk>  wrote:
>> On Wed, Jun 12, 2013 at 05:38:13PM -0700, Linus Torvalds wrote:
>>> For the particular case of dget_parent() maybe dget_parent() should
>>> just double-check the original dentry->d_parent pointer after getting
>>> the refcount on it (and if the parent has changed, drop the refcount
>>> again and go to the locked version). That might be a good idea anyway,
>>> and should fix the possible race (which would be with another cpu
>>> having to first rename the child to some other parent, and the
>>> d_invalidate() the original parent)
>> Yes, but...  Then we'd need to dput() that sucker if we decide we shouldn't
>> have grabbed that reference, after all, which would make dget_parent()
>> potentially blocking.
> Ho humm.. interesting. I was talking about wanting to mix atomics and
> spinlocks earlier in this thread due to space constraints, and it
> strikes me that that would actually help this case a lot. Having the
> dentry count mix d_lock and the count in one word would allow for
> atomic ops like "increment if not locked", and we'd avoid this whole
> race entirely..
>
> Something like "low bit of count is the lock bit" would end up being
> lovely for this case. Of course, that's not how our spinlocks work ..
>
>                Linus

I have created another patch to do exactly the "increment if not locked" 
operation as suggested. It did help a lot. See the patch below for more 
information. Any additional comment will be appreciated.

Regards,
Longman

-------------------------------------------------------------------------------------------------------------------
The current code takes the dentry's d_lock lock whenever the d_count
reference count is being updated. In reality, nothing big really
happens until d_count goes to 0 in dput(). So it is not necessary
to take the lock if the reference count won't go to 0. On the other
hand, there are cases where d_count should not be updated or was not
expected to be updated while d_lock was taken by other functions.

To try to locklessly update the d_count while d_lock is not taken
by others, the 32-bit d_count and 32-bit d_lock (when no debugging
code is turned on) can be combined into a single 64-bit word to be
updated atomically whenever the following conditions happen:

1. The lock is not taken, i.e. spin_can_lock() returns true.
2. For increment, the original d_count must be > 0, or
3. for decrement, the original d_count must be > 1.

To maximize the chance of doing lockless update, the new code calls
spin_unlock_wait() before trying to do the update.

The new code also attempts to do lockless atomic update twice before
falling back to the old code path of taking a lock before doing
the update. It is because there will still be some fair amount of
contention with only one attempt.

The offsets of the d_count/d_lock duple are at byte 72 and 88 for
32-bit and 64-bit systems respectively. In both cases, they are
8-byte aligned and their combination into a single 8-byte word will
not introduce a hole that increase the size of the dentry structure.

This patch has a particular big impact on the short workload of the
AIM7 benchmark with ramdisk filesystem. The table below show the
performance improvement to the JPM (jobs per minutes) throughput due
to this patch on an 8-socket 80-core x86-64 system with a 3.10-rc4
kernel in a 1/2/4/8 node configuration by using numactl to restrict
the execution of the workload on certain nodes.

+-----------------+----------------+-----------------+----------+
|  Configuration  |    Mean JPM    |    Mean JPM     | % Change |
|                 | Rate w/o patch | Rate with patch |          |
+-----------------+---------------------------------------------+
|                 |              User Range 10 - 100            |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1596798     |     4748981     | +197.4%  |
| 4 nodes, HT off |    1653817     |     4845590     | +193.0%  |
| 2 nodes, HT off |    3802258     |     3832017     |   +0.8%  |
| 1 node , HT off |    2403297     |     2386401     |   -0.7%  |
+-----------------+---------------------------------------------+
|                 |              User Range 200 - 1000          |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1070992     |     6060457     | +465.9%  |
| 4 nodes, HT off |    1367668     |     6799978     | +397.2%  |
| 2 nodes, HT off |    4554370     |     4609893     |   +1.2%  |
| 1 node , HT off |    2534826     |     2526519     |   -0.3%  |
+-----------------+---------------------------------------------+
|                 |              User Range 1100 - 2000         |
+-----------------+---------------------------------------------+
| 8 nodes, HT off |    1061322     |     6435537     | +506.37  |
| 4 nodes, HT off |    1365111     |     6589983     | +382.7%  |
| 2 nodes, HT off |    4583947     |     4648464     |   +1.4%  |
| 1 node , HT off |    2563721     |     2566229     |   +0.1%  |
+-----------------+----------------+-----------------+----------+

It can be seen that with 40 CPUs (4 nodes) or more, this patch can
significantly improve the short workload performance. With only 1 or
2 nodes, the performance is similar with or without the patch. The
short workload also scales pretty well up to 4 nodes with this patch.

A perf call-graph report of the short workload at 1500 users
without the patch on the same 8-node machine indicates that about
78% of the workload's total time were spent in the _raw_spin_lock()
function. Almost all of which can be attributed to the following 2
kernel functions:
  1. dget_parent (49.91%)
  2. dput (49.89%)

The relevant perf report lines are:
+  78.37%           reaim  [kernel.kallsyms]     [k] _raw_spin_lock
+   0.09%           reaim  [kernel.kallsyms]     [k] dput
+   0.05%           reaim  [kernel.kallsyms]     [k] _raw_spin_lock_irq
+   0.00%           reaim  [kernel.kallsyms]     [k] dget_parent

With this patch installed, the new perf report lines are:
+  13.28%           reaim  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
+   7.33%           reaim  [kernel.kallsyms]     [k] _raw_spin_lock
+   2.93%           reaim  [kernel.kallsyms]     [k] dget_parent
+   1.32%           reaim  [kernel.kallsyms]     [k] dput

-   7.33%           reaim  [kernel.kallsyms]     [k] _raw_spin_lock
    - _raw_spin_lock
       + 41.96% d_path
       + 41.68% sys_getcwd
       + 2.67% prepend_path
       + 1.66% complete_walk
       + 0.86% unlazy_walk
       + 0.74% sem_lock
       + 0.72% do_anonymous_page
       + 0.69% dget_parent
       + 0.67% dput
       + 0.55% process_backlog
       + 0.52% enqueue_to_backlog

The dput used up only 0.67% of the _raw_spin_lock time while
dget_parent used only 0.69%. The time spent on dput and dget_parent
did increase because of busy waiting for unlock as well as the overhead
of doing cmpxchg operations.

This impact of this patch on other AIM7 workloads were much more
modest.  The table below show the mean %change due to this patch on
the same 8-socket system with a 3.10-rc4 kernel.

+--------------+---------------+----------------+-----------------+
|   Workload   | mean % change | mean % change  | mean % change   |
|              | 10-100 users  | 200-1000 users | 1100-2000 users |
+--------------+---------------+----------------+-----------------+
| alltests     |      0.0%     |     -0.3%      |     -0.3%       |
| five_sec     |     -4.6%     |     +6.5%      |     +3.1%       |
| fserver      |     -1.2%     |     -4.0%      |     -3.4%       |
| high_systime |     -0.1%     |     +1.7%      |     +7.2%       |
| new_fserver  |     -2.8%     |     -3.3%      |     -2.1%       |
| shared       |     -0.6%     |     -0.2%      |     +0.2%       |
+--------------+---------------+----------------+-----------------+

There are slight drops in performance for fsever and new_fserver
workloads, but slight increase in the high_systime and five_sec
workloads.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
  fs/dcache.c            |   14 ++++++-
  include/linux/dcache.h |  102 
+++++++++++++++++++++++++++++++++++++++++++++++-
  2 files changed, 112 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f09b908..2190c34 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -515,6 +515,8 @@ void dput(struct dentry *dentry)
  repeat:
      if (dentry->d_count == 1)
          might_sleep();
+    if (__dput_unless_lt2_or_locked(dentry))
+        return;
      spin_lock(&dentry->d_lock);
      BUG_ON(!dentry->d_count);
      if (dentry->d_count > 1) {
@@ -611,6 +613,8 @@ static inline void __dget_dlock(struct dentry *dentry)

  static inline void __dget(struct dentry *dentry)
  {
+    if (__dget_unless_zero_or_locked(dentry))
+        return;
      spin_lock(&dentry->d_lock);
      __dget_dlock(dentry);
      spin_unlock(&dentry->d_lock);
@@ -620,17 +624,23 @@ struct dentry *dget_parent(struct dentry *dentry)
  {
      struct dentry *ret;

+    rcu_read_lock();
+    ret = rcu_dereference(dentry->d_parent);
+    if (__dget_unless_zero_or_locked(ret)) {
+        rcu_read_unlock();
+        return ret;
+    }
  repeat:
      /*
       * Don't need rcu_dereference because we re-check it was correct under
       * the lock.
       */
-    rcu_read_lock();
-    ret = dentry->d_parent;
+    ret = ACCESS_ONCE(dentry->d_parent);
      spin_lock(&ret->d_lock);
      if (unlikely(ret != dentry->d_parent)) {
          spin_unlock(&ret->d_lock);
          rcu_read_unlock();
+        rcu_read_lock();
          goto repeat;
      }
      rcu_read_unlock();
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 1a6bb81..99ab699 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -112,8 +112,13 @@ struct dentry {
      unsigned char d_iname[DNAME_INLINE_LEN];    /* small names */

      /* Ref lookup also touches following */
-    unsigned int d_count;        /* protected by d_lock */
-    spinlock_t d_lock;        /* per dentry lock */
+    union {
+        struct {
+            unsigned int d_count;    /* protected by d_lock */
+            spinlock_t d_lock;    /* per dentry lock */
+        };
+        u64 d_cnt_lock;            /* combined count & lock */
+    };
      const struct dentry_operations *d_op;
      struct super_block *d_sb;    /* The root of the dentry tree */
      unsigned long d_time;        /* used by d_revalidate */
@@ -132,6 +137,19 @@ struct dentry {
  };

  /*
+ * The compiler does not allow named union in struct dentry without adding
+ * a named field. The union definition is repeated below to allow functions
+ * to reference it.
+ */
+union _d_cnt_lock {
+    struct {
+        unsigned int d_count;    /* protected by d_lock */
+        spinlock_t d_lock;    /* per dentry lock */
+    };
+    u64 d_cnt_lock;            /* combined count & lock */
+};
+
+/*
   * dentry->d_lock spinlock nesting subclasses:
   *
   * 0: normal
@@ -325,6 +343,84 @@ static inline int __d_rcu_to_refcount(struct dentry 
*dentry
, unsigned seq)
      return ret;
  }

+/**
+ * __dget_unless_zero_or_locked - atomically inc d_count if != 0 and 
not locked
+ * @dentry: dentry to work on
+ * Return: 0 on failure, else 1
+ *
+ * __dget_if_notzero_and_locked tries to atomically increment d_count 
without
+ * taking a lock as long as the count is not 0 and d_lock is not taken.
+ */
+static inline int __dget_unless_zero_or_locked(struct dentry *dentry)
+{
+    if (sizeof(union _d_cnt_lock) == sizeof(dentry->d_cnt_lock)) {
+        union _d_cnt_lock old, new;
+
+        spin_unlock_wait(&dentry->d_lock);
+        old.d_cnt_lock = ACCESS_ONCE(dentry->d_cnt_lock);
+        if ((old.d_count > 0) && spin_can_lock(&old.d_lock)) {
+            new.d_cnt_lock = old.d_cnt_lock;
+            new.d_count++;
+            if (cmpxchg(&dentry->d_cnt_lock, old.d_cnt_lock,
+                    new.d_cnt_lock) == old.d_cnt_lock)
+                return 1;
+            cpu_relax();
+            /*
+             * Try one more time
+             */
+            old.d_cnt_lock = ACCESS_ONCE(dentry->d_cnt_lock);
+            if ((old.d_count > 0) && spin_can_lock(&old.d_lock)) {
+                new.d_cnt_lock = old.d_cnt_lock;
+                new.d_count++;
+                if (cmpxchg(&dentry->d_cnt_lock, old.d_cnt_lock,
+                        new.d_cnt_lock) == old.d_cnt_lock)
+                    return 1;
+                cpu_relax();
+            }
+        }
+    }
+    return 0;
+}
+
+/**
+ * __dput_unless_lt2_or_locked - atomically dec d_count if >= 1 and not 
locked
+ * @dentry: dentry to work on
+ * Return: 0 on failure, else 1
+ *
+ * __dput_unless_leone_or_locked tries to atomically decrement d_count 
without
+ * taking a lock as long as the count is bigger than 1 and d_lock is 
not taken.
+ */
+static inline int __dput_unless_lt2_or_locked(struct dentry *dentry)
+{
+    if (sizeof(union _d_cnt_lock) == sizeof(dentry->d_cnt_lock)) {
+        union _d_cnt_lock old, new;
+
+        spin_unlock_wait(&dentry->d_lock);
+        old.d_cnt_lock = ACCESS_ONCE(dentry->d_cnt_lock);
+        if ((old.d_count > 1) && spin_can_lock(&old.d_lock)) {
+            new.d_cnt_lock = old.d_cnt_lock;
+            new.d_count--;
+            if (cmpxchg(&dentry->d_cnt_lock, old.d_cnt_lock,
+                    new.d_cnt_lock) == old.d_cnt_lock)
+                return 1;
+            cpu_relax();
+            /*
+             * Try one more time
+             */
+            old.d_cnt_lock = ACCESS_ONCE(dentry->d_cnt_lock);
+            if ((old.d_count > 1) && spin_can_lock(&old.d_lock)) {
+                new.d_cnt_lock = old.d_cnt_lock;
+                new.d_count--;
+                if (cmpxchg(&dentry->d_cnt_lock, old.d_cnt_lock,
+                        new.d_cnt_lock) == old.d_cnt_lock)
+                    return 1;
+                cpu_relax();
+            }
+        }
+    }
+    return 0;
+}
+
  /* validate "insecure" dentry pointer */
  extern int d_validate(struct dentry *, struct dentry *);

@@ -359,6 +455,8 @@ static inline struct dentry *dget_dlock(struct 
dentry *dentr
y)
  static inline struct dentry *dget(struct dentry *dentry)
  {
      if (dentry) {
+        if (__dget_unless_zero_or_locked(dentry))
+            return dentry;
          spin_lock(&dentry->d_lock);
          dget_dlock(dentry);
          spin_unlock(&dentry->d_lock);
-- 
1.7.1


