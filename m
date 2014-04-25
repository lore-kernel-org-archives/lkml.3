Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaDYFNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:13:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45503 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaDYFM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:12:58 -0400
Message-ID: <5359EDDB.4060409@linux.vnet.ibm.com>
Date: Fri, 25 Apr 2014 10:38:43 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Jason Low <jason.low2@hp.com>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com> <1398303035-18255-2-git-send-email-jason.low2@hp.com> <5358E417.8090503@linux.vnet.ibm.com> <20140424120415.GS11096@twins.programming.kicks-ass.net> <20140424124438.GT13658@twins.programming.kicks-ass.net> <1398358417.3509.11.camel@j-VirtualBox> <20140424171453.GZ11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140424171453.GZ11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042505-9332-0000-0000-0000009B3159
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 10:44 PM, Peter Zijlstra wrote:
> On Thu, Apr 24, 2014 at 09:53:37AM -0700, Jason Low wrote:
>>
>> So I thought that the original rationale (commit 1bd77f2d) behind
>> updating rq->next_balance in idle_balance() is that, if we are going
>> idle (!pulled_task), we want to ensure that the next_balance gets
>> calculated without the busy_factor.
>>
>> If the rq is busy, then rq->next_balance gets updated based on
>> sd->interval * busy_factor. However, when the rq goes from "busy"
>> to idle, rq->next_balance might still have been calculated under
>> the assumption that the rq is busy. Thus, if we are going idle, we
>> would then properly update next_balance without the busy factor
>> if we update when !pulled_task.
>>
> 
> Its late here and I'm confused!
> 
> So the for_each_domain() loop calculates a new next_balance based on
> ->balance_interval (which has that busy_factor on, right).
> 
> But if it fails to pull anything, we'll (potentially) iterate the entire
> tree up to the largest domain; and supposedly set next_balanced to the
> largest possible interval.

*to the smallest possible interval.
> 
> So when we go from busy to idle (!pulled_task), we actually set
> ->next_balance to the longest interval. Whereas the commit you
> referenced says it sets it to a shorter while.

We will set next_balance to the earliest balance time among the sched
domains iterated.
> 
> Not seeing it.
> 
> So the code as modified by Ingo in one of the initial CFS commits, will
> move the ->next_balance time ahead if the balance succeeded
> (pulled_task), thereby reflecting that we are busy and we just did a
> balance so we need not do one again soon. (we might want to re-think
> this if we really make the idle balance only pull 1 task max).
> 
> Of course, I've now gone over this code 3 times today, so I'm terminally
> confused.

I am unable to understand how updating of rq->next_balance should depend
solely on the pulled_task parameter( I am not considering the expiry of
rq->next_balance here).

True that we will need to override the busy_factor in rq->next_balance
if we do not pull any tasks and go to idle. Besides that however we will
probably need to override rq->next_balance irrespective of whether we
pull any tasks.

Lets look at what happens to the sd->balance_interval in load_balance().
If we pull tasks then it is set to min_interval. If active balance
occurs or if tasks are pinned then we push the interval farther away.In
the former case where it is set to min_interval, pulled_tasks > 0, in
the latter case, especially the pinned case, pulled_task=0 (not sure
about the active balance case).

If after this modification on sd->balance_interval,
rq->next_balance > sd->last_balance + sd->balance_interval then
shouldn't we be resetting rq->next_balance? And if we should, then the
dependence on pulled_tasks is not justified is it? All this assuming
that rq->next_balance should always reflect the minimum value of
sd->next_balance among the sched domains of which the rq is a part.

Regards
Preeti U Murthy
> 

