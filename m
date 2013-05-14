Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab3ENKi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:38:59 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38875 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3ENKi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:38:58 -0400
Date: Tue, 14 May 2013 03:38:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time
 as with v3.9
Message-ID: <20130514103852.GE17576@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87r4hdjsu5.fsf@nemi.mork.no>
 <20130512113157.GG3648@linux.vnet.ibm.com>
 <87hai8kwgh.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87hai8kwgh.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051410-3620-0000-0000-00000277D6E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 06:13:34PM +0200, Bjørn Mork wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > We don't want to back out the RCU_FAST_NO_HZ changes due to their
> > energy-efficiency benefits.
> 
> Yes, that's what I assumed.  Just didn't know where to start dissecting
> it...
> 
> >  So could you please try out Borislav's
> > patch below?  He ran into the same issue a few weeks ago, and this
> > one fixed it for him.
> >
> > 							Thanx, Paul
> >
> > ------------------------------------------------------------------------
> >
> > rcu: Expedite grace periods during suspend/resume
> >
> > CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by up to
> > a factor of four, which can result in long suspend and resume times.
> > Thus, this commit temporarily switches to expedited grace periods when
> > suspending the box and return to normal settings when resuming.
> >
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index a9610d1..d9604a4 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -53,6 +53,7 @@
> >  #include <linux/delay.h>
> >  #include <linux/stop_machine.h>
> >  #include <linux/random.h>
> > +#include <linux/suspend.h>
> >  
> >  #include "rcutree.h"
> >  #include <trace/events/rcu.h>
> > @@ -3003,6 +3004,22 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
> >  	return NOTIFY_OK;
> >  }
> >  
> > +static int rcu_pm_notify(struct notifier_block *self,
> > +			 unsigned long action, void *hcpu)
> > +{
> > +	switch (action) {
> > +	case PM_HIBERNATION_PREPARE:
> > +		rcu_expedited = 1;
> > +		break;
> > +	case PM_POST_RESTORE:
> > +		rcu_expedited = 0;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +	return NOTIFY_OK;
> > +}
> > +
> >  /*
> >   * Spawn the kthread that handles this RCU flavor's grace periods.
> >   */
> > @@ -3243,6 +3260,7 @@ void __init rcu_init(void)
> >  	 * or the scheduler are operational.
> >  	 */
> >  	cpu_notifier(rcu_cpu_notify, 0);
> > +	pm_notifier(rcu_pm_notify, 0);
> >  	for_each_online_cpu(cpu)
> >  		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
> >  }
> 
> 
> Thanks!  This patch did not make any difference for me by itself, for
> pretty obvious reasons (I didn't time restore from hibernate - only from
> suspend). But it pointed me in the right direction.  Applying the
> attached patch on top of that one fixed the problem.
> 
> Note that I'm also changing the restore from hibernate hook. According
> to Documentation/power/notifiers.txt :
> 
>  PM_POST_RESTORE         An error occurred during restore from hibernation.
>                          Device drivers' restore callbacks have been executed
>                          and tasks have been thawed.
> 
> 
> I believe Borislav must have meant 
> 
>  PM_POST_HIBERNATION     The system memory state has been restored from a
>                          hibernation image or an error occurred during
>                          hibernation.  Device drivers' restore callbacks have
>                          been executed and tasks have been thawed.
> 
> in the above patch?
> 
> Please include some combination of these patches in your upcoming v3.10
> fixes.  Thanks.

I have queued the following patch, thank you, Bjørn!

							Thanx, Paul

> Bjørn
> 

> >From cf169d21274911fea4b6a89a0a2c7b370d9de441 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
> Date: Sun, 12 May 2013 17:51:10 +0200
> Subject: [PATCH] rcu: Really switch to expedited grace periods for suspend
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> commit 587ff2cf ("rcu: Expedite grace periods during suspend/resume")
> enabled expedited grace periods for hibernation, but not for suspend.
> The same issue applies to both cases, so apply the same logic.
> 
> Restoring on post hibernation and post suspend, but not on post
> restore, which only applies to the restore error case.
> 
> Cc: Borislav Petkov <bp@suse.de>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
>  kernel/rcutree.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 6934238..2dcbf84 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -3103,9 +3103,11 @@ static int rcu_pm_notify(struct notifier_block *self,
>  {
>  	switch (action) {
>  	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
>  		rcu_expedited = 1;
>  		break;
> -	case PM_POST_RESTORE:
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_SUSPEND:
>  		rcu_expedited = 0;
>  		break;
>  	default:
> -- 
> 1.7.10.4
> 

