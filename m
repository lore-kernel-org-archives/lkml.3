Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaG1CYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 22:24:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:37513 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbaG1CYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 22:24:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,745,1400050800"; 
   d="scan'208";a="576307867"
Message-ID: <53D5B45E.4030403@intel.com>
Date: Mon, 28 Jul 2014 10:24:30 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS buffer
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com> <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com> <20140725081033.GV3935@laptop> <53D216A4.3090600@intel.com> <20140725140652.GA6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140725140652.GA6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 10:06 PM, Peter Zijlstra wrote:
> On Fri, Jul 25, 2014 at 04:34:44PM +0800, Yan, Zheng wrote:
>> On 07/25/2014 04:10 PM, Peter Zijlstra wrote:
>>> On Tue, Jul 22, 2014 at 04:09:59PM +0800, Yan, Zheng wrote:
>>>> One corner case needs to mention is that the PEBS hardware doesn't
>>>> deal well with collisions, when PEBS events happen near to each
>>>> other. The records for the events can be collapsed into a single
>>>> one. However in practice collisions are extremely rare, as long as
>>>> different events are used. The periods are typically very large,
>>>> so any collision is unlikely. When collision happens, we can either
>>>> drop the PEBS record or use the record to serve multiple events.
>>>> This patch chooses the later approach.
>>>
>>> You can't.. the events might have different security context.
>>>
>>> Remember, the overflow bit is set from the overflow until the PEBS
>>> event is generated, this is quite a long time. So if another PEBS event
>>> gets generated while the other is still pending it will have both bits
>>> set. Even though the second bit is for another (unrelated) counter.
>>>
>>> The unrelated counter might not have privilege to observe the data of
>>> the generated event.
>>>
>>> I think you can unwind and fully correct this trainwreck.
>>
>> could you give more information how to do this.
> 
> We went over that already:
> 
> lkml.kernel.org/r/20140528170531.GT30445@twins.programming.kicks-ass.net
> 
> Now ignore the patch there, its nonsense.
> 
> But the idea is that the bit gets cleared upon writing the PEBS record.
> So look to the next record and see which bit got cleared.
> 
> Furthermore, we know that all bits set at PMI time are in-progress and
> can therefore be cleared from the last record.
> 
> This should allow us to iterate the entire thing backwards and provide
> a unique event for each record.
> 
> So take this series of 2 records and a PMI:
> 
>  C0  C1  C3  C4
>  ---------------
>   O
>   |   O
>   |   |
>   |   A          < R1
>   |       O
>   A       |      < R2
>  ---------+----- < PMI
> 
> O - overflow
> A - assist
> 
> So at PMI time we have C3 set in the overflow mask, our last even R2
> will have both C0 and C3 set, we clear C3 because we know it cannot have
> been that. Then for R1 we have C0 and C1 set, but because R2 was C0 we
> can clear C0 from R1, finding it was indeed C1.

I don't think this method works for interrupt threshold > 1 case. When collision
happens, the hardware only create one PEBS record. The status in next record has
nothing to do with the collision record.
> 
> So typically we'd have one event set and no problem, but in case there's
> more we can reconstruct with such a backwards pass from a known good
> state.
> 
> But when in doubt, we should drop the record, its the safest choice.

The problem is that, in some cases, each PEBS record has more than one events
set, so we will drop all records.

Regards
Yan, Zheng
 

