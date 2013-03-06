Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3CFTOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:14:14 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:35656 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab3CFTOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:14:12 -0500
Date: Wed, 6 Mar 2013 11:14:08 -0800
From: Tejun Heo <tj@kernel.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: linux-kernel@vger.kernel.org, leiwen@marvell.com
Subject: Re: workqueue panic in 3.4 kernel
Message-ID: <20130306191408.GN1227@htj.dyndns.org>
References: <CALZhoSR0+SzPLHzJafmny=o8PJ2d7MaH9N6_6s0QZ_oCQm43Xg@mail.gmail.com>
 <20130305163228.GA12795@htj.dyndns.org>
 <CALZhoSRyjRYVcKpq9cECHWgKkci6V+O_zn2CkiwqnFo57tZDfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSRyjRYVcKpq9cECHWgKkci6V+O_zn2CkiwqnFo57tZDfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lei.

On Wed, Mar 06, 2013 at 10:39:15PM +0800, Lei Wen wrote:
> We find a race condition as below:
> CPU0                                                                  CPU1
> timer interrupt happen
> __run_timers
>    __run_timers::spin_lock_irq(&base->lock)
>    __run_timers::spin_unlock_irq(&base->lock)
> 
>    __cancel_work_timer
> 
>    __cancel_work_timer::del_timer
> 
>    __cancel_work_timer::wait_on_work
> 
>    __cancel_work_timer::clear_work_data
>    __run_timers::call_timer_fn(timer, fn, data);
>          delayed_work_timer_fn::get_work_cwq
>    __run_timers::spin_lock_irq(&base->lock)
> 
> It is possible for __cancel_work_timer to be run over cpu1 __BEFORE__
> cpu0 is ready to
> run the timer callback, which is delayed_work_timer_fn in our case.

If del_timer() happens after the timer starts running, del_timer()
would return NULL and try_to_grab_pending() will be called which will
return >=0 iff if successfully steals the PENDING bit (ie. it's the
sole owner of the work item).  If del_timer() happens before the timer
starts running, the timer function would never run.

clear_work_data() happens iff the work item is confirmed to be idle.
At this point, I'm pretty skeptical this is a bug in workqueue itself
and strongly suggest looking at the crashing workqueue user.

Thanks.

-- 
tejun
