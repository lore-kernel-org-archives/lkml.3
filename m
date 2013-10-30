Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3J3QAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:00:39 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:52904 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3J3QAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:00:38 -0400
Message-ID: <52712D1C.9000802@mentor.com>
Date: Wed, 30 Oct 2013 21:00:28 +0500
From: Abbas Raza <abbas_raza@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com, peterz@infradead.org, Xie XiuQi <xiexiuqi@huawei.com>
Subject: Re: [PATCH] kthread_bind: don't wait in kthread_bind for presmp initcalls
References: <1380300451-396-1-git-send-email-abbas_raza@mentor.com>
In-Reply-To: <1380300451-396-1-git-send-email-abbas_raza@mentor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2013 16:00:34.0393 (UTC) FILETIME=[2AB2F490:01CED589]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Any thoughts here please?

Thanks .
Abbas Raza

On 09/27/2013 09:47 PM, Abbas Raza wrote:
> From: Abbas Raza <Abbas_Raza@mentor.com>
>
> wait_task_inactive shouldn't be called in __kthread_bind for presmp
> initcalls the same way it is done in !SMP case.
>
> more info here:
> http://permalink.gmane.org/gmane.linux.kernel.embedded/4046
>
> This patch improves boot time for pre-smp initcalls as given below
>
> boot time with this patch:
>
> calling  spawn_ksoftirqd+0x0/0x30 @ 1
> initcall spawn_ksoftirqd+0x0/0x30 returned 0 after 0 usecs
>
> boot time without this patch:
>
> calling  spawn_ksoftirqd+0x0/0x30 @ 1
> initcall spawn_ksoftirqd+0x0/0x30 returned 0 after 19531 usecs
>
> Signed-off-by: Abbas Raza <Abbas_Raza@mentor.com>
> ---
>  kernel/kthread.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 760e86d..28b5c4b 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -290,11 +290,17 @@ EXPORT_SYMBOL(kthread_create_on_node);
>  
>  static void __kthread_bind(struct task_struct *p, unsigned int cpu, long state)
>  {
> -	/* Must have done schedule() in kthread() before we set_task_cpu */
> -	if (!wait_task_inactive(p, state)) {
> -		WARN_ON(1);
> -		return;
> +	if (!((num_online_cpus() == 1) && !cpu)) {
> +		/*
> +		 * Must have done schedule() in kthread() before
> +		 * we set_task_cpu
> +		 */
> +		if (!wait_task_inactive(p, state)) {
> +			WARN_ON(1);
> +			return;
> +		}
>  	}
> +
>  	/* It's safe because the task is inactive. */
>  	do_set_cpus_allowed(p, cpumask_of(cpu));
>  	p->flags |= PF_NO_SETAFFINITY;

