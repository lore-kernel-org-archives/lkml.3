Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaILJmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:42:53 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43174 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaILJmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:42:49 -0400
Message-ID: <5412C006.6060207@linaro.org>
Date: Fri, 12 Sep 2014 17:42:30 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v3 11/17] ARM64 / ACPI: Introduce ACPI_IRQ_MODEL_GIC and
 register device's gsi
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-12-git-send-email-hanjun.guo@linaro.org> <20140911110846.D152DC408F0@trevor.secretlab.ca>
In-Reply-To: <20140911110846.D152DC408F0@trevor.secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月11日 19:08, Grant Likely wrote:
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
>>  static int enabled_cpus;	/* Processors (GICC) with enabled flag in MADT */
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
>>  	pr_info("%d CPUs enabled, %d CPUs total\n", enabled_cpus, total_cpus);
>>  }
>>  
>> +int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
>> +{
>> +	*irq = irq_find_mapping(NULL, gsi);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
> Why is this exported? x86 exports it, but ia64 does not. There aren't
> very many callers, and none of them can be built as a module AFAICS.

It will be called by Generic Hardware Error Source driver which
can be built as module, and it provides a way to report platform
hardware errors (such as that from chipset) which can also used
by ARM platform, so I think we can keep it as exported.

Thanks
Hanjun
