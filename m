Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3C2NIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:08:40 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65039 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab3C2NIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:08:38 -0400
MIME-Version: 1.0
In-Reply-To: <51558407.5040005@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<5150B1C2.8090607@oracle.com>
	<20130325163844.042a45ba@annuminas.surriel.com>
	<CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
	<1364303965.5053.29.camel@laptop>
	<CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com>
	<1364308023.5053.40.camel@laptop>
	<5151BC78.3030306@surriel.com>
	<1364373750.5053.54.camel@laptop>
	<20130328162337.3003ccd4@cuia.bos.redhat.com>
	<CANN689GGwztb=beCNtUU8SJp6sfjn_mNTaHQxezt=ehtxvYBAA@mail.gmail.com>
	<51558407.5040005@surriel.com>
Date: Fri, 29 Mar 2013 06:08:37 -0700
Message-ID: <CANN689FGoTF=5sbYSE7JyyS9CyyYTLrjHq5B0O23tFuCh550qg@mail.gmail.com>
Subject: Re: [PATCH v2 -mm -next] ipc,sem: fix lockdep false positive
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@surriel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 5:07 AM, Rik van Riel <riel@surriel.com> wrote:
> On 03/28/2013 10:50 PM, Michel Lespinasse wrote:
>> On Thu, Mar 28, 2013 at 1:23 PM, Rik van Riel <riel@surriel.com> wrote:
>>>                  if (unlikely(sma->complex_count)) {
>>>                          spin_unlock(&sem->lock);
>>> -                       goto lock_all;
>>> +                       goto lock_array;
>>> +               }
>>> +
>>> +               /*
>>> +                * Another process is holding the global lock on the
>>> +                * sem_array; we cannot enter our critical section,
>>> +                * but have to wait for the global lock to be released.
>>> +                */
>>> +               if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
>>> +                       spin_unlock(&sem->lock);
>>> +                       goto again;
>>
>> This is IMO where the spin_unlock_wait(&sma->sem_perm.lock) would
>> belong - right before the goto again.
>
> That is where I had it initially. I may have gotten too clever
> and worked on keeping more accesses read-only. If you want, I
> can move it back here and re-submit the patch :)

I think I would prefer that - I feel having it upper serves little
purpose, as you still need to check it here, so we might as well be
optimistic and check it only here. Or maybe I've missed the benefit of
having it earlier - I just don't see it.

>> Also - I think there is a risk that an endless stream of complex
>> semops could starve a simple semop here, as it would always find the
>> sem_perm.lock to be locked ??? One easy way to guarantee progress
>> would be to goto lock_array instead; however there is then the issue
>> that a complex semop could force an endless stream of following simple
>> semops to take the lock_array path. I'm not sure which of these
>> problems is preferable to have...
>
> If starvation turns out to be an issue, there is an even
> simpler solution:
>
>         if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
>                 spin_unlock(&sem->lock);
>                 spin_lock(&sma->sem_perm.lock);
>                 spin_lock(&sem->lock);
>                 spin_unlock(&sma->sem_perm.lock);
>         }

This is kinda nice - certainly nicer than falling back to the lock_array case.

It still makes it possible (though less likely) that each simple semop
taking this path might make the next one take it too, though. So, I'm
not sure how to balance that against the starvation possibility. I'll
leave it up to you then :)

Cheers,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
