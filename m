Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaBNTu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:50:29 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:64301 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaBNTu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:50:27 -0500
MIME-Version: 1.0
In-Reply-To: <20140214172920.GQ4250@linux.vnet.ibm.com>
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
Date: Fri, 14 Feb 2014 11:50:26 -0800
X-Google-Sender-Auth: vvpFQ-HzAh6U92mQSviUPGV-Jwc
Message-ID: <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
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

On Fri, Feb 14, 2014 at 9:29 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Linus, Peter, any objections to marking places where we are relying on
> ordering from control dependencies against later stores?  This approach
> seems to me to have significant documentation benefits.

Quite frankly, I think it's stupid, and the "documentation" is not a
benefit, it's just wrong.

How would you figure out whether your added "documentation" holds true
for particular branches but not others?

How could you *ever* trust a compiler that makes the dependency meaningful?

Again, let's keep this simple and sane:

 - if a compiler ever generates code where an atomic store movement is
"visible" in any way, then that compiler is broken shit.

I don't understand why you even argue this. Seriously, Paul, you seem
to *want* to think that "broken shit" is acceptable, and that we
should then add magic markers to say "now you need to *not* be broken
shit".

Here's a magic marker for you: DON'T USE THAT BROKEN COMPILER.

And if a compiler can *prove* that whatever code movement it does
cannot make a difference, then let it do so. No amount of
"documentation" should matter.

Seriously, this whole discussion has been completely moronic. I don't
understand why you even bring shit like this up:

> >     r1 = atomic_load(x, memory_order_control);
> >     if (control_dependency(r1))
> >             atomic_store(y, memory_order_relaxed);

I mean, really? Anybody who writes code like that, or any compiler
where that "control_dependency()" marker makes any difference
what-so-ever for code generation should just be retroactively aborted.

There is absolutely *zero* reason for that "control_dependency()"
crap. If you ever find a reason for it, it is either because the
compiler is buggy, or because the standard is so shit that we should
never *ever* use the atomics.

Seriously. This thread has devolved into some kind of "just what kind
of idiotic compiler cesspool crap could we accept". Get away from that
f*cking mindset. We don't accept *any* crap.

Why are we still discussing this idiocy? It's irrelevant. If the
standard really allows random store speculation, the standard doesn't
matter, and sane people shouldn't waste their time arguing about it.

            Linus
