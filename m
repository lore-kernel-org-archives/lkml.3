Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaKJPtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:49:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22442 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaKJPtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:49:04 -0500
Message-ID: <5460DE4C.6050306@oracle.com>
Date: Mon, 10 Nov 2014 10:48:28 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>
CC: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
References: <1413962231.19914.130.camel@tkhai> <545D928B.2070508@oracle.com> <1415542020.474.22.camel@tkhai> <20141110100328.GF29390@twins.programming.kicks-ass.net>
In-Reply-To: <20141110100328.GF29390@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 05:03 AM, Peter Zijlstra wrote:
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1268,6 +1268,13 @@ static void task_numa_compare(struct tas
>  	raw_spin_unlock_irq(&dst_rq->lock);
>  
>  	/*
> +	 * Because we have preemption enabled we can get migrated around and
> +	 * end try selecting ourselves (current == env->p) as a swap candidate.
> +	 */
> +	if (cur == env->p)
> +		goto unlock;

This is too late though, because currently the lockup happens couple of lines
above that at:

        raw_spin_lock_irq(&dst_rq->lock); <=== here
        cur = dst_rq->curr;

Which got me a bit stuck trying to use your old patch since we can't access '->curr'
without locking dst_rq, but locking dst_rq is causing a lockup.


Thanks,
Sasha
