Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaATJbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:31:10 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44663 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaATJbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:31:06 -0500
Message-ID: <52DCECAD.9090906@linaro.org>
Date: Mon, 20 Jan 2014 17:30:21 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sudeep Holla <Sudeep.Holla@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH 07/20] ARM64 / ACPI: Enable ARM64 in Kconfig
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-8-git-send-email-hanjun.guo@linaro.org> <52D93F88.8090801@arm.com>
In-Reply-To: <52D93F88.8090801@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-1-17 22:34, Sudeep Holla wrote:
> On 17/01/14 12:25, Hanjun Guo wrote:
>> Add Kconfigs to build ACPI on ARM64, and make ACPI runable on ARM64.
>>
>> acpi_idle driver is x86/IA64 dependent now, so make CONFIG_ACPI_PROCESSOR
>> depends on X86 || IA64, and implement it on ARM/ARM64 in the furture.
>>
>> In order to make arm-core.c can both run on ARM and ARM64, introduce
>> CONFIG_ACPI_ARM to support it.
>>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Al Stone <al.stone@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  arch/arm64/Kconfig         |    2 ++
>>  drivers/acpi/Kconfig       |   11 ++++++++---
>>  drivers/acpi/plat/Makefile |    2 +-
>>  3 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 6d4dd22..2b1fb1d 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -279,6 +279,8 @@ source "net/Kconfig"
>>  
>>  source "drivers/Kconfig"
>>  
>> +source "drivers/acpi/Kconfig"
>> +
>>  source "fs/Kconfig"
>>  
>>  source "arch/arm64/kvm/Kconfig"
>> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
>> index 4770de5..cae5dc9 100644
>> --- a/drivers/acpi/Kconfig
>> +++ b/drivers/acpi/Kconfig
>> @@ -2,13 +2,16 @@
>>  # ACPI Configuration
>>  #
>>  
>> +config ACPI_ARM
>> +	bool
>> +
>>  menuconfig ACPI
>>  	bool "ACPI (Advanced Configuration and Power Interface) Support"
>>  	depends on !IA64_HP_SIM
>> -	depends on IA64 || X86
>> -	depends on PCI
>> +	depends on ((IA64 || X86) && PCI) || ARM64
>>  	select PNP
>> -	default y
>> +	select ACPI_ARM if ARM64
>> +	default y if !ARM64
>>  	help
>>  	  Advanced Configuration and Power Interface (ACPI) support for 
>>  	  Linux requires an ACPI-compliant platform (hardware/firmware),
>> @@ -149,6 +152,7 @@ config ACPI_PROCESSOR
>>  	tristate "Processor"
>>  	select THERMAL
>>  	select CPU_IDLE
>> +	depends on X86 || IA64
> 
> This doesn't look correct to me. You are disabling Perf/Idle/Thermal/Throttling
> support for ARM64. Any particular reason ?

As I said in the change log, acpi_idle driver is x86/IA64 dependent now,
we should revisit it later for these drivers on ARM64.

Since this is the ARM ACPI core patches, I think we can implement it later.

> 
> Also this is conflicting with other change where you are adding/exporting
> boot_option_idle_override which is mainly used in processor_idle and that's
> disabled for ARM64 here.

boot_option_idle_override is used in processor_core.c and it is the common
file used by every processor drivers including the processor_idle driver,
if I didn't introduce boot_option_idle_override there will be compile errors.

Thanks
Hanjun
