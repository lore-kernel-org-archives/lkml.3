Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab3ITWOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 18:14:08 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:62654 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3ITWOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 18:14:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130920162603.GA30381@localhost.localdomain>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	<CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	<alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	<20130920162603.GA30381@localhost.localdomain>
Date: Fri, 20 Sep 2013 15:14:05 -0700
X-Google-Sender-Auth: T9e81RVlTSmmDyRbdElw6JiP3ac
Message-ID: <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 9:26 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> Now just for clarity, what do we then do with inline sofirq executions: on local_bh_enable()
> for example, or explicit calls to do_softirq() other than irq exit?

If we do a softirq because it was pending and we did a
"local_bh_enable()" in normal code, we need a new stack. The
"local_bh_enable()" may be pretty deep in the callchain on a normal
process stack, so I think it would be safest to switch to a separate
stack for softirq handling.

So you have a few different cases:

 - irq_exit(). The irq stack is by definition empty (assuming
itq_exit() is done on the irq stack), so doing softirq in that context
should be fine. However, that assumes that if we get *another*
interrupt, then we'll switch stacks again, so this does mean that we
need two irq stacks. No, irq's don't nest, but if we run softirq on
the first irq stack, the other irq *can* nest that softirq.

 - process context doing local_bh_enable, and a bh became pending
while it was disabled. See above: this needs a stack switch. Which
stack to use is open, again assuming that a hardirq coming in will
switch to yet another stack.

Hmm?

            Linus
