Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaLAPFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:05:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbaLAPFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:05:54 -0500
Date: Mon, 1 Dec 2014 16:05:46 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Juergen Gross <jgross@suse.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>, Jan Beulich <JBeulich@suse.com>,
        Olaf Hering <ohering@suse.de>
Subject: Re: [PATCH] xen: privcmd: schedule() after private hypercall when
	non CONFIG_PREEMPT
Message-ID: <20141201150546.GC25677@wotan.suse.de>
References: <1417040805-15857-1-git-send-email-mcgrof@do-not-panic.com> <5476C66F.5040308@suse.com> <20141127183616.GV25677@wotan.suse.de> <547C4CEF.1010603@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547C4CEF.1010603@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:11:43AM +0000, David Vrabel wrote:
> On 27/11/14 18:36, Luis R. Rodriguez wrote:
> > On Thu, Nov 27, 2014 at 07:36:31AM +0100, Juergen Gross wrote:
> >> On 11/26/2014 11:26 PM, Luis R. Rodriguez wrote:
> >>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >>>
> >>> Some folks had reported that some xen hypercalls take a long time
> >>> to complete when issued from the userspace private ioctl mechanism,
> >>> this can happen for instance with some hypercalls that have many
> >>> sub-operations, this can happen for instance on hypercalls that use
> [...]
> >>> --- a/drivers/xen/privcmd.c
> >>> +++ b/drivers/xen/privcmd.c
> >>> @@ -60,6 +60,9 @@ static long privcmd_ioctl_hypercall(void __user *udata)
> >>>   			   hypercall.arg[0], hypercall.arg[1],
> >>>   			   hypercall.arg[2], hypercall.arg[3],
> >>>   			   hypercall.arg[4]);
> >>> +#ifndef CONFIG_PREEMPT
> >>> +	schedule();
> >>> +#endif
> 
> As Juergen points out, this does nothing.  You need to schedule while in
> the middle of the hypercall.
> 
> Remember that Xen's hypercall preemption only preempts the hypercall to
> run interrupts in the guest.

How is it ensured that when the kernel preempts on this code path on
CONFIG_PREEMPT=n kernel that only interrupts in the guest are run?

> >>>
> >>>   	return ret;
> >>>   }
> >>>
> >>
> >> Sorry, I don't think this will solve anything. You're calling schedule()
> >> right after the long running hypercall just nanoseconds before returning
> >> to the user.
> > 
> > Yeah, well that is what [1] tried as well only it tried using
> > preempt_schedule_irq() on the hypercall callback...
> 
> No.  My patch added a schedule point in the middle of a hypercall on the
> return from an interrupt (e.g., the timer interrupt).

OK that provides much better context and given that I do see the above hunk as
pointless. I was completely misrepresenting what the callback was for. Now --
just to address my issues with the use of preempt_schedule_irq(). If the above
is addressed that I think should address most of my concerns, if we can figure
out a way to not deal with it to be arch specific that'd be neat, and if we
could not have to ifdef around stuff even better.

  Luis
