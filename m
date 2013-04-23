Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3DWLBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 07:01:05 -0400
Received: from relay.parallels.com ([195.214.232.42]:44007 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3DWLBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 07:01:04 -0400
Date: Tue, 23 Apr 2013 14:59:18 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>, <linux-kernel@vger.kernel.org>,
        Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] ptrace: add ability to get/set signal-blocked mask
Message-ID: <20130423105917.GA11121@paralelels.com>
References: <1366624400-9773-1-git-send-email-avagin@openvz.org>
 <20130422145704.GA30029@redhat.com>
 <20130422150710.GA30858@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20130422150710.GA30858@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.30.16.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 05:07:10PM +0200, Oleg Nesterov wrote:
> On 04/22, Oleg Nesterov wrote:
> >
> > On 04/22, Andrey Vagin wrote:
> > >
> > > +	case PTRACE_SETSIGMASK:
> > > +	{
> > > +		sigset_t new_set;
> > > +
> > > +		if (addr != sizeof(sigset_t)) {
> > > +			ret = -EINVAL;
> > > +			break;
> > > +		}
> > > +
> > > +		if (copy_from_user(&new_set, datavp, sizeof(sigset_t))) {
> > > +			ret = -EFAULT;
> > > +			break;
> > > +		}
> > > +
> > > +		sigdelsetmask(&new_set, sigmask(SIGKILL)|sigmask(SIGSTOP));
> > > +
> > > +		spin_lock_irq(&child->sighand->siglock);
> > > +		__set_task_blocked(child, &new_set);
> > > +		spin_unlock_irq(&child->sighand->siglock);
> >
> > No, please don't...
> >
> > set_current_blocked/__set_task_blocked assume that tsk == current.
> > If nothing else, note recalc_sigpending() in __set_task_blocked().

Thank you for the comment. It's my mistake.

> >
> > I don't understand "This method is not suitable for stopped tasks"

For example, a stopped process has a pending signal and this signal is
not blocked. crtools should dump its state, so that the process remains
in a stopped state with the same pending signal.

For dumping state crtools inject a parasite code with help POKE_DATA,
sets %rip on this code (PTRACE_SETREGS) and resumes the task
(PTRACE_CONT).

If signals are not blocked, the kernel starts to handle the signal after
resuming a process. It's out of our plan.

https://lkml.org/lkml/2011/7/20/138 - an example of code for injecting a
parasite code.

I hope the problem is become more clear.

> > from the changelog, but if you really need PTRACE_SETSIGMASK just
> > change ->blocked under siglock and do recalc_sigpending_tsk(child).
>                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> actually this is not necessary, the tracee will do recalc_sigpending()
> after resume. But perhaps a comment make sense.

__set_task_blocked executes retarget_shared_pending. I think it must be
called here too or am I wrong?

> 
> Oleg.
> 
