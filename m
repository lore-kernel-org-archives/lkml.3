Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3ITB4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 21:56:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:47915 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab3ITB43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 21:56:29 -0400
Message-ID: <1379642029.6148.89.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Date: Fri, 20 Sep 2013 11:53:49 +1000
In-Reply-To: <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 19:02 -0500, Linus Torvalds wrote:
> On Thu, Sep 19, 2013 at 2:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> > It fixes stacks overruns reported by Benjamin Herrenschmidt:
> > http://lkml.kernel.org/r/1378330796.4321.50.camel%40pasglop
> 
> So I don't really dislike this patch-series, but isn't "irq_exit()"
> (which calls the new softirq_on_stack()) already running in the
> context of the irq stack? 

Not on powerpc and afaik not on i386 from my quick look at
handle_irq() in irq_32.c ... maybe x86_64 calls do_IRQ already
on the irq stack ?

Also irq and softirq are (somewhat on purpose) different stacks

> And it's run at the very end of the irq
> processing, so the irq stack should be empty too at that point.
> So switching to *another* empty stack sounds really sad. No? Taking
> more cache misses etc, instead of using the already empty - but
> cache-hot - stack that we already have.
> 
> I'm assuming that the problem is that since we're already on the irq
> stack, if *another* irq comes in, now that *other* irq doesn't get yet
> another irq stack page. And I'm wondering whether we shouldn't just
> fix that (hopefully unlikely) case instead? So instead of having a
> softirq stack, we'd have just an extra irq stack for the case where
> the original irq stack is already in use.

Well actually in the crash we observed we aren't already in the irq
stack.

We could try to change powerpc to switch stack before calling do_IRQ but
that would be fairly invasive for various reasons (a significant change
of our assembly entry code) unless we do it as a kind of wrapper around
do_IRQ (and thus keep the actual interrupt frame on the main kernel
stack).

I'll look into hacking something up along those lines, it might be the
best approach for a RHEL7 fix anyway.

Ben.

> Hmm?
> 
>                    Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


