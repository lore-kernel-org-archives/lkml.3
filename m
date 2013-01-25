Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3AYJY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:24:29 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:64667 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab3AYJY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:24:26 -0500
Date: Fri, 25 Jan 2013 10:24:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: nan chen <nachenn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mutex: use spin_[un]lock instead of
 arch_spin_[un]lock
Message-ID: <20130125092422.GA19541@gmail.com>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20130124161413.a3903fa4.akpm@linux-foundation.org>
 <20130125074053.GD18243@gmail.com>
 <CABBm8944FSNDZ2u=PJy0CsZmz=Vm7e+Y5jX+3UFLN5NOSGRgWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABBm8944FSNDZ2u=PJy0CsZmz=Vm7e+Y5jX+3UFLN5NOSGRgWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* nan chen <nachenn@gmail.com> wrote:

> 2013/1/25 Ingo Molnar <mingo@kernel.org>
> 
> >
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > On Thu, 24 Jan 2013 17:22:45 +0800
> > > Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > >
> > > > Use spin_[un]lock instead of arch_spin_[un]lock in mutex-debug.h so
> > > > that we can collect the lock statistics of spin_lock_mutex from
> > > > /proc/lock_stat.
> >
> > So, as per the discussion we don't want this patch, because we
> > are using raw locks there to keep mutex lockdep overhead low.
> > The value of lockdep-checking such a basic locking primitive is
> > minimal - it's rarely tweaked and if it breaks we won't have a
> > bootable kernel to begin with.
> >
> > So instead I suggested a different patch: adding a comment to
> > explain why we don't lockdep-cover the mutex code spinlocks.
> >
> > > Also, I believe your patch permits this cleanup:
> > >
> > > ---
> > a/kernel/mutex-debug.h~mutex-use-spin_lock-instead-of-arch_spin_lock-fix
> > > +++ a/kernel/mutex-debug.h
> > > @@ -42,14 +42,12 @@ static inline void mutex_clear_owner(str
> > >               struct mutex *l = container_of(lock, struct mutex,
> > wait_lock); \
> > >                                                       \
> > >               DEBUG_LOCKS_WARN_ON(in_interrupt());    \
> > > -             local_irq_save(flags);                  \
> > > -             spin_lock(lock);                        \
> > > +             spin_lock_irqsave(lock, flags);         \
> >
> > Yes, I mentioned that yesterday, but we really don't want the
> > change to begin with.
> >
> > Thanks,
> >
> >         Ingo
> >
> 
> Hi,
> 
> Looks like in mutex.h, it does not disable local interrupt.  
> But why the code disable local interrupt in mutex-debug.h?

To protect against preemption I suspect. preempt_disable() could 
be used in the mutex-debug.h variant I suppose.

Thanks,

	Ingo
