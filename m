Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaDPFnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:43:49 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40922 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaDPFnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:43:47 -0400
Message-ID: <534E187E.6050908@gmail.com>
Date: Wed, 16 Apr 2014 13:43:26 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, akpm@linux-foundation.org,
        liuj97@gmail.com, rientjes@google.com, dhowells@redhat.com,
        mhocko@suse.cz, mgorman@suse.de, linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFtQQVRDSCB2M10gYXJjaDp1bmljb3JlMzI6bW0=?=
 =?UTF-8?B?OiBhZGQgZGV2bWVtX2lzX2FsbG93ZWQoKSB0byBzdXBwb3J0IFNUUklDVF9ERVY=?=
 =?UTF-8?B?TUVN?=
References: <1834032058.38902.1397625329658.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <1834032058.38902.1397625329658.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 01:15 PM, 管雪涛 wrote:
> Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
> 

OK, thanks.

> ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
>> unicore32 supports STRICT_DEVMEM, so it needs devmem_is_allowed(), like
>> some of other architectures have done (e.g. arm, powerpc, x86 ...).
>>
>> The related error with allmodconfig:
>>
>>     CC      drivers/char/mem.o
>>   drivers/char/mem.c: In function ‘range_is_allowed’:
>>   drivers/char/mem.c:69: error: implicit declaration of function ‘devmem_is_allowed’
>>   make[2]: *** [drivers/char/mem.o] Error 1
>>   make[1]: *** [drivers/char] Error 2
>>   make: *** [drivers] Error 2
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  arch/unicore32/include/asm/io.h |   23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>
>> diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
>> index 39decb6..ae327e4 100644
>> --- a/arch/unicore32/include/asm/io.h
>> +++ b/arch/unicore32/include/asm/io.h
>> @@ -44,5 +44,28 @@ extern void __uc32_iounmap(volatile void __iomem *addr);
>>  #define PIO_MASK		(unsigned int)(IO_SPACE_LIMIT)
>>  #define PIO_RESERVED		(PIO_OFFSET + PIO_MASK + 1)
>>  
>> +#ifdef CONFIG_STRICT_DEVMEM
>> +
>> +#include <linux/ioport.h>
>> +#include <linux/mm.h>
>> +
>> +/*
>> + * devmem_is_allowed() checks to see if /dev/mem access to a certain
>> + * address is valid. The argument is a physical page number.
>> + * We mimic x86 here by disallowing access to system RAM as well as
>> + * device-exclusive MMIO regions. This effectively disable read()/write()
>> + * on /dev/mem.
>> + */
>> +static inline int devmem_is_allowed(unsigned long pfn)
>> +{
>> +	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
>> +		return 0;
>> +	if (!page_is_ram(pfn))
>> +		return 1;
>> +	return 0;
>> +}
>> +
>> +#endif /* CONFIG_STRICT_DEVMEM */
>> +
>>  #endif	/* __KERNEL__ */
>>  #endif	/* __UNICORE_IO_H__ */
>> -- 
>> 1.7.9.5
>>
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
