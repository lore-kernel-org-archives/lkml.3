Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3C2HO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 03:14:26 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:57132 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab3C2HOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 03:14:24 -0400
Message-ID: <51553EF5.90702@linux.vnet.ibm.com>
Date: Fri, 29 Mar 2013 12:42:53 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/5] sched: don't consider upper se in sched_slice()
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com> <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032907-9264-0000-0000-0000036CDCD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On 03/28/2013 01:28 PM, Joonsoo Kim wrote:
> Following-up upper se in sched_slice() should not be done,
> because sched_slice() is used for checking that resched is needed
> whithin *this* cfs_rq and there is one problem related to this
> in current implementation.
> 
> The problem is that if we follow-up upper se in sched_slice(), it is
> possible that we get a ideal slice which is lower than
> sysctl_sched_min_granularity.
> 
> For example, we assume that we have 4 tg which is attached to root tg
> with same share and each one have 20 runnable tasks on cpu0, respectivly.
> In this case, __sched_period() return sysctl_sched_min_granularity * 20
> and then go into loop. At first iteration, we compute a portion of slice
> for this task on this cfs_rq, so get a slice, sysctl_sched_min_granularity.
> Afterward, we enter second iteration and get a slice which is a quarter of
> sysctl_sched_min_granularity, because there is 4 tgs with same share
> in that cfs_rq.
> 
> Ensuring slice larger than min_granularity is important for performance
> and there is no lower bound about this, except timer tick, we should
> fix it not to consider upper se when calculating sched_slice.
> 

I am assuming the sysctl_sched_latency = 20ms and
sysctl_sched_min_granularity = 4ms.
In that case:

With your patch, the sum of the sched_slice(runnable_task) on each_tg is
 40ms = sched_min_granularity * 10, while the parent tg has a
sched_slice of sysctl_sched_latency / 4 = (20 / 4) = 5ms.

Ideally the children's cpu share must add upto the parent's share.


Thank you

Regards
Preeti U Murthy

