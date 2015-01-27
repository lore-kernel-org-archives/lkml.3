Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbbA0Tlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:41:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbbA0Tlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:41:45 -0500
Date: Tue, 27 Jan 2015 20:40:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: question about save_xstate_sig() - WHY DOES THIS WORK?
Message-ID: <20150127194030.GA29879@redhat.com>
References: <54C2A245.4010307@redhat.com> <20150124202021.GA1285@redhat.com> <54C6CD64.10208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C6CD64.10208@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Rik van Riel wrote:
>
> On 01/24/2015 03:20 PM, Oleg Nesterov wrote:
>
> > Now the questions:
> >
> > - This doesn't hurt, but does it really need __thread_fpu_end?
> >
> > Perhaps this is because we do not check the error code returned by
> > __save_init_fpu? although I am not sure I understand the comment
> > above fpu_save_init correctly...
>
> Looking at the code some more, I do not see any call site of
> save_init_fpu() that actually needs or wants __thread_fpu_end(),
> with or without eager fpu mode.

Yes. But probably it is needed if __save_init_fpu() returns 0.
But this is minor, __thread_fpu_end() doesn't hurt correctness-wise
if !eager.

> It looks like we can get rid of that.

Agreed, but probably this needs a separate change.

> > - What about do_bounds() ? Should not it use save_init_fpu()
> > rather than fpu_save_init() ?
>
> I suppose do_bounds() probably should save the fpu context while
> not preemptible,

plus it also needs the __thread_has_fpu() check. Otherwise fpu_save_init()
can save the wrong FPU state afaics.

> but that may also mean moving conditional_sti()
> until after save_init_fpu() or __save_init_fpu() has been called.

Agreed, this can work too.

> > - Why unlazy_fpu() always does __save_init_fpu() even if
> > use_eager_fpu?
> >
> > and note that in this case __thread_fpu_end() is wrong if
> > use_eager_fpu, but fortunately the only possible caller of
> > unlazy_fpu() is coredump. fpu_copy() checks use_eager_fpu().
> >
> > - Is unlazy_fpu()->__save_init_fpu() safe wrt __kernel_fpu_begin()
> > from irq?
> >
> > I mean, is it safe if __save_init_fpu() path is interrupted by
> > another __save_init_fpu() + restore_fpu_checking() from
> > __kernel_fpu_begin/end?
>
> I got lost in the core dump code trying to figure out whether this is
> safe or broken. I'll need some more time to look through that code...

It is called indirectly by regset code, see xstateregs_get()->init_fpu().

The coredumping task can't return to user-mode and use FPU in this case,
so this is not that bad. Still unlazy_fpu()->__thread_fpu_end() is wrong
if eager.

And I forgot to mention, the "else" branch in unlazy_fpu() makes no sense.
And note that save_init_fpu() and unlazy_fpu() is the same thing (if we
fix/cleanup them).

Oh. I'll try to finish my cleanups and send them tomorrow. Unless you
do this ;)

Oleg.

