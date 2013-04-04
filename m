Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3DDBMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 21:12:01 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53416 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab3DDBMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 21:12:00 -0400
Message-ID: <515CD359.40004@gmail.com>
Date: Thu, 04 Apr 2013 09:11:53 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com
Subject: Re: [PATCH] x86: add phys addr validity check for /dev/mem mmap
References: <1364905733-23937-1-git-send-email-fhrbata@redhat.com> <515B2802.1050405@zytor.com>
In-Reply-To: <515B2802.1050405@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H.Peter,
On 04/03/2013 02:48 AM, H. Peter Anvin wrote:
> On 04/02/2013 05:28 AM, Frantisek Hrbata wrote:
>> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
>> index d8e8eef..39607c6 100644
>> --- a/arch/x86/include/asm/io.h
>> +++ b/arch/x86/include/asm/io.h
>> @@ -242,6 +242,10 @@ static inline void flush_write_buffers(void)
>>   #endif
>>   }
>>   
>> +#define ARCH_HAS_VALID_PHYS_ADDR_RANGE
>> +extern int valid_phys_addr_range(phys_addr_t addr, size_t count);
>> +extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t count);
>> +
>>   #endif /* __KERNEL__ */
>>   
>>   extern void native_io_delay(void);
>> diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
>> index 845df68..92ec31c 100644
>> --- a/arch/x86/mm/mmap.c
>> +++ b/arch/x86/mm/mmap.c
>> @@ -31,6 +31,8 @@
>>   #include <linux/sched.h>
>>   #include <asm/elf.h>
>>   
>> +#include "physaddr.h"
>> +
>>   struct __read_mostly va_alignment va_align = {
>>   	.flags = -1,
>>   };
>> @@ -122,3 +124,14 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
>>   		mm->unmap_area = arch_unmap_area_topdown;
>>   	}
>>   }
>> +
>> +int valid_phys_addr_range(phys_addr_t addr, size_t count)
>> +{
>> +	return addr + count <= __pa(high_memory);
>> +}
>> +
>> +int valid_mmap_phys_addr_range(unsigned long pfn, size_t count)
>> +{
>> +	resource_size_t addr = (pfn << PAGE_SHIFT) + count;
>> +	return phys_addr_valid(addr);
>> +}
>>

Why we consider boot_cpu_data.x86_phys_bits instead of e820 map here?

>
> 	-hpa
>

