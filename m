Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaEIMUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:20:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbaEIMUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:20:52 -0400
Date: Fri, 9 May 2014 08:20:25 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Victor Kaplansky <VICTORK@il.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: perf events ring buffer memory barrier on powerpc
In-Reply-To: <OF667059AA.7F151BCC-ONC2257CD3.0036CFEB-C2257CD3.003BBF01@il.ibm.com>
Message-ID: <alpine.LRH.2.02.1405090755320.21432@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405081614100.4346@file01.intranet.prod.int.rdu2.redhat.com> <OF667059AA.7F151BCC-ONC2257CD3.0036CFEB-C2257CD3.003BBF01@il.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185206533-810175369-1399638026=:21432"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-810175369-1399638026=:21432
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT



On Fri, 9 May 2014, Victor Kaplansky wrote:

> Mikulas Patocka <mpatocka@redhat.com> wrote on 05/08/2014 11:46:53 PM:
> 
> > > > BTW, it is why you also don't need ACCESS_ONCE() around @tail, but only
> > > > around
> > > > @head read.
> > >
> > > Agreed, the ACCESS_ONCE() around tail is superfluous since we're the one
> > > updating tail, so there's no problem with the value changing
> > > unexpectedly.
> >
> > You need ACCESS_ONCE even if you are the only process writing the value.
> > Because without ACCESS_ONCE, the compiler may perform store tearing and
> > split the store into several smaller stores. Search the file
> > "Documentation/memory-barriers.txt" for the term "store tearing", it shows
> > an example where one instruction storing 32-bit value may be split to two
> > instructions, each storing 16-bit value.
> >
> > Mikulas
> 
> AFAIR, I was talking about redundant ACCESS_ONCE() around @tail *read* in
> consumer code. As for ACCESS_ONCE() around @tail write in consumer code,
> I see your point, but I don't think that volatile imposed by ACCESS_ONCE()
> is appropriate, since:
> 
>     - compiler can generate several stores despite volatile if @tail
>     is bigger in size than native machine data size, e.g. 64-bit on
>     a 32-bit CPU.

That's true - so you should define data_head and data_tail as "unsigned 
long", not "__u64".

>     - volatile imposed by ACCESS_ONCE() does nothing to prevent CPU from
>     reordering, splitting or merging accesses. It can only mediate
>     communication problems between processes running on same CPU.

That's why you need smp barrier in addition to ACCESS_ONCE. You need both 
- the smp barrier (to prevent the CPU from reordering) and ACCESS_ONCE (to 
prevent the compiler from splitting the write to smaller memory accesses).


Since Linux 3.14, there are new macros smp_store_release and 
smp_load_acquire that combine ACCESS_ONCE and memory barrier, so you can 
use them. (they call compiletime_assert_atomic_type to make sure that you 
don't use them on types that are not atomic, such as long long on 32-bit 
architectures)

> What you really want is to guarantee *atomicity* of @tail write on consumer
> side.
> 
> -- Victor

Mikulas
--185206533-810175369-1399638026=:21432--
