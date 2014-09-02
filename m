Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaIBNAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:00:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbaIBNAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:00:52 -0400
Date: Tue, 2 Sep 2014 14:58:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <sbsiddha@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86, fpu: irq_fpu_usable: kill all checks except
	!in_kernel_fpu
Message-ID: <20140902125810.GB18534@redhat.com>
References: <20140827185138.GA12487@redhat.com> <CA+55aFwi-S27_maZXU+baOqPAYfi_NTGcfbnRnk45+B8+i4hVQ@mail.gmail.com> <20140828111628.GB15276@redhat.com> <20140829181533.GA30659@redhat.com> <20140829181729.GE30659@redhat.com> <CALmL7E8mTeALSjSXkgVQs=KW9AX5K4r5k63foiP0Vy5ue8Vfgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALmL7E8mTeALSjSXkgVQs=KW9AX5K4r5k63foiP0Vy5ue8Vfgg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02, Suresh Siddha wrote:
>
> On Fri, Aug 29, 2014 at 11:17 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > ONCE AGAIN, THIS IS MORE THE QUESTION THAN THE PATCH.
>
> this patch I think needs more thought for sure. please see below.

Of course.

> > interrupted_kernel_fpu_idle() does:
> >
> >         if (use_eager_fpu())
> >                 return true;
> >
> >         return !__thread_has_fpu(current) &&
> >                 (read_cr0() & X86_CR0_TS);
> >
> > and it is absolutely not clear why these 2 cases differ so much.
> >
> > To remind, the use_eager_fpu() case is buggy; __save_init_fpu() in
> > __kernel_fpu_begin() can race with math_state_restore() which does
> > __thread_fpu_begin() + restore_fpu_checking(). So we should fix this
> > race anyway and we can't require __thread_has_fpu() == F likes the
> > !use_eager_fpu() case does, in this case kernel_fpu_begin() will not
> > work if it interrupts the idle thread (this will reintroduce the
> > performance regression fixed by 5187b28f).
> >
> > Probably math_state_restore() can use kernel_fpu_disable/end() which
> > sets/clears in_kernel_fpu, or it can disable irqs. Doesn't matter, we
> > should fix this bug anyway.
> >
> > And if we fix this bug, why else !use_eager_fpu() case needs the much
> > more strict check? Why we can't handle the __thread_has_fpu(current)
> > case the same way?
> >
> > The comment deleted by this change says:
> >
> >         and TS must be set so that the clts/stts pair does nothing
> >
> > and can explain the difference, but I can not understand this (again,
> > assuming that we fix the race(s) mentoined above).
> >
> > Say, user_fpu_begin(). Yes, kernel_fpu_begin/end() can restore X86_CR0_TS.
> > But this should be fine?
>
> No. The reason is that has_fpu state and cr0.TS can get out of sync.
>
> Let's say you get an interrupt after clts() in __thread_fpu_begin()
> called as part of user_fpu_begin().
>
> And because of this proposed change, irq_fpu_usable() returns true and
> an interrupt can end-up using fpu and after the return from interrupt
> we can have a state where cr0.TS is set but we end up resuming the
> execution from __thread_set_has_fpu(). Now after this point has_fpu is
> set but cr0.TS is set. And now any schedule() with this state (let's
> say immd after preemption_enable() at the end of user_fpu_begin()) is
> dangerous. We can get a dna fault in the middle of __switch_to() which
> can lead to subtle bugs.

Thanks. Yes, I thought about this race, but I didn't realize that a DNA
inside __switch_to() is dangerous.

Thanks a lot. OK, this is trivially fixable. I had this v2 in mind from
the very beginning because I was not really sure that unconditional stts()
in kernel_fpu_end() is safe (but yes, I didn't realize why). Just we need
to save X86_CR0_TS in the same per-cpu in_kernel_fpu,

	static DEFINE_PER_CPU(int, in_kernel_fpu);

	void __kernel_fpu_begin(void)
	{
		struct task_struct *me = current;

		this_cpu_write(in_kernel_fpu, 1);

		if (__thread_has_fpu(me)) {
			__save_init_fpu(me);
		} else if (!use_eager_fpu()) {
			this_cpu_write(fpu_owner_task, NULL);
			if ((read_cr0() & X86_CR0_TS))
				this_cpu_write(in_kernel_fpu, 2);
				clts();
			}
		}
	}

	void __kernel_fpu_end(void)
	{
		struct task_struct *me = current;

		if (__thread_has_fpu(me)) {
			if (WARN_ON(restore_fpu_checking(me)))
				drop_init_fpu(me);
		} else if (!use_eager_fpu()) {
			if (this_cpu_read(in_kernel_fpu) == 2)
				stts();
		}

		this_cpu_write(in_kernel_fpu, 0);
	}

Or, perhaps better, we can turn user_fpu_begin()->preempt_disable()
into kernel_fpu_disable().

Do you think this can work?

> other than this patch, rest of the changes look ok to me. Can you
> please resend this patchset with the math_state_restore() race
> addressed aswell?

OK, will do, but probably next week.

Will you agree if I add kernel_fpu_disable/enable to fix this race?
It can probably have more users (see above).

Thanks!

Oleg.

