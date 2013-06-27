Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3F0A1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 20:27:09 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20643 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3F0A1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 20:27:07 -0400
Message-ID: <51CB86CB.3050701@hp.com>
Date: Wed, 26 Jun 2013 20:26:51 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1306262307020.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306262307020.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 07:06 PM, Thomas Gleixner wrote:
> On Wed, 26 Jun 2013, Waiman Long wrote:
>
> It would have been nice if you'd had cc'ed people who spent a massive
> amount of time working on the spinlock code. Did that now.

I am sorry that I am relatively new to the Linux community and using 
get_maintainer.pl didn't out your name when I modified spinlock_types.h. 
Thank for letting me know about the shortcoming of my patch and this is 
what I am looking for.

>> +#ifndef CONFIG_SMP
>> +#define __LOCK_WITH_REFCOUNT(lock, count, u_name)	\
>> +	unsigned int count;				\
>> +	spinlock_t   lock
>> +
>> +#elif defined(__SPINLOCK_HAS_REFCOUNT)
>> +#define __LOCK_WITH_REFCOUNT(lock, count, u_name)	\
>> +	union u_name {					\
>> +		u64		__lock_count;		\
>> +		spinlock_t	lock;			\
>> +		struct {				\
>> +			arch_spinlock_t __raw_lock;	\
>> +			unsigned int	count;		\
>> +		};					\
>> +	}
>> +
>> +#else /* __SPINLOCK_HAS_REFCOUNT */
>> +#define __LOCK_WITH_REFCOUNT(lock, count, u_name)	\
>> +	union u_name {					\
>> +		u64		__lock_count;		\
>> +		struct {				\
>> +			unsigned int	count;		\
>> +			spinlock_t	lock;		\
>> +		};					\
>> +	}
>> +
>> +#endif /* __SPINLOCK_HAS_REFCOUNT */
> This is a complete design disaster. You are violating every single
> rule of proper layering. The differentiation of spinlock, raw_spinlock
> and arch_spinlock is there for a reason and you just take the current
> implementation and map your desired function to it. If we take this,
> then we fundamentally ruled out a change to the mappings of spinlock,
> raw_spinlock and arch_spinlock. This layering is on purpose and it
> took a lot of effort to make it as clean as it is now. Your proposed
> change undoes that and completely wreckages preempt-rt.

Would you mind enlighten me how this change will break preempt-rt?

> What's even worse is that you go and fiddle with the basic data
> structures:
>
>> diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
>> index 73548eb..cc107ad 100644
>> --- a/include/linux/spinlock_types.h
>> +++ b/include/linux/spinlock_types.h
>> @@ -17,8 +17,27 @@
>>
>>   #include<linux/lockdep.h>
>>
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
>> + */
>> +#if defined(CONFIG_64BIT)&&  (defined(CONFIG_DEBUG_SPINLOCK) ||\
>> +			      defined(CONFIG_DEBUG_LOCK_ALLOC))
>> +#define	__SPINLOCK_HAS_REFCOUNT	1
>> +#endif
>> +
>>   typedef struct raw_spinlock {
>>   	arch_spinlock_t raw_lock;
>> +#ifdef __SPINLOCK_HAS_REFCOUNT
>> +	unsigned int count;
>> +#endif
>>   #ifdef CONFIG_GENERIC_LOCKBREAK
>>   	unsigned int break_lock;
>>   #endif
> You need to do that, because you blindly bolt your spinlock extension
> into the existing code without taking the time to think about the
> design implications.

Another alternative is to disable this lockless update optimization for 
this special case. With that, I don't need to modify the raw_spinlock_t 
data structure.

> Do not misunderstand me, I'm impressed by the improvement numbers, but
> we need to find a way how this can be done sanely. You really have to
> understand that there is a world aside of x86 and big machines.

I am well aware that my knowledge in other architectures is very 
limited. And this is why we have this kind of public review process.

> Let's have a look at your UP implementation. It's completely broken:
>
>> +/*
>> + * Just add the value as the spinlock is a no-op
> So what protects that from being preempted? Nothing AFAICT.

Thank for the pointing this out. I can change it to return 0 to disable 
the optimization.

> What's even worse is that you break all architectures, which have an
> arch_spinlock type != sizeof(unsigned int), e.g. SPARC

Actually the code should work as long as arch_spinlock type is not 
bigger than 4 bytes because of structure field alignment.  It can be 1 
or 2 bytes. If NR_CPUS is less than 256, x86's arch_spinlock type should 
only be 2 bytes.

The only architecture that will break, according to data in the 
respectively arch/*/include/asm/spinlock_types.h files is PA-RISC 1.x 
(it is OK in PA-RISC 2.0) whose arch_spinlock type has a size of 16 
bytes. I am not sure if 32-bit PA-RISC 1.x is still supported or not, 
but we can always disable the optimization for this case.

> So what you really want is a new data structure, e.g. something like
> struct spinlock_refcount() and a proper set of new accessor functions
> instead of an adhoc interface which is designed solely for the needs
> of dcache improvements.

I had thought about that. The only downside is we need more code changes 
to make existing code to use the new infrastructure. One of the drivers 
in my design is to minimize change to existing code. Personally, I have 
no objection of doing that if others think this is the right way to go.

> The first step to achieve your goal is to consolidate all the
> identical copies of arch_spinlock_t and talk to the maintainers of the
> architectures which have a different (i.e. !32bit) notion of the arch
> specific spinlock implementation, whether it's possible to move over
> to a common data struct. Once you have achieved this, you can build
> your spinlock + refcount construct upon that.

As I said above, as long as the arch_spinlock type isn't bigger than 4 
bytes, the code should work.

Regards,
Longman
