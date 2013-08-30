Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3H3AZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:25:26 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53873 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3H3AXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:23:51 -0400
Date: Thu, 29 Aug 2013 17:23:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Libin <huawei.libin@huawei.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, viro@zeniv.linux.org.uk,
        eparis@redhat.com, tglx@linutronix.de, rusty@rustcorp.com.au,
        ebiederm@xmission.com, john.stultz@linaro.org, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        jovi.zhangwei@huawei.com, guohanjun@huawei.com,
        zhangdianfang@huawei.com, wangyijing@huawei.com
Subject: Re: [PATCH 09/14] rcutree: Fix invalid wakeup in rcu_wait
Message-ID: <20130830002327.GA3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
 <1377784669-28140-10-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377784669-28140-10-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083000-7164-0000-0000-000001227589
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 09:57:44PM +0800, Libin wrote:
> If thread is preempted before calling set_current_state(TASK_INTERRUPTIBLE),
> and the other thread set the condition followed with wake_up_process. After
> that when this thread is re-scheduled, calling set_current_state to set itself
> as state TASK_INTERRUPTIBLE, if it is preempted again after that and before
> __set_current_state(TASK_RUNNING), it triggers the invalid wakeup problem.
> 
> To solve this problem, using preempt_disable() to bound the operaion that
> setting the task state and the conditions(set by the wake thread) validation.
> 
> Signed-off-by: Libin <huawei.libin@huawei.com>
> ---
>  kernel/rcutree.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index b383258..e3f1278 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -357,13 +357,17 @@ struct rcu_data {
> 
>  #define rcu_wait(cond)							\
>  do {									\
> +	preempt_disable();					\
>  	for (;;) {							\
>  		set_current_state(TASK_INTERRUPTIBLE);			\
>  		if (cond)						\
>  			break;						\

Here also the condition check follows the call to set_current_state(),
so this patch should not be needed.

Again, if you are seeing lost wakeups on this exact code path, please
let me know.

Please re-check your other patches.  If they really do follow the
buggy pattern you called out in your patch 0, namely the test preceding
the call to set_current_state(), please send patches that restore the
correct ordering.

Your use of preemption is not fixing anything.  It is at best hiding
the problem by making it less likely to occur.

							Thanx, Paul

> +		preempt_enable();				\
>  		schedule();						\
> +		preempt_disable();				\
>  	}								\
>  	__set_current_state(TASK_RUNNING);				\
> +	preempt_enable();				\
>  } while (0)
> 
>  /*
> -- 
> 1.8.2.1
> 
> 

