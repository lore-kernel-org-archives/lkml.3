Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaCLJSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:18:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50926 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaCLJSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:18:46 -0400
Date: Wed, 12 Mar 2014 10:18:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Bohac <jbohac@suse.cz>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: is printk() safe within a timekeeper_seq write section?
Message-ID: <20140312091841.GN30956@twins.programming.kicks-ass.net>
References: <20140306174531.GA30634@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306174531.GA30634@midget.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 06:45:31PM +0100, Jiri Bohac wrote:
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

So HRTICK is disabled by default; but yes this is a problem when you
enable it.

The problem is that our timers are in an entirely different clock base
than our (scheduler) clocks.

On SNB+ hardware with TSC deadline timers we have the same clockbase I
suppose but I'm not sure that's something we can (and want) to rely on.

Now, I've long had the idea to mess up the hrtimer code to optimize this
particular timer, but I'm not entirely sure we can get around having to
use the timerkeeper_seq thing, we simply have to get into timer clock
space :/
