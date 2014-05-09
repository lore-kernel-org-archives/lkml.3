Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaEIOPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:15:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:49432 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaEIOPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:15:23 -0400
Date: Fri, 9 May 2014 16:15:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: mingo@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        luto@amacapital.net, nicolas.pitre@linaro.org,
        daniel.lezcano@linaro.org, umgwanakikbuti@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC][PATCH 6/8] sched,idle: Avoid spurious wakeup IPIs
Message-ID: <20140509141520.GV2844@laptop.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <20140411135218.478299389@infradead.org>
 <CAAG0J9_q1KsUx10-XAb7AJnxv2ehctg6q1KME7ahsk1OZV8vZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAAG0J9_q1KsUx10-XAb7AJnxv2ehctg6q1KME7ahsk1OZV8vZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 02:37:27PM +0100, James Hogan wrote:
> Hi Peter,
> 
> On 11 April 2014 14:42, Peter Zijlstra <peterz@infradead.org> wrote:
> > +       return !(fetch_or(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG);
> 
> This breaks the build on metag, and I suspect arm64 too:

Yep, I just got a patch for arm64.

> kernel/sched/core.c In function ‘set_nr_and_not_polling’:
> kernel/sched/core.c +531 : error: ‘_TIF_POLLING_NRFLAG’ undeclared
> 
> since metag/arm64 define TIF_POLLING_NRFLAG but not
> _TIF_POLLING_NRFLAG. Could you please fix that prior to your patch to
> avoid breaking bisection?

Ingo, is there any git magic to make that happen? Can we have a tree
with 2 patches (one for ARM64 and one for metag) before the sched/core
tree?

> BTW what is it that determines whether an arch needs TIF_POLLING_NRFLAG?

Any SMP arch that has a polling idle function of any kind (including the
default cpu_idle_poll()).

That said, even if that's true, not having TIF_POLLING_NRFLAG isn't
fatal, just sub-optimal in that we'll send an unconditional IPI to wake
the CPU even though its polling TIF_NEED_RESCHED and doesn't need
anything other than that write to wake up.

Most archs have (x86) hlt or (arm) wfi like idle instructions, and if
that is your only possible idle function, you'll require the interrupt
to wake up and there's really no point to having the POLLING bit.

Lastly, having the POLLING bit and not needing it is similarly non-fatal.
