Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaKZQaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:30:46 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:38951 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaKZQao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:30:44 -0500
Message-ID: <5476002B.30900@de.ibm.com>
Date: Wed, 26 Nov 2014 17:30:35 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com> <20141126070258.GA25523@redhat.com> <20141126110504.511b733a@thinkpad-w530> <20141126151729.GB9612@redhat.com> <20141126152334.GA9648@redhat.com> <20141126163207.63810fcb@thinkpad-w530> <20141126154717.GB10568@redhat.com> <20141126170223.3b108b94@thinkpad-w530> <20141126161947.GA10850@redhat.com>
In-Reply-To: <20141126161947.GA10850@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112616-0017-0000-0000-000001FD6EFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.11.2014 um 17:19 schrieb Michael S. Tsirkin:
> On Wed, Nov 26, 2014 at 05:02:23PM +0100, David Hildenbrand wrote:
>>>> This is what happened on our side (very recent kernel):
>>>>
>>>> spin_lock(&lock)
>>>> copy_to_user(...)
>>>> spin_unlock(&lock)
>>>
>>> That's a deadlock even without copy_to_user - it's
>>> enough for the thread to be preempted and another one
>>> to try taking the lock.
>>>
>>>
>>>> 1. s390 locks/unlocks a spin lock with a compare and swap, using the _cpu id_
>>>>    as "old value"
>>>> 2. we slept during copy_to_user()
>>>> 3. the thread got scheduled onto another cpu
>>>> 4. spin_unlock failed as the _cpu id_ didn't match (another cpu that locked
>>>>    the spinlock tried to unlocked it).
>>>> 5. lock remained locked -> deadlock
>>>>
>>>> Christian came up with the following explanation:
>>>> Without preemption, spin_lock() will not touch the preempt counter.
>>>> disable_pfault() will always touch it.
>>>>
>>>> Therefore, with preemption disabled, copy_to_user() has no idea that it is
>>>> running in atomic context - and will therefore try to sleep.
>>>>
>>>> So copy_to_user() will on s390:
>>>> 1. run "as atomic" while spin_lock() with preemption enabled.
>>>> 2. run "as not atomic" while spin_lock() with preemption disabled.
>>>> 3.  run "as atomic" while pagefault_disabled() with preemption enabled or
>>>> disabled.
>>>> 4. run "as not atomic" when really not atomic.
>>
>> should have been more clear at that point: 
>> preemption enabled == kernel compiled with preemption support
>> preemption disabled == kernel compiled without preemption support
>>
>>>>
>>>> And exactly nr 2. is the thing that produced the deadlock in our scenario and
>>>> the reason why I want a might_sleep() :)
>>>
>>> IMHO it's not copy to user that causes the problem.
>>> It's the misuse of spinlocks with preemption on.
>>
>> As I said, preemption was off.
> 
> off -> disabled at compile time?
> 
> But the code is broken for people that do enable it.
[...]
> You should normally disable preemption if you take
> spinlocks.

Your are telling that any sequence of
spin_lock
...
spin_unlock

is broken with CONFIG_PREEMPT?
Michael, that is bullshit. spin_lock will take care of CONFIG_PREEMPT just fine. 

Only sequences like
spin_lock
...
schedule
...
spin_unlock
are broken.

But as I said. That is not the problem that we are discussing here.

Christian

