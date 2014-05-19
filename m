Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaESXOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:14:24 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:51912 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaESXOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:14:23 -0400
MIME-Version: 1.0
In-Reply-To: <1400539179.6399.7.camel@buesod1.americas.hpqcorp.net>
References: <1399055055.6275.15.camel@buesod1.americas.hpqcorp.net>
	<tip-746c198007a8a5a155c4f74cb42f9a36f55272cf@git.kernel.org>
	<1400536056.6399.3.camel@buesod1.americas.hpqcorp.net>
	<1400539179.6399.7.camel@buesod1.americas.hpqcorp.net>
Date: Mon, 19 May 2014 16:14:22 -0700
X-Google-Sender-Auth: 9rIot1TXmSxUl1DeMeP4TyvikpM
Message-ID: <CAGQ1y=6KSQaSfv4yHp4S1vbDHR2Osa+XpCyk7w9-SbPMpnae6Q@mail.gmail.com>
Subject: Re: [tip:locking/core] rwsem: Support optimistic spinning
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Peter Hurley <peter@hurleysoftware.com>, Jason Low <jason.low2@hp.com>,
        Alex Shi <alex.shi@linaro.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 3:39 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Mon, 2014-05-19 at 14:47 -0700, Davidlohr Bueso wrote:
>> Andrew had put this patch in -next for a while, and Stephen Rothwell was
>> able to trigger some warnings: https://lkml.org/lkml/2014/5/19/627
>>
>> 8<----------------------------------------------------------------
>> From: Davidlohr Bueso <davidlohr@hp.com>
>> Subject: [PATCH] rwsem: Fix warnings for CONFIG_RWSEM_GENERIC_SPINLOCK
>>
>> Optimistic spinning is only used by the xadd variant
>> of rw-semaphores. Make sure that we use the old version
>> of the __RWSEM_INITIALIZER macro for systems that rely
>> on the spinlock one, otherwise warnings can be triggered,
>> such as the following reported on an arm box:
>>
>> ipc/ipcns_notifier.c:22:8: warning: excess elements in struct initializer [enabled by default]
>> ipc/ipcns_notifier.c:22:8: warning: (near initialization for 'ipcns_chain.rwsem') [enabled by default]
>> ipc/ipcns_notifier.c:22:8: warning: excess elements in struct initializer [enabled by default]
>> ipc/ipcns_notifier.c:22:8: warning: (near initialization for 'ipcns_chain.rwsem') [enabled by default]
>>
>> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
>> ---
>>  include/linux/rwsem.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
>> index 3e108f1..091d993 100644
>> --- a/include/linux/rwsem.h
>> +++ b/include/linux/rwsem.h
>> @@ -64,7 +64,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
>>  # define __RWSEM_DEP_MAP_INIT(lockname)
>>  #endif
>>
>> -#ifdef CONFIG_SMP
>> +#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)
>
> Of course, we can also use the following. I have no preference.
>
> #if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)

So if given the choice between the 2, I think checking
!CONFIG_RWSEM_GENERIC_SPINLOCK is better just because we use that to
decide the implementation/structure layout.

Jason
