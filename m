Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaFMQaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:30:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:15675 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753355AbaFMQaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:30:08 -0400
Date: Fri, 13 Jun 2014 12:30:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch V4 04/10] rtmutex: No need to keep task ref for lock
 owner check
Message-ID: <20140613123005.5c309e98@gandalf.local.home>
In-Reply-To: <20140611183853.208557255@linutronix.de>
References: <20140611182944.108526809@linutronix.de>
	<20140611183853.208557255@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 18:44:05 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> There is no point to keep the task ref across the check for lock
> owner. Drop the ref before that, so the protection context is clear.

You mean you deobfuscated the code ;-)

(No, patch #3 could have been called "deobfuscate the code")

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Found while documenting the chain walk.
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
> @@ -463,6 +463,8 @@ static int rt_mutex_adjust_prio_chain(st
>  
>  	/* Release the task */
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +	put_task_struct(task);
> +
>  	if (!rt_mutex_owner(lock)) {
>  		/*
>  		 * If the requeue above changed the top waiter, then we need
> @@ -472,9 +474,8 @@ static int rt_mutex_adjust_prio_chain(st
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

