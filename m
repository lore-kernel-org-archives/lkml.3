Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3CVXis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 19:38:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab3CVXir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 19:38:47 -0400
Message-ID: <514CEB6A.8020300@redhat.com>
Date: Fri, 22 Mar 2013 19:38:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com
Subject: Re: [PATCH 7/7] ipc,sem: fine grained locking for semtimedop
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <1363809337-29718-8-git-send-email-riel@surriel.com> <CANN689FT6LGtFykOScV29MzZp2qeooaXZSeFp6_HhEF20g7ZMg@mail.gmail.com>
In-Reply-To: <CANN689FT6LGtFykOScV29MzZp2qeooaXZSeFp6_HhEF20g7ZMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 07:01 PM, Michel Lespinasse wrote:
> Sorry for the late reply; I've been swamped and am behind on my upstream mail.
>
> On Wed, Mar 20, 2013 at 12:55 PM, Rik van Riel <riel@surriel.com> wrote:
>> +static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
>> +                             int nsops)
>> +{
>> +       int locknum;
>> +       if (nsops == 1 && !sma->complex_count) {
>> +               struct sem *sem = sma->sem_base + sops->sem_num;
>> +
>> +               /* Lock just the semaphore we are interested in. */
>> +               spin_lock(&sem->lock);
>> +
>> +               /*
>> +                * If sma->complex_count was set while we were spinning,
>> +                * we may need to look at things we did not lock here.
>> +                */
>> +               if (unlikely(sma->complex_count)) {
>> +                       spin_unlock(&sma->sem_perm.lock);
>
> I believe this should be spin_unlock(&sem->lock) instead ?

You are right. Good catch.

I'll send a one-liner fix for this to Andrew Morton,
since he already applied the patches in -mm.

>> +                       goto lock_all;
>> +               }
>> +               locknum = sops->sem_num;
>> +       } else {
>> +               int i;
>> +               /* Lock the sem_array, and all the semaphore locks */
>> + lock_all:
>> +               spin_lock(&sma->sem_perm.lock);
>> +               for (i = 0; i < sma->sem_nsems; i++) {
>
> Do we have to lock every sem from the array instead of just the ones
> that are being operated on in sops ?
> (I'm not sure either way, as I don't fully understand the queueing of
> complex ops)

We should be able to get away with locking just the ones that are
being operated on.  However, that does require we remember which
ones we locked, so we know which ones to unlock again.

I do not know whether that additional complexity is worthwhile,
especially considering that in Davidlohr's profile, the major
caller locking everybody appears to be semctl, which passes no
semops into the kernel but simply operates on all semaphores
at once (SET_ALL).

> If we want to keep the loop as is, then we may at least remove the
> sops argument to sem_lock() since we only care about nsops.

We need to know exactly which semaphore to lock when we
are locking only one. The sops argument is used to figure
out which one.

-- 
All rights reversed
