Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaJTHEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:04:14 -0400
Received: from numascale.com ([213.162.240.84]:56780 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbaJTHEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:04:07 -0400
Message-ID: <5444B3DC.90709@numascale.com>
Date: Mon, 20 Oct 2014 15:03:56 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH v2 5/5] Numachip: use 2GB memory block size
References: <1413683152-31302-1-git-send-email-daniel@numascale.com> <1413683152-31302-5-git-send-email-daniel@numascale.com> <20141019092324.GA10027@gmail.com>
In-Reply-To: <20141019092324.GA10027@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/10/2014 17:23, Ingo Molnar wrote:
>
> * Daniel J Blueman <daniel@numascale.com> wrote:
>
>> Use appropriate memory block size to reduce sysfs entry creation time
>> by 16x.
>>
>> Boot-tested with the four permutations of X86_UV and X86_NUMACHIP.
>>
>> Signed-off-by: Daniel J Blueman <daniel@numascale.com>
>> ---
>>   arch/x86/mm/init_64.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index 5621c47..22ea6de 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -53,6 +53,7 @@
>>   #include <asm/cacheflush.h>
>>   #include <asm/init.h>
>>   #include <asm/uv/uv.h>
>> +#include <asm/numachip/numachip.h>
>>   #include <asm/setup.h>
>>
>>   #include "mm_internal.h"
>> @@ -1235,9 +1236,9 @@ static unsigned long probe_memory_block_size(void)
>>   	/* start from 2g */
>>   	unsigned long bz = 1UL<<31;
>>
>> -#ifdef CONFIG_X86_UV
>> -	if (is_uv_system()) {
>> -		printk(KERN_INFO "UV: memory block size 2GB\n");
>> +#ifdef CONFIG_X86_64
>> +	if (is_uv_system() || is_numachip_system()) {
>> +		pr_info("Memory block size 2GB for large-SMP system\n");
>>   		return 2UL * 1024 * 1024 * 1024;
>
> It would be a lot cleaner and more robust to have a more
> intelligent decision here.
>
> Is there a reliable indicator for large 'sysfs entry creation
> time', such as a lot of RAM present?

Yes, agreed exactly.

> Also, it would be nice to list the pros/cons of this change, an
> advantage is reduced overhead - what are the disadvantages?

The single disadvantage is that small-memory systems won't be able to 
have finer control of memory offlining, though the impact of that depend 
on why the user is offlining memory of course.

If it seems reasonable for x86-64 systems with >64GB memory to have 2GB 
memory block sizes, I could prepare that change instead and document the 
above if preferred?

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
