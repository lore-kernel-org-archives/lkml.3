Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbaFBVMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:12:33 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:48172 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaFBVMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140602210227.GE22231@linux.vnet.ibm.com>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
	<20140602162525.GH16155@laptop.programming.kicks-ass.net>
	<20140602163032.GI16155@laptop.programming.kicks-ass.net>
	<538CB56E.5010709@hp.com>
	<20140602200525.GD13930@laptop.programming.kicks-ass.net>
	<CA+55aFwJwVf_MbcwNNWg-KrLdoOaV2xse2jzvBZTJHJgC_Htvg@mail.gmail.com>
	<20140602210227.GE22231@linux.vnet.ibm.com>
Date: Mon, 2 Jun 2014 14:12:30 -0700
X-Google-Sender-Auth: S6Ld09e0rC8nI5NqWjHWneWLnxw
Message-ID: <CA+55aFzX3oDvzqh4AfkJ7-X1Yfo8obFM+jOOmwzeN-GyqOPLJg@mail.gmail.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Waiman Long <waiman.long@hp.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 2:02 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> In the ->qlen case, interrupts are disabled and the current CPU is
> the only one who can write, so the read need not be volatile.  In the
> ->n_barrier_done, modifications are done holding ->barrier_mutex, so again
> the read need not be volatile.  In the sync_rcu_preempt_exp_count case,
> modifications are done holding sync_rcu_preempt_exp_mutex, so once again,
> the read need not be volatile.  So I could do something like:
>
>         ACCESS_ONCE(rdp->qlen) = rdp->qlen + 1;
>
> But that still makes gcc generate bad code
>
> The reason I was not all that worried about this is that these are not
> in fastpaths, and the last two are especially not in fastpaths.
>
> Suggestions?

So I think it probably *works*, but even so splitting it up to use
ACCESS_ONCE() on just the write is probably a better option, if only
because it would then make it much easier to change if we do end up
splitting reads and writes.

Because from a gcc code generation standpoint, using "volatile" will
always be horrible, because gcc will never be able to turn it into a
read-modify-write cycle. Arguable gcc _should_ be able to do that (it
is certainly allowable within the virtual machine definition), but I
understand why it doesn't ("volatile? Let's not optimize anything at
all, because it's special").

So "ACCESS_ONCE() + R-M-W" operation is actually pretty much
guaranteed to be "ACCESS_TWICE()", which may well be ok (performance
may not matter, and even when it does most architectures don't
actually have r-m-w instructions and when they do they aren't always
even faster), but I think it's just horribly horribly bad from a
conceptual and readability standpoint because it's so misleading.

So I'd actually rather see two explicit ACCESS_ONCE() calls - once to
read, once to write. Because that at least describes what is
happening, unlike the current situation.

Put another way: I can understand why you do it, and I can even agree
that it is "correct" from a functionality standpoint. But even despite
that all, I really don't like the construct very much..

              Linus
