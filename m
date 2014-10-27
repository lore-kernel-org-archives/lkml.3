Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaJ0PDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:03:03 -0400
Received: from mail1.windriver.com ([147.11.146.13]:47643 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaJ0PDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:03:00 -0400
Message-ID: <544E5E77.1000000@windriver.com>
Date: Mon, 27 Oct 2014 09:02:15 -0600
From: Chris Friesen <chris.friesen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: semantics of reader/writer semaphores in rt patch
References: <544956B8.2000406@windriver.com> <alpine.DEB.2.11.1410252354030.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410252354030.5308@nanos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.118.178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2014 04:19 PM, Thomas Gleixner wrote:
> On Thu, 23 Oct 2014, Chris Friesen wrote:
>
>> I recently noticed that when CONFIG_PREEMPT_RT_FULL is enabled we the
>> semantics change.  From "include/linux/rwsem_rt.h":
>>
>>   * Note that the semantics are different from the usual
>>   * Linux rw-sems, in PREEMPT_RT mode we do not allow
>>   * multiple readers to hold the lock at once, we only allow
>>   * a read-lock owner to read-lock recursively. This is
>>   * better for latency, makes the implementation inherently
>>   * fair and makes it simpler as well.
>>
>> How is this valid?  It seems to me that there are any number of code paths
>> that could depend on having multiple threads of execution be able to hold the
>> reader lock simultaneously.  Something as simple as:
>>
>> thread A:
>> take rw_semaphore X for reading
>> take lock Y, modify data, release lock Y
>> wake up thread B
>> wait on conditional protected by lock Y
>> free rw_semaphore X
>>
>> thread B:
>> take rw_semaphore X for reading
>> wait on conditional protected by lock Y
>> send message to wake up thread A
>> free rw_semaphore X
>
> I don't see why B should wake A without changing the conditional. A
> won't make progress by being woken by B as the conditional does not
> magically change just because B wakes A.
>
> So what you wanted to say is:
>
>    thread B:
>    take rw_semaphore X for reading
>    wait on conditional protected by lock Y
> + take lock Y, modify data, release lock Y
>    send message to wake up thread A
>    free rw_semaphore X
>
> Otherwise your example does not make any sense at all. And that has
> some serious non RT related implications.


Yes, your reformulated version is what I meant to say.  Sorry for any 
confusion.


>> Does the RT kernel just disallow this sort of algorithm?
>
> Yes. For a good reason. Let's add thread C
>
> A    	   	B		C
> down_read(X)
> 				down_write(X)
> lock(Y)
> modify data
> unlock(Y)
> wake(B)
> 		down_read(X)
>
> Due to the mainline rwsem fairness semantics:
>
> A holds X, C is blocked on A and B is blocked on A.
>
> Deadlock, without RT and the single reader restriction being involved.


Crap, I had forgotten about the fairness semantics stuff.  That makes 
perfect sense.

Thanks for the explanation.

Chris

