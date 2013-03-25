Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab3CYVmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:42:18 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:45032 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3CYVmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:42:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130325163844.042a45ba@annuminas.surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<5150B1C2.8090607@oracle.com>
	<20130325163844.042a45ba@annuminas.surriel.com>
Date: Mon, 25 Mar 2013 14:42:17 -0700
Message-ID: <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
Subject: Re: [PATCH -mm -next] ipc,sem: fix lockdep false positive
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@surriel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 1:38 PM, Rik van Riel <riel@surriel.com> wrote:
> On Mon, 25 Mar 2013 16:21:22 -0400
> Sasha Levin <sasha.levin@oracle.com> wrote:
>
>> On 03/20/2013 03:55 PM, Rik van Riel wrote:
>> > Include lkml in the CC: this time... *sigh*
>> > ---8<---
>> >
>> > This series makes the sysv semaphore code more scalable,
>> > by reducing the time the semaphore lock is held, and making
>> > the locking more scalable for semaphore arrays with multiple
>> > semaphores.
>>
>> Hi Rik,
>>
>> I'm getting the following false positives from lockdep:
>
> Does this patch fix it?

I'll be surprised if it does, because we don't actually have single
depth nesting here...
Adding Peter & Ingo for advice about how to proceed
(the one solution I know would involve using arch_spin_lock() directly
to bypass the lockdep checks, but there's got to be a better way...)

> Andrew, this looks like another one for the queue...
> ---8<---
> Subject: [PATCH -mm -next] ipc,sem: fix lockdep false positive
>
> When locking all the semaphores inside a sem_array, the kernel ends up
> locking a large number of locks with identical lockdep status. This
> trips up lockdep.  Annotate the code to prevent such warnings.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  ipc/sem.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 450248e..f46441a 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -357,7 +357,7 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
>                 spin_lock(&sma->sem_perm.lock);
>                 for (i = 0; i < sma->sem_nsems; i++) {
>                         struct sem *sem = sma->sem_base + i;
> -                       spin_lock(&sem->lock);
> +                       spin_lock_nested(&sem->lock, SINGLE_DEPTH_NESTING);
>                 }
>                 locknum = -1;
>         }
> @@ -558,7 +558,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
>         for (i = 0; i < nsems; i++) {
>                 INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
>                 spin_lock_init(&sma->sem_base[i].lock);
> -               spin_lock(&sma->sem_base[i].lock);
> +               spin_lock_nested(&sma->sem_base[i].lock, SINGLE_DEPTH_NESTING);
>         }
>
>         sma->complex_count = 0;
>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
