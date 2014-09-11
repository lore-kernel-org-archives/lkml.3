Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaIKLe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:34:56 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:43972 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbaIKLey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140911110846.D152DC408F0@trevor.secretlab.ca>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
 <1409583475-6978-12-git-send-email-hanjun.guo@linaro.org> <20140911110846.D152DC408F0@trevor.secretlab.ca>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 11 Sep 2014 12:34:33 +0100
X-Google-Sender-Auth: zmfRFbL0MIDVdKhtwQvMMjHDArs
Message-ID: <CACxGe6vYKyZu0txFZB+HDJaC3onDfwCvXJ44kWCBcXoqLsTvxQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/17] ARM64 / ACPI: Introduce ACPI_IRQ_MODEL_GIC and
 register device's gsi
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:08 PM, Grant Likely <grant.likely@linaro.org> wrote:
> On Mon,  1 Sep 2014 22:57:49 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
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
>>  arch/arm64/kernel/acpi.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/acpi/bus.c       |    3 ++
>>  include/linux/acpi.h     |    1 +
>>  3 files changed, 77 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> index 35dff11..354b912 100644
>> --- a/arch/arm64/kernel/acpi.c
>> +++ b/arch/arm64/kernel/acpi.c
>> @@ -37,6 +37,12 @@ EXPORT_SYMBOL(acpi_pci_disabled);
>>  static int enabled_cpus;     /* Processors (GICC) with enabled flag in MADT */
>>
>>  /*
>> + * Since we're on ARM, the default interrupt routing model
>> + * clearly has to be GIC.
>> + */
>> +enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_GIC;
>> +
>> +/*
>>   * __acpi_map_table() will be called before page_init(), so early_ioremap()
>>   * or early_memremap() should be called here to for ACPI table mapping.
>>   */
>> @@ -194,6 +200,73 @@ void __init acpi_smp_init_cpus(void)
>>       pr_info("%d CPUs enabled, %d CPUs total\n", enabled_cpus, total_cpus);
>>  }
>>
>> +int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
>> +{
>> +     *irq = irq_find_mapping(NULL, gsi);
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
>
> Why is this exported? x86 exports it, but ia64 does not. There aren't
> very many callers, and none of them can be built as a module AFAICS.
>
>> +
>> +/*
>> + * success: return IRQ number (>0)
>> + * failure: return =< 0
>> + */
>> +int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
>> +{
>> +     unsigned int irq;
>> +     unsigned int irq_type;
>> +
>> +     /*
>> +      * ACPI have no bindings to indicate SPI or PPI, so we
>> +      * use different mappings from DT in ACPI.
>> +      *
>> +      * For FDT
>> +      * PPI interrupt: in the range [0, 15];
>> +      * SPI interrupt: in the range [0, 987];
>> +      *
>> +      * For ACPI, GSI should be unique so using
>> +      * the hwirq directly for the mapping:
>> +      * PPI interrupt: in the range [16, 31];
>> +      * SPI interrupt: in the range [32, 1019];
>> +      */
>
> Hmmm, so doing it this way means that DT systems will have a different
> irq_domain setup compared with ACPI systems. I'm not convinced we want
> to do that, but I need to look at the code that sets up the new domains
> before I comment further...

Okay, nevermind. I looked at the setup code. This isn't an issue of
the irq domain being set up differently, but rather the binding
translation operates differently between DT and ACPI. ACPI used a
single integer encapsulating PPI and SPI which just happens to line up
with the hwirq numbers, whereas DT uses a [type,number] tuple that
needs translating into the hwirq. This code is fine.

g.
