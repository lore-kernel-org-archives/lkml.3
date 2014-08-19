Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaHSSMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:12:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33475 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaHSSMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:12:15 -0400
Message-ID: <53F39377.1070308@linaro.org>
Date: Tue, 19 Aug 2014 19:12:07 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
References: <1408369264-14242-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-4-git-send-email-daniel.thompson@linaro.org> <20140819173742.GG30401@n2100.arm.linux.org.uk>
In-Reply-To: <20140819173742.GG30401@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/14 18:37, Russell King - ARM Linux wrote:
> On Tue, Aug 19, 2014 at 05:45:53PM +0100, Daniel Thompson wrote:
>> +int register_fiq_nmi_notifier(struct notifier_block *nb)
>> +{
>> +	return atomic_notifier_chain_register(&fiq_nmi_chain, nb);
>> +}
>> +
>> +asmlinkage void __exception_irq_entry fiq_nmi_handler(struct pt_regs *regs)
>> +{
>> +	struct pt_regs *old_regs = set_irq_regs(regs);
>> +
>> +	nmi_enter();
>> +	atomic_notifier_call_chain(&fiq_nmi_chain, (unsigned long)regs, NULL);
>> +	nmi_exit();
>> +	set_irq_regs(old_regs);
>> +}
> 
> Really not happy with this.  What happens if a FIQ occurs while we're
> inside register_fiq_nmi_notifier() - more specifically inside
> atomic_notifier_chain_register() ?

Should depend on which side of the rcu update we're on.


> This is how easy it is to end up with a deadlock-able situation with
> FIQs, and it is why I said:
> 
> | > 2. Have default trap handler call an RCU notifier chain to allow it to
> | >    hook up with "normal" code without any hard coding (kgdb, IPI
> | >    handling, etc)
> | 
> | Maybe... that sounds like it opens up FIQ for general purpose use which
> | is something I want to avoid - I've little motivation to ensure that
> | everyone plays by the rules.  Given the choice, I'd rather maintain our
> | present stance that using FIQs is hard and requires a lot of thought.
> 
> You've just proven my point.
> 
> So, what I want is to make FIQs hard to use.  No notifier chain at all
> please, people can't be trusted to know all the details (even if they
> do know the details, it's just been proven that it's incredibly difficult
> to do it right.)

For what its worth the reason I stuck to the notifier idea was that
there has to be some dynamic registration; the gic is registering
something to clear IPIs. Once I had dynamic registration notifiers felt
most elegant.

However, the dynamic registration requirement is in fact very basic
since and can be registered by function pointer since only irqchip
instance is responsible for IPIs. It might even be possible to hardcode
direct calls into the gic driver and have the gic driver maintain a flag.


> What I instead want to see is that users get added to the above code
> fragment with #ifdef's around the calls - that way ensuring that people
> have to modify this file, and therefore /should/ be copying me with
> their patches.  That means less chance for someone to sneak a change
> in by merely calling some register function without first having to
> copy this mailing list.

I can do this.

Note that I'm about to go and live in a field for a week so there will
be a bit of a delay since the field interferes substantially with
hacking time.

