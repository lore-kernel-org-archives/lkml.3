Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbaCKVcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:32:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:35582 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaCKVcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:32:18 -0400
Date: Tue, 11 Mar 2014 22:32:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: is printk() safe within a timekeeper_seq write section?
In-Reply-To: <531F6429.8050008@linaro.org>
Message-ID: <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de>
References: <20140306174531.GA30634@midget.suse.cz> <531F6429.8050008@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014, John Stultz wrote:
> On 03/06/2014 09:45 AM, Jiri Bohac wrote:
> > Hi,
> >
> > I'm looking at the printk call in
> > __timekeeping_inject_sleeptime(), introduced in cb5de2f8
> > (time: Catch invalid timespec sleep values in __timekeeping_inject_sleeptime)
> >
> > Is it safe to call printk() while timekeeper_seq is held for
> > writing?
> >
> > What about this call chain?
> >   printk
> >     vprintk_emit
> >       console_unlock
> >         up(&console_sem)
> >           __up
> > 	    wake_up_process
> > 	      try_to_wake_up
> > 	        ttwu_do_activate
> > 		  ttwu_activate
> > 		    activate_task
> > 		      enqueue_task
> > 		        enqueue_task_fair
> > 			  hrtick_update
> > 			    hrtick_start_fair
> > 			      hrtick_start_fair
> > 			        get_time
> > 				  ktime_get
> > 				    --> endless loop on
> > 				    read_seqcount_retry(&timekeeper_seq, ...)
> > 		  
> >
> > It looks like an unlikely but possible deadlock. 
> > Or did I overlook something?
> 
> So I don't think I've seen anything like the above in my testing, but it
> may just be very hard to get that path to trigger.

It's hard, but possible:

CPU0	     		CPU1

T1 down(&console_sem);
			T2 down(&console_sem);
			   --> preemption or interrupt
			        write_seqcount_begin(&timekeeper_seq);
T1 up(&console_sem);
				down(&console_sem);
				....
				up(&console_sem);
				   wakeup(T2);
				     ....
				     hrtick_update();
				     
> I was also surprised the seqlock lockdep enablement changes wouldn't
> catch this, but Jiri pointed out printk calls lockdep_off in
> vprintk_emit() - which makes sense as you don't want lockdep splats
> calling printk and recursing - but is frustrating to have that hole in
> the checking.
> 
> There's a few spots where we do printks with the timekeeping seqlock
> held, and they're annoyingly nested far enough to make deferring the
> printk awkward. So I'm half thinking we could have some sort of buffer
> something like time_printk() could fill and then flush it after the lock
> is dropped. Then we just need something to warn if any new printks' are
> added to timekeeping seqlock sequences.
> 
> The whole thing makes my head spin a bit, since even if we remove the
> explicit printks, I'm not sure where else printk might be triggered
> (like via lockdep warnings, for instance), where it might be unsafe.
> 
> Peter/Thomas: Any thoughts on the deferred printk buffer? Does printk
> already have something like this? Any other ideas here?

I was thinking about something like that for RT as on RT printk is a
complete nightmare. It's simple to implement that, but as we know from
the RT experience it can lead to painful loss of debug output.

Assume you printk inside such a region, which just fills the dmesg
buffer and schedules the delayed output. Now in that same region you
run into a deadlock which causes the whole machine to freeze. Then you
won't see the debug output, which might actually give you the hint why
the system deadlocked ....

Thanks,

	tglx


