Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaCKT3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:29:51 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:49372 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaCKT3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:29:50 -0400
Message-ID: <531F6429.8050008@linaro.org>
Date: Tue, 11 Mar 2014 12:29:45 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: is printk() safe within a timekeeper_seq write section?
References: <20140306174531.GA30634@midget.suse.cz>
In-Reply-To: <20140306174531.GA30634@midget.suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 09:45 AM, Jiri Bohac wrote:
> Hi,
>
> I'm looking at the printk call in
> __timekeeping_inject_sleeptime(), introduced in cb5de2f8
> (time: Catch invalid timespec sleep values in __timekeeping_inject_sleeptime)
>
> Is it safe to call printk() while timekeeper_seq is held for
> writing?
>
> What about this call chain?
>   printk
>     vprintk_emit
>       console_unlock
>         up(&console_sem)
>           __up
> 	    wake_up_process
> 	      try_to_wake_up
> 	        ttwu_do_activate
> 		  ttwu_activate
> 		    activate_task
> 		      enqueue_task
> 		        enqueue_task_fair
> 			  hrtick_update
> 			    hrtick_start_fair
> 			      hrtick_start_fair
> 			        get_time
> 				  ktime_get
> 				    --> endless loop on
> 				    read_seqcount_retry(&timekeeper_seq, ...)
> 		  
>
> It looks like an unlikely but possible deadlock. 
> Or did I overlook something?

So I don't think I've seen anything like the above in my testing, but it
may just be very hard to get that path to trigger.

I was also surprised the seqlock lockdep enablement changes wouldn't
catch this, but Jiri pointed out printk calls lockdep_off in
vprintk_emit() - which makes sense as you don't want lockdep splats
calling printk and recursing - but is frustrating to have that hole in
the checking.

There's a few spots where we do printks with the timekeeping seqlock
held, and they're annoyingly nested far enough to make deferring the
printk awkward. So I'm half thinking we could have some sort of buffer
something like time_printk() could fill and then flush it after the lock
is dropped. Then we just need something to warn if any new printks' are
added to timekeeping seqlock sequences.

The whole thing makes my head spin a bit, since even if we remove the
explicit printks, I'm not sure where else printk might be triggered
(like via lockdep warnings, for instance), where it might be unsafe.

Peter/Thomas: Any thoughts on the deferred printk buffer? Does printk
already have something like this? Any other ideas here?

thanks
-john




