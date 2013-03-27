Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3C0UCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 16:02:22 -0400
Received: from shelob.surriel.com ([74.92.59.67]:37585 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3C0UCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 16:02:21 -0400
Message-ID: <51534FF3.2010007@surriel.com>
Date: Wed, 27 Mar 2013 16:00:51 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Michel Lespinasse <walken@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH -mm -next] ipc,sem: fix lockdep false positive
References: <1363809337-29718-1-git-send-email-riel@surriel.com>   <5150B1C2.8090607@oracle.com>   <20130325163844.042a45ba@annuminas.surriel.com>   <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>   <1364303965.5053.29.camel@laptop>   <CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com>  <1364308023.5053.40.camel@laptop> <5151BC78.3030306@surriel.com> <1364373750.5053.54.camel@laptop>
In-Reply-To: <1364373750.5053.54.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 04:42 AM, Peter Zijlstra wrote:
> On Tue, 2013-03-26 at 11:19 -0400, Rik van Riel wrote:
>>> Maybe something like:
>>>
>>> void sma_lock(struct sem_array *sma) /* global */
>>> {
>>>        int i;
>>>
>>>        sma->global_locked = 1;
>>>        smp_wmb(); /* can we merge with the LOCK ? */
>>>        spin_lock(&sma->global_lock);
>>>
>>>        /* wait for all local locks to go away */
>>>        for (i = 0; i < sma->sem_nsems; i++)
>>>                spin_unlock_wait(&sem->sem_base[i]->lock);
>>> }
>>>
>>> void sma_lock_one(struct sem_array *sma, int nr) /* local */
>>> {
>>>        smp_rmb(); /* pairs with wmb in sma_lock() */
>>>        if (unlikely(sma->global_locked)) { /* wait for global lock */
>>>                while (sma->global_locked)
>>>                        spin_unlock_wait(&sma->global_lock);
>>>        }
>>>        spin_lock(&sma->sem_base[nr]->lock);
>>> }
>
> I since realized there's an ordering problem with ->global_locked, we
> need to use spin_is_locked() or somesuch.
>
> Two competing sma_lock() operations will screw over the separate
> variable.

There may be another problem with your idea.

If there are two single locks coming in for the same semaphore,
the first one holds the lock, while the second one is spinning
on the lock.

The global lock is spinning on spin_unlock_wait, which may end
up finishing after the first single lock holder unlocks, right
before the second single lock holder grabs the lock.

At that point, you have both a process that thinks it holds the
global lock, and a process that thinks it holds a single lock.

To prevent against this, the single lock probably needs to test
whether the global lock is locked, after it acquires the local
lock.

If the global lock is locked, it needs to unlock its single lock,
and then do a spin_unlock_wait on the global lock, before trying
again from the start.

Would that work?

