Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaBJTJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:09:30 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:49854 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaBJTJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:09:26 -0500
MIME-Version: 1.0
In-Reply-To: <1391992071.18779.99.camel@triegel.csb>
References: <52F3DA85.1060209@arm.com>
	<20140206185910.GE27276@mudshark.cambridge.arm.com>
	<20140206192743.GH4250@linux.vnet.ibm.com>
	<1391721423.23421.3898.camel@triegel.csb>
	<20140206221117.GJ4250@linux.vnet.ibm.com>
	<1391730288.23421.4102.camel@triegel.csb>
	<20140207042051.GL4250@linux.vnet.ibm.com>
	<20140207074405.GM5002@laptop.programming.kicks-ass.net>
	<20140207165028.GO4250@linux.vnet.ibm.com>
	<20140207165548.GR5976@mudshark.cambridge.arm.com>
	<20140207180216.GP4250@linux.vnet.ibm.com>
	<1391992071.18779.99.camel@triegel.csb>
Date: Mon, 10 Feb 2014 11:09:24 -0800
X-Google-Sender-Auth: AecA6CsNHShj6rLsYb9u0ccaIOc
Message-ID: <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 4:27 PM, Torvald Riegel <triegel@redhat.com> wrote:
>
> Intuitively, this is wrong because this let's the program take a step
> the abstract machine wouldn't do.  This is different to the sequential
> code that Peter posted because it uses atomics, and thus one can't
> easily assume that the difference is not observable.

Btw, what is the definition of "observable" for the atomics?

Because I'm hoping that it's not the same as for volatiles, where
"observable" is about the virtual machine itself, and as such volatile
accesses cannot be combined or optimized at all.

Now, I claim that atomic accesses cannot be done speculatively for
writes, and not re-done for reads (because the value could change),
but *combining* them would be possible and good.

For example, we often have multiple independent atomic accesses that
could certainly be combined: testing the individual bits of an atomic
value with helper functions, causing things like "load atomic, test
bit, load same atomic, test another bit". The two atomic loads could
be done as a single load without possibly changing semantics on a real
machine, but if "visibility" is defined in the same way it is for
"volatile", that wouldn't be a valid transformation. Right now we use
"volatile" semantics for these kinds of things, and they really can
hurt.

Same goes for multiple writes (possibly due to setting bits):
combining multiple accesses into a single one is generally fine, it's
*adding* write accesses speculatively that is broken by design..

At the same time, you can't combine atomic loads or stores infinitely
- "visibility" on a real machine definitely is about timeliness.
Removing all but the last write when there are multiple consecutive
writes is generally fine, even if you unroll a loop to generate those
writes. But if what remains is a loop, it might be a busy-loop
basically waiting for something, so it would be wrong ("untimely") to
hoist a store in a loop entirely past the end of the loop, or hoist a
load in a loop to before the loop.

Does the standard allow for that kind of behavior?

              Linus
