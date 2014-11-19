Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaKSM3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:29:04 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49302 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaKSM3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:29:02 -0500
Message-ID: <546C8CFD.2060200@gmail.com>
Date: Wed, 19 Nov 2014 20:28:45 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sched/deadline: reduce overhead if there are no scheduling
 parameters changed
References: <1416391297-111305-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1416391297-111305-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to send out a duplicated patchset, please ignore this one.
On 11/19/14, 6:01 PM, Wanpeng Li wrote:
> There is no need to dequeue/enqueue and push/pull if there are
> no scheduling parameters changed for dl class, actually both
> fair and rt class have already check if parameters changed for
> them to avoid unnecessary overhead. This patch add the parameters
> changed verify for dl class in order to reduce overhead.
>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>   kernel/sched/core.c | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 603c462..f361867 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3402,6 +3402,21 @@ static bool check_same_owner(struct task_struct *p)
>   	return match;
>   }
>   
> +static bool dl_param_changed(struct task_struct *p,
> +			const struct sched_attr *attr)
> +{
> +	struct sched_dl_entity *dl_se = &p->dl;
> +
> +	if (dl_se->dl_runtime != attr->sched_runtime ||
> +		dl_se->dl_deadline != attr->sched_deadline ||
> +		dl_se->dl_period != attr->sched_period ||
> +		dl_se->flags != attr->sched_flags ||
> +		p->rt_priority != attr->sched_priority)
> +		return true;
> +
> +	return false;
> +}
> +
>   static int __sched_setscheduler(struct task_struct *p,
>   				const struct sched_attr *attr,
>   				bool user)
> @@ -3530,7 +3545,7 @@ recheck:
>   			goto change;
>   		if (rt_policy(policy) && attr->sched_priority != p->rt_priority)
>   			goto change;
> -		if (dl_policy(policy))
> +		if (dl_policy(policy) && dl_param_changed(p, attr))
>   			goto change;
>   
>   		p->sched_reset_on_fork = reset_on_fork;

