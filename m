Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3ITShj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:37:39 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:65423 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3ITShi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:37:38 -0400
Date: Fri, 20 Sep 2013 13:37:33 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
Message-ID: <20130920183731.GC30381@localhost.localdomain>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
 <20130920162603.GA30381@localhost.localdomain>
 <alpine.DEB.2.02.1309201926440.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309201926440.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 07:30:14PM +0200, Thomas Gleixner wrote:
> On Fri, 20 Sep 2013, Frederic Weisbecker wrote:
> 
> > Now just for clarity, what do we then do with inline sofirq
> > executions: on local_bh_enable() for example, or explicit calls to
> > do_softirq() other than irq exit?  Should we keep the current switch
> > to a different softirq stack? If we have a generic irq stack (used
> > for both hard and soft) that is big enough, perhaps we can also
> > switch to this generic irq stack for inline softirqs executions?
> > After all there is no much point in keeping a separate stack for
> > that: this result in cache misses if the inline softirq is
> > interrupted by a hardirq, also inlined softirqs can't happen in
> > hardirq, so there should be no much risk of overruns.
> 
> We can use the same irqstack for this because from the irqstack point
> of view, thats the same as if softirqs get executed from
> irq_exit().

Ok, so I see that's what x86-64 is doing. But x86-32 seems to be using different
stacks for hard and soft irqs for no much reasons (expept maybe to avoid overrun if
the hardirq). And x86-32 only switches to hardirq
stack for the handler. So probably we can use the same stack for the whole and extend
it to before irq_enter() and after irq_exit(), like you suggested.

BTW, we still want the 1st patch of my series I think, as it simply consolidate existing code.
Using the same stack for hard and soft irqs is independant from that.

If you're ok with it, would you agree to apply it?

Thanks.
