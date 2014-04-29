Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbaD2OwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:52:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:54870 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751706AbaD2OwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:52:14 -0400
Date: Tue, 29 Apr 2014 15:52:21 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
Message-ID: <20140429145221.GH2639@e103034-lin>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 03:43:21AM +0100, Alex Shi wrote:
> In the cpu_load decay usage, we mixed the long term, short term load with
> balance bias, randomly pick a big or small value according to balance 
> destination or source.

I disagree that it is random. min()/max() in {source,target}_load()
provides a conservative bias to the load estimate that should prevent us
from trying to pull tasks from the source cpu if its current load is
just a temporary spike. Likewise, we don't try to pull tasks to the
target cpu if the load is just a temporary drop.

> This mix is wrong, the balance bias should be based
> on task moving cost between cpu groups, not on random history or instant load.

Your patch set actually changes everything to be based on the instant
load alone. rq->cfs.runnable_load_avg is updated instantaneously when
tasks are enqueued and deqeueue, so this load expression is quite volatile.

What do you mean by "task moving cost"?

> History load maybe diverage a lot from real load, that lead to incorrect bias.
> 
> like on busy_idx,
> We mix history load decay and bias together. The ridiculous thing is, when 
> all cpu load are continuous stable, long/short term load is same. then we 
> lose the bias meaning, so any minimum imbalance may cause unnecessary task
> moving. To prevent this funny thing happen, we have to reuse the 
> imbalance_pct again in find_busiest_group().  But that clearly causes over
> bias in normal time. If there are some burst load in system, it is more worse.

Isn't imbalance_pct only used once in the periodic load-balance path?

It is not clear to me what the over bias problem is. If you have a
stable situation, I would expect the long and short term load to be the
same?

> As to idle_idx:
> Though I have some cencern of usage corretion, 
> https://lkml.org/lkml/2014/3/12/247 but since we are working on cpu
> idle migration into scheduler. The problem will be reconsidered. We don't
> need to care it too much now.
> 
> In fact, the cpu_load decays can be replaced by the sched_avg decay, that 
> also decays load on time. The balance bias part can fullly use fixed bias --
> imbalance_pct, which is already used in newly idle, wake, forkexec balancing
> and numa balancing scenarios.

As I have said previously, I agree that cpu_load[] is somewhat broken in
its current form, but I don't see how removing it and replacing it with
the instantaneous cpu load solves the problems you point out.

The current cpu_load[] averages the cpu_load over time, while
rq->cfs.runnable_load_avg is the sum of the currently runnable tasks'
load_avg_contrib. The former provides a long term view of the cpu_load,
the latter does not. It can change radically in an instant. I'm
therefore a bit concerned about the stability of the load-balance
decisions. However, since most decisions are based on cpu_load[0]
anyway, we could try setting LB_BIAS to false as Peter suggests and see
what happens.

Morten
