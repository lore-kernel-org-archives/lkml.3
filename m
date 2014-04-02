Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbaDBTBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:01:17 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38833 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969AbaDBTBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:01:13 -0400
Date: Wed, 2 Apr 2014 12:01:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>, Kevin Hilman <khilman@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] smp: Non busy-waiting IPI queue
Message-ID: <20140402190108.GR4284@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1396455966-21128-1-git-send-email-fweisbec@gmail.com>
 <1396455966-21128-2-git-send-email-fweisbec@gmail.com>
 <20140402180513.GQ4284@linux.vnet.ibm.com>
 <CAFTL4hyUC7JO6+H4kiLCLOxO7WzyC+MUKxE-jrmanZMM4dXSrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hyUC7JO6+H4kiLCLOxO7WzyC+MUKxE-jrmanZMM4dXSrg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040219-7164-0000-0000-000000BFBE60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 08:30:23PM +0200, Frederic Weisbecker wrote:
> 2014-04-02 20:05 GMT+02:00 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Wed, Apr 02, 2014 at 06:26:05PM +0200, Frederic Weisbecker wrote:
> >> diff --git a/kernel/smp.c b/kernel/smp.c
> >> index 06d574e..bfe7b36 100644
> >> --- a/kernel/smp.c
> >> +++ b/kernel/smp.c
> >> @@ -265,6 +265,50 @@ int smp_call_function_single_async(int cpu, struct call_single_data *csd)
> >>  }
> >>  EXPORT_SYMBOL_GPL(smp_call_function_single_async);
> >>
> >> +void generic_smp_queue_function_single_interrupt(void *info)
> >> +{
> >> +     struct queue_single_data *qsd = info;
> >> +
> >> +     WARN_ON_ONCE(xchg(&qsd->pending, 0) != 1);
> >
> > I am probably missing something here, but shouldn't this function copy
> > *qsd to a local on-stack variable before doing the above xchg()?  What
> > prevents the following from happening?
> >
> > o       CPU 0 does smp_queue_function_single(), which sets ->pending
> >         and fills in ->func and ->data.
> >
> > o       CPU 1 takes IPI, invoking generic_smp_queue_function_single_interrupt().
> >
> > o       CPU 1 does xchg(), so that ->pending is now zero.
> >
> > o       An attempt to reuse the queue_single_data sees ->pending equal
> >         to zero, so the ->func and ->data is overwritten.
> >
> > o       CPU 1 calls the new ->func with the new ->data (or any of the other
> >         two possible unexpected outcomes), which might not be helpful to
> >         the kernel's actuarial statistics.
> >
> > So what am I missing?
> 
> Ah, I forgot to precise that the function must remain the same for all
> calls on a single qsd. And the data is always the qsd so this one can
> only stay stable. So that shouldn't be a problem.

I did indeed miss that particular constraint.  ;-)

> But you're right. The fact that we pass the function as an argument of
> smp_queue_function_single() suggests that we can pass a different
> function across various calls on a same qsd. So that's confusing.
> Perhaps changing smp_queue_function_single() such that it only takes
> the qsd as an argument would make that clearer? Then it's up to the
> caller to initialize the qsd with the constant function. I could
> define smp_queue_function_init() for that purpose. Or
> DEFINE_QUEUE_FUNCTION_DATA() for static initializers.
> 
> How does that sound?

Sounds good!

							Thanx, Paul

