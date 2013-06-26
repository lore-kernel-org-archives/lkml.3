Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3FZX0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:26:36 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:2399 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3FZX0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:26:34 -0400
Message-ID: <51CB7898.5070206@hp.com>
Date: Wed, 26 Jun 2013 19:26:16 -0400
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
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <20130626201713.GH6123@two.firstfloor.org> <51CB57F6.6010003@hp.com> <20130626212221.GI6123@two.firstfloor.org>
In-Reply-To: <20130626212221.GI6123@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 05:22 PM, Andi Kleen wrote:
> On Wed, Jun 26, 2013 at 05:07:02PM -0400, Waiman Long wrote:
>> On 06/26/2013 04:17 PM, Andi Kleen wrote:
>>>> + * The combined data structure is 8-byte aligned. So proper placement of this
>>>> + * structure in the larger embedding data structure is needed to ensure that
>>>> + * there is no hole in it.
>>> On i386 u64 is only 4 bytes aligned. So you need to explicitely align
>>> it to 8 bytes. Otherwise you risk the two members crossing a cache line, which
>>> would be really expensive with atomics.
>> Do you mean the original i386 or the i586 that are now used by most
>> distribution now? If it is the former, I recall that i386 is now no
>> longer supported.
> I mean i386, as in the 32bit x86 architecture.
>
>> I also look around some existing codes that use cmpxchg64. It
>> doesn't seem like they use explicit alignment. I will need more
>> investigation to see if it is a real problem.
> Adding the alignment is basically free. If 32bit users don't enforce
> it they're likely potentially broken yes, but they may be lucky.

You are right. I will added the 8-byte alignment attribute to the union 
definition and document that in the code.

>>>> +	get_lock = ((threshold>= 0)&&   (old.count == threshold));
>>>> +	if (likely(!get_lock&&   spin_can_lock(&old.lock))) {
>>> What is that for? Why can't you do the CMPXCHG unconditially ?
>> An unconditional CMPXCHG can be as bad as acquiring the spinlock. So
>> we need to check the conditions are ready before doing an actual
>> CMPXCHG.
> But this isn't a cheap check. Especially spin_unlock_wait can be
> very expensive.
> And all these functions have weird semantics. Perhaps just a quick
> spin_is_locked.

In the uncontended case, doing spin_unlock_wait will be similar to 
spin_can_lock. This, when combined with a cmpxchg, is still faster than 
doing 2 atomic operations in spin_lock/spin_unlock.

In the contended case, doing spin_unlock_wait won't be more expensive 
than doing spin_lock. Without doing that, most of the threads will fall 
back to acquiring the lock negating any performance benefit. I had tried 
that without spin_unlock_wait and there wasn't that much performance 
gain in the AIM7 short workload. BTW, spin_can_lock is just the negation 
of spin_is_locked.

Regards,
Longman
