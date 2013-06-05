Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab3FEBKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 21:10:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:2463 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab3FEBKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 21:10:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,803,1363158000"; 
   d="scan'208";a="348240252"
Message-ID: <51AE8FC7.8090300@intel.com>
Date: Wed, 05 Jun 2013 09:09:27 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/tlb_info: detect more tlb configuration
References: <1370358196-5699-1-git-send-email-kirill.shutemov@linux.intel.com> <20130604150956.05843E0090@blue.fi.intel.com>
In-Reply-To: <20130604150956.05843E0090@blue.fi.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 11:09 PM, Kirill A. Shutemov wrote:
> 
> Kirill A. Shutemov wrote:
>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>>
> 
> Err.. Forgot CC lists.
> 
>> Software Developer’s Manual covers two more TLB configurations:
>>
>> 63H Data TLB: 1 GByte pages, 4-way set associative, 4 entries
>> 76H Instruction TLB: 2M/4M pages, fully associative, 8 entries

Acked-by: Alex Shi <alex.shi@intel.com>

BTW,
What the new CPU has them?

>>
>> Let's detect them as well.
>>
>> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> ---
>>  arch/x86/include/asm/processor.h |    1 +
>>  arch/x86/kernel/cpu/common.c     |    7 ++++---
>>  arch/x86/kernel/cpu/intel.c      |    6 ++++++
>>  3 files changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>> index 3270116..1476a41 100644
>> --- a/arch/x86/include/asm/processor.h
>> +++ b/arch/x86/include/asm/processor.h
>> @@ -72,6 +72,7 @@ extern u16 __read_mostly tlb_lli_4m[NR_INFO];
>>  extern u16 __read_mostly tlb_lld_4k[NR_INFO];
>>  extern u16 __read_mostly tlb_lld_2m[NR_INFO];
>>  extern u16 __read_mostly tlb_lld_4m[NR_INFO];
>> +extern u16 __read_mostly tlb_lld_1g[NR_INFO];
>>  extern s8  __read_mostly tlb_flushall_shift;
>>  
>>  /*
>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index d814772..ee2f15b 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -470,6 +470,7 @@ u16 __read_mostly tlb_lli_4m[NR_INFO];
>>  u16 __read_mostly tlb_lld_4k[NR_INFO];
>>  u16 __read_mostly tlb_lld_2m[NR_INFO];
>>  u16 __read_mostly tlb_lld_4m[NR_INFO];
>> +u16 __read_mostly tlb_lld_1g[NR_INFO];
>>  
>>  /*
>>   * tlb_flushall_shift shows the balance point in replacing cr3 write
>> @@ -484,13 +485,13 @@ void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
>>  	if (this_cpu->c_detect_tlb)
>>  		this_cpu->c_detect_tlb(c);
>>  
>> -	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n" \
>> -		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d\n"	     \
>> +	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n"
>> +		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d, 1GB %d\n"
>>  		"tlb_flushall_shift: %d\n",
>>  		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
>>  		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
>>  		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES],
>> -		tlb_flushall_shift);
>> +		tlb_lld_1g[ENTRIES], tlb_flushall_shift);
>>  }
>>  
>>  void __cpuinit detect_ht(struct cpuinfo_x86 *c)
>> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
>> index 1905ce9..1130519 100644
>> --- a/arch/x86/kernel/cpu/intel.c
>> +++ b/arch/x86/kernel/cpu/intel.c
>> @@ -529,6 +529,8 @@ static const struct _tlb_table intel_tlb_table[] __cpuinitconst = {
>>  	{ 0x5b, TLB_DATA_4K_4M,		64,	" TLB_DATA 4 KByte and 4 MByte pages" },
>>  	{ 0x5c, TLB_DATA_4K_4M,		128,	" TLB_DATA 4 KByte and 4 MByte pages" },
>>  	{ 0x5d, TLB_DATA_4K_4M,		256,	" TLB_DATA 4 KByte and 4 MByte pages" },
>> +	{ 0x63, TLB_DATA_1G,		4,	" TLB_DATA 1 GByte pages, 4-way set associative" },
>> +	{ 0x76, TLB_INST_2M_4M,		8,	" TLB_INST 2-MByte or 4-MByte pages, fully associative" },
>>  	{ 0xb0, TLB_INST_4K,		128,	" TLB_INST 4 KByte pages, 4-way set associative" },
>>  	{ 0xb1, TLB_INST_2M_4M,		4,	" TLB_INST 2M pages, 4-way, 8 entries or 4M pages, 4-way entries" },
>>  	{ 0xb2, TLB_INST_4K,		64,	" TLB_INST 4KByte pages, 4-way set associative" },
>> @@ -606,6 +608,10 @@ static void __cpuinit intel_tlb_lookup(const unsigned char desc)
>>  		if (tlb_lld_4m[ENTRIES] < intel_tlb_table[k].entries)
>>  			tlb_lld_4m[ENTRIES] = intel_tlb_table[k].entries;
>>  		break;
>> +	case TLB_DATA_1G:
>> +		if (tlb_lld_1g[ENTRIES] < intel_tlb_table[k].entries)
>> +			tlb_lld_1g[ENTRIES] = intel_tlb_table[k].entries;
>> +		break;
>>  	}
>>  }
>>  
>> -- 
>> 1.7.10.4
> 


-- 
Thanks
    Alex
