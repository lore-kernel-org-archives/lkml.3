Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaLSLfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:35:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:43358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaLSLfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:35:21 -0500
Date: Fri, 19 Dec 2014 12:35:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141219113501.GK30905@twins.programming.kicks-ass.net>
References: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
 <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
 <20141218051327.GA31988@redhat.com>
 <1418918059.17358.6@mail.thefacebook.com>
 <20141218161230.GA6042@redhat.com>
 <20141219024549.GB1671@redhat.com>
 <CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
 <20141219035859.GA20022@redhat.com>
 <20141219040308.GB20022@redhat.com>
 <CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 08:48:24PM -0800, Linus Torvalds wrote:
> On Thu, Dec 18, 2014 at 8:03 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > So the only thing that was on that could cause spinlock overhead
> > was DEBUG_SPINLOCK (and LOCK_STAT, though iirc that's not huge either)
> 
> So DEBUG_SPINLOCK does have one big downside if I recall correctly -
> the debugging spinlocks are very much not fair. So they don't work
> like the real ticket spinlocks. That might have serious effects on the
> contention case, with some thread not making any progress due to just
> the implementation of the debug spinlocks.
> 
> Peter, Ingo, maybe I'm full of crap on the debug spinlock thing., but
> a quick look tells me thay are all built on top of the "trylock"
> primitive that does indeed not queue anything, and is thus not fair.
> 
> I'm not sure why the debug spinlocks couldn't just be ticket locks
> instead. But there you are - once more, the debug infrastructure is
> actually much weaker and inferior to the "real" code.

Yeah, the DEBUG_SPINLOCK stuff is horrible. The trylock loops were
designed to 'detect' actual lockups, but this was all done before
lockdep.

I think one can make an argument to remove the trylock loops and fully
rely on lockdep to detect such issues. Only keeping the integrity
checks; similar to the mutex debugging stuff.

There's a related issue with the trylock loops in that it relies on
delay(1) and DVFS heavy (or virt) platforms often have 'dubious' quality
delay loops.
