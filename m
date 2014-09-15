Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaIOQRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbaIOQRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:17:46 -0400
Message-ID: <541710D5.3030001@redhat.com>
Date: Mon, 15 Sep 2014 12:16:21 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Hanjun Guo <hanjun.guo@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 14/18] ARM64 / ACPI: Add GICv2 specific ACPI boot support
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <1410530416-30200-15-git-send-email-hanjun.guo@linaro.org> <20140915150136.GF5415@arm.com>
In-Reply-To: <20140915150136.GF5415@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 11:01 AM, Catalin Marinas wrote:
> On Fri, Sep 12, 2014 at 03:00:12PM +0100, Hanjun Guo wrote:
>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> index 5b3546b..9869377 100644
>> --- a/arch/arm64/kernel/acpi.c
>> +++ b/arch/arm64/kernel/acpi.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/irqdomain.h>
>>  #include <linux/bootmem.h>
>>  #include <linux/smp.h>
>> +#include <linux/irqchip/arm-gic-acpi.h>
>>  
>>  #include <asm/cputype.h>
>>  #include <asm/cpu_ops.h>
>> @@ -312,6 +313,28 @@ void __init acpi_boot_table_init(void)
>>  		pr_err("Can't find FADT or error happened during parsing FADT\n");
>>  }
>>  
>> +void __init acpi_gic_init(void)
>> +{
>> +	struct acpi_table_header *table;
>> +	acpi_status status;
>> +	acpi_size tbl_size;
>> +	int err;
>> +
>> +	status = acpi_get_table_with_size(ACPI_SIG_MADT, 0, &table, &tbl_size);
>> +	if (ACPI_FAILURE(status)) {
>> +		const char *msg = acpi_format_exception(status);
>> +
>> +		pr_err("Failed to get MADT table, %s\n", msg);
>> +		return;
>> +	}
>> +
>> +	err = gic_v2_acpi_init(table);
>> +	if (err)
>> +		pr_err("Failed to initialize GIC IRQ controller");
>> +
>> +	early_acpi_os_unmap_memory((char *)table, tbl_size);
>> +}
> 
> Maybe this was discussed already but why does this function need to live
> under arch/arm64? Isn't the driver code more appropriate?

Well there's two halves to this, right? There's the MADT parsing/setup,
which is architecture specific, and then there's the GIC irqchip
initialization which lives under drivers.

Jon.

