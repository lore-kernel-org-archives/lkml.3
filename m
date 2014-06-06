Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaFFDKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 23:10:04 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:64511 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaFFDKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 23:10:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140605072248.GE3213@twins.programming.kicks-ass.net>
References: <538F83DF.8090303@gatech.edu> <CAJUuVQ4VioKuVuCTXr3BcfRpYs+9+5bx9m2WLO7Swsnni0tUAw@mail.gmail.com>
 <20140605072248.GE3213@twins.programming.kicks-ass.net>
From: Pranith Kumar <pranith@gatech.edu>
Date: Thu, 5 Jun 2014 23:09:29 -0400
X-Google-Sender-Auth: PoTxoLYT-F9CmMKmXIz8w3JEkpg
Message-ID: <CAJhHMCAw5iPeHKAVFVYFpFTeLsb=fz9cp2WGwAYU7QGRRgKXGg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] remove redundant compare, cmpxchg already does it
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andev <debiandev@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        davidlohr@hp.com, jason.low2@hp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 3:22 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jun 04, 2014 at 04:56:50PM -0400, Andev wrote:
>> On Wed, Jun 4, 2014 at 4:38 PM, Pranith Kumar <pranith@gatech.edu> wrote:
>> > remove a redundant comparision
>> >
>> > Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> > ---
>> >  kernel/locking/rwsem-xadd.c | 3 +--
>> >  1 file changed, 1 insertion(+), 2 deletions(-)
>> >
>> > diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
>> > index 1f99664b..6f8bd3c 100644
>> > --- a/kernel/locking/rwsem-xadd.c
>> > +++ b/kernel/locking/rwsem-xadd.c
>> > @@ -249,8 +249,7 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
>> >  {
>> >      if (!(count & RWSEM_ACTIVE_MASK)) {
>> >          /* try acquiring the write lock */
>> > -        if (sem->count == RWSEM_WAITING_BIAS &&
>> > -            cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
>> > +        if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
>> >                  RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
>>
>> This was mainly done to avoid the cost of a cmpxchg in case where they
>> are not equal. Not sure if it really makes a difference though.
>
> It does, a cache hot cmpxchg instruction is 24 cycles (as is pretty much
> any other LOCKed ins, as measured on my WSM-EP), not to mention that
> cmpxchg is a RMW so it needs to grab the cacheline in exclusive mode.
>
> A read, which allows the cacheline to remain in shared, and non LOCKed
> ops are way faster.


Ok, this means that we need to use more of such swaps on highly
contended paths. As Davidlohr suggested later on, I think it would be
a good idea to document this and add an API.

-- 
Pranith
