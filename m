Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaB0TWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:22:37 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:41787 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaB0TWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:22:35 -0500
Date: Thu, 27 Feb 2014 11:22:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Torvald Riegel <triegel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140227192226.GA4698@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
 <20140223063426.GT4250@linux.vnet.ibm.com>
 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
 <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
 <20140224172110.GO8264@linux.vnet.ibm.com>
 <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
 <20140224185341.GU8264@linux.vnet.ibm.com>
 <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
 <1393515453.28840.9961.camel@triegel.csb>
 <20140227175021.GT8264@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227175021.GT8264@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022719-3532-0000-0000-00000612CF21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 09:50:21AM -0800, Paul E. McKenney wrote:
> On Thu, Feb 27, 2014 at 04:37:33PM +0100, Torvald Riegel wrote:
> > xagsmtp2.20140227154925.3851@vmsdvm9.vnet.ibm.com
> > 
> > On Mon, 2014-02-24 at 11:54 -0800, Linus Torvalds wrote:
> > > On Mon, Feb 24, 2014 at 10:53 AM, Paul E. McKenney
> > > <paulmck@linux.vnet.ibm.com> wrote:
> > > >
> > > > Good points.  How about the following replacements?
> > > >
> > > > 3.      Adding or subtracting an integer to/from a chained pointer
> > > >         results in another chained pointer in that same pointer chain.
> > > >         The results of addition and subtraction operations that cancel
> > > >         the chained pointer's value (for example, "p-(long)p" where "p"
> > > >         is a pointer to char) are implementation defined.
> > > >
> > > > 4.      Bitwise operators ("&", "|", "^", and I suppose also "~")
> > > >         applied to a chained pointer and an integer for the purposes
> > > >         of alignment and pointer translation results in another
> > > >         chained pointer in that same pointer chain.  Other uses
> > > >         of bitwise operators on chained pointers (for example,
> > > >         "p|~0") are implementation defined.
> > > 
> > > Quite frankly, I think all of this language that is about the actual
> > > operations is irrelevant and wrong.
> > > 
> > > It's not going to help compiler writers, and it sure isn't going to
> > > help users that read this.
> > > 
> > > Why not just talk about "value chains" and that any operations that
> > > restrict the value range severely end up breaking the chain. There is
> > > no point in listing the operations individually, because every single
> > > operation *can* restrict things. Listing individual operations and
> > > depdendencies is just fundamentally wrong.
> > 
> > [...]
> > 
> > > The *only* thing that matters for all of them is whether they are
> > > "value-preserving", or whether they drop so much information that the
> > > compiler might decide to use a control dependency instead. That's true
> > > for every single one of them.
> > > 
> > > Similarly, actual true control dependencies that limit the problem
> > > space sufficiently that the actual pointer value no longer has
> > > significant information in it (see the above example) are also things
> > > that remove information to the point that only a control dependency
> > > remains. Even when the value itself is not modified in any way at all.
> > 
> > I agree that just considering syntactic properties of the program seems
> > to be insufficient.  Making it instead depend on whether there is a
> > "semantic" dependency due to a value being "necessary" to compute a
> > result seems better.  However, whether a value is "necessary" might not
> > be obvious, and I understand Paul's argument that he does not want to
> > have to reason about all potential compiler optimizations.  Thus, I
> > believe we need to specify when a value is "necessary".
> > 
> > I have a suggestion for a somewhat different formulation of the feature
> > that you seem to have in mind, which I'll discuss below.  Excuse the
> > verbosity of the following, but I'd rather like to avoid
> > misunderstandings than save a few words.
> 
> Thank you very much for putting this forward!  I must confess that I was
> stuck, and my earlier attempt now enshrined in the C11 and C++11 standards
> is quite clearly way bogus.
> 
> One possible saving grace:  From discussions at the standards committee
> meeting a few weeks ago, there is a some chance that the committee will
> be willing to do a rip-and-replace on the current memory_order_consume
> wording, without provisions for backwards compatibility with the current
> bogosity.
> 
> > What we'd like to capture is that a value originating from a mo_consume
> > load is "necessary" for a computation (e.g., it "cannot" be replaced
> > with value predictions and/or control dependencies); if that's the case
> > in the program, we can reasonably assume that a compiler implementation
> > will transform this into a data dependency, which will then lead to
> > ordering guarantees by the HW.
> > 
> > However, we need to specify when a value is "necessary".  We could say
> > that this is implementation-defined, and use a set of litmus tests
> > (e.g., like those discussed in the thread) to roughly carve out what a
> > programmer could expect.  This may even be practical for a project like
> > the Linux kernel that follows strict project-internal rules and pays a
> > lot of attention to what the particular implementations of compilers
> > expected to compile the kernel are doing.  However, I think this
> > approach would be too vague for the standard and for many other
> > programs/projects.
> 
> I agree that a number of other projects would have more need for this than
> might the kernel.  Please understand that this is in no way denigrating
> the intelligence of other projects' members.  It is just that many of
> them have only recently started seriously thinking about concurrency.
> In contrast, the Linux kernel community has been doing concurrency since
> the mid-1990s.  Projects with less experience with concurrency will
> probably need more help, from the compiler and from elsewhere as well.

I should hasten to add that it is not just concurrency.  After all, part
of the reason I got into trouble with memory_order_consume is that my
mid-to-late 70s experience with compilers is not so useful in 2014.  ;-)

							Thanx, Paul

> Your proposal looks quite promising at first glance.  But rather than
> try and comment on it immediately, I am going to take a number of uses of
> RCU from the Linux kernel and apply your proposal to them, then respond
> with the results
> 
> Fair enough?
> 
> 							Thanx, Paul

