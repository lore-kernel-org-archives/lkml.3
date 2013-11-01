Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3KAQHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:07:13 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:53669 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3KAQHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:07:11 -0400
In-Reply-To: <20131031152543.GC4067@linux.vnet.ibm.com>
References: <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131030092725.GL4126@linux.vnet.ibm.com> <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com> <20131031043258.GQ4126@linux.vnet.ibm.com> <OFDF23985D.1D949148-ON42257C15.002DEB25-42257C15.0036DF93@il.ibm.com> <20131031152543.GC4067@linux.vnet.ibm.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
X-KeepSent: 3CB471BA:BACC7843-42257C16:0055EF23;
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
Message-ID: <OF3CB471BA.BACC7843-ON42257C16.0055EF23-42257C16.0058875B@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Fri, 1 Nov 2013 18:06:58 +0200
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 01/11/2013 18:06:50
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110116-1948-0000-0000-000006C48715
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote on 10/31/2013
05:25:43 PM:

> I really don't care about "fair" -- I care instead about the kernel
> working reliably.

Though I don't see how putting a memory barrier without deep understanding
why it is needed helps kernel reliability, I do agree that reliability
is more important than performance.

> And it should also be easy for proponents of removing memory barriers to
> clearly articulate what orderings their code does and does not need.

I intentionally took a simplified example of circle buffer from
Documentation/circular-buffers.txt. I think both sides agree about
memory ordering requirements in the example. At least I didn't see anyone
argued about them.

> You are assuming control dependencies that the C language does not
> provide.  Now, for all I know right now, there might well be some other
> reason why a full barrier is not required, but the "if" statement cannot
> be that reason.
>
> Please review section 1.10 of the C++11 standard (or the corresponding
> section of the C11 standard, if you prefer).  The point is that the
> C/C++11 covers only data dependencies, not control dependencies.

I feel you made a wrong assumption about my expertise in compilers. I don't
need to reread section 1.10 of the C++11 standard, because I do agree that
potentially compiler can break the code in our case. And I do agree that
a compiler barrier() or some other means (including a change of the
standard)
can be required in future to prevent a compiler from moving memory accesses
around.

But "broken" compiler is much wider issue to be deeply discussed in this
thread. I'm pretty sure that kernel have tons of very subtle
code that actually creates locks and memory ordering. Such code
usually just use the "barrier()"  approach to tell gcc not to combine
or move memory accesses around it.

Let's just agree for the sake of this memory barrier discussion that we
*do* need compiler barrier to tell gcc not to combine or move memory
accesses around it.

> Glad we agree on something!

I'm glad too!

> Did you miss the following passage in the paragraph you quoted?
>
>    "... likewise, your consumer must issue a memory barrier
>    instruction after removing an item from the queue and before
>    reading from its memory."
>
> That is why DEC Alpha readers need a read-side memory barrier -- it says
> so right there.  And as either you or Peter noted earlier in this thread,
> this barrier can be supplied by smp_read_barrier_depends().

I did not miss that passage. That passage explains why consumer on Alpha
processor after reading @head is required to execute an additional
smp_read_barrier_depends() before it can *read* from memory pointed by
@tail. And I think that I understand why - because the reader have to wait
till local caches are fully updated and only then it can read data from
the data buffer.

But on the producer side, after we read @tail, we don't need to wait for
update of local caches before we start *write* data to the buffer, since
the
producer is the only one who write data there!

>
> I can sympathize if you are having trouble believing this.  After all,
> it took the DEC Alpha architects a full hour to convince me, and that was
> in a face-to-face meeting instead of over email.  (Just for the record,
> it took me even longer to convince them that their earlier documentation
> did not clearly indicate the need for these read-side barriers.)  But
> regardless of whether or not I sympathize, DEC Alpha is what it is.

Again, I do understand quirkiness of the DEC Alpha, and I still think that
there is no need in *full* memory barrier on producer side - the one
before writing data to the buffer and which you've put in kfifo
implementation.

Regard,
-- Victor

