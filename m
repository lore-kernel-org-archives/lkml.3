Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaFIU7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:59:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:11367 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751736AbaFIU7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:59:46 -0400
Date: Mon, 9 Jun 2014 16:59:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 1/7] rtmutex: Deobfuscate chain walk
Message-ID: <20140609165943.09935fb8@gandalf.local.home>
In-Reply-To: <20140609202335.980283946@linutronix.de>
References: <20140609201118.387571774@linutronix.de>
	<20140609202335.980283946@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2014 20:28:06 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> There is no point to keep the task ref across the check for lock
> owner. Drop the ref before that, so the protection context is clear.
> 
> Found while documenting the chain walk.

This looks fine, I just hate the subject. I don't see how it is
'deobfuscating" the chain walk. How about:

rtmutex: No need to keep task ref when checking lock ownership

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/locking/rtmutex.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -411,6 +411,8 @@ static int rt_mutex_adjust_prio_chain(st
>  
>  	/* Release the task */
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +	put_task_struct(task);
> +
>  	if (!rt_mutex_owner(lock)) {
>  		/*
>  		 * If the requeue above changed the top waiter, then we need
> @@ -420,9 +422,8 @@ static int rt_mutex_adjust_prio_chain(st
>  		if (top_waiter != rt_mutex_top_waiter(lock))
>  			wake_up_process(rt_mutex_top_waiter(lock)->task);
>  		raw_spin_unlock(&lock->wait_lock);
> -		goto out_put_task;
> +		return 0;
>  	}
> -	put_task_struct(task);
>  
>  	/* Grab the next task */
>  	task = rt_mutex_owner(lock);
> 

