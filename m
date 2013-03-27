Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab3C0LW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:22:26 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:47248 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3C0LWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:22:24 -0400
MIME-Version: 1.0
In-Reply-To: <1364373750.5053.54.camel@laptop>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<5150B1C2.8090607@oracle.com>
	<20130325163844.042a45ba@annuminas.surriel.com>
	<CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
	<1364303965.5053.29.camel@laptop>
	<CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com>
	<1364308023.5053.40.camel@laptop>
	<5151BC78.3030306@surriel.com>
	<1364373750.5053.54.camel@laptop>
Date: Wed, 27 Mar 2013 04:22:23 -0700
Message-ID: <CANN689G9Xt6Hmpg70x3LMy-KtccD5EvdjOW4SF+d6PsJCwK0tg@mail.gmail.com>
Subject: Re: [PATCH -mm -next] ipc,sem: fix lockdep false positive
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>, Sasha Levin <sasha.levin@oracle.com>,
        torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, lwoodman@redhat.com,
        chegu_vinod@hp.com, Dave Jones <davej@redhat.com>, benisty.e@gmail.com,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 1:42 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2013-03-26 at 11:19 -0400, Rik van Riel wrote:
>> > Maybe something like:
>> >
>> > void sma_lock(struct sem_array *sma) /* global */
>> > {
>> >       int i;
>> >
>> >       sma->global_locked = 1;
>> >       smp_wmb(); /* can we merge with the LOCK ? */
>> >       spin_lock(&sma->global_lock);
>> >
>> >       /* wait for all local locks to go away */
>> >       for (i = 0; i < sma->sem_nsems; i++)
>> >               spin_unlock_wait(&sem->sem_base[i]->lock);
>> > }
>> >
>> > void sma_lock_one(struct sem_array *sma, int nr) /* local */
>> > {
>> >       smp_rmb(); /* pairs with wmb in sma_lock() */
>> >       if (unlikely(sma->global_locked)) { /* wait for global lock */
>> >               while (sma->global_locked)
>> >                       spin_unlock_wait(&sma->global_lock);
>> >       }
>> >       spin_lock(&sma->sem_base[nr]->lock);
>> > }
>
> I since realized there's an ordering problem with ->global_locked, we
> need to use spin_is_locked() or somesuch.
>
> Two competing sma_lock() operations will screw over the separate
> variable.
>
>>
>> > This still has the problem of a non-preemptible section of
>> O(sem_nsems)
>> > (with the avg wait-time on the local lock). Could we make the global
>> > lock a sleeping lock?
>>
>> Not without breaking your scheme above :)
>
> How would making sma->global_lock a mutex wreck anything?

I don't remember the details (rik probably will), but rcu is also
already involved, so there is a non trivial chance that it would...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
