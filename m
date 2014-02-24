Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaBXSxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:53:50 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:41756 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaBXSxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:53:47 -0500
Date: Mon, 24 Feb 2014 10:53:41 -0800
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
Message-ID: <20140224185341.GU8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
 <1393095223.28840.4914.camel@triegel.csb>
 <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
 <20140223003933.GQ4250@linux.vnet.ibm.com>
 <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
 <20140223063426.GT4250@linux.vnet.ibm.com>
 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
 <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
 <20140224172110.GO8264@linux.vnet.ibm.com>
 <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022418-6688-0000-0000-000006F033D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 10:14:01AM -0800, Linus Torvalds wrote:
> On Mon, Feb 24, 2014 at 9:21 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > 4.      Bitwise operators ("&", "|", "^", and I suppose also "~")
> >         applied to a chained pointer and an integer results in another
> >         chained pointer in that same pointer chain.
> 
> No. You cannot define it this way. Taking the value of a pointer and
> doing a bitwise operation that throws away all the bits (or even
> *most* of the bits) results in the compiler easily being able to turn
> the "chain" into a non-chain.
> 
> The obvious example being "val & 0", but things like "val & 1" are in
> practice also something that compilers easily turn into control
> dependencies instead of data dependencies.

Indeed, most of the bits need to remain for this to work.

> So you can talk about things like "aligning the pointer value to
> object boundaries" etc, but it really cannot and *must* not be about
> the syntactic operations.
> 
> The same goes for "adding and subtracting an integer". The *syntax*
> doesn't matter. It's about remaining information. Doing "p-(int)p" or
> "p+(-(int)p)" doesn't leave any information despite being "subtracting
> and adding an integer" at a syntactic level.
> 
> Syntax is meaningless. Really.

Good points.  How about the following replacements?

3.	Adding or subtracting an integer to/from a chained pointer
	results in another chained pointer in that same pointer chain.
	The results of addition and subtraction operations that cancel
	the chained pointer's value (for example, "p-(long)p" where "p"
	is a pointer to char) are implementation defined.

4.	Bitwise operators ("&", "|", "^", and I suppose also "~")
	applied to a chained pointer and an integer for the purposes
	of alignment and pointer translation results in another
	chained pointer in that same pointer chain.  Other uses
	of bitwise operators on chained pointers (for example,
	"p|~0") are implementation defined.

> > 8.      Applying any of the following operators to a chained pointer
> >         results in something that is not a chained pointer:
> >         "()", sizeof, "!", "*", "/", "%", ">>", "<<", "<", ">", "<=",
> >         ">=", "==", "!=", "&&", and "||".
> 
> Parenthesis? I'm assuming that you mean calling through the chained pointer.

Yes, good point.  Of course, parentheses for grouping just pass the
value through without affecting the chained-ness.

> Also, I think all of /, * and % are perfectly fine, and might be used
> for that "aligning the pointer" operation that is fine.

Something like this?

	char *p;

	p = p - (unsigned long)p % 8;

I was thinking of this as subtraction -- the "p" gets moduloed by 8,
which loses the chained-pointer designation.  But that is OK because
that designation gets folded back in by the subtraction.  Am I missing
a use case?

That leaves things like this one:

	p = (p / 8) * 8;

I cannot think of any other legitimate use for "/" and "*".

Here is an updated #8 and a new 8a:

8.	Applying any of the following operators to a chained pointer
	results in something that is not a chained pointer: function call
	"()", sizeof, "!", "%", ">>", "<<", "<", ">", "<=", ">=", "==",
	"!=", "&&", "||", and "kill_dependency()".

8a.	Dividing a chained pointer by an integer and multiplying it
	by that same integer (for example, to align that pointer) results
	in a chained pointer in that same pointer chain.  The ordering
	effects of other uses of infix "*" and "/" on chained pointers
	are implementation defined.

Does that capture it?

							Thanx, Paul

