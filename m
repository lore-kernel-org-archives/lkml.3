Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3GPJDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:03:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46232 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3GPJDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:03:14 -0400
Message-ID: <51E50C59.50900@arm.com>
Date: Tue, 16 Jul 2013 10:03:21 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Subject: Re: [RFC PATCH 02/11] ARM: DT/kernel: define ARM specific arch_of_get_cpu_node
References: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1373883732-26303-3-git-send-email-Sudeep.KarkadaNagesha@arm.com> <51E44943.7000600@gmail.com>
In-Reply-To: <51E44943.7000600@gmail.com>
X-OriginalArrivalTime: 16 Jul 2013 09:03:09.0388 (UTC) FILETIME=[4AECF8C0:01CE8203]
X-MC-Unique: 113071610031102701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/13 20:10, Rob Herring wrote:
> On 07/15/2013 05:22 AM, Sudeep.KarkadaNagesha@arm.com wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> CPU subsystem now provides architecture specific hook to retrieve the
>> of_node. Most of the cpu DT node parsing and initialisation is contained
>> in devtree.c. It's better to contain all CPU device node parsing there.
>>
>> arch_of_get_cpu_node is mainly used to assign cpu->of_node when CPUs get
>> registered. This patch overrides the defination of the same. It can also
>> act as the helper function in pre-SMP/early initialisation stages to
>> retrieve CPU device node pointers in logical ordering.
>>
>> This mainly helps to avoid replication of the code doing CPU node parsing
>> and physical(MPIDR) to logical mapping.
>>
>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> [snip]
> 
>> +struct device_node * __init arch_of_get_cpu_node(int cpu)
>> +{
>> +	struct device_node *cpun, *cpus;
>> +	const u32 *cell;
>> +	u64 hwid;
>> +	int ac;
>> +
>> +	cpus = of_find_node_by_path("/cpus");
>> +	if (WARN(!cpus, "Missing cpus node, bailing out\n"))
>> +		return NULL;
>> +
>> +	if (WARN_ON(of_property_read_u32(cpus, "#address-cells", &ac)))
>> +		ac = of_n_addr_cells(cpus);
>> +
>> +	for_each_child_of_node(cpus, cpun) {
>> +		if (of_node_cmp(cpun->type, "cpu"))
>> +			continue;
>> +		cell = of_get_property(cpun, "reg", NULL);
>> +		if (WARN(!cell, "%s: missing reg property\n", cpun->full_name))
>> +			continue;
>> +
>> +		hwid = of_read_number(cell, ac);
>> +		if ((hwid & MPIDR_HWID_BITMASK) == cpu_logical_map(cpu))
> 
> Most of this function is not ARM specific, so it would be nice if we
> could shrink the arch specific part down to just this match. A default
> match of reg == logical cpu number might be useful.
> 
I completely agree, in fact that was my initial idea too.

But when I had a look at powerpc implementation of "of_get_cpu_node" in
arch/powerpc/kernel/prom.c, it looked like PPC is using some
compatibles(e.g. ibm,ppc-interrupt-server#s) which are not specified in
ePAPR. I am not sure is that's allowed or not, if allowed then we can't
have generic of_get_cpu_node with just arch specific hwid matching function.

Let me know how would you prefer me to proceed on this.

Regards,
Sudeep

