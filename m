Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3JHNfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:35:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab3JHNfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:35:34 -0400
Date: Tue, 8 Oct 2013 09:35:32 -0400
From: Don Zickus <dzickus@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] hung_task: add method to reset detector
Message-ID: <20131008133532.GQ227855@redhat.com>
References: <20131008010515.516032211@amt.cnet>
 <20131008010552.713337492@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008010552.713337492@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 10:05:16PM -0300, Marcelo Tosatti wrote:
> In certain occasions it is possible for a hung task detector
> positive to be false: continuation from a paused VM, for example.
> 
> Add a method to reset detection, similar as is done
> with other kernel watchdogs.

This makes sense to me.  Should we throw the 'reset_hung_task_detector' in
include/linux/sched.h like some of the other watchdog functions?  Or is
having a small hung_task.h file like this fine?

Cheers,
Don

> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> Index: kvm/kernel/hung_task.c
> ===================================================================
> --- kvm.orig/kernel/hung_task.c
> +++ kvm/kernel/hung_task.c
> @@ -203,6 +203,14 @@ int proc_dohung_task_timeout_secs(struct
>  	return ret;
>  }
>  
> +static atomic_t reset_hung_task = ATOMIC_INIT(0);
> +
> +void reset_hung_task_detector(void)
> +{
> +	atomic_set(&reset_hung_task, 1);
> +}
> +EXPORT_SYMBOL_GPL(reset_hung_task_detector);
> +
>  /*
>   * kthread which checks for tasks stuck in D state
>   */
> @@ -216,6 +224,9 @@ static int watchdog(void *dummy)
>  		while (schedule_timeout_interruptible(timeout_jiffies(timeout)))
>  			timeout = sysctl_hung_task_timeout_secs;
>  
> +		if (atomic_xchg(&reset_hung_task, 0))
> +			continue;
> +
>  		check_hung_uninterruptible_tasks(timeout);
>  	}
>  
> Index: kvm/include/linux/hung_task.h
> ===================================================================
> --- /dev/null
> +++ kvm/include/linux/hung_task.h
> @@ -0,0 +1,15 @@
> +/*
> + *  linux/include/linux/hung_task.h
> + */
> +#ifndef LINUX_HUNG_TASK_H
> +#define LINUX_HUNG_TASK_H
> +
> +#ifdef CONFIG_DETECT_HUNG_TASK
> +void reset_hung_task_detector(void);
> +#else
> +static inline void reset_hung_task_detector(void)
> +{
> +}
> +#endif
> +
> +#endif
> 
> 
