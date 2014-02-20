Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaBTS4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:56:19 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46640 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbaBTS4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:56:17 -0500
Date: Thu, 20 Feb 2014 10:56:08 -0800
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
Message-ID: <20140220185608.GX4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1392740258.18779.7732.camel@triegel.csb>
 <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
 <1392752867.18779.8120.camel@triegel.csb>
 <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
 <20140220040102.GM4250@linux.vnet.ibm.com>
 <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
 <20140220083032.GN4250@linux.vnet.ibm.com>
 <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
 <20140220181116.GT4250@linux.vnet.ibm.com>
 <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022018-3532-0000-0000-000005DB5E02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:32:51AM -0800, Linus Torvalds wrote:
> On Thu, Feb 20, 2014 at 10:11 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > You really need that "consume" to be "acquire".
> 
> So I think we now all agree that that is what the standard is saying.
> 
> And I'm saying that that is wrong, that the standard is badly written,
> and should be fixed.
> 
> Because before the standard is fixed, I claim that "consume" is
> unusable. We cannot trust it. End of story.

We get exactly those same issues with control dependencies.

The example gcc breakage was something like this:

	i = atomic_load(idx, memory_order_consume);
	x = array[0 + i - i];

Then gcc optimized this to:

	i = atomic_load(idx, memory_order_consume);
	x = array[0];

This same issue would hit control dependencies.  You are free to argue
that this is the fault of ARM and PowerPC memory ordering, but the fact
remains that your suggested change has -exactly- the same vulnerability
as memory_order_consume currently has.

> The fact that apparently gcc is currently buggy because it got the
> dependency calculations *wrong* just reinforces my point.
> 
> The gcc bug Torvald pointed at is exactly because the current C
> standard is illogical unreadable CRAP. I can guarantee that what
> happened is:
> 
>  - the compiler saw that the result of the read was used as the left
> hand expression of the ternary "? :" operator
> 
>  - as a result, the compiler decided that there's no dependency
> 
>  - the compiler didn't think about the dependency that comes from the
> result of the load *also* being used as the middle part of the ternary
> expression, because it had optimized it away, despite the standard not
> talking about that at all.
> 
>  - so the compiler never saw the dependency that the standard talks about

No, the dependency was in a cancelling arithmetic expression as shown
above, so that gcc optimized the dependency away.  Then the ordering
was lost on AARCH64.

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59448

> BECAUSE THE STANDARD LANGUAGE IS PURE AND UTTER SHIT.
> 
> My suggested language never had any of these problems, because *my*
> suggested semantics are clear, logical, and don't have these kinds of
> idiotic pit-falls.
> 
> Solution: Fix the f*cking C standard. No excuses, no explanations.
> Just get it fixed.

I agree that the standard needs help, but your suggested fix has the
same problems as shown in the bugzilla.

							Thanx, Paul

