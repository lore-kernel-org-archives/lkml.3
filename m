Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaBXRiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:38:51 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:43320 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaBXRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:38:47 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1402241745100.7694@wotan.suse.de>
References: <20140220083032.GN4250@linux.vnet.ibm.com>
	<CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	<20140220181116.GT4250@linux.vnet.ibm.com>
	<CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	<1392922421.28840.36.camel@triegel.csb>
	<CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
	<1393095223.28840.4914.camel@triegel.csb>
	<CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	<20140223003933.GQ4250@linux.vnet.ibm.com>
	<CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	<20140223063426.GT4250@linux.vnet.ibm.com>
	<CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	<CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
	<CAFiYyc08cusFTsydD2C4rEZB-k38NnorzEXzKvqab0m3R+qn8w@mail.gmail.com>
	<CA+55aFyYtMm1_UsPVw8mi7o2iH_--1wLvxPUt5Z9mAEOGMgXdQ@mail.gmail.com>
	<alpine.LNX.2.00.1402241745100.7694@wotan.suse.de>
Date: Mon, 24 Feb 2014 09:38:46 -0800
X-Google-Sender-Auth: e4OtgnTN7CBetah6UzJSgcyAzU4
Message-ID: <CA+55aFwi-wd_heT_R-ngHAS5=aVNqy4PqKTriK4bVWpuS5+pkg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Matz <matz@suse.de>
Cc: Richard Biener <richard.guenther@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
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

On Mon, Feb 24, 2014 at 8:55 AM, Michael Matz <matz@suse.de> wrote:
>
> So, let me try to poke holes into your definition or increase my
> understanding :) .  You said "chain of pointers"(dereferences I assume),
> e.g. if p is result of consume load, then access to
> p->here->there->next->prev->stuff is supposed to be ordered with that load
> (or only when that last load/store itself is also an atomic load or
> store?).

It's supposed to be ordered wrt the first load (the consuming one), yes.

> So, what happens if the pointer deref chain is partly hidden in some
> functions:

No problem.

The thing is, the ordering is actually handled by the CPU in all
relevant cases.  So the compiler doesn't actually need to *do*
anything. All this legalistic stuff is just to describe the semantics
and the guarantees.

The problem is two cases:

 (a) alpha (which doesn't really order any accesses at all, not even
dependent loads), but for a compiler alpha is actually trivial: just
add a "rmb" instruction after the load, and you can't really do
anything else (there's a few optimizations you can do wrt the rmb, but
they are very specific and simple).

So (a) is a "problem", but the solution is actually really simple, and
gives very *strong* guarantees: on alpha, a "consume" ends up being
basically the same as a read barrier after the load, with only very
minimal room for optimization.

 (b) ARM and powerpc and similar architectures, that guarantee the
data dependency as long as it is an *actual* data dependency, and
never becomes a control dependency.

On ARM and powerpc, control dependencies do *not* order accesses (the
reasons boil down to essentially: branch prediction breaks the
dependency, and instructions that come after the branch can be happily
executed before the branch). But it's almost impossible to describe
that in the standard, since compilers can (and very much do) turn a
control dependency into a data dependency and vice versa.

So the current standard tries to describe that "control vs data"
dependency, and tries to limit it to a data dependency. It fails. It
fails for multiple reasons - it doesn't allow for trivial
optimizations that just remove the data dependency, and it also
doesn't allow for various trivial cases where the compiler *does* turn
the data dependency into a control dependency.

So I really really think that the current C standard language is
broken. Unfixably broken.

I'm trying to change the "syntactic data dependency" that the current
standard uses into something that is clearer and correct.

The "chain of pointers" thing is still obviously a data dependency,
but by limiting it to pointers, it simplifies the language, clarifies
the meaning, avoids all syntactic tricks (ie "p-p" is clearly a
syntactic dependency on "p", but does *not* involve in any way
following the pointer) and makes it basically impossible for the
compiler to break the dependency without doing value prediction, and
since value prediction has to be disallowed anyway, that's a feature,
not a bug.

                      Linus
