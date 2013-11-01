Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3KANNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:13:12 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:44505 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab3KANNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:13:10 -0400
In-Reply-To: <20131031061602.GU4126@linux.vnet.ibm.com>
References: <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131030092725.GL4126@linux.vnet.ibm.com> <20131030112526.GI16117@laptop.programming.kicks-ass.net> <OFF6C78E48.E477DB1E-ON42257C14.0050F9B3-42257C14.0051AC6D@il.ibm.com> <20131031061602.GU4126@linux.vnet.ibm.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
X-KeepSent: 6655E55D:554B7448-42257C16:00442B8B;
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
Message-ID: <OF6655E55D.554B7448-ON42257C16.00442B8B-42257C16.0048995E@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Fri, 1 Nov 2013 15:12:58 +0200
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 01/11/2013 15:12:51
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110113-0542-0000-0000-000006EDF973
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote on 10/31/2013
08:16:02 AM:

> > BTW, it is why you also don't need ACCESS_ONCE() around @tail, but only
> > around
> > @head read.

Just to be sure, that we are talking about the same code - I was
considering
ACCESS_ONCE() around @tail in point AAA in the following example from
Documentation/circular-buffers.txt for CONSUMER:

        unsigned long head = ACCESS_ONCE(buffer->head);
        unsigned long tail = buffer->tail;      /* AAA */

        if (CIRC_CNT(head, tail, buffer->size) >= 1) {
                /* read index before reading contents at that index */
                smp_read_barrier_depends();

                /* extract one item from the buffer */
                struct item *item = buffer[tail];

                consume_item(item);

                smp_mb(); /* finish reading descriptor before incrementing
tail */

                buffer->tail = (tail + 1) & (buffer->size - 1); /* BBB */
        }

>
> If you omit the ACCESS_ONCE() calls around @tail, the compiler is within
> its rights to combine adjacent operations and also to invent loads and
> stores, for example, in cases of register pressure.

Right. And I was completely aware about these possible transformations when
said that ACCESS_ONCE() around @tail in point AAA is redundant. Moved, or
even
completely dismissed reads of @tail in consumer code, are not a problem at
all,
since @tail is written exclusively by CONSUMER side.


> It is also within
> its rights to do piece-at-a-time loads and stores, which might sound
> unlikely, but which can actually has happened when the compiler figures
> out exactly what is to be stored at compile time, especially on hardware
> that only allows small immediate values.

As for writes to @tail, the ACCESS_ONCE around @tail at point AAA,
doesn't prevent in any way an imaginary super-optimizing compiler
from moving around the store to @tail (which appears in the code at point
BBB).

It is why ACCESS_ONCE at point AAA is completely redundant.

-- Victor

