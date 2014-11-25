Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaKYRtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:49:14 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45818 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaKYRtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:49:11 -0500
Message-ID: <5474C119.7020800@arm.com>
Date: Tue, 25 Nov 2014 17:49:13 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched/deadline: reduce overhead if there are no scheduling
 parameters changed
References: <1416386103-90800-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1416386103-90800-1-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 25 Nov 2014 17:49:09.0477 (UTC) FILETIME=[1D822150:01D008D8]
X-MC-Unique: 114112517490900601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 19/11/14 08:35, Wanpeng Li wrote:
> There is no need to dequeue/enqueue and push/pull if there are
> no scheduling parameters changed for dl class, actually both 
> fair and rt class have already check if parameters changed for 
> them to avoid unnecessary overhead. This patch add the parameters 
> changed verify for dl class in order to reduce overhead.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/core.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 603c462..f361867 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3402,6 +3402,21 @@ static bool check_same_owner(struct task_struct *p)
>  	return match;
>  }
>  
> +static bool dl_param_changed(struct task_struct *p,
> +			const struct sched_attr *attr)

Please check alignment.

> +{
> +	struct sched_dl_entity *dl_se = &p->dl;
> +
> +	if (dl_se->dl_runtime != attr->sched_runtime ||
> +		dl_se->dl_deadline != attr->sched_deadline ||
> +		dl_se->dl_period != attr->sched_period ||
> +		dl_se->flags != attr->sched_flags ||
> +		p->rt_priority != attr->sched_priority)

This last one is useless, as we fail above if
attr->sched_priority != 0 when task has !rt_policy.

Thanks,

- Juri

> +		return true;
> +
> +	return false;
> +}
> +
>  static int __sched_setscheduler(struct task_struct *p,
>  				const struct sched_attr *attr,
>  				bool user)
> @@ -3530,7 +3545,7 @@ recheck:
>  			goto change;
>  		if (rt_policy(policy) && attr->sched_priority != p->rt_priority)
>  			goto change;
> -		if (dl_policy(policy))
> +		if (dl_policy(policy) && dl_param_changed(p, attr))
>  			goto change;
>  
>  		p->sched_reset_on_fork = reset_on_fork;
> 

