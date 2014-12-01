Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaLAOOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:14:03 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:43763 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaLAOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:14:01 -0500
Message-ID: <547C77A0.8030208@linaro.org>
Date: Mon, 01 Dec 2014 14:13:52 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tim Sander <tim@krieglstein.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>
Subject: Re: [PATCH 3.18-rc3 v9 5/5] arm: smp: Handle ipi_cpu_backtrace()
 using FIQ (if available)
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1633306.naE1qIcAOt@dabox> <20141201103832.GX3836@n2100.arm.linux.org.uk> <5910085.Y47hdorDAO@dabox>
In-Reply-To: <5910085.Y47hdorDAO@dabox>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/14 13:54, Tim Sander wrote:
>> Look, in my mind it is very simple.  If you are using CONFIG_FIQ on a
>> SMP platform, your life will be very difficult.  The FIQ code enabled
>> by that symbol is not designed to be used on SMP systems, *period*.
> Well the only extra thing you had to do is set up the FIQ registers on every 
> cpu, but i would not call that very difficult. Other than that i am not aware of 
> any problems that are not also present on a uniprocessor system. So i have a 
> hard time following your reasoning why SMP is different from UP in regard to 
> the CONFIG_FIQ.
> 
>> If you decide to enable CONFIG_FIQ, and you use that code on a SMP
>> platform, I'm going to say right now so it's totally clear: if you
>> encounter a problem, I don't want to know about it.  The code is not
>> designed for use on that situation.
> Even with using the FIQ on a Linux SMP system you have not heard from me 
> before, as i knew that this is not your problem (and that is not to say that 
> there where none!). The only interface Linux has been making available is 
> set_fiq_handler. So it was clear that the FIQ is its own domain otherwise 
> untouched by the kernel. Now the line gets blurried with the linux kernel 
> moving to use the FIQ. And with the descicions forthcoming its not only 
> grabbing land it also claims a previous public path for its own. So it doesn't 
> help that its planting some flowers along the way. So please be nice to the 
> natural inhabitants...

Surely only upstream code could claim to be a natural inhabitant.

Whenever I've been working on code that, for whatever reason, cannot be
upstreamed I'd probably best be regarded as a tourist.


> And i really don't get it, that neither ARM nor the kernel community sees fast 
> interrupts as a worthwhile usecase. Unfortunatly the interrupt latencies with 
> Linux are at least a order of magnitude higher than the pure hardware even 
> with longer pipelines can deliver. 
> 
>> Therefore, as far as I'm concerned, the two facilities are mututally
>> exclusive.
> Well can't have the cake and eat it too.
> 
>> I had thought about whether the IPI FIQ should be disabled when a
>> replacement FIQ handler is installed, I deem it not to be a use case
>> that the mainline kernel needs to be concerned about.
> That would be nice.

Just to be clear, this is exactly the dynamic switching that I mentioned
a couple of mails ago.

As I said such code should not especially hard to write but, with the
current mainline kernel, the code would be unreachable and, as a result,
likely also to be more or less untested.


>>> Yes, but if the FIQ handler is also used for IPI, set_fiq_handler gets IPI
>>> interrupts (with the patch starting this thread)? So i think that the
>>> patch
>>> needs to look like:
>>> --- a/arch/arm/kernel/traps.c
>>> +++ b/arch/arm/kernel/traps.c
>>> @@ -483,6 +483,9 @@ asmlinkage void __exception_irq_entry
>>> handle_fiq_as_nmi(struct pt_regs *regs)
>>> +#ifndef CONFIG_FIQ
>>>
>>>  #ifdef CONFIG_ARM_GIC
>>>  
>>>         gic_handle_fiq_ipi();
>>>  
>>>  #endif
>>>
>>> +#endif
>>
>> No.  With a single zImage kernel, you could very well have SMP and FIQ
>> both enabled, but have a non-SMP platform using FIQ, but also support
>> SMP platforms as well.  Your change prevents that happening.
> Ah, well i have to get used to this "new" devicetree thingy, where one size 
> fits all...
> 
> Still if you boot a single process system which has FIQ available and has a 
> GIC with such a kernel, then you also reprogramm the IPI's as FIQs. But i 
> guess thats not a problem as Linux does not self IPI the kernel as other os'es
> do?


> 
> Best regards
> Tim
> 

