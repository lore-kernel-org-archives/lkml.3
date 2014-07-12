Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaGLJZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 05:25:54 -0400
Received: from forward8l.mail.yandex.net ([84.201.143.141]:43581 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaGLJZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 05:25:53 -0400
X-Yandex-Uniq: 8134ffe6-e20f-4f52-a2d1-fa315b91317c
Authentication-Results: smtp18.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <53C0FF16.40902@yandex.ru>
Date: Sat, 12 Jul 2014 13:25:42 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose number
 of tasks running on cpu
References: <cover.1405074379.git.tim.c.chen@linux.intel.com> <1405110784.2970.655.camel@schen9-DESK>
In-Reply-To: <1405110784.2970.655.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.07.2014 00:33, Tim Chen wrote:
> This function will help a thread decide if it wants to to do work
> that can be delayed, to accumulate more tasks for more efficient
> batch processing later.
> 
> However, if no other tasks are running on the cpu, it can take
> advantgae of the available cpu cycles to complete the tasks
> for immediate processing to minimize delay, otherwise it will yield.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  include/linux/sched.h | 1 +
>  kernel/sched/core.c   | 8 ++++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 7cb07fd..0884250 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -168,6 +168,7 @@ extern int nr_threads;
>  DECLARE_PER_CPU(unsigned long, process_counts);
>  extern int nr_processes(void);
>  extern unsigned long nr_running(void);
> +extern unsigned long nr_running_cpu(int cpu);
>  extern unsigned long nr_iowait(void);
>  extern unsigned long nr_iowait_cpu(int cpu);
>  extern unsigned long this_cpu_load(void);
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9cae286..d5bb8e6 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2283,6 +2283,14 @@ unsigned long nr_running(void)
>  	return sum;
>  }
>  
> +unsigned long nr_running_cpu(int cpu)
> +{
> +	if (cpumask_test_cpu(cpu, cpu_online_mask))
> +		return cpu_rq(cpu)->nr_running;
> +	else
> +		return 0;
> +}
> +

Offline cpu should have nr_running equal to 0. We park last
enqueued thread (migration_thread) at the end of take_cpu_down().

So, it's enough to return cpu_rq(cpu)->nr_running.

>  unsigned long long nr_context_switches(void)
>  {
>  	int i;
> 

Thanks,
Kirill
