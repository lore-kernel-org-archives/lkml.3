Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbaGVTe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:34:57 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:14697 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbaGVTez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:34:55 -0400
Message-ID: <53CEBCDB.8060106@hp.com>
Date: Tue, 22 Jul 2014 15:34:51 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Scott J Norton <scott.norton@hp.com>
Subject: Re: [RFC PATCH 2/5] futex: add optimistic spinning to FUTEX_SPIN_LOCK
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>  <1405956271-34339-3-git-send-email-Waiman.Long@hp.com> <1405973838.4677.11.camel@j-VirtualBox>
In-Reply-To: <1405973838.4677.11.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 04:17 PM, Jason Low wrote:
> On Mon, 2014-07-21 at 11:24 -0400, Waiman Long wrote:
>> This patch adds code to do optimistic spinning for the FUTEX_SPIN_LOCK
>> primitive on the futex value when the lock owner is running. It is
>> the same optimistic spinning technique that is done in the mutex and
>> rw semaphore code to improve their performance especially on large
>> systems with large number of CPUs. When the lock owner is not running,
>> the spinning tasks will go to sleep.
> Perhaps we could introduce a "CONFIG_FUTEX_SPIN_ON_OWNER" that depends
> on SMP and ARCH_SUPPORTS_ATOMIC_RMW?

The new futex opcode depends on the ability to do cmpxchg() in the futex 
context. The code will be disabled if futex cmpxchg is not supported. I 
guess that should be enough to limit it to just a handful of architectures.

>> There is 2 major advantages of doing optimistic spinning here:
>>   1) It eliminates the context switching latency and overhead (at
>>      least a few us) associated with sleeping and wakeup.
>>   2) It eliminates most of the need to call futex(2) with
>>      FUTEX_SPIN_UNLOCK as spinning is done without the need to set
>>      the FUTEX_WAITERS bit.
>>   struct futex_q_head {
>>   	struct list_head	      hnode;
>>   	struct list_head	      waitq;
>>   	union futex_key		      key;
>> +	struct optimistic_spin_queue *osq;
> And this would have to be updated to
>
> +	struct optimistic_spin_queue osq;
>
> given the recent changes to the osq lock.

Yes, I will make the change in the next iteration of the patch.

-Longman

