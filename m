Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaG1FTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:19:34 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:37312 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaG1FS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:18:56 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: jason.low2@hp.com, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] locking: Move docs into Documentation/locking/
Date: Sun, 27 Jul 2014 22:18:43 -0700
Message-Id: <1406524724-17946-6-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specifically:
  Documentation/locking/lockdep-design.txt
  Documentation/locking/lockstat.txt
  Documentation/locking/mutex-design.txt
  Documentation/locking/rt-mutex-design.txt
  Documentation/locking/rt-mutex.txt
  Documentation/locking/spinlocks.txt
  Documentation/locking/ww-mutex-design.txt

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 Documentation/00-INDEX                    |   2 +
 Documentation/DocBook/kernel-locking.tmpl |   2 +-
 Documentation/lockdep-design.txt          | 286 -----------
 Documentation/locking/lockdep-design.txt  | 286 +++++++++++
 Documentation/locking/lockstat.txt        | 178 +++++++
 Documentation/locking/mutex-design.txt    | 157 ++++++
 Documentation/locking/rt-mutex-design.txt | 781 ++++++++++++++++++++++++++++++
 Documentation/locking/rt-mutex.txt        |  79 +++
 Documentation/locking/spinlocks.txt       | 167 +++++++
 Documentation/locking/ww-mutex-design.txt | 344 +++++++++++++
 Documentation/lockstat.txt                | 178 -------
 Documentation/mutex-design.txt            | 157 ------
 Documentation/rt-mutex-design.txt         | 781 ------------------------------
 Documentation/rt-mutex.txt                |  79 ---
 Documentation/spinlocks.txt               | 167 -------
 Documentation/ww-mutex-design.txt         | 344 -------------
 MAINTAINERS                               |   4 +-
 drivers/gpu/drm/drm_modeset_lock.c        |   2 +-
 include/linux/lockdep.h                   |   2 +-
 include/linux/mutex.h                     |   2 +-
 include/linux/rwsem.h                     |   2 +-
 kernel/locking/mutex.c                    |   2 +-
 kernel/locking/rtmutex.c                  |   2 +-
 lib/Kconfig.debug                         |   4 +-
 24 files changed, 2005 insertions(+), 2003 deletions(-)
 delete mode 100644 Documentation/lockdep-design.txt
 create mode 100644 Documentation/locking/lockdep-design.txt
 create mode 100644 Documentation/locking/lockstat.txt
 create mode 100644 Documentation/locking/mutex-design.txt
 create mode 100644 Documentation/locking/rt-mutex-design.txt
 create mode 100644 Documentation/locking/rt-mutex.txt
 create mode 100644 Documentation/locking/spinlocks.txt
 create mode 100644 Documentation/locking/ww-mutex-design.txt
 delete mode 100644 Documentation/lockstat.txt
 delete mode 100644 Documentation/mutex-design.txt
 delete mode 100644 Documentation/rt-mutex-design.txt
 delete mode 100644 Documentation/rt-mutex.txt
 delete mode 100644 Documentation/spinlocks.txt
 delete mode 100644 Documentation/ww-mutex-design.txt

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 27e67a9..1750fce 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -287,6 +287,8 @@ local_ops.txt
 	- semantics and behavior of local atomic operations.
 lockdep-design.txt
 	- documentation on the runtime locking correctness validator.
+locking/
+	- directory with info about kernel locking primitives
 lockstat.txt
 	- info on collecting statistics on locks (and contention).
 lockup-watchdogs.txt
diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index e584ee1..c70fd1b 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1972,7 +1972,7 @@ machines due to caching.
    <itemizedlist>
     <listitem>
      <para>
-       <filename>Documentation/spinlocks.txt</filename>: 
+       <filename>Documentation/locking/spinlocks.txt</filename>: 
        Linus Torvalds' spinlocking tutorial in the kernel sources.
      </para>
     </listitem>
diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
deleted file mode 100644
index 5dbc99c..0000000
--- a/Documentation/lockdep-design.txt
+++ /dev/null
@@ -1,286 +0,0 @@
-Runtime locking correctness validator
-=====================================
-
-started by Ingo Molnar <mingo@redhat.com>
-additions by Arjan van de Ven <arjan@linux.intel.com>
-
-Lock-class
-----------
-
-The basic object the validator operates upon is a 'class' of locks.
-
-A class of locks is a group of locks that are logically the same with
-respect to locking rules, even if the locks may have multiple (possibly
-tens of thousands of) instantiations. For example a lock in the inode
-struct is one class, while each inode has its own instantiation of that
-lock class.
-
-The validator tracks the 'state' of lock-classes, and it tracks
-dependencies between different lock-classes. The validator maintains a
-rolling proof that the state and the dependencies are correct.
-
-Unlike an lock instantiation, the lock-class itself never goes away: when
-a lock-class is used for the first time after bootup it gets registered,
-and all subsequent uses of that lock-class will be attached to this
-lock-class.
-
-State
------
-
-The validator tracks lock-class usage history into 4n + 1 separate state bits:
-
-- 'ever held in STATE context'
-- 'ever held as readlock in STATE context'
-- 'ever held with STATE enabled'
-- 'ever held as readlock with STATE enabled'
-
-Where STATE can be either one of (kernel/lockdep_states.h)
- - hardirq
- - softirq
- - reclaim_fs
-
-- 'ever used'                                       [ == !unused        ]
-
-When locking rules are violated, these state bits are presented in the
-locking error messages, inside curlies. A contrived example:
-
-   modprobe/2287 is trying to acquire lock:
-    (&sio_locks[i].lock){-.-...}, at: [<c02867fd>] mutex_lock+0x21/0x24
-
-   but task is already holding lock:
-    (&sio_locks[i].lock){-.-...}, at: [<c02867fd>] mutex_lock+0x21/0x24
-
-
-The bit position indicates STATE, STATE-read, for each of the states listed
-above, and the character displayed in each indicates:
-
-   '.'  acquired while irqs disabled and not in irq context
-   '-'  acquired in irq context
-   '+'  acquired with irqs enabled
-   '?'  acquired in irq context with irqs enabled.
-
-Unused mutexes cannot be part of the cause of an error.
-
-
-Single-lock state rules:
-------------------------
-
-A softirq-unsafe lock-class is automatically hardirq-unsafe as well. The
-following states are exclusive, and only one of them is allowed to be
-set for any lock-class:
-
- <hardirq-safe> and <hardirq-unsafe>
- <softirq-safe> and <softirq-unsafe>
-
-The validator detects and reports lock usage that violate these
-single-lock state rules.
-
-Multi-lock dependency rules:
-----------------------------
-
-The same lock-class must not be acquired twice, because this could lead
-to lock recursion deadlocks.
-
-Furthermore, two locks may not be taken in different order:
-
- <L1> -> <L2>
- <L2> -> <L1>
-
-because this could lead to lock inversion deadlocks. (The validator
-finds such dependencies in arbitrary complexity, i.e. there can be any
-other locking sequence between the acquire-lock operations, the
-validator will still track all dependencies between locks.)
-
-Furthermore, the following usage based lock dependencies are not allowed
-between any two lock-classes:
-
-   <hardirq-safe>   ->  <hardirq-unsafe>
-   <softirq-safe>   ->  <softirq-unsafe>
-
-The first rule comes from the fact the a hardirq-safe lock could be
-taken by a hardirq context, interrupting a hardirq-unsafe lock - and
-thus could result in a lock inversion deadlock. Likewise, a softirq-safe
-lock could be taken by an softirq context, interrupting a softirq-unsafe
-lock.
-
-The above rules are enforced for any locking sequence that occurs in the
-kernel: when acquiring a new lock, the validator checks whether there is
-any rule violation between the new lock and any of the held locks.
-
-When a lock-class changes its state, the following aspects of the above
-dependency rules are enforced:
-
-- if a new hardirq-safe lock is discovered, we check whether it
-  took any hardirq-unsafe lock in the past.
-
-- if a new softirq-safe lock is discovered, we check whether it took
-  any softirq-unsafe lock in the past.
-
-- if a new hardirq-unsafe lock is discovered, we check whether any
-  hardirq-safe lock took it in the past.
-
-- if a new softirq-unsafe lock is discovered, we check whether any
-  softirq-safe lock took it in the past.
-
-(Again, we do these checks too on the basis that an interrupt context
-could interrupt _any_ of the irq-unsafe or hardirq-unsafe locks, which
-could lead to a lock inversion deadlock - even if that lock scenario did
-not trigger in practice yet.)
-
-Exception: Nested data dependencies leading to nested locking
--------------------------------------------------------------
-
-There are a few cases where the Linux kernel acquires more than one
-instance of the same lock-class. Such cases typically happen when there
-is some sort of hierarchy within objects of the same type. In these
-cases there is an inherent "natural" ordering between the two objects
-(defined by the properties of the hierarchy), and the kernel grabs the
-locks in this fixed order on each of the objects.
-
-An example of such an object hierarchy that results in "nested locking"
-is that of a "whole disk" block-dev object and a "partition" block-dev
-object; the partition is "part of" the whole device and as long as one
-always takes the whole disk lock as a higher lock than the partition
-lock, the lock ordering is fully correct. The validator does not
-automatically detect this natural ordering, as the locking rule behind
-the ordering is not static.
-
-In order to teach the validator about this correct usage model, new
-versions of the various locking primitives were added that allow you to
-specify a "nesting level". An example call, for the block device mutex,
-looks like this:
-
-enum bdev_bd_mutex_lock_class
-{
-       BD_MUTEX_NORMAL,
-       BD_MUTEX_WHOLE,
-       BD_MUTEX_PARTITION
-};
-
- mutex_lock_nested(&bdev->bd_contains->bd_mutex, BD_MUTEX_PARTITION);
-
-In this case the locking is done on a bdev object that is known to be a
-partition.
-
-The validator treats a lock that is taken in such a nested fashion as a
-separate (sub)class for the purposes of validation.
-
-Note: When changing code to use the _nested() primitives, be careful and
-check really thoroughly that the hierarchy is correctly mapped; otherwise
-you can get false positives or false negatives.
-
-Proof of 100% correctness:
---------------------------
-
-The validator achieves perfect, mathematical 'closure' (proof of locking
-correctness) in the sense that for every simple, standalone single-task
-locking sequence that occurred at least once during the lifetime of the
-kernel, the validator proves it with a 100% certainty that no
-combination and timing of these locking sequences can cause any class of
-lock related deadlock. [*]
-
-I.e. complex multi-CPU and multi-task locking scenarios do not have to
-occur in practice to prove a deadlock: only the simple 'component'
-locking chains have to occur at least once (anytime, in any
-task/context) for the validator to be able to prove correctness. (For
-example, complex deadlocks that would normally need more than 3 CPUs and
-a very unlikely constellation of tasks, irq-contexts and timings to
-occur, can be detected on a plain, lightly loaded single-CPU system as
-well!)
-
-This radically decreases the complexity of locking related QA of the
-kernel: what has to be done during QA is to trigger as many "simple"
-single-task locking dependencies in the kernel as possible, at least
-once, to prove locking correctness - instead of having to trigger every
-possible combination of locking interaction between CPUs, combined with
-every possible hardirq and softirq nesting scenario (which is impossible
-to do in practice).
-
-[*] assuming that the validator itself is 100% correct, and no other
-    part of the system corrupts the state of the validator in any way.
-    We also assume that all NMI/SMM paths [which could interrupt
-    even hardirq-disabled codepaths] are correct and do not interfere
-    with the validator. We also assume that the 64-bit 'chain hash'
-    value is unique for every lock-chain in the system. Also, lock
-    recursion must not be higher than 20.
-
-Performance:
-------------
-
-The above rules require _massive_ amounts of runtime checking. If we did
-that for every lock taken and for every irqs-enable event, it would
-render the system practically unusably slow. The complexity of checking
-is O(N^2), so even with just a few hundred lock-classes we'd have to do
-tens of thousands of checks for every event.
-
-This problem is solved by checking any given 'locking scenario' (unique
-sequence of locks taken after each other) only once. A simple stack of
-held locks is maintained, and a lightweight 64-bit hash value is
-calculated, which hash is unique for every lock chain. The hash value,
-when the chain is validated for the first time, is then put into a hash
-table, which hash-table can be checked in a lockfree manner. If the
-locking chain occurs again later on, the hash table tells us that we
-dont have to validate the chain again.
-
-Troubleshooting:
-----------------
-
-The validator tracks a maximum of MAX_LOCKDEP_KEYS number of lock classes.
-Exceeding this number will trigger the following lockdep warning:
-
-	(DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
-
-By default, MAX_LOCKDEP_KEYS is currently set to 8191, and typical
-desktop systems have less than 1,000 lock classes, so this warning
-normally results from lock-class leakage or failure to properly
-initialize locks.  These two problems are illustrated below:
-
-1.	Repeated module loading and unloading while running the validator
-	will result in lock-class leakage.  The issue here is that each
-	load of the module will create a new set of lock classes for
-	that module's locks, but module unloading does not remove old
-	classes (see below discussion of reuse of lock classes for why).
-	Therefore, if that module is loaded and unloaded repeatedly,
-	the number of lock classes will eventually reach the maximum.
-
-2.	Using structures such as arrays that have large numbers of
-	locks that are not explicitly initialized.  For example,
-	a hash table with 8192 buckets where each bucket has its own
-	spinlock_t will consume 8192 lock classes -unless- each spinlock
-	is explicitly initialized at runtime, for example, using the
-	run-time spin_lock_init() as opposed to compile-time initializers
-	such as __SPIN_LOCK_UNLOCKED().  Failure to properly initialize
-	the per-bucket spinlocks would guarantee lock-class overflow.
-	In contrast, a loop that called spin_lock_init() on each lock
-	would place all 8192 locks into a single lock class.
-
-	The moral of this story is that you should always explicitly
-	initialize your locks.
-
-One might argue that the validator should be modified to allow
-lock classes to be reused.  However, if you are tempted to make this
-argument, first review the code and think through the changes that would
-be required, keeping in mind that the lock classes to be removed are
-likely to be linked into the lock-dependency graph.  This turns out to
-be harder to do than to say.
-
-Of course, if you do run out of lock classes, the next thing to do is
-to find the offending lock classes.  First, the following command gives
-you the number of lock classes currently in use along with the maximum:
-
-	grep "lock-classes" /proc/lockdep_stats
-
-This command produces the following output on a modest system:
-
-	 lock-classes:                          748 [max: 8191]
-
-If the number allocated (748 above) increases continually over time,
-then there is likely a leak.  The following command can be used to
-identify the leaking lock classes:
-
-	grep "BD" /proc/lockdep
-
-Run the command and save the output, then compare against the output from
-a later run of this command to identify the leakers.  This same output
-can also help you find situations where runtime lock initialization has
-been omitted.
diff --git a/Documentation/locking/lockdep-design.txt b/Documentation/locking/lockdep-design.txt
new file mode 100644
index 0000000..5dbc99c
--- /dev/null
+++ b/Documentation/locking/lockdep-design.txt
@@ -0,0 +1,286 @@
+Runtime locking correctness validator
+=====================================
+
+started by Ingo Molnar <mingo@redhat.com>
+additions by Arjan van de Ven <arjan@linux.intel.com>
+
+Lock-class
+----------
+
+The basic object the validator operates upon is a 'class' of locks.
+
+A class of locks is a group of locks that are logically the same with
+respect to locking rules, even if the locks may have multiple (possibly
+tens of thousands of) instantiations. For example a lock in the inode
+struct is one class, while each inode has its own instantiation of that
+lock class.
+
+The validator tracks the 'state' of lock-classes, and it tracks
+dependencies between different lock-classes. The validator maintains a
+rolling proof that the state and the dependencies are correct.
+
+Unlike an lock instantiation, the lock-class itself never goes away: when
+a lock-class is used for the first time after bootup it gets registered,
+and all subsequent uses of that lock-class will be attached to this
+lock-class.
+
+State
+-----
+
+The validator tracks lock-class usage history into 4n + 1 separate state bits:
+
+- 'ever held in STATE context'
+- 'ever held as readlock in STATE context'
+- 'ever held with STATE enabled'
+- 'ever held as readlock with STATE enabled'
+
+Where STATE can be either one of (kernel/lockdep_states.h)
+ - hardirq
+ - softirq
+ - reclaim_fs
+
+- 'ever used'                                       [ == !unused        ]
+
+When locking rules are violated, these state bits are presented in the
+locking error messages, inside curlies. A contrived example:
+
+   modprobe/2287 is trying to acquire lock:
+    (&sio_locks[i].lock){-.-...}, at: [<c02867fd>] mutex_lock+0x21/0x24
+
+   but task is already holding lock:
+    (&sio_locks[i].lock){-.-...}, at: [<c02867fd>] mutex_lock+0x21/0x24
+
+
+The bit position indicates STATE, STATE-read, for each of the states listed
+above, and the character displayed in each indicates:
+
+   '.'  acquired while irqs disabled and not in irq context
+   '-'  acquired in irq context
+   '+'  acquired with irqs enabled
+   '?'  acquired in irq context with irqs enabled.
+
+Unused mutexes cannot be part of the cause of an error.
+
+
+Single-lock state rules:
+------------------------
+
+A softirq-unsafe lock-class is automatically hardirq-unsafe as well. The
+following states are exclusive, and only one of them is allowed to be
+set for any lock-class:
+
+ <hardirq-safe> and <hardirq-unsafe>
+ <softirq-safe> and <softirq-unsafe>
+
+The validator detects and reports lock usage that violate these
+single-lock state rules.
+
+Multi-lock dependency rules:
+----------------------------
+
+The same lock-class must not be acquired twice, because this could lead
+to lock recursion deadlocks.
+
+Furthermore, two locks may not be taken in different order:
+
+ <L1> -> <L2>
+ <L2> -> <L1>
+
+because this could lead to lock inversion deadlocks. (The validator
+finds such dependencies in arbitrary complexity, i.e. there can be any
+other locking sequence between the acquire-lock operations, the
+validator will still track all dependencies between locks.)
+
+Furthermore, the following usage based lock dependencies are not allowed
+between any two lock-classes:
+
+   <hardirq-safe>   ->  <hardirq-unsafe>
+   <softirq-safe>   ->  <softirq-unsafe>
+
+The first rule comes from the fact the a hardirq-safe lock could be
+taken by a hardirq context, interrupting a hardirq-unsafe lock - and
+thus could result in a lock inversion deadlock. Likewise, a softirq-safe
+lock could be taken by an softirq context, interrupting a softirq-unsafe
+lock.
+
+The above rules are enforced for any locking sequence that occurs in the
+kernel: when acquiring a new lock, the validator checks whether there is
+any rule violation between the new lock and any of the held locks.
+
+When a lock-class changes its state, the following aspects of the above
+dependency rules are enforced:
+
+- if a new hardirq-safe lock is discovered, we check whether it
+  took any hardirq-unsafe lock in the past.
+
+- if a new softirq-safe lock is discovered, we check whether it took
+  any softirq-unsafe lock in the past.
+
+- if a new hardirq-unsafe lock is discovered, we check whether any
+  hardirq-safe lock took it in the past.
+
+- if a new softirq-unsafe lock is discovered, we check whether any
+  softirq-safe lock took it in the past.
+
+(Again, we do these checks too on the basis that an interrupt context
+could interrupt _any_ of the irq-unsafe or hardirq-unsafe locks, which
+could lead to a lock inversion deadlock - even if that lock scenario did
+not trigger in practice yet.)
+
+Exception: Nested data dependencies leading to nested locking
+-------------------------------------------------------------
+
+There are a few cases where the Linux kernel acquires more than one
+instance of the same lock-class. Such cases typically happen when there
+is some sort of hierarchy within objects of the same type. In these
+cases there is an inherent "natural" ordering between the two objects
+(defined by the properties of the hierarchy), and the kernel grabs the
+locks in this fixed order on each of the objects.
+
+An example of such an object hierarchy that results in "nested locking"
+is that of a "whole disk" block-dev object and a "partition" block-dev
+object; the partition is "part of" the whole device and as long as one
+always takes the whole disk lock as a higher lock than the partition
+lock, the lock ordering is fully correct. The validator does not
+automatically detect this natural ordering, as the locking rule behind
+the ordering is not static.
+
+In order to teach the validator about this correct usage model, new
+versions of the various locking primitives were added that allow you to
+specify a "nesting level". An example call, for the block device mutex,
+looks like this:
+
+enum bdev_bd_mutex_lock_class
+{
+       BD_MUTEX_NORMAL,
+       BD_MUTEX_WHOLE,
+       BD_MUTEX_PARTITION
+};
+
+ mutex_lock_nested(&bdev->bd_contains->bd_mutex, BD_MUTEX_PARTITION);
+
+In this case the locking is done on a bdev object that is known to be a
+partition.
+
+The validator treats a lock that is taken in such a nested fashion as a
+separate (sub)class for the purposes of validation.
+
+Note: When changing code to use the _nested() primitives, be careful and
+check really thoroughly that the hierarchy is correctly mapped; otherwise
+you can get false positives or false negatives.
+
+Proof of 100% correctness:
+--------------------------
+
+The validator achieves perfect, mathematical 'closure' (proof of locking
+correctness) in the sense that for every simple, standalone single-task
+locking sequence that occurred at least once during the lifetime of the
+kernel, the validator proves it with a 100% certainty that no
+combination and timing of these locking sequences can cause any class of
+lock related deadlock. [*]
+
+I.e. complex multi-CPU and multi-task locking scenarios do not have to
+occur in practice to prove a deadlock: only the simple 'component'
+locking chains have to occur at least once (anytime, in any
+task/context) for the validator to be able to prove correctness. (For
+example, complex deadlocks that would normally need more than 3 CPUs and
+a very unlikely constellation of tasks, irq-contexts and timings to
+occur, can be detected on a plain, lightly loaded single-CPU system as
+well!)
+
+This radically decreases the complexity of locking related QA of the
+kernel: what has to be done during QA is to trigger as many "simple"
+single-task locking dependencies in the kernel as possible, at least
+once, to prove locking correctness - instead of having to trigger every
+possible combination of locking interaction between CPUs, combined with
+every possible hardirq and softirq nesting scenario (which is impossible
+to do in practice).
+
+[*] assuming that the validator itself is 100% correct, and no other
+    part of the system corrupts the state of the validator in any way.
+    We also assume that all NMI/SMM paths [which could interrupt
+    even hardirq-disabled codepaths] are correct and do not interfere
+    with the validator. We also assume that the 64-bit 'chain hash'
+    value is unique for every lock-chain in the system. Also, lock
+    recursion must not be higher than 20.
+
+Performance:
+------------
+
+The above rules require _massive_ amounts of runtime checking. If we did
+that for every lock taken and for every irqs-enable event, it would
+render the system practically unusably slow. The complexity of checking
+is O(N^2), so even with just a few hundred lock-classes we'd have to do
+tens of thousands of checks for every event.
+
+This problem is solved by checking any given 'locking scenario' (unique
+sequence of locks taken after each other) only once. A simple stack of
+held locks is maintained, and a lightweight 64-bit hash value is
+calculated, which hash is unique for every lock chain. The hash value,
+when the chain is validated for the first time, is then put into a hash
+table, which hash-table can be checked in a lockfree manner. If the
+locking chain occurs again later on, the hash table tells us that we
+dont have to validate the chain again.
+
+Troubleshooting:
+----------------
+
+The validator tracks a maximum of MAX_LOCKDEP_KEYS number of lock classes.
+Exceeding this number will trigger the following lockdep warning:
+
+	(DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
+
+By default, MAX_LOCKDEP_KEYS is currently set to 8191, and typical
+desktop systems have less than 1,000 lock classes, so this warning
+normally results from lock-class leakage or failure to properly
+initialize locks.  These two problems are illustrated below:
+
+1.	Repeated module loading and unloading while running the validator
+	will result in lock-class leakage.  The issue here is that each
+	load of the module will create a new set of lock classes for
+	that module's locks, but module unloading does not remove old
+	classes (see below discussion of reuse of lock classes for why).
+	Therefore, if that module is loaded and unloaded repeatedly,
+	the number of lock classes will eventually reach the maximum.
+
+2.	Using structures such as arrays that have large numbers of
+	locks that are not explicitly initialized.  For example,
+	a hash table with 8192 buckets where each bucket has its own
+	spinlock_t will consume 8192 lock classes -unless- each spinlock
+	is explicitly initialized at runtime, for example, using the
+	run-time spin_lock_init() as opposed to compile-time initializers
+	such as __SPIN_LOCK_UNLOCKED().  Failure to properly initialize
+	the per-bucket spinlocks would guarantee lock-class overflow.
+	In contrast, a loop that called spin_lock_init() on each lock
+	would place all 8192 locks into a single lock class.
+
+	The moral of this story is that you should always explicitly
+	initialize your locks.
+
+One might argue that the validator should be modified to allow
+lock classes to be reused.  However, if you are tempted to make this
+argument, first review the code and think through the changes that would
+be required, keeping in mind that the lock classes to be removed are
+likely to be linked into the lock-dependency graph.  This turns out to
+be harder to do than to say.
+
+Of course, if you do run out of lock classes, the next thing to do is
+to find the offending lock classes.  First, the following command gives
+you the number of lock classes currently in use along with the maximum:
+
+	grep "lock-classes" /proc/lockdep_stats
+
+This command produces the following output on a modest system:
+
+	 lock-classes:                          748 [max: 8191]
+
+If the number allocated (748 above) increases continually over time,
+then there is likely a leak.  The following command can be used to
+identify the leaking lock classes:
+
+	grep "BD" /proc/lockdep
+
+Run the command and save the output, then compare against the output from
+a later run of this command to identify the leakers.  This same output
+can also help you find situations where runtime lock initialization has
+been omitted.
diff --git a/Documentation/locking/lockstat.txt b/Documentation/locking/lockstat.txt
new file mode 100644
index 0000000..7428773
--- /dev/null
+++ b/Documentation/locking/lockstat.txt
@@ -0,0 +1,178 @@
+
+LOCK STATISTICS
+
+- WHAT
+
+As the name suggests, it provides statistics on locks.
+
+- WHY
+
+Because things like lock contention can severely impact performance.
+
+- HOW
+
+Lockdep already has hooks in the lock functions and maps lock instances to
+lock classes. We build on that (see Documentation/lokcing/lockdep-design.txt).
+The graph below shows the relation between the lock functions and the various
+hooks therein.
+
+        __acquire
+            |
+           lock _____
+            |        \
+            |    __contended
+            |         |
+            |       <wait>
+            | _______/
+            |/
+            |
+       __acquired
+            |
+            .
+          <hold>
+            .
+            |
+       __release
+            |
+         unlock
+
+lock, unlock	- the regular lock functions
+__*		- the hooks
+<> 		- states
+
+With these hooks we provide the following statistics:
+
+ con-bounces       - number of lock contention that involved x-cpu data
+ contentions       - number of lock acquisitions that had to wait
+ wait time min     - shortest (non-0) time we ever had to wait for a lock
+           max     - longest time we ever had to wait for a lock
+	   total   - total time we spend waiting on this lock
+	   avg     - average time spent waiting on this lock
+ acq-bounces       - number of lock acquisitions that involved x-cpu data
+ acquisitions      - number of times we took the lock
+ hold time min     - shortest (non-0) time we ever held the lock
+	   max     - longest time we ever held the lock
+	   total   - total time this lock was held
+	   avg     - average time this lock was held
+
+These numbers are gathered per lock class, per read/write state (when
+applicable).
+
+It also tracks 4 contention points per class. A contention point is a call site
+that had to wait on lock acquisition.
+
+ - CONFIGURATION
+
+Lock statistics are enabled via CONFIG_LOCK_STAT.
+
+ - USAGE
+
+Enable collection of statistics:
+
+# echo 1 >/proc/sys/kernel/lock_stat
+
+Disable collection of statistics:
+
+# echo 0 >/proc/sys/kernel/lock_stat
+
+Look at the current lock statistics:
+
+( line numbers not part of actual output, done for clarity in the explanation
+  below )
+
+# less /proc/lock_stat
+
+01 lock_stat version 0.4
+02-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+03                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
+04-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+05
+06                         &mm->mmap_sem-W:            46             84           0.26         939.10       16371.53         194.90          47291        2922365           0.16     2220301.69 17464026916.32        5975.99
+07                         &mm->mmap_sem-R:            37            100           1.31      299502.61      325629.52        3256.30         212344       34316685           0.10        7744.91    95016910.20           2.77
+08                         ---------------
+09                           &mm->mmap_sem              1          [<ffffffff811502a7>] khugepaged_scan_mm_slot+0x57/0x280
+19                           &mm->mmap_sem             96          [<ffffffff815351c4>] __do_page_fault+0x1d4/0x510
+11                           &mm->mmap_sem             34          [<ffffffff81113d77>] vm_mmap_pgoff+0x87/0xd0
+12                           &mm->mmap_sem             17          [<ffffffff81127e71>] vm_munmap+0x41/0x80
+13                         ---------------
+14                           &mm->mmap_sem              1          [<ffffffff81046fda>] dup_mmap+0x2a/0x3f0
+15                           &mm->mmap_sem             60          [<ffffffff81129e29>] SyS_mprotect+0xe9/0x250
+16                           &mm->mmap_sem             41          [<ffffffff815351c4>] __do_page_fault+0x1d4/0x510
+17                           &mm->mmap_sem             68          [<ffffffff81113d77>] vm_mmap_pgoff+0x87/0xd0
+18
+19.............................................................................................................................................................................................................................
+20
+21                         unix_table_lock:           110            112           0.21          49.24         163.91           1.46          21094          66312           0.12         624.42       31589.81           0.48
+22                         ---------------
+23                         unix_table_lock             45          [<ffffffff8150ad8e>] unix_create1+0x16e/0x1b0
+24                         unix_table_lock             47          [<ffffffff8150b111>] unix_release_sock+0x31/0x250
+25                         unix_table_lock             15          [<ffffffff8150ca37>] unix_find_other+0x117/0x230
+26                         unix_table_lock              5          [<ffffffff8150a09f>] unix_autobind+0x11f/0x1b0
+27                         ---------------
+28                         unix_table_lock             39          [<ffffffff8150b111>] unix_release_sock+0x31/0x250
+29                         unix_table_lock             49          [<ffffffff8150ad8e>] unix_create1+0x16e/0x1b0
+30                         unix_table_lock             20          [<ffffffff8150ca37>] unix_find_other+0x117/0x230
+31                         unix_table_lock              4          [<ffffffff8150a09f>] unix_autobind+0x11f/0x1b0
+
+
+This excerpt shows the first two lock class statistics. Line 01 shows the
+output version - each time the format changes this will be updated. Line 02-04
+show the header with column descriptions. Lines 05-18 and 20-31 show the actual
+statistics. These statistics come in two parts; the actual stats separated by a
+short separator (line 08, 13) from the contention points.
+
+The first lock (05-18) is a read/write lock, and shows two lines above the
+short separator. The contention points don't match the column descriptors,
+they have two: contentions and [<IP>] symbol. The second set of contention
+points are the points we're contending with.
+
+The integer part of the time values is in us.
+
+Dealing with nested locks, subclasses may appear:
+
+32...........................................................................................................................................................................................................................
+33
+34                               &rq->lock:       13128          13128           0.43         190.53      103881.26           7.91          97454        3453404           0.00         401.11    13224683.11           3.82
+35                               ---------
+36                               &rq->lock          645          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
+37                               &rq->lock          297          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+38                               &rq->lock          360          [<ffffffff8103c4c5>] select_task_rq_fair+0x1f0/0x74a
+39                               &rq->lock          428          [<ffffffff81045f98>] scheduler_tick+0x46/0x1fb
+40                               ---------
+41                               &rq->lock           77          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
+42                               &rq->lock          174          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+43                               &rq->lock         4715          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
+44                               &rq->lock          893          [<ffffffff81340524>] schedule+0x157/0x7b8
+45
+46...........................................................................................................................................................................................................................
+47
+48                             &rq->lock/1:        1526          11488           0.33         388.73      136294.31          11.86          21461          38404           0.00          37.93      109388.53           2.84
+49                             -----------
+50                             &rq->lock/1        11526          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
+51                             -----------
+52                             &rq->lock/1         5645          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
+53                             &rq->lock/1         1224          [<ffffffff81340524>] schedule+0x157/0x7b8
+54                             &rq->lock/1         4336          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
+55                             &rq->lock/1          181          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+
+Line 48 shows statistics for the second subclass (/1) of &rq->lock class
+(subclass starts from 0), since in this case, as line 50 suggests,
+double_rq_lock actually acquires a nested lock of two spinlocks.
+
+View the top contending locks:
+
+# grep : /proc/lock_stat | head
+			clockevents_lock:       2926159        2947636           0.15       46882.81  1784540466.34         605.41        3381345        3879161           0.00        2260.97    53178395.68          13.71
+		     tick_broadcast_lock:        346460         346717           0.18        2257.43    39364622.71         113.54        3642919        4242696           0.00        2263.79    49173646.60          11.59
+		  &mapping->i_mmap_mutex:        203896         203899           3.36      645530.05 31767507988.39      155800.21        3361776        8893984           0.17        2254.15    14110121.02           1.59
+			       &rq->lock:        135014         136909           0.18         606.09      842160.68           6.15        1540728       10436146           0.00         728.72    17606683.41           1.69
+	       &(&zone->lru_lock)->rlock:         93000          94934           0.16          59.18      188253.78           1.98        1199912        3809894           0.15         391.40     3559518.81           0.93
+			 tasklist_lock-W:         40667          41130           0.23        1189.42      428980.51          10.43         270278         510106           0.16         653.51     3939674.91           7.72
+			 tasklist_lock-R:         21298          21305           0.20        1310.05      215511.12          10.12         186204         241258           0.14        1162.33     1179779.23           4.89
+			      rcu_node_1:         47656          49022           0.16         635.41      193616.41           3.95         844888        1865423           0.00         764.26     1656226.96           0.89
+       &(&dentry->d_lockref.lock)->rlock:         39791          40179           0.15        1302.08       88851.96           2.21        2790851       12527025           0.10        1910.75     3379714.27           0.27
+			      rcu_node_0:         29203          30064           0.16         786.55     1555573.00          51.74          88963         244254           0.00         398.87      428872.51           1.76
+
+Clear the statistics:
+
+# echo 0 > /proc/lock_stat
diff --git a/Documentation/locking/mutex-design.txt b/Documentation/locking/mutex-design.txt
new file mode 100644
index 0000000..ee231ed
--- /dev/null
+++ b/Documentation/locking/mutex-design.txt
@@ -0,0 +1,157 @@
+Generic Mutex Subsystem
+
+started by Ingo Molnar <mingo@redhat.com>
+updated by Davidlohr Bueso <davidlohr@hp.com>
+
+What are mutexes?
+-----------------
+
+In the Linux kernel, mutexes refer to a particular locking primitive
+that enforces serialization on shared memory systems, and not only to
+the generic term referring to 'mutual exclusion' found in academia
+or similar theoretical text books. Mutexes are sleeping locks which
+behave similarly to binary semaphores, and were introduced in 2006[1]
+as an alternative to these. This new data structure provided a number
+of advantages, including simpler interfaces, and at that time smaller
+code (see Disadvantages).
+
+[1] http://lwn.net/Articles/164802/
+
+Implementation
+--------------
+
+Mutexes are represented by 'struct mutex', defined in include/linux/mutex.h
+and implemented in kernel/locking/mutex.c. These locks use a three
+state atomic counter (->count) to represent the different possible
+transitions that can occur during the lifetime of a lock:
+
+	  1: unlocked
+	  0: locked, no waiters
+   negative: locked, with potential waiters
+
+In its most basic form it also includes a wait-queue and a spinlock
+that serializes access to it. CONFIG_SMP systems can also include
+a pointer to the lock task owner (->owner) as well as a spinner MCS
+lock (->osq), both described below in (ii).
+
+When acquiring a mutex, there are three possible paths that can be
+taken, depending on the state of the lock:
+
+(i) fastpath: tries to atomically acquire the lock by decrementing the
+    counter. If it was already taken by another task it goes to the next
+    possible path. This logic is architecture specific. On x86-64, the
+    locking fastpath is 2 instructions:
+
+    0000000000000e10 <mutex_lock>:
+    e21:   f0 ff 0b                lock decl (%rbx)
+    e24:   79 08                   jns    e2e <mutex_lock+0x1e>
+
+   the unlocking fastpath is equally tight:
+
+    0000000000000bc0 <mutex_unlock>:
+    bc8:   f0 ff 07                lock incl (%rdi)
+    bcb:   7f 0a                   jg     bd7 <mutex_unlock+0x17>
+
+
+(ii) midpath: aka optimistic spinning, tries to spin for acquisition
+     while the lock owner is running and there are no other tasks ready
+     to run that have higher priority (need_resched). The rationale is
+     that if the lock owner is running, it is likely to release the lock
+     soon. The mutex spinners are queued up using MCS lock so that only
+     one spinner can compete for the mutex.
+
+     The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spinlock
+     with the desirable properties of being fair and with each cpu trying
+     to acquire the lock spinning on a local variable. It avoids expensive
+     cacheline bouncing that common test-and-set spinlock implementations
+     incur. An MCS-like lock is specially tailored for optimistic spinning
+     for sleeping lock implementation. An important feature of the customized
+     MCS lock is that it has the extra property that spinners are able to exit
+     the MCS spinlock queue when they need to reschedule. This further helps
+     avoid situations where MCS spinners that need to reschedule would continue
+     waiting to spin on mutex owner, only to go directly to slowpath upon
+     obtaining the MCS lock.
+
+
+(iii) slowpath: last resort, if the lock is still unable to be acquired,
+      the task is added to the wait-queue and sleeps until woken up by the
+      unlock path. Under normal circumstances it blocks as TASK_UNINTERRUPTIBLE.
+
+While formally kernel mutexes are sleepable locks, it is path (ii) that
+makes them more practically a hybrid type. By simply not interrupting a
+task and busy-waiting for a few cycles instead of immediately sleeping,
+the performance of this lock has been seen to significantly improve a
+number of workloads. Note that this technique is also used for rw-semaphores.
+
+Semantics
+---------
+
+The mutex subsystem checks and enforces the following rules:
+
+    - Only one task can hold the mutex at a time.
+    - Only the owner can unlock the mutex.
+    - Multiple unlocks are not permitted.
+    - Recursive locking/unlocking is not permitted.
+    - A mutex must only be initialized via the API (see below).
+    - A task may not exit with a mutex held.
+    - Memory areas where held locks reside must not be freed.
+    - Held mutexes must not be reinitialized.
+    - Mutexes may not be used in hardware or software interrupt
+      contexts such as tasklets and timers.
+
+These semantics are fully enforced when CONFIG DEBUG_MUTEXES is enabled.
+In addition, the mutex debugging code also implements a number of other
+features that make lock debugging easier and faster:
+
+    - Uses symbolic names of mutexes, whenever they are printed
+      in debug output.
+    - Point-of-acquire tracking, symbolic lookup of function names,
+      list of all locks held in the system, printout of them.
+    - Owner tracking.
+    - Detects self-recursing locks and prints out all relevant info.
+    - Detects multi-task circular deadlocks and prints out all affected
+      locks and tasks (and only those tasks).
+
+
+Interfaces
+----------
+Statically define the mutex:
+   DEFINE_MUTEX(name);
+
+Dynamically initialize the mutex:
+   mutex_init(mutex);
+
+Acquire the mutex, uninterruptible:
+   void mutex_lock(struct mutex *lock);
+   void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
+   int  mutex_trylock(struct mutex *lock);
+
+Acquire the mutex, interruptible:
+   int mutex_lock_interruptible_nested(struct mutex *lock,
+				       unsigned int subclass);
+   int mutex_lock_interruptible(struct mutex *lock);
+
+Acquire the mutex, interruptible, if dec to 0:
+   int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
+
+Unlock the mutex:
+   void mutex_unlock(struct mutex *lock);
+
+Test if the mutex is taken:
+   int mutex_is_locked(struct mutex *lock);
+
+Disadvantages
+-------------
+
+Unlike its original design and purpose, 'struct mutex' is larger than
+most locks in the kernel. E.g: on x86-64 it is 40 bytes, almost twice
+as large as 'struct semaphore' (24 bytes) and 8 bytes shy of the
+'struct rw_semaphore' variant. Larger structure sizes mean more CPU
+cache and memory footprint.
+
+When to use mutexes
+-------------------
+
+Unless the strict semantics of mutexes are unsuitable and/or the critical
+region prevents the lock from being shared, always prefer them to any other
+locking primitive.
diff --git a/Documentation/locking/rt-mutex-design.txt b/Documentation/locking/rt-mutex-design.txt
new file mode 100644
index 0000000..8666070
--- /dev/null
+++ b/Documentation/locking/rt-mutex-design.txt
@@ -0,0 +1,781 @@
+#
+# Copyright (c) 2006 Steven Rostedt
+# Licensed under the GNU Free Documentation License, Version 1.2
+#
+
+RT-mutex implementation design
+------------------------------
+
+This document tries to describe the design of the rtmutex.c implementation.
+It doesn't describe the reasons why rtmutex.c exists. For that please see
+Documentation/rt-mutex.txt.  Although this document does explain problems
+that happen without this code, but that is in the concept to understand
+what the code actually is doing.
+
+The goal of this document is to help others understand the priority
+inheritance (PI) algorithm that is used, as well as reasons for the
+decisions that were made to implement PI in the manner that was done.
+
+
+Unbounded Priority Inversion
+----------------------------
+
+Priority inversion is when a lower priority process executes while a higher
+priority process wants to run.  This happens for several reasons, and
+most of the time it can't be helped.  Anytime a high priority process wants
+to use a resource that a lower priority process has (a mutex for example),
+the high priority process must wait until the lower priority process is done
+with the resource.  This is a priority inversion.  What we want to prevent
+is something called unbounded priority inversion.  That is when the high
+priority process is prevented from running by a lower priority process for
+an undetermined amount of time.
+
+The classic example of unbounded priority inversion is where you have three
+processes, let's call them processes A, B, and C, where A is the highest
+priority process, C is the lowest, and B is in between. A tries to grab a lock
+that C owns and must wait and lets C run to release the lock. But in the
+meantime, B executes, and since B is of a higher priority than C, it preempts C,
+but by doing so, it is in fact preempting A which is a higher priority process.
+Now there's no way of knowing how long A will be sleeping waiting for C
+to release the lock, because for all we know, B is a CPU hog and will
+never give C a chance to release the lock.  This is called unbounded priority
+inversion.
+
+Here's a little ASCII art to show the problem.
+
+   grab lock L1 (owned by C)
+     |
+A ---+
+        C preempted by B
+          |
+C    +----+
+
+B         +-------->
+                B now keeps A from running.
+
+
+Priority Inheritance (PI)
+-------------------------
+
+There are several ways to solve this issue, but other ways are out of scope
+for this document.  Here we only discuss PI.
+
+PI is where a process inherits the priority of another process if the other
+process blocks on a lock owned by the current process.  To make this easier
+to understand, let's use the previous example, with processes A, B, and C again.
+
+This time, when A blocks on the lock owned by C, C would inherit the priority
+of A.  So now if B becomes runnable, it would not preempt C, since C now has
+the high priority of A.  As soon as C releases the lock, it loses its
+inherited priority, and A then can continue with the resource that C had.
+
+Terminology
+-----------
+
+Here I explain some terminology that is used in this document to help describe
+the design that is used to implement PI.
+
+PI chain - The PI chain is an ordered series of locks and processes that cause
+           processes to inherit priorities from a previous process that is
+           blocked on one of its locks.  This is described in more detail
+           later in this document.
+
+mutex    - In this document, to differentiate from locks that implement
+           PI and spin locks that are used in the PI code, from now on
+           the PI locks will be called a mutex.
+
+lock     - In this document from now on, I will use the term lock when
+           referring to spin locks that are used to protect parts of the PI
+           algorithm.  These locks disable preemption for UP (when
+           CONFIG_PREEMPT is enabled) and on SMP prevents multiple CPUs from
+           entering critical sections simultaneously.
+
+spin lock - Same as lock above.
+
+waiter   - A waiter is a struct that is stored on the stack of a blocked
+           process.  Since the scope of the waiter is within the code for
+           a process being blocked on the mutex, it is fine to allocate
+           the waiter on the process's stack (local variable).  This
+           structure holds a pointer to the task, as well as the mutex that
+           the task is blocked on.  It also has the plist node structures to
+           place the task in the waiter_list of a mutex as well as the
+           pi_list of a mutex owner task (described below).
+
+           waiter is sometimes used in reference to the task that is waiting
+           on a mutex. This is the same as waiter->task.
+
+waiters  - A list of processes that are blocked on a mutex.
+
+top waiter - The highest priority process waiting on a specific mutex.
+
+top pi waiter - The highest priority process waiting on one of the mutexes
+                that a specific process owns.
+
+Note:  task and process are used interchangeably in this document, mostly to
+       differentiate between two processes that are being described together.
+
+
+PI chain
+--------
+
+The PI chain is a list of processes and mutexes that may cause priority
+inheritance to take place.  Multiple chains may converge, but a chain
+would never diverge, since a process can't be blocked on more than one
+mutex at a time.
+
+Example:
+
+   Process:  A, B, C, D, E
+   Mutexes:  L1, L2, L3, L4
+
+   A owns: L1
+           B blocked on L1
+           B owns L2
+                  C blocked on L2
+                  C owns L3
+                         D blocked on L3
+                         D owns L4
+                                E blocked on L4
+
+The chain would be:
+
+   E->L4->D->L3->C->L2->B->L1->A
+
+To show where two chains merge, we could add another process F and
+another mutex L5 where B owns L5 and F is blocked on mutex L5.
+
+The chain for F would be:
+
+   F->L5->B->L1->A
+
+Since a process may own more than one mutex, but never be blocked on more than
+one, the chains merge.
+
+Here we show both chains:
+
+   E->L4->D->L3->C->L2-+
+                       |
+                       +->B->L1->A
+                       |
+                 F->L5-+
+
+For PI to work, the processes at the right end of these chains (or we may
+also call it the Top of the chain) must be equal to or higher in priority
+than the processes to the left or below in the chain.
+
+Also since a mutex may have more than one process blocked on it, we can
+have multiple chains merge at mutexes.  If we add another process G that is
+blocked on mutex L2:
+
+  G->L2->B->L1->A
+
+And once again, to show how this can grow I will show the merging chains
+again.
+
+   E->L4->D->L3->C-+
+                   +->L2-+
+                   |     |
+                 G-+     +->B->L1->A
+                         |
+                   F->L5-+
+
+
+Plist
+-----
+
+Before I go further and talk about how the PI chain is stored through lists
+on both mutexes and processes, I'll explain the plist.  This is similar to
+the struct list_head functionality that is already in the kernel.
+The implementation of plist is out of scope for this document, but it is
+very important to understand what it does.
+
+There are a few differences between plist and list, the most important one
+being that plist is a priority sorted linked list.  This means that the
+priorities of the plist are sorted, such that it takes O(1) to retrieve the
+highest priority item in the list.  Obviously this is useful to store processes
+based on their priorities.
+
+Another difference, which is important for implementation, is that, unlike
+list, the head of the list is a different element than the nodes of a list.
+So the head of the list is declared as struct plist_head and nodes that will
+be added to the list are declared as struct plist_node.
+
+
+Mutex Waiter List
+-----------------
+
+Every mutex keeps track of all the waiters that are blocked on itself. The mutex
+has a plist to store these waiters by priority.  This list is protected by
+a spin lock that is located in the struct of the mutex. This lock is called
+wait_lock.  Since the modification of the waiter list is never done in
+interrupt context, the wait_lock can be taken without disabling interrupts.
+
+
+Task PI List
+------------
+
+To keep track of the PI chains, each process has its own PI list.  This is
+a list of all top waiters of the mutexes that are owned by the process.
+Note that this list only holds the top waiters and not all waiters that are
+blocked on mutexes owned by the process.
+
+The top of the task's PI list is always the highest priority task that
+is waiting on a mutex that is owned by the task.  So if the task has
+inherited a priority, it will always be the priority of the task that is
+at the top of this list.
+
+This list is stored in the task structure of a process as a plist called
+pi_list.  This list is protected by a spin lock also in the task structure,
+called pi_lock.  This lock may also be taken in interrupt context, so when
+locking the pi_lock, interrupts must be disabled.
+
+
+Depth of the PI Chain
+---------------------
+
+The maximum depth of the PI chain is not dynamic, and could actually be
+defined.  But is very complex to figure it out, since it depends on all
+the nesting of mutexes.  Let's look at the example where we have 3 mutexes,
+L1, L2, and L3, and four separate functions func1, func2, func3 and func4.
+The following shows a locking order of L1->L2->L3, but may not actually
+be directly nested that way.
+
+void func1(void)
+{
+	mutex_lock(L1);
+
+	/* do anything */
+
+	mutex_unlock(L1);
+}
+
+void func2(void)
+{
+	mutex_lock(L1);
+	mutex_lock(L2);
+
+	/* do something */
+
+	mutex_unlock(L2);
+	mutex_unlock(L1);
+}
+
+void func3(void)
+{
+	mutex_lock(L2);
+	mutex_lock(L3);
+
+	/* do something else */
+
+	mutex_unlock(L3);
+	mutex_unlock(L2);
+}
+
+void func4(void)
+{
+	mutex_lock(L3);
+
+	/* do something again */
+
+	mutex_unlock(L3);
+}
+
+Now we add 4 processes that run each of these functions separately.
+Processes A, B, C, and D which run functions func1, func2, func3 and func4
+respectively, and such that D runs first and A last.  With D being preempted
+in func4 in the "do something again" area, we have a locking that follows:
+
+D owns L3
+       C blocked on L3
+       C owns L2
+              B blocked on L2
+              B owns L1
+                     A blocked on L1
+
+And thus we have the chain A->L1->B->L2->C->L3->D.
+
+This gives us a PI depth of 4 (four processes), but looking at any of the
+functions individually, it seems as though they only have at most a locking
+depth of two.  So, although the locking depth is defined at compile time,
+it still is very difficult to find the possibilities of that depth.
+
+Now since mutexes can be defined by user-land applications, we don't want a DOS
+type of application that nests large amounts of mutexes to create a large
+PI chain, and have the code holding spin locks while looking at a large
+amount of data.  So to prevent this, the implementation not only implements
+a maximum lock depth, but also only holds at most two different locks at a
+time, as it walks the PI chain.  More about this below.
+
+
+Mutex owner and flags
+---------------------
+
+The mutex structure contains a pointer to the owner of the mutex.  If the
+mutex is not owned, this owner is set to NULL.  Since all architectures
+have the task structure on at least a four byte alignment (and if this is
+not true, the rtmutex.c code will be broken!), this allows for the two
+least significant bits to be used as flags.  This part is also described
+in Documentation/rt-mutex.txt, but will also be briefly described here.
+
+Bit 0 is used as the "Pending Owner" flag.  This is described later.
+Bit 1 is used as the "Has Waiters" flags.  This is also described later
+  in more detail, but is set whenever there are waiters on a mutex.
+
+
+cmpxchg Tricks
+--------------
+
+Some architectures implement an atomic cmpxchg (Compare and Exchange).  This
+is used (when applicable) to keep the fast path of grabbing and releasing
+mutexes short.
+
+cmpxchg is basically the following function performed atomically:
+
+unsigned long _cmpxchg(unsigned long *A, unsigned long *B, unsigned long *C)
+{
+	unsigned long T = *A;
+	if (*A == *B) {
+		*A = *C;
+	}
+	return T;
+}
+#define cmpxchg(a,b,c) _cmpxchg(&a,&b,&c)
+
+This is really nice to have, since it allows you to only update a variable
+if the variable is what you expect it to be.  You know if it succeeded if
+the return value (the old value of A) is equal to B.
+
+The macro rt_mutex_cmpxchg is used to try to lock and unlock mutexes. If
+the architecture does not support CMPXCHG, then this macro is simply set
+to fail every time.  But if CMPXCHG is supported, then this will
+help out extremely to keep the fast path short.
+
+The use of rt_mutex_cmpxchg with the flags in the owner field help optimize
+the system for architectures that support it.  This will also be explained
+later in this document.
+
+
+Priority adjustments
+--------------------
+
+The implementation of the PI code in rtmutex.c has several places that a
+process must adjust its priority.  With the help of the pi_list of a
+process this is rather easy to know what needs to be adjusted.
+
+The functions implementing the task adjustments are rt_mutex_adjust_prio,
+__rt_mutex_adjust_prio (same as the former, but expects the task pi_lock
+to already be taken), rt_mutex_getprio, and rt_mutex_setprio.
+
+rt_mutex_getprio and rt_mutex_setprio are only used in __rt_mutex_adjust_prio.
+
+rt_mutex_getprio returns the priority that the task should have.  Either the
+task's own normal priority, or if a process of a higher priority is waiting on
+a mutex owned by the task, then that higher priority should be returned.
+Since the pi_list of a task holds an order by priority list of all the top
+waiters of all the mutexes that the task owns, rt_mutex_getprio simply needs
+to compare the top pi waiter to its own normal priority, and return the higher
+priority back.
+
+(Note:  if looking at the code, you will notice that the lower number of
+        prio is returned.  This is because the prio field in the task structure
+        is an inverse order of the actual priority.  So a "prio" of 5 is
+        of higher priority than a "prio" of 10.)
+
+__rt_mutex_adjust_prio examines the result of rt_mutex_getprio, and if the
+result does not equal the task's current priority, then rt_mutex_setprio
+is called to adjust the priority of the task to the new priority.
+Note that rt_mutex_setprio is defined in kernel/sched/core.c to implement the
+actual change in priority.
+
+It is interesting to note that __rt_mutex_adjust_prio can either increase
+or decrease the priority of the task.  In the case that a higher priority
+process has just blocked on a mutex owned by the task, __rt_mutex_adjust_prio
+would increase/boost the task's priority.  But if a higher priority task
+were for some reason to leave the mutex (timeout or signal), this same function
+would decrease/unboost the priority of the task.  That is because the pi_list
+always contains the highest priority task that is waiting on a mutex owned
+by the task, so we only need to compare the priority of that top pi waiter
+to the normal priority of the given task.
+
+
+High level overview of the PI chain walk
+----------------------------------------
+
+The PI chain walk is implemented by the function rt_mutex_adjust_prio_chain.
+
+The implementation has gone through several iterations, and has ended up
+with what we believe is the best.  It walks the PI chain by only grabbing
+at most two locks at a time, and is very efficient.
+
+The rt_mutex_adjust_prio_chain can be used either to boost or lower process
+priorities.
+
+rt_mutex_adjust_prio_chain is called with a task to be checked for PI
+(de)boosting (the owner of a mutex that a process is blocking on), a flag to
+check for deadlocking, the mutex that the task owns, and a pointer to a waiter
+that is the process's waiter struct that is blocked on the mutex (although this
+parameter may be NULL for deboosting).
+
+For this explanation, I will not mention deadlock detection. This explanation
+will try to stay at a high level.
+
+When this function is called, there are no locks held.  That also means
+that the state of the owner and lock can change when entered into this function.
+
+Before this function is called, the task has already had rt_mutex_adjust_prio
+performed on it.  This means that the task is set to the priority that it
+should be at, but the plist nodes of the task's waiter have not been updated
+with the new priorities, and that this task may not be in the proper locations
+in the pi_lists and wait_lists that the task is blocked on.  This function
+solves all that.
+
+A loop is entered, where task is the owner to be checked for PI changes that
+was passed by parameter (for the first iteration).  The pi_lock of this task is
+taken to prevent any more changes to the pi_list of the task.  This also
+prevents new tasks from completing the blocking on a mutex that is owned by this
+task.
+
+If the task is not blocked on a mutex then the loop is exited.  We are at
+the top of the PI chain.
+
+A check is now done to see if the original waiter (the process that is blocked
+on the current mutex) is the top pi waiter of the task.  That is, is this
+waiter on the top of the task's pi_list.  If it is not, it either means that
+there is another process higher in priority that is blocked on one of the
+mutexes that the task owns, or that the waiter has just woken up via a signal
+or timeout and has left the PI chain.  In either case, the loop is exited, since
+we don't need to do any more changes to the priority of the current task, or any
+task that owns a mutex that this current task is waiting on.  A priority chain
+walk is only needed when a new top pi waiter is made to a task.
+
+The next check sees if the task's waiter plist node has the priority equal to
+the priority the task is set at.  If they are equal, then we are done with
+the loop.  Remember that the function started with the priority of the
+task adjusted, but the plist nodes that hold the task in other processes
+pi_lists have not been adjusted.
+
+Next, we look at the mutex that the task is blocked on. The mutex's wait_lock
+is taken.  This is done by a spin_trylock, because the locking order of the
+pi_lock and wait_lock goes in the opposite direction. If we fail to grab the
+lock, the pi_lock is released, and we restart the loop.
+
+Now that we have both the pi_lock of the task as well as the wait_lock of
+the mutex the task is blocked on, we update the task's waiter's plist node
+that is located on the mutex's wait_list.
+
+Now we release the pi_lock of the task.
+
+Next the owner of the mutex has its pi_lock taken, so we can update the
+task's entry in the owner's pi_list.  If the task is the highest priority
+process on the mutex's wait_list, then we remove the previous top waiter
+from the owner's pi_list, and replace it with the task.
+
+Note: It is possible that the task was the current top waiter on the mutex,
+      in which case the task is not yet on the pi_list of the waiter.  This
+      is OK, since plist_del does nothing if the plist node is not on any
+      list.
+
+If the task was not the top waiter of the mutex, but it was before we
+did the priority updates, that means we are deboosting/lowering the
+task.  In this case, the task is removed from the pi_list of the owner,
+and the new top waiter is added.
+
+Lastly, we unlock both the pi_lock of the task, as well as the mutex's
+wait_lock, and continue the loop again.  On the next iteration of the
+loop, the previous owner of the mutex will be the task that will be
+processed.
+
+Note: One might think that the owner of this mutex might have changed
+      since we just grab the mutex's wait_lock. And one could be right.
+      The important thing to remember is that the owner could not have
+      become the task that is being processed in the PI chain, since
+      we have taken that task's pi_lock at the beginning of the loop.
+      So as long as there is an owner of this mutex that is not the same
+      process as the tasked being worked on, we are OK.
+
+      Looking closely at the code, one might be confused.  The check for the
+      end of the PI chain is when the task isn't blocked on anything or the
+      task's waiter structure "task" element is NULL.  This check is
+      protected only by the task's pi_lock.  But the code to unlock the mutex
+      sets the task's waiter structure "task" element to NULL with only
+      the protection of the mutex's wait_lock, which was not taken yet.
+      Isn't this a race condition if the task becomes the new owner?
+
+      The answer is No!  The trick is the spin_trylock of the mutex's
+      wait_lock.  If we fail that lock, we release the pi_lock of the
+      task and continue the loop, doing the end of PI chain check again.
+
+      In the code to release the lock, the wait_lock of the mutex is held
+      the entire time, and it is not let go when we grab the pi_lock of the
+      new owner of the mutex.  So if the switch of a new owner were to happen
+      after the check for end of the PI chain and the grabbing of the
+      wait_lock, the unlocking code would spin on the new owner's pi_lock
+      but never give up the wait_lock.  So the PI chain loop is guaranteed to
+      fail the spin_trylock on the wait_lock, release the pi_lock, and
+      try again.
+
+      If you don't quite understand the above, that's OK. You don't have to,
+      unless you really want to make a proof out of it ;)
+
+
+Pending Owners and Lock stealing
+--------------------------------
+
+One of the flags in the owner field of the mutex structure is "Pending Owner".
+What this means is that an owner was chosen by the process releasing the
+mutex, but that owner has yet to wake up and actually take the mutex.
+
+Why is this important?  Why can't we just give the mutex to another process
+and be done with it?
+
+The PI code is to help with real-time processes, and to let the highest
+priority process run as long as possible with little latencies and delays.
+If a high priority process owns a mutex that a lower priority process is
+blocked on, when the mutex is released it would be given to the lower priority
+process.  What if the higher priority process wants to take that mutex again.
+The high priority process would fail to take that mutex that it just gave up
+and it would need to boost the lower priority process to run with full
+latency of that critical section (since the low priority process just entered
+it).
+
+There's no reason a high priority process that gives up a mutex should be
+penalized if it tries to take that mutex again.  If the new owner of the
+mutex has not woken up yet, there's no reason that the higher priority process
+could not take that mutex away.
+
+To solve this, we introduced Pending Ownership and Lock Stealing.  When a
+new process is given a mutex that it was blocked on, it is only given
+pending ownership.  This means that it's the new owner, unless a higher
+priority process comes in and tries to grab that mutex.  If a higher priority
+process does come along and wants that mutex, we let the higher priority
+process "steal" the mutex from the pending owner (only if it is still pending)
+and continue with the mutex.
+
+
+Taking of a mutex (The walk through)
+------------------------------------
+
+OK, now let's take a look at the detailed walk through of what happens when
+taking a mutex.
+
+The first thing that is tried is the fast taking of the mutex.  This is
+done when we have CMPXCHG enabled (otherwise the fast taking automatically
+fails).  Only when the owner field of the mutex is NULL can the lock be
+taken with the CMPXCHG and nothing else needs to be done.
+
+If there is contention on the lock, whether it is owned or pending owner
+we go about the slow path (rt_mutex_slowlock).
+
+The slow path function is where the task's waiter structure is created on
+the stack.  This is because the waiter structure is only needed for the
+scope of this function.  The waiter structure holds the nodes to store
+the task on the wait_list of the mutex, and if need be, the pi_list of
+the owner.
+
+The wait_lock of the mutex is taken since the slow path of unlocking the
+mutex also takes this lock.
+
+We then call try_to_take_rt_mutex.  This is where the architecture that
+does not implement CMPXCHG would always grab the lock (if there's no
+contention).
+
+try_to_take_rt_mutex is used every time the task tries to grab a mutex in the
+slow path.  The first thing that is done here is an atomic setting of
+the "Has Waiters" flag of the mutex's owner field.  Yes, this could really
+be false, because if the mutex has no owner, there are no waiters and
+the current task also won't have any waiters.  But we don't have the lock
+yet, so we assume we are going to be a waiter.  The reason for this is to
+play nice for those architectures that do have CMPXCHG.  By setting this flag
+now, the owner of the mutex can't release the mutex without going into the
+slow unlock path, and it would then need to grab the wait_lock, which this
+code currently holds.  So setting the "Has Waiters" flag forces the owner
+to synchronize with this code.
+
+Now that we know that we can't have any races with the owner releasing the
+mutex, we check to see if we can take the ownership.  This is done if the
+mutex doesn't have a owner, or if we can steal the mutex from a pending
+owner.  Let's look at the situations we have here.
+
+  1) Has owner that is pending
+  ----------------------------
+
+  The mutex has a owner, but it hasn't woken up and the mutex flag
+  "Pending Owner" is set.  The first check is to see if the owner isn't the
+  current task.  This is because this function is also used for the pending
+  owner to grab the mutex.  When a pending owner wakes up, it checks to see
+  if it can take the mutex, and this is done if the owner is already set to
+  itself.  If so, we succeed and leave the function, clearing the "Pending
+  Owner" bit.
+
+  If the pending owner is not current, we check to see if the current priority is
+  higher than the pending owner.  If not, we fail the function and return.
+
+  There's also something special about a pending owner.  That is a pending owner
+  is never blocked on a mutex.  So there is no PI chain to worry about.  It also
+  means that if the mutex doesn't have any waiters, there's no accounting needed
+  to update the pending owner's pi_list, since we only worry about processes
+  blocked on the current mutex.
+
+  If there are waiters on this mutex, and we just stole the ownership, we need
+  to take the top waiter, remove it from the pi_list of the pending owner, and
+  add it to the current pi_list.  Note that at this moment, the pending owner
+  is no longer on the list of waiters.  This is fine, since the pending owner
+  would add itself back when it realizes that it had the ownership stolen
+  from itself.  When the pending owner tries to grab the mutex, it will fail
+  in try_to_take_rt_mutex if the owner field points to another process.
+
+  2) No owner
+  -----------
+
+  If there is no owner (or we successfully stole the lock), we set the owner
+  of the mutex to current, and set the flag of "Has Waiters" if the current
+  mutex actually has waiters, or we clear the flag if it doesn't.  See, it was
+  OK that we set that flag early, since now it is cleared.
+
+  3) Failed to grab ownership
+  ---------------------------
+
+  The most interesting case is when we fail to take ownership. This means that
+  there exists an owner, or there's a pending owner with equal or higher
+  priority than the current task.
+
+We'll continue on the failed case.
+
+If the mutex has a timeout, we set up a timer to go off to break us out
+of this mutex if we failed to get it after a specified amount of time.
+
+Now we enter a loop that will continue to try to take ownership of the mutex, or
+fail from a timeout or signal.
+
+Once again we try to take the mutex.  This will usually fail the first time
+in the loop, since it had just failed to get the mutex.  But the second time
+in the loop, this would likely succeed, since the task would likely be
+the pending owner.
+
+If the mutex is TASK_INTERRUPTIBLE a check for signals and timeout is done
+here.
+
+The waiter structure has a "task" field that points to the task that is blocked
+on the mutex.  This field can be NULL the first time it goes through the loop
+or if the task is a pending owner and had its mutex stolen.  If the "task"
+field is NULL then we need to set up the accounting for it.
+
+Task blocks on mutex
+--------------------
+
+The accounting of a mutex and process is done with the waiter structure of
+the process.  The "task" field is set to the process, and the "lock" field
+to the mutex.  The plist nodes are initialized to the processes current
+priority.
+
+Since the wait_lock was taken at the entry of the slow lock, we can safely
+add the waiter to the wait_list.  If the current process is the highest
+priority process currently waiting on this mutex, then we remove the
+previous top waiter process (if it exists) from the pi_list of the owner,
+and add the current process to that list.  Since the pi_list of the owner
+has changed, we call rt_mutex_adjust_prio on the owner to see if the owner
+should adjust its priority accordingly.
+
+If the owner is also blocked on a lock, and had its pi_list changed
+(or deadlock checking is on), we unlock the wait_lock of the mutex and go ahead
+and run rt_mutex_adjust_prio_chain on the owner, as described earlier.
+
+Now all locks are released, and if the current process is still blocked on a
+mutex (waiter "task" field is not NULL), then we go to sleep (call schedule).
+
+Waking up in the loop
+---------------------
+
+The schedule can then wake up for a few reasons.
+  1) we were given pending ownership of the mutex.
+  2) we received a signal and was TASK_INTERRUPTIBLE
+  3) we had a timeout and was TASK_INTERRUPTIBLE
+
+In any of these cases, we continue the loop and once again try to grab the
+ownership of the mutex.  If we succeed, we exit the loop, otherwise we continue
+and on signal and timeout, will exit the loop, or if we had the mutex stolen
+we just simply add ourselves back on the lists and go back to sleep.
+
+Note: For various reasons, because of timeout and signals, the steal mutex
+      algorithm needs to be careful. This is because the current process is
+      still on the wait_list. And because of dynamic changing of priorities,
+      especially on SCHED_OTHER tasks, the current process can be the
+      highest priority task on the wait_list.
+
+Failed to get mutex on Timeout or Signal
+----------------------------------------
+
+If a timeout or signal occurred, the waiter's "task" field would not be
+NULL and the task needs to be taken off the wait_list of the mutex and perhaps
+pi_list of the owner.  If this process was a high priority process, then
+the rt_mutex_adjust_prio_chain needs to be executed again on the owner,
+but this time it will be lowering the priorities.
+
+
+Unlocking the Mutex
+-------------------
+
+The unlocking of a mutex also has a fast path for those architectures with
+CMPXCHG.  Since the taking of a mutex on contention always sets the
+"Has Waiters" flag of the mutex's owner, we use this to know if we need to
+take the slow path when unlocking the mutex.  If the mutex doesn't have any
+waiters, the owner field of the mutex would equal the current process and
+the mutex can be unlocked by just replacing the owner field with NULL.
+
+If the owner field has the "Has Waiters" bit set (or CMPXCHG is not available),
+the slow unlock path is taken.
+
+The first thing done in the slow unlock path is to take the wait_lock of the
+mutex.  This synchronizes the locking and unlocking of the mutex.
+
+A check is made to see if the mutex has waiters or not.  On architectures that
+do not have CMPXCHG, this is the location that the owner of the mutex will
+determine if a waiter needs to be awoken or not.  On architectures that
+do have CMPXCHG, that check is done in the fast path, but it is still needed
+in the slow path too.  If a waiter of a mutex woke up because of a signal
+or timeout between the time the owner failed the fast path CMPXCHG check and
+the grabbing of the wait_lock, the mutex may not have any waiters, thus the
+owner still needs to make this check. If there are no waiters then the mutex
+owner field is set to NULL, the wait_lock is released and nothing more is
+needed.
+
+If there are waiters, then we need to wake one up and give that waiter
+pending ownership.
+
+On the wake up code, the pi_lock of the current owner is taken.  The top
+waiter of the lock is found and removed from the wait_list of the mutex
+as well as the pi_list of the current owner.  The task field of the new
+pending owner's waiter structure is set to NULL, and the owner field of the
+mutex is set to the new owner with the "Pending Owner" bit set, as well
+as the "Has Waiters" bit if there still are other processes blocked on the
+mutex.
+
+The pi_lock of the previous owner is released, and the new pending owner's
+pi_lock is taken.  Remember that this is the trick to prevent the race
+condition in rt_mutex_adjust_prio_chain from adding itself as a waiter
+on the mutex.
+
+We now clear the "pi_blocked_on" field of the new pending owner, and if
+the mutex still has waiters pending, we add the new top waiter to the pi_list
+of the pending owner.
+
+Finally we unlock the pi_lock of the pending owner and wake it up.
+
+
+Contact
+-------
+
+For updates on this document, please email Steven Rostedt <rostedt@goodmis.org>
+
+
+Credits
+-------
+
+Author:  Steven Rostedt <rostedt@goodmis.org>
+
+Reviewers:  Ingo Molnar, Thomas Gleixner, Thomas Duetsch, and Randy Dunlap
+
+Updates
+-------
+
+This document was originally written for 2.6.17-rc3-mm1
diff --git a/Documentation/locking/rt-mutex.txt b/Documentation/locking/rt-mutex.txt
new file mode 100644
index 0000000..243393d
--- /dev/null
+++ b/Documentation/locking/rt-mutex.txt
@@ -0,0 +1,79 @@
+RT-mutex subsystem with PI support
+----------------------------------
+
+RT-mutexes with priority inheritance are used to support PI-futexes,
+which enable pthread_mutex_t priority inheritance attributes
+(PTHREAD_PRIO_INHERIT). [See Documentation/pi-futex.txt for more details
+about PI-futexes.]
+
+This technology was developed in the -rt tree and streamlined for
+pthread_mutex support.
+
+Basic principles:
+-----------------
+
+RT-mutexes extend the semantics of simple mutexes by the priority
+inheritance protocol.
+
+A low priority owner of a rt-mutex inherits the priority of a higher
+priority waiter until the rt-mutex is released. If the temporarily
+boosted owner blocks on a rt-mutex itself it propagates the priority
+boosting to the owner of the other rt_mutex it gets blocked on. The
+priority boosting is immediately removed once the rt_mutex has been
+unlocked.
+
+This approach allows us to shorten the block of high-prio tasks on
+mutexes which protect shared resources. Priority inheritance is not a
+magic bullet for poorly designed applications, but it allows
+well-designed applications to use userspace locks in critical parts of
+an high priority thread, without losing determinism.
+
+The enqueueing of the waiters into the rtmutex waiter list is done in
+priority order. For same priorities FIFO order is chosen. For each
+rtmutex, only the top priority waiter is enqueued into the owner's
+priority waiters list. This list too queues in priority order. Whenever
+the top priority waiter of a task changes (for example it timed out or
+got a signal), the priority of the owner task is readjusted. [The
+priority enqueueing is handled by "plists", see include/linux/plist.h
+for more details.]
+
+RT-mutexes are optimized for fastpath operations and have no internal
+locking overhead when locking an uncontended mutex or unlocking a mutex
+without waiters. The optimized fastpath operations require cmpxchg
+support. [If that is not available then the rt-mutex internal spinlock
+is used]
+
+The state of the rt-mutex is tracked via the owner field of the rt-mutex
+structure:
+
+rt_mutex->owner holds the task_struct pointer of the owner. Bit 0 and 1
+are used to keep track of the "owner is pending" and "rtmutex has
+waiters" state.
+
+ owner		bit1	bit0
+ NULL		0	0	mutex is free (fast acquire possible)
+ NULL		0	1	invalid state
+ NULL		1	0	Transitional state*
+ NULL		1	1	invalid state
+ taskpointer	0	0	mutex is held (fast release possible)
+ taskpointer	0	1	task is pending owner
+ taskpointer	1	0	mutex is held and has waiters
+ taskpointer	1	1	task is pending owner and mutex has waiters
+
+Pending-ownership handling is a performance optimization:
+pending-ownership is assigned to the first (highest priority) waiter of
+the mutex, when the mutex is released. The thread is woken up and once
+it starts executing it can acquire the mutex. Until the mutex is taken
+by it (bit 0 is cleared) a competing higher priority thread can "steal"
+the mutex which puts the woken up thread back on the waiters list.
+
+The pending-ownership optimization is especially important for the
+uninterrupted workflow of high-prio tasks which repeatedly
+takes/releases locks that have lower-prio waiters. Without this
+optimization the higher-prio thread would ping-pong to the lower-prio
+task [because at unlock time we always assign a new owner].
+
+(*) The "mutex has waiters" bit gets set to take the lock. If the lock
+doesn't already have an owner, this bit is quickly cleared if there are
+no waiters.  So this is a transitional state to synchronize with looking
+at the owner field of the mutex and the mutex owner releasing the lock.
diff --git a/Documentation/locking/spinlocks.txt b/Documentation/locking/spinlocks.txt
new file mode 100644
index 0000000..97eaf57
--- /dev/null
+++ b/Documentation/locking/spinlocks.txt
@@ -0,0 +1,167 @@
+Lesson 1: Spin locks
+
+The most basic primitive for locking is spinlock.
+
+static DEFINE_SPINLOCK(xxx_lock);
+
+	unsigned long flags;
+
+	spin_lock_irqsave(&xxx_lock, flags);
+	... critical section here ..
+	spin_unlock_irqrestore(&xxx_lock, flags);
+
+The above is always safe. It will disable interrupts _locally_, but the
+spinlock itself will guarantee the global lock, so it will guarantee that
+there is only one thread-of-control within the region(s) protected by that
+lock. This works well even under UP also, so the code does _not_ need to
+worry about UP vs SMP issues: the spinlocks work correctly under both.
+
+   NOTE! Implications of spin_locks for memory are further described in:
+
+     Documentation/memory-barriers.txt
+       (5) LOCK operations.
+       (6) UNLOCK operations.
+
+The above is usually pretty simple (you usually need and want only one
+spinlock for most things - using more than one spinlock can make things a
+lot more complex and even slower and is usually worth it only for
+sequences that you _know_ need to be split up: avoid it at all cost if you
+aren't sure).
+
+This is really the only really hard part about spinlocks: once you start
+using spinlocks they tend to expand to areas you might not have noticed
+before, because you have to make sure the spinlocks correctly protect the
+shared data structures _everywhere_ they are used. The spinlocks are most
+easily added to places that are completely independent of other code (for
+example, internal driver data structures that nobody else ever touches).
+
+   NOTE! The spin-lock is safe only when you _also_ use the lock itself
+   to do locking across CPU's, which implies that EVERYTHING that
+   touches a shared variable has to agree about the spinlock they want
+   to use.
+
+----
+
+Lesson 2: reader-writer spinlocks.
+
+If your data accesses have a very natural pattern where you usually tend
+to mostly read from the shared variables, the reader-writer locks
+(rw_lock) versions of the spinlocks are sometimes useful. They allow multiple
+readers to be in the same critical region at once, but if somebody wants
+to change the variables it has to get an exclusive write lock.
+
+   NOTE! reader-writer locks require more atomic memory operations than
+   simple spinlocks.  Unless the reader critical section is long, you
+   are better off just using spinlocks.
+
+The routines look the same as above:
+
+   rwlock_t xxx_lock = __RW_LOCK_UNLOCKED(xxx_lock);
+
+	unsigned long flags;
+
+	read_lock_irqsave(&xxx_lock, flags);
+	.. critical section that only reads the info ...
+	read_unlock_irqrestore(&xxx_lock, flags);
+
+	write_lock_irqsave(&xxx_lock, flags);
+	.. read and write exclusive access to the info ...
+	write_unlock_irqrestore(&xxx_lock, flags);
+
+The above kind of lock may be useful for complex data structures like
+linked lists, especially searching for entries without changing the list
+itself.  The read lock allows many concurrent readers.  Anything that
+_changes_ the list will have to get the write lock.
+
+   NOTE! RCU is better for list traversal, but requires careful
+   attention to design detail (see Documentation/RCU/listRCU.txt).
+
+Also, you cannot "upgrade" a read-lock to a write-lock, so if you at _any_
+time need to do any changes (even if you don't do it every time), you have
+to get the write-lock at the very beginning.
+
+   NOTE! We are working hard to remove reader-writer spinlocks in most
+   cases, so please don't add a new one without consensus.  (Instead, see
+   Documentation/RCU/rcu.txt for complete information.)
+
+----
+
+Lesson 3: spinlocks revisited.
+
+The single spin-lock primitives above are by no means the only ones. They
+are the most safe ones, and the ones that work under all circumstances,
+but partly _because_ they are safe they are also fairly slow. They are slower
+than they'd need to be, because they do have to disable interrupts
+(which is just a single instruction on a x86, but it's an expensive one -
+and on other architectures it can be worse).
+
+If you have a case where you have to protect a data structure across
+several CPU's and you want to use spinlocks you can potentially use
+cheaper versions of the spinlocks. IFF you know that the spinlocks are
+never used in interrupt handlers, you can use the non-irq versions:
+
+	spin_lock(&lock);
+	...
+	spin_unlock(&lock);
+
+(and the equivalent read-write versions too, of course). The spinlock will
+guarantee the same kind of exclusive access, and it will be much faster. 
+This is useful if you know that the data in question is only ever
+manipulated from a "process context", ie no interrupts involved. 
+
+The reasons you mustn't use these versions if you have interrupts that
+play with the spinlock is that you can get deadlocks:
+
+	spin_lock(&lock);
+	...
+		<- interrupt comes in:
+			spin_lock(&lock);
+
+where an interrupt tries to lock an already locked variable. This is ok if
+the other interrupt happens on another CPU, but it is _not_ ok if the
+interrupt happens on the same CPU that already holds the lock, because the
+lock will obviously never be released (because the interrupt is waiting
+for the lock, and the lock-holder is interrupted by the interrupt and will
+not continue until the interrupt has been processed). 
+
+(This is also the reason why the irq-versions of the spinlocks only need
+to disable the _local_ interrupts - it's ok to use spinlocks in interrupts
+on other CPU's, because an interrupt on another CPU doesn't interrupt the
+CPU that holds the lock, so the lock-holder can continue and eventually
+releases the lock). 
+
+Note that you can be clever with read-write locks and interrupts. For
+example, if you know that the interrupt only ever gets a read-lock, then
+you can use a non-irq version of read locks everywhere - because they
+don't block on each other (and thus there is no dead-lock wrt interrupts. 
+But when you do the write-lock, you have to use the irq-safe version. 
+
+For an example of being clever with rw-locks, see the "waitqueue_lock" 
+handling in kernel/sched/core.c - nothing ever _changes_ a wait-queue from
+within an interrupt, they only read the queue in order to know whom to
+wake up. So read-locks are safe (which is good: they are very common
+indeed), while write-locks need to protect themselves against interrupts.
+
+		Linus
+
+----
+
+Reference information:
+
+For dynamic initialization, use spin_lock_init() or rwlock_init() as
+appropriate:
+
+   spinlock_t xxx_lock;
+   rwlock_t xxx_rw_lock;
+
+   static int __init xxx_init(void)
+   {
+	spin_lock_init(&xxx_lock);
+	rwlock_init(&xxx_rw_lock);
+	...
+   }
+
+   module_init(xxx_init);
+
+For static initialization, use DEFINE_SPINLOCK() / DEFINE_RWLOCK() or
+__SPIN_LOCK_UNLOCKED() / __RW_LOCK_UNLOCKED() as appropriate.
diff --git a/Documentation/locking/ww-mutex-design.txt b/Documentation/locking/ww-mutex-design.txt
new file mode 100644
index 0000000..8a112dc
--- /dev/null
+++ b/Documentation/locking/ww-mutex-design.txt
@@ -0,0 +1,344 @@
+Wait/Wound Deadlock-Proof Mutex Design
+======================================
+
+Please read mutex-design.txt first, as it applies to wait/wound mutexes too.
+
+Motivation for WW-Mutexes
+-------------------------
+
+GPU's do operations that commonly involve many buffers.  Those buffers
+can be shared across contexts/processes, exist in different memory
+domains (for example VRAM vs system memory), and so on.  And with
+PRIME / dmabuf, they can even be shared across devices.  So there are
+a handful of situations where the driver needs to wait for buffers to
+become ready.  If you think about this in terms of waiting on a buffer
+mutex for it to become available, this presents a problem because
+there is no way to guarantee that buffers appear in a execbuf/batch in
+the same order in all contexts.  That is directly under control of
+userspace, and a result of the sequence of GL calls that an application
+makes.	Which results in the potential for deadlock.  The problem gets
+more complex when you consider that the kernel may need to migrate the
+buffer(s) into VRAM before the GPU operates on the buffer(s), which
+may in turn require evicting some other buffers (and you don't want to
+evict other buffers which are already queued up to the GPU), but for a
+simplified understanding of the problem you can ignore this.
+
+The algorithm that the TTM graphics subsystem came up with for dealing with
+this problem is quite simple.  For each group of buffers (execbuf) that need
+to be locked, the caller would be assigned a unique reservation id/ticket,
+from a global counter.  In case of deadlock while locking all the buffers
+associated with a execbuf, the one with the lowest reservation ticket (i.e.
+the oldest task) wins, and the one with the higher reservation id (i.e. the
+younger task) unlocks all of the buffers that it has already locked, and then
+tries again.
+
+In the RDBMS literature this deadlock handling approach is called wait/wound:
+The older tasks waits until it can acquire the contended lock. The younger tasks
+needs to back off and drop all the locks it is currently holding, i.e. the
+younger task is wounded.
+
+Concepts
+--------
+
+Compared to normal mutexes two additional concepts/objects show up in the lock
+interface for w/w mutexes:
+
+Acquire context: To ensure eventual forward progress it is important the a task
+trying to acquire locks doesn't grab a new reservation id, but keeps the one it
+acquired when starting the lock acquisition. This ticket is stored in the
+acquire context. Furthermore the acquire context keeps track of debugging state
+to catch w/w mutex interface abuse.
+
+W/w class: In contrast to normal mutexes the lock class needs to be explicit for
+w/w mutexes, since it is required to initialize the acquire context.
+
+Furthermore there are three different class of w/w lock acquire functions:
+
+* Normal lock acquisition with a context, using ww_mutex_lock.
+
+* Slowpath lock acquisition on the contending lock, used by the wounded task
+  after having dropped all already acquired locks. These functions have the
+  _slow postfix.
+
+  From a simple semantics point-of-view the _slow functions are not strictly
+  required, since simply calling the normal ww_mutex_lock functions on the
+  contending lock (after having dropped all other already acquired locks) will
+  work correctly. After all if no other ww mutex has been acquired yet there's
+  no deadlock potential and hence the ww_mutex_lock call will block and not
+  prematurely return -EDEADLK. The advantage of the _slow functions is in
+  interface safety:
+  - ww_mutex_lock has a __must_check int return type, whereas ww_mutex_lock_slow
+    has a void return type. Note that since ww mutex code needs loops/retries
+    anyway the __must_check doesn't result in spurious warnings, even though the
+    very first lock operation can never fail.
+  - When full debugging is enabled ww_mutex_lock_slow checks that all acquired
+    ww mutex have been released (preventing deadlocks) and makes sure that we
+    block on the contending lock (preventing spinning through the -EDEADLK
+    slowpath until the contended lock can be acquired).
+
+* Functions to only acquire a single w/w mutex, which results in the exact same
+  semantics as a normal mutex. This is done by calling ww_mutex_lock with a NULL
+  context.
+
+  Again this is not strictly required. But often you only want to acquire a
+  single lock in which case it's pointless to set up an acquire context (and so
+  better to avoid grabbing a deadlock avoidance ticket).
+
+Of course, all the usual variants for handling wake-ups due to signals are also
+provided.
+
+Usage
+-----
+
+Three different ways to acquire locks within the same w/w class. Common
+definitions for methods #1 and #2:
+
+static DEFINE_WW_CLASS(ww_class);
+
+struct obj {
+	struct ww_mutex lock;
+	/* obj data */
+};
+
+struct obj_entry {
+	struct list_head head;
+	struct obj *obj;
+};
+
+Method 1, using a list in execbuf->buffers that's not allowed to be reordered.
+This is useful if a list of required objects is already tracked somewhere.
+Furthermore the lock helper can use propagate the -EALREADY return code back to
+the caller as a signal that an object is twice on the list. This is useful if
+the list is constructed from userspace input and the ABI requires userspace to
+not have duplicate entries (e.g. for a gpu commandbuffer submission ioctl).
+
+int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj *res_obj = NULL;
+	struct obj_entry *contended_entry = NULL;
+	struct obj_entry *entry;
+
+	ww_acquire_init(ctx, &ww_class);
+
+retry:
+	list_for_each_entry (entry, list, head) {
+		if (entry->obj == res_obj) {
+			res_obj = NULL;
+			continue;
+		}
+		ret = ww_mutex_lock(&entry->obj->lock, ctx);
+		if (ret < 0) {
+			contended_entry = entry;
+			goto err;
+		}
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+
+err:
+	list_for_each_entry_continue_reverse (entry, list, head)
+		ww_mutex_unlock(&entry->obj->lock);
+
+	if (res_obj)
+		ww_mutex_unlock(&res_obj->lock);
+
+	if (ret == -EDEADLK) {
+		/* we lost out in a seqno race, lock and retry.. */
+		ww_mutex_lock_slow(&contended_entry->obj->lock, ctx);
+		res_obj = contended_entry->obj;
+		goto retry;
+	}
+	ww_acquire_fini(ctx);
+
+	return ret;
+}
+
+Method 2, using a list in execbuf->buffers that can be reordered. Same semantics
+of duplicate entry detection using -EALREADY as method 1 above. But the
+list-reordering allows for a bit more idiomatic code.
+
+int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj_entry *entry, *entry2;
+
+	ww_acquire_init(ctx, &ww_class);
+
+	list_for_each_entry (entry, list, head) {
+		ret = ww_mutex_lock(&entry->obj->lock, ctx);
+		if (ret < 0) {
+			entry2 = entry;
+
+			list_for_each_entry_continue_reverse (entry2, list, head)
+				ww_mutex_unlock(&entry2->obj->lock);
+
+			if (ret != -EDEADLK) {
+				ww_acquire_fini(ctx);
+				return ret;
+			}
+
+			/* we lost out in a seqno race, lock and retry.. */
+			ww_mutex_lock_slow(&entry->obj->lock, ctx);
+
+			/*
+			 * Move buf to head of the list, this will point
+			 * buf->next to the first unlocked entry,
+			 * restarting the for loop.
+			 */
+			list_del(&entry->head);
+			list_add(&entry->head, list);
+		}
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+}
+
+Unlocking works the same way for both methods #1 and #2:
+
+void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj_entry *entry;
+
+	list_for_each_entry (entry, list, head)
+		ww_mutex_unlock(&entry->obj->lock);
+
+	ww_acquire_fini(ctx);
+}
+
+Method 3 is useful if the list of objects is constructed ad-hoc and not upfront,
+e.g. when adjusting edges in a graph where each node has its own ww_mutex lock,
+and edges can only be changed when holding the locks of all involved nodes. w/w
+mutexes are a natural fit for such a case for two reasons:
+- They can handle lock-acquisition in any order which allows us to start walking
+  a graph from a starting point and then iteratively discovering new edges and
+  locking down the nodes those edges connect to.
+- Due to the -EALREADY return code signalling that a given objects is already
+  held there's no need for additional book-keeping to break cycles in the graph
+  or keep track off which looks are already held (when using more than one node
+  as a starting point).
+
+Note that this approach differs in two important ways from the above methods:
+- Since the list of objects is dynamically constructed (and might very well be
+  different when retrying due to hitting the -EDEADLK wound condition) there's
+  no need to keep any object on a persistent list when it's not locked. We can
+  therefore move the list_head into the object itself.
+- On the other hand the dynamic object list construction also means that the -EALREADY return
+  code can't be propagated.
+
+Note also that methods #1 and #2 and method #3 can be combined, e.g. to first lock a
+list of starting nodes (passed in from userspace) using one of the above
+methods. And then lock any additional objects affected by the operations using
+method #3 below. The backoff/retry procedure will be a bit more involved, since
+when the dynamic locking step hits -EDEADLK we also need to unlock all the
+objects acquired with the fixed list. But the w/w mutex debug checks will catch
+any interface misuse for these cases.
+
+Also, method 3 can't fail the lock acquisition step since it doesn't return
+-EALREADY. Of course this would be different when using the _interruptible
+variants, but that's outside of the scope of these examples here.
+
+struct obj {
+	struct ww_mutex ww_mutex;
+	struct list_head locked_list;
+};
+
+static DEFINE_WW_CLASS(ww_class);
+
+void __unlock_objs(struct list_head *list)
+{
+	struct obj *entry, *temp;
+
+	list_for_each_entry_safe (entry, temp, list, locked_list) {
+		/* need to do that before unlocking, since only the current lock holder is
+		allowed to use object */
+		list_del(&entry->locked_list);
+		ww_mutex_unlock(entry->ww_mutex)
+	}
+}
+
+void lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj *obj;
+
+	ww_acquire_init(ctx, &ww_class);
+
+retry:
+	/* re-init loop start state */
+	loop {
+		/* magic code which walks over a graph and decides which objects
+		 * to lock */
+
+		ret = ww_mutex_lock(obj->ww_mutex, ctx);
+		if (ret == -EALREADY) {
+			/* we have that one already, get to the next object */
+			continue;
+		}
+		if (ret == -EDEADLK) {
+			__unlock_objs(list);
+
+			ww_mutex_lock_slow(obj, ctx);
+			list_add(&entry->locked_list, list);
+			goto retry;
+		}
+
+		/* locked a new object, add it to the list */
+		list_add_tail(&entry->locked_list, list);
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+}
+
+void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	__unlock_objs(list);
+	ww_acquire_fini(ctx);
+}
+
+Method 4: Only lock one single objects. In that case deadlock detection and
+prevention is obviously overkill, since with grabbing just one lock you can't
+produce a deadlock within just one class. To simplify this case the w/w mutex
+api can be used with a NULL context.
+
+Implementation Details
+----------------------
+
+Design:
+  ww_mutex currently encapsulates a struct mutex, this means no extra overhead for
+  normal mutex locks, which are far more common. As such there is only a small
+  increase in code size if wait/wound mutexes are not used.
+
+  In general, not much contention is expected. The locks are typically used to
+  serialize access to resources for devices. The only way to make wakeups
+  smarter would be at the cost of adding a field to struct mutex_waiter. This
+  would add overhead to all cases where normal mutexes are used, and
+  ww_mutexes are generally less performance sensitive.
+
+Lockdep:
+  Special care has been taken to warn for as many cases of api abuse
+  as possible. Some common api abuses will be caught with
+  CONFIG_DEBUG_MUTEXES, but CONFIG_PROVE_LOCKING is recommended.
+
+  Some of the errors which will be warned about:
+   - Forgetting to call ww_acquire_fini or ww_acquire_init.
+   - Attempting to lock more mutexes after ww_acquire_done.
+   - Attempting to lock the wrong mutex after -EDEADLK and
+     unlocking all mutexes.
+   - Attempting to lock the right mutex after -EDEADLK,
+     before unlocking all mutexes.
+
+   - Calling ww_mutex_lock_slow before -EDEADLK was returned.
+
+   - Unlocking mutexes with the wrong unlock function.
+   - Calling one of the ww_acquire_* twice on the same context.
+   - Using a different ww_class for the mutex than for the ww_acquire_ctx.
+   - Normal lockdep errors that can result in deadlocks.
+
+  Some of the lockdep errors that can result in deadlocks:
+   - Calling ww_acquire_init to initialize a second ww_acquire_ctx before
+     having called ww_acquire_fini on the first.
+   - 'normal' deadlocks that can occur.
+
+FIXME: Update this section once we have the TASK_DEADLOCK task state flag magic
+implemented.
diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
deleted file mode 100644
index 72d0106..0000000
--- a/Documentation/lockstat.txt
+++ /dev/null
@@ -1,178 +0,0 @@
-
-LOCK STATISTICS
-
-- WHAT
-
-As the name suggests, it provides statistics on locks.
-
-- WHY
-
-Because things like lock contention can severely impact performance.
-
-- HOW
-
-Lockdep already has hooks in the lock functions and maps lock instances to
-lock classes. We build on that (see Documentation/lockdep-design.txt).
-The graph below shows the relation between the lock functions and the various
-hooks therein.
-
-        __acquire
-            |
-           lock _____
-            |        \
-            |    __contended
-            |         |
-            |       <wait>
-            | _______/
-            |/
-            |
-       __acquired
-            |
-            .
-          <hold>
-            .
-            |
-       __release
-            |
-         unlock
-
-lock, unlock	- the regular lock functions
-__*		- the hooks
-<> 		- states
-
-With these hooks we provide the following statistics:
-
- con-bounces       - number of lock contention that involved x-cpu data
- contentions       - number of lock acquisitions that had to wait
- wait time min     - shortest (non-0) time we ever had to wait for a lock
-           max     - longest time we ever had to wait for a lock
-	   total   - total time we spend waiting on this lock
-	   avg     - average time spent waiting on this lock
- acq-bounces       - number of lock acquisitions that involved x-cpu data
- acquisitions      - number of times we took the lock
- hold time min     - shortest (non-0) time we ever held the lock
-	   max     - longest time we ever held the lock
-	   total   - total time this lock was held
-	   avg     - average time this lock was held
-
-These numbers are gathered per lock class, per read/write state (when
-applicable).
-
-It also tracks 4 contention points per class. A contention point is a call site
-that had to wait on lock acquisition.
-
- - CONFIGURATION
-
-Lock statistics are enabled via CONFIG_LOCK_STAT.
-
- - USAGE
-
-Enable collection of statistics:
-
-# echo 1 >/proc/sys/kernel/lock_stat
-
-Disable collection of statistics:
-
-# echo 0 >/proc/sys/kernel/lock_stat
-
-Look at the current lock statistics:
-
-( line numbers not part of actual output, done for clarity in the explanation
-  below )
-
-# less /proc/lock_stat
-
-01 lock_stat version 0.4
-02-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-03                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
-04-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-05
-06                         &mm->mmap_sem-W:            46             84           0.26         939.10       16371.53         194.90          47291        2922365           0.16     2220301.69 17464026916.32        5975.99
-07                         &mm->mmap_sem-R:            37            100           1.31      299502.61      325629.52        3256.30         212344       34316685           0.10        7744.91    95016910.20           2.77
-08                         ---------------
-09                           &mm->mmap_sem              1          [<ffffffff811502a7>] khugepaged_scan_mm_slot+0x57/0x280
-19                           &mm->mmap_sem             96          [<ffffffff815351c4>] __do_page_fault+0x1d4/0x510
-11                           &mm->mmap_sem             34          [<ffffffff81113d77>] vm_mmap_pgoff+0x87/0xd0
-12                           &mm->mmap_sem             17          [<ffffffff81127e71>] vm_munmap+0x41/0x80
-13                         ---------------
-14                           &mm->mmap_sem              1          [<ffffffff81046fda>] dup_mmap+0x2a/0x3f0
-15                           &mm->mmap_sem             60          [<ffffffff81129e29>] SyS_mprotect+0xe9/0x250
-16                           &mm->mmap_sem             41          [<ffffffff815351c4>] __do_page_fault+0x1d4/0x510
-17                           &mm->mmap_sem             68          [<ffffffff81113d77>] vm_mmap_pgoff+0x87/0xd0
-18
-19.............................................................................................................................................................................................................................
-20
-21                         unix_table_lock:           110            112           0.21          49.24         163.91           1.46          21094          66312           0.12         624.42       31589.81           0.48
-22                         ---------------
-23                         unix_table_lock             45          [<ffffffff8150ad8e>] unix_create1+0x16e/0x1b0
-24                         unix_table_lock             47          [<ffffffff8150b111>] unix_release_sock+0x31/0x250
-25                         unix_table_lock             15          [<ffffffff8150ca37>] unix_find_other+0x117/0x230
-26                         unix_table_lock              5          [<ffffffff8150a09f>] unix_autobind+0x11f/0x1b0
-27                         ---------------
-28                         unix_table_lock             39          [<ffffffff8150b111>] unix_release_sock+0x31/0x250
-29                         unix_table_lock             49          [<ffffffff8150ad8e>] unix_create1+0x16e/0x1b0
-30                         unix_table_lock             20          [<ffffffff8150ca37>] unix_find_other+0x117/0x230
-31                         unix_table_lock              4          [<ffffffff8150a09f>] unix_autobind+0x11f/0x1b0
-
-
-This excerpt shows the first two lock class statistics. Line 01 shows the
-output version - each time the format changes this will be updated. Line 02-04
-show the header with column descriptions. Lines 05-18 and 20-31 show the actual
-statistics. These statistics come in two parts; the actual stats separated by a
-short separator (line 08, 13) from the contention points.
-
-The first lock (05-18) is a read/write lock, and shows two lines above the
-short separator. The contention points don't match the column descriptors,
-they have two: contentions and [<IP>] symbol. The second set of contention
-points are the points we're contending with.
-
-The integer part of the time values is in us.
-
-Dealing with nested locks, subclasses may appear:
-
-32...........................................................................................................................................................................................................................
-33
-34                               &rq->lock:       13128          13128           0.43         190.53      103881.26           7.91          97454        3453404           0.00         401.11    13224683.11           3.82
-35                               ---------
-36                               &rq->lock          645          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
-37                               &rq->lock          297          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
-38                               &rq->lock          360          [<ffffffff8103c4c5>] select_task_rq_fair+0x1f0/0x74a
-39                               &rq->lock          428          [<ffffffff81045f98>] scheduler_tick+0x46/0x1fb
-40                               ---------
-41                               &rq->lock           77          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
-42                               &rq->lock          174          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
-43                               &rq->lock         4715          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
-44                               &rq->lock          893          [<ffffffff81340524>] schedule+0x157/0x7b8
-45
-46...........................................................................................................................................................................................................................
-47
-48                             &rq->lock/1:        1526          11488           0.33         388.73      136294.31          11.86          21461          38404           0.00          37.93      109388.53           2.84
-49                             -----------
-50                             &rq->lock/1        11526          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
-51                             -----------
-52                             &rq->lock/1         5645          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
-53                             &rq->lock/1         1224          [<ffffffff81340524>] schedule+0x157/0x7b8
-54                             &rq->lock/1         4336          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
-55                             &rq->lock/1          181          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
-
-Line 48 shows statistics for the second subclass (/1) of &rq->lock class
-(subclass starts from 0), since in this case, as line 50 suggests,
-double_rq_lock actually acquires a nested lock of two spinlocks.
-
-View the top contending locks:
-
-# grep : /proc/lock_stat | head
-			clockevents_lock:       2926159        2947636           0.15       46882.81  1784540466.34         605.41        3381345        3879161           0.00        2260.97    53178395.68          13.71
-		     tick_broadcast_lock:        346460         346717           0.18        2257.43    39364622.71         113.54        3642919        4242696           0.00        2263.79    49173646.60          11.59
-		  &mapping->i_mmap_mutex:        203896         203899           3.36      645530.05 31767507988.39      155800.21        3361776        8893984           0.17        2254.15    14110121.02           1.59
-			       &rq->lock:        135014         136909           0.18         606.09      842160.68           6.15        1540728       10436146           0.00         728.72    17606683.41           1.69
-	       &(&zone->lru_lock)->rlock:         93000          94934           0.16          59.18      188253.78           1.98        1199912        3809894           0.15         391.40     3559518.81           0.93
-			 tasklist_lock-W:         40667          41130           0.23        1189.42      428980.51          10.43         270278         510106           0.16         653.51     3939674.91           7.72
-			 tasklist_lock-R:         21298          21305           0.20        1310.05      215511.12          10.12         186204         241258           0.14        1162.33     1179779.23           4.89
-			      rcu_node_1:         47656          49022           0.16         635.41      193616.41           3.95         844888        1865423           0.00         764.26     1656226.96           0.89
-       &(&dentry->d_lockref.lock)->rlock:         39791          40179           0.15        1302.08       88851.96           2.21        2790851       12527025           0.10        1910.75     3379714.27           0.27
-			      rcu_node_0:         29203          30064           0.16         786.55     1555573.00          51.74          88963         244254           0.00         398.87      428872.51           1.76
-
-Clear the statistics:
-
-# echo 0 > /proc/lock_stat
diff --git a/Documentation/mutex-design.txt b/Documentation/mutex-design.txt
deleted file mode 100644
index ee231ed..0000000
--- a/Documentation/mutex-design.txt
+++ /dev/null
@@ -1,157 +0,0 @@
-Generic Mutex Subsystem
-
-started by Ingo Molnar <mingo@redhat.com>
-updated by Davidlohr Bueso <davidlohr@hp.com>
-
-What are mutexes?
------------------
-
-In the Linux kernel, mutexes refer to a particular locking primitive
-that enforces serialization on shared memory systems, and not only to
-the generic term referring to 'mutual exclusion' found in academia
-or similar theoretical text books. Mutexes are sleeping locks which
-behave similarly to binary semaphores, and were introduced in 2006[1]
-as an alternative to these. This new data structure provided a number
-of advantages, including simpler interfaces, and at that time smaller
-code (see Disadvantages).
-
-[1] http://lwn.net/Articles/164802/
-
-Implementation
---------------
-
-Mutexes are represented by 'struct mutex', defined in include/linux/mutex.h
-and implemented in kernel/locking/mutex.c. These locks use a three
-state atomic counter (->count) to represent the different possible
-transitions that can occur during the lifetime of a lock:
-
-	  1: unlocked
-	  0: locked, no waiters
-   negative: locked, with potential waiters
-
-In its most basic form it also includes a wait-queue and a spinlock
-that serializes access to it. CONFIG_SMP systems can also include
-a pointer to the lock task owner (->owner) as well as a spinner MCS
-lock (->osq), both described below in (ii).
-
-When acquiring a mutex, there are three possible paths that can be
-taken, depending on the state of the lock:
-
-(i) fastpath: tries to atomically acquire the lock by decrementing the
-    counter. If it was already taken by another task it goes to the next
-    possible path. This logic is architecture specific. On x86-64, the
-    locking fastpath is 2 instructions:
-
-    0000000000000e10 <mutex_lock>:
-    e21:   f0 ff 0b                lock decl (%rbx)
-    e24:   79 08                   jns    e2e <mutex_lock+0x1e>
-
-   the unlocking fastpath is equally tight:
-
-    0000000000000bc0 <mutex_unlock>:
-    bc8:   f0 ff 07                lock incl (%rdi)
-    bcb:   7f 0a                   jg     bd7 <mutex_unlock+0x17>
-
-
-(ii) midpath: aka optimistic spinning, tries to spin for acquisition
-     while the lock owner is running and there are no other tasks ready
-     to run that have higher priority (need_resched). The rationale is
-     that if the lock owner is running, it is likely to release the lock
-     soon. The mutex spinners are queued up using MCS lock so that only
-     one spinner can compete for the mutex.
-
-     The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spinlock
-     with the desirable properties of being fair and with each cpu trying
-     to acquire the lock spinning on a local variable. It avoids expensive
-     cacheline bouncing that common test-and-set spinlock implementations
-     incur. An MCS-like lock is specially tailored for optimistic spinning
-     for sleeping lock implementation. An important feature of the customized
-     MCS lock is that it has the extra property that spinners are able to exit
-     the MCS spinlock queue when they need to reschedule. This further helps
-     avoid situations where MCS spinners that need to reschedule would continue
-     waiting to spin on mutex owner, only to go directly to slowpath upon
-     obtaining the MCS lock.
-
-
-(iii) slowpath: last resort, if the lock is still unable to be acquired,
-      the task is added to the wait-queue and sleeps until woken up by the
-      unlock path. Under normal circumstances it blocks as TASK_UNINTERRUPTIBLE.
-
-While formally kernel mutexes are sleepable locks, it is path (ii) that
-makes them more practically a hybrid type. By simply not interrupting a
-task and busy-waiting for a few cycles instead of immediately sleeping,
-the performance of this lock has been seen to significantly improve a
-number of workloads. Note that this technique is also used for rw-semaphores.
-
-Semantics
----------
-
-The mutex subsystem checks and enforces the following rules:
-
-    - Only one task can hold the mutex at a time.
-    - Only the owner can unlock the mutex.
-    - Multiple unlocks are not permitted.
-    - Recursive locking/unlocking is not permitted.
-    - A mutex must only be initialized via the API (see below).
-    - A task may not exit with a mutex held.
-    - Memory areas where held locks reside must not be freed.
-    - Held mutexes must not be reinitialized.
-    - Mutexes may not be used in hardware or software interrupt
-      contexts such as tasklets and timers.
-
-These semantics are fully enforced when CONFIG DEBUG_MUTEXES is enabled.
-In addition, the mutex debugging code also implements a number of other
-features that make lock debugging easier and faster:
-
-    - Uses symbolic names of mutexes, whenever they are printed
-      in debug output.
-    - Point-of-acquire tracking, symbolic lookup of function names,
-      list of all locks held in the system, printout of them.
-    - Owner tracking.
-    - Detects self-recursing locks and prints out all relevant info.
-    - Detects multi-task circular deadlocks and prints out all affected
-      locks and tasks (and only those tasks).
-
-
-Interfaces
-----------
-Statically define the mutex:
-   DEFINE_MUTEX(name);
-
-Dynamically initialize the mutex:
-   mutex_init(mutex);
-
-Acquire the mutex, uninterruptible:
-   void mutex_lock(struct mutex *lock);
-   void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
-   int  mutex_trylock(struct mutex *lock);
-
-Acquire the mutex, interruptible:
-   int mutex_lock_interruptible_nested(struct mutex *lock,
-				       unsigned int subclass);
-   int mutex_lock_interruptible(struct mutex *lock);
-
-Acquire the mutex, interruptible, if dec to 0:
-   int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
-
-Unlock the mutex:
-   void mutex_unlock(struct mutex *lock);
-
-Test if the mutex is taken:
-   int mutex_is_locked(struct mutex *lock);
-
-Disadvantages
--------------
-
-Unlike its original design and purpose, 'struct mutex' is larger than
-most locks in the kernel. E.g: on x86-64 it is 40 bytes, almost twice
-as large as 'struct semaphore' (24 bytes) and 8 bytes shy of the
-'struct rw_semaphore' variant. Larger structure sizes mean more CPU
-cache and memory footprint.
-
-When to use mutexes
--------------------
-
-Unless the strict semantics of mutexes are unsuitable and/or the critical
-region prevents the lock from being shared, always prefer them to any other
-locking primitive.
diff --git a/Documentation/rt-mutex-design.txt b/Documentation/rt-mutex-design.txt
deleted file mode 100644
index 8666070..0000000
--- a/Documentation/rt-mutex-design.txt
+++ /dev/null
@@ -1,781 +0,0 @@
-#
-# Copyright (c) 2006 Steven Rostedt
-# Licensed under the GNU Free Documentation License, Version 1.2
-#
-
-RT-mutex implementation design
-------------------------------
-
-This document tries to describe the design of the rtmutex.c implementation.
-It doesn't describe the reasons why rtmutex.c exists. For that please see
-Documentation/rt-mutex.txt.  Although this document does explain problems
-that happen without this code, but that is in the concept to understand
-what the code actually is doing.
-
-The goal of this document is to help others understand the priority
-inheritance (PI) algorithm that is used, as well as reasons for the
-decisions that were made to implement PI in the manner that was done.
-
-
-Unbounded Priority Inversion
-----------------------------
-
-Priority inversion is when a lower priority process executes while a higher
-priority process wants to run.  This happens for several reasons, and
-most of the time it can't be helped.  Anytime a high priority process wants
-to use a resource that a lower priority process has (a mutex for example),
-the high priority process must wait until the lower priority process is done
-with the resource.  This is a priority inversion.  What we want to prevent
-is something called unbounded priority inversion.  That is when the high
-priority process is prevented from running by a lower priority process for
-an undetermined amount of time.
-
-The classic example of unbounded priority inversion is where you have three
-processes, let's call them processes A, B, and C, where A is the highest
-priority process, C is the lowest, and B is in between. A tries to grab a lock
-that C owns and must wait and lets C run to release the lock. But in the
-meantime, B executes, and since B is of a higher priority than C, it preempts C,
-but by doing so, it is in fact preempting A which is a higher priority process.
-Now there's no way of knowing how long A will be sleeping waiting for C
-to release the lock, because for all we know, B is a CPU hog and will
-never give C a chance to release the lock.  This is called unbounded priority
-inversion.
-
-Here's a little ASCII art to show the problem.
-
-   grab lock L1 (owned by C)
-     |
-A ---+
-        C preempted by B
-          |
-C    +----+
-
-B         +-------->
-                B now keeps A from running.
-
-
-Priority Inheritance (PI)
--------------------------
-
-There are several ways to solve this issue, but other ways are out of scope
-for this document.  Here we only discuss PI.
-
-PI is where a process inherits the priority of another process if the other
-process blocks on a lock owned by the current process.  To make this easier
-to understand, let's use the previous example, with processes A, B, and C again.
-
-This time, when A blocks on the lock owned by C, C would inherit the priority
-of A.  So now if B becomes runnable, it would not preempt C, since C now has
-the high priority of A.  As soon as C releases the lock, it loses its
-inherited priority, and A then can continue with the resource that C had.
-
-Terminology
------------
-
-Here I explain some terminology that is used in this document to help describe
-the design that is used to implement PI.
-
-PI chain - The PI chain is an ordered series of locks and processes that cause
-           processes to inherit priorities from a previous process that is
-           blocked on one of its locks.  This is described in more detail
-           later in this document.
-
-mutex    - In this document, to differentiate from locks that implement
-           PI and spin locks that are used in the PI code, from now on
-           the PI locks will be called a mutex.
-
-lock     - In this document from now on, I will use the term lock when
-           referring to spin locks that are used to protect parts of the PI
-           algorithm.  These locks disable preemption for UP (when
-           CONFIG_PREEMPT is enabled) and on SMP prevents multiple CPUs from
-           entering critical sections simultaneously.
-
-spin lock - Same as lock above.
-
-waiter   - A waiter is a struct that is stored on the stack of a blocked
-           process.  Since the scope of the waiter is within the code for
-           a process being blocked on the mutex, it is fine to allocate
-           the waiter on the process's stack (local variable).  This
-           structure holds a pointer to the task, as well as the mutex that
-           the task is blocked on.  It also has the plist node structures to
-           place the task in the waiter_list of a mutex as well as the
-           pi_list of a mutex owner task (described below).
-
-           waiter is sometimes used in reference to the task that is waiting
-           on a mutex. This is the same as waiter->task.
-
-waiters  - A list of processes that are blocked on a mutex.
-
-top waiter - The highest priority process waiting on a specific mutex.
-
-top pi waiter - The highest priority process waiting on one of the mutexes
-                that a specific process owns.
-
-Note:  task and process are used interchangeably in this document, mostly to
-       differentiate between two processes that are being described together.
-
-
-PI chain
---------
-
-The PI chain is a list of processes and mutexes that may cause priority
-inheritance to take place.  Multiple chains may converge, but a chain
-would never diverge, since a process can't be blocked on more than one
-mutex at a time.
-
-Example:
-
-   Process:  A, B, C, D, E
-   Mutexes:  L1, L2, L3, L4
-
-   A owns: L1
-           B blocked on L1
-           B owns L2
-                  C blocked on L2
-                  C owns L3
-                         D blocked on L3
-                         D owns L4
-                                E blocked on L4
-
-The chain would be:
-
-   E->L4->D->L3->C->L2->B->L1->A
-
-To show where two chains merge, we could add another process F and
-another mutex L5 where B owns L5 and F is blocked on mutex L5.
-
-The chain for F would be:
-
-   F->L5->B->L1->A
-
-Since a process may own more than one mutex, but never be blocked on more than
-one, the chains merge.
-
-Here we show both chains:
-
-   E->L4->D->L3->C->L2-+
-                       |
-                       +->B->L1->A
-                       |
-                 F->L5-+
-
-For PI to work, the processes at the right end of these chains (or we may
-also call it the Top of the chain) must be equal to or higher in priority
-than the processes to the left or below in the chain.
-
-Also since a mutex may have more than one process blocked on it, we can
-have multiple chains merge at mutexes.  If we add another process G that is
-blocked on mutex L2:
-
-  G->L2->B->L1->A
-
-And once again, to show how this can grow I will show the merging chains
-again.
-
-   E->L4->D->L3->C-+
-                   +->L2-+
-                   |     |
-                 G-+     +->B->L1->A
-                         |
-                   F->L5-+
-
-
-Plist
------
-
-Before I go further and talk about how the PI chain is stored through lists
-on both mutexes and processes, I'll explain the plist.  This is similar to
-the struct list_head functionality that is already in the kernel.
-The implementation of plist is out of scope for this document, but it is
-very important to understand what it does.
-
-There are a few differences between plist and list, the most important one
-being that plist is a priority sorted linked list.  This means that the
-priorities of the plist are sorted, such that it takes O(1) to retrieve the
-highest priority item in the list.  Obviously this is useful to store processes
-based on their priorities.
-
-Another difference, which is important for implementation, is that, unlike
-list, the head of the list is a different element than the nodes of a list.
-So the head of the list is declared as struct plist_head and nodes that will
-be added to the list are declared as struct plist_node.
-
-
-Mutex Waiter List
------------------
-
-Every mutex keeps track of all the waiters that are blocked on itself. The mutex
-has a plist to store these waiters by priority.  This list is protected by
-a spin lock that is located in the struct of the mutex. This lock is called
-wait_lock.  Since the modification of the waiter list is never done in
-interrupt context, the wait_lock can be taken without disabling interrupts.
-
-
-Task PI List
-------------
-
-To keep track of the PI chains, each process has its own PI list.  This is
-a list of all top waiters of the mutexes that are owned by the process.
-Note that this list only holds the top waiters and not all waiters that are
-blocked on mutexes owned by the process.
-
-The top of the task's PI list is always the highest priority task that
-is waiting on a mutex that is owned by the task.  So if the task has
-inherited a priority, it will always be the priority of the task that is
-at the top of this list.
-
-This list is stored in the task structure of a process as a plist called
-pi_list.  This list is protected by a spin lock also in the task structure,
-called pi_lock.  This lock may also be taken in interrupt context, so when
-locking the pi_lock, interrupts must be disabled.
-
-
-Depth of the PI Chain
----------------------
-
-The maximum depth of the PI chain is not dynamic, and could actually be
-defined.  But is very complex to figure it out, since it depends on all
-the nesting of mutexes.  Let's look at the example where we have 3 mutexes,
-L1, L2, and L3, and four separate functions func1, func2, func3 and func4.
-The following shows a locking order of L1->L2->L3, but may not actually
-be directly nested that way.
-
-void func1(void)
-{
-	mutex_lock(L1);
-
-	/* do anything */
-
-	mutex_unlock(L1);
-}
-
-void func2(void)
-{
-	mutex_lock(L1);
-	mutex_lock(L2);
-
-	/* do something */
-
-	mutex_unlock(L2);
-	mutex_unlock(L1);
-}
-
-void func3(void)
-{
-	mutex_lock(L2);
-	mutex_lock(L3);
-
-	/* do something else */
-
-	mutex_unlock(L3);
-	mutex_unlock(L2);
-}
-
-void func4(void)
-{
-	mutex_lock(L3);
-
-	/* do something again */
-
-	mutex_unlock(L3);
-}
-
-Now we add 4 processes that run each of these functions separately.
-Processes A, B, C, and D which run functions func1, func2, func3 and func4
-respectively, and such that D runs first and A last.  With D being preempted
-in func4 in the "do something again" area, we have a locking that follows:
-
-D owns L3
-       C blocked on L3
-       C owns L2
-              B blocked on L2
-              B owns L1
-                     A blocked on L1
-
-And thus we have the chain A->L1->B->L2->C->L3->D.
-
-This gives us a PI depth of 4 (four processes), but looking at any of the
-functions individually, it seems as though they only have at most a locking
-depth of two.  So, although the locking depth is defined at compile time,
-it still is very difficult to find the possibilities of that depth.
-
-Now since mutexes can be defined by user-land applications, we don't want a DOS
-type of application that nests large amounts of mutexes to create a large
-PI chain, and have the code holding spin locks while looking at a large
-amount of data.  So to prevent this, the implementation not only implements
-a maximum lock depth, but also only holds at most two different locks at a
-time, as it walks the PI chain.  More about this below.
-
-
-Mutex owner and flags
----------------------
-
-The mutex structure contains a pointer to the owner of the mutex.  If the
-mutex is not owned, this owner is set to NULL.  Since all architectures
-have the task structure on at least a four byte alignment (and if this is
-not true, the rtmutex.c code will be broken!), this allows for the two
-least significant bits to be used as flags.  This part is also described
-in Documentation/rt-mutex.txt, but will also be briefly described here.
-
-Bit 0 is used as the "Pending Owner" flag.  This is described later.
-Bit 1 is used as the "Has Waiters" flags.  This is also described later
-  in more detail, but is set whenever there are waiters on a mutex.
-
-
-cmpxchg Tricks
---------------
-
-Some architectures implement an atomic cmpxchg (Compare and Exchange).  This
-is used (when applicable) to keep the fast path of grabbing and releasing
-mutexes short.
-
-cmpxchg is basically the following function performed atomically:
-
-unsigned long _cmpxchg(unsigned long *A, unsigned long *B, unsigned long *C)
-{
-	unsigned long T = *A;
-	if (*A == *B) {
-		*A = *C;
-	}
-	return T;
-}
-#define cmpxchg(a,b,c) _cmpxchg(&a,&b,&c)
-
-This is really nice to have, since it allows you to only update a variable
-if the variable is what you expect it to be.  You know if it succeeded if
-the return value (the old value of A) is equal to B.
-
-The macro rt_mutex_cmpxchg is used to try to lock and unlock mutexes. If
-the architecture does not support CMPXCHG, then this macro is simply set
-to fail every time.  But if CMPXCHG is supported, then this will
-help out extremely to keep the fast path short.
-
-The use of rt_mutex_cmpxchg with the flags in the owner field help optimize
-the system for architectures that support it.  This will also be explained
-later in this document.
-
-
-Priority adjustments
---------------------
-
-The implementation of the PI code in rtmutex.c has several places that a
-process must adjust its priority.  With the help of the pi_list of a
-process this is rather easy to know what needs to be adjusted.
-
-The functions implementing the task adjustments are rt_mutex_adjust_prio,
-__rt_mutex_adjust_prio (same as the former, but expects the task pi_lock
-to already be taken), rt_mutex_getprio, and rt_mutex_setprio.
-
-rt_mutex_getprio and rt_mutex_setprio are only used in __rt_mutex_adjust_prio.
-
-rt_mutex_getprio returns the priority that the task should have.  Either the
-task's own normal priority, or if a process of a higher priority is waiting on
-a mutex owned by the task, then that higher priority should be returned.
-Since the pi_list of a task holds an order by priority list of all the top
-waiters of all the mutexes that the task owns, rt_mutex_getprio simply needs
-to compare the top pi waiter to its own normal priority, and return the higher
-priority back.
-
-(Note:  if looking at the code, you will notice that the lower number of
-        prio is returned.  This is because the prio field in the task structure
-        is an inverse order of the actual priority.  So a "prio" of 5 is
-        of higher priority than a "prio" of 10.)
-
-__rt_mutex_adjust_prio examines the result of rt_mutex_getprio, and if the
-result does not equal the task's current priority, then rt_mutex_setprio
-is called to adjust the priority of the task to the new priority.
-Note that rt_mutex_setprio is defined in kernel/sched/core.c to implement the
-actual change in priority.
-
-It is interesting to note that __rt_mutex_adjust_prio can either increase
-or decrease the priority of the task.  In the case that a higher priority
-process has just blocked on a mutex owned by the task, __rt_mutex_adjust_prio
-would increase/boost the task's priority.  But if a higher priority task
-were for some reason to leave the mutex (timeout or signal), this same function
-would decrease/unboost the priority of the task.  That is because the pi_list
-always contains the highest priority task that is waiting on a mutex owned
-by the task, so we only need to compare the priority of that top pi waiter
-to the normal priority of the given task.
-
-
-High level overview of the PI chain walk
-----------------------------------------
-
-The PI chain walk is implemented by the function rt_mutex_adjust_prio_chain.
-
-The implementation has gone through several iterations, and has ended up
-with what we believe is the best.  It walks the PI chain by only grabbing
-at most two locks at a time, and is very efficient.
-
-The rt_mutex_adjust_prio_chain can be used either to boost or lower process
-priorities.
-
-rt_mutex_adjust_prio_chain is called with a task to be checked for PI
-(de)boosting (the owner of a mutex that a process is blocking on), a flag to
-check for deadlocking, the mutex that the task owns, and a pointer to a waiter
-that is the process's waiter struct that is blocked on the mutex (although this
-parameter may be NULL for deboosting).
-
-For this explanation, I will not mention deadlock detection. This explanation
-will try to stay at a high level.
-
-When this function is called, there are no locks held.  That also means
-that the state of the owner and lock can change when entered into this function.
-
-Before this function is called, the task has already had rt_mutex_adjust_prio
-performed on it.  This means that the task is set to the priority that it
-should be at, but the plist nodes of the task's waiter have not been updated
-with the new priorities, and that this task may not be in the proper locations
-in the pi_lists and wait_lists that the task is blocked on.  This function
-solves all that.
-
-A loop is entered, where task is the owner to be checked for PI changes that
-was passed by parameter (for the first iteration).  The pi_lock of this task is
-taken to prevent any more changes to the pi_list of the task.  This also
-prevents new tasks from completing the blocking on a mutex that is owned by this
-task.
-
-If the task is not blocked on a mutex then the loop is exited.  We are at
-the top of the PI chain.
-
-A check is now done to see if the original waiter (the process that is blocked
-on the current mutex) is the top pi waiter of the task.  That is, is this
-waiter on the top of the task's pi_list.  If it is not, it either means that
-there is another process higher in priority that is blocked on one of the
-mutexes that the task owns, or that the waiter has just woken up via a signal
-or timeout and has left the PI chain.  In either case, the loop is exited, since
-we don't need to do any more changes to the priority of the current task, or any
-task that owns a mutex that this current task is waiting on.  A priority chain
-walk is only needed when a new top pi waiter is made to a task.
-
-The next check sees if the task's waiter plist node has the priority equal to
-the priority the task is set at.  If they are equal, then we are done with
-the loop.  Remember that the function started with the priority of the
-task adjusted, but the plist nodes that hold the task in other processes
-pi_lists have not been adjusted.
-
-Next, we look at the mutex that the task is blocked on. The mutex's wait_lock
-is taken.  This is done by a spin_trylock, because the locking order of the
-pi_lock and wait_lock goes in the opposite direction. If we fail to grab the
-lock, the pi_lock is released, and we restart the loop.
-
-Now that we have both the pi_lock of the task as well as the wait_lock of
-the mutex the task is blocked on, we update the task's waiter's plist node
-that is located on the mutex's wait_list.
-
-Now we release the pi_lock of the task.
-
-Next the owner of the mutex has its pi_lock taken, so we can update the
-task's entry in the owner's pi_list.  If the task is the highest priority
-process on the mutex's wait_list, then we remove the previous top waiter
-from the owner's pi_list, and replace it with the task.
-
-Note: It is possible that the task was the current top waiter on the mutex,
-      in which case the task is not yet on the pi_list of the waiter.  This
-      is OK, since plist_del does nothing if the plist node is not on any
-      list.
-
-If the task was not the top waiter of the mutex, but it was before we
-did the priority updates, that means we are deboosting/lowering the
-task.  In this case, the task is removed from the pi_list of the owner,
-and the new top waiter is added.
-
-Lastly, we unlock both the pi_lock of the task, as well as the mutex's
-wait_lock, and continue the loop again.  On the next iteration of the
-loop, the previous owner of the mutex will be the task that will be
-processed.
-
-Note: One might think that the owner of this mutex might have changed
-      since we just grab the mutex's wait_lock. And one could be right.
-      The important thing to remember is that the owner could not have
-      become the task that is being processed in the PI chain, since
-      we have taken that task's pi_lock at the beginning of the loop.
-      So as long as there is an owner of this mutex that is not the same
-      process as the tasked being worked on, we are OK.
-
-      Looking closely at the code, one might be confused.  The check for the
-      end of the PI chain is when the task isn't blocked on anything or the
-      task's waiter structure "task" element is NULL.  This check is
-      protected only by the task's pi_lock.  But the code to unlock the mutex
-      sets the task's waiter structure "task" element to NULL with only
-      the protection of the mutex's wait_lock, which was not taken yet.
-      Isn't this a race condition if the task becomes the new owner?
-
-      The answer is No!  The trick is the spin_trylock of the mutex's
-      wait_lock.  If we fail that lock, we release the pi_lock of the
-      task and continue the loop, doing the end of PI chain check again.
-
-      In the code to release the lock, the wait_lock of the mutex is held
-      the entire time, and it is not let go when we grab the pi_lock of the
-      new owner of the mutex.  So if the switch of a new owner were to happen
-      after the check for end of the PI chain and the grabbing of the
-      wait_lock, the unlocking code would spin on the new owner's pi_lock
-      but never give up the wait_lock.  So the PI chain loop is guaranteed to
-      fail the spin_trylock on the wait_lock, release the pi_lock, and
-      try again.
-
-      If you don't quite understand the above, that's OK. You don't have to,
-      unless you really want to make a proof out of it ;)
-
-
-Pending Owners and Lock stealing
---------------------------------
-
-One of the flags in the owner field of the mutex structure is "Pending Owner".
-What this means is that an owner was chosen by the process releasing the
-mutex, but that owner has yet to wake up and actually take the mutex.
-
-Why is this important?  Why can't we just give the mutex to another process
-and be done with it?
-
-The PI code is to help with real-time processes, and to let the highest
-priority process run as long as possible with little latencies and delays.
-If a high priority process owns a mutex that a lower priority process is
-blocked on, when the mutex is released it would be given to the lower priority
-process.  What if the higher priority process wants to take that mutex again.
-The high priority process would fail to take that mutex that it just gave up
-and it would need to boost the lower priority process to run with full
-latency of that critical section (since the low priority process just entered
-it).
-
-There's no reason a high priority process that gives up a mutex should be
-penalized if it tries to take that mutex again.  If the new owner of the
-mutex has not woken up yet, there's no reason that the higher priority process
-could not take that mutex away.
-
-To solve this, we introduced Pending Ownership and Lock Stealing.  When a
-new process is given a mutex that it was blocked on, it is only given
-pending ownership.  This means that it's the new owner, unless a higher
-priority process comes in and tries to grab that mutex.  If a higher priority
-process does come along and wants that mutex, we let the higher priority
-process "steal" the mutex from the pending owner (only if it is still pending)
-and continue with the mutex.
-
-
-Taking of a mutex (The walk through)
-------------------------------------
-
-OK, now let's take a look at the detailed walk through of what happens when
-taking a mutex.
-
-The first thing that is tried is the fast taking of the mutex.  This is
-done when we have CMPXCHG enabled (otherwise the fast taking automatically
-fails).  Only when the owner field of the mutex is NULL can the lock be
-taken with the CMPXCHG and nothing else needs to be done.
-
-If there is contention on the lock, whether it is owned or pending owner
-we go about the slow path (rt_mutex_slowlock).
-
-The slow path function is where the task's waiter structure is created on
-the stack.  This is because the waiter structure is only needed for the
-scope of this function.  The waiter structure holds the nodes to store
-the task on the wait_list of the mutex, and if need be, the pi_list of
-the owner.
-
-The wait_lock of the mutex is taken since the slow path of unlocking the
-mutex also takes this lock.
-
-We then call try_to_take_rt_mutex.  This is where the architecture that
-does not implement CMPXCHG would always grab the lock (if there's no
-contention).
-
-try_to_take_rt_mutex is used every time the task tries to grab a mutex in the
-slow path.  The first thing that is done here is an atomic setting of
-the "Has Waiters" flag of the mutex's owner field.  Yes, this could really
-be false, because if the mutex has no owner, there are no waiters and
-the current task also won't have any waiters.  But we don't have the lock
-yet, so we assume we are going to be a waiter.  The reason for this is to
-play nice for those architectures that do have CMPXCHG.  By setting this flag
-now, the owner of the mutex can't release the mutex without going into the
-slow unlock path, and it would then need to grab the wait_lock, which this
-code currently holds.  So setting the "Has Waiters" flag forces the owner
-to synchronize with this code.
-
-Now that we know that we can't have any races with the owner releasing the
-mutex, we check to see if we can take the ownership.  This is done if the
-mutex doesn't have a owner, or if we can steal the mutex from a pending
-owner.  Let's look at the situations we have here.
-
-  1) Has owner that is pending
-  ----------------------------
-
-  The mutex has a owner, but it hasn't woken up and the mutex flag
-  "Pending Owner" is set.  The first check is to see if the owner isn't the
-  current task.  This is because this function is also used for the pending
-  owner to grab the mutex.  When a pending owner wakes up, it checks to see
-  if it can take the mutex, and this is done if the owner is already set to
-  itself.  If so, we succeed and leave the function, clearing the "Pending
-  Owner" bit.
-
-  If the pending owner is not current, we check to see if the current priority is
-  higher than the pending owner.  If not, we fail the function and return.
-
-  There's also something special about a pending owner.  That is a pending owner
-  is never blocked on a mutex.  So there is no PI chain to worry about.  It also
-  means that if the mutex doesn't have any waiters, there's no accounting needed
-  to update the pending owner's pi_list, since we only worry about processes
-  blocked on the current mutex.
-
-  If there are waiters on this mutex, and we just stole the ownership, we need
-  to take the top waiter, remove it from the pi_list of the pending owner, and
-  add it to the current pi_list.  Note that at this moment, the pending owner
-  is no longer on the list of waiters.  This is fine, since the pending owner
-  would add itself back when it realizes that it had the ownership stolen
-  from itself.  When the pending owner tries to grab the mutex, it will fail
-  in try_to_take_rt_mutex if the owner field points to another process.
-
-  2) No owner
-  -----------
-
-  If there is no owner (or we successfully stole the lock), we set the owner
-  of the mutex to current, and set the flag of "Has Waiters" if the current
-  mutex actually has waiters, or we clear the flag if it doesn't.  See, it was
-  OK that we set that flag early, since now it is cleared.
-
-  3) Failed to grab ownership
-  ---------------------------
-
-  The most interesting case is when we fail to take ownership. This means that
-  there exists an owner, or there's a pending owner with equal or higher
-  priority than the current task.
-
-We'll continue on the failed case.
-
-If the mutex has a timeout, we set up a timer to go off to break us out
-of this mutex if we failed to get it after a specified amount of time.
-
-Now we enter a loop that will continue to try to take ownership of the mutex, or
-fail from a timeout or signal.
-
-Once again we try to take the mutex.  This will usually fail the first time
-in the loop, since it had just failed to get the mutex.  But the second time
-in the loop, this would likely succeed, since the task would likely be
-the pending owner.
-
-If the mutex is TASK_INTERRUPTIBLE a check for signals and timeout is done
-here.
-
-The waiter structure has a "task" field that points to the task that is blocked
-on the mutex.  This field can be NULL the first time it goes through the loop
-or if the task is a pending owner and had its mutex stolen.  If the "task"
-field is NULL then we need to set up the accounting for it.
-
-Task blocks on mutex
---------------------
-
-The accounting of a mutex and process is done with the waiter structure of
-the process.  The "task" field is set to the process, and the "lock" field
-to the mutex.  The plist nodes are initialized to the processes current
-priority.
-
-Since the wait_lock was taken at the entry of the slow lock, we can safely
-add the waiter to the wait_list.  If the current process is the highest
-priority process currently waiting on this mutex, then we remove the
-previous top waiter process (if it exists) from the pi_list of the owner,
-and add the current process to that list.  Since the pi_list of the owner
-has changed, we call rt_mutex_adjust_prio on the owner to see if the owner
-should adjust its priority accordingly.
-
-If the owner is also blocked on a lock, and had its pi_list changed
-(or deadlock checking is on), we unlock the wait_lock of the mutex and go ahead
-and run rt_mutex_adjust_prio_chain on the owner, as described earlier.
-
-Now all locks are released, and if the current process is still blocked on a
-mutex (waiter "task" field is not NULL), then we go to sleep (call schedule).
-
-Waking up in the loop
----------------------
-
-The schedule can then wake up for a few reasons.
-  1) we were given pending ownership of the mutex.
-  2) we received a signal and was TASK_INTERRUPTIBLE
-  3) we had a timeout and was TASK_INTERRUPTIBLE
-
-In any of these cases, we continue the loop and once again try to grab the
-ownership of the mutex.  If we succeed, we exit the loop, otherwise we continue
-and on signal and timeout, will exit the loop, or if we had the mutex stolen
-we just simply add ourselves back on the lists and go back to sleep.
-
-Note: For various reasons, because of timeout and signals, the steal mutex
-      algorithm needs to be careful. This is because the current process is
-      still on the wait_list. And because of dynamic changing of priorities,
-      especially on SCHED_OTHER tasks, the current process can be the
-      highest priority task on the wait_list.
-
-Failed to get mutex on Timeout or Signal
-----------------------------------------
-
-If a timeout or signal occurred, the waiter's "task" field would not be
-NULL and the task needs to be taken off the wait_list of the mutex and perhaps
-pi_list of the owner.  If this process was a high priority process, then
-the rt_mutex_adjust_prio_chain needs to be executed again on the owner,
-but this time it will be lowering the priorities.
-
-
-Unlocking the Mutex
--------------------
-
-The unlocking of a mutex also has a fast path for those architectures with
-CMPXCHG.  Since the taking of a mutex on contention always sets the
-"Has Waiters" flag of the mutex's owner, we use this to know if we need to
-take the slow path when unlocking the mutex.  If the mutex doesn't have any
-waiters, the owner field of the mutex would equal the current process and
-the mutex can be unlocked by just replacing the owner field with NULL.
-
-If the owner field has the "Has Waiters" bit set (or CMPXCHG is not available),
-the slow unlock path is taken.
-
-The first thing done in the slow unlock path is to take the wait_lock of the
-mutex.  This synchronizes the locking and unlocking of the mutex.
-
-A check is made to see if the mutex has waiters or not.  On architectures that
-do not have CMPXCHG, this is the location that the owner of the mutex will
-determine if a waiter needs to be awoken or not.  On architectures that
-do have CMPXCHG, that check is done in the fast path, but it is still needed
-in the slow path too.  If a waiter of a mutex woke up because of a signal
-or timeout between the time the owner failed the fast path CMPXCHG check and
-the grabbing of the wait_lock, the mutex may not have any waiters, thus the
-owner still needs to make this check. If there are no waiters then the mutex
-owner field is set to NULL, the wait_lock is released and nothing more is
-needed.
-
-If there are waiters, then we need to wake one up and give that waiter
-pending ownership.
-
-On the wake up code, the pi_lock of the current owner is taken.  The top
-waiter of the lock is found and removed from the wait_list of the mutex
-as well as the pi_list of the current owner.  The task field of the new
-pending owner's waiter structure is set to NULL, and the owner field of the
-mutex is set to the new owner with the "Pending Owner" bit set, as well
-as the "Has Waiters" bit if there still are other processes blocked on the
-mutex.
-
-The pi_lock of the previous owner is released, and the new pending owner's
-pi_lock is taken.  Remember that this is the trick to prevent the race
-condition in rt_mutex_adjust_prio_chain from adding itself as a waiter
-on the mutex.
-
-We now clear the "pi_blocked_on" field of the new pending owner, and if
-the mutex still has waiters pending, we add the new top waiter to the pi_list
-of the pending owner.
-
-Finally we unlock the pi_lock of the pending owner and wake it up.
-
-
-Contact
--------
-
-For updates on this document, please email Steven Rostedt <rostedt@goodmis.org>
-
-
-Credits
--------
-
-Author:  Steven Rostedt <rostedt@goodmis.org>
-
-Reviewers:  Ingo Molnar, Thomas Gleixner, Thomas Duetsch, and Randy Dunlap
-
-Updates
--------
-
-This document was originally written for 2.6.17-rc3-mm1
diff --git a/Documentation/rt-mutex.txt b/Documentation/rt-mutex.txt
deleted file mode 100644
index 243393d..0000000
--- a/Documentation/rt-mutex.txt
+++ /dev/null
@@ -1,79 +0,0 @@
-RT-mutex subsystem with PI support
-----------------------------------
-
-RT-mutexes with priority inheritance are used to support PI-futexes,
-which enable pthread_mutex_t priority inheritance attributes
-(PTHREAD_PRIO_INHERIT). [See Documentation/pi-futex.txt for more details
-about PI-futexes.]
-
-This technology was developed in the -rt tree and streamlined for
-pthread_mutex support.
-
-Basic principles:
------------------
-
-RT-mutexes extend the semantics of simple mutexes by the priority
-inheritance protocol.
-
-A low priority owner of a rt-mutex inherits the priority of a higher
-priority waiter until the rt-mutex is released. If the temporarily
-boosted owner blocks on a rt-mutex itself it propagates the priority
-boosting to the owner of the other rt_mutex it gets blocked on. The
-priority boosting is immediately removed once the rt_mutex has been
-unlocked.
-
-This approach allows us to shorten the block of high-prio tasks on
-mutexes which protect shared resources. Priority inheritance is not a
-magic bullet for poorly designed applications, but it allows
-well-designed applications to use userspace locks in critical parts of
-an high priority thread, without losing determinism.
-
-The enqueueing of the waiters into the rtmutex waiter list is done in
-priority order. For same priorities FIFO order is chosen. For each
-rtmutex, only the top priority waiter is enqueued into the owner's
-priority waiters list. This list too queues in priority order. Whenever
-the top priority waiter of a task changes (for example it timed out or
-got a signal), the priority of the owner task is readjusted. [The
-priority enqueueing is handled by "plists", see include/linux/plist.h
-for more details.]
-
-RT-mutexes are optimized for fastpath operations and have no internal
-locking overhead when locking an uncontended mutex or unlocking a mutex
-without waiters. The optimized fastpath operations require cmpxchg
-support. [If that is not available then the rt-mutex internal spinlock
-is used]
-
-The state of the rt-mutex is tracked via the owner field of the rt-mutex
-structure:
-
-rt_mutex->owner holds the task_struct pointer of the owner. Bit 0 and 1
-are used to keep track of the "owner is pending" and "rtmutex has
-waiters" state.
-
- owner		bit1	bit0
- NULL		0	0	mutex is free (fast acquire possible)
- NULL		0	1	invalid state
- NULL		1	0	Transitional state*
- NULL		1	1	invalid state
- taskpointer	0	0	mutex is held (fast release possible)
- taskpointer	0	1	task is pending owner
- taskpointer	1	0	mutex is held and has waiters
- taskpointer	1	1	task is pending owner and mutex has waiters
-
-Pending-ownership handling is a performance optimization:
-pending-ownership is assigned to the first (highest priority) waiter of
-the mutex, when the mutex is released. The thread is woken up and once
-it starts executing it can acquire the mutex. Until the mutex is taken
-by it (bit 0 is cleared) a competing higher priority thread can "steal"
-the mutex which puts the woken up thread back on the waiters list.
-
-The pending-ownership optimization is especially important for the
-uninterrupted workflow of high-prio tasks which repeatedly
-takes/releases locks that have lower-prio waiters. Without this
-optimization the higher-prio thread would ping-pong to the lower-prio
-task [because at unlock time we always assign a new owner].
-
-(*) The "mutex has waiters" bit gets set to take the lock. If the lock
-doesn't already have an owner, this bit is quickly cleared if there are
-no waiters.  So this is a transitional state to synchronize with looking
-at the owner field of the mutex and the mutex owner releasing the lock.
diff --git a/Documentation/spinlocks.txt b/Documentation/spinlocks.txt
deleted file mode 100644
index 97eaf57..0000000
--- a/Documentation/spinlocks.txt
+++ /dev/null
@@ -1,167 +0,0 @@
-Lesson 1: Spin locks
-
-The most basic primitive for locking is spinlock.
-
-static DEFINE_SPINLOCK(xxx_lock);
-
-	unsigned long flags;
-
-	spin_lock_irqsave(&xxx_lock, flags);
-	... critical section here ..
-	spin_unlock_irqrestore(&xxx_lock, flags);
-
-The above is always safe. It will disable interrupts _locally_, but the
-spinlock itself will guarantee the global lock, so it will guarantee that
-there is only one thread-of-control within the region(s) protected by that
-lock. This works well even under UP also, so the code does _not_ need to
-worry about UP vs SMP issues: the spinlocks work correctly under both.
-
-   NOTE! Implications of spin_locks for memory are further described in:
-
-     Documentation/memory-barriers.txt
-       (5) LOCK operations.
-       (6) UNLOCK operations.
-
-The above is usually pretty simple (you usually need and want only one
-spinlock for most things - using more than one spinlock can make things a
-lot more complex and even slower and is usually worth it only for
-sequences that you _know_ need to be split up: avoid it at all cost if you
-aren't sure).
-
-This is really the only really hard part about spinlocks: once you start
-using spinlocks they tend to expand to areas you might not have noticed
-before, because you have to make sure the spinlocks correctly protect the
-shared data structures _everywhere_ they are used. The spinlocks are most
-easily added to places that are completely independent of other code (for
-example, internal driver data structures that nobody else ever touches).
-
-   NOTE! The spin-lock is safe only when you _also_ use the lock itself
-   to do locking across CPU's, which implies that EVERYTHING that
-   touches a shared variable has to agree about the spinlock they want
-   to use.
-
-----
-
-Lesson 2: reader-writer spinlocks.
-
-If your data accesses have a very natural pattern where you usually tend
-to mostly read from the shared variables, the reader-writer locks
-(rw_lock) versions of the spinlocks are sometimes useful. They allow multiple
-readers to be in the same critical region at once, but if somebody wants
-to change the variables it has to get an exclusive write lock.
-
-   NOTE! reader-writer locks require more atomic memory operations than
-   simple spinlocks.  Unless the reader critical section is long, you
-   are better off just using spinlocks.
-
-The routines look the same as above:
-
-   rwlock_t xxx_lock = __RW_LOCK_UNLOCKED(xxx_lock);
-
-	unsigned long flags;
-
-	read_lock_irqsave(&xxx_lock, flags);
-	.. critical section that only reads the info ...
-	read_unlock_irqrestore(&xxx_lock, flags);
-
-	write_lock_irqsave(&xxx_lock, flags);
-	.. read and write exclusive access to the info ...
-	write_unlock_irqrestore(&xxx_lock, flags);
-
-The above kind of lock may be useful for complex data structures like
-linked lists, especially searching for entries without changing the list
-itself.  The read lock allows many concurrent readers.  Anything that
-_changes_ the list will have to get the write lock.
-
-   NOTE! RCU is better for list traversal, but requires careful
-   attention to design detail (see Documentation/RCU/listRCU.txt).
-
-Also, you cannot "upgrade" a read-lock to a write-lock, so if you at _any_
-time need to do any changes (even if you don't do it every time), you have
-to get the write-lock at the very beginning.
-
-   NOTE! We are working hard to remove reader-writer spinlocks in most
-   cases, so please don't add a new one without consensus.  (Instead, see
-   Documentation/RCU/rcu.txt for complete information.)
-
-----
-
-Lesson 3: spinlocks revisited.
-
-The single spin-lock primitives above are by no means the only ones. They
-are the most safe ones, and the ones that work under all circumstances,
-but partly _because_ they are safe they are also fairly slow. They are slower
-than they'd need to be, because they do have to disable interrupts
-(which is just a single instruction on a x86, but it's an expensive one -
-and on other architectures it can be worse).
-
-If you have a case where you have to protect a data structure across
-several CPU's and you want to use spinlocks you can potentially use
-cheaper versions of the spinlocks. IFF you know that the spinlocks are
-never used in interrupt handlers, you can use the non-irq versions:
-
-	spin_lock(&lock);
-	...
-	spin_unlock(&lock);
-
-(and the equivalent read-write versions too, of course). The spinlock will
-guarantee the same kind of exclusive access, and it will be much faster. 
-This is useful if you know that the data in question is only ever
-manipulated from a "process context", ie no interrupts involved. 
-
-The reasons you mustn't use these versions if you have interrupts that
-play with the spinlock is that you can get deadlocks:
-
-	spin_lock(&lock);
-	...
-		<- interrupt comes in:
-			spin_lock(&lock);
-
-where an interrupt tries to lock an already locked variable. This is ok if
-the other interrupt happens on another CPU, but it is _not_ ok if the
-interrupt happens on the same CPU that already holds the lock, because the
-lock will obviously never be released (because the interrupt is waiting
-for the lock, and the lock-holder is interrupted by the interrupt and will
-not continue until the interrupt has been processed). 
-
-(This is also the reason why the irq-versions of the spinlocks only need
-to disable the _local_ interrupts - it's ok to use spinlocks in interrupts
-on other CPU's, because an interrupt on another CPU doesn't interrupt the
-CPU that holds the lock, so the lock-holder can continue and eventually
-releases the lock). 
-
-Note that you can be clever with read-write locks and interrupts. For
-example, if you know that the interrupt only ever gets a read-lock, then
-you can use a non-irq version of read locks everywhere - because they
-don't block on each other (and thus there is no dead-lock wrt interrupts. 
-But when you do the write-lock, you have to use the irq-safe version. 
-
-For an example of being clever with rw-locks, see the "waitqueue_lock" 
-handling in kernel/sched/core.c - nothing ever _changes_ a wait-queue from
-within an interrupt, they only read the queue in order to know whom to
-wake up. So read-locks are safe (which is good: they are very common
-indeed), while write-locks need to protect themselves against interrupts.
-
-		Linus
-
-----
-
-Reference information:
-
-For dynamic initialization, use spin_lock_init() or rwlock_init() as
-appropriate:
-
-   spinlock_t xxx_lock;
-   rwlock_t xxx_rw_lock;
-
-   static int __init xxx_init(void)
-   {
-	spin_lock_init(&xxx_lock);
-	rwlock_init(&xxx_rw_lock);
-	...
-   }
-
-   module_init(xxx_init);
-
-For static initialization, use DEFINE_SPINLOCK() / DEFINE_RWLOCK() or
-__SPIN_LOCK_UNLOCKED() / __RW_LOCK_UNLOCKED() as appropriate.
diff --git a/Documentation/ww-mutex-design.txt b/Documentation/ww-mutex-design.txt
deleted file mode 100644
index 8a112dc..0000000
--- a/Documentation/ww-mutex-design.txt
+++ /dev/null
@@ -1,344 +0,0 @@
-Wait/Wound Deadlock-Proof Mutex Design
-======================================
-
-Please read mutex-design.txt first, as it applies to wait/wound mutexes too.
-
-Motivation for WW-Mutexes
--------------------------
-
-GPU's do operations that commonly involve many buffers.  Those buffers
-can be shared across contexts/processes, exist in different memory
-domains (for example VRAM vs system memory), and so on.  And with
-PRIME / dmabuf, they can even be shared across devices.  So there are
-a handful of situations where the driver needs to wait for buffers to
-become ready.  If you think about this in terms of waiting on a buffer
-mutex for it to become available, this presents a problem because
-there is no way to guarantee that buffers appear in a execbuf/batch in
-the same order in all contexts.  That is directly under control of
-userspace, and a result of the sequence of GL calls that an application
-makes.	Which results in the potential for deadlock.  The problem gets
-more complex when you consider that the kernel may need to migrate the
-buffer(s) into VRAM before the GPU operates on the buffer(s), which
-may in turn require evicting some other buffers (and you don't want to
-evict other buffers which are already queued up to the GPU), but for a
-simplified understanding of the problem you can ignore this.
-
-The algorithm that the TTM graphics subsystem came up with for dealing with
-this problem is quite simple.  For each group of buffers (execbuf) that need
-to be locked, the caller would be assigned a unique reservation id/ticket,
-from a global counter.  In case of deadlock while locking all the buffers
-associated with a execbuf, the one with the lowest reservation ticket (i.e.
-the oldest task) wins, and the one with the higher reservation id (i.e. the
-younger task) unlocks all of the buffers that it has already locked, and then
-tries again.
-
-In the RDBMS literature this deadlock handling approach is called wait/wound:
-The older tasks waits until it can acquire the contended lock. The younger tasks
-needs to back off and drop all the locks it is currently holding, i.e. the
-younger task is wounded.
-
-Concepts
---------
-
-Compared to normal mutexes two additional concepts/objects show up in the lock
-interface for w/w mutexes:
-
-Acquire context: To ensure eventual forward progress it is important the a task
-trying to acquire locks doesn't grab a new reservation id, but keeps the one it
-acquired when starting the lock acquisition. This ticket is stored in the
-acquire context. Furthermore the acquire context keeps track of debugging state
-to catch w/w mutex interface abuse.
-
-W/w class: In contrast to normal mutexes the lock class needs to be explicit for
-w/w mutexes, since it is required to initialize the acquire context.
-
-Furthermore there are three different class of w/w lock acquire functions:
-
-* Normal lock acquisition with a context, using ww_mutex_lock.
-
-* Slowpath lock acquisition on the contending lock, used by the wounded task
-  after having dropped all already acquired locks. These functions have the
-  _slow postfix.
-
-  From a simple semantics point-of-view the _slow functions are not strictly
-  required, since simply calling the normal ww_mutex_lock functions on the
-  contending lock (after having dropped all other already acquired locks) will
-  work correctly. After all if no other ww mutex has been acquired yet there's
-  no deadlock potential and hence the ww_mutex_lock call will block and not
-  prematurely return -EDEADLK. The advantage of the _slow functions is in
-  interface safety:
-  - ww_mutex_lock has a __must_check int return type, whereas ww_mutex_lock_slow
-    has a void return type. Note that since ww mutex code needs loops/retries
-    anyway the __must_check doesn't result in spurious warnings, even though the
-    very first lock operation can never fail.
-  - When full debugging is enabled ww_mutex_lock_slow checks that all acquired
-    ww mutex have been released (preventing deadlocks) and makes sure that we
-    block on the contending lock (preventing spinning through the -EDEADLK
-    slowpath until the contended lock can be acquired).
-
-* Functions to only acquire a single w/w mutex, which results in the exact same
-  semantics as a normal mutex. This is done by calling ww_mutex_lock with a NULL
-  context.
-
-  Again this is not strictly required. But often you only want to acquire a
-  single lock in which case it's pointless to set up an acquire context (and so
-  better to avoid grabbing a deadlock avoidance ticket).
-
-Of course, all the usual variants for handling wake-ups due to signals are also
-provided.
-
-Usage
------
-
-Three different ways to acquire locks within the same w/w class. Common
-definitions for methods #1 and #2:
-
-static DEFINE_WW_CLASS(ww_class);
-
-struct obj {
-	struct ww_mutex lock;
-	/* obj data */
-};
-
-struct obj_entry {
-	struct list_head head;
-	struct obj *obj;
-};
-
-Method 1, using a list in execbuf->buffers that's not allowed to be reordered.
-This is useful if a list of required objects is already tracked somewhere.
-Furthermore the lock helper can use propagate the -EALREADY return code back to
-the caller as a signal that an object is twice on the list. This is useful if
-the list is constructed from userspace input and the ABI requires userspace to
-not have duplicate entries (e.g. for a gpu commandbuffer submission ioctl).
-
-int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
-{
-	struct obj *res_obj = NULL;
-	struct obj_entry *contended_entry = NULL;
-	struct obj_entry *entry;
-
-	ww_acquire_init(ctx, &ww_class);
-
-retry:
-	list_for_each_entry (entry, list, head) {
-		if (entry->obj == res_obj) {
-			res_obj = NULL;
-			continue;
-		}
-		ret = ww_mutex_lock(&entry->obj->lock, ctx);
-		if (ret < 0) {
-			contended_entry = entry;
-			goto err;
-		}
-	}
-
-	ww_acquire_done(ctx);
-	return 0;
-
-err:
-	list_for_each_entry_continue_reverse (entry, list, head)
-		ww_mutex_unlock(&entry->obj->lock);
-
-	if (res_obj)
-		ww_mutex_unlock(&res_obj->lock);
-
-	if (ret == -EDEADLK) {
-		/* we lost out in a seqno race, lock and retry.. */
-		ww_mutex_lock_slow(&contended_entry->obj->lock, ctx);
-		res_obj = contended_entry->obj;
-		goto retry;
-	}
-	ww_acquire_fini(ctx);
-
-	return ret;
-}
-
-Method 2, using a list in execbuf->buffers that can be reordered. Same semantics
-of duplicate entry detection using -EALREADY as method 1 above. But the
-list-reordering allows for a bit more idiomatic code.
-
-int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
-{
-	struct obj_entry *entry, *entry2;
-
-	ww_acquire_init(ctx, &ww_class);
-
-	list_for_each_entry (entry, list, head) {
-		ret = ww_mutex_lock(&entry->obj->lock, ctx);
-		if (ret < 0) {
-			entry2 = entry;
-
-			list_for_each_entry_continue_reverse (entry2, list, head)
-				ww_mutex_unlock(&entry2->obj->lock);
-
-			if (ret != -EDEADLK) {
-				ww_acquire_fini(ctx);
-				return ret;
-			}
-
-			/* we lost out in a seqno race, lock and retry.. */
-			ww_mutex_lock_slow(&entry->obj->lock, ctx);
-
-			/*
-			 * Move buf to head of the list, this will point
-			 * buf->next to the first unlocked entry,
-			 * restarting the for loop.
-			 */
-			list_del(&entry->head);
-			list_add(&entry->head, list);
-		}
-	}
-
-	ww_acquire_done(ctx);
-	return 0;
-}
-
-Unlocking works the same way for both methods #1 and #2:
-
-void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
-{
-	struct obj_entry *entry;
-
-	list_for_each_entry (entry, list, head)
-		ww_mutex_unlock(&entry->obj->lock);
-
-	ww_acquire_fini(ctx);
-}
-
-Method 3 is useful if the list of objects is constructed ad-hoc and not upfront,
-e.g. when adjusting edges in a graph where each node has its own ww_mutex lock,
-and edges can only be changed when holding the locks of all involved nodes. w/w
-mutexes are a natural fit for such a case for two reasons:
-- They can handle lock-acquisition in any order which allows us to start walking
-  a graph from a starting point and then iteratively discovering new edges and
-  locking down the nodes those edges connect to.
-- Due to the -EALREADY return code signalling that a given objects is already
-  held there's no need for additional book-keeping to break cycles in the graph
-  or keep track off which looks are already held (when using more than one node
-  as a starting point).
-
-Note that this approach differs in two important ways from the above methods:
-- Since the list of objects is dynamically constructed (and might very well be
-  different when retrying due to hitting the -EDEADLK wound condition) there's
-  no need to keep any object on a persistent list when it's not locked. We can
-  therefore move the list_head into the object itself.
-- On the other hand the dynamic object list construction also means that the -EALREADY return
-  code can't be propagated.
-
-Note also that methods #1 and #2 and method #3 can be combined, e.g. to first lock a
-list of starting nodes (passed in from userspace) using one of the above
-methods. And then lock any additional objects affected by the operations using
-method #3 below. The backoff/retry procedure will be a bit more involved, since
-when the dynamic locking step hits -EDEADLK we also need to unlock all the
-objects acquired with the fixed list. But the w/w mutex debug checks will catch
-any interface misuse for these cases.
-
-Also, method 3 can't fail the lock acquisition step since it doesn't return
--EALREADY. Of course this would be different when using the _interruptible
-variants, but that's outside of the scope of these examples here.
-
-struct obj {
-	struct ww_mutex ww_mutex;
-	struct list_head locked_list;
-};
-
-static DEFINE_WW_CLASS(ww_class);
-
-void __unlock_objs(struct list_head *list)
-{
-	struct obj *entry, *temp;
-
-	list_for_each_entry_safe (entry, temp, list, locked_list) {
-		/* need to do that before unlocking, since only the current lock holder is
-		allowed to use object */
-		list_del(&entry->locked_list);
-		ww_mutex_unlock(entry->ww_mutex)
-	}
-}
-
-void lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
-{
-	struct obj *obj;
-
-	ww_acquire_init(ctx, &ww_class);
-
-retry:
-	/* re-init loop start state */
-	loop {
-		/* magic code which walks over a graph and decides which objects
-		 * to lock */
-
-		ret = ww_mutex_lock(obj->ww_mutex, ctx);
-		if (ret == -EALREADY) {
-			/* we have that one already, get to the next object */
-			continue;
-		}
-		if (ret == -EDEADLK) {
-			__unlock_objs(list);
-
-			ww_mutex_lock_slow(obj, ctx);
-			list_add(&entry->locked_list, list);
-			goto retry;
-		}
-
-		/* locked a new object, add it to the list */
-		list_add_tail(&entry->locked_list, list);
-	}
-
-	ww_acquire_done(ctx);
-	return 0;
-}
-
-void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
-{
-	__unlock_objs(list);
-	ww_acquire_fini(ctx);
-}
-
-Method 4: Only lock one single objects. In that case deadlock detection and
-prevention is obviously overkill, since with grabbing just one lock you can't
-produce a deadlock within just one class. To simplify this case the w/w mutex
-api can be used with a NULL context.
-
-Implementation Details
-----------------------
-
-Design:
-  ww_mutex currently encapsulates a struct mutex, this means no extra overhead for
-  normal mutex locks, which are far more common. As such there is only a small
-  increase in code size if wait/wound mutexes are not used.
-
-  In general, not much contention is expected. The locks are typically used to
-  serialize access to resources for devices. The only way to make wakeups
-  smarter would be at the cost of adding a field to struct mutex_waiter. This
-  would add overhead to all cases where normal mutexes are used, and
-  ww_mutexes are generally less performance sensitive.
-
-Lockdep:
-  Special care has been taken to warn for as many cases of api abuse
-  as possible. Some common api abuses will be caught with
-  CONFIG_DEBUG_MUTEXES, but CONFIG_PROVE_LOCKING is recommended.
-
-  Some of the errors which will be warned about:
-   - Forgetting to call ww_acquire_fini or ww_acquire_init.
-   - Attempting to lock more mutexes after ww_acquire_done.
-   - Attempting to lock the wrong mutex after -EDEADLK and
-     unlocking all mutexes.
-   - Attempting to lock the right mutex after -EDEADLK,
-     before unlocking all mutexes.
-
-   - Calling ww_mutex_lock_slow before -EDEADLK was returned.
-
-   - Unlocking mutexes with the wrong unlock function.
-   - Calling one of the ww_acquire_* twice on the same context.
-   - Using a different ww_class for the mutex than for the ww_acquire_ctx.
-   - Normal lockdep errors that can result in deadlocks.
-
-  Some of the lockdep errors that can result in deadlocks:
-   - Calling ww_acquire_init to initialize a second ww_acquire_ctx before
-     having called ww_acquire_fini on the first.
-   - 'normal' deadlocks that can occur.
-
-FIXME: Update this section once we have the TASK_DEADLOCK task state flag magic
-implemented.
diff --git a/MAINTAINERS b/MAINTAINERS
index b4534ee..053d8c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5516,8 +5516,8 @@ M:	Ingo Molnar <mingo@redhat.com>
 L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/locking
 S:	Maintained
-F:	Documentation/lockdep*.txt
-F:	Documentation/lockstat.txt
+F:	Documentation/locking/lockdep*.txt
+F:	Documentation/locking/lockstat.txt
 F:	include/linux/lockdep.h
 F:	kernel/locking/
 
diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
index 0dc57d5..3a02e5e 100644
--- a/drivers/gpu/drm/drm_modeset_lock.c
+++ b/drivers/gpu/drm/drm_modeset_lock.c
@@ -35,7 +35,7 @@
  * of extra utility/tracking out of our acquire-ctx.  This is provided
  * by drm_modeset_lock / drm_modeset_acquire_ctx.
  *
- * For basic principles of ww_mutex, see: Documentation/ww-mutex-design.txt
+ * For basic principles of ww_mutex, see: Documentation/locking/ww-mutex-design.txt
  *
  * The basic usage pattern is to:
  *
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index dadd6ba..b5a84b62 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -4,7 +4,7 @@
  *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
- * see Documentation/lockdep-design.txt for more details.
+ * see Documentation/locking/lockdep-design.txt for more details.
  */
 #ifndef __LINUX_LOCKDEP_H
 #define __LINUX_LOCKDEP_H
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index e4c2941..cc31498 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -133,7 +133,7 @@ static inline int mutex_is_locked(struct mutex *lock)
 
 /*
  * See kernel/locking/mutex.c for detailed documentation of these APIs.
- * Also see Documentation/mutex-design.txt.
+ * Also see Documentation/locking/mutex-design.txt.
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 035d3c5..8f498cd 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -149,7 +149,7 @@ extern void downgrade_write(struct rw_semaphore *sem);
  * static then another method for expressing nested locking is
  * the explicit definition of lock class keys and the use of
  * lockdep_set_class() at lock initialization time.
- * See Documentation/lockdep-design.txt for more details.)
+ * See Documentation/locking/lockdep-design.txt for more details.)
  */
 extern void down_read_nested(struct rw_semaphore *sem, int subclass);
 extern void down_write_nested(struct rw_semaphore *sem, int subclass);
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index a925597..50933f3 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -15,7 +15,7 @@
  *    by Steven Rostedt, based on work by Gregory Haskins, Peter Morreale
  *    and Sven Dietrich.
  *
- * Also see Documentation/mutex-design.txt.
+ * Also see Documentation/locking/mutex-design.txt.
  */
 #include <linux/mutex.h>
 #include <linux/ww_mutex.h>
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index a0ea2a1..7c98873 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -8,7 +8,7 @@
  *  Copyright (C) 2005 Kihon Technologies Inc., Steven Rostedt
  *  Copyright (C) 2006 Esben Nielsen
  *
- *  See Documentation/rt-mutex-design.txt for details.
+ *  See Documentation/locking/rt-mutex-design.txt for details.
  */
 #include <linux/spinlock.h>
 #include <linux/export.h>
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 03f461f..269da61 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -924,7 +924,7 @@ config PROVE_LOCKING
 	 the proof of observed correctness is also maintained for an
 	 arbitrary combination of these separate locking variants.
 
-	 For more details, see Documentation/lockdep-design.txt.
+	 For more details, see Documentation/locking/lockdep-design.txt.
 
 config LOCKDEP
 	bool
@@ -945,7 +945,7 @@ config LOCK_STAT
 	help
 	 This feature enables tracking lock contention points
 
-	 For more details, see Documentation/lockstat.txt
+	 For more details, see Documentation/locking/lockstat.txt
 
 	 This also enables lock events required by "perf lock",
 	 subcommand of perf.
-- 
1.8.1.4

