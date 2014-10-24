Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086AbaJXEAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 00:00:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:50344 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750699AbaJXEAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 00:00:20 -0400
X-IronPort-AV: E=Sophos;i="5.04,778,1406563200"; 
   d="scan'208";a="38468679"
Message-ID: <5449C8A6.9080403@cn.fujitsu.com>
Date: Fri, 24 Oct 2014 11:33:58 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <torvalds@linux-foundation.org>, <paulmck@linux.vnet.ibm.com>,
        <tglx@linutronix.de>, <akpm@linux-foundation.org>, <riel@redhat.com>,
        <mgorman@suse.de>, <oleg@redhat.com>, <mingo@redhat.com>,
        <minchan@kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <viro@zeniv.linux.org.uk>, <dave@stgolabs.net>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 4/6] SRCU free VMAs
References: <20141020215633.717315139@infradead.org> <20141020222841.419869904@infradead.org> <5448D515.90006@cn.fujitsu.com> <20141023110346.GP21513@worktop.programming.kicks-ass.net>
In-Reply-To: <20141023110346.GP21513@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 07:03 PM, Peter Zijlstra wrote:
> On Thu, Oct 23, 2014 at 06:14:45PM +0800, Lai Jiangshan wrote:
>>
>>>  
>>> +struct vm_area_struct *find_vma_srcu(struct mm_struct *mm, unsigned long addr)
>>> +{
>>> +	struct vm_area_struct *vma;
>>> +	unsigned int seq;
>>> +
>>> +	WARN_ON_ONCE(!srcu_read_lock_held(&vma_srcu));
>>> +
>>> +	do {
>>> +		seq = read_seqbegin(&mm->mm_seq);
>>> +		vma = __find_vma(mm, addr);
>>
>> will the __find_vma() loops for ever due to the rotations in the RBtree?
> 
> No, a rotation takes a tree and generates a tree, furthermore the
> rotation has a fairly strict fwd progress guarantee seeing how its now
> done with preemption disabled.

I can't get the magic.

__find_vma is visiting vma_a,
vma_a is rotated to near the top due to multiple updates to the mm.
__find_vma is visiting down to near the bottom, vma_b.
now vma_b is rotated up to near the top again.
__find_vma is visiting down to near the bottom, vma_c.
now vma_c is rotated up to near the top again.

...




> 
> Therefore, even if we're in a node that's being rotated up, we can only
> 'loop' for as long as it takes for the new pointer stores to become
> visible on our CPU.
> 
> Thus we have a tree descent termination guarantee.
> .
> 

