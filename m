Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab3H3AUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:20:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48521 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3H3AUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:20:42 -0400
Date: Thu, 29 Aug 2013 17:20:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Libin <huawei.libin@huawei.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, viro@zeniv.linux.org.uk,
        eparis@redhat.com, tglx@linutronix.de, rusty@rustcorp.com.au,
        ebiederm@xmission.com, john.stultz@linaro.org, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        jovi.zhangwei@huawei.com, guohanjun@huawei.com,
        zhangdianfang@huawei.com, wangyijing@huawei.com
Subject: Re: [PATCH 01/14] kthread: Fix invalid wakeup in kthreadd
Message-ID: <20130830002021.GZ3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
 <1377784669-28140-2-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377784669-28140-2-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083000-4834-0000-0000-00000A966D35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 09:57:36PM +0800, Libin wrote:
> If kthreadd is preempted at(or before) location a, and the other thread,
> such as calling kthread_create_on_node(), adds a list item to
> the kthread_create_list followed with wake_up_process(kthread). After that
> when kthreadd is re-scheduled, calling set_current_state to set itself as
> state TASK_INTERRUPTIBLE, if it is preempted again after that and before
> __set_current_state(TASK_RUNNING), it triggers the invalid wakeup problem.
> ------------------------
> kthreadd()
> ------------------------
> ...
> for (;;) {
> 	//location a
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	if (list_empty(&kthread_create_list)) {
> 		//location b
> 		schedule();
> 		//location c
> 	}
> 	__set_current_state(TASK_RUNNING);
> 	//location d
> ...
> ------------------------
> kthread_create_on_node()
> ------------------------
> ...
> spin_lock(&kthread_create_lock);
> list_add_tail(&create.list, &kthread_create_list);
> spin_unlock(&kthread_create_lock);
> ...
> wake_up_process(kthreadd_task);
> ...
> 
> To solve this problem, using preempt_disable() to bound the operaion that
> setting the task state and the conditions(set by the wake thread) validation.
> ------------------------
> kthreadd()
> ------------------------
> ...
> for (;;) {
> 	preempt_disable();
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	if (list_empty(&kthread_create_list)) {
> 		preempt_enable();
> 		schedule();
> 		preempt_disable();
> 	}
> ...
> 
> Signed-off-by: Libin <huawei.libin@huawei.com>
> ---
>  kernel/kthread.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 760e86d..25c3fed 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -456,10 +456,15 @@ int kthreadd(void *unused)
>  	current->flags |= PF_NOFREEZE;
> 
>  	for (;;) {
> +		preempt_disable();
>  		set_current_state(TASK_INTERRUPTIBLE);
> -		if (list_empty(&kthread_create_list))

And this one already has the list_empty() check after the call to
set_current_state(), so no change should be needed here.

On the other hand, if your testing shows that you are losing wakeups
with this exact code, please let us know!

							Thanx, Paul

> +		if (list_empty(&kthread_create_list)) {
> +			preempt_enable();
>  			schedule();
> +			preempt_disable();
> +		}
>  		__set_current_state(TASK_RUNNING);
> +		preempt_enable();
> 
>  		spin_lock(&kthread_create_lock);
>  		while (!list_empty(&kthread_create_list)) {
> -- 
> 1.8.2.1
> 
> 

