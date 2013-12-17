Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3LQOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:16:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:37452 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753989Ab3LQOQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:16:27 -0500
Date: Tue, 17 Dec 2013 09:16:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mike Galbraith <bitbucket@online.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.5-rt6
Message-ID: <20131217091624.65be757c@gandalf.local.home>
In-Reply-To: <20131217124248.GA21694@linutronix.de>
References: <20131216091431.GA13796@linutronix.de>
	<1387264591.5340.23.camel@marge.simpson.net>
	<20131217063156.6ac3bfed@gandalf.local.home>
	<20131217124248.GA21694@linutronix.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013 13:42:48 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

 
> >> @@ -1068,8 +1082,10 @@ unsigned long wait_task_inactive(struct
> >>  		 * is actually now running somewhere else!
> >>  		 */
> >>  		while (task_running(rq, p)) {
> >> -			if (match_state && unlikely(p->state != match_state))
> >> +			if (match_state && unlikely(p->state != match_state)
> >> +			    && unlikely(p->saved_state != match_state))
> >>  				return 0;
> >> +			}
> >
> >Yeah, it should just be:
> >
> >		if (match_state && check_task_state(p, match_state))
> >			return 0;
> 
> Are you sure?

No :-)

> If the state matches we should continue as long as it runs
> therefore I would go for !check_task_state(). The problem here was that

Yeah yeah, hey, I typed it by hand, no cut and paste there. Thus, I
dropped the '!' by accident ;-)

Hey! Here's a case where cut and paste would have prevented the bug!


> I return 0 in both cases.
> 
> >Also, looking at check_task_state():
> >
> >+static bool check_task_state(struct task_struct *p, long match_state)
> >+{
> >+       bool match = false;
> >+
> >+       raw_spin_lock_irq(&p->pi_lock);
> >+       if (p->state == match_state)
> >+               match = true;
> >+       else if (p->saved_state == match_state)
> >+               match = true;
> >
> >Why the if () else if()? and not just:
> >
> >	if (p->state == match_state || p->save_state == match_state)
> >		match = true;
> >?
> >
> >The else if makes me think there's something missing.
> 
> Okay I can do this. But regarding the check_task_state part, I think I
> should go with:
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1076,9 +1076,7 @@ static bool check_task_state(struct task_struct *p, long match_state)
>  	bool match = false;
>  
>  	raw_spin_lock_irq(&p->pi_lock);
> -	if (p->state == match_state)
> -		match = true;
> -	else if (p->saved_state == match_state)
> +	if (p->state == match_state || p->saved_state == match_state)
>  		match = true;
>  	raw_spin_unlock_irq(&p->pi_lock);
>  
> @@ -1129,11 +1127,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
>  		 * is actually now running somewhere else!
>  		 */
>  		while (task_running(rq, p)) {
> -			if (match_state) {
> -				if (!unlikely(check_task_state(p, match_state)))
> -					return 0;
> +			if (match_state && !check_task_state(p, match_state))

Ah, it was that "!unlikely(" that caused me to miss the '!'. That
should have been: likely(!check_task_state()). But anyway, I rather
just keep what you wrote and drop the unlikely altogether.


>  				return 0;
> -			}
>  			cpu_relax();
>  		}
>  
> 
>  Any objections?
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
