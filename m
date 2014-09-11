Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaIKMBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:01:43 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56652 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaIKMBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:01:42 -0400
Message-ID: <54118F1F.4050501@arm.com>
Date: Thu, 11 Sep 2014 13:01:35 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v3 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot support
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-14-git-send-email-hanjun.guo@linaro.org> <5404AE56.80801@arm.com> <5405AE95.1020201@linaro.org> <20140911114831.E22E6C408F0@trevor.secretlab.ca>
In-Reply-To: <20140911114831.E22E6C408F0@trevor.secretlab.ca>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 11 Sep 2014 12:01:37.0322 (UTC) FILETIME=[23AC88A0:01CFCDB8]
X-MC-Unique: 114091113013802801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 11/09/14 12:48, Grant Likely wrote:
> On Tue, 02 Sep 2014 13:48:37 +0200, Tomasz Nowicki <tomasz.nowicki@linaro.org> wrote:
>> On 01.09.2014 19:35, Marc Zyngier wrote:
>>> On 01/09/14 15:57, Hanjun Guo wrote:
>>>> From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>>>>
>>>> ACPI kernel uses MADT table for proper GIC initialization. It needs to
>>>> parse GIC related subtables, collect CPU interface and distributor
>>>> addresses and call driver initialization function (which is hardware
>>>> abstraction agnostic). In a similar way, FDT initialize GICv1/2.
>>>>
>>>> NOTE: This commit allow to initialize GICv1/2 only.
>>>
>>> I cannot help but notice that there is no support for KVM here. It'd be
>>> good to add a note to that effect, so that people do not expect
>>> virtualization support to be working when booting with ACPI.
>>
>> yes, it is worth mentioning!
>>
>>>
>>>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>>> ---
>>>>   arch/arm64/include/asm/acpi.h        |    2 -
>>>>   arch/arm64/kernel/acpi.c             |   23 +++++++
>>>>   arch/arm64/kernel/irq.c              |    5 ++
>>>>   drivers/irqchip/irq-gic.c            |  114 ++++++++++++++++++++++++++++++++++
>>>>   include/linux/irqchip/arm-gic-acpi.h |   33 ++++++++++
>>>>   5 files changed, 175 insertions(+), 2 deletions(-)
>>>>   create mode 100644 include/linux/irqchip/arm-gic-acpi.h
>>>>
>>>> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
>>>> index a867467..5d2ab63 100644
>>>> --- a/arch/arm64/include/asm/acpi.h
>>>> +++ b/arch/arm64/include/asm/acpi.h
>>>> @@ -97,8 +97,6 @@ void __init acpi_smp_init_cpus(void);
>>>>   extern int (*acpi_suspend_lowlevel)(void);
>>>>   #define acpi_wakeup_address 0
>>>>
>>>> -#define ACPI_MAX_GIC_CPU_INTERFACE_ENTRIES 65535
>>>> -
>>>>   #else
>>>>
>>>>   static inline bool acpi_psci_present(void) { return false; }
>>>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>>>> index 354b912..b3b82b0 100644
>>>> --- a/arch/arm64/kernel/acpi.c
>>>> +++ b/arch/arm64/kernel/acpi.c
>>>> @@ -23,6 +23,7 @@
>>>>   #include <linux/irqdomain.h>
>>>>   #include <linux/bootmem.h>
>>>>   #include <linux/smp.h>
>>>> +#include <linux/irqchip/arm-gic-acpi.h>
>>>>
>>>>   #include <asm/cputype.h>
>>>>   #include <asm/cpu_ops.h>
>>>> @@ -313,6 +314,28 @@ void __init acpi_boot_table_init(void)
>>>>   		pr_err("Can't find FADT or error happened during parsing FADT\n");
>>>>   }
>>>>
>>>> +void __init acpi_gic_init(void)
>>>> +{
>>>> +	struct acpi_table_header *table;
>>>> +	acpi_status status;
>>>> +	acpi_size tbl_size;
>>>> +	int err;
>>>> +
>>>> +	status = acpi_get_table_with_size(ACPI_SIG_MADT, 0, &table, &tbl_size);
>>>> +	if (ACPI_FAILURE(status)) {
>>>> +		const char *msg = acpi_format_exception(status);
>>>> +
>>>> +		pr_err("Failed to get MADT table, %s\n", msg);
>>>> +		return;
>>>> +	}
>>>> +
>>>> +	err = gic_v2_acpi_init(table);
>>>> +	if (err)
>>>> +		pr_err("Failed to initialize GIC IRQ controller");
>>>
>>> What will happen when you get to implement GICv3 support? Another entry
>>> like this? Why isn't this entirely contained in the GIC driver? Do I
>>> sound like a stuck record?
>>
>> There will be another call to GICv3 init:
>> [...]
>> 	err = gic_v3_acpi_init(table);
>> 	if (err)
>> 		err = gic_v2_acpi_init(table);
>> 	if (err)
>> 		pr_err("Failed to initialize GIC IRQ controller");
>> [...]
>> This is the main reason I put common code here.
>>
>>>
>>>> +
>>>> +	early_acpi_os_unmap_memory((char *)table, tbl_size);
>>>> +}
>>>> +
>>>>   /*
>>>>    * acpi_suspend_lowlevel() - save kernel state and suspend.
>>>>    *
>>>> diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
>>>> index 0f08dfd..c074d60 100644
>>>> --- a/arch/arm64/kernel/irq.c
>>>> +++ b/arch/arm64/kernel/irq.c
>>>> @@ -28,6 +28,7 @@
>>>>   #include <linux/irqchip.h>
>>>>   #include <linux/seq_file.h>
>>>>   #include <linux/ratelimit.h>
>>>> +#include <linux/irqchip/arm-gic-acpi.h>
>>>>
>>>>   unsigned long irq_err_count;
>>>>
>>>> @@ -78,6 +79,10 @@ void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
>>>>   void __init init_IRQ(void)
>>>>   {
>>>>   	irqchip_init();
>>>> +
>>>> +	if (!handle_arch_irq)
>>>> +		acpi_gic_init();
>>>> +
>>>
>>> Why isn't this called from irqchip_init? It would seem like the logical
>>> spot to probe an interrupt controller.
>>
>> irqchip.c is OF dependent, I want to decouple these from the very 
>> beginning.
> 
> It doesn't have to be that way, but given that ARM64 is the only
> platform in the foreseeable future that will use ACPI irq setup, it
> doesn't make sense to put it in there.

I have a different perspective. There is no reason to pollute the arch
code with something that is essentially platform specific.

irqchip_init is the logical place to probe for an irqchip, and I fail to
see the point of sticking this code somewhere else. Why would ACPI be so
special that it requires additional hooks in the arch code?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

