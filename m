Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaG2Isp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:48:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44827 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaG2Ism convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:48:42 -0400
Message-ID: <53D76006.4040105@arm.com>
Date: Tue, 29 Jul 2014 09:49:10 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Graeme Gregory <graeme.gregory@linaro.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Stone <al.stone@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH 01/19] ARM64 / ACPI: Get RSDP and ACPI boot-time tables
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-2-git-send-email-hanjun.guo@linaro.org> <53D69678.20002@arm.com> <53D6D391.8090907@linaro.org>
In-Reply-To: <53D6D391.8090907@linaro.org>
X-OriginalArrivalTime: 29 Jul 2014 08:48:37.0726 (UTC) FILETIME=[E38567E0:01CFAB09]
X-MC-Unique: 114072909484012201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 28/07/14 23:49, Graeme Gregory wrote:
>
> On 28/07/2014 19:29, Sudeep Holla wrote:
>>
>>
>> On 24/07/14 14:00, Hanjun Guo wrote:
>>> From: Al Stone <al.stone@linaro.org>
>>>
>>> As we want to get ACPI tables to parse and then use the information
>>> for system initialization, we should get the RSDP (Root System
>>> Description Pointer) first, it then locates Extended Root Description
>>> Table (XSDT) which contains all the 64-bit physical address that
>>> pointer to other boot-time tables.
>>>
>>> Introduce acpi.c and its related head file in this patch to provide
>>> fundamental needs of extern variables and functions for ACPI core,
>>> and then get boot-time tables as needed.
>>>     - asm/cpu.h need for ACPI core and will be updated in the future to
>>>       add definitions for arch_(un)register_cpu which are required for
>>>       ACPI based physical CPU hotplug;
>>>     - asm/acenv.h for arch specific ACPICA environments and
>>>       implementation;
>>>     - asm/acpi.h for arch specific variables and functions needed by
>>>       ACPI driver core;
>>>     - acpi.c for ARM64 related ACPI implementation for ACPI driver
>>>       core;
>>>
>>> acpi_boot_table_init() is introduced to get RSDP and boot-time tables,
>>> it will be called in setup_arch() before paging_init(), so we should
>>> use eary_memremap() mechanism here to get the RSDP and all the table
>>> pointers.
>>>
>>> Signed-off-by: Al Stone <al.stone@linaro.org>
>>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>> ---
>>>    arch/arm64/include/asm/acenv.h |   18 ++++++++++
>>>    arch/arm64/include/asm/acpi.h  |   41 ++++++++++++++++++++++
>>>    arch/arm64/include/asm/cpu.h   |   11 ++++++
>>>    arch/arm64/kernel/Makefile     |    1 +
>>>    arch/arm64/kernel/acpi.c       |   76
>>> ++++++++++++++++++++++++++++++++++++++++
>>>    arch/arm64/kernel/setup.c      |    4 +++
>>>    6 files changed, 151 insertions(+)
>>>    create mode 100644 arch/arm64/include/asm/acenv.h
>>>    create mode 100644 arch/arm64/include/asm/acpi.h
>>>    create mode 100644 arch/arm64/include/asm/cpu.h
>>>    create mode 100644 arch/arm64/kernel/acpi.c
>>>

[...]

>>> +
>>> +/*
>>> + * MADT must provide at least one GICC structure
>>> + * for GIC initialization, so CPU will be
>>> + * always available in MADT on ARM64
>>> + */
>>> +static inline bool acpi_has_cpu_in_madt(void)
>>> +{
>>> +       return 1;
>>> +}
>>> +
>>
>> I don't see the user of this function in the series, it's better to
>> remove. Moreover the comment is so misleading. We will have CPU UID
>> not the CPU itself in MADT.
>>
> This is actually required for a patch that is now upstreamed. Comment
> should actually say that its checking for the posibility that the CPU
> can be initialised from the MADT. Its used from core in crash kernel
> case where boot CPU is not necessarily CPU0 like spec demands.
>

Ah OK, I now see that in Rafael's linux-pm/linux-next. Sorry I might have
missed to notice that and I assumed this series is based on mainline.

Regards,
Sudeep

