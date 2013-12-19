Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab3LSVON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:14:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47503 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab3LSVOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:14:11 -0500
Date: Thu, 19 Dec 2013 22:14:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Anvin <hpa@linux.intel.com>, Len Brown <len.brown@intel.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/idle] x86, idle: Use static_cpu_has() for CLFLUSH
 workaround, add barriers
Message-ID: <20131219211406.GA3464@gmail.com>
References: <CA+55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com>
 <tip-7e98b71920464b8d15fa95c74366416cd3c88861@git.kernel.org>
 <20131219204051.GA2253@gmail.com>
 <CA+55aFyr5VcONQKp_yDRDy+BFpMy9=P--+U8d1uYeDVNWcAM8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyr5VcONQKp_yDRDy+BFpMy9=P--+U8d1uYeDVNWcAM8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Dec 20, 2013 at 5:40 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > The first mb() looks superfluous, because see
> > current_set_polling_and_test():
> >
> > static inline bool __must_check current_set_polling_and_test(void)
> > {
> >         __current_set_polling();
> >
> >         /*
> >          * Polling state must be visible before we test NEED_RESCHED,
> >          * paired by resched_task()
> >          */
> >         smp_mb();
> >
> >         return unlikely(tif_need_resched());
> > }
> >
> > So it already has a (MFENCE) barrier after ->flags is modified.
> 
> So what?
> 
> The mb() isn't necessarily against the *write*, it is also against 
> the *read*.
> 
> If the cflush is needed before the monitor, it's likely because the 
> monitor instruction has some bug with already-existing cachelines in 
> shared state or whatever.

So, my thinking was that maybe it's the other way around: the problem 
is with the write not being drained to cache yet.

One possibility would be that the bug is that MONITOR will not see the 
previous write in the store buffer and when shortly afterwards the 
store hits the cache, it falsely 'wakes up' the MWAIT.

(If so then the race window roughly depends on the the number of 
cycles the current_set_polling_and_test() modification retires and 
explains how small reorganizations of the code triggered the hw bug.)

The CLFLUSH ensures that the modification is visible in the cache 
before MONITOR is run.

If this guess is true then the need_resched() read is immaterial to 
the bug. On the flip side, if my guess is wrong then I'm leaving 
another subtle race window in the code...

So yeah I agree that without more information from Intel we are better 
off with a more conservative approach, the bug took relatively long to 
find, Thomas did the original 7d1a941731fab back in March, 3 kernel 
releases ago ...

If only there were Intel employees on Cc: who could tell us more about 
the background of the bug ;-)

> Which means that we want to make sure that the cflush is ordered wrt 
> *reads* from that cacheline too.
> 
> cflush has nothing specifically to do with writes.

Yes.

Thanks,

	Ingo
