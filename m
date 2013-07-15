Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab3GOVAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:00:38 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:17079 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3GOVAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:00:35 -0400
Message-ID: <51E462E5.4020806@hp.com>
Date: Mon, 15 Jul 2013 17:00:21 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v6 01/14] spinlock: A new lockref structure for lockless
 update of refcount
References: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com> <1373332204-10379-2-git-send-email-Waiman.Long@hp.com> <51E18730.2020105@hitachi.com>
In-Reply-To: <51E18730.2020105@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2013 12:58 PM, Masami Hiramatsu wrote:
> Hi,
>
> (2013/07/09 10:09), Waiman Long wrote:> +/**
>> + * lockref_put_or_lock - decrements count unless count <= 1 before decrement
>> + * @lockcnt: pointer to lockref structure
>> + * Return: 1 if count updated successfully or 0 if count <= 1 and lock taken
>> + *
>> + * The only difference between lockref_put_or_lock and lockref_put is that
>> + * the former function will hold the lock on return while the latter one
>> + * will free it on return.
>> + */
>> +static __always_inline int lockref_put_or_locked(struct lockref *lockcnt)
> Here is a function name typo. _locked should be _lock.
> And also, I think we should take a note here to tell this function does *not*
> guarantee lockcnt->refcnt == 0 or 1 until unlocked if this returns 0.

Thank for pointing this out. I will fix the typo and add additional note
to the comments.

>> +{
>> +	spin_lock(&lockcnt->lock);
>> +	if (likely(lockcnt->refcnt > 1)) {
>> +		lockcnt->refcnt--;
>> +		spin_unlock(&lockcnt->lock);
>> +		return 1;
>> +	}
>> +	return 0;
>> +}
> Using this implementation guarantees lockcnt->refcnt == 0 or 1 until unlocked
> if this returns 0.
>
> However, the below one looks not guarantee it. Since lockref_add_unless
> and spinlock are not done atomically, there is a chance for someone
> to increment it right before locking.
>
> Or, I missed something?

For both functions, reference count won't be decremented to 0 and the
caller has to handle this case by taking the lock and do whatever it
needs to handle it. When refcnt > 1, decrement is done atomically either
by cmpxchg or with the spinlock hold. The reason for these 2 functions
is to save an extra lock/unlock sequence when this feature is disabled.
I will add comments to clarify that.

>> +/**
>> + * lockref_put_or_lock - Decrements count unless the count is <= 1
>> + *			 otherwise, the lock will be taken
>> + * @lockcnt: pointer to struct lockref structure
>> + * Return: 1 if count updated successfully or 0 if count <= 1 and lock taken
>> + */
>> +int
>> +lockref_put_or_lock(struct lockref *lockcnt)
>> +{
>> +	if (lockref_add_unless(lockcnt, -1, 1))
>> +		return 1;
>> +	spin_lock(&lockcnt->lock);
>> +	return 0;
>> +}
> BTW, it looks that your dcache patch knows this and keeps double check for
> the case of lockcnt->refcnt > 1 in dput().

There is a slight chance that the refcnt may be changed in between
locked section of code. So it is prudent to double check before
decrementing it to zero.

Regards,
Longman
