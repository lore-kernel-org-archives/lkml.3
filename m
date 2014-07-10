Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaGJMSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:18:07 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44273 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaGJMSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:18:04 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-f0-53be84785f79
Message-id: <53BE8333.6060404@samsung.com>
Date: Thu, 10 Jul 2014 16:12:35 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 01/21] Add kernel address sanitizer
 infrastructure.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-2-git-send-email-a.ryabinin@samsung.com>
 <53BDA568.5030607@intel.com>
In-reply-to: <53BDA568.5030607@intel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t/xa7oVLfuCDU62K1j83juT1WLO+jVs
	Fte/vWG0+PTyAaPFhIdt7BYru5vZLLY/e8tksbLzAavFpsfXWC3+7NrBZHF51xw2i3tr/rNa
	3L7Ma3HpwAImi5Z9F5gs2j7/Y7XYt/I8kLVkI5PF4iO3mS3ePZvMbLF501Rmix8bHrM6iHm0
	NPeweeycdZfdY8GmUo/Fe14yeWxa1cnmsenTJHaPrrdXmDzenTvH7nFixm8WjydXpjN5bF5S
	7/Hx6S0Wj/f7rrJ5nFlwhN3j8ya5AP4oLpuU1JzMstQifbsEroz1LcuYCv6zV/ze3cTcwNjE
	1sXIySEhYCIx9e19dghbTOLCvfVAcS4OIYGljBIL1txggXCamSRunpgBVsUroCUx7/tTRhCb
	RUBV4te9X2BxNgE9iX+ztoNNFRWIkDjQ94wVol5Q4sfkeywgtoiAq8SK7lawocwC11kl2i8f
	BhskLBAl0fP8DCPEtgWMEm82LWEGSXAKaErs2vsUrJtZQEdif+s0NghbXmLzmrfMExgFZiFZ
	MgtJ2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihMT3lx2Mi49ZHWIU4GBU4uHV
	qN0dLMSaWFZcmXuIUYKDWUmEN6tuX7AQb0piZVVqUX58UWlOavEhRiYOTqkGxqnKX907vssl
	vHTR372twGjvk68V4Twb5vUIvNp03kNo4YuVS/cHvRAX35Rld33lDLdfEYVbPOTTUnWPBEd+
	uh5XeEaXXcc9izNSc3lHlyZDbkh4W6SB6sGDSdoO65Qdw5SXNisuzXvW5Fy3aZHgqlm582ex
	9ik83rhiR/pTiXkNZ9pcp504oMRSnJFoqMVcVJwIAPcdevfNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/14 00:26, Dave Hansen wrote:
> On 07/09/2014 04:29 AM, Andrey Ryabinin wrote:
>> Address sanitizer dedicates 1/8 of the low memory to the shadow memory and uses direct
>> mapping with a scale and offset to translate a memory address to its corresponding
>> shadow address.
>>
>> Here is function to translate address to corresponding shadow address:
>>
>>      unsigned long kasan_mem_to_shadow(unsigned long addr)
>>      {
>>                 return ((addr - PAGE_OFFSET) >> KASAN_SHADOW_SCALE_SHIFT)
>>                              + kasan_shadow_start;
>>      }
> 
> How does this interact with vmalloc() addresses or those from a kmap()?
> 

It's used only for lowmem:

static inline bool addr_is_in_mem(unsigned long addr)
{
	return likely(addr >= PAGE_OFFSET && addr < (unsigned long)high_memory);
}



static __always_inline void check_memory_region(unsigned long addr,
						size_t size, bool write)
{

	....
	if (!addr_is_in_mem(addr))
		return;
	// check shadow here

