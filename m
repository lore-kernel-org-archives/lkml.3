Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3LCAtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 19:49:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49399 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3LCAtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 19:49:15 -0500
Message-ID: <529D2A6F.5050607@ti.com>
Date: Mon, 2 Dec 2013 19:48:47 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <tj@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH 09/24] mm/memblock: Add memblock memory allocation apis
References: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com> <1383954120-24368-10-git-send-email-santosh.shilimkar@ti.com> <20131202163136.f31f39c5940c0ba6d20f4a00@linux-foundation.org>
In-Reply-To: <20131202163136.f31f39c5940c0ba6d20f4a00@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 December 2013 07:31 PM, Andrew Morton wrote:
> On Fri, 8 Nov 2013 18:41:45 -0500 Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> 
>> Introduce memblock memory allocation APIs which allow to support
>> PAE or LPAE extension on 32 bits archs where the physical memory start
>> address can be beyond 4GB. In such cases, existing bootmem APIs which
>> operate on 32 bit addresses won't work and needs memblock layer which
>> operates on 64 bit addresses.
>>
>> So we add equivalent APIs so that we can replace usage of bootmem
>> with memblock interfaces. Architectures already converted to NO_BOOTMEM
>> use these new interfaces and other which still uses bootmem, these new
>> APIs just fallback to exiting bootmem APIs. So no functional change as
>> such.
>>
>> In long run, once all the achitectures moves to NO_BOOTMEM, we can get rid of
>> bootmem layer completely. This is one step to remove the core code dependency
>> with bootmem and also gives path for architectures to move away from bootmem.
>>
>> The proposed interface will became active if both CONFIG_HAVE_MEMBLOCK
>> and CONFIG_NO_BOOTMEM are specified by arch. In case !CONFIG_NO_BOOTMEM,
>> the memblock() wrappers will fallback to the existing bootmem apis so
>> that arch's not converted to NO_BOOTMEM continue to work as is.
>>
>> The meaning of MEMBLOCK_ALLOC_ACCESSIBLE and MEMBLOCK_ALLOC_ANYWHERE is
>> kept same.
>>
>> ...
>>
>> +static void * __init _memblock_virt_alloc_try_nid_nopanic(
>> +				phys_addr_t size, phys_addr_t align,
>> +				phys_addr_t from, phys_addr_t max_addr,
>> +				int nid)
>> +{
>> +	phys_addr_t alloc;
>> +	void *ptr;
>> +
>> +	if (WARN_ON_ONCE(slab_is_available())) {
>> +		if (nid == MAX_NUMNODES)
>> +			return kzalloc(size, GFP_NOWAIT);
>> +		else
>> +			return kzalloc_node(size, GFP_NOWAIT, nid);
>> +	}
> 
> The use of MAX_NUMNODES is a bit unconventional here.  I *think* we
> generally use NUMA_NO_NODE to indicate "don't care".  I Also *think*
> that if this code did s/MAX_NUMNODES/NUMA_NO_NODE/g then the above
> simply becomes
> 
> 	return kzalloc_node(size, GFP_NOWAIT, nid);
> 
> and kzalloc_node() handles NUMA_NO_NODE appropriately.
> 
> I *think* ;)  Please check all this.
> 
I guess same comment was given by Tejun as well. We didn't
address that in this series mainly because when NO_BOOTMEM
are not enabled, all calls of the new APIs will
be redirected to bootmem  where MAX_NUMNODES is used.

Also, memblock core APIs __next_free_mem_range_rev() and
__next_free_mem_range() would need to be updated, and as result
we will need to re-check/update all direct calls of
memblock_alloc_xxx() APIs (including nobootmem).

So to keep behavior consistent with and without NO_BOOTMEM, we
used MAX_NUMNODES. Once we get a stage where we can remove
the bootmem.c, it should be easy to update the code
to use NUMA_NO_NODE without too much churn.

Regards,
Santosh
