Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaBNUC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:02:28 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37085 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaBNUCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:02:25 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
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
Date: Fri, 14 Feb 2014 12:02:23 -0800
X-Google-Sender-Auth: vS09ErzWeLMpAgW1I1ZKGGpuzYA
Message-ID: <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
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

On Fri, Feb 14, 2014 at 11:50 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Why are we still discussing this idiocy? It's irrelevant. If the
> standard really allows random store speculation, the standard doesn't
> matter, and sane people shouldn't waste their time arguing about it.

Btw, the other part of this coin is that our manual types (using
volatile and various architecture-specific stuff) and our manual
barriers and inline asm accesses are generally *fine*.

The C11 stuff doesn't buy us anything. The argument that "new
architectures might want to use it" is prue and utter bollocks, since
unless the standard gets the thing *right*, nobody sane would ever use
it for some new architecture, when the sane thing to do is to just
fill in the normal barriers and inline asms.

So I'm very very serious: either the compiler and the standard gets
things right, or we don't use it. There is no middle ground where "we
might use it for one or two architectures and add random hints".
That's just stupid.

The only "middle ground" is about which compiler version we end up
trusting _if_ it turns out that the compiler and standard do get
things right. From Torvald's explanations (once I don't mis-read them
;), my take-away so far has actually been that the standard *does* get
things right, but I do know from over-long personal experience that
compiler people sometimes want to be legalistic and twist the
documentation to the breaking point, at which point we just go "we'd
be crazy do use that".

See our use of "-fno-strict-aliasing", for example. The C standard
aliasing rules are a mistake, stupid, and wrong, and gcc uses those
stupid type-based alias rules even when statically *proving* the
aliasing gives the opposite result. End result: we turn the shit off.

Exact same deal wrt atomics. We are *not* going to add crazy "this
here is a control dependency" crap. There's a test, the compiler
*sees* the control dependency for chrissake, and it still generates
crap, we turn that broken "optimization" off. It really is that
simple.

            Linus
