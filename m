Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbaJHMT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:19:58 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47278 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbaJHMTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:19:44 -0400
Date: Wed, 8 Oct 2014 05:19:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] workqueue: add quiescent state between work items
Message-ID: <20141008121938.GJ4880@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
 <1412529862-17954-2-git-send-email-joe.lawrence@stratus.com>
 <20141005192119.GE8549@htj.dyndns.org>
 <20141005194748.GG8549@htj.dyndns.org>
 <20141006042158.GW5015@linux.vnet.ibm.com>
 <20141007072942.GA2088@nanopsycho.orion>
 <20141007134329.GA4880@linux.vnet.ibm.com>
 <20141007134528.1a59f31b@jlaw-desktop.mno.stratus.com>
 <20141008032411.GG4880@linux.vnet.ibm.com>
 <20141008115428.GA1858@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008115428.GA1858@nanopsycho.orion>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100812-0013-0000-0000-00000564A51F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 01:54:28PM +0200, Jiri Pirko wrote:
> Wed, Oct 08, 2014 at 05:24:11AM CEST, paulmck@linux.vnet.ibm.com wrote:
> >On Tue, Oct 07, 2014 at 01:45:28PM -0400, Joe Lawrence wrote:
> >> On Tue, 7 Oct 2014 06:43:29 -0700
> >> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >> 
> >> > On Tue, Oct 07, 2014 at 09:29:42AM +0200, Jiri Pirko wrote:
> >> [ ... snip ... ]
> >> > > 
> >> > > Paul, Tehun, how do you propose to fix this on older kernels which do
> >> > > not have rcu_note_voluntary_context_switch? I'm particullary interested
> >> > > in 3.10.
> >> > 
> >> > Hello, Jiri,
> >> > 
> >> > Older kernels can instead use rcu_note_context_switch().
> >> 
> >> Hi Paul,
> >> 
> >> Does 4a81e8328d37 ("rcu: Reduce overhead of cond_resched() checks for
> >> RCU") affect a backport to 3.10?
> >> 
> >> I noticed that rcu_note_context_switch added a call to
> >> rcu_momentary_dyntick_idle in that change, which is only present in
> >> v3.16+.
> >> 
> >> Would rcu_note_context_switch be effective by itself on a 3.10 kernel?
> >
> >Should be fine.  There is more overhead than current mainline, but that
> >should not be in the noise compared to executing a work-queue item.
> >
> >							Thanx, Paul
> >
> 
> I cooked up following patch. Please tell me if it is fine or not. I can
> also send it oficially so it can be included into stable trees:

Looks good!

							Thanx, Paul

> Subject: workqueue: Add quiescent state between work items
> 
> Similar to the stop_machine deadlock scenario on !PREEMPT kernels
> addressed in b22ce2785d97 "workqueue: cond_resched() after processing
> each work item", kworker threads requeueing back-to-back with zero jiffy
> delay can stall RCU. The cond_resched call introduced in that fix will
> yield only iff there are other higher priority tasks to run, so force a
> quiescent RCU state between work items.
> 
> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
> ---
>  kernel/workqueue.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index e9719c7..14a7163 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2196,8 +2196,10 @@ __acquires(&pool->lock)
>  	 * kernels, where a requeueing work item waiting for something to
>  	 * happen could deadlock with stop_machine as such work item could
>  	 * indefinitely requeue itself while all other CPUs are trapped in
> -	 * stop_machine.
> +	 * stop_machine. At the same time, report a quiescent RCU state so
> +	 * the same condition doesn't freeze RCU.
>  	 */
> +	rcu_note_context_switch(raw_smp_processor_id());
>  	cond_resched();
> 
>  	spin_lock_irq(&pool->lock);
> -- 
> 1.9.3
> 
> 

