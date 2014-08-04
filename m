Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaHDJ6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:58:15 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41089 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaHDJ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:58:10 -0400
Message-ID: <53DF58CD.9000704@linaro.org>
Date: Mon, 04 Aug 2014 17:56:29 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Geoff Levand <geoff@infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH 10/19] ARM64 / ACPI: Get the enable method for SMP initialization
 in ACPI way
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-11-git-send-email-hanjun.guo@linaro.org> <20140731065426.GA876@quad.lixom.net> <53DA2110.8060000@linaro.org>
In-Reply-To: <53DA2110.8060000@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On 2014-7-31 18:57, Hanjun Guo wrote:
> On 2014-7-31 14:54, Olof Johansson wrote:
[...]
>>> +static void __init acpi_smp_init_cpus(void)
>>> +{
>>> +	int cpu;
>>> +
>>> +	for_each_possible_cpu(cpu) {
>>> +		if (cpu_acpi_read_ops(cpu) != 0)
>>> +			continue;
>>> +
>>> +		cpu_ops[cpu]->cpu_init(NULL, cpu);
>>> +	}
>>> +}
>>> +
>>> +void __init smp_init_cpus(void)
>>> +{
>>> +	if (acpi_disabled)
>>> +		of_smp_init_cpus();
>>> +	else
>>> +		acpi_smp_init_cpus();
>>
>> I'm liking these deeply split code paths less and less every time I see
>> them. :(
>>
>> I would prefer to set up shared state in separate functions, but keep the
>> control flow the same. Right now you're splitting it completely.
>>
>> I.e. split data setup between the two, but do the loop calling cpu_init()
>> the same way. (Yes, that will require you to refactor the DT code path
>> a bit too...)
> 
> OK, I will dive into the code and figure out if I can fix that as you
> suggested, thanks for your comments :)

After some investigation of the code, it seems that it is pretty hard
to do so, the major gap to do that is DT needs the device node of CPU
to init CPUs, but ACPI just needs the logical CPU number. In DT mode,
it needs to search the DT and get the CPU device node to get its enable
method, but in ACPI mode, it is a flag to indicate the CPU enable (boot)
method.

the code can be modified as below, but the logic is the same:

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 40f38f4..71a625b 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -320,6 +320,17 @@ void __init smp_init_cpus(void)
        unsigned int i, cpu = 1;
        bool bootcpu_valid = false;

+       if (!acpi_disabled) {
+               for_each_possible_cpu(cpu) {
+                       if (cpu_read_ops(NULL, cpu) != 0)
+                               continue;
+
+                       cpu_ops[cpu]->cpu_init(NULL, cpu);
+               }
+
+               return;
+       }
+
        while ((dn = of_find_node_by_type(dn, "cpu"))) {
                const u32 *cell;
                u64 hwid;

Does it make sense to you?

Thanks
Hanjun
