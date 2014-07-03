Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbaGCVfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:35:09 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:3426 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaGCVfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:35:07 -0400
Message-ID: <53B5CC85.1040603@hp.com>
Date: Thu, 03 Jul 2014 17:35:01 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Cancellable MCS spinlock rework
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>   <20140702162749.GP19379@twins.programming.kicks-ass.net>   <1404320356.3170.12.camel@j-VirtualBox>   <20140702172333.GQ19379@twins.programming.kicks-ass.net>   <1404322203.3170.17.camel@j-VirtualBox>   <20140703073107.GS19379@twins.programming.kicks-ass.net>   <1404407389.2498.3.camel@buesod1.americas.hpqcorp.net>  <1404412485.8764.33.camel@j-VirtualBox> <53B5BE99.1090008@hp.com> <1404420708.8764.54.camel@j-VirtualBox>
In-Reply-To: <1404420708.8764.54.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 04:51 PM, Jason Low wrote:
> On Thu, 2014-07-03 at 16:35 -0400, Waiman Long wrote:
>> On 07/03/2014 02:34 PM, Jason Low wrote:
>>> On Thu, 2014-07-03 at 10:09 -0700, Davidlohr Bueso wrote:
>>>> On Thu, 2014-07-03 at 09:31 +0200, Peter Zijlstra wrote:
>>>>> On Wed, Jul 02, 2014 at 10:30:03AM -0700, Jason Low wrote:
>>>>>> Would potentially reducing the size of the rw semaphore structure by 32
>>>>>> bits (for all architectures using optimistic spinning) be a nice
>>>>>> benefit?
>>>>> Possibly, although I had a look at the mutex structure and we didn't
>>>>> have a hole to place it in, unlike what you found with the rwsem.
>>>> Yeah, and currently struct rw_semaphore is the largest lock we have in
>>>> the kernel. Shaving off space is definitely welcome.
>>> Right, especially if it could help things like xfs inode.
>>>
>> I do see a point in reducing the size of the rwsem structure. However, I
>> don't quite understand the point of converting pointers in the
>> optimistic_spin_queue structure to atomic_t.
> Converting the pointers in the optimistic_spin_queue to atomic_t would
> mean we're fully operating on atomic operations instead of using the
> potentially racy cmpxchg + ACCESS_ONCE stores on the pointers.

Yes, the ACCESS_ONCE macro for data store does have problem on some 
architectures. However, I prefer a more holistic solution to solve this 
problem rather than a workaround by changing the pointers to atomic_t's. 
It is because even if we make the change,  we are still not sure if that 
will work for those architectures as we have no machine to verify that. 
Why not let the champions of those architectures to propose changes 
instead of making some untested changes now and penalize commonly used 
architectures like x86.

> If we're in the process of using the CPU numbers in atomic_t, I thought
> we might as well fix that as well since it has actually been shown to
> result in lockups on some architectures. We can then avoid needing to
> implement the tricky architecture workarounds for optimistic spinning.
> Wouldn't that be a "nice-have"?
>
> Jason
>

I am not aware of any tricky architectural workarounds other than 
disabling optimistic spinning for those that don't support it.

-Longman

