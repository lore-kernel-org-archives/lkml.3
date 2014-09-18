Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbaIRCXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:23:47 -0400
Received: from chicago.guarana.org ([198.144.183.183]:55471 "EHLO
	chicago.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaIRCXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:23:46 -0400
Date: Thu, 18 Sep 2014 13:23:34 +1000
From: Kevin Easton <kevin@guarana.org>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Message-ID: <20140918032334.GA26560@chicago.guarana.org>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
 <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com>
 <20140916075007.GA22076@chicago.guarana.org>
 <9E0BE1322F2F2246BD820DA9FC397ADE017B32C6@shsmsx102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE017B32C6@shsmsx102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:40:29AM +0000, Ren, Qiaowei wrote:
> > Would it be prudent to use an error code other than EINVAL for the
> > "hardware doesn't support it" case?
> >
> Seems like no specific error code for this case.

ENXIO would probably be OK.  It's not too important as long as it's
documented.

> 
> >> @@ -2011,6 +2017,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned
> > long, arg2, unsigned long, arg3,
> >>  			me->mm->def_flags &= ~VM_NOHUGEPAGE;
> >>  		up_write(&me->mm->mmap_sem);
> >>  		break;
> >> +	case PR_MPX_REGISTER:
> >> +		error = MPX_REGISTER(me);
> >> +		break;
> >> +	case PR_MPX_UNREGISTER:
> >> +		error = MPX_UNREGISTER(me);
> >> +		break;
> > 
> > If you pass me->mm from prctl, that makes it clear that it's
> > per-process not per-thread, just like PR_SET_DUMPABLE / PR_GET_DUMPABLE.
> > 
> > This code should also enforce nulls in arg2 / arg3 / arg4,/ arg5 if
> > it's not using them, otherwise you'll be sunk if you ever want to use them later.
> > 
> > It seems like it only makes sense for all threads using the mm to have
> > the same bounds directory set.  If the interface was changed to
> > directly pass the address, then could the kernel take care of setting
> > it for *all* of the threads in the process? This seems like something
> > that would be easier for the kernel to do than userspace.
> > 
> If the interface was changed to this, it will be possible for insane 
> application to pass error bounds directory address to kernel. We still 
> have to call fpu_xsave() to check this.

I was actually thinking that the kernel would take care of the xsave / 
xrstor (for current), updating tsk->thread.fpu.state (for non-running
threads) and sending an IPI for threads running on other CPUs.

Of course userspace can always then manually change the bounds directory
address itself, but then it's quite clear that they're doing something
unsupported.  Just an idea, anyway.

    - Kevin
