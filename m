Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaFRP06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:26:58 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:23821 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaFRP05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:26:57 -0400
Message-ID: <53A1AFBB.7090800@hp.com>
Date: Wed, 18 Jun 2014 11:26:51 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
        mingo@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/11] qspinlock: Paravirt support
References: <20140615124657.264658593@chello.nl> <20140615130154.213923590@chello.nl> <539F6AD5.4070301@hp.com> <53A18000.8080909@redhat.com>
In-Reply-To: <53A18000.8080909@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 08:03 AM, Paolo Bonzini wrote:
> Il 17/06/2014 00:08, Waiman Long ha scritto:
>>> +void __pv_queue_unlock(struct qspinlock *lock)
>>> +{
>>> +    int val = atomic_read(&lock->val);
>>> +
>>> +    native_queue_unlock(lock);
>>> +
>>> +    if (val & _Q_LOCKED_SLOW)
>>> +        ___pv_kick_head(lock);
>>> +}
>>> +
>>
>> Again a race can happen here between the reading and writing of the lock
>> value. I can't think of a good way to do that without using cmpxchg.
>
> Could you just use xchg on the locked byte?
>
> Paolo

The slowpath flag is just an indication that the queue head cpu might 
have been suspended. It may not be due to spurious wakeup. Releasing the 
lock unconditionally may cause the queue to be changed while it is being 
inspected. It really depending on how the cpu kicking is being handled. 
My patch delays the unlocking until all the inspections had been done to 
make sure that we don't waste time doing a cpu kick that is not needed.

-Longman
