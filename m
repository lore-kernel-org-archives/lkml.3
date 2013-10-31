Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3JaJ7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 05:59:38 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:36194 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3JaJ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:59:36 -0400
In-Reply-To: <20131031043258.GQ4126@linux.vnet.ibm.com>
References: <20131023141948.GB3566@localhost.localdomain> <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131030092725.GL4126@linux.vnet.ibm.com> <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com> <20131031043258.GQ4126@linux.vnet.ibm.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
X-KeepSent: DF23985D:1D949148-42257C15:002DEB25;
 type=4; name=$KeepSent
To: paulmck@linux.vnet.ibm.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFDF23985D.1D949148-ON42257C15.002DEB25-42257C15.0036DF93@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Thu, 31 Oct 2013 11:59:21 +0200
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 31/10/2013 11:59:14
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103109-4966-0000-0000-0000075BB8B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote on 10/31/2013
06:32:58 AM:

> If you want to play the "omit memory barriers" game, then proving a
> negative is in fact the task before you.

Generally it is not fair. Otherwise, anyone could put an smp_mb() at a
random place, and expect others to "prove" that it is not needed.

It is not fair also because it should be virtually impossible to prove lack
of any problem. OTH, if a problem exists, it should be easy for proponents
of a memory barrier to build a test case or design a scenario demonstrating
the problem.

Actually, advocates of the memory barrier in our case do have an argument -
- the rule of thumb saying that barriers should be paired. I consider this
rule only as a general recommendation to look into potentially risky
places.
And indeed, in our case if the store to circular wasn't conditional, it
would require a memory barrier to prevent the store to be performed before
the read of @tail. But in our case the store is conditional, so no memory
barrier is required.

> And the correctness of this code has been called into question.  :-(
> An embarrassingly long time ago -- I need to get this either proven
> or fixed.

I agree.

> Before C/C++11, the closest thing to such a prohibition is use of
> volatile, for example, ACCESS_ONCE().  Even in C/C++11, you have to
> use atomics to get anything resembing this prohibition.
>
> If you just use normal variables, the compiler is within its rights
> to transform something like the following:
>
>    if (a)
>       b = 1;
>    else
>       b = 42;
>
> Into:
>
>    b = 42;
>    if (a)
>       b = 1;
>
> Many other similar transformations are permitted.  Some are used to all
> vector instructions to be used -- the compiler can do a write with an
> overly wide vector instruction, then clean up the clobbered variables
> later, if it wishes.  Again, if the variables are not marked volatile,
> or, in C/C++11, atomic.

All this can justify only compiler barrier() which is almost free from
performance point of view, since current gcc anyway doesn't perform store
hoisting optimization in our case.

(And I'm not getting into philosophical discussion whether kernel code
should consider future possible bugs/features in gcc or C/C++11
standard).


> The compilers don't always know as much as they might about the
underlying
> hardware's memory model.

That's correct in general. But can you point out a problem that really
exists?

> Of course, if this code is architecture specific,
> it can avoid DEC Alpha's fun and games, which could also violate your
> assumptions in the above paragraph:
>
>    http://www.openvms.compaq.com/wizard/wiz_2637.html

Are you talking about this paragraph from above link:

"For instance, your producer must issue a "memory barrier" instruction
  after writing the data to shared memory and before inserting it on
  the queue; likewise, your consumer must issue a memory barrier
  instruction after removing an item from the queue and before reading
  from its memory.  Otherwise, you risk seeing stale data, since, while
  the Alpha processor does provide coherent memory, it does not provide
  implicit ordering of reads and writes.  (That is, the write of the
  producer's data might reach memory after the write of the queue, such
  that the consumer might read the new item from the queue but get the
  previous values from the item's memory."

If yes, I don't think it explains the need of memory barrier on Alpha
in our case (we all agree about the need of smp_wmb() right before @head
update by producer). If not, could you please point to specific paragraph?

>
> Anyway, proving or fixing the code in Documentation/circular-buffers.txt
> has been on my list for too long, so I will take a closer look at it.

Thanks!

I'm concerned more about performance overhead imposed by the full memory
barrier in kfifo circular buffers. Even if it is needed on Alpha (I don't
understand why) we could try to solve this with some memory barrier which
is effective only on architectures which really need it.

Regards,
-- Victor

