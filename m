Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab3G3D1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:27:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:56998 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3G3D1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:27:49 -0400
Message-ID: <51F732A9.9060106@huawei.com>
Date: Tue, 30 Jul 2013 11:27:37 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Abbas Raza <abbas_raza@mentor.com>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched: don't wait in kthread_bind for presmp initcalls
References: <1375118348-25253-1-git-send-email-abbas_raza@mentor.com>
In-Reply-To: <1375118348-25253-1-git-send-email-abbas_raza@mentor.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/30 1:19, Abbas Raza wrote:
> From: Abbas Raza <Abbas_Raza@mentor.com>
> 
> wait_task_inactive shouldn't be called in kthread_bind for presmp
> initcalls the same way it is done in !SMP case.
> 
> more info here:
> http://permalink.gmane.org/gmane.linux.kernel.embedded/4046
> 
> This patch improves boot time for pre-smp initcalls as given below
> 
> initcall spawn_ksoftirqd+0x0/0x54 returned 0 after 0 usecs
> initcall init_workqueues+0x0/0x358 returned 0 after 0 usecs
> initcall cpu_stop_init+0x0/0xcc returned 0 after 0 usecs
> 
> boot time without this patch:
> 
> initcall spawn_ksoftirqd+0x0/0x54 returned 0 after 9765 usecs
> initcall init_workqueues+0x0/0x358 returned 0 after 9765 usecs
> initcall cpu_stop_init+0x0/0xcc returned 0 after 19531 usecs
> 
> Signed-off-by: Abbas Raza <Abbas_Raza@mentor.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> 
> ---
>  kernel/kthread.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index b579af5..80f19b5 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -221,10 +221,15 @@ EXPORT_SYMBOL(kthread_create_on_node);
>   */
>  void kthread_bind(struct task_struct *p, unsigned int cpu)
>  {
> -	/* Must have done schedule() in kthread() before we set_task_cpu */
> -	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
> -		WARN_ON(1);
> -		return;

Hi Abbas, this patch isn't based the current mainline, and kthread_bind()
has been changed since v3.9.

> +	if (!((num_online_cpus() == 1) && !cpu)) {
> +		/*
> +		 * Must have done schedule() in kthread() before
> +		 * we set_task_cpu
> +		 */
> +		if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
> +			WARN_ON(1);
> +			return;
> +		}
>  	}
>  
>  	/* It's safe because the task is inactive. */
> 


