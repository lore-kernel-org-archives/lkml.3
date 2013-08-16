Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3HPIsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:48:21 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46597 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab3HPIsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:48:16 -0400
Message-ID: <520DE753.8090601@arm.com>
Date: Fri, 16 Aug 2013 09:48:19 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "microblaze-uclinux@itee.uq.edu.au" 
	<microblaze-uclinux@itee.uq.edu.au>,
        "linux@openrisc.net" <linux@openrisc.net>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH 3/4] powerpc: refactor of_get_cpu_node to support
 other architectures
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>  <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>  <1376586580-5409-4-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376628563.4255.137.camel@pasglop>
In-Reply-To: <1376628563.4255.137.camel@pasglop>
X-OriginalArrivalTime: 16 Aug 2013 08:48:11.0228 (UTC) FILETIME=[5662E1C0:01CE9A5D]
X-MC-Unique: 113081609481401001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/13 05:49, Benjamin Herrenschmidt wrote:
> On Thu, 2013-08-15 at 18:09 +0100, Sudeep KarkadaNagesha wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> Currently different drivers requiring to access cpu device node are
>> parsing the device tree themselves. Since the ordering in the DT need
>> not match the logical cpu ordering, the parsing logic needs to consider
>> that. However, this has resulted in lots of code duplication and in some
>> cases even incorrect logic.
> 
>  .../...
> 
>>  
>> +bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
>> +{
>> +	return (int)phys_id == get_hard_smp_processor_id(cpu);
>> +}
> 
> Naming is a bit gross. You might want to make it clearer that
> we are talking about CPU IDs in the device-tree here.
> 
Any particular preference to the name or just a note is sufficient.
Also unlike PPC, in ARM we don't set hard processor id value based
values read from device tree. DT must contain the values matching to the
hardware ID registers.

>> +static bool __of_find_n_match_cpu_property(struct device_node *cpun,
>> +			const char *prop_name, int cpu, unsigned int *thread)
>> +{
>> +	const __be32 *cell;
>> +	int ac, prop_len, tid;
>> +	u64 hwid;
>> +
>> +	ac = of_n_addr_cells(cpun);
>> +	cell = of_get_property(cpun, prop_name, &prop_len);
>> +	if (!cell)
>> +		return false;
>> +	prop_len /= sizeof(*cell);
>> +	for (tid = 0; tid < prop_len; tid++) {
>> +		hwid = of_read_number(cell, ac);
>> +		if (arch_match_cpu_phys_id(cpu, hwid)) {
>> +			if (thread)
>> +				*thread = tid;
>> +			return true;
>> +		}
> 
> Missing:          cell += ac;
Ah, missed it while refactoring, will fix it. Thanks

Regards,
Sudeep




