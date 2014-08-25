Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbaHYOnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbaHYOnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:43:39 -0400
Date: Mon, 25 Aug 2014 16:41:11 +0200
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
Message-ID: <20140825144111.GB31880@redhat.com>
References: <20140824194700.GA27281@redhat.com> <20140824194736.GA27441@redhat.com> <CA+55aFyQzvvmWUDA01x69vYkrwUG07q9P3Mv5KaT31pOFsBZGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyQzvvmWUDA01x69vYkrwUG07q9P3Mv5KaT31pOFsBZGQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> fix Suresh's email...

(Damn, really fix this time, sorry for resend)

And the patch is buggy, fpu_finit(&tsk->thread.fpu) if __copy_from_user()
fails is obviously wrong, but this is fixable.

On 08/24, Linus Torvalds wrote:
>
> I really dislike this one.
>
> If I read it right, you now do *two* math_state_restore calls for each
> FPU signal state restore. That's potentially quite expensive.

Yes, this adds one restore_fpu_checking().

But only if a 32bit task does this. And only if use_eager_fpu(), and in
this case we do this on every context switch unconditionally.

So personally I think it is not that bad. And this allows to do more
cleanups (if this can actually work of course). But I can't really
judge.

> Also, you can actually end up with multiple threads pointing to the
> same math state in init_task.thread.fpu.state, right?

Yes. I think this should be fine, but let me remind that I do not
understand i387.

I think this should be safe, because this thread and/or swapper/0 can
do nothing with with fpu->state, and they should not use fpu. So I
hope that, say,  __save_init_fpu() and restore_fpu_checking() can race
with each other using the same fpu->state without any problem.
kernel_fpu_begin() looks fine to, fpu_save_init() should not hurt.

But again, again, this is only my speculation.

> Why is that any
> better than just having the save state temporarily contain garbage?

I do not know if restore_fpu_checking(garbage) is safe without
sanitize_restored_xstate(). Can't this, say, trigger an exception?

But there is another reason. Any preemption will overwrite ->xsave,
and I think this is the main reason why we should be careful.

> The other patches look sane, this one I really don't like. You may
> have good reasons for it, but it's disgusting.

5/5 (and other potential cleanups) depends on this change.

So do you still think this change is really bad? Or perhaps it is just
technically wrong?

We can probably do fault_in_pages() +  __copy_from_user_inatomic(), but
this will complicate the code more... Something like

	__copy_from_user(&env);	

	while (!fatal_signal_pending() && !fault_in_pages_readable(buf_fx)) {
			return -1;

		preempt_disable();
		if (!__copy_from_user_in_atomic(buf_fx)) {
			sanitize_restored_xstate(...);
			math_state_restore();
			done = true;
		}
		preempt_disable();
		if (done)
			break;
	}

not sure this looks better.

Other ideas or should I simply forget about these cleanups?


OK. Given that this patch at least needs more discussion, let me send another
simple fix first. This code calls math_state_restore() without preempt_disable()
and afaics this is very wrong and can lead to FPU corruption: if this task gets
a preemption after __thread_fpu_begin(), __save_init_fpu() will overwrite the
registers we are going to restore.

Btw, do you see any problem with another "shift drop_init_fpu() from
save_xstate_sig() to handle_signal()" fix I sent? I think that Bean Anderson
is right, this should be fixed.

Oleg.

