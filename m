Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbbAXUVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 15:21:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbbAXUVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 15:21:30 -0500
Date: Sat, 24 Jan 2015 21:20:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: question about save_xstate_sig() - WHY DOES THIS WORK?
Message-ID: <20150124202021.GA1285@redhat.com>
References: <54C2A245.4010307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C2A245.4010307@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me abuse this thread to ask more questions.

Peter, could you help?

On 01/23, Rik van Riel wrote:
>
> Not only is this broken with my new code, but it looks like it may
> be broken with the current code, too...

As I already mentioned, at least math_error()->save_init_fpu() looks
buggy. And unlazy_fpu() doesn't look right too.

Note that save_init_fpu() is calles after conditional_sti(), so unless
I missed something the task can be preempted and we can actually hit
WARN_ON_ONCE(!__thread_has_fpu()) if !use_eager_fpu() && .fpu_counter == 0.

Worse, the unconditional __save_init_fpu() is obviously wrong in this case.

I already have a patch which (like the patch from Rik) turns it into

	static inline void save_init_fpu(struct task_struct *tsk)
	{
		preempt_disable();
		if (__thread_has_fpu(tsk)) {
			if (use_eager_fpu()) {
				__save_fpu(tsk);
			} else {
				__save_init_fpu(tsk);
				__thread_fpu_end(tsk);
			}
		}
		preempt_enable();
	}

and I think this fix needs the separate patch/changelog.

Now the questions:

- This doesn't hurt, but does it really need __thread_fpu_end?

  Perhaps this is because we do not check the error code returned
  by __save_init_fpu? although I am not sure I understand the comment
  above fpu_save_init correctly...

- What about do_bounds() ? Should not it use save_init_fpu() rather
  than fpu_save_init() ?

- Why unlazy_fpu() always does __save_init_fpu() even if use_eager_fpu?

  and note that in this case __thread_fpu_end() is wrong if use_eager_fpu,
  but fortunately the only possible caller of unlazy_fpu() is coredump.
  fpu_copy() checks use_eager_fpu().

- Is unlazy_fpu()->__save_init_fpu() safe wrt __kernel_fpu_begin() from
  irq?

  I mean, is it safe if __save_init_fpu() path is interrupted by another
  __save_init_fpu() + restore_fpu_checking() from __kernel_fpu_begin/end?

Thanks,

Oleg.

