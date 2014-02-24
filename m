Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaBXFAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:00:02 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49014 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaBXE77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 23:59:59 -0500
Date: Sun, 23 Feb 2014 20:59:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140224045951.GH8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1392922421.28840.36.camel@triegel.csb>
 <CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
 <1393095223.28840.4914.camel@triegel.csb>
 <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
 <20140223003933.GQ4250@linux.vnet.ibm.com>
 <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
 <20140223063426.GT4250@linux.vnet.ibm.com>
 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
 <20140224011651.GC8264@linux.vnet.ibm.com>
 <CA+55aFx06UTTeypXOGUiwwbzJyqpVNR90zBDLPmxFzBkz=VwgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx06UTTeypXOGUiwwbzJyqpVNR90zBDLPmxFzBkz=VwgQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022404-6688-0000-0000-000006EB2CBA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 05:35:28PM -0800, Linus Torvalds wrote:
> On Sun, Feb 23, 2014 at 5:16 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >>
> >>  (a) we've said 'q' is restricted, so there is no aliasing between q
> >> and the pointers b/c. So the compiler is free to move those accesses
> >> around the "q = p->next" access.
> >
> > Ah, if I understand you, very good!
> >
> > My example intentionally left "q" -not- restricted.
> 
> No, I 100% agree with that. "q" is *not* restricted. But "p" is, since
> it came from that consuming load.
> 
> But "q = p->next" is ordered by how something can alias "p->next", not by 'q'!
> 
> There is no need to restrict anything but 'p' for all of this to work.

I cannot say I understand this last sentence right new from the viewpoint
of the standard, but suspending disbelief for the moment...

(And yes, given current compilers and CPUs, I agree that this should
all work in practice.  My concern is the legality, not the reality.)

> Btw, it's also worth pointing out that I do *not* in any way expect
> people to actually write the "restrict" keyword anywhere. So no need
> to change source code.

Understood -- in this variant, you are taking the marking from the
fact that there was an assignment from a memory_order_consume load
rather than from a keyword on the assigned-to variable's declaration.

> What you have is a situation where the pointer coming out of the
> memory_order_consume is restricted. But if you assign it to a
> non-restricted pointer, that's *fine*. That's perfectly normal C
> behavior. The "restrict" concept is not something that the programmer
> needs to worry about or ever even notice, it's basically just a
> promise to the compiler that "if somebody has another pointer lying
> around, accesses though that other pointer do not require ordering".
> 
> So it sounds like you believe that the programmer would mark things
> "restrict", and I did not mean that at all.

Indeed I did believe that.

I must confess that I was looking for an easy way to express in
standardese -exactly- where the ordering guarantee did and did
not propagate.

The thing is that the vast majority of the Linux-kernel RCU code is more
than happy with the guarantee only applying to fetches via the pointer
returned from the memory_order_consume load.  There are relatively few
places where groups of structures are made visible to RCU readers via
a single rcu_assign_pointer().  I guess I need to actually count them.

							Thanx, Paul

