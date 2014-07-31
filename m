Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaGaK6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:58:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39393 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaGaK6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:58:39 -0400
Message-ID: <53DA2110.8060000@linaro.org>
Date: Thu, 31 Jul 2014 18:57:20 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
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
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-11-git-send-email-hanjun.guo@linaro.org> <20140731065426.GA876@quad.lixom.net>
In-Reply-To: <20140731065426.GA876@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-7-31 14:54, Olof Johansson wrote:
> Hi,
> 
> On Thu, Jul 24, 2014 at 09:00:16PM +0800, Hanjun Guo wrote:
>> +/*
>> + * In ACPI mode, the cpu possible map was enumerated before SMP
>> + * initialization when MADT table was parsed, so we can get the
>> + * possible map here to initialize CPUs.
>> + */
> 
> The DT smp init will warn if the kernel has been build with too low NR_CPUS.
> Does the ACPI core already warn, or did that go missing with this separate code
> path?

ACPI code will warn, it is in PATCH 07/19,

+	if (enabled_cpus >=  NR_CPUS) {
+		pr_warn("NR_CPUS limit of %d reached, Processor %d/0x%llx ignored.\n",
+			NR_CPUS, total_cpus, mpidr);
+		return -EINVAL;
+	}

> 
>> +static void __init acpi_smp_init_cpus(void)
>> +{
>> +	int cpu;
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		if (cpu_acpi_read_ops(cpu) != 0)
>> +			continue;
>> +
>> +		cpu_ops[cpu]->cpu_init(NULL, cpu);
>> +	}
>> +}
>> +
>> +void __init smp_init_cpus(void)
>> +{
>> +	if (acpi_disabled)
>> +		of_smp_init_cpus();
>> +	else
>> +		acpi_smp_init_cpus();
> 
> I'm liking these deeply split code paths less and less every time I see
> them. :(
> 
> I would prefer to set up shared state in separate functions, but keep the
> control flow the same. Right now you're splitting it completely.
> 
> I.e. split data setup between the two, but do the loop calling cpu_init()
> the same way. (Yes, that will require you to refactor the DT code path
> a bit too...)

OK, I will dive into the code and figure out if I can fix that as you
suggested, thanks for your comments :)

Best Regards
Hanjun
