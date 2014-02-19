Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaBSLmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:42:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53684 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbaBSLmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:42:49 -0500
Date: Wed, 19 Feb 2014 12:42:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alec Teal <a.teal@warwick.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140219114238.GH15586@twins.programming.kicks-ass.net>
References: <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
 <1392666947.18779.6838.camel@triegel.csb>
 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
 <530296CD.5050503@warwick.ac.uk>
 <CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.c!om>
 <1392737465.18779.7644.camel@triegel.csb>
 <CA+55aFxn2KRXDQ91xRs=bO_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
 <1392758516.18779.8378.camel@triegel.csb>
 <20140218214713.GV14089@laptop.programming.kicks-ass.net>
 <1392808022.18779.8674.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392808022.18779.8674.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 12:07:02PM +0100, Torvald Riegel wrote:
> > Its not only hardware; also the kernel/user boundary has this same
> > problem. We cannot a-priory say what userspace will do; in fact, because
> > we're a general purpose OS, we must assume it will willfully try its
> > bestest to wreck whatever assumptions we make about its behaviour.
> 
> That's a good note, and I think a distinct case from those below,
> because here you're saying that you can't assume that the userspace code
> follows the C11 semantics ...

Right; we can malfunction in those cases though; as long as the
malfunctioning happens on the userspace side. That is, whatever
userspace does should not cause the kernel to crash, but userspace
crashing itself, or getting crap data or whatever is its own damn fault
for not following expected behaviour.

To stay on topic; if the kernel/user interface requires memory ordering
and userspace explicitly omits the barriers all malfunctioning should be
on the user. For instance it might loose a fwd progress guarantee or
data integrity guarantees.

In specific, given a kernel/user lockless producer/consumer buffer, if
the user-side allows the tail write to happen before its data reads are
complete, the kernel might overwrite the data its still reading.

Or in case of futexes, if the user side doesn't use the appropriate
operations its lock state gets corrupt but only userspace should suffer.

But yes, this does require some care and consideration from our side.
