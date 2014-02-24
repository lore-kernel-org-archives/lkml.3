Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaBXWhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:37:09 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60813 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaBXWhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:37:07 -0500
Date: Mon, 24 Feb 2014 14:37:02 -0800
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
Message-ID: <20140224223701.GC8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
 <20140223003933.GQ4250@linux.vnet.ibm.com>
 <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
 <20140223063426.GT4250@linux.vnet.ibm.com>
 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
 <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
 <20140224172110.GO8264@linux.vnet.ibm.com>
 <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
 <20140224185341.GU8264@linux.vnet.ibm.com>
 <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022422-0928-0000-0000-000006C658FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 11:54:46AM -0800, Linus Torvalds wrote:
> On Mon, Feb 24, 2014 at 10:53 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Good points.  How about the following replacements?
> >
> > 3.      Adding or subtracting an integer to/from a chained pointer
> >         results in another chained pointer in that same pointer chain.
> >         The results of addition and subtraction operations that cancel
> >         the chained pointer's value (for example, "p-(long)p" where "p"
> >         is a pointer to char) are implementation defined.
> >
> > 4.      Bitwise operators ("&", "|", "^", and I suppose also "~")
> >         applied to a chained pointer and an integer for the purposes
> >         of alignment and pointer translation results in another
> >         chained pointer in that same pointer chain.  Other uses
> >         of bitwise operators on chained pointers (for example,
> >         "p|~0") are implementation defined.
> 
> Quite frankly, I think all of this language that is about the actual
> operations is irrelevant and wrong.
> 
> It's not going to help compiler writers, and it sure isn't going to
> help users that read this.
> 
> Why not just talk about "value chains" and that any operations that
> restrict the value range severely end up breaking the chain. There is
> no point in listing the operations individually, because every single
> operation *can* restrict things. Listing individual operations and
> depdendencies is just fundamentally wrong.
> 
> For example, let's look at this obvious case:
> 
>    int q,*p = atomic_read(&pp, consume);
>    .. nothing modifies 'p' ..
>    q = *p;
> 
> and there are literally *zero* operations that modify the value
> change, so obviously the two operations are ordered, right?
> 
> Wrong.
> 
> What if the "nothing modifies 'p'" part looks like this:
> 
>     if (p != &myvariable)
>         return;
> 
> and now any sane compiler will happily optimize "q = *p" into "q =
> myvariable", and we're all done - nothing invalid was ever

Yes, the compiler could do that.  But it would still be required to
carry a dependency from the memory_order_consume read to the "*p",
which it could do by compiling "q = *p" rather than "q = myvariable"
on the one hand or by emitting a memory-barrier instruction on the other.

This was the point of #12:

12.	A memory_order_consume load carries a dependency to any
	dereference operator (unary "*", "[]", and "->") in the
	resulting pointer chain.

							Thanx, Paul

