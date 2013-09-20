Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3ITLDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:03:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:39895 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab3ITLDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:03:33 -0400
Date: Fri, 20 Sep 2013 13:03:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
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
In-Reply-To: <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com> <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Sep 2013, Linus Torvalds wrote:

> On Thu, Sep 19, 2013 at 2:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> > It fixes stacks overruns reported by Benjamin Herrenschmidt:
> > http://lkml.kernel.org/r/1378330796.4321.50.camel%40pasglop
> 
> So I don't really dislike this patch-series, but isn't "irq_exit()"
> (which calls the new softirq_on_stack()) already running in the
> context of the irq stack? And it's run at the very end of the irq
> processing, so the irq stack should be empty too at that point.

Right, but most of the implementations are braindamaged.

      irq_enter();
      handle_irq_on_hardirq_stack();
      irq_exit();

instead of doing:
	
      switch_stack()
      irq_enter()
      handle_irq()
      irq_exit()
      restore_stack()

So in the case of softirq processing (the likely case) we end up doing:

   switch_to_hardirq_stack()
   ...
   restore_original_stack()
   switch_to_softirq_stack()
   ...
   restore_original_stack()

Two avoidable stack switch operations for no gain.

> I'm assuming that the problem is that since we're already on the irq
> stack, if *another* irq comes in, now that *other* irq doesn't get yet
> another irq stack page. And I'm wondering whether we shouldn't just
> fix that (hopefully unlikely) case instead? So instead of having a
> softirq stack, we'd have just an extra irq stack for the case where
> the original irq stack is already in use.

Why not have a single irq_stack large enough to accomodate interrupt
handling during softirq processing? We have no interrupt nesting so
the maximum stack depth necessary is

  max(softirq_stack_usage) + max(irq_stack_usage)

Today we allocate THREAD_SIZE_ORDER for the hard and the soft context,
so allocating 2 * THREAD_SIZE_ORDER should be sufficient.

Thanks,

	tglx
