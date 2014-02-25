Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaBYK1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:27:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:35838 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaBYK1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:27:51 -0500
Date: Tue, 25 Feb 2014 11:27:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russ Dill <Russ.Dill@ti.com>
cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH RFC v1 1/3] ARM: Add irq disabled version of
 soft_restart.
In-Reply-To: <530C4CAE.5000202@ti.com>
Message-ID: <alpine.DEB.2.02.1402251125500.21251@ionos.tec.linutronix.de>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org> <1392774729-3235-2-git-send-email-sebastian.capella@linaro.org> <20140222102616.GG21483@n2100.arm.linux.org.uk> <20140224231345.10580.62916@capellas-linux>
 <530C4CAE.5000202@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Russ Dill wrote:
> On 02/24/2014 03:13 PM, Sebastian Capella wrote:
> > Quoting Russell King - ARM Linux (2014-02-22 02:26:17)
> >> On Tue, Feb 18, 2014 at 05:52:07PM -0800, Sebastian Capella wrote:
> >>> From: Russ Dill <Russ.Dill@ti.com>
> >>>
> >>> This adds the ability to run soft_restart with local_irq/fiq_disable
> >>> already called. This is helpful for the hibernation code paths.
> >>
> >> I'd rather keep this simple.  There's no problem with calling soft_restart
> >> with interrupts already disabled.  local_irq_disable()/local_fiq_disable()
> >> there should be harmless.
> > 
> > Hi Russell,
> > 
> > I'm observing a data abort loop when I replace this call:
> > 
> > In the local_irq_disable, it ends up calling trace_hardirqs_off
> > (CONFIG_TRACE_IRQFLAGS_SUPPORT is enabled), which calls
> > trace_hardirqs_off_caller which checks lockdep_recursion in the
> > current task, but we've switched to a temporary stack with the
> > call_with_stack, and get_current is returning NULL.  This
> > triggers a data abort, which calls trace_hardirqs_off
> > again and so on.
> > 
> > Do you have any suggestions here?
> > 
> > Thanks,
> > 
> > Sebastian
> > 
> 
> So the alternative is to have a version of the call that calls a special
> no trace version of local_irq_disable()/local_fiq_disable(). Which would
> be preferable? Having a noirq version of soft_restart seems much simpler
> to me.

If you want escape the tracer and in that case you really want it
being on a different stack, use raw_local_irq_* which are not traced.

Thanks,

	tglx


