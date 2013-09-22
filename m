Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3IVQYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 12:24:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34026 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3IVQYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 12:24:34 -0400
Date: Sun, 22 Sep 2013 18:24:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
Message-ID: <20130922162410.GA10649@laptop.programming.kicks-ass.net>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
 <20130920162603.GA30381@localhost.localdomain>
 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
 <1379799901.24090.6.camel@pasglop>
 <523E4F8A.7020708@zytor.com>
 <1379824754.24090.11.camel@pasglop>
 <1379824861.24090.12.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379824861.24090.12.camel@pasglop>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 02:41:01PM +1000, Benjamin Herrenschmidt wrote:
> On Sun, 2013-09-22 at 14:39 +1000, Benjamin Herrenschmidt wrote:
> > How do you do your per-cpu on x86 ? 

We use a segment offset. Something like:

  inc %gs:var;

would be a per-cpu increment. The actual memory location used for the
memop is the variable address + GS offset.

And our GS offset is per cpu and points to the base of the per cpu
segment for that cpu.

> Also, do you have a half-decent way of getting to per-cpu from asm ?

Yes, see above :-)

Assuming we repurpose r13 as per-cpu base, you could do the whole
this_cpu_* stuff which is locally atomic -- ie. safe against IRQs and
preemption as:

loop:
	lwarx	rt, var, r13
	inc	rt
	stwcx	rt, var, r13
	bne-	loop

Except, I think your ll/sc pair is actually slower than doing:

  local_irq_save(flags)
  var++;
  local_irq_restore(flags)

Esp. with the lazy irq disable you have.

And I'm fairly sure using them as generic per cpu accessors isn't sane,
but I'm not sure PPC64 has other memops with implicit addition like
that.

As to the problem of GCC moving r13 about, some archs have some
exceptions in the register allocator and leave some registers alone.
IIRC MIPS has this and uses one of those (istr there's 2) for the
per cpu base address.




