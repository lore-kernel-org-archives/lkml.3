Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3JXCap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 22:30:45 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:49859 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753025Ab3JXCan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 22:30:43 -0400
X-Greylist: delayed 983 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Oct 2013 22:30:43 EDT
In-Reply-To: <OF77F96D5F.776C09BF-ON48257BFE.00106C94-48257BFE.0020EF59@LocalDomain>
References: <OFCEFEC0A7.CD482CBA-ON48257BF2.000535D1-48257BF2.00066AD1@zte.com.cn>	 <1380219317.32071.6.camel@dvhart-mobl4.amr.corp.intel.com>
	 <OFFC4F71E6.FCD3279D-ON48257BF3.000E2A58-48257BF3.00251AFA@zte.com.cn> <1380295947.32071.69.camel@dvhart-mobl4.amr.corp.intel.com> <OF77F96D5F.776C09BF-ON48257BFE.00106C94-48257BFE.0020EF59@LocalDomain>
Subject: Re: Re: Re: Re: [PATCH] futex: Remove the owner check when waking task in
 handle_futex_death
X-KeepSent: B158B42B:9D58FA32-48257C0E:000BF4D4;
 type=4; name=$KeepSent
To: Darren Hart <dvhart@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFB158B42B.9D58FA32-ON48257C0E.000BF4D4-48257C0E.000C48E8@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Thu, 24 Oct 2013 10:13:56 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-10-24 10:14:02
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-MAIL: mse02.zte.com.cn r9O2E7Mb084196
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Zhang Yi <zhang.yi20@zte.com.cn> wrote on 2013/10/08 13:59:36:

> Re: Re: Re: [PATCH] futex: Remove the owner check when waking task in handle_futex_death
>
> Darren Hart <dvhart@linux.intel.com> wrote on 2013/09/27 23:32:27:

> >
> > Re: Re: [PATCH] futex: Remove the owner check when waking task in handle_futex_death
> >
> > >
> > > The earlier patch cannot solve another problem:
> > > The owner wakes the next waiter through normal unlocking which make the
> > > futex value as zero, the waked task exits before actually locking the mutex.
> > > In this case, the owner doesn't call handle_futex_death() and the waked task
> > > doesn't call futex_wake() when they are dying. The rest waiters will still
> > > block as the same.
> > >
> > > This is also the reason that I drop the owner and FUTEX_WAITERS check,
> > > because the futex value can be zero at that time.
> > >
> >
> > If the FUTEX_WAITERS bit is not set, there are no waiters, and thus no
> > need to wake. I understand why you dropped the OWNER check, but I'm not
> > following this one. Where would the futex word be set from having
> > waiters to zero when there might still be waiters pending?
> >
> >
> > --
> > Darren Hart
> > Intel Open Source Technology Center
> > Yocto Project - Linux Kernel
> >
> >

> I have drawn a diagram as below:
>
>                process1                     |      process2
>    -------------------------------------------------------------
>   |       thread1       |      thread2      |      thread3
>    -------------------------------------------------------------
> t1|pthread_mutex_lock:  |                   |
>   |  __lock=self        |                   |
>   |                     |                   |
> t2|                     |pthread_mutex_lock:|
>   |                     |__lock|=FUTEX_WAITERS
>   |                     | syscall futex_wait|
>   |                     |                   |
> t3|                     |                   |pthrea_mutex_lock:
>   |                     |                   |__lock|=FUTEX_WAITERS
>   |                     |                   | syscall futex_wait
>   |                     |                   |
> t4|pthread_mutex_unlock:|                   |
>   |  __lock=0           |                   |
>   |  syscall futex_wake | waked             |
>   |                     |                   |
> t5| exit                |exit:              |
>   |                     | handle_futex_death|
> ---------------------------------------------------------------
> t6|                     |pthread_mutex_lock:|
>   |                     |__lock=self|FUTEX_WAITERS
>
> 1, At time t4, in the unlocking process of glibc, it clears the FUTEX_WAITERS bit before
> calling futex_wake syscall.
>
> 2, At time t5, thread2 cannot know if the FUTEX_WAITERS bit was set.
>
> 3, Time t6 is expected but can never be true.

Are there any questions?

