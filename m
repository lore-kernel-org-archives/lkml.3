Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaHSLhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:37:51 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51013 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaHSLhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:37:50 -0400
Message-ID: <53F336AB.80401@linaro.org>
Date: Tue, 19 Aug 2014 19:36:11 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
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
Subject: Re: [PATCH v2 10/18] ARM64 / ACPI: Introduce ACPI_IRQ_MODEL_GIC and
 register device's gsi
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-11-git-send-email-hanjun.guo@linaro.org> <53F2474F.70601@arm.com>
In-Reply-To: <53F2474F.70601@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-19 2:34, Sudeep Holla wrote:
> 
> 
> On 04/08/14 16:28, Hanjun Guo wrote:
>> Introduce ACPI_IRQ_MODEL_GIC which is needed for ARM64 as GIC is
>> used, and then register device's gsi with the core IRQ subsystem.
>>
>> acpi_register_gsi() is similar to DT based irq_of_parse_and_map(),
>> since gsi is unique in the system, so use hwirq number directly
>> for the mapping.
>>
>> Originally-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   arch/arm64/kernel/acpi.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/acpi/bus.c       |    3 ++
>>   include/linux/acpi.h     |    1 +
>>   3 files changed, 77 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> index ac7ab34..621ced8 100644
>> --- a/arch/arm64/kernel/acpi.c
>> +++ b/arch/arm64/kernel/acpi.c
>> @@ -34,6 +34,12 @@ EXPORT_SYMBOL(acpi_pci_disabled);
>>   static int enabled_cpus;    /* Processors (GICC) with enabled flag in MADT */
>>
>>   /*
>> + * Since we're on ARM, the default interrupt routing model
>> + * clearly has to be GIC.
>> + */
>> +enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_GIC;
>> +
>> +/*
>>    * __acpi_map_table() will be called before page_init(), so early_ioremap()
>>    * or early_memremap() should be called here to for ACPI table mapping.
>>    */
>> @@ -169,6 +175,73 @@ static int __init
>> acpi_parse_madt_gic_cpu_interface_entries(void)
>>       return 0;
>>   }
>>
>> +int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
>> +{
>> +    *irq = irq_find_mapping(NULL, gsi);
>> +
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
>> +
>> +/*
>> + * success: return IRQ number (>0)
>> + * failure: return =< 0
>> + */
>> +int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
>> +{
>> +    unsigned int irq;
>> +    unsigned int irq_type;
>> +
>> +    /*
>> +     * ACPI have no bindings to indicate SPI or PPI, so we
>> +     * use different mappings from DT in ACPI.
>> +     *
>> +     * For FDT
>> +     * PPI interrupt: in the range [0, 15];
>> +     * SPI interrupt: in the range [0, 987];
>> +     *
>> +     * For ACPI, GSI should be unique so using
>> +     * the hwirq directly for the mapping:
>> +     * PPI interrupt: in the range [16, 31];
>> +     * SPI interrupt: in the range [32, 1019];
>> +     */
>> +
>> +    if (trigger == ACPI_EDGE_SENSITIVE &&
>> +                polarity == ACPI_ACTIVE_LOW)
>> +        irq_type = IRQ_TYPE_EDGE_FALLING;
>> +    else if (trigger == ACPI_EDGE_SENSITIVE &&
>> +                polarity == ACPI_ACTIVE_HIGH)
>> +        irq_type = IRQ_TYPE_EDGE_RISING;
>> +    else if (trigger == ACPI_LEVEL_SENSITIVE &&
>> +                polarity == ACPI_ACTIVE_LOW)
>> +        irq_type = IRQ_TYPE_LEVEL_LOW;
>> +    else if (trigger == ACPI_LEVEL_SENSITIVE &&
>> +                polarity == ACPI_ACTIVE_HIGH)
>> +        irq_type = IRQ_TYPE_LEVEL_HIGH;
>> +    else
>> +        irq_type = IRQ_TYPE_NONE;
>> +
>> +    /*
>> +     * Since only one GIC is supported in ACPI 5.0, we can
>> +     * create mapping refer to the default domain
>> +     */
>> +    irq = irq_create_mapping(NULL, gsi);
>> +    if (!irq)
>> +        return irq;
>> +
>> +    /* Set irq type if specified and different than the current one */
>> +    if (irq_type != IRQ_TYPE_NONE &&
>> +        irq_type != irq_get_trigger_type(irq))
>> +        irq_set_irq_type(irq, irq_type);
>> +    return irq;
>> +}
>> +EXPORT_SYMBOL_GPL(acpi_register_gsi);
>> +
> 
> Not sure if acpi_gsi_to_irq and acpi_{,un}register_gsi belong here.
> These are GIC specific and should belong to GIC driver IMO.

I think we can keep them here as GSI is ACPI specific and they are
not GIC init related.

Thanks
Hanjun
