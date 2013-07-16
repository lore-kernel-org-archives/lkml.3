Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab3GPT22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:28:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148Ab3GPT21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:28:27 -0400
Message-ID: <51E59EA0.6060209@redhat.com>
Date: Tue, 16 Jul 2013 15:27:28 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Portante <pportant@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too frequently
References: <1374002463.3944.11.camel@j-VirtualBox>
In-Reply-To: <1374002463.3944.11.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 03:21 PM, Jason Low wrote:
> When running benchmarks on an 8 socket 80 core machine with a 3.10 kernel,
> there can be a lot of contention in idle_balance() and related functions.
> On many AIM7 workloads in which CPUs go idle very often and idle balance
> gets called a lot, it is actually lowering performance.
>
> Since idle balance often helps performance (when it is not overused), I
> looked into trying to avoid attempting idle balance only when it is
> occurring too frequently.
>
> This RFC patch attempts to keep track of the approximate "average" time between
> idle balance attempts per CPU. Each time the idle_balance() function is
> invoked, it will compute the duration since the last idle_balance() for
> the current CPU. The avg time between idle balance attempts is then updated
> using a very similar method as how rq->avg_idle is computed.
>
> Once the average time between idle balance attempts drops below a certain
> value (which in this patch is sysctl_sched_idle_balance_limit), idle_balance
> for that CPU will be skipped. The average time between idle balances will
> continue to be updated, even if it ends up getting skipped. The
> initial/maximum average is set a lot higher though to make sure that the
> avg doesn't fall below the threshold until the sample size is large and to
> prevent the avg from being overestimated.
>
> This change improved the performance of many AIM7 workloads at 1, 2, 4, 8
> sockets on the 3.10 kernel. The most significant differences were at
> 8 sockets HT-enabled. The table below compares the average jobs per minute
> at 1100-2000 users between the vanilla 3.10 kernel and 3.10 kernel with this
> patch. I included data for both hyperthreading disabled and enabled. I used
> numactl to restrict AIM7 to run on certain number of nodes. I only included
> data in which the % difference was beyond a 2% noise range.

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
