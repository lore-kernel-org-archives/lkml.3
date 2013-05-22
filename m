Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab3EVNhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:37:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55037 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab3EVNhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:37:09 -0400
Date: Wed, 22 May 2013 14:33:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chen Gang <gang.chen@asianux.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] kernel/sched/core.c: need return NULL when BUG() is
	defined as empty.
Message-ID: <20130522133317.GC18614@n2100.arm.linux.org.uk>
References: <5199D565.4070307@asianux.com> <20130522091156.GC18810@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522091156.GC18810@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 11:11:56AM +0200, Peter Zijlstra wrote:
> On Mon, May 20, 2013 at 03:48:53PM +0800, Chen Gang wrote:
> > 
> > When neither CONFIG_BUG nor HAVE_ARCH_BUG is defined, need let function
> > return failure value ('NULL') instead of random value.
> 
> What will such a kernel do? Happily continue running whenever we hit a
> BUG? that seems like a particularly bad idea. Should we not have a stub
> BUG() function like:
> 
> void BUG(void) __attribute__((noreturn))
> {
> 	local_irq_disable();
> 	while (1) ;
> }

Eww.  So you've a platform where you have things like panic_on_oops
enabled, and you hit this bug... do we really want to just stop?
Wouldn't replacing BUG() with panic("BUG"); be better ?

But, this begs the question - what is the point of being able to turn
off BUG() ?  As BUG() on any sensible architecture is implemented by
placing the minimum of code at the callsite (eg, one instruction if
not using verbose) anything like the above is likely to be bigger.

So, I'd actually argue that rather than trying to "fix" this, get rid
of CONFIG_BUG and make it always enabled everywhere - just like what
has recently been done with hotplug.
