Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3AURWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:22:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250Ab3AURWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:22:39 -0500
Date: Mon, 21 Jan 2013 18:21:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Kernel Security <security@kernel.org>,
        Michael Davidson <md@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Julien Tinnes <jln@google.com>,
        Aaron Durbin <adurbin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@hack.frob.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/4] ptrace: ensure arch_ptrace/ptrace_request can
	never race with SIGKILL
Message-ID: <20130121172151.GA4691@redhat.com>
References: <20130118153700.GA27915@redhat.com> <CA+55aFxEow_-PoX0xFa07yOi6az=6uVx8zeOsfToErmzh7dB8A@mail.gmail.com> <20130118172854.GA29753@redhat.com> <20130118175224.GA520@redhat.com> <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com> <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com> <20130120192448.GA6771@redhat.com> <20130120192527.GC6771@redhat.com> <CA+55aFx1+hFSCa4nX80C30BkEOugXRvBZ=7LA+u+KOq_qSaJsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx1+hFSCa4nX80C30BkEOugXRvBZ=7LA+u+KOq_qSaJsg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Linus Torvalds wrote:
>
> On Sun, Jan 20, 2013 at 11:25 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > +
> > +static void ptrace_unfreeze_traced(struct task_struct *task)
> > +{
> > +       if (task->state != __TASK_TRACED)
> > +               return;
> > +
> > +       if (WARN_ON(!task->ptrace || task->parent != current))
> > +               return;
>
> This WARN_ON() is bogus.
>
> Because you added the warning, you then need to make the callers check
> for the whole PTRACE_UNATTACH.
>
> So I think you should just remove the WARN_ON(), and then just call
> ptrace_unfreeze_traced() unconditionally after you've successfully
> done a ptrace_check_attach(). Just to keep the code simpler.

This is what initial patch did. But, assuming that ptrace_unfreeze_traced()
is called unconditionally, we need a locking or barriers, otherwise

	// another debugger attached after we did PTRACE_DETACH ?
	if (!task->ptrace || task->parent != current)
		return;

is racy. Suppose we trace the natural child, then do PTRACE_DETACH,
then another tracer comes. We can see ->ptrace and __TASK_TRACED,
but see the old task->parent == current.

Of course, this is only theoretical, and probably we can add a barrier
before this check, but I am not sure this will make the code simpler.
If nothing else, this needs a comment.

If PTRACE_DETACH doesn't do _unfreeze_, we know that the task is either
traced by us or it is exiting/exited, so we can always trust the
"state == __TASK_TRACED" check.

So I'd prefer to keep this code, but I won't insist if you still disagree.

> Also, in your corrected version, you had
>
> +               if (!wait_task_inactive(child, __TASK_TRACED)) {
> +                       /* This can only happen if may_ptrace_stop() fails */
> +                       WARN_ON(child->state == __TASK_TRACED);
> +                       ret = -ESRCH;
>
> where I actually think that the comment is not really helpful. It
> doesn't really explain what he child can do to get to ptrace_stop() in
> the first place, and what that does to the child state...

OK. Agreed. This comment reflects the fact that the first version removed
may_ptrace_stop() to ensure wait_task_inactive() can't fail.

I'll update the comment and resend.

Oleg.

