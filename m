Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaH1PBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:01:39 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35704 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751280AbaH1PBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:01:34 -0400
Date: Thu, 28 Aug 2014 16:01:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
Message-ID: <20140828150112.GD30401@n2100.arm.linux.org.uk>
References: <1408369264-14242-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-4-git-send-email-daniel.thompson@linaro.org> <20140819173742.GG30401@n2100.arm.linux.org.uk> <53F39377.1070308@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F39377.1070308@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 07:12:07PM +0100, Daniel Thompson wrote:
> On 19/08/14 18:37, Russell King - ARM Linux wrote:
> > On Tue, Aug 19, 2014 at 05:45:53PM +0100, Daniel Thompson wrote:
> >> +int register_fiq_nmi_notifier(struct notifier_block *nb)
> >> +{
> >> +	return atomic_notifier_chain_register(&fiq_nmi_chain, nb);
> >> +}
> >> +
> >> +asmlinkage void __exception_irq_entry fiq_nmi_handler(struct pt_regs *regs)
> >> +{
> >> +	struct pt_regs *old_regs = set_irq_regs(regs);
> >> +
> >> +	nmi_enter();
> >> +	atomic_notifier_call_chain(&fiq_nmi_chain, (unsigned long)regs, NULL);
> >> +	nmi_exit();
> >> +	set_irq_regs(old_regs);
> >> +}
> > 
> > Really not happy with this.  What happens if a FIQ occurs while we're
> > inside register_fiq_nmi_notifier() - more specifically inside
> > atomic_notifier_chain_register() ?
> 
> Should depend on which side of the rcu update we're on.

I just asked Paul McKenney, our RCU expert... essentially, yes, RCU
stuff itself is safe in this context.  However, RCU stuff can call into
lockdep if lockdep is configured, and there are questions over lockdep.

There's some things which can be done to reduce the lockdep exposure
to it, such as ensuring that rcu_read_lock() is first called outside
of FIQ context.

There's concerns with whether either printk() in check_flags() could
be reached too (flags there should always indicate that IRQs were
disabled, so that reduces down to a question about just the first
printk() there.)

There's also the very_verbose() stuff for RCU lockdep classes which
Paul says must not be enabled.

Lastly, Paul isn't a lockdep expert, but he sees nothing that prevents
lockdep doing the deadlock checking as a result of the above call.

So... this coupled with my feeling that notifiers make it too easy for
unreviewed code to be hooked into this path, I'm fairly sure that we
don't want to be calling atomic notifier chains from FIQ context.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
