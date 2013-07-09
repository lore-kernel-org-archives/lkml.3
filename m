Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3GIHvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:51:19 -0400
Received: from mail1.windriver.com ([147.11.146.13]:42567 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3GIHvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:51:16 -0400
Message-ID: <51DBC118.6030100@windriver.com>
Date: Tue, 9 Jul 2013 15:51:52 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bhushan Bharat-R65777 <R65777@freescale.com>
CC: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2][PATCH 4/7] book3e/kexec/kdump: introduce a kexec kernel
 flag
References: <1371714797-7898-1-git-send-email-tiejun.chen@windriver.com> <1371714797-7898-5-git-send-email-tiejun.chen@windriver.com> <6A3DF150A5B70D4F9B66A25E3F7C888D070947A5@039-SN2MPN1-011.039d.mgd.msft.net>
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D070947A5@039-SN2MPN1-011.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.214]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 01:37 PM, Bhushan Bharat-R65777 wrote:
>
>
>> -----Original Message-----
>> From: Linuxppc-dev [mailto:linuxppc-dev-
>> bounces+bharat.bhushan=freescale.com@lists.ozlabs.org] On Behalf Of Tiejun Chen
>> Sent: Thursday, June 20, 2013 1:23 PM
>> To: benh@kernel.crashing.org
>> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
>> Subject: [v2][PATCH 4/7] book3e/kexec/kdump: introduce a kexec kernel flag
>>
>> We need to introduce a flag to indicate we're already running
>> a kexec kernel then we can go proper path. For example, We
>> shouldn't access spin_table from the bootloader to up any secondary
>> cpu for kexec kernel, and kexec kernel already know how to jump to
>> generic_secondary_smp_init.
>>
>> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
>> ---

[snip]

>> +++ b/arch/powerpc/platforms/85xx/smp.c
>> @@ -150,6 +150,9 @@ static int __cpuinit smp_85xx_kick_cpu(int nr)
>>   	int hw_cpu = get_hard_smp_processor_id(nr);
>>   	int ioremappable;
>>   	int ret = 0;
>> +#if defined(CONFIG_KEXEC) || defined(CONFIG_CRASH_DUMP)
>> +	unsigned long *ptr;
>> +#endif
>
> What about if we can remove the ifdef around *ptr ...
>
>>
>>   	WARN_ON(nr < 0 || nr >= NR_CPUS);
>>   	WARN_ON(hw_cpu < 0 || hw_cpu >= NR_CPUS);
>> @@ -238,11 +241,22 @@ out:
>>   #else
>>   	smp_generic_kick_cpu(nr);
>>
>> +#if defined(CONFIG_KEXEC) || defined(CONFIG_CRASH_DUMP)
>> +	ptr  = (unsigned long *)((unsigned long)&__run_at_kexec);
>
> ... #endif here ...
>
>> +	/* We shouldn't access spin_table from the bootloader to up any
>> +	 * secondary cpu for kexec kernel, and kexec kernel already
>> +	 * know how to jump to generic_secondary_smp_init.
>> +	 */
>> +	if (!*ptr) {
>> +#endif
>
> ... remove #endif ...
>
>>   	flush_spin_table(spin_table);
>>   	out_be32(&spin_table->pir, hw_cpu);
>>   	out_be64((u64 *)(&spin_table->addr_h),
>>   	  __pa((u64)*((unsigned long long *)generic_secondary_smp_init)));
>>   	flush_spin_table(spin_table);
>> +#if defined(CONFIG_KEXEC) || defined(CONFIG_CRASH_DUMP)
>> +	}
>> +#endif
>
> --- remove above 3 lines

I'd like to try to address your comments next version.

Thanks

Tiejun
