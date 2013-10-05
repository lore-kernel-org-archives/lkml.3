Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab3JEGwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 02:52:23 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65449 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3JEGwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 02:52:22 -0400
Message-ID: <524FB719.30502@gmail.com>
Date: Sat, 05 Oct 2013 14:52:09 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        isimatu.yasuaki@jp.fujitsu.com, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] mm/sparsemem: Fix a bug in free_map_bootmem when
 CONFIG_SPARSEMEM_VMEMMAP
References: <524CE4C1.8060508@gmail.com> <524CE532.1030001@gmail.com> <524fa9a0.a5e8420a.188e.5eb1SMTPIN_ADDED_BROKEN@mx.google.com>
In-Reply-To: <524fa9a0.a5e8420a.188e.5eb1SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello wanpeng,

On 10/05/2013 01:54 PM, Wanpeng Li wrote:
> Hi Yanfei,
> On Thu, Oct 03, 2013 at 11:32:02AM +0800, Zhang Yanfei wrote:
>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>>
>> We pass the number of pages which hold page structs of a memory
>> section to function free_map_bootmem. This is right when
>> !CONFIG_SPARSEMEM_VMEMMAP but wrong when CONFIG_SPARSEMEM_VMEMMAP.
>> When CONFIG_SPARSEMEM_VMEMMAP, we should pass the number of pages
>> of a memory section to free_map_bootmem.
>>
>> So the fix is removing the nr_pages parameter. When
>> CONFIG_SPARSEMEM_VMEMMAP, we directly use the prefined marco
>> PAGES_PER_SECTION in free_map_bootmem. When !CONFIG_SPARSEMEM_VMEMMAP,
>> we calculate page numbers needed to hold the page structs for a
>> memory section and use the value in free_map_bootmem.
>>
>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> ---
>> mm/sparse.c |   17 +++++++----------
>> 1 files changed, 7 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index fbb9dbc..908c134 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -603,10 +603,10 @@ static void __kfree_section_memmap(struct page *memmap)
>> 	vmemmap_free(start, end);
>> }
>> #ifdef CONFIG_MEMORY_HOTREMOVE
>> -static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
>> +static void free_map_bootmem(struct page *memmap)
>> {
>> 	unsigned long start = (unsigned long)memmap;
>> -	unsigned long end = (unsigned long)(memmap + nr_pages);
>> +	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
>>
>> 	vmemmap_free(start, end);
>> }
>> @@ -648,11 +648,13 @@ static void __kfree_section_memmap(struct page *memmap)
>> }
>>
>> #ifdef CONFIG_MEMORY_HOTREMOVE
>> -static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
>> +static void free_map_bootmem(struct page *memmap)
>> {
>> 	unsigned long maps_section_nr, removing_section_nr, i;
>> 	unsigned long magic;
>> 	struct page *page = virt_to_page(memmap);
>> +	unsigned long nr_pages = get_order(sizeof(struct page) *
>> +					   PAGES_PER_SECTION);
> 
> Why replace PAGE_ALIGN(XXX) >> PAGE_SHIFT by get_order(XXX)? This will result 
> in memory leak.

oops... I will correct this by sending a new version.

Thanks.


-- 
Thanks.
Zhang Yanfei
