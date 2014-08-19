Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaHSRh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:37:58 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55207 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752533AbaHSRh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:37:56 -0400
Date: Tue, 19 Aug 2014 18:37:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
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
Message-ID: <20140819173742.GG30401@n2100.arm.linux.org.uk>
References: <1408369264-14242-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-4-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408466769-20004-4-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 05:45:53PM +0100, Daniel Thompson wrote:
> +int register_fiq_nmi_notifier(struct notifier_block *nb)
> +{
> +	return atomic_notifier_chain_register(&fiq_nmi_chain, nb);
> +}
> +
> +asmlinkage void __exception_irq_entry fiq_nmi_handler(struct pt_regs *regs)
> +{
> +	struct pt_regs *old_regs = set_irq_regs(regs);
> +
> +	nmi_enter();
> +	atomic_notifier_call_chain(&fiq_nmi_chain, (unsigned long)regs, NULL);
> +	nmi_exit();
> +	set_irq_regs(old_regs);
> +}

Really not happy with this.  What happens if a FIQ occurs while we're
inside register_fiq_nmi_notifier() - more specifically inside
atomic_notifier_chain_register() ?

This is how easy it is to end up with a deadlock-able situation with
FIQs, and it is why I said:

| > 2. Have default trap handler call an RCU notifier chain to allow it to
| >    hook up with "normal" code without any hard coding (kgdb, IPI
| >    handling, etc)
| 
| Maybe... that sounds like it opens up FIQ for general purpose use which
| is something I want to avoid - I've little motivation to ensure that
| everyone plays by the rules.  Given the choice, I'd rather maintain our
| present stance that using FIQs is hard and requires a lot of thought.

You've just proven my point.

So, what I want is to make FIQs hard to use.  No notifier chain at all
please, people can't be trusted to know all the details (even if they
do know the details, it's just been proven that it's incredibly difficult
to do it right.)

What I instead want to see is that users get added to the above code
fragment with #ifdef's around the calls - that way ensuring that people
have to modify this file, and therefore /should/ be copying me with
their patches.  That means less chance for someone to sneak a change
in by merely calling some register function without first having to
copy this mailing list.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
