Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3F0OpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:45:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:41292 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3F0OpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:45:13 -0400
Date: Thu, 27 Jun 2013 16:44:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Waiman Long <waiman.long@hp.com>
cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
In-Reply-To: <51CB8472.1040502@hp.com>
Message-ID: <alpine.DEB.2.02.1306271501220.4013@ionos.tec.linutronix.de>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1306262307020.4013@ionos.tec.linutronix.de> <51CB8472.1040502@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013, Waiman Long wrote:
> On 06/26/2013 07:06 PM, Thomas Gleixner wrote:
> > On Wed, 26 Jun 2013, Waiman Long wrote:
> > This is a complete design disaster. You are violating every single
> > rule of proper layering. The differentiation of spinlock, raw_spinlock
> > and arch_spinlock is there for a reason and you just take the current
> > implementation and map your desired function to it. If we take this,
> > then we fundamentally ruled out a change to the mappings of spinlock,
> > raw_spinlock and arch_spinlock. This layering is on purpose and it
> > took a lot of effort to make it as clean as it is now. Your proposed
> > change undoes that and completely wreckages preempt-rt.
> 
> Would you mind enlighten me how this change will break preempt-rt?

The whole spinlock layering was done for RT. In mainline spinlock is
mapped to raw_spinlock. On RT spinlock is mapped to a PI aware
rtmutex.

So your mixing of the various layers and the assumption of lock plus
count being adjacent, does not work on RT at all.

> The only architecture that will break, according to data in the
> respectively arch/*/include/asm/spinlock_types.h files is PA-RISC
> 1.x (it is OK in PA-RISC 2.0) whose arch_spinlock type has a size of
> 16 bytes. I am not sure if 32-bit PA-RISC 1.x is still supported or
> not, but we can always disable the optimization for this case.

You have to do that right from the beginning with a proper data
structure and proper accessor functions. Introducing wreckage and then
retroactivly fixing it, is not a really good idea.

> > So what you really want is a new data structure, e.g. something like
> > struct spinlock_refcount() and a proper set of new accessor functions
> > instead of an adhoc interface which is designed solely for the needs
> > of dcache improvements.
> 
> I had thought about that. The only downside is we need more code changes to
> make existing code to use the new infrastructure. One of the drivers in my

That's not a downside. It makes the usage of the infrastructure more
obvious and not hidden behind macro magic. And the changes are trivial
to script.

> design is to minimize change to existing code. Personally, I have no
> objection of doing that if others think this is the right way to go.

Definitely. Something like this would be ok:

struct lock_refcnt {
       int                 refcnt;
       struct spinlock     lock;
};

It does not require a gazillion of ifdefs and works for
UP,SMP,DEBUG....

extern bool lock_refcnt_mod(struct lock_refcnt *lr, int mod, int cond);

You also want something like:

extern void lock_refcnt_disable(void);

So we can runtime disable it e.g. when lock elision is detected and
active. So you can force lock_refcnt_mod() to return false.

static inline bool lock_refcnt_inc(struct lock_refcnt *sr)
{
#ifdef CONFIG_HAVE_LOCK_REFCNT
	return lock_refcnt_mod(sr, 1, INTMAX);
#else
	return false;
#endif
}

That does not break any code as long as CONFIG_HAVE_SPINLOCK_REFCNT=n.

So we can enable it per architecture and make it depend on SMP. For RT
we simply can force this switch to n.

The other question is the semantic of these refcount functions. From
your description the usage pattern is:

     if (refcnt_xxx())
	   return;
     /* Slow path */
     spin_lock();
     ...
     spin_unlock();

So it might be sensible to make this explicit:

static inline bool refcnt_inc_or_lock(struct lock_refcnt *lr))
{
#ifdef CONFIG_HAVE_SPINLOCK_REFCNT
	if (lock_refcnt_mod(lr, 1, INTMAX))
	   return true;
#endif
	spin_lock(&lr->lock);
	return false;
}

Thanks,

	tglx
