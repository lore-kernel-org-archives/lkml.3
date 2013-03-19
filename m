Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467Ab3CSWt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:49:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51027 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934451Ab3CSWtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:49:25 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355126400"; 
   d="scan'208";a="30804678"
Message-ID: <5148EB74.3020407@codeaurora.org>
Date: Tue, 19 Mar 2013 15:49:24 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Benjamin Gaignard <benjamin.gaignard@stericsson.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: gen_pool_add broken with LPAE based systems
References: <514257B7.5080206@codeaurora.org> <20130319145424.8711f4c1b23fb457d2611007@linux-foundation.org>
In-Reply-To: <20130319145424.8711f4c1b23fb457d2611007@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/2013 2:54 PM, Andrew Morton wrote:
> On Thu, 14 Mar 2013 16:05:27 -0700 Laura Abbott <lauraa@codeaurora.org> wrote:
>
>> Hi,
>>
>> We use genalloc for managing certain pools of physical memory. genalloc
>> currently uses unsigned long for virtual addresses and phys_addr_t for
>> physical addresses. Our ARM LPAE systems have 64-bit physical addresses
>> but unsigned long is still 32 bits.  Using gen_pool_add breaks with
>> addresses > 4G because gen_pool_add treats the address passed in as the
>> virtual address. gen_pool allocates internally based on the 32 bit
>> virtual address as well so everything is broken if we want to be able to
>> manage the full address space after 4G. I see a couple of options:
>
> The above only makes sense if ARM LPAE has 64-bit (actually >= 33-bit)
> virtual addresses.  If so, I don't understand how ARM LPAE can work at
> all - the core MM assumes that addresses-fit-in-ulongs in eleventy
> trillion places.
>
> I think we need a better description of the problem, please.
>

Sorry, let me clarify. ARM LPAE still has 32 bit virtual addresses.

Change 3c8f370ded3483b27f1218ff0051fcf0c7a2facd (lib/genalloc.c: add 
support for specifying the physical address) added support for using 
genalloc to know about both physical addresses and virtual addresses. 
Allocation in gen_pool is still based on the virtual address though.

The problem is we've been using genalloc to allocate physical addresses, 
not virtual ones so allocating and returning an unsigned long breaks 
with sizeof(phys_addr_t) > sizeof(unsigned long). It looks like genalloc 
was added and extended with virtual addresses in mind but apart from the 
address size limitation right now it should be able to work just fine 
for physical addresses.

There seem to be a few other clients scattered about who are using 
genalloc for physical addresses as well (although all are 32 bit systems 
right now)

A better subject would be 'genalloc broken on LPAE systems when used to 
allocate physical addresses instead of virtual addresses'

>> 1) Change gen_pool_add to use physical addresses and allocate based on
>> physical addresses instead of virtual addresses
>> 2) Change the virtual address to be a 64 bit type or something
>> selectable to a 64 bit type.
>> 3) Allow a flag per pool to select whether the allocator is virtual or
>> physical and switch between those.
>> 4) Split the APIs into virtual <-> physical and physical only and have
>> separate types for each.
>>
>> Any of these suggestions seem reasonable or is there another option to
>> consider?
>
> 2) sounds least intrusive but I can't think with my head spinning so fast.
>

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
