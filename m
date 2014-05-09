Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbaEINrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:47:33 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:33711 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaEINrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:47:32 -0400
Date: Fri, 9 May 2014 06:47:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20140509134726.GR8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.02.1405081614100.4346@file01.intranet.prod.int.rdu2.redhat.com>
 <OF667059AA.7F151BCC-ONC2257CD3.0036CFEB-C2257CD3.003BBF01@il.ibm.com>
 <alpine.LRH.2.02.1405090755320.21432@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LRH.2.02.1405090755320.21432@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050913-1344-0000-0000-000001727965
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 08:20:25AM -0400, Mikulas Patocka wrote:
> 
> 
> On Fri, 9 May 2014, Victor Kaplansky wrote:
> 
> > Mikulas Patocka <mpatocka@redhat.com> wrote on 05/08/2014 11:46:53 PM:
> > 
> > > > > BTW, it is why you also don't need ACCESS_ONCE() around @tail, but only
> > > > > around
> > > > > @head read.
> > > >
> > > > Agreed, the ACCESS_ONCE() around tail is superfluous since we're the one
> > > > updating tail, so there's no problem with the value changing
> > > > unexpectedly.
> > >
> > > You need ACCESS_ONCE even if you are the only process writing the value.
> > > Because without ACCESS_ONCE, the compiler may perform store tearing and
> > > split the store into several smaller stores. Search the file
> > > "Documentation/memory-barriers.txt" for the term "store tearing", it shows
> > > an example where one instruction storing 32-bit value may be split to two
> > > instructions, each storing 16-bit value.
> > >
> > > Mikulas
> > 
> > AFAIR, I was talking about redundant ACCESS_ONCE() around @tail *read* in
> > consumer code. As for ACCESS_ONCE() around @tail write in consumer code,
> > I see your point, but I don't think that volatile imposed by ACCESS_ONCE()
> > is appropriate, since:
> > 
> >     - compiler can generate several stores despite volatile if @tail
> >     is bigger in size than native machine data size, e.g. 64-bit on
> >     a 32-bit CPU.
> 
> That's true - so you should define data_head and data_tail as "unsigned 
> long", not "__u64".
> 
> >     - volatile imposed by ACCESS_ONCE() does nothing to prevent CPU from
> >     reordering, splitting or merging accesses. It can only mediate
> >     communication problems between processes running on same CPU.
> 
> That's why you need smp barrier in addition to ACCESS_ONCE. You need both 
> - the smp barrier (to prevent the CPU from reordering) and ACCESS_ONCE (to 
> prevent the compiler from splitting the write to smaller memory accesses).

IIRC the ring-buffer code uses the fact that one element remains
empty to make clever double use of a memory barrier.

> Since Linux 3.14, there are new macros smp_store_release and 
> smp_load_acquire that combine ACCESS_ONCE and memory barrier, so you can 
> use them. (they call compiletime_assert_atomic_type to make sure that you 
> don't use them on types that are not atomic, such as long long on 32-bit 
> architectures)

These are indeed useful and often simpler to use than raw barriers.

							Thanx, Paul

> > What you really want is to guarantee *atomicity* of @tail write on consumer
> > side.
> > 
> > -- Victor
> 
> Mikulas

