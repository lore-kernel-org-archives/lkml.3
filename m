Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaAHBf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:35:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaAHBfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:35:51 -0500
Date: Tue, 7 Jan 2014 17:36:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shaohua Li <shli@fusionio.com>, Jens Axboe <axboe@kernel.dk>,
        Fan Du <fan.du@windriver.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] lib/percpu_counter.c: disable local irq when updating
 percpu couter
Message-Id: <20140107173645.64d6838e.akpm@linux-foundation.org>
In-Reply-To: <CACVXFVMVBbSqLfCwX9Q2EvAH6K4u1Y_nbtcxEixH8-g-4j6oPA@mail.gmail.com>
References: <1389090568-29079-1-git-send-email-tom.leiming@gmail.com>
	<20140107142742.9c075b52ad81e60d19bff3d3@linux-foundation.org>
	<CACVXFVMVBbSqLfCwX9Q2EvAH6K4u1Y_nbtcxEixH8-g-4j6oPA@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014 09:12:19 +0800 Ming Lei <tom.leiming@gmail.com> wrote:

> Hi Andrew,
> 
> >> --- a/lib/percpu_counter.c
> >> +++ b/lib/percpu_counter.c
> >> @@ -75,19 +75,19 @@ EXPORT_SYMBOL(percpu_counter_set);
> >>  void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
> >>  {
> >>       s64 count;
> >> +     unsigned long flags;
> >>
> >> -     preempt_disable();
> >> +     raw_local_irq_save(flags);
> >>       count = __this_cpu_read(*fbc->counters) + amount;
> >>       if (count >= batch || count <= -batch) {
> >> -             unsigned long flags;
> >> -             raw_spin_lock_irqsave(&fbc->lock, flags);
> >> +             raw_spin_lock(&fbc->lock);
> >>               fbc->count += count;
> >> -             raw_spin_unlock_irqrestore(&fbc->lock, flags);
> >> +             raw_spin_unlock(&fbc->lock);
> >>               __this_cpu_write(*fbc->counters, 0);
> >>       } else {
> >>               __this_cpu_write(*fbc->counters, count);
> >>       }
> >> -     preempt_enable();
> >> +     raw_local_irq_restore(flags);
> >>  }
> >>  EXPORT_SYMBOL(__percpu_counter_add);
> >
> > Can this be made more efficient?
> >
> > The this_cpu_foo() documentation is fairly dreadful, but way down at
> > the end of Documentation/this_cpu_ops.txt we find "this_cpu ops are
> > interrupt safe".  So I think this is a more efficient fix:
> >
> > --- a/lib/percpu_counter.c~a
> > +++ a/lib/percpu_counter.c
> > @@ -82,10 +82,10 @@ void __percpu_counter_add(struct percpu_
> >                 unsigned long flags;
> >                 raw_spin_lock_irqsave(&fbc->lock, flags);
> >                 fbc->count += count;
> > +               __this_cpu_sub(*fbc->counters, count);
> >                 raw_spin_unlock_irqrestore(&fbc->lock, flags);
> > -               __this_cpu_write(*fbc->counters, 0);
> >         } else {
> > -               __this_cpu_write(*fbc->counters, count);
> > +               this_cpu_add(*fbc->counters, amount);
> >         }
> >         preempt_enable();
> >  }
> >
> > It avoids the local_irq_disable() in the common case, when the CPU
> > supports efficient this_cpu_add().  It will in rare race situations
> > permit the cpu-local counter to exceed `batch', but that should be
> > harmless.
> 
> I am wondering if the above patch is more efficient, because:
> 
> - raw_local_irq_save()/raw_local_irq_restore() should be cheaper
> than preempt_enable() in theory

Don't think so - local_irq_disable() requires quite some internal
synchronization in the CPU and is expensive.  preempt_disable() is just
an add+barrier, minus the add if the kernel is non-preemptable.

> - except for x86 and s390, other ARCHs have not their own implementation
> of  this_cpu_foo(), and the generic one just disables local interrupt
> when operating the percpu variable.

Yup.  But other CPUs should and will optimise their this_cpu
implementations over time.
