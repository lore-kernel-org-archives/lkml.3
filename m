Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962Ab3BOLjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 06:39:48 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49218 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3BOLjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 06:39:47 -0500
Date: Fri, 15 Feb 2013 12:39:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] spinlock/debugging: Print out lock name when available
Message-ID: <20130215113943.GC26955@gmail.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130213111007.GA11367@gmail.com>
 <CA+55aFwpFFg+Z28aZ=92bGdU+Va00j08BzL-2frtLarKWt=qOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwpFFg+Z28aZ=92bGdU+Va00j08BzL-2frtLarKWt=qOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Feb 13, 2013 at 3:10 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Setting up Logical Volume Management: [   13.140000] BUG: spinlock lockup suspected on CPU#1, lvm.static/139
> > [   13.140000] BUG: spinlock lockup suspected on CPU#1, lvm.static/139
> > [   13.140000]  lock: 0x97fe9fc0, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
> 
> Btw, this is an entirely unrelated thing, but it just struck 
> me: you have CONFIG_DEBUG_LOCK_ALLOC in your config, so that 
> spinlock has a _name_, and the not-so-helpful "spin_dump()" is 
> too stupid to even bother to print it out.

Yeah - the spinlock debug code predates lockdep.

> Now, in this case, it doesn't much matter, since the callchain 
> really does end up showing pretty unambiguously what the lock 
> is, but shouldn't we print that lock name when we dump the 
> lock information?
> 
> I dunno. Maybe the names aren't useful, and the callchain ends 
> up always making them redundant. But it seems an oversight in 
> our debug output.

I think it's generally useful, sometimes, for deep crashes we 
don't get a call-chain at all.

Something like the patch below? (entirely untested)

( Using CPP macros to not have to create trivial wrappers for 
  half a dozen lock types. 'dep_map' is not a very likely source 
  of typos and type confusion in any case. )

We could also do a kallsyms lookup like lockdep does - but I'd 
rather keep the spinlock debugging code simple and while 
checking that code I noticed that 
kernel/lockdep.c:print_lockdep_cache() is probably buggy as it 
subtly returns an on-stack variable ... Needs a separate fix.

Thanks,

	Ingo

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index f05631e..17df33a 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -315,6 +315,8 @@ static inline int lockdep_match_key(struct lockdep_map *lock,
 	return lock->key == key;
 }
 
+#define lock_name(lock) ((lock)->dep_map.name)
+
 /*
  * Acquire a lock.
  *
@@ -373,6 +375,8 @@ static inline void lockdep_on(void)
 {
 }
 
+# define lock_name(lock) ""
+
 # define lock_acquire(l, s, t, r, c, n, i)	do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
 # define lock_set_class(l, n, k, s, i)		do { } while (0)
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 0374a59..80d4818 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -55,15 +55,19 @@ static void spin_dump(raw_spinlock_t *lock, const char *msg)
 
 	if (lock->owner && lock->owner != SPINLOCK_OWNER_INIT)
 		owner = lock->owner;
-	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
+
+	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d %s\n",
 		msg, raw_smp_processor_id(),
-		current->comm, task_pid_nr(current));
+		current->comm, task_pid_nr(current),
+		lock_name(lock));
+
 	printk(KERN_EMERG " lock: %pS, .magic: %08x, .owner: %s/%d, "
 			".owner_cpu: %d\n",
 		lock, lock->magic,
 		owner ? owner->comm : "<none>",
 		owner ? task_pid_nr(owner) : -1,
 		lock->owner_cpu);
+
 	dump_stack();
 }
 
