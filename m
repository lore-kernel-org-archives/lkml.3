Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3IUHrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 03:47:31 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44165 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3IUHra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 03:47:30 -0400
Date: Sat, 21 Sep 2013 09:47:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
Message-ID: <20130921074726.GA7771@gmail.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
 <20130920162603.GA30381@localhost.localdomain>
 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Sep 20, 2013 at 9:26 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> > Now just for clarity, what do we then do with inline sofirq 
> > executions: on local_bh_enable() for example, or explicit calls to 
> > do_softirq() other than irq exit?
> 
> If we do a softirq because it was pending and we did a 
> "local_bh_enable()" in normal code, we need a new stack. The 
> "local_bh_enable()" may be pretty deep in the callchain on a normal 
> process stack, so I think it would be safest to switch to a separate 
> stack for softirq handling.
> 
> So you have a few different cases:
> 
>  - irq_exit(). The irq stack is by definition empty (assuming itq_exit() 
> is done on the irq stack), so doing softirq in that context should be 
> fine. However, that assumes that if we get *another* interrupt, then 
> we'll switch stacks again, so this does mean that we need two irq 
> stacks. No, irq's don't nest, but if we run softirq on the first irq 
> stack, the other irq *can* nest that softirq.
> 
>  - process context doing local_bh_enable, and a bh became pending while 
> it was disabled. See above: this needs a stack switch. Which stack to 
> use is open, again assuming that a hardirq coming in will switch to yet 
> another stack.
> 
> Hmm?

I'd definitely argue in favor of never letting unknown-size stacks nest 
(i.e. to always switch if we start a new context on top of a non-trivial 
stack).

Known (small) size stack nesting is not real stack nesting, it's just a 
somewhat unusual (and faster) way of stack switching.

Thanks,

	Ingo
