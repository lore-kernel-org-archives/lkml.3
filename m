Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaIJRVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:21:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55709 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaIJRVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:21:08 -0400
Message-ID: <54108881.6070202@arm.com>
Date: Wed, 10 Sep 2014 18:21:05 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 09/11] ARM64: kernel: add support for cpu cache information
References: <1409763617-17074-1-git-send-email-sudeep.holla@arm.com> <1409763617-17074-10-git-send-email-sudeep.holla@arm.com> <20140910164147.GB1710@arm.com>
In-Reply-To: <20140910164147.GB1710@arm.com>
X-OriginalArrivalTime: 10 Sep 2014 17:21:05.0561 (UTC) FILETIME=[9A6BF090:01CFCD1B]
X-MC-Unique: 114091018210603201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

Thanks for having a look this.

On 10/09/14 17:41, Will Deacon wrote:
> Hi Sudeep,
>
> On Wed, Sep 03, 2014 at 06:00:15PM +0100, Sudeep Holla wrote:
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
>
> Out of interest, what's this actually for? Is there something useful in
> userspace that will lap this out of sysfs? If so, it would be great if those
> people could take these patches for a spin.
>

I am not aware how the userspace makes use of this information in
particular. Since it's already part of cacheinfo ABI on other
architectures, I am just making sure we present some sane value deriving
it from DT on ARM{32,64} platforms. For sure lscpu uses it, not aware of
any other application.

>> diff --git a/arch/arm64/kernel/cacheinfo.c b/arch/arm64/kernel/cacheinfo.c
>> new file mode 100644
>> index 000000000000..a9cbf3b40a1f
>> --- /dev/null
>> +++ b/arch/arm64/kernel/cacheinfo.c
>> @@ -0,0 +1,142 @@
>> +/*
>> + *  ARM64 cacheinfo support
>> + *
>> + *  Copyright (C) 2014 ARM Ltd.
>> + *  All Rights Reserved
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/bitops.h>
>> +#include <linux/cacheinfo.h>
>> +#include <linux/cpu.h>
>> +#include <linux/compiler.h>
>> +#include <linux/of.h>
>> +
>> +#include <asm/processor.h>
>> +
>> +#define MAX_CACHE_LEVEL			7	/* Max 7 level supported */
>> +/* Ctypen, bits[3(n - 1) + 2 : 3(n - 1)], for n = 1 to 7 */
>> +#define CLIDR_CTYPE_SHIFT(level)	(3 * (level - 1))
>> +#define CLIDR_CTYPE_MASK(level)		(7 << CLIDR_CTYPE_SHIFT(level))
>> +#define CLIDR_CTYPE(clidr, level)	\
>> +	(((clidr) & CLIDR_CTYPE_MASK(level)) >> CLIDR_CTYPE_SHIFT(level))
>> +
>> +static inline enum cache_type get_cache_type(int level)
>> +{
>> +	u64 clidr;
>> +
>> +	if (level > MAX_CACHE_LEVEL)
>> +		return CACHE_TYPE_NOCACHE;
>> +	asm volatile ("mrs     %x0, clidr_el1" : "=r" (clidr));
>> +	return CLIDR_CTYPE(clidr, level);
>> +}
>> +
>> +/*
>> + * NumSets, bits[27:13] - (Number of sets in cache) - 1
>> + * Associativity, bits[12:3] - (Associativity of cache) - 1
>> + * LineSize, bits[2:0] - (Log2(Number of words in cache line)) - 2
>> + */
>> +#define CCSIDR_WRITE_THROUGH		BIT(31)
>> +#define CCSIDR_WRITE_BACK		BIT(30)
>> +#define CCSIDR_READ_ALLOCATE		BIT(29)
>> +#define CCSIDR_WRITE_ALLOCATE		BIT(28)
>> +#define CCSIDR_LINESIZE_MASK		0x7
>> +#define CCSIDR_ASSOCIATIVITY_SHIFT	3
>> +#define CCSIDR_ASSOCIATIVITY_MASK	0x3FF
>> +#define CCSIDR_NUMSETS_SHIFT		13
>> +#define CCSIDR_NUMSETS_MASK		0x7FF
>> +
>> +/*
>> + * Which cache CCSIDR represents depends on CSSELR value
>> + * Make sure no one else changes CSSELR during this
>> + * smp_call_function_single prevents preemption for us
>> + */
>> +static inline u32 get_ccsidr(u64 csselr)
>> +{
>> +	u64 ccsidr;
>> +
>> +	/* Put value into CSSELR */
>> +	asm volatile("msr csselr_el1, %x0" : : "r" (csselr));
>> +	isb();
>> +	/* Read result out of CCSIDR */
>> +	asm volatile("mrs %x0, ccsidr_el1" : "=r" (ccsidr));
>> +
>> +	return (u32)ccsidr;
>
> Since you're using %x0, can you just make ccsidr a u32?
>

This was suggested by MarkR, I think u32 should be fine for reading back
ccsidr. IIRC his concern was more when writing cssselr as GCC might
leave stale data in upper 32-bit if we use u32 for csselr but had
suggested to change both.

> Also, we have icache_get_ccsidr in kernel/cpuinfo.c already, as well as
> some parsing constants in asm/cachetype.h. Can you try to clean up some of
> the duplication/needless split please? (moving this helper and the #defines
> out would be a good start).
>

Agreed, I know and am already tracking recent changes from Ard, will
clean up the duplication once it hits the mainline.

Regards,
Sudeep

