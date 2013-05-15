Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3EOEJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:09:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3EOEJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:09:19 -0400
Message-ID: <1368590955.5957.7.camel@marge.simpson.net>
Subject: Re: dynticks: CONFIG_VIRT_CPU_ACCOUNTING +  CONFIG_CONTEXT_TRACKING
 breaks accounting on core2 CPUs only
From: Mike Galbraith <bitbucket@online.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 15 May 2013 06:09:15 +0200
In-Reply-To: <20130515002646.GA24004@somewhere>
References: <1368346669.5998.13.camel@marge.simpson.net>
	 <20130514005744.GA12749@somewhere>
	 <1368540440.6275.32.camel@marge.simpson.net>
	 <20130515002646.GA24004@somewhere>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Kp2KchMI2ZqdQXRQVcSF05fRlOGKKso5bS1at6RX3Yo
 0BUNVgZnUUQt1o9K6nauyaw4uMVFZW81A4DcUTbIxDefsyH308
 ozcjHeNx+T8q5IVrTQ1Ts3cVUloED7X/G7SX/mF+qqXuLhl9v4
 UGy4CHjo88CSHIrX4rmKrxkcal+vIM4SFGI06gd8+oWESVjNZI
 Fd3yWgaCaIgNYhFG5kvyNQkIJHrc+9ato/QJSH60u5Dvl52CWU
 kHnDZVpmZViab3jo0N4BO3nrlCHUuiWO6f2uCjbgnypiwJyikw
 Bhd9LaTVFFBs/uq5xNMNwCZzNBs65FsVMuBIztCOZyFW9YdlGh
 aPf8KbpNBTvZTz9KBixdvwRLOg8ulH9we8ZW3iw9s4YA9ikRu5
 vVU301rBzCQfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 02:26 +0200, Frederic Weisbecker wrote: 
> On Tue, May 14, 2013 at 04:07:20PM +0200, Mike Galbraith wrote:
> > On Tue, 2013-05-14 at 02:57 +0200, Frederic Weisbecker wrote: 
> > > On Sun, May 12, 2013 at 10:17:49AM +0200, Mike Galbraith wrote:
> > > > Greetings,
> > > > 
> > > > Turning on new NO_HZ feature on my Q6600 box in master, I see that tasks
> > > > accrue zero utime/stime.  However, the same exact kernel on E5620 box
> > > > works fine, so it would appear there's a CPU dependency somewhere.
> > > 
> > > Ah indeed, I just managed to reproduce the same issue.
> > > 
> > > > 
> > > > Is core2 expected to go dysfunctional with context tracking enabled?
> > > > CONFIG_VIRT_CPU_ACCOUNTING alone works fine in 3.9-stable, turn on
> > > > CONFIG_CONTEXT_TRACKING_FORCE, and CPU accounting stops working on core2
> > > > boxen only, same exact kernel continues to work just fine on E5620
> > > > (Westmere) box.
> > > 
> > > There was no known issue with core2. The box where I'm seeing the it
> > > is a Phenom quad core that had NR_CPUS=2. May be the issue is more
> > > likely to happen with this low number. I don't know.
> > > 
> > > I'm investigating further.
> > 
> > So with CONFIG_HAVE_UNSTABLE_SCHED_CLOCK, you can't mix sched_clock()
> > (pure tsc) with local_clock()/sched_clock_cpu(cpu).  The former is
> > always quite a bit ahead of the later, so mixing clocks is a nogo on
> > crusty old (but beloved) core2 box.
> 
> Right I have the same issue. So let's use local_clock() everywhere here,
> it takes care of unstable tsc.
> 
> Does the following fix the issue for you?

Yeah, both can use sched_clock_cpu() instead though.

> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index cc2dc3e..1ce322f 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -747,7 +748,7 @@ void arch_vtime_task_switch(struct task_struct *prev)
>  
>  	write_seqlock(&current->vtime_seqlock);
>  	current->vtime_snap_whence = VTIME_SYS;
> -	current->vtime_snap = sched_clock();
> +	current->vtime_snap = local_clock();
>  	write_sequnlock(&current->vtime_seqlock);
>  }
>  
> @@ -757,7 +758,7 @@ void vtime_init_idle(struct task_struct *t)
>  
>  	write_seqlock_irqsave(&t->vtime_seqlock, flags);
>  	t->vtime_snap_whence = VTIME_SYS;
> -	t->vtime_snap = sched_clock();
> +	t->vtime_snap = local_clock();
>  	write_sequnlock_irqrestore(&t->vtime_seqlock, flags);
>  }
>  


