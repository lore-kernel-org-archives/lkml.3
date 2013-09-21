Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3IUAyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 20:54:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:40762 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab3IUAyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 20:54:24 -0400
Message-ID: <1379724733.22775.5.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 21 Sep 2013 10:52:13 +1000
In-Reply-To: <20130920162603.GA30381@localhost.localdomain>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-20 at 11:26 -0500, Frederic Weisbecker wrote:

> Looks good to me.
> 
> Now just for clarity, what do we then do with inline sofirq executions: on local_bh_enable()
> for example, or explicit calls to do_softirq() other than irq exit?

We cannot make the irq stack larger than the normal stacks on ppc due to
how we get to the thread info (by masking low bits of the stack
pointer), however our stacks are pretty big too (16k) so it might be
ok to run the softirqs on the irq stack, it's just a matter of us
doing the switch before do_IRQ rather than later when calling the
handlers.

I think we basically copied what x86 originally did, but we can
definitely change that.

> Should we keep the current switch to a different softirq stack? If we have a generic irq stack
> (used for both hard and soft) that is big enough, perhaps we can also switch to this
> generic irq stack for inline softirqs executions? After all there is no much point in keeping
> a separate stack for that: this result in cache misses if the inline softirq is interrupted by
> a hardirq, also inlined softirqs can't happen in hardirq, so there should be no much risk of overruns.
> 
> Or am I missing other things?

Originally IRQs could nest so we really wanted separate stacks,
especially since softirq is where network processing happens and that
can go fairly deep.

But that's not the case anymore so I suppose it makes some sense...

Ben.

> > 
> > Thanks,
> > 
> > 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


