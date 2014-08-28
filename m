Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbaH1QP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:15:57 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47525 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaH1QP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:15:56 -0400
Date: Thu, 28 Aug 2014 09:15:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v10 03/19] arm: fiq: Replace default FIQ handler
Message-ID: <20140828161551.GC5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1408369264-14242-1-git-send-email-daniel.thompson@linaro.org>
 <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1408466769-20004-4-git-send-email-daniel.thompson@linaro.org>
 <20140819173742.GG30401@n2100.arm.linux.org.uk>
 <53F39377.1070308@linaro.org>
 <20140828150112.GD30401@n2100.arm.linux.org.uk>
 <53FF50B1.20009@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FF50B1.20009@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082816-1542-0000-0000-0000045DD4FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 04:54:25PM +0100, Daniel Thompson wrote:
> On 28/08/14 16:01, Russell King - ARM Linux wrote:
> > On Tue, Aug 19, 2014 at 07:12:07PM +0100, Daniel Thompson wrote:
> >> On 19/08/14 18:37, Russell King - ARM Linux wrote:
> >>> On Tue, Aug 19, 2014 at 05:45:53PM +0100, Daniel Thompson wrote:
> >>>> +int register_fiq_nmi_notifier(struct notifier_block *nb)
> >>>> +{
> >>>> +	return atomic_notifier_chain_register(&fiq_nmi_chain, nb);
> >>>> +}
> >>>> +
> >>>> +asmlinkage void __exception_irq_entry fiq_nmi_handler(struct pt_regs *regs)
> >>>> +{
> >>>> +	struct pt_regs *old_regs = set_irq_regs(regs);
> >>>> +
> >>>> +	nmi_enter();
> >>>> +	atomic_notifier_call_chain(&fiq_nmi_chain, (unsigned long)regs, NULL);
> >>>> +	nmi_exit();
> >>>> +	set_irq_regs(old_regs);
> >>>> +}
> >>>
> >>> Really not happy with this.  What happens if a FIQ occurs while we're
> >>> inside register_fiq_nmi_notifier() - more specifically inside
> >>> atomic_notifier_chain_register() ?
> >>
> >> Should depend on which side of the rcu update we're on.
> > 
> > I just asked Paul McKenney, our RCU expert... essentially, yes, RCU
> > stuff itself is safe in this context.  However, RCU stuff can call into
> > lockdep if lockdep is configured, and there are questions over lockdep.
> 
> Thanks for following this up.
> 
> I originally formed the opinion RCU was safe from FIQ because it is also
> used to manage the NMI notification handlers for x86
> (register_nmi_handler) and I understood the runtime constraints on FIQ
> to be very similar.
> 
> Note that x86 manages the notifiers itself so it uses
> list_for_each_entry_rcu() rather atomic_notifier_call_chain() but
> nevertheless I think this boils down to the same thing w.r.t. safety
> concerns.
> 
> 
> > There's some things which can be done to reduce the lockdep exposure
> > to it, such as ensuring that rcu_read_lock() is first called outside
> > of FIQ context.
> 
> lockdep is automatically disabled by calling nmi_enter() so all the
> lockdep calls should end up following the early exit path based on
> current->lockdep_recursion.

Ah, that was what I was missing.  Then the notification should be
safe from NMI, so have at it!  ;-)

							Thanx, Paul

> > There's concerns with whether either printk() in check_flags() could
> > be reached too (flags there should always indicate that IRQs were
> > disabled, so that reduces down to a question about just the first
> > printk() there.)
> > 
> > There's also the very_verbose() stuff for RCU lockdep classes which
> > Paul says must not be enabled.
> > 
> > Lastly, Paul isn't a lockdep expert, but he sees nothing that prevents
> > lockdep doing the deadlock checking as a result of the above call.
> >
> > So... this coupled with my feeling that notifiers make it too easy for
> > unreviewed code to be hooked into this path, I'm fairly sure that we
> > don't want to be calling atomic notifier chains from FIQ context.
> 
> 
> 

