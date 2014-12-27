Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaL0JwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 04:52:16 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:52222 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaL0JwP (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sat, 27 Dec 2014 04:52:15 -0500
Message-ID: <1419673927.8667.2.camel@stgolabs.net>
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
From: Davidlohr Bueso <dave@stgolabs.net>
To: Li Bin <huawei.libin@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        rui.xiang@huawei.com, wengmeiling.weng@huawei.com
Date: Sat, 27 Dec 2014 01:52:07 -0800
In-Reply-To: <549D03F6.9090607@huawei.com>
References: <53B98709.3090603@oracle.com>
	 <20140707083016.GA19379@twins.programming.kicks-ass.net>
	 <53BAA6DF.5060409@oracle.com>
	 <20140707200550.GA6758@twins.programming.kicks-ass.net>
	 <549D03F6.9090607@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-26 at 14:45 +0800, Li Bin wrote:
> On 2014/7/8 4:05, Peter Zijlstra wrote:
> > On Mon, Jul 07, 2014 at 09:55:43AM -0400, Sasha Levin wrote:
> >> I've also had this one, which looks similar:
> >>
> >> [10375.005884] BUG: spinlock recursion on CPU#0, modprobe/10965
> >> [10375.006573]  lock: 0xffff8803a0fd7740, .magic: dead4ead, .owner: modprobe/10965, .owner_cpu: 15
> >> [10375.007412] CPU: 0 PID: 10965 Comm: modprobe Tainted: G        W      3.16.0-rc3-next-20140704-sasha-00023-g26c0906-dirty #765
> > 
> > Something's fucked; so we have:
> > 
> > debug_spin_lock_before()
> > 	SPIN_BUG_ON(lock->owner == current, "recursion");
> > 
> 
> Hello，
> Does ACCESS_ONCE() can help this issue? I have no evidence that its lack is
> responsible for the issue, but I think here need it indeed. Is that right?
> 
> SPIN_BUG_ON(ACCESS_ONCE(lock->owner) == current, "recursion");

Hmm I guess on a contended spinlock, there's a chance that lock->owner
can change, if the contended lock is acquired, right between the 'cond'
and spin_debug(), which would explain the bogus ->owner related
messages. Of course the same applies to ->owner_cpu. Your ACCESS_ONCE,
however, doesn't really change anything since we still read ->owner
again in spin_debug; How about something like this (untested)?

diff --git a/kernel/locking/spinlock_debug.c b/kernel/locking/spinlock_debug.c
index 0374a59..86c199a 100644
--- a/kernel/locking/spinlock_debug.c
+++ b/kernel/locking/spinlock_debug.c
@@ -75,15 +75,58 @@ static void spin_bug(raw_spinlock_t *lock, const char *msg)
 	spin_dump(lock, msg);
 }
 
+static void spin_dump_owner(raw_spinlock_t *lock, struct task_struct *owner, 
+			    int owner_cpu, const char *msg)
+{
+	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
+	       msg, raw_smp_processor_id(),
+	       current->comm, task_pid_nr(current));
+	printk(KERN_EMERG " lock: %pS, .magic: %08x, .owner: %s/%d, "
+	       ".owner_cpu: %d\n", lock, lock->magic, owner->comm,
+	       task_pid_nr(owner), owner_cpu);
+
+	dump_stack();
+}
+
+static void spin_bug_owner_lock(raw_spinlock_t *lock)
+{
+	int owner_cpu;
+	struct task_struct *owner;
+
+	if (!debug_locks_off())
+		return;
+
+	owner = ACCESS_ONCE(lock->owner);
+	owner_cpu = ACCESS_ONCE(lock->owner_cpu);
+	if (owner == current)
+		spin_dump_owner(lock, owner, owner_cpu, "recursion");
+	if (owner_cpu == raw_smp_processor_id())
+		spin_dump_owner(lock, owner, owner_cpu, "cpu recursion");
+}
+
+static void spin_bug_owner_unlock(raw_spinlock_t *lock)
+{
+	int owner_cpu;
+	struct task_struct *owner;
+
+	if (!debug_locks_off())
+		return;
+
+	owner = ACCESS_ONCE(lock->owner);
+	owner_cpu = ACCESS_ONCE(lock->owner_cpu);
+	if (owner != current)
+		spin_dump_owner(lock, owner, owner_cpu, "wrong owner");
+	if (owner_cpu != raw_smp_processor_id())
+		spin_dump_owner(lock, owner, owner_cpu, "wrong CPU");
+}
+
 #define SPIN_BUG_ON(cond, lock, msg) if (unlikely(cond)) spin_bug(lock, msg)
 
 static inline void
 debug_spin_lock_before(raw_spinlock_t *lock)
 {
 	SPIN_BUG_ON(lock->magic != SPINLOCK_MAGIC, lock, "bad magic");
-	SPIN_BUG_ON(lock->owner == current, lock, "recursion");
-	SPIN_BUG_ON(lock->owner_cpu == raw_smp_processor_id(),
-							lock, "cpu recursion");
+	spin_bug_owner_lock(lock);
 }
 
 static inline void debug_spin_lock_after(raw_spinlock_t *lock)
@@ -96,9 +139,8 @@ static inline void debug_spin_unlock(raw_spinlock_t *lock)
 {
 	SPIN_BUG_ON(lock->magic != SPINLOCK_MAGIC, lock, "bad magic");
 	SPIN_BUG_ON(!raw_spin_is_locked(lock), lock, "already unlocked");
-	SPIN_BUG_ON(lock->owner != current, lock, "wrong owner");
-	SPIN_BUG_ON(lock->owner_cpu != raw_smp_processor_id(),
-							lock, "wrong CPU");
+	spin_bug_owner_unlock(lock);
+
 	lock->owner = SPINLOCK_OWNER_INIT;
 	lock->owner_cpu = -1;
 }


Thanks,
Davidlohr

