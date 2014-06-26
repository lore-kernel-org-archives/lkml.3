Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbaFZLct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:32:49 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36920 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbaFZLcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:32:47 -0400
Message-ID: <53AC04FA.4060303@arm.com>
Date: Thu, 26 Jun 2014 12:33:14 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 8/9] ARM: kernel: add support for cpu cache information
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1403717444-23559-9-git-send-email-sudeep.holla@arm.com> <20140625223302.GL32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140625223302.GL32514@n2100.arm.linux.org.uk>
X-OriginalArrivalTime: 26 Jun 2014 11:32:35.0155 (UTC) FILETIME=[53743230:01CF9132]
X-MC-Unique: 114062612324600301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Thanks for the reviews.

On 25/06/14 23:33, Russell King - ARM Linux wrote:
> On Wed, Jun 25, 2014 at 06:30:43PM +0100, Sudeep Holla wrote:
[...]
>> +
>> +#include <linux/bitops.h>
>> +#include <linux/cacheinfo.h>
>> +#include <linux/cpu.h>
>> +#include <linux/compiler.h>
>> +#include <linux/of.h>
>> +
>> +#include <asm/cputype.h>
>> +#include <asm/processor.h>
>> +
>> +#if __LINUX_ARM_ARCH__ < 7 /* pre ARMv7 */
>
> __LINUX_ARM_ARCH__ defines the minimum architecture version we are building
> for - we may support later versions than the architecture version denoted
> by this symbol.  It does not define which CPUs we are building for.  Are
> you sure that this is correct here?  What if we build a kernel supporting
> both v6 + v7, as the OMAP guys do?
>

You are right, I have not considered v6 + v7, I will use cpu_architecture and
make it runtime.

>> +
>> +#define MAX_CACHE_LEVEL		1	/* Only 1 level supported */
>> +#define CTR_CTYPE_SHIFT		24
>> +#define CTR_CTYPE_MASK		(1 << CTR_CTYPE_SHIFT)
>> +
>> +struct ctr_info {
>> +	unsigned int cpuid_id;
>> +	unsigned int ctr;
>> +};
>> +
>> +static struct ctr_info cache_ctr_list[] = {
>> +};
>
> This list needs to be populated.  Early CPUs (such as StrongARM) do not
> have the CTR register.
>

Right, since I didn't have the list left it empty. I will compile the list
soon but I need your help. The list of StrongARM I can come up is:
1. SA-110
2. SA-1100
3. SA-1110
4. SA-1500 (grep didn't show this in kernel, not sure if it's supported)

I also have to find all other ARMv4 implementations not having CTR.

>> +static int get_unimplemented_ctr(unsigned int *ctr)
>> +{
>> +	int i, cpuid_id = read_cpuid_id();
>> +
>> +	for (i = 0; i < ARRAY_SIZE(cache_ctr_list); i++)
>> +		if (cache_ctr_list[i].cpuid_id == cpuid_id) {
>> +			*ctr = cache_ctr_list[i].ctr;
>> +			return 0;
>> +		}
>> +	return -ENOENT;
>> +}
>> +
>> +static unsigned int get_ctr(void)
>> +{
>> +	unsigned int ctr;
>> +
>> +	if (get_unimplemented_ctr(&ctr))
>> +		asm volatile ("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
>
> read_cpuid_cachetype() ?
>
Ah, I missed to see that, will use it.

Regards,
Sudeep

