Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3CCVuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 16:50:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31466 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab3CCVux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 16:50:53 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=kgYMabYmpb8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=dqICLntVI3MA:10 a=pGLkceISAAAA:8 a=t7CeM3EgAAAA:8 a=7cPCDnJzvlj1FLPZnkMA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362347450.31874.16.camel@gandalf.local.home>
Subject: Re: [PATCH] futex: fix unbalanced spin_lock/spin_unlock() in
 exit_pi_state_list()
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Date: Sun, 03 Mar 2013 16:50:50 -0500
In-Reply-To: <alpine.LFD.2.02.1303011047170.22263@ionos>
References: <1362101815-19968-1-git-send-email-yong.zhang0@gmail.com>
	 <alpine.LFD.2.02.1303011047170.22263@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 11:17 +0100, Thomas Gleixner wrote:

> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/futex.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index 9e26e87..2b676a2 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -562,16 +562,17 @@ void exit_pi_state_list(struct task_struct *curr)
> >  
> >  		spin_lock(&hb->lock);
> >  
> > -		raw_spin_lock_irq(&curr->pi_lock);
> >  		/*
> >  		 * We dropped the pi-lock, so re-check whether this
> >  		 * task still owns the PI-state:
> >  		 */
> 
> Did you read and understand this comment ?
> 
> The logic here is
> 
>     raw_spin_lock_irq(&curr->pi_lock);
>     next = head->next;
>     raw_spin_unlock_irq(&curr->pi_lock);
>     spin_lock(&hb->lock);
>     raw_spin_lock_irq(&curr->pi_lock);
>     if (head->next != next)
> 
> We must drop pi_lock before locking the hash bucket lock. That opens a
> window for another task to modify head list. So we must relock pi_lock
> and verify whether head->next is unmodified. If it changed, we need to
> reevaluate.
> 
> >  		if (head->next != next) {
> >  			spin_unlock(&hb->lock);
> > +			raw_spin_lock_irq(&curr->pi_lock);
> >  			continue;
> >  		}
> >  
> > +		raw_spin_lock_irq(&curr->pi_lock);
> >  		WARN_ON(pi_state->owner != curr);
> >  		WARN_ON(list_empty(&pi_state->list));
> >  		list_del_init(&pi_state->list);
> 
> So both your patch description and your patch are patently wrong.
> Correct solution below.
> 
> Thanks,
> 
> 	tglx
> ---
> futex: Ensure lock/unlock symetry versus pi_lock and hash bucket lock
> 
> In exit_pi_state_list() we have the following locking construct:
> 
>    spin_lock(&hb->lock);
>    raw_spin_lock_irq(&curr->pi_lock);
>    
>    ...
>    spin_unlock(&hb->lock);
> 
> In !RT this works, but on RT the migrate_enable() function which is
> called from spin_unlock() sees atomic context due to the held pi_lock
> and just decrements the migrate_disable_atomic counter of the
> task. Now the next call to migrate_disable() sees the counter being
> negative and issues a warning. That check should be in
> migrate_enable() already.
> 
> Fix this by dropping pi_lock before unlocking hb->lock and reaquire
> pi_lock after that again. This is safe as the loop code reevaluates
> head again under the pi_lock.
> 
> Reported-by: Yong Zhang <yong.zhang@windriver.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index f15f0e4..c795c9c 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -568,7 +568,9 @@ void exit_pi_state_list(struct task_struct *curr)
>  		 * task still owns the PI-state:
>  		 */
>  		if (head->next != next) {

Can we add the following comment here:

	/*
	 * Normal spin_lock() and matching spin_unlock() must not be
	 * inside a raw_spin_lock() or any raw preempt disabled
	 * context.
	 */

Or something similar. Otherwise, people looking at this may think that
the unlock and relock is unnecessary. Or they may just not understand it
in general. Things like this deserve comments, or we ourselves may
forget why we did it ;-)

We probably should document somewhere (if we haven't already, I haven't
looked), that if a spin_trylock() is inside a preempt disabled section,
the entire context of that lock must stay inside a preempt disabled
section (to the unlock). No normal spin_lock()s, and their matching
unlocks, should be in any preempt disabled section, although a preempt
disabled section may exist between the two.

-- Steve

> +			raw_spin_unlock_irq(&curr->pi_lock);
>  			spin_unlock(&hb->lock);
> +			raw_spin_lock_irq(&curr->pi_lock);
>  			continue;
>  		}
>  


