Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab3JaEf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 00:35:56 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38508 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3JaEfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 00:35:55 -0400
Date: Wed, 30 Oct 2013 21:32:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131031043258.GQ4126@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131023141948.GB3566@localhost.localdomain>
 <20131025173749.GG19466@laptop.lan>
 <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103104-9332-0000-0000-000001FC82ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 03:28:54PM +0200, Victor Kaplansky wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote on 10/30/2013
> 11:27:25 AM:
> 
> > If you were to back up that insistence with a description of the
> orderings
> > you are relying on, why other orderings are not important, and how the
> > important orderings are enforced, I might be tempted to pay attention
> > to your opinion.
> >
> >                      Thanx, Paul
> 
> NP, though, I feel too embarrassed to explain things about memory barriers
> when
> one of the authors of Documentation/memory-barriers.txt is on cc: list ;-)
> 
> Disclaimer: it is anyway impossible to prove lack of *any* problem.

If you want to play the "omit memory barriers" game, then proving a
negative is in fact the task before you.

> Having said that, lets look into an example in
> Documentation/circular-buffers.txt:

And the correctness of this code has been called into question.  :-(
An embarrassingly long time ago -- I need to get this either proven
or fixed.

> > THE PRODUCER
> > ------------
> >
> > The producer will look something like this:
> >
> >       spin_lock(&producer_lock);
> >
> >       unsigned long head = buffer->head;
> >       unsigned long tail = ACCESS_ONCE(buffer->tail);
> >
> >       if (CIRC_SPACE(head, tail, buffer->size) >= 1) {
> >               /* insert one item into the buffer */
> >               struct item *item = buffer[head];
> >
> >               produce_item(item);
> >
> >               smp_wmb(); /* commit the item before incrementing the head
> */
> >
> >               buffer->head = (head + 1) & (buffer->size - 1);
> >
> >               /* wake_up() will make sure that the head is committed
> before
> >                * waking anyone up */
> >               wake_up(consumer);
> >       }
> >
> >       spin_unlock(&producer_lock);
> 
> We can see that authors of the document didn't put any memory barrier
> after "buffer->tail" read and before "produce_item(item)" and I think they
> have
> a good reason.
> 
> Lets consider an imaginary smp_mb() right before "produce_item(item);".
> Such a barrier will ensure that -
> 
>     - the memory read on "buffer->tail" is completed
> 	before store to memory pointed by "item" is committed.
> 
> However, the store to "buffer->tail" anyway cannot be completed before
> conditional
> branch implied by "if ()" is proven to execute body statement of the if().
> And the
> latter cannot be proven before read of "buffer->tail" is completed.
> 
> Lets see this other way. Lets imagine that somehow a store to the data
> pointed by "item"
> is completed before we read "buffer->tail". That would mean, that the store
> was completed
> speculatively. But speculative execution of conditional stores is
> prohibited by C/C++ standard,
> otherwise any conditional store at any random place of code could pollute
> shared memory.

Before C/C++11, the closest thing to such a prohibition is use of
volatile, for example, ACCESS_ONCE().  Even in C/C++11, you have to
use atomics to get anything resembing this prohibition.

If you just use normal variables, the compiler is within its rights
to transform something like the following:

	if (a)
		b = 1;
	else
		b = 42;

Into:

	b = 42;
	if (a)
		b = 1;

Many other similar transformations are permitted.  Some are used to all
vector instructions to be used -- the compiler can do a write with an
overly wide vector instruction, then clean up the clobbered variables
later, if it wishes.  Again, if the variables are not marked volatile,
or, in C/C++11, atomic.

> On the other hand, if compiler or processor can prove that condition in
> above if() is going
> to be true (or if speculative store writes the same value as it was before
> write), the
> speculative store *is* allowed. In this case we should not be bothered by
> the fact that
> memory pointed by "item" is written before a read from "buffer->tail" is
> completed.

The compilers don't always know as much as they might about the underlying
hardware's memory model.  Of course, if this code is architecture specific,
it can avoid DEC Alpha's fun and games, which could also violate your
assumptions in the above paragraph:

	http://www.openvms.compaq.com/wizard/wiz_2637.html

Anyway, proving or fixing the code in Documentation/circular-buffers.txt
has been on my list for too long, so I will take a closer look at it.

							Thanx, Paul

