Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbbAMQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:56:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbbAMQ4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:56:23 -0500
Date: Tue, 13 Jan 2015 17:55:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 02/11] x86,fpu: replace fpu_switch_t with a thread
	flag
Message-ID: <20150113165508.GB26931@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-3-git-send-email-riel@redhat.com> <20150113152409.GA23134@redhat.com> <54B5496E.7050001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B5496E.7050001@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13, Rik van Riel wrote:
>
> On 01/13/2015 10:24 AM, Oleg Nesterov wrote:
> > Rik,
> >
> > I can't review this series, I forgot almost everything I learned
> > about this code. The only thing I can recall is that it needs
> > cleanups and fixes ;) Just a couple of random questions.
> >
> > On 01/11, riel@redhat.com wrote:
> >>
> >> +static inline void switch_fpu_prepare(struct task_struct *old,
> >> struct task_struct *new, int cpu) { -	fpu_switch_t fpu; - /* * If
> >> the task has used the math, pre-load the FPU on xsave processors
> >> * or if the past 5 consecutive context-switches used math. */ -
> >> fpu.preload = tsk_used_math(new) && (use_eager_fpu() || +	bool
> >> preload = tsk_used_math(new) && (use_eager_fpu() ||
> >> new->thread.fpu_counter > 5); if (__thread_has_fpu(old)) { if
> >> (!__save_init_fpu(old)) @@ -433,8 +417,9 @@ static inline
> >> fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct
> >> ta old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
> >>
> >> /* Don't change CR0.TS if we just switch! */ -		if (fpu.preload)
> >> { +		if (preload) { new->thread.fpu_counter++; +
> >> set_thread_flag(TIF_LOAD_FPU); __thread_set_has_fpu(new);
> >> prefetch(new->thread.fpu.state); } else if (!use_eager_fpu()) @@
> >> -442,16 +427,19 @@ static inline fpu_switch_t
> >> switch_fpu_prepare(struct task_struct *old, struct ta } else {
> >> old->thread.fpu_counter = 0; old->thread.fpu.last_cpu = ~0; -		if
> >> (fpu.preload) { +		if (preload) { new->thread.fpu_counter++; if
> >> (!use_eager_fpu() && fpu_lazy_restore(new, cpu)) -				fpu.preload
> >> = 0; -			else +				/* XXX: is this safe against ptrace??? */
> >
> > Could you explain your concerns?
>
> Ptrace could modify the in-memory copy of a task's FPU context,
> while fpu_lazy_restore() could decide that the task's FPU context
> is still loaded in the registers (nothing else on the CPU has used
> the FPU since it last ran), and does not need to be re-loaded.

This connects to our discussion about 5/11. Debugger should reset
.last_cpu in this case.

Yes, yes, I agree this all needs cleanups ;)

> > Well, the comment is wrong after this patch, but I see 4/11...
>
> I did not want to change that same line in two different patches,
> with the idea that that would make things harder to review.
>
> >> /* work to do in syscall_trace_enter() */ #define
> >> _TIF_WORK_SYSCALL_ENTRY	\ @@ -141,7 +143,7 @@ struct thread_info
> >> { /* Only used for 64 bit */ #define _TIF_DO_NOTIFY_MASK						\
> >> (_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\ -
> >> _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE) +	 _TIF_USER_RETURN_NOTIFY
> >> | _TIF_UPROBE | _TIF_LOAD_FPU)
> >
> > This too. I mean, this change has no effect until 4/11.
>
> I can move this line to patch 4/11 if you prefer.

No, no, please ignore. I mentioned this only because I was a bit confused
initially.

Oleg.

