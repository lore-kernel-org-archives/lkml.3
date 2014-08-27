Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaH0Rnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:43:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbaH0Rnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:43:45 -0400
Date: Wed, 27 Aug 2014 19:02:33 +0200
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
Message-ID: <20140827170233.GA6092@redhat.com>
References: <20140824194700.GA27281@redhat.com> <20140824194736.GA27441@redhat.com> <CA+55aFyQzvvmWUDA01x69vYkrwUG07q9P3Mv5KaT31pOFsBZGQ@mail.gmail.com> <20140825144111.GB31880@redhat.com> <CA+55aFwNUF+CLWKkDBe56xOtK_JTj9zHWip+_Ep41GJniN+sPw@mail.gmail.com> <20140825170920.GA8338@redhat.com> <CA+55aFw_-_h9Rj8F1H-nRm2-x8wMZ=f0ee122UXCVyJ_seuk2w@mail.gmail.com> <20140825173930.GA10376@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825173930.GA10376@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm afraid you all already hate me, but let me continue to spam your
mailboxes.

On 08/25, Oleg Nesterov wrote:
>
> I'll try to play with copy_from_user_in_atomic(), if nothing else just
> to complete the discussion and see how the code can look in this case.

OK, to complete the discussion, the code looks simple unless I missed
something,

	if (ia32_fxstate) {
		/*
		 * For 32-bit frames with fxstate, copy the user state to the
		 * thread's fpu state, reconstruct fxstate from the fsave
		 * header. Sanitize the copied state etc.
		 */
		struct xsave_struct *xsave = &tsk->thread.fpu.state->xsave;
		struct user_i387_ia32_struct env;
		bool done;

		if (__copy_from_user(&env, buf, sizeof(env))
			return -1;

		for (done = false; !done; ) {
			if (fatal_signal_pending(current) ||
			    fault_in_pages_readable(buf_fx, state_size))
				return -1;

			preempt_disable();
			pagefault_disable(); /* not really needed */
			done = !__copy_from_user_inatomic(xsave, buf_fx, state_size);
			pagefault_enable();
			if (likely(done)) {
				sanitize_restored_xstate(tsk, &env, xstate_bv, fx_only);
				if (__thread_has_fpu(tsk))
					math_state_restore();
			} else {
				fpu_finit(&tsk->thread.fpu);
			}
			preempt_enable();
		}

		return 0;
	}

and in some sense it is even simpler because we do not care about
use_eager_fpu() or set/clear_used_math().

Does it look better than switch_fpu_xstate() hack?


However, this code can race with kernel_fpu_begin() if use_eager_fpu().
I _think_ that kernel_fpu_begin/end and irq_fpu_usable() need cleanups
too and in any case. Will try to do, but I am not sure.

And to spam you even more, I'll send you a couple of other, more simple
cleanups.

Oleg.

