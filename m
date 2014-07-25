Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbaGYKkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:40:23 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:45062 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914AbaGYKkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:40:21 -0400
Message-ID: <53D233CC.1070006@linaro.org>
Date: Fri, 25 Jul 2014 18:39:08 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/19] ARM64 / ACPI: Move the initialization of cpu_logical_map(0)
 before acpi_boot_init()
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-10-git-send-email-hanjun.guo@linaro.org> <20140724152103.GB26190@leverpostej>
In-Reply-To: <20140724152103.GB26190@leverpostej>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-7-24 23:21, Mark Rutland wrote:
> On Thu, Jul 24, 2014 at 02:00:15PM +0100, Hanjun Guo wrote:
>> Move the initialization of cpu_logical_map(0) before acpi_boot_init()
>> to remove the duplicated initialization of cpu_logical_map(0).
> 
> It always make sense to initialise CPU0's logical map entry from the
> hardware values, so you could do this earlier in the series, before you
> introduce any ACPI code. Then you don't have the churn in acpi.c

ok, I will prepare a separate patch to do this before ACPI code, does it
make sense to you?

> 
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  arch/arm64/kernel/acpi.c  |    3 ---
>>  arch/arm64/kernel/setup.c |    3 ++-
>>  2 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> index 801e268..ff0f6a0 100644
>> --- a/arch/arm64/kernel/acpi.c
>> +++ b/arch/arm64/kernel/acpi.c
>> @@ -244,9 +244,6 @@ int __init acpi_boot_init(void)
>>  	if (err)
>>  		pr_err("Can't find FADT\n");
>>  
>> -	/* Get the boot CPU's MPIDR before MADT parsing */
>> -	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
>> -
>>  	err = acpi_parse_madt_gic_cpu_interface_entries();
>>  
>>  	return err;
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index e00d40c..17ab98e 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -394,13 +394,14 @@ void __init setup_arch(char **cmdline_p)
>>  
>>  	efi_idmap_init();
>>  
>> +	/* Get the boot CPU's MPIDR before cpu logical map is built */
> 
> That comment's a bit useless; I think it can just be dropped.
> 
> All you need to do is move the initialisation of cpu_logical_map(0)
> before unflatten_device_tree(). When you introduce acpi_boot_init(),
> place it after the initialisation.

ok, I agree with you, will update it.

Thanks
Hanjun

