Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab3CZNkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:40:12 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:35808 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933859Ab3CZNkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <1364303965.5053.29.camel@laptop>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<5150B1C2.8090607@oracle.com>
	<20130325163844.042a45ba@annuminas.surriel.com>
	<CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
	<1364303965.5053.29.camel@laptop>
Date: Tue, 26 Mar 2013 06:40:09 -0700
Message-ID: <CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com>
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

On Tue, Mar 26, 2013 at 6:19 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2013-03-25 at 14:42 -0700, Michel Lespinasse wrote:
>> depth nesting here...
>> Adding Peter & Ingo for advice about how to proceed
>
>> > +++ b/ipc/sem.c
>> > @@ -357,7 +357,7 @@ static inline int sem_lock(struct sem_array
>> *sma, struct sembuf *sops,
>> >                 spin_lock(&sma->sem_perm.lock);
>> >                 for (i = 0; i < sma->sem_nsems; i++) {
>> >                         struct sem *sem = sma->sem_base + i;
>> > -                       spin_lock(&sem->lock);
>> > +                       spin_lock_nested(&sem->lock,
>> SINGLE_DEPTH_NESTING);
>> >                 }
>> >                 locknum = -1;
>> >         }
>
> Right, so as walken said, this isn't going to work right.
>
> I need a little more information as I've not really paid much attention
> to this stuff. Firstly, is there a limit to sem_nsems or is this a
> random user specified number? Secondly do we care about lock order at
> all, or is array order the only order that counts?

sem_nsems is user provided as the array size in some semget system
call. It's the size of an ipc semaphore array.

complex semop operations take the array's lock plus every semaphore
locks; simple semop operations (operating on a single semaphore) only
take that one semaphore's lock.

AFAIK no operations take more than one semaphore lock except for the
case where they are all taken (in which case the array's lock is also
taken). Ideally it'd be best to have lockdep verify that this usage
pattern is respected, though.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
