Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaBORp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 12:45:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbaBORpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 12:45:54 -0500
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
In-Reply-To: <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Feb 2014 09:45:10 -0800
Message-ID: <1392486310.18779.6447.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 12:02 -0800, Linus Torvalds wrote:
> On Fri, Feb 14, 2014 at 11:50 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Why are we still discussing this idiocy? It's irrelevant. If the
> > standard really allows random store speculation, the standard doesn't
> > matter, and sane people shouldn't waste their time arguing about it.
> 
> Btw, the other part of this coin is that our manual types (using
> volatile and various architecture-specific stuff) and our manual
> barriers and inline asm accesses are generally *fine*.

AFAICT, it does work for you, but hasn't been exactly pain-free.

I think a major benefit of C11's memory model is that it gives a
*precise* specification for how a compiler is allowed to optimize.
There is a formalization of the model, which allows things like the
cppmem tool by the Cambridge group.  It also allows meaningful fuzz
testing: http://www.di.ens.fr/~zappa/projects/cmmtest/ ; this did reveal
several GCC compiler bugs.

I also think that reasoning about this model is easier than reasoning
about how lots of different, concrete compiler optimizations would
interact.

> The C11 stuff doesn't buy us anything. The argument that "new
> architectures might want to use it" is prue and utter bollocks, since
> unless the standard gets the thing *right*, nobody sane would ever use
> it for some new architecture, when the sane thing to do is to just
> fill in the normal barriers and inline asms.
> 
> So I'm very very serious: either the compiler and the standard gets
> things right, or we don't use it. There is no middle ground where "we
> might use it for one or two architectures and add random hints".
> That's just stupid.
> 
> The only "middle ground" is about which compiler version we end up
> trusting _if_ it turns out that the compiler and standard do get
> things right. From Torvald's explanations (once I don't mis-read them
> ;), my take-away so far has actually been that the standard *does* get
> things right, but I do know from over-long personal experience that
> compiler people sometimes want to be legalistic and twist the
> documentation to the breaking point, at which point we just go "we'd
> be crazy do use that".

I agree that compilers want to optimize, and sometimes there's probably
a little too much emphasis on applying an optimization vs. not
surprising users.  But we have to draw a line (e.g., what is undefined
behavior and what is not), because we need this to be actually able to
optimize.

Therefore, we need to get the rules into a shape that both allows
optimizations and isn't full of surprising corner cases.  The rules are
the standard, so it's the standard we have to get right.  According to
my experience, a lot of thought goes into how to design the standard's
language and library so that they are intuitive yet efficient.

If you see issues in the standard, please bring them up.  Either report
the defects directly and get involved yourself, or reach out to somebody
that is participating in the standards process.

The standard certainly isn't perfect, so there is room to contribute.

