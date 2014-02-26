Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaBZNJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:09:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaBZNJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:09:54 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Matz <matz@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <Pine.LNX.4.64.1402212206040.16563@digraph.polyomino.org.uk>
References: <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	 <20140220083032.GN4250@linux.vnet.ibm.com>
	 <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	 <20140220181116.GT4250@linux.vnet.ibm.com>
	 <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	 <20140220185608.GX4250@linux.vnet.ibm.com>
	 <CA+55aFw4inow5B-JAg-NtZigJ90yDbksddr00RoMKytzDAEa8A@mail.gmail.com>
	 <20140220221027.GC4250@linux.vnet.ibm.com>
	 <CA+55aFxp7U67R0PARaUfj94y5dJ8q6_HQ2pnbQ6=JD=XR-bTOw@mail.gmail.com>
	 <alpine.LNX.2.00.1402211847290.7694@wotan.suse.de>
	 <20140221191318.GK4250@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.1402212206040.16563@digraph.polyomino.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Feb 2014 14:09:17 +0100
Message-ID: <1393420157.28840.8691.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 22:10 +0000, Joseph S. Myers wrote:
> On Fri, 21 Feb 2014, Paul E. McKenney wrote:
> 
> > This needs to be as follows:
> > 
> > [[carries_dependency]] int getzero(int i [[carries_dependency]])
> > {
> > 	return i - i;
> > }
> > 
> > Otherwise dependencies won't get carried through it.
> 
> C11 doesn't have attributes at all (and no specification regarding calls 
> and dependencies that I can see).  And the way I read the C++11 
> specification of carries_dependency is that specifying carries_dependency 
> is purely about increasing optimization of the caller: that if it isn't 
> specified, then the caller doesn't know what dependencies might be 
> carried.  "Note: The carries_dependency attribute does not change the 
> meaning of the program, but may result in generation of more efficient 
> code. - end note".

I think that this last sentence can be kind of misleading, especially
when looking at it from an implementation point of view.  How
dependencies are handled (ie, preserving the syntactic dependencies vs.
emitting barriers) must be part of the ABI, or things like
[[carries_dependency]] won't work as expected (or lead to inefficient
code).  Thus, in practice, all compiler vendors on a platform would have
to agree to a particular handling, which might end up in selecting the
easy-but-conservative implementation option (ie, always emitting
mo_acquire when the source uses mo_consume).

