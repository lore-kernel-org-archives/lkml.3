Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab3LEPha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:37:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41919 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab3LEPh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:37:29 -0500
Message-ID: <52A0AB34.2030703@ti.com>
Date: Thu, 5 Dec 2013 18:35:00 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mm@kvack.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 08/23] mm/memblock: Add memblock memory allocation
 apis
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com> <1386037658-3161-9-git-send-email-santosh.shilimkar@ti.com> <20131203232445.GX8277@htj.dyndns.org>
In-Reply-To: <20131203232445.GX8277@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 12/04/2013 01:24 AM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Dec 02, 2013 at 09:27:23PM -0500, Santosh Shilimkar wrote:
>> So we add equivalent APIs so that we can replace usage of bootmem
>> with memblock interfaces. Architectures already converted to NO_BOOTMEM
>> use these new interfaces and other which still uses bootmem, these new
>> APIs just fallback to exiting bootmem APIs. So no functional change as
>> such.
> 
> The last part of the second last sentence doesn't parse too well.  I
> think it'd be worthwhile to improve and preferably expand on it as
> this is a bit tricky to understand given the twisted state of early
> memory allocation.
> 
>> In long run, once all the achitectures moves to NO_BOOTMEM, we can get rid of
>> bootmem layer completely. This is one step to remove the core code dependency
>> with bootmem and also gives path for architectures to move away from bootmem.
> 
> Lines too long?
> 

[...]

> 
>> +/* FIXME: Move to memblock.h at a point where we remove nobootmem.c */
>> +void *memblock_virt_alloc_try_nid_nopanic(phys_addr_t size,
>> +		phys_addr_t align, phys_addr_t from,
>> +		phys_addr_t max_addr, int nid);
> 
> Wouldn't @min_addr instead of @from make more sense?  Ditto for other
> occurrences.
> 
>> +void *memblock_virt_alloc_try_nid(phys_addr_t size, phys_addr_t align,
>> +		phys_addr_t from, phys_addr_t max_addr, int nid);
>> +void __memblock_free_early(phys_addr_t base, phys_addr_t size);
>> +void __memblock_free_late(phys_addr_t base, phys_addr_t size);
>> +
>> +#define memblock_virt_alloc(x) \
>> +	memblock_virt_alloc_try_nid(x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT, \
>> +				     BOOTMEM_ALLOC_ACCESSIBLE, MAX_NUMNODES)
> 
> The underlying function interprets 0 as the default align, so it
> probably is a better idea to just use 0 here.
> 
>> +#define memblock_virt_alloc_align(x, align) \
>> +	memblock_virt_alloc_try_nid(x, align, BOOTMEM_LOW_LIMIT, \
>> +				     BOOTMEM_ALLOC_ACCESSIBLE, MAX_NUMNODES)
> 
> Also, do we really need this align variant separate when the caller
> can simply specify 0 for the default?

Unfortunately Yes. 
We need it to keep compatibility with bootmem/nobootmem
which don't handle 0 as default align value.

> 
>> +#define memblock_virt_alloc_nopanic(x) \
>> +	memblock_virt_alloc_try_nid_nopanic(x, SMP_CACHE_BYTES, \
>> +					     BOOTMEM_LOW_LIMIT, \
>> +					     BOOTMEM_ALLOC_ACCESSIBLE, \
>> +					     MAX_NUMNODES)
>> +#define memblock_virt_alloc_align_nopanic(x, align) \
>> +	memblock_virt_alloc_try_nid_nopanic(x, align, \
>> +					     BOOTMEM_LOW_LIMIT, \
>> +					     BOOTMEM_ALLOC_ACCESSIBLE, \
>> +					     MAX_NUMNODES)
>> +#define memblock_virt_alloc_node(x, nid) \
>> +	memblock_virt_alloc_try_nid(x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT, \
>> +				     BOOTMEM_ALLOC_ACCESSIBLE, nid)
>> +#define memblock_virt_alloc_node_nopanic(x, nid) \

Regards,
- grygorii

