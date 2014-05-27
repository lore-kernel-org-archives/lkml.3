Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaE0Lux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:50:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbaE0Luv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:50:51 -0400
Message-ID: <53847C17.2080609@suse.cz>
Date: Tue, 27 May 2014 13:50:47 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [RFC][PATCH 0/5] VM_PINNED
References: <20140526145605.016140154@infradead.org>	<CALYGNiMG1NVBUS4TJrYJMr92yWGZHSdGUdCGtBJDHoUMMhE+Wg@mail.gmail.com>	<20140526203232.GC5444@laptop.programming.kicks-ass.net>	<CALYGNiO8FNKjtETQMRSqgiArjfQ9nRAALUg9GGdNYbpKru=Sjw@mail.gmail.com>	<20140527102909.GO30445@twins.programming.kicks-ass.net>	<20140527105438.GW13658@twins.programming.kicks-ass.net> <CALYGNiNCp5ShyKLAQi_cht_-sPt79Zxzj=Q=VSzqCvdnsCE5ag@mail.gmail.com>
In-Reply-To: <CALYGNiNCp5ShyKLAQi_cht_-sPt79Zxzj=Q=VSzqCvdnsCE5ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 01:11 PM, Konstantin Khlebnikov wrote:
> On Tue, May 27, 2014 at 2:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, May 27, 2014 at 12:29:09PM +0200, Peter Zijlstra wrote:
>>> On Tue, May 27, 2014 at 12:49:08AM +0400, Konstantin Khlebnikov wrote:
>>>> Another suggestion. VM_RESERVED is stronger than VM_LOCKED and extends
>>>> its functionality.
>>>> Maybe it's easier to add VM_DONTMIGRATE and use it together with VM_LOCKED.
>>>> This will make accounting easier. No?
>>>
>>> I prefer the PINNED name because the not being able to migrate is only
>>> one of the desired effects of it, not the primary effect. We're really
>>> looking to keep physical pages in place and preserve mappings.
> 
> Ah, I just mixed it up.
> 
>>>
>>> The -rt people for example really want to avoid faults (even minor
>>> faults), and DONTMIGRATE would still allow unmapping.
>>>
>>> Maybe always setting VM_PINNED and VM_LOCKED together is easier, I
>>> hadn't considered that. The first thing that came to mind is that that
>>> might make the fork() semantics difficult, but maybe it works out.
>>>
>>> And while we're on the subject, my patch preserves PINNED over fork()
>>> but maybe we don't actually need that either.
>>
>> So pinned_vm is userspace exposed, which means we have to maintain the
>> individual counts, and doing the fully orthogonal accounting is 'easier'
>> than trying to get the boundary cases right.
>>
>> That is, if we have a program that does mlockall() and then does the IB
>> ioctl() to 'pin' a region, we'd have to make mm_mpin() do munlock()
>> after it splits the vma, and then do the pinned accounting.
>>
>> Also, we'll have lost the LOCKED state and unless MCL_FUTURE was used,
>> we don't know what to restore the vma to on mm_munpin().
>>
>> So while the accounting looks tricky, it has simpler semantics.
> 
> What if VM_PINNED will require VM_LOCKED?
> I.e. user must mlock it before pining and cannot munlock vma while it's pinned.

Mlocking makes sense, as pages won't be uselessly scanned on
non-evictable LRU, no? (Or maybe I just don't see that something else
prevents then from being there already).

Anyway I like the idea of playing nicer with compaction etc.

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

