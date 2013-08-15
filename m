Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab3HOO7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:59:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35819 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab3HOO7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:59:16 -0400
Message-ID: <520CECC5.7080802@arm.com>
Date: Thu, 15 Aug 2013 15:59:17 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v3 01/16] of: add support for retrieving cpu node for
 a given logical cpu index
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-2-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1403722.mOLJEHt2Ii@flatron>
In-Reply-To: <1403722.mOLJEHt2Ii@flatron>
X-OriginalArrivalTime: 15 Aug 2013 14:59:11.0622 (UTC) FILETIME=[0033B260:01CE99C8]
X-MC-Unique: 113081515591307301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/13 12:32, Tomasz Figa wrote:
> Hi Sudeep,
> 
> I don't like this constant DT parsing every time a node of given CPU is 
> required, but I believe it was correctly discussed with people that are 
> more into CPU topologies and similar things than me. (My idea would be to 
> make a lookup array with logical ID to struct device_node * mapping.)
> 
Yes that's the idea, see the last paragraph in the commit log.

> Let me just review this from DT parsing perspective.
> 
> On Monday 22 of July 2013 12:32:12 Sudeep KarkadaNagesha wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> Currently different drivers requiring to access cpu device node are
>> parsing the device tree themselves. Since the ordering in the DT need
>> not match the logical cpu ordering, the parsing logic needs to consider
>> that. However, this has resulted in lots of code duplication and in some
>> cases even incorrect logic.
>>
>> It's better to consolidate them by adding support for getting cpu
>> device node for a given logical cpu index in DT core library. However
>> logical to physical index mapping can be architecture specific.
>>
>> This patch adds of_get_cpu_node to retrieve a cpu device node for a
>> given logical cpu index. The default matching of the physical id to the
>> logical cpu index can be overridden by architecture specific code.
>>
>> It is recommended to use these helper function only in pre-SMP/early
>> initialisation stages to retrieve CPU device node pointers in logical
>> ordering. Once the cpu devices are registered, it can be retrieved
>> easily from cpu device of_node which avoids unnecessary parsing and
>> matching.
>>
Here we go, do I need to emphasis this recommendation more ?

>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>> ---
>>  drivers/of/base.c  | 72
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>> include/linux/of.h |  6 +++++
>>  2 files changed, 78 insertions(+)
>>
>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>> index 5c54279..1e690bf 100644
>> --- a/drivers/of/base.c
>> +++ b/drivers/of/base.c
>> @@ -230,6 +230,78 @@ const void *of_get_property(const struct
>> device_node *np, const char *name, }
>>  EXPORT_SYMBOL(of_get_property);
>>
>> +/*
>> + * arch_match_cpu_phys_id - Match the given logical CPU and physical id
>> + *
>> + * @cpu: logical index of a cpu
>> + * @phys_id: physical identifier of a cpu
>> + *
>> + * CPU logical to physical index mapping is architecture specific.
>> + * However this __weak function provides a default match of physical
>> + * id to logical cpu index.
>> + *
>> + * Returns true if the physical identifier and the logical index
>> correspond + * to the same cpu, false otherwise.
>> + */
>> +bool __weak arch_match_cpu_phys_id(int cpu, u64 phys_id)
>> +{
>> +	return (u32)phys_id == cpu;
>> +}
>> +
>> +/**
>> + * of_get_cpu_node - Get device node associated with the given logical
>> CPU + *
>> + * @cpu: CPU number(logical index) for which device node is required
>> + *
>> + * The main purpose of this function is to retrieve the device node for
>> the + * given logical CPU index. It should be used to intialize the
>> of_node in + * cpu device. Once of_node in cpu device is populated, all
>> the further + * references can use that instead.
>> + *
>> + * CPU logical to physical index mapping is architecture specific and
>> is built + * before booting secondary cores. This function uses
>> arch_match_cpu_phys_id + * which can be overridden by architecture
>> specific implementation. + *
>> + * Returns a node pointer for the logical cpu if found, else NULL.
>> + */
>> +struct device_node *of_get_cpu_node(int cpu)
>> +{
>> +	struct device_node *cpun, *cpus;
>> +	const __be32 *cell;
>> +	u64 hwid;
>> +	int ac, prop_len;
>> +
>> +	cpus = of_find_node_by_path("/cpus");
>> +	if (!cpus) {
>> +		pr_warn("Missing cpus node, bailing out\n");
>> +		return NULL;
>> +	}
>> +
>> +	if (of_property_read_u32(cpus, "#address-cells", &ac)) {
>> +		pr_warn("%s: missing #address-cells\n", cpus->full_name);
>> +		ac = of_n_addr_cells(cpus);
> 
> I'm not sure this fallback is appropriate. According to ePAPR:
> 
> "The #address-cells and #size-cells properties are not inherited from 
> ancestors in the device tree. They shall be explicitly defined."
> 
> In addition:
> 
> If missing, a client program should assume a default value of 2 for 
> #address-cells, and a value of 1 for #size-cells.
> 
> This also leaves in question the correctness of of_n_addr_cells() and 
> of_n_size_cells().
> 
Yes agreed. We can discus that and fix it separately as it might affect
multiple users.

>> +	}
>> +
>> +	for_each_child_of_node(cpus, cpun) {
>> +		if (of_node_cmp(cpun->type, "cpu"))
>> +			continue;
>> +		cell = of_get_property(cpun, "reg", &prop_len);
>> +		if (!cell) {
>> +			pr_warn("%s: missing reg property\n", cpun-
>> full_name);
>> +			continue;
>> +		}
>> +		prop_len /= sizeof(*cell);
>> +		while (prop_len) {
>> +			hwid = of_read_number(cell, ac);
>> +			prop_len -= ac;
>> +			if (arch_match_cpu_phys_id(cpu, hwid))
>> +				return cpun;
> 
> This is a nice potential infinite loop. Consider following example:
> 
Good point, but based on the other discussion recently with PPC guys to
support thread ids, I have changed this loop differently, it should not
have this issue.

Regards,
Sudeep

> cpus {
> 	#address-cells = <2>; /* A typo. Should be 1. */
> 	#size-cells = <0>;
> 
> 	cpu@0 {
> 		/* ... */
> 		reg = <0>;
> 	};
> };
> 
> In this case prop_len will start with 1, while ac will be 2. After first 
> iteration of the loop (when the phys id doesn't match) you will end up 
> with prop_len = -1 and each iteration will decrement it even more.
> 
> By the way, I'm not sure why the whole loop is here. IMHO it should be 
> something like:
> 
> 	if (prop_len != ac) {
> 		pr_warn(...); // or whatever
> 		continue;
> 	}
> 
> 	hwid = of_read_number(cell, ac);
> 	// ...
> 
> Best regards,
> Tomasz
> 


