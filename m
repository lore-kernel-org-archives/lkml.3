Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3IEN3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:29:20 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42706 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3IEN3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:29:18 -0400
Date: Thu, 5 Sep 2013 15:29:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net,
        Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: do_softirq() vs __do_softirq() in irq_exit() and stack overflow
Message-ID: <20130905132914.GD20519@somewhere>
References: <1378330796.4321.50.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378330796.4321.50.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 07:39:56AM +1000, Benjamin Herrenschmidt wrote:
> Hi Folks !
> 
> It appears that the current version of irq_exit() calls __do_softirq()
> directly rather than do_softirq().
> 
> That means we are going to call the softirq's in the current interrupt
> frame rather than on the separate softirq stack.
> 
> The current frame is also still the normal kernel stack, because
> do_IRQ() itself only switches to the interrupt stack for processing
> the handlers (it's back to the original stack by the time it calls
> irq_exit).
> 
> That means that we end up stacking the normal stack, the actually HW
> interrupt stack frame (which can be pretty big on ppc) + do_IRQ's own,
> then the softirq (networks stack can create HUGE stack frames) and ...
> we are in softirq, so HW irqs are enable, we can thus can another irq
> stack frame piled up on top of that (or a perf stack).
> 
> We are observing actual overflows, here's an example blowing up our 16k
> stack on ppc64, you notice that it's all on the normal kernel stack:

I see, __do_softirq() is sometimes called to avoid irqsafe and softirq_pending
check they are not necessary but OTOH this bypass the arch overriden handler.

I'm going to try something and post soon.

Thanks.
