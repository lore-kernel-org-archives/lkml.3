Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3F2Uah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 16:30:37 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:21411 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3F2Uaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 16:30:35 -0400
Message-ID: <51CF43DE.4070703@hp.com>
Date: Sat, 29 Jun 2013 16:30:22 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andi Kleen <andi@firstfloor.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <20130626201713.GH6123@two.firstfloor.org> <51CB57F6.6010003@hp.com> <20130626212221.GI6123@two.firstfloor.org> <51CB7898.5070206@hp.com> <20130627010658.GL6123@two.firstfloor.org> <51CB9233.7020508@hp.com> <51CB9450.80601@hp.com> <20130627013714.GM6123@two.firstfloor.org> <51CC528A.4000001@hp.com> <alpine.DEB.2.02.1306281536020.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306281536020.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 09:46 AM, Thomas Gleixner wrote:
> On Thu, 27 Jun 2013, Waiman Long wrote:
>> On 06/26/2013 09:37 PM, Andi Kleen wrote:
>>>> It will be hard to know what changes will be needed without knowing
>>>> the exact semantics of the spinlock functions with lock elision. Can
>>>> you explain a little more what bizarre semantics you are referring
>>>> to?
>>> Totally independent of elision.
>>>
>>> For example, what semantics does spin_unlock_wait() have with a ticket
>>> lock. Where in the queue does it wait?
>>> It doesn't really make sense with a ticket lock.
>>>
>>> What semantics would lockdep put on it?
>>>
>>> -Andi
>> Calling spin_unlock_wait() doesn't put the caller into a queue. It just wait
>> until the lock is no longer held by any thread. Yes, there is a possibility
>> that the lock can be so busy that it may be hold by various threads
>> continuously for a long time making it hard for those who wait to proceed.
>> Perhaps, I should change the code to abandon the use of spin_unlock_wait().
>> Instead, I can make it wait for the lock to be free with some kind of timeout
>> to make sure that it won't wait too long.
> Please no timeout heuristics. They are bound to be wrong.
>
> If the lock is held by some other cpu, then waiting for it with
> unlock_wait() or a magic timeout is probably equally expensive as just
> going into the slow path right away.

After some more thought, it may not be such a bad idea of have some kind 
of timeout. In that case, the code will just fall back to the old way of 
acquiring the spinlock before updating the count. If the lock is really 
busy, it is possible that the waiting thread may get starved to a point 
that it cannot proceed for a really long time. A timeout mechanism 
ensures that unfairness to the waiting thread will be limited. The exact 
timeout value is not that critical, a larger value will increase the 
probability of doing a lockless update and a smaller value will decrease 
the probability.

Regards,
Longman
