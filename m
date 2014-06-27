Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaF0LVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:21:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58349 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaF0LVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:21:47 -0400
Message-ID: <53AD53E9.8030105@arm.com>
Date: Fri, 27 Jun 2014 12:22:17 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 7/9] ARM64: kernel: add support for cpu cache information
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1403717444-23559-8-git-send-email-sudeep.holla@arm.com> <20140627103611.GE7262@leverpostej>
In-Reply-To: <20140627103611.GE7262@leverpostej>
X-OriginalArrivalTime: 27 Jun 2014 11:21:44.0604 (UTC) FILETIME=[FA1BBDC0:01CF91F9]
X-MC-Unique: 114062712214514501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for the review.

On 27/06/14 11:36, Mark Rutland wrote:
> Hi Sudeep,
>
> On Wed, Jun 25, 2014 at 06:30:42PM +0100, Sudeep Holla wrote:
>> From: Sudeep Holla <sudeep.holla@arm.com>
>>
>> This patch adds support for cacheinfo on ARM64.
>>
>> On ARMv8, the cache hierarchy can be identified through Cache Level ID
>> (CLIDR) register while the cache geometry is provided by Cache Size ID
>> (CCSIDR) register.
>>
>> Since the architecture doesn't provide any way of detecting the cpus
>> sharing particular cache, device tree is used for the same purpose.
>>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> ---
>>   arch/arm64/kernel/Makefile    |   3 +-
>>   arch/arm64/kernel/cacheinfo.c | 135 ++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 137 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/kernel/cacheinfo.c
>
> [...]
>
>> +static inline enum cache_type get_cache_type(int level)
>> +{
>> +	unsigned int clidr;
>> +
>> +	if (level > MAX_CACHE_LEVEL)
>> +		return CACHE_TYPE_NOCACHE;
>> +	asm volatile ("mrs     %0, clidr_el1" : "=r" (clidr));
>
> Can't that allocate a w register?
>

That should be fine, as all of these cache info registers are 32-bit.

> You can make clidr a u64 to avoid that.
>

What would be the preference ?
Using w registers for all these cache registers or using u64 with x registers?

>> +	return CLIDR_CTYPE(clidr, level);
>> +}
>> +
>> +/*
>> + * NumSets, bits[27:13] - (Number of sets in cache) - 1
>> + * Associativity, bits[12:3] - (Associativity of cache) - 1
>> + * LineSize, bits[2:0] - (Log2(Number of words in cache line)) - 2
>> + */
>> +#define CCSIDR_WRITE_THROUGH	BIT(31)
>> +#define CCSIDR_WRITE_BACK	BIT(30)
>> +#define CCSIDR_READ_ALLOCATE	BIT(29)
>> +#define CCSIDR_WRITE_ALLOCATE	BIT(28)
>> +#define CCSIDR_LINESIZE_MASK	0x7
>> +#define CCSIDR_ASSOCIAT_SHIFT	3
>> +#define CCSIDR_ASSOCIAT_MASK	0x3FF
>
> ASSOCIAT doesn't quite roll off of the tongue...
>

I have no idea why I chose that incomplete name :(

>> +#define CCSIDR_NUMSETS_SHIFT	13
>> +#define CCSIDR_NUMSETS_MASK	0x7FF
>> +
>> +/*
>> + * Which cache CCSIDR represents depends on CSSELR value
>> + * Make sure no one else changes CSSELR during this
>> + * smp_call_function_single prevents preemption for us
>> + */
>> +static inline u32 get_ccsidr(u32 csselr)
>> +{
>> +	u32 ccsidr;
>> +
>> +	/* Put value into CSSELR */
>> +	asm volatile("msr csselr_el1, %x0" : : "r" (csselr));
>
> This looks a little dodgy. I think GCC can leave the upper 32 bits in a
> random state. Why not cast csselr to a u64 here?
>
>> +	isb();
>> +	/* Read result out of CCSIDR */
>> +	asm volatile("mrs %0, ccsidr_el1" : "=r" (ccsidr));
>> +
>> +	return ccsidr;
>
> Similarly it might make sense to make the temporary variable a u64.
>
> [...]
>
>> +int init_cache_level(unsigned int cpu)
>> +{
>> +	unsigned int ctype, level = 1, leaves = 0;
>> +	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
>> +
>> +	if (!this_cpu_ci)
>> +		return -EINVAL;
>> +
>> +	do {
>> +		ctype = get_cache_type(level);
>> +		if (ctype == CACHE_TYPE_NOCACHE)
>> +			break;
>> +		/* Separate instruction and data caches */
>> +		leaves += (ctype == CACHE_TYPE_SEPARATE) ? 2 : 1;
>> +	} while (++level <= MAX_CACHE_LEVEL);
>
> I think this would be clearer with:
>
> for (level = 1; level <= MAX_CACHE_LEVEL; level++)
>
> We do something like that in populate_cache_leaves below.
>

Right will change it.

