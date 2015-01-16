Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbbAPOiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:38:17 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36109 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbbAPOiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:38:14 -0500
Message-ID: <54B92245.6080306@arm.com>
Date: Fri, 16 Jan 2015 14:37:57 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v7 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot support
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-14-git-send-email-hanjun.guo@linaro.org> <54B8F2E3.80306@arm.com> <CACxGe6tBb8L8upS3zenZbrOc_c0E=MA=DqLjkSezEbregaAaaA@mail.gmail.com>
In-Reply-To: <CACxGe6tBb8L8upS3zenZbrOc_c0E=MA=DqLjkSezEbregaAaaA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/15 13:54, Grant Likely wrote:
> On Fri, Jan 16, 2015 at 11:15 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 14/01/15 15:05, Hanjun Guo wrote:
>>> From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>>>
>>> ACPI kernel uses MADT table for proper GIC initialization. It needs to
>>> parse GIC related subtables, collect CPU interface and distributor
>>> addresses and call driver initialization function (which is hardware
>>> abstraction agnostic). In a similar way, FDT initialize GICv1/2.
>>>
>>> NOTE: This commit allow to initialize GICv1/2 basic functionality.
>>> GICv2 vitalization extension, GICv3/4 and ITS are considered as next
>>> steps.
>>
>> And so is GICv2m, apparently (see below).
>>
>>>
>>> Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>> Tested-by: Yijing Wang <wangyijing@huawei.com>
>>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>> ---
>>> +     /*
>>> +      * Initialize zero GIC instance (no multi-GIC support). Also, set GIC
>>> +      * as default IRQ domain to allow for GSI registration and GSI to IRQ
>>> +      * number translation (see acpi_register_gsi() and acpi_gsi_to_irq()).
>>> +      */
>>> +     gic_init_bases(0, -1, dist_base, cpu_base, 0, NULL);
>>
>> I assume you never tried to port the GICv2m driver to ACPI, right?
>> Because the above code actively prevents the GIC domain to be defined as
>> a stacked domain, making it impossible for the v2m widget to be
>> implemented on top of GIC. But maybe legacy interrupts are enough?
> 
> It's sufficient for what is supported right now, and easily changed in
> a patch series to add GICv2m support. This shouldn't be a blocking
> issue as it isn't actively dangerous. It is merely limited, and that
> is okay.
> 
>>> @@ -26,4 +27,6 @@ extern struct of_device_id __irqchip_of_table[];
>>>  void __init irqchip_init(void)
>>>  {
>>>       of_irq_init(__irqchip_of_table);
>>> +
>>> +     acpi_gic_init();
>>
>> Have you realised that this file is probably compiled on multiple
>> architecture, none of which particularly cares about ACPI or the GIC?
>> This is (still) very ugly.
> 
> "very ugly?" That's overstating things a bit. We may quibble about the
> name, but we're just talking about a setup hook function that may or
> may not be implemented. How about we put acpi_irq_init() here and make
> it an inline macro that directly calls acpi_gic_init() when ACPI is
> enabled on AARCH64? Then the function can be extended by architectures
> as needed, and default to an empty inline otherwise. When (if) we have
> more than one hook that needs to be called from it, then we can
> refactor it to be more like of_irq_init().
> 
> As for other architectures calling this function, but not caring about
> ACPI, I believe it was your suggestion to put it here!  :-)
> 
> On Mon, 01 Sep 2014 18:35:18 +0100^M, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 01/09/14 15:57, Hanjun Guo wrote:
>>> @@ -78,6 +79,10 @@ void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
>>>  void __init init_IRQ(void)
>>>  {
>>>     irqchip_init();
>>> +
>>> +   if (!handle_arch_irq)
>>> +           acpi_gic_init();
>>> +
>>
>> Why isn't this called from irqchip_init? It would seem like the logical
>> spot to probe an interrupt controller.
> 
> What has been done here isn't an unusual choice. We've got stuff all
> over the kernel that may or may not be implemented depending on what
> the architecture supports. If the function call is renamed to
> acpi_init_irq(), are you content?

My (full) suggestion was to do it like we've done it for DT, and I don't
think I varied much from this point of view. Yes, calling it
acpi_irq_init() would be a good start, and having the ACPI-compatible
irqchips to be self-probable even better.

<lack-of-sleep-rant>

Hell, if nobody beats me to it, maybe I'll just write that code, with
proper entry points in the various GIC drivers. Yes, this is
infrastructure. Maybe it is grossly overdesigned. But I really spend too
much time dealing with the crap that people are happy to pile on top of
the GIC code to be madly enthusiastic about the general "good enough"
attitude.

</lack-of-sleep-rant>

Or to put it in a slightly more diplomatic way: If ACPI is to be our
future, can we please make the future look a bit better?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
