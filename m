Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaFBODn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:03:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbaFBODl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:03:41 -0400
Date: Mon, 2 Jun 2014 10:02:49 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: John David Anglin <dave.anglin@bell.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, chegu_vinod@hp.com,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH] fix a race condition in cancelable mcs spinlocks
In-Reply-To: <alpine.LRH.2.02.1406020914440.18342@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1406021002090.1300@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com> <20140601192026.GE16155@laptop.programming.kicks-ass.net> <BLU0-SMTP387BD0AE22A4EAD432D65F97210@phx.gbl>
 <alpine.LRH.2.02.1406020914440.18342@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Jun 2014, Mikulas Patocka wrote:

> 
> 
> On Sun, 1 Jun 2014, John David Anglin wrote:
> 
> > On 1-Jun-14, at 3:20 PM, Peter Zijlstra wrote:
> > 
> > > > If you write to some variable with ACCESS_ONCE and use cmpxchg or xchg at
> > > > the same time, you break it. ACCESS_ONCE doesn't take the hashed spinlock,
> > > > so, in this case, cmpxchg or xchg isn't really atomic at all.
> > > 
> > > And this is really the first place in the kernel that breaks like this?
> > > I've been using xchg() and cmpxchg() without such consideration for
> > > quite a while.
> > 
> > I believe Mikulas is correct.  Even in a controlled situation where a 
> > cmpxchg operation is used to implement pthread_spin_lock() in userspace, 
> > we found recently that the lock must be released with a cmpxchg 
> > operation and not a simple write on SMP systems. There is a race in the 
> > cache operations or instruction ordering that's not present with the 
> > ldcw instruction.
> > 
> > Dave
> > --
> > John David Anglin	dave.anglin@bell.net
> 
> That is strange.
> 
> Spinlock with cmpxchg on lock and a single write on unlock should work,
> assuming that cmpxchg doesn't write to the target address when it detects
> mismatch (the cmpxchg in the kernel syscall page doesn't do it, it
> nullifies the write instruction on mismatch).
> 
> Do you have some code that reproduces this misbehavior?
> 
> We really need to find out why does it behave this way:
> - is PA-RISC really out of order? (we used to believe that it is in-order
>   and we have empty barrier instructions in the kernel). Does adding the
>   "SYNC" instruction before the write in pthread_spin_unlock fix it?
> - does the processor performs nullified writes unconditionally? Does
>   moving the write in the cmpxchg implementation from the nullified slot
>   to is own branch fix it?
> - does adding a dummy "ldcw" instruction to an unrelated address fix it?
>   Is it that "ldcw" has some magic barrier properties?

- and there is "stw,o" instruction that does ordered store according to 
the specification, so we should test it too...

> I think we need to perform these tests and maybe some more to find out
> what really happened there...
> 
> BTW. in Debian 5 libc 2.7, pthread_spin_lock uses ldcw and 
> pthread_spin_unlock uses a single write (just like the kernel spinlock 
> implementation). In Debian-ports libc 2.18, both pthread_spin_lock and 
> pthread_spin_unlock call the kernel syscall page. What was the reason for 
> switching to a less efficient implementation?
> 
> Mikulas
> 
