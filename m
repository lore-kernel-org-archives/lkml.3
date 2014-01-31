Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbaAaTwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:52:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54368 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaAaTv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:51:57 -0500
Date: Fri, 31 Jan 2014 20:51:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
Message-ID: <20140131195133.GP5002@laptop.programming.kicks-ass.net>
References: <1390933151-1797-1-git-send-email-Waiman.Long@hp.com>
 <1390933151-1797-2-git-send-email-Waiman.Long@hp.com>
 <20140131150832.GG4941@twins.programming.kicks-ass.net>
 <52EBF871.5020603@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EBF871.5020603@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 02:24:33PM -0500, Waiman Long wrote:
> On 01/31/2014 10:08 AM, Peter Zijlstra wrote:
> >Whereas for the straight cmpxchg() you'd get something relatively simple
> >like:
> >
> >   mov %edx,%eax
> >   lock cmpxchg %ecx,(%rbx)
> >   cmp %edx,%eax
> >   jne ...
> 
> I believe the speeds of the lock functions are about the same. However,
> qspinlock has a much simpler unlock function which probably account of most
> of the speed gain.

The unlock path for ticket locks is a single "add[bw] $0x1,()", that should be
as fast as the single "movb 0,()" you have.

> >I suppose we could from the ticket code more and optimize the
> >uncontended path, but that'll make the contended path more expensive
> >again, although probably not as bad as hitting a new cacheline.
> 
> I don't get what you are trying to say.

I said we could probably make the ticket lock function faster for the
uncontended case by making the contended case slightly more expensive.
