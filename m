Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaFCLPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:15:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbaFCLPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:15:48 -0400
Date: Tue, 3 Jun 2014 07:14:31 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
In-Reply-To: <20140603073613.GH11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.LRH.2.02.1406030341570.10639@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com> <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com> <alpine.LRH.2.02.1406021622200.5874@file01.intranet.prod.int.rdu2.redhat.com> <CA+55aFwCy4-x02U6A-KbkPEpe_4pagsZ__ipBhe5HZOQt2vNmw@mail.gmail.com> <alpine.LRH.2.02.1406021656550.5874@file01.intranet.prod.int.rdu2.redhat.com>
 <20140603073613.GH11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jun 2014, Peter Zijlstra wrote:

> On Mon, Jun 02, 2014 at 05:12:16PM -0400, Mikulas Patocka wrote:
> > The patch adds atomic_pointer_t for all architectures - it is in the 
> > common code and it is backed by atomic_long_t (that already exists for all 
> > architectures). There is no new arch-specific code at all.
> > 
> > When we have atomic_pointer_t, we can find the instances of xchg() and 
> > cmpxchg() and convert them to atomic_pointer_t (or to other atomic*_t 
> > types).
> > 
> > When we convert them all, we can drop xchg() and cmpxchg() at all (at 
> > least from architecture-neutral code).
> > 
> > The problem with xchg() and cmpxchg() is that they are very easy to 
> > misuse. Peter Zijlstra didn't know that they are not atomic w.r.t. normal 
> > stores, a lot of other people don't know it too - and if we allow these 
> > functions to be used, this race condition will reappear in the future 
> > again and again.
> > 
> > That's why I'm proposing atomic_pointer_t - it guarantees that this race 
> > condition can't be made.
> 
> But its horrible, and doesn't have any benefit afaict.
>
> So if we really want to keep supporting these platforms; I would propose
> something like:
> 
> #ifdef __CHECKER__
> #define __atomic	__attribute__((address_space(5)))
> #else
> #define __atomic
> #endif
> 
> #define store(p, v)	(*(p) = (typeof(*(p)) __force __atomic)(v))
> #define load(p)		((typeof(*p) __force)ACCESS_ONCE(*(p)))
> 
> Along with changes to xchg() and cmpxchg() that require them to take
> pointers to __atomic.
> 
> That way we keep the flexibility of xchg() and cmpxchg() for being
> (mostly) type and size invariant, and get sparse to find wrong usage.
> 
> Then parisc, sparc32, tile32, metag-lock1 and arc-!llsc can go implement
> store() however they like.

Your proposal is very good because it warns about incorrect usage 
automatically.



Your usage is very similar to what my patch at the top of this thread 
does:

Instead of "__atomic struct s *p;" declaration, my patch uses
"atomic_pointer(struct s*) p;" as the declaration
Instead of store(&p, v), my patch uses atomic_pointer_set(&p, v);
Instead of load(&p), my patch uses atomic_pointer_get(&p);
Instead of xchg(&p, v), my patch uses atomic_pointer_xchg(&p, v);
Instead of cmpxchg(&p, v1, v2), my patch uses atomic_pointer_cmpxchg(&p1, v1, v2);

> But its horrible, and doesn't have any benefit afaict.

See the five cases above - why do you say that the operation on the left 
is good and the operation on the right is horrible? To me, it looks like 
they are both similar, they are just named differently. Both check the 
type of the pointer and warns if the user passes incompatible pointer. If 
I rename the operations in my patch to store(), load(), xchg(), cmpxchg(), 
would you like it?


My patch has advantage (over your #define __atomic 
__attribute__((address_space(5))) ) that it checks the mismatches at 
compile time. Your proposal only check them with sparse. But either way - 
it is very good that the mismatches are being checked automatically.




We need some method to catch these races automatically. There are places 
where people xchg() or cmpxchg() with direct modifications, see for 
example this:


$ grep -w mnt_expiry_mark */*.c
fs/namespace.c:         if (unlikely(m->mnt_expiry_mark))
fs/namespace.c:                 m->mnt_expiry_mark = 0;
fs/namespace.c:         if (!xchg(&mnt->mnt_expiry_mark, 1))
fs/namespace.c: /* we mustn't call path_put() as that would clear mnt_expiry_mark */
fs/namespace.c:         if (!xchg(&mnt->mnt_expiry_mark, 1) ||

$ grep "sub_info->complete" */*.c
kernel/kmod.c:  struct completion *comp = xchg(&sub_info->complete, NULL);
kernel/kmod.c:  sub_info->complete = &done;
kernel/kmod.c:          if (xchg(&sub_info->complete, NULL))

$ grep -w "fdt->fd" */*.c
fs/file.c:      free_fdmem(fdt->fd);
fs/file.c:      fdt->fd = data;
fs/file.c:      free_fdmem(fdt->fd);
fs/file.c:                              struct file * file = xchg(&fdt->fd[i], NULL);
fs/file.c:      if (rcu_access_pointer(fdt->fd[fd]) != NULL) {
fs/file.c:              rcu_assign_pointer(fdt->fd[fd], NULL);
fs/file.c:      BUG_ON(fdt->fd[fd] != NULL);
fs/file.c:      rcu_assign_pointer(fdt->fd[fd], file);
fs/file.c:      file = fdt->fd[fd];
fs/file.c:      rcu_assign_pointer(fdt->fd[fd], NULL);
fs/file.c:                      file = fdt->fd[fd];
fs/file.c:                      rcu_assign_pointer(fdt->fd[fd], NULL);
fs/file.c:      tofree = fdt->fd[fd];
fs/file.c:      rcu_assign_pointer(fdt->fd[fd], file);
fs/file.c:              file = rcu_dereference_check_fdtable(files, fdt->fd[n]);

$ grep -w exit_state */*.c
fs/exec.c:                      if (likely(leader->exit_state))
fs/exec.c:              BUG_ON(leader->exit_state != EXIT_ZOMBIE);
fs/exec.c:              leader->exit_state = EXIT_DEAD;
kernel/exit.c:  if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
kernel/exit.c:                  leader->exit_state = EXIT_DEAD;
kernel/exit.c:              (p->exit_state && thread_group_empty(p)) ||
kernel/exit.c:  if (p->exit_state == EXIT_DEAD)
kernel/exit.c:      p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
kernel/exit.c:                  p->exit_state = EXIT_DEAD;
kernel/exit.c:  tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
kernel/exit.c:  if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
kernel/exit.c:          p->exit_state = state;
kernel/exit.c:  if (unlikely(p->exit_state == EXIT_DEAD))
kernel/exit.c:  if (unlikely(p->exit_state == EXIT_TRACE)) {
kernel/exit.c:  if (p->exit_state == EXIT_ZOMBIE) {
kernel/fork.c:  WARN_ON(!tsk->exit_state);
kernel/posix-cpu-timers.c:              if (unlikely(p->exit_state))
kernel/posix-cpu-timers.c:              } else if (unlikely(p->exit_state) && thread_group_empty(p)) {
kernel/ptrace.c:        if (unlikely(task->exit_state))
kernel/ptrace.c:        if (p->exit_state != EXIT_ZOMBIE)
kernel/ptrace.c:                p->exit_state = EXIT_DEAD;
kernel/ptrace.c:                if (child->exit_state)  /* already dead */
kernel/signal.c:                if (t->exit_state)
kernel/taskstats.c:             if (tsk->exit_state)
mm/oom_kill.c:  if (task->exit_state)


Mikulas
