Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945947AbaD3Qdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:33:38 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:61735 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422657AbaD3Qdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:33:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140430090420.GB11096@twins.programming.kicks-ass.net>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	<1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
	<20140430090420.GB11096@twins.programming.kicks-ass.net>
Date: Wed, 30 Apr 2014 09:33:34 -0700
X-Google-Sender-Auth: RY8iJzYcflSr5nW_ao-SQuEO0jk
Message-ID: <CAGQ1y=4oyErcwikuyDVZchigWKw0mg_vZGA5XmmG_JghmoPC+Q@mail.gmail.com>
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 2:04 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Apr 28, 2014 at 03:09:01PM -0700, Davidlohr Bueso wrote:
>> +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
>> +{
>> +     int retval;
>
> And yet the return value is bool.
>
>> +     struct task_struct *owner;
>> +
>> +     rcu_read_lock();
>> +     owner = ACCESS_ONCE(sem->owner);
>> +
>> +     /* Spin only if active writer running */
>> +     if (owner)
>> +             retval = owner->on_cpu;
>> +     else {
>> +             /*
>> +              * When the owner is not set, the sem owner may have just
>> +              * acquired it and not set the owner yet, or the sem has
>> +              * been released, or reader active.
>> +              */
>> +             retval = false;
>> +     }
>
> And if you init the retval to false, you can leave this entire branch
> out.
>
>> +     rcu_read_unlock();
>> +
>> +     return retval;
>> +}
>
>
> Which yields the much shorter:
>
> static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> {
>         struct task_struct *owner;
>         bool on_cpu = false;

Wouldn't we want to initialize on_cpu = true. For the !owner case, I
would expect that we want to spin for the lock.

>         rcu_read_lock();
>         owner = ACCESS_ONCE(sem->owner);
>         if (owner)
>                 on_cpu = owner->on_cpu;
>         rcu_read_unlock();
>
>         return on_cpu;
> }
