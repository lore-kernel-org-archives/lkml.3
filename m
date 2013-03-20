Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3CTPi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:38:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab3CTPi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:38:58 -0400
Message-ID: <5149D7ED.4040702@redhat.com>
Date: Wed, 20 Mar 2013 11:38:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 4/4] ipc: sem: do not hold ipc lock more than necessary
References: <1362476179.2225.54.camel@buesod1.americas.hpqcorp.net> <5149C76D.7090409@redhat.com>
In-Reply-To: <5149C76D.7090409@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 10:27 AM, Rik van Riel wrote:
> On 03/05/2013 04:36 AM, Davidlohr Bueso wrote:
>
>> @@ -1476,8 +1539,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct
>> sembuf __user *, tsops,
>>       queue.sleeper = current;
>>
>>   sleep_again:
>> -    current->state = TASK_INTERRUPTIBLE;
>>       sem_unlock(sma);
>> +    current->state = TASK_INTERRUPTIBLE;
>>
>>       if (timeout)
>>           jiffies_left = schedule_timeout(jiffies_left);
>
> After modifying my test case to start with a semaphore value of 1 on
> every semaphore, and do down followed by up (to have only one process
> take each semaphore at a time), I started seeing lost wakeups and the
> test case being stuck.
>
> I believe the change above is the cause of that issue.
>
> By unlocking before setting current->state to TASK_INTERRUPTIBLE,
> there is a small window where the next lock holder can grab the
> lock and wake us up, before we set ourselves to TASK_INTERRUPTIBLE
> and go to sleep.
>
> I have reverted your change in my code and am building a test kernel
> now.
>
> If things work, I'll clean up the whole patch series for a re-posting
> today.

Half a billion semaphore operations later, I am pretty sure
the above was the cause of the semaphore hangups we both
observed :)

I am currently building a kernel with the cleaned up patch
series I put together while building the previous test kernel.

If all goes well, expect a patch series after lunch...

-- 
All rights reversed
