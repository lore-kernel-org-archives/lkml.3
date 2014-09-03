Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbaICI1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:27:07 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:37408 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaICI1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:27:03 -0400
Message-ID: <5406D0D5.1050909@linaro.org>
Date: Wed, 03 Sep 2014 09:27:01 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Russell King <linux@arm.linux.org.uk>, linaro-kernel@lists.linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>, patches@linaro.org,
        kgdb-bugreport@lists.sourceforge.net, Nicolas Pitre <nico@linaro.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Fabio Estevam <festevam@gmail.com>, Colin Cross <ccross@android.com>,
        kernel-team@android.com, Dave Martin <Dave.Martin@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 01/19] arm: fiq: Add callbacks to manage FIQ routings
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-2-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.10.1409030103090.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409030103090.3333@nanos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 01:03, Thomas Gleixner wrote:
> On Tue, 2 Sep 2014, Daniel Thompson wrote:
> 
>> Currently enable_fiq/disable_fiq use a simple offset to convert an IRQ
>> virq into a FIQ virq. This is too inflexible for multi-platform kernels
>> and makes runtime error checking impossible.
> 
> You are missing to explain WHY it is too inflexible ....
>  
>> We solve this by introducing a flexible mapping that allows interrupt
> 
> Flexible in that context reads like random semantics. And that's
> definitely nothing we want to see in the context of interrupts/fiqs
> 
>> controllers that support FIQ to register those mappings. This, in turn,
>> makes it much possible for drivers in DT kernels to install FIQ handlers
>> without knowing anything about the interrupt controller.
> 
>> +#include <linux/irq.h>
>>  #include <asm/ptrace.h>
>>  
>> +struct fiq_chip {
>> +	void (*fiq_enable)(struct irq_data *data);
>> +	void (*fiq_disable)(struct irq_data *data);
>> +};
> 
> So you define an ARM specific extension to the irq infrastructure
> which is completely ignoring that there might be other architectures
> which have the same issue?
> 
> Aside of that you define that structure w/o documenting in any way
> what the semantics of the callbacks are and how struct irq_data is
> supposed to be (ab)used there.
> 
>> +struct fiq_data {
>> +	struct fiq_chip *fiq_chip;
>> +	struct irq_data *irq_data;
>> +};
> 
> Nice. Another completely undocumented data structure.
> 
>>  static unsigned long no_fiq_insn;
>> +static int fiq_start = -1;
>> +static RADIX_TREE(fiq_data_tree, GFP_KERNEL);
> 
> Along with a radix tree, which again lacks any form of documentation.
> 
>> -static int fiq_start;
>> +static struct fiq_data *lookup_fiq_data(int fiq)
>> +{
>> +	struct fiq_data *data;
>> +
>> +	rcu_read_lock();
>> +	data = radix_tree_lookup(&fiq_data_tree, fiq);
>> +	rcu_read_unlock();
>> +
>> +	return data;
> 
> That makes a lot of sense. NOT!
> 
> What kind of protection is that rcu_read_lock/unlock pair providing
> for the return value? Just that it has been valid at lookup time?
> 
> What protects against concurrent calls to the various usage sites
> which shine by the lack of serialization ...

The locking here ought to safe because there is no means to unregister
fiq data (the two irqchip drivers I looked at has no need for that) so
once looked up the data will be valid.

Thus it's only purpose was to prevent incorrect traversals of the radix
tree.

That said, this doesn't make it right.


>>  void enable_fiq(int fiq)
>>  {
>> +	struct fiq_data *data = lookup_fiq_data(fiq);
>> +
>> +	if (data) {
>> +		if (data->fiq_chip->fiq_enable)
>> +			data->fiq_chip->fiq_enable(data->irq_data);
>> +		enable_irq(fiq);
> 
> This is ass backwards, really.
> 
> The FIQ target is a property of the interrupt line right?
> 
> So why the heck do you need a separate chip/data representation
> including a radix tree and whatever? Just because you can?
> 
> What is wrong to tell the irq core code via a flag that a particular
> interrupt should be targeted at FIQ instead of a regular interrupt?
> 
> Nothing as far as I can tell. And that would even allow to retarget an
> already enabled interrupt to FIQ or vice versa.
> 
> So all your patch does is trying to (ab)use an existing interface
> which was created in the last millenium for totally different reasons
> and in a totally different context.
> 
> But you fail completely to understand what that interface is doing:
> 
>     It merily maps the Linux virq to a FIQ via an offset.
> 
> While I understand that this is not workable on multiplatform kernels,
> I really cannot understand your attempt to change this by adding
> complex functionality to a primitive offset mapping function.
> 
> You just add some randomly defined new chip/data combination which
> abuses the irq_data structure under the hood instead of properly
> integrating that irq chip property into irqchip/irqdata itself.
> 
> So instead of thinking about the properties of the hardware and
> questioning the existing mechanism, you just bolt some crap onto it
> and inflict a gazillion of pointless modifications to the irq chip
> drivers without any value.
> 
> So all it needs is
> 
>  1) Adding a property flag to the irq chip which signals that it
>     supports FIQ/NMI targets
> 
>  2) Adding a interface which allows to flag a particular interrupt
>     line targeted to either the regular or the FIQ/NMI which consults
>     the flag added by #1
> 
>  3) Let the chip driver deal with the target flag at a minimal
>     intrusive level w/o registering racy callbacks designed in hell
>     and imposing arch specific data structures, storage etc. for no
>     value

Thanks for the comments.

I'll get working along these lines.


