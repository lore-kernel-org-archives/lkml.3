Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaKRSOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:14:03 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13780 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbaKRSOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:14:01 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-cf-546b8c6546ff
Message-id: <546B8C64.3010904@samsung.com>
Date: Tue, 18 Nov 2014 21:13:56 +0300
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Icedove/31.2.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: Re: [PATCH RFC] ARM: option for loading modules into vmalloc area
References: <20141118172146.3784.81151.stgit@buzz>
 <20141118173413.GB4042@n2100.arm.linux.org.uk>
In-reply-to: <20141118173413.GB4042@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xa7qpPdkhBq9uaFhs+/WIzWLT42us
	Fpd3zWGzuH2Z14HFo6W5h81j85J6j74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mq4Mu04Y8F1
	6Yr9T9kbGNeKdjFyckgImEjceLeSHcIWk7hwbz1bFyMXh5DAUkaJG4feQjmfGCUuNSxiBani
	FdCSOH16EksXIwcHi4CqxKk/8iBhNgEziW37bjOC2KICIRJznt5mgigXlPgx+R4LiC0iYCpx
	7dEzZhCbWaBIYsvSU2A1wgJeEqvPzAOrERJIlui7cRfsIE4Ba4nWx3/ZIOptJRa8X8cCYctL
	bF7zlnkCo8AsJCtmISmbhaRsASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQsP26g3Hp
	MatDjAIcjEo8vA0bs0KEWBPLiitzDzFKcDArifAKdmeHCPGmJFZWpRblxxeV5qQWH2Jk4uCU
	amDUeTRRznRO5tXkXZGeX++uzktXU3/PYp/PZfxR66DLr68Tfxtv49j4xtHYbrnzqskb2YPS
	y8pKbsfLyL5IuhX7T6hegL380s+WkHb+iozFGUIKwVanwzTieiN3fXy46+usO8n10/zi7JVm
	LON64md6m/H71O2tOm0/OLgjSne3XuBSEJyU9VKJpTgj0VCLuag4EQCx5Qi9OQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014-11-18 20:34, Russell King - ARM Linux wrote:
> On Tue, Nov 18, 2014 at 08:21:46PM +0400, Konstantin Khlebnikov wrote:
>> Usually modules are loaded into small area prior to the kernel
>> text because they are linked with the kernel using short calls.
>> Compile-time instrumentation like GCOV or KASAN bloats code a lot,
>> and as a result huge modules no longer fit into reserved area.
>>
>> This patch adds option CONFIG_MODULES_USE_VMALLOC which lifts
>> limitation on amount of loaded modules. It links modules using
>> long-calls (option -mlong-calls) and loads them into vmalloc area.
>>
>> In few places exported symbols are called from inline assembly.
>> This patch adds macro for such call sites: __asmbl and __asmbl_clobber.
>> Call turns into single 'bl' or sequence 'movw; movt; blx' depending on
>> context and state of config option.
>>
>> Unfortunately this option isn't compatible with CONFIG_FUNCTION_TRACER.
>> Compiler emits short calls to profiling function despite of -mlong-calls.
>> This is a bug in GCC, but ftrace anyway needs an update to handle this.
> It also isn't compatible with the older architectures which don't have
> "blx".

Ok, I'll add "depends on CPU_V6 || CPU_V7" I don't think that it is 
necessary for older cpus.

>> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
>> index 9d2cdda..9e0c4f4 100644
>> --- a/arch/arm/mm/mmu.c
>> +++ b/arch/arm/mm/mmu.c
>> @@ -1161,16 +1161,15 @@ void __init sanity_check_meminfo(void)
>>   
>>   static inline void prepare_page_table(void)
>>   {
>> -	unsigned long addr;
>> +	unsigned long addr = 0;
>>   	phys_addr_t end;
>>   
>>   	/*
>>   	 * Clear out all the mappings below the kernel image.
>>   	 */
>> -	for (addr = 0; addr < MODULES_VADDR; addr += PMD_SIZE)
>> -		pmd_clear(pmd_off_k(addr));
>> -
>>   #ifdef CONFIG_XIP_KERNEL
>> +	for ( ; addr < MODULES_VADDR; addr += PMD_SIZE)
>> +		pmd_clear(pmd_off_k(addr));
>>   	/* The XIP kernel is mapped in the module area -- skip over it */
>>   	addr = ((unsigned long)_etext + PMD_SIZE - 1) & PMD_MASK;
>>   #endif
> This seems to be an unrelated change.  In any case, it looks wrong to
> me.  Please describe what you are trying to achieve here.
>

My patch changes  MODULES_VADDR, if option enabled it becomes alias for 
VMALLOC_START

It's used as border between two loops, before patch this code looks like:

     /*
      * Clear out all the mappings below the kernel image.
      */
     for (addr = 0; addr < MODULES_VADDR; addr += PMD_SIZE)
         pmd_clear(pmd_off_k(addr));

#ifdef CONFIG_XIP_KERNEL
     /* The XIP kernel is mapped in the module area -- skip over it */
     addr = ((unsigned long)_etext + PMD_SIZE - 1) & PMD_MASK;
#endif
     for ( ; addr < PAGE_OFFSET; addr += PMD_SIZE)
         pmd_clear(pmd_off_k(addr));

It's written with assumption that MODULES_VADDR < PAGE_OFFSET,
but this no longer true if modules are placed inside vmalloc area.


After patch:

     unsigned long addr = 0;

     /*
      * Clear out all the mappings below the kernel image.
      */
#ifdef CONFIG_XIP_KERNEL
     for ( ; addr < MODULES_VADDR; addr += PMD_SIZE)
         pmd_clear(pmd_off_k(addr));
     /* The XIP kernel is mapped in the module area -- skip over it */
     addr = ((unsigned long)_etext + PMD_SIZE - 1) & PMD_MASK;
#endif
     for ( ; addr < PAGE_OFFSET; addr += PMD_SIZE)
         pmd_clear(pmd_off_k(addr));


Without XIP there is no reason for splitting it into two loops.
