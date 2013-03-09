Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab3CIS2H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:28:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3CIS2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:28:05 -0500
Date: Sat, 9 Mar 2013 19:26:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] tasklist_lock fairness issues
Message-ID: <20130309182613.GA32343@redhat.com>
References: <1362717437-1729-1-git-send-email-walken@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362717437-1729-1-git-send-email-walken@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michel,

Well. I can't say I really like this. 4/5 itself looks fine, but other
complications do not look nice, at least in the long term. Imho, imho,
I can be wrong.

Everyone seem to agree that tasklist should die, this series doesn't
even try to solve the fundamental problems with this global lock.

However, I agree. tasklist rework can take ages, so probably we need
to solve at least the write-starvation problem right now. Probably this
series is correct (I didn't read it except 4/5), but too complex.

Can't we do some simple hack to avoid the user-triggered livelocks?
Say, can't we add

	// Just for illustration, at least we need CONTENDED/etc

	void read_lock_fair(rwlock_t *lock)
	{
		while (arch_writer_active(lock))
			cpu_relax();
		read_lock(lock);
	}

and then turn some of read_lock's (do_wait, setpriority, more) into
read_lock_fair?

I have to admit, I do not know how rwlock_t actually works, and it seems
that arch_writer_active() is not trivial even on x86. __write_lock_failed()
changes the counter back, and afaics you can't detect the writer in the
window between addl and subl. Perhaps we can change __write_lock_failed()
to use RW_LOCK_BIAS + HUGE_NUMBER while it spins, but I am not sure...

Or perhaps we can turn write_lock(tasklist) into

		void tasklist_write_lock(void)
		{
			if (write_try_lock(taslist_lock))
				return;

			// checked by writer_active() above		
			taslist_lock_writer_active = true;

			write_lock(taslist_lock);
			taslist_lock_writer_active = false;
		}


In any case I am not proud of this idea, and in any case I would like
to see more comments.

Oleg.

On 03/07, Michel Lespinasse wrote:
>
> I'd like to gather comments on these patches, which apply over v3.9-rc1.
>
> I have been looking at rwlock_t fairness issues, and in particular at
> tasklist_lock as this is the one rwlock_t user that seems to be making
> it difficult to switch rwlock_t to a fair lock. This is because the
> tasklist_lock read side is taken both in process and irq contexts,
> and we don't want to have to disable irqs when tasklist_lock is taken
> in process context, so we need a rwlock_t that supports a recursive
> read side.
>
> Patches 1-3 convert the existing tasklist_lock users to use helper
> functions.  For the tasklist_lock read side, we have different helpers
> for call sites that are known to run only in process context, vs call
> sites that may run in any context.
>
> - Patch 1 introduces the tasklist_lock helper functions;
>
> - Patch 2 identifies all tasklist_lock call sites that may run in
>   (soft or hard) irq context and converts them to use the
>   tasklist_read_[un]lock_any helper functions;
>
> - Patch 3 converts the remaining call sites (known to run only in
>   process context) to use the tasklist_{read,write}_[un]lock helpers.
>
> Together, these 3 patches provide some kind of documentation about which
> tasklist users may run in irq contexts, and are thus currently making it
> difficult to do a straight conversion of rwlock_t to a fair rw spinlock.
>
> Patch 4 introduces a generic implementation of a fair (ticket based)
> rw spinlock. I did not try optimizing it; it would be possible to do
> better using arch specific code. Seems too early for it though :)
>
> Patch 5 makes tasklist_lock fair when acquired from process context.
> This is done using a double locking scheme; there is a fair rwlock
> that is used when tasklist_lock is acquired from process context and
> an unfair rwlock_t that is used when tasklist_lock read side is acquired
> from irq context. When tasklist_lock is acquired for write both locks
> are taken. Clearly, such double locking is suboptimal; one would hope
> that the irq context read side users could be eliminated over time.
> Converting the process context users to a fair rwlock also has the
> additional benefit that it lets lockdep verify that we are not trying
> to do recursive acquires of the tasklist_lock read side in process context.
> (I haven't been able to break this check so far).
>
> Does this look like a reasonable approach to get traction on the
> tasklist_lock issues ?
>
> Michel Lespinasse (5):
>   kernel: add tasklist_{read,write}_lock{,_any} helper functions
>   kernel: use tasklist_read_lock_any() when locking tasklist in irq context
>   kernel: use tasklist_{read,write}_lock() to lock tasklist in process context
>   kernel: add ticket based fair rwlock
>   kernel: make tasklist_lock fair for process context call sites
>
>  arch/blackfin/kernel/trace.c     |  4 +--
>  arch/frv/mm/mmu-context.c        |  4 +--
>  arch/ia64/kernel/mca.c           | 13 ++++----
>  arch/ia64/kernel/perfmon.c       |  8 ++---
>  arch/ia64/kernel/ptrace.c        |  8 ++---
>  arch/metag/kernel/smp.c          |  4 +--
>  arch/mips/kernel/mips-mt-fpaff.c |  4 +--
>  arch/sh/mm/asids-debugfs.c       |  4 +--
>  arch/um/kernel/reboot.c          |  4 +--
>  drivers/tty/sysrq.c              |  4 +--
>  drivers/tty/tty_io.c             | 20 +++++------
>  fs/exec.c                        | 14 ++++----
>  fs/fcntl.c                       |  8 ++---
>  fs/fs_struct.c                   |  4 +--
>  fs/proc/array.c                  |  4 +--
>  fs/proc/base.c                   |  4 +--
>  include/linux/fair_rwlock.h      | 72 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/lockdep.h          | 15 +++++++++
>  include/linux/sched.h            | 46 ++++++++++++++++++++++++-
>  kernel/cgroup.c                  |  4 +--
>  kernel/cpu.c                     |  4 +--
>  kernel/exit.c                    | 42 +++++++++++------------
>  kernel/fork.c                    | 14 +++++---
>  kernel/lockdep.c                 |  6 ++--
>  kernel/pid_namespace.c           |  8 ++---
>  kernel/posix-cpu-timers.c        | 32 +++++++++---------
>  kernel/power/process.c           | 16 ++++-----
>  kernel/ptrace.c                  | 20 +++++------
>  kernel/sched/core.c              | 13 ++++----
>  kernel/sched/debug.c             |  5 ++-
>  kernel/signal.c                  | 26 +++++++--------
>  kernel/sys.c                     | 22 ++++++------
>  kernel/trace/ftrace.c            |  5 ++-
>  kernel/tracepoint.c              | 10 +++---
>  mm/kmemleak.c                    |  4 +--
>  mm/memory-failure.c              |  8 ++---
>  mm/oom_kill.c                    |  4 +--
>  security/keys/keyctl.c           |  4 +--
>  security/selinux/hooks.c         |  4 +--
>  39 files changed, 312 insertions(+), 183 deletions(-)
>  create mode 100644 include/linux/fair_rwlock.h
>
> --
> 1.8.1.3

