Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab3LDPjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:39:12 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33911 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3LDPjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:39:11 -0500
Message-ID: <529F4C90.4070402@linaro.org>
Date: Wed, 04 Dec 2013 23:38:56 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Linaro Patches <patches@linaro.org>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC part2 PATCH 7/9] irqdomain: Add a new API irq_create_acpi_mapping()
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org> <1386088753-2850-8-git-send-email-hanjun.guo@linaro.org> <CAL_JsqK93mJbFu+GaK_5L14jKnMgctUNdEBqS6K5zKer16Sm3Q@mail.gmail.com>
In-Reply-To: <CAL_JsqK93mJbFu+GaK_5L14jKnMgctUNdEBqS6K5zKer16Sm3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月04日 01:25, Rob Herring wrote:
> On Tue, Dec 3, 2013 at 10:39 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>> From: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>
>> This patch introduces a new API for acpi based irq mapping.
>>
>> [hanjun: Rework this patch to delete the reference to
>> gic_irq_domain_xlate() which can simplify the code a lot.]
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   include/linux/acpi.h   |    2 ++
>>   kernel/irq/irqdomain.c |   27 +++++++++++++++++++++++++++
>>   2 files changed, 29 insertions(+)
>>
>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
>> index 1e6a0ac..edd5806 100644
>> --- a/include/linux/acpi.h
>> +++ b/include/linux/acpi.h
>> @@ -141,6 +141,8 @@ int acpi_map_lsapic(acpi_handle handle, int physid, int *pcpu);
>>   int acpi_unmap_lsapic(int cpu);
>>   #endif /* CONFIG_ACPI_HOTPLUG_CPU */
>>
>> +unsigned int irq_create_acpi_mapping(irq_hw_number_t hwirq,
>> +                                        unsigned int type);
>>   int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
>>   int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
>>   void acpi_irq_stats_init(void);
>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>> index cf68bb3..c661552 100644
>> --- a/kernel/irq/irqdomain.c
>> +++ b/kernel/irq/irqdomain.c
>> @@ -501,6 +501,33 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>>   }
>>   EXPORT_SYMBOL_GPL(irq_create_of_mapping);
>>
>> +#ifdef CONFIG_ACPI
>> +unsigned int irq_create_acpi_mapping(irq_hw_number_t hwirq,
>> +                                       unsigned int type)
>> +{
>> +       struct irq_domain *domain;
>> +       unsigned int virq;
>> +
>> +       domain = irq_default_domain;
>> +       if (!domain) {
>> +               pr_warn("no irq domain found !\n");
>> +               return 0;
>> +       }
>> +
>> +       /* Create mapping */
>> +       virq = irq_create_mapping(domain, hwirq);
>> +       if (!virq)
>> +               return virq;
>> +
>> +       /* Set type if specified and different than the current one */
>> +       if (type != IRQ_TYPE_NONE &&
>> +           type != irq_get_trigger_type(virq))
>> +               irq_set_irq_type(virq, type);
>> +       return virq;
>> +}
>> +EXPORT_SYMBOL_GPL(irq_create_acpi_mapping);
> There is nothing ACPI specific about this function. This is simply
> irq_create_of_mapping w/o translating of_phandle_args to a hwirq and
> type. So I expect the code to be re-factored here to mirror that.

Sorry for my bad english, do you mean create a OF free function
and call that from the OF function ?

Thanks
Hanjun
