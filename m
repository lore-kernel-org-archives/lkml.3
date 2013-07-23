Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415Ab3GWXyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:54:35 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23475 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085Ab3GWXye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:54:34 -0400
Message-ID: <51EF17A4.5040300@hp.com>
Date: Tue, 23 Jul 2013 19:54:12 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
References: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com> <1373679249-27123-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1307151657540.11918@ionos.tec.linutronix.de> <51E49FA3.4030202@hp.com> <alpine.DEB.2.02.1307181210330.4089@ionos.tec.linutronix.de> <51E7F95B.9050202@hp.com> <51EB74C7.7060503@linux.vnet.ibm.com>
In-Reply-To: <51EB74C7.7060503@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2013 01:42 AM, Raghavendra K T wrote:
> On 07/18/2013 07:49 PM, Waiman Long wrote:
>> On 07/18/2013 06:22 AM, Thomas Gleixner wrote:
>>> Waiman,
>>>
>>> On Mon, 15 Jul 2013, Waiman Long wrote:
>>>> On 07/15/2013 06:31 PM, Thomas Gleixner wrote:
>>>>> On Fri, 12 Jul 2013, Waiman Long wrote:
> [...]
>>>
>>>>>> + * an increase in lock size is not an issue.
>>>>> So is it faster in the general case or only for the high 
>>>>> contention or
>>>>> single thread operation cases?
>>>>>
>>>>> And you still miss to explain WHY it is faster. Can you please 
>>>>> explain
>>>>> proper WHY it is faster and WHY we can't apply that technique you
>>>>> implemented for qrwlocks to writer only locks (aka spinlocks) with a
>>>>> smaller lock size?
>>>> I will try to collect more data to justify the usefulness of qrwlock.
>>> And please provide a proper argument why we can't use the same
>>> technique for spinlocks.
>>
>> Of course, we can use the same technique for spinlock. Since we only
>> need 1 bit for lock, we could combine the lock bit with the queue
>> address with a little bit more overhead in term of coding and speed.
>> That will make the new lock 4 bytes in size for 32-bit code & 8 bytes
>> for 64-bit code. That could solve a lot of performance problem that we
>> have with spinlock. However, I am aware that increasing the size of
>> spinlock (for 64-bit systems) may break a lot of inherent alignment in
>> many of the data structures. That is why I am not proposing such a
>> change right now. But if there is enough interest, we could certainly go
>> ahead and see how things go.
>
> keeping apart the lock size part, for spinlocks, is it that
>  fastpath overhead is less significant in low contention scenarios for
> qlocks?

Fastpath speed is an important consideration for accepting changes to 
lock, especially if the critical section is short. This is the 
impression that I got so far. When the critical section is long, 
however, the speed of the fastpath will be less important.

> Also let me know if you have POC implementation for the spinlocks that
> you can share. I am happy to test that.

I don't any POC implementation for the spinlocks as I am aware that any 
increase in spinlock size will cause it hard to get merged. I could make 
one after I finish the current set of patches that I am working on.

> sorry. different context:
> apart from AIM7 fserver, is there any other benchmark to exercise this
> qrwlock series? (to help in the testing).
>
For the AIM7 test suite, the fserver & new_fserver with ext4 are the 
best ones for exercising the qrwlock series, but you do need to have a 
lot of cores to see the effect. I haven't try to find other suitable 
benchmark tests yet.

Actually, improving fserver and new_fserver performance is not my 
primary objective. My primary goal is to have a fair rwlock 
implementation that can be used to replace selected spinlocks that is in 
high contention without losing the fairness attribute of the ticket 
spinlock, just like the replacement of mutex by rwsem.

Regards,
Longman
