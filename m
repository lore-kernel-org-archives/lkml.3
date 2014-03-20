Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbaCTUgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:36:49 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:39985 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959AbaCTUgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:36:48 -0400
MIME-Version: 1.0
In-Reply-To: <1395346808.14694.62.camel@buesod1.americas.hpqcorp.net>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	<20140319154705.GB8557@laptop.programming.kicks-ass.net>
	<20140319170829.GD8557@laptop.programming.kicks-ass.net>
	<20140320053350.GB30295@linux.vnet.ibm.com>
	<1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
	<1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFwH2sJKCH6hUf8H-7nMPo8YwFCR6oP8McZ5VpMcGDrYSw@mail.gmail.com>
	<1395342510.14694.43.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFw8wSe-DUtZ8=rjFJzXYmOSsZ0JzS-_jsZKrDai8LZMXw@mail.gmail.com>
	<1395346808.14694.62.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 20 Mar 2014 13:36:47 -0700
X-Google-Sender-Auth: 0iWcnk1wh-pBHC0WtjcSn-AbHMw
Message-ID: <CA+55aFzu53M_E3n5ZyeWzZYLD9sQ2fZd4nLrpLwrrBva9NO1bA@mail.gmail.com>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 1:20 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> I reverted commits 99b60ce6 (documentation) and b0c29f79 (the offending
> commit), and then I cleanly applied the equivalent ones from v3 of the
> series (which was already *tested* and ready for upstream until you
> suggested looking into the alternative spinlock approach):
>
> https://lkml.org/lkml/2013/12/19/624
> https://lkml.org/lkml/2013/12/19/630
>
> Assuming the atomics solves the issue, would you be willing to take this
> path? Any pending documentation fixes can be added afterwards. The
> important thing is that the actual code is well tested.

So my preference would be to do that "tested code" thing, but then
edit out the comment changes and boil it down to just the minimal code
changes. So that you can see what the patch actually *does*, without
it being hidden by the bulk of the patch just being the reverts of the
comment fixups.

In fact, I hope that if you do that, you end up with the patch I just
created by hand, and then we'd have come to the same situation two
different ways independently, and I'd be doubly happy for that extra
cross-checking of what went on.

And I would *not* want to do this as "two reverts and one patch to
re-do things like we used to", because that just makes the actual
change even harder to see. And that's partly because if we eventually
do decide that "hey, if we can do this using the ticket lock as a
counter, let's do it that way", then this *small* fixup patch ends up
showing the actual real differences between the two approaches.

Of course, right now we don't even have confirmation from Srikar that
the explicit "waiters" counter even fixes things on powerpc, so.. All
the testing that orginal patch had was also on x86, so if it's some
subtle memory ordering issue that we haven't figured out now, rather
than the ticket lock thing, all this discussion about which way to go
turns out to be entirely premature.

            Linus
