Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3EFIFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:05:44 -0400
Received: from relay.parallels.com ([195.214.232.42]:46821 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3EFIFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:05:42 -0400
Date: Mon, 6 May 2013 12:03:54 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Vagin <avagin@openvz.org>, <linux-kernel@vger.kernel.org>,
        Roland McGrath <roland@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] ptrace: add ability to get/set signal-blocked mask (v2)
Message-ID: <20130506080354.GA25568@paralelels.com>
References: <1366729843-24148-1-git-send-email-avagin@openvz.org>
 <20130423152143.GA30125@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20130423152143.GA30125@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.30.16.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, let me know if you are waiting something to accept this patch.

Thanks.

On Tue, Apr 23, 2013 at 05:21:43PM +0200, Oleg Nesterov wrote:
> On 04/23, Andrey Vagin wrote:
> >
> > @@ -841,6 +841,48 @@ int ptrace_request(struct task_struct *child, long request,
> >  			ret = ptrace_setsiginfo(child, &siginfo);
> >  		break;
> >  
> > +	case PTRACE_GETSIGMASK:
> > +		if (addr != sizeof(sigset_t)) {
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> > +
> > +		if (copy_to_user(datavp, &child->blocked, sizeof(sigset_t)))
> > +			ret = -EFAULT;
> 
> Yes, we can do this lockless. Only the task itself (or the debugger with
> this patch) can change ->blocked, and the tracee can't run.
> 
> > +	case PTRACE_SETSIGMASK:
> > +	{
> > +		sigset_t new_set;
> > +
> > +		if (addr != sizeof(sigset_t)) {
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> > +
> > +		if (copy_from_user(&new_set, datavp, sizeof(sigset_t))) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +
> > +		sigdelsetmask(&new_set, sigmask(SIGKILL)|sigmask(SIGSTOP));
> > +
> > +		/*
> > +		 * Every thread does recalc_sigpending() after resume, so
> > +		 * retarget_shared_pending() and recalc_sigpending() are not
> > +		 * called here.
> > +		 */
> > +		spin_lock_irq(&child->sighand->siglock);
> > +		child->blocked = new_set;
> > +		spin_unlock_irq(&child->sighand->siglock);
> > +
> > +		ret = 0;
> > +		break;
> > +	}
> 
> And this looks fine too.
> 
> Personally I am not sure we need to check addr == sizeof(), debugger
> should know what it does... But I won't argue.

We do the same thing in sys_rt_sigaction. I think it may be useful in a
future, if we decide to change the size of sigset_t.

> 
> Oleg.
> 
