Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaCaP4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:56:34 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47320 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaCaP4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:56:31 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tglx@linutronix.de, fweisbec@gmail.com, peterz@infradead.org,
        mingo@kernel.org, tj@kernel.org, lizefan@huawei.com,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [RFC 2/4] timer: don't migrate pinned timers
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<cover.1395322529.git.viresh.kumar@linaro.org>
	<3fa0ea3a19a51ae2797a25e281763451ad8d2844.1395322529.git.viresh.kumar@linaro.org>
Date: Mon, 31 Mar 2014 08:56:26 -0700
In-Reply-To: <3fa0ea3a19a51ae2797a25e281763451ad8d2844.1395322529.git.viresh.kumar@linaro.org>
	(Viresh Kumar's message of "Thu, 20 Mar 2014 19:18:59 +0530")
Message-ID: <7htxae5plh.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:

> migrate_timer() is called when a CPU goes down and its timers are required to be
> migrated to some other CPU. Its the responsibility of the users of the timer to
> remove it before control reaches to migrate_timers().
>
> As these were the pinned timers, the best we can do is: don't migrate these and
> report to the user as well.
>
> That's all this patch does.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/timer.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/kernel/timer.c b/kernel/timer.c
> index fec4ab4..a7f8b99 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1606,11 +1606,22 @@ static int init_timers_cpu(int cpu)
>  static void migrate_timer_list(struct tvec_base *new_base, struct list_head *head)
>  {
>  	struct timer_list *timer;
> +	int is_pinned;
>  
>  	while (!list_empty(head)) {
>  		timer = list_first_entry(head, struct timer_list, entry);
>  		/* We ignore the accounting on the dying cpu */
>  		detach_timer(timer, false);
> +
> +		is_pinned = tbase_get_pinned(timer->base);
> +
> +		/* Check if CPU still has pinned timers */
> +		if (is_pinned) {
> +			pr_warn("%s: can't migrate pinned timer: %p, removing it\n",
> +					__func__, timer);

printk message will be confusing: removing it from what? 

Kevin


> +			continue;
> +		}
> +
>  		timer_set_base(timer, new_base);
>  		internal_add_timer(new_base, timer);
>  	}
