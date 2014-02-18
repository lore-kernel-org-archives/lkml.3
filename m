Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaBRPlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:41:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104AbaBRPlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:41:00 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <CA+55aFzSBZMC6kbdJj5Jus9-q1dzXdCYQXfMm34O+9h8SbGcGQ@mail.gmail.com>
References: <20140207180216.GP4250@linux.vnet.ibm.com>
	 <1391992071.18779.99.camel@triegel.csb>
	 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
	 <1392183564.18779.2187.camel@triegel.csb>
	 <20140212180739.GB4250@linux.vnet.ibm.com>
	 <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
	 <20140213002355.GI4250@linux.vnet.ibm.com>
	 <1392321837.18779.3249.camel@triegel.csb>
	 <20140214020144.GO4250@linux.vnet.ibm.com>
	 <1392352981.18779.3800.camel@triegel.csb>
	 <20140214172920.GQ4250@linux.vnet.ibm.com>
	 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	 <1392486310.18779.6447.camel@triegel.csb>
	 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	 <1392666947.18779.6838.camel@triegel.csb>
	 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	 <1392672063.18779.6940.camel@triegel.csb>
	 <1392675939.18779.7063.camel@triegel.csb>
	 <CA+55aFx2jxE8! sTZEmNnMg6ktDuU_0xPiEw3=qH0=+xat8p8cAA@mail.gmail.com>
	 <1392680518.18779.7213.camel@triegel.csb>
	 <CA+55aFzSBZMC6kbdJj5Jus9-q1dzXdCYQXfMm34O+9h8SbGcGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 16:38:40 +0100
Message-ID: <1392737920.18779.7659.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 16:18 -0800, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 3:41 PM, Torvald Riegel <triegel@redhat.com> wrote:
> >
> > There's an underlying problem here that's independent from the actual
> > instance that you're worried about here: "no sense" is a ultimately a
> > matter of taste/objectives/priorities as long as the respective
> > specification is logically consistent.
> 
> Yes. But I don't think it's "independent".
> 
> Exactly *because* some people will read standards without applying
> "does the resulting code generation actually make sense for the
> programmer that wrote the code", the standard has to be pretty clear.
> 
> The standard often *isn't* pretty clear. It wasn't clear enough when
> it came to "volatile", and yet that was a *much* simpler concept than
> atomic accesses and memory ordering.
> 
> And most of the time it's not a big deal. But because the C standard
> generally tries to be very portable, and cover different machines,
> there tends to be a mindset that anything inherently unportable is
> "undefined" or "implementation defined", and then the compiler writer
> is basically given free reign to do anything they want (with
> "implementation defined" at least requiring that it is reliably the
> same thing).

Yes, that's how it works in general.  And this makes sense, because all
optimizations rely on that.  Second, you can't keep something consistent
(eg, between compilers) if it isn't specified.  So if we want stricter
rules, those need to be specified somewhere.

> And when it comes to memory ordering, *everything* is basically
> non-portable, because different CPU's very much have different rules.

Well, the current set of memory orders (and the memory model as a whole)
is portable, even though it might not allow to exploit all hardware
properties, and thus might perform sub-optimally in some cases.

> I worry that that means that the standard then takes the stance that
> "well, compiler re-ordering is no worse than CPU re-ordering, so we
> let the compiler do anything". And then we have to either add
> "volatile" to make sure the compiler doesn't do that, or use an overly
> strict memory model at the compiler level that makes it all pointless.

Using "volatile" is not a good option, I think, because synchronization
between threads should be orthogonal to observable output of the
abstract machine.

The current memory model might not allow to exploit all hardware
properties, I agree.

But then why don't we work on how to extend it to do so?  We need to
specify the behavior we want anyway, and this can't be independent of
the language semantics, so it has to be conceptually integrated with the
standard anyway.

> So I really really hope that the standard doesn't give compiler
> writers free hands to do anything that they can prove is "equivalent"
> in the virtual C machine model.

It does, but it also doesn't mean this can't be extended.  So let's
focus on whether we can find an extension.

> That's not how you get reliable
> results.

In this general form, that's obviously a false claim.

