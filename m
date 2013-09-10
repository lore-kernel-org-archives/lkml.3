Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3IJCcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 22:32:45 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45105 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab3IJCcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 22:32:43 -0400
Date: Tue, 10 Sep 2013 10:32:15 +0800
From: Wang YanQing <udknight@gmail.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        liguang <lig.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] SMP: kill redundant
 call_function_data->cpumask_ipi field
Message-ID: <20130910023215.GA5955@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Jiang Liu <liuj97@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shaohua Li <shli@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	liguang <lig.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
References: <1378653745-8343-1-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378653745-8343-1-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 11:22:23PM +0800, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Commit f44310b98ddb7 "smp: Fix SMP function call empty cpu mask race"
> introduced field call_function_data->cpumask_ipi to resolve a race
> condition in smp_call_function_many().
> 
> Later commit 9a46ad6d6df3 "smp: make smp_call_function_many() use logic
> similar to smp_call_function_single()" fixed the same issue in another
> way when optimizing smp_call_function_many(), which then obsoletes
> changes introduced by commit f44310b98ddb7. So revert it.
> 

Yes, you are right, after commit 9a46ad6d6df3, we can revert f44310b98ddb7.
Maybe use "Revert smp: Fix SMP function call empty cpu mask race" is a better
subject.

> We may also keep call_function_data->cpumask_ipi field and use it to
> optimize smp_call_function_many() as below:
> diff --git a/kernel/smp.c b/kernel/smp.c
> index fe9f773..dd852fb 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -428,6 +428,8 @@ void smp_call_function_many(const struct cpumask *mask,
>                 csd->info = info;
> 
>                 raw_spin_lock_irqsave(&dst->lock, flags);
> +               if (list_empty(&dst->list))
> +                       cpumask_clear_cpu(cpu, cfd->cpumask_ipi);
>                 list_add_tail(&csd->list, &dst->list);
>                 raw_spin_unlock_irqrestore(&dst->lock, flags);
>         }
> 

Your optimization don't need to keep cpumask_ipi, just clear cfd->cpumask,
and test whether cfd->cpumask is empty after "for_each_cpu(cpu, cfd->cpumask)".


Acked-by: Wang YanQing <udknight@gmail.com>

Thanks.
