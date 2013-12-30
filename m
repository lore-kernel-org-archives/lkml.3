Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3L3LQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:16:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41518 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab3L3LQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:16:50 -0500
Message-ID: <52C1635D.9070703@ti.com>
Date: Mon, 30 Dec 2013 14:13:17 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <akpm@linux-foundation.org>, <tj@kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] mm/memblock: use WARN_ONCE when MAX_NUMNODES passed as
 input parameter
References: <1387578536-18280-1-git-send-email-santosh.shilimkar@ti.com> <alpine.DEB.2.02.1312261542260.9342@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1312261542260.9342@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2013 01:45 AM, David Rientjes wrote:
> On Fri, 20 Dec 2013, Santosh Shilimkar wrote:
>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 71b11d9..6af873a 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -707,11 +707,9 @@ void __init_memblock __next_free_mem_range(u64 *idx, int nid,
>>   	struct memblock_type *rsv = &memblock.reserved;
>>   	int mi = *idx & 0xffffffff;
>>   	int ri = *idx >> 32;
>> -	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
>>
>> -	if (nid == MAX_NUMNODES)
>> -		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
>> -			     __func__);
>> +	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
>> +		nid = NUMA_NO_NODE;
>>
>>   	for ( ; mi < mem->cnt; mi++) {
>>   		struct memblock_region *m = &mem->regions[mi];
>
> Um, why do this at runtime?  This is only used for
> for_each_free_mem_range(), which is used rarely in x86 and memblock-only
> code.  I'm struggling to understand why we can't deterministically fix the
> callers if this condition is possible.
>


Unfortunately, It's not so simple as from first look :(
We've modified __next_free_mem_range_x() functions which are part of
Memblock APIs (like memblock_alloc_xxx()) and Nobootmem APIs.
These APIs are used as directly as indirectly (as part of callbacks from 
other MM modules like Sparse), as result, it's not trivial to identify 
all places where MAX_NUMNODES will be used as input parameter.

Same was discussed here in details:
- [PATCH v2 08/23] mm/memblock: Add memblock memory allocation apis
   https://lkml.org/lkml/2013/12/2/1075
- Re: [PATCH 09/24] mm/memblock: Add memblock memory allocation apis
   https://lkml.org/lkml/2013/12/2/907

Regards,
- grygorii

