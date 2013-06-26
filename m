Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3FZVHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:07:22 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:10205 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3FZVHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:07:20 -0400
Message-ID: <51CB57F6.6010003@hp.com>
Date: Wed, 26 Jun 2013 17:07:02 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <20130626201713.GH6123@two.firstfloor.org>
In-Reply-To: <20130626201713.GH6123@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 04:17 PM, Andi Kleen wrote:
>> + * The combined data structure is 8-byte aligned. So proper placement of this
>> + * structure in the larger embedding data structure is needed to ensure that
>> + * there is no hole in it.
> On i386 u64 is only 4 bytes aligned. So you need to explicitely align
> it to 8 bytes. Otherwise you risk the two members crossing a cache line, which
> would be really expensive with atomics.

Do you mean the original i386 or the i586 that are now used by most 
distribution now? If it is the former, I recall that i386 is now no 
longer supported.

I also look around some existing codes that use cmpxchg64. It doesn't 
seem like they use explicit alignment. I will need more investigation to 
see if it is a real problem.
>> +	/*
>> +	 * Code doesn't work if raw spinlock is larger than 4 bytes
>> +	 * or is empty.
>> +	 */
>> +	BUG_ON((sizeof(arch_spinlock_t)>  4) || (sizeof(arch_spinlock_t) == 0));
> BUILD_BUG_ON

Thank for the suggestion, will make the change.

>> +
>> +	spin_unlock_wait(plock);	/* Wait until lock is released */
>> +	old.__lock_count = ACCESS_ONCE(*plockcnt);
>> +	get_lock = ((threshold>= 0)&&  (old.count == threshold));
>> +	if (likely(!get_lock&&  spin_can_lock(&old.lock))) {
> What is that for? Why can't you do the CMPXCHG unconditially ?

An unconditional CMPXCHG can be as bad as acquiring the spinlock. So we 
need to check the conditions are ready before doing an actual CMPXCHG.
> If it's really needed, it is most likely a race?

If there is a race going on between threads, the code will fall back to 
the old way of acquiring the spinlock.

> The duplicated code should be likely an inline.

The duplicated code is only used once in the function. I don't think an 
additional inline is really needed, but I can do it if other people also 
think that is a good idea.

>> +/*
>> + * The presence of either one of the CONFIG_DEBUG_SPINLOCK or
>> + * CONFIG_DEBUG_LOCK_ALLOC configuration parameter will force the
>> + * spinlock_t structure to be 8-byte aligned.
>> + *
>> + * To support the spinlock/reference count combo data type for 64-bit SMP
>> + * environment with spinlock debugging turned on, the reference count has
>> + * to be integrated into the spinlock_t data structure in this special case.
>> + * The spinlock_t data type will be 8 bytes larger if CONFIG_GENERIC_LOCKBREAK
>> + * is also defined.
> I would rather just disable the optimization when these CONFIGs are set

Looking from the other perspective, we may want the locking code to have 
the same behavior whether spinlock debugging is enabled or not. 
Disabling the optimization will cause the code path to differ which may 
not be what we want. Of course, I can change it if other people also 
think it is the right way to do it.

Regards,
Longman
