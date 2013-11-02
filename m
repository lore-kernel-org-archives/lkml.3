Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3KCEFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 00:05:25 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48791 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3KCEEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 00:04:38 -0400
Date: Sat, 2 Nov 2013 08:46:48 -0700
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
Message-ID: <20131102154647.GJ4067@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com>
 <20131031043258.GQ4126@linux.vnet.ibm.com>
 <OFDF23985D.1D949148-ON42257C15.002DEB25-42257C15.0036DF93@il.ibm.com>
 <20131031152543.GC4067@linux.vnet.ibm.com>
 <OF3CB471BA.BACC7843-ON42257C16.0055EF23-42257C16.0058875B@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF3CB471BA.BACC7843-ON42257C16.0055EF23-42257C16.0058875B@il.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110304-9332-0000-0000-00000204BA5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 06:06:58PM +0200, Victor Kaplansky wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote on 10/31/2013
> 05:25:43 PM:
> 
> > I really don't care about "fair" -- I care instead about the kernel
> > working reliably.
> 
> Though I don't see how putting a memory barrier without deep understanding
> why it is needed helps kernel reliability, I do agree that reliability
> is more important than performance.

True enough.  Of course, the same applies to removing memory barriers.

> > And it should also be easy for proponents of removing memory barriers to
> > clearly articulate what orderings their code does and does not need.
> 
> I intentionally took a simplified example of circle buffer from
> Documentation/circular-buffers.txt. I think both sides agree about
> memory ordering requirements in the example. At least I didn't see anyone
> argued about them.

Hard to say.  No one has actually stated them clearly, so how could we
know whether or not we agree.

> > You are assuming control dependencies that the C language does not
> > provide.  Now, for all I know right now, there might well be some other
> > reason why a full barrier is not required, but the "if" statement cannot
> > be that reason.
> >
> > Please review section 1.10 of the C++11 standard (or the corresponding
> > section of the C11 standard, if you prefer).  The point is that the
> > C/C++11 covers only data dependencies, not control dependencies.
> 
> I feel you made a wrong assumption about my expertise in compilers. I don't
> need to reread section 1.10 of the C++11 standard, because I do agree that
> potentially compiler can break the code in our case. And I do agree that
> a compiler barrier() or some other means (including a change of the
> standard)
> can be required in future to prevent a compiler from moving memory accesses
> around.

I was simply reacting to what seemed to me to be your statement that
control dependencies affect ordering.  They don't.  The C/C++ standard
does not in any way respect control dependencies.  In fact, there are
implementations that do not respect control dependencies.  But don't
take my word for it, actually try it out on a weakly ordered system.
Or try out either ppcmem or armmem, which does a full state-space search.

Here is the paper:

	http://www.cl.cam.ac.uk/~pes20/ppc-supplemental/pldi105-sarkar.pdf

And here is the web-based tool:

	http://www.cl.cam.ac.uk/~pes20/ppcmem/

And here is a much faster version that you can run locally:

	http://www.cl.cam.ac.uk/~pes20/weakmemory/index.html

> But "broken" compiler is much wider issue to be deeply discussed in this
> thread. I'm pretty sure that kernel have tons of very subtle
> code that actually creates locks and memory ordering. Such code
> usually just use the "barrier()"  approach to tell gcc not to combine
> or move memory accesses around it.
> 
> Let's just agree for the sake of this memory barrier discussion that we
> *do* need compiler barrier to tell gcc not to combine or move memory
> accesses around it.

Sometimes barrier() is indeed all you need, other times more is needed.

> > Glad we agree on something!
> 
> I'm glad too!
> 
> > Did you miss the following passage in the paragraph you quoted?
> >
> >    "... likewise, your consumer must issue a memory barrier
> >    instruction after removing an item from the queue and before
> >    reading from its memory."
> >
> > That is why DEC Alpha readers need a read-side memory barrier -- it says
> > so right there.  And as either you or Peter noted earlier in this thread,
> > this barrier can be supplied by smp_read_barrier_depends().
> 
> I did not miss that passage. That passage explains why consumer on Alpha
> processor after reading @head is required to execute an additional
> smp_read_barrier_depends() before it can *read* from memory pointed by
> @tail. And I think that I understand why - because the reader have to wait
> till local caches are fully updated and only then it can read data from
> the data buffer.
> 
> But on the producer side, after we read @tail, we don't need to wait for
> update of local caches before we start *write* data to the buffer, since
> the
> producer is the only one who write data there!

Well, we cannot allow the producer to clobber data while the consumer
is reading it out.  That said, I do agree that we should get some help
from the fact that one element of the array is left empty, so that the
producer goes through a full write before clobbering the cell that the
consumer just vacated.

> > I can sympathize if you are having trouble believing this.  After all,
> > it took the DEC Alpha architects a full hour to convince me, and that was
> > in a face-to-face meeting instead of over email.  (Just for the record,
> > it took me even longer to convince them that their earlier documentation
> > did not clearly indicate the need for these read-side barriers.)  But
> > regardless of whether or not I sympathize, DEC Alpha is what it is.
> 
> Again, I do understand quirkiness of the DEC Alpha, and I still think that
> there is no need in *full* memory barrier on producer side - the one
> before writing data to the buffer and which you've put in kfifo
> implementation.

There really does need to be some sort of memory barrier there to
order the read of the index before the write into the array element.
Now, it might well be that this barrier is supplied by the unlock-lock
pair guarding the producer, but either way, there does need to be some
ordering.

							Thanx, Paul

