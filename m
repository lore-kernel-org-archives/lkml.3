Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbaHYRLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:11:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbaHYRLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:11:47 -0400
Date: Mon, 25 Aug 2014 19:09:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, fpu: don't drop_fpu() in
	__restore_xstate_sig() if use_eager_fpu()
Message-ID: <20140825170920.GA8338@redhat.com>
References: <20140824194700.GA27281@redhat.com> <20140824194736.GA27441@redhat.com> <CA+55aFyQzvvmWUDA01x69vYkrwUG07q9P3Mv5KaT31pOFsBZGQ@mail.gmail.com> <20140825144111.GB31880@redhat.com> <CA+55aFwNUF+CLWKkDBe56xOtK_JTj9zHWip+_Ep41GJniN+sPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwNUF+CLWKkDBe56xOtK_JTj9zHWip+_Ep41GJniN+sPw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Linus Torvalds wrote:
>
> On Mon, Aug 25, 2014 at 7:41 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > I think this should be safe, because this thread and/or swapper/0 can
> > do nothing with with fpu->state, and they should not use fpu.
>
> .. but if that's the case, then what was wrong with the old code

Confused... Just in case, I think that you mean current code, and ignoring
the lack of preempt_disable() around math_state_restore() it is correct.

I'd like to change it only because this code is the main source of the
nasty special case, used_math() and/or __thread_has_fpu(current) can be
false even if use_eager_fpu().

> that
> just copied the state over the unused space from the user space
> buffer?

But it is not unused? Although I probably misunderstood you from the
very beginning.

OK, what I meant that without switch_fpu_xstate(init_task.fpu.state)
or another hack we can't avoid drop_fpu() which leads to this special
case.

Currently __copy_from_user(&xstate->xsave) copies the new registers
right into this thread's fpu->state. If this thread is preempted before
math_state_restore(), the context switch (__save_init_fpu) will overwrite
the same buffer, the result of __copy_from_user() can be simply lost
(entirely or not).

With this patch we can safely do __copy_from_user(xstate), this buffer
is not used until the 2nd switch_fpu_xstate().

> You can't have it both ways. Either the old code was fine (because it
> doesn't use the buffer while it is in flux), or the new code is broken
> (because it uses the shared buffer). Your choice.No?

It uses the shared buffer, yes. But in this case (I think! please correct
me!), when this thread uses the swapper's fpu->state, schedule() ->
fpu_xsave() into this shared buffer should be fine because it should write
the same content?

Oleg.

