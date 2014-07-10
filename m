Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaGJP6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:58:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:25852 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbaGJP6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:58:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,638,1400050800"; 
   d="scan'208";a="541506619"
Message-ID: <53BEB77A.6020003@intel.com>
Date: Thu, 10 Jul 2014 08:55:38 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org
CC: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
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
Subject: Re: [RFC/PATCH RESEND -next 01/21] Add kernel address sanitizer infrastructure.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1404905415-9046-2-git-send-email-a.ryabinin@samsung.com> <53BDA568.5030607@intel.com> <53BE8333.6060404@samsung.com>
In-Reply-To: <53BE8333.6060404@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 05:12 AM, Andrey Ryabinin wrote:
> On 07/10/14 00:26, Dave Hansen wrote:
>> On 07/09/2014 04:29 AM, Andrey Ryabinin wrote:
>>> Address sanitizer dedicates 1/8 of the low memory to the shadow memory and uses direct
>>> mapping with a scale and offset to translate a memory address to its corresponding
>>> shadow address.
>>>
>>> Here is function to translate address to corresponding shadow address:
>>>
>>>      unsigned long kasan_mem_to_shadow(unsigned long addr)
>>>      {
>>>                 return ((addr - PAGE_OFFSET) >> KASAN_SHADOW_SCALE_SHIFT)
>>>                              + kasan_shadow_start;
>>>      }
>>
>> How does this interact with vmalloc() addresses or those from a kmap()?
>> 
> It's used only for lowmem:
> 
> static inline bool addr_is_in_mem(unsigned long addr)
> {
> 	return likely(addr >= PAGE_OFFSET && addr < (unsigned long)high_memory);
> }

That's fine, and definitely covers the common cases.  Could you make
sure to call this out explicitly?  Also, there's nothing to _keep_ this
approach working for things out of the direct map, right?  It would just
be a matter of updating the shadow memory to have entries for the other
virtual address ranges.

addr_is_in_mem() is a pretty bad name for what it's doing. :)

I'd probably call it something like kasan_tracks_vaddr().
