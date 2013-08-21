Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3HUACT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:02:19 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:49117 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab3HUACS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:02:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130820160735.b12fe1b3dd64b4dc146d2fa0@linux-foundation.org>
References: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<1376981696-4312-2-git-send-email-liwanp@linux.vnet.ibm.com>
	<20130820160735.b12fe1b3dd64b4dc146d2fa0@linux-foundation.org>
Date: Tue, 20 Aug 2013 17:02:17 -0700
X-Google-Sender-Auth: Pe60AQIn4LkPEo5SLkbOHxSa6Gk
Message-ID: <CAE9FiQVy2uqLm2XyStYmzxSmsw7TzrB0XDhCRLymnf+L3NPxrA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm/sparse: introduce alloc_usemap_and_memmap
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiri Kosina <jkosina@suse.cz>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 4:07 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 20 Aug 2013 14:54:54 +0800 Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
>
>> v1 -> v2:
>>  * add comments to describe alloc_usemap_and_memmap
>>
>> After commit 9bdac91424075("sparsemem: Put mem map for one node together."),
>> vmemmap for one node will be allocated together, its logic is similar as
>> memory allocation for pageblock flags. This patch introduce alloc_usemap_and_memmap
>> to extract the same logic of memory alloction for pageblock flags and vmemmap.
>>
>
> 9bdac91424075 was written by Yinghai.  He is an excellent reviewer, as
> long as people remember to cc him!

could be that he forgot to use scripts/get_maintainer.pl

or get_maintainer.pl has some problem.

>
>> ---
>>  mm/sparse.c | 140 ++++++++++++++++++++++++++++--------------------------------
>>  1 file changed, 66 insertions(+), 74 deletions(-)
>>
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index 308d503..d27db9b 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -439,6 +439,14 @@ static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
>>                                        map_count, nodeid);
>>  }
>>  #else
>> +
>> +static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
>> +                             unsigned long pnum_begin,
>> +                             unsigned long pnum_end,
>> +                             unsigned long map_count, int nodeid)
>> +{
>> +}
>> +
...
could be avoided, if passing function pointer instead.

>>  static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
>>  {
>>       struct page *map;
>> @@ -460,6 +468,62 @@ void __attribute__((weak)) __meminit vmemmap_populate_print_last(void)
>>  {
>>  }
>>
>> +/**
>> + *  alloc_usemap_and_memmap - memory alloction for pageblock flags and vmemmap
>> + *  @map: usemap_map for pageblock flags or mmap_map for vmemmap
>> + *  @use_map: true if memory allocated for pageblock flags, otherwise false
>> + */
>> +static void alloc_usemap_and_memmap(unsigned long **map, bool use_map)
...
>> @@ -471,11 +535,7 @@ void __init sparse_init(void)
>>       unsigned long *usemap;
>>       unsigned long **usemap_map;
>>       int size;
...
>> -     /* ok, last chunk */
>> -     sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, NR_MEM_SECTIONS,
>> -                                      usemap_count, nodeid_begin);
>> +     alloc_usemap_and_memmap(usemap_map, true);

alloc_usemap_and_memmap() is somehow confusing.

Please check if you can pass function pointer instead of true/false.

Thanks

Yinghai
