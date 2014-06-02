Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaFBVCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:02:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54517 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbaFBVCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:02:35 -0400
Date: Mon, 2 Jun 2014 14:02:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140602210227.GE22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <20140602163032.GI16155@laptop.programming.kicks-ass.net>
 <538CB56E.5010709@hp.com>
 <20140602200525.GD13930@laptop.programming.kicks-ass.net>
 <CA+55aFwJwVf_MbcwNNWg-KrLdoOaV2xse2jzvBZTJHJgC_Htvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwJwVf_MbcwNNWg-KrLdoOaV2xse2jzvBZTJHJgC_Htvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060221-8236-0000-0000-000002CDE21B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 01:22:10PM -0700, Linus Torvalds wrote:
> On Mon, Jun 2, 2014 at 1:05 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > So the question is, do you prefer subtly broken code or hard compile
> > fails? Me, I go for the compile fail.
> 
> The thing is, parisc has a perfectly fine "cmpxchg" implementation in
> practice, and ACCESS_ONCE() and friends work fine too for reading.
> 
> What the "use a spinlock" approach cannot generally do is:
> 
>  - ACCESS_ONCE() to _write_ things doesn't work well. You really
> should use "atomic_set()".
> 
>  - you may not necessarily be able to mix partial updates (ie
> differently sized updates to the same thing) depending on just how the
> spinlock hashing works
> 
> but both of those are really rare issues and don't affect normal code.
> 
> I would not necessarily be opposed to splitting up ACCESS_ONCE() for
> reading and for writing, and maybe we could do something special for
> the writing path (which tends to be less ctitical). It's really mixing
> "ACCESS_ONCE(x)" to _set_ a value, together with atomic ops to update
> it, that ends up being problematic.

Knowing what I know now about how ACCESS_ONCE() is used, I would have
split it for reading and writing to begin with.  Where is that time
machine when you need it?  ;-)

> Maybe there are other issues I can't think of right now. But
> basically, parisc _can_ do cmpxchg, it's just that the code needs to
> be somewhat sanitized.
> 
> Side note: some of the RCU code uses "ACCESS_ONCE()" for
> read-modify-write code, which is just f*cking crazy. The semantics are
> dubious, and it generally makes gcc create bad code too.

A couple of the places are admittedly overkill, for example the pair of:

	ACCESS_ONCE(rsp->n_force_qs_lh)++;

which is just for debug statistics in any case.  I could put these back
to "rsp->n_force_qs_lh++;" without problems, if desired.  (Yeah, I know,
I am overly paranoid.)

However, these cases need a bit more care:

	ACCESS_ONCE(rdp->qlen)++;
	ACCESS_ONCE(rsp->n_barrier_done)++;
	ACCESS_ONCE(sync_rcu_preempt_exp_count)++;

In the ->qlen case, interrupts are disabled and the current CPU is
the only one who can write, so the read need not be volatile.  In the
->n_barrier_done, modifications are done holding ->barrier_mutex, so again
the read need not be volatile.  In the sync_rcu_preempt_exp_count case,
modifications are done holding sync_rcu_preempt_exp_mutex, so once again,
the read need not be volatile.  So I could do something like:

	ACCESS_ONCE(rdp->qlen) = rdp->qlen + 1;

But that still makes gcc generate bad code.

The reason I was not all that worried about this is that these are not
in fastpaths, and the last two are especially not in fastpaths.

Suggestions?

							Thanx, Paul

