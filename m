Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3CMVmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:42:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:48550 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab3CMVmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:42:19 -0400
Date: Wed, 13 Mar 2013 22:42:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Arjan van de Veen <arjan@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>
Subject: Re: [patch 4/7] tick: Handle broadcast wakeup of multiple cpus
In-Reply-To: <20130313113623.GA6635@e102568-lin.cambridge.arm.com>
Message-ID: <alpine.LFD.2.02.1303132239510.22263@ionos>
References: <20130306111351.883117670@linutronix.de> <20130306111537.492045206@linutronix.de> <20130313113623.GA6635@e102568-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013, Lorenzo Pieralisi wrote:
> > +	/* Take care of enforced broadcast requests */
> > +	cpumask_or(tmpmask, tmpmask, tick_broadcast_force_mask);
> > +	cpumask_clear(tick_broadcast_force_mask);
> 
> I tested the set and it works fine on a dual cluster big.LITTLE testchip
> using broadcast timer to manage deep idle cluster states.
> 
> Just asking a question: the force mask is cleared before sending the
> timer IPI. Would not be better to clear it after the IPI is sent in
> 
> tick_do_broadcast(...) ?
> 
> Can you spot a regression if we do this ? The idle thread checks that
> mask with irqs disabled, so it is possible that we clear the mask before
> the CPU has a chance to get the IPI. If we clear the mask after sending
> the IPI, we are increasing the chances for the idle thread to get it.
> 
> It is just a further optimization, just asking, thanks.

Need to think about that.
 
> > @@ -524,7 +530,16 @@ void tick_broadcast_oneshot_control(unsi
> >  		WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
> >  		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
> >  			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
> > -			if (dev->next_event.tv64 < bc->next_event.tv64)
> > +			/*
> > +			 * We only reprogram the broadcast timer if we
> > +			 * did not mark ourself in the force mask and
> > +			 * if the cpu local event is earlier than the
> > +			 * broadcast event. If the current CPU is in
> > +			 * the force mask, then we are going to be
> > +			 * woken by the IPI right away.
> > +			 */
> > +			if (!cpumask_test_cpu(cpu, tick_broadcast_force_mask) &&
> Is the test against tick_broadcast_force_mask necessary if we add the check
> in the idle thread before entering idle ? It does not hurt, agreed, and we'd
> better leave it there, it is just for my own understanding, thanks a lot.

Well, it's necessary for all archs which do not have the check (yet).
 
> Having said that, on the series:
> 
> Tested-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

Thanks,

	tglx
