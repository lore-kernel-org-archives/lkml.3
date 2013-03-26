Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781Ab3CZO0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:26:08 -0400
Received: from shelob.surriel.com ([74.92.59.67]:41116 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3CZO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:26:07 -0400
Message-ID: <5151AFEC.1050304@surriel.com>
Date: Tue, 26 Mar 2013 10:25:48 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Michel Lespinasse <walken@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH -mm -next] ipc,sem: fix lockdep false positive
References: <1363809337-29718-1-git-send-email-riel@surriel.com>  <5150B1C2.8090607@oracle.com>  <20130325163844.042a45ba@annuminas.surriel.com>  <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com> <1364303965.5053.29.camel@laptop>
In-Reply-To: <1364303965.5053.29.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 09:19 AM, Peter Zijlstra wrote:
> On Mon, 2013-03-25 at 14:42 -0700, Michel Lespinasse wrote:
>> depth nesting here...
>> Adding Peter & Ingo for advice about how to proceed
>
>>> +++ b/ipc/sem.c
>>> @@ -357,7 +357,7 @@ static inline int sem_lock(struct sem_array
>> *sma, struct sembuf *sops,
>>>                  spin_lock(&sma->sem_perm.lock);
>>>                  for (i = 0; i < sma->sem_nsems; i++) {
>>>                          struct sem *sem = sma->sem_base + i;
>>> -                       spin_lock(&sem->lock);
>>> +                       spin_lock_nested(&sem->lock,
>> SINGLE_DEPTH_NESTING);
>>>                  }
>>>                  locknum = -1;
>>>          }
>
> Right, so as walken said, this isn't going to work right.
>
> I need a little more information as I've not really paid much attention
> to this stuff. Firstly, is there a limit to sem_nsems or is this a
> random user specified number? Secondly do we care about lock order at
> all, or is array order the only order that counts?

It is a user specified number, and we either lock only one
of the semaphore locks, or we lock all of them (in array
order, after taking the semaphore array lock).

-- 
All rights reversed.
