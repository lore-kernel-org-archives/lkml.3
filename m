Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3IUS6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 14:58:14 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:32881 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab3IUS6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 14:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	<CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	<alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	<20130920162603.GA30381@localhost.localdomain>
	<CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
Date: Sat, 21 Sep 2013 13:58:11 -0500
Message-ID: <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/9/20 Linus Torvalds <torvalds@linux-foundation.org>:
> On Fri, Sep 20, 2013 at 9:26 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>
>> Now just for clarity, what do we then do with inline sofirq executions: on local_bh_enable()
>> for example, or explicit calls to do_softirq() other than irq exit?
>
> If we do a softirq because it was pending and we did a
> "local_bh_enable()" in normal code, we need a new stack. The
> "local_bh_enable()" may be pretty deep in the callchain on a normal
> process stack, so I think it would be safest to switch to a separate
> stack for softirq handling.

Right.

>
> So you have a few different cases:
>
>  - irq_exit(). The irq stack is by definition empty (assuming
> itq_exit() is done on the irq stack), so doing softirq in that context
> should be fine. However, that assumes that if we get *another*
> interrupt, then we'll switch stacks again, so this does mean that we
> need two irq stacks. No, irq's don't nest, but if we run softirq on
> the first irq stack, the other irq *can* nest that softirq.

Well, most archs don't define __ARCH_IRQ_EXIT_IRQS_DISABLED. It doesn't
even mean that the majority of them actually run irq_exit() with irqs enabled in
practice. But there may be thoretically some where hardirqs can nest
without even the
help of softirqs.

So it's quite possible to run softirqs on a hardirq stack that is not empty.

Now certainly what needs to be fixed then is archs that don't have
__ARCH_IRQ_EXIT_IRQS_DISABLED
or archs that have any other significant opportunity to nest interrupt.

>
>  - process context doing local_bh_enable, and a bh became pending
> while it was disabled. See above: this needs a stack switch. Which
> stack to use is open, again assuming that a hardirq coming in will
> switch to yet another stack.

Right. Now if we do like Thomas suggested, we can have a common irq
stack that is big enough for hard and softirqs. After all there should
never be more than two or three nesting irq contexts:
hardirq->softirq->hardirq, softirq->hardirq, ...

At least if we put aside the unsane archs that can nest irqs somehow.
