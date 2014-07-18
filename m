Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419AbaGRJ4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:56:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:38640 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934148AbaGRJ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:56:28 -0400
Message-ID: <53C8EF3E.1090706@huawei.com>
Date: Fri, 18 Jul 2014 17:56:14 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
CC: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        "Mel Gorman" <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Pei Feiyue" <peifeiyue@huawei.com>, <linux-mm@kvack.org>,
        <x86@kernel.org>, <linux-ia64@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-sh@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] memory-hotplug: suitable memory should go to ZONE_MOVABLE
References: <1405670163-53747-1-git-send-email-wangnan0@huawei.com> <53C8E602.1060301@cn.fujitsu.com>
In-Reply-To: <53C8E602.1060301@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/18 17:16, Zhang Yanfei wrote:
> Hello,
> 
> On 07/18/2014 03:55 PM, Wang Nan wrote:
>> This series of patches fix a problem when adding memory in bad manner.
>> For example: for a x86_64 machine booted with "mem=400M" and with 2GiB
>> memory installed, following commands cause problem:
>>
>>  # echo 0x40000000 > /sys/devices/system/memory/probe
>> [   28.613895] init_memory_mapping: [mem 0x40000000-0x47ffffff]
>>  # echo 0x48000000 > /sys/devices/system/memory/probe
>> [   28.693675] init_memory_mapping: [mem 0x48000000-0x4fffffff]
>>  # echo online_movable > /sys/devices/system/memory/memory9/state
>>  # echo 0x50000000 > /sys/devices/system/memory/probe 
>> [   29.084090] init_memory_mapping: [mem 0x50000000-0x57ffffff]
>>  # echo 0x58000000 > /sys/devices/system/memory/probe 
>> [   29.151880] init_memory_mapping: [mem 0x58000000-0x5fffffff]
>>  # echo online_movable > /sys/devices/system/memory/memory11/state
>>  # echo online> /sys/devices/system/memory/memory8/state
>>  # echo online> /sys/devices/system/memory/memory10/state
>>  # echo offline> /sys/devices/system/memory/memory9/state
>> [   30.558819] Offlined Pages 32768
>>  # free
>>              total       used       free     shared    buffers     cached
>> Mem:        780588 18014398509432020     830552          0          0      51180
>> -/+ buffers/cache: 18014398509380840     881732
>> Swap:            0          0          0
>>
>> This is because the above commands probe higher memory after online a
>> section with online_movable, which causes ZONE_HIGHMEM (or ZONE_NORMAL
>> for systems without ZONE_HIGHMEM) overlaps ZONE_MOVABLE.
> 
> Yeah, this is rare in reality but can happen. Could you please also
> include the free result and zoneinfo after applying your patch?
> 
> Thanks.
> 

OK.

I paste the free result and zoneinfo at the end of this mail. This is a x86_64 result,
generated on qemu, after applying my patches.

I only tested x86_64 and x86_32 (and found a typo). Could any one can help me verify
other platforms?

Thanks.

>>
>> After the second online_movable, the problem can be observed from
>> zoneinfo:
>>
>>  # cat /proc/zoneinfo
>> ...
>> Node 0, zone  Movable
>>   pages free     65491
>>         min      250
>>         low      312
>>         high     375
>>         scanned  0
>>         spanned  18446744073709518848
>>         present  65536
>>         managed  65536
>> ...
>>
>> This series of patches solve the problem by checking ZONE_MOVABLE when
>> choosing zone for new memory. If new memory is inside or higher than
>> ZONE_MOVABLE, makes it go there instead.
>>
>>
>> Wang Nan (5):
>>   memory-hotplug: x86_64: suitable memory should go to ZONE_MOVABLE
>>   memory-hotplug: x86_32: suitable memory should go to ZONE_MOVABLE
>>   memory-hotplug: ia64: suitable memory should go to ZONE_MOVABLE
>>   memory-hotplug: sh: suitable memory should go to ZONE_MOVABLE
>>   memory-hotplug: powerpc: suitable memory should go to ZONE_MOVABLE
>>
>>  arch/ia64/mm/init.c   |  7 +++++++
>>  arch/powerpc/mm/mem.c |  6 ++++++
>>  arch/sh/mm/init.c     | 13 ++++++++-----
>>  arch/x86/mm/init_32.c |  6 ++++++
>>  arch/x86/mm/init_64.c | 10 ++++++++--
>>  5 files changed, 35 insertions(+), 7 deletions(-)
>>
> 
> 

After applying the above patches, here is the free result and zoneinfo (after offline memory9):

bash-4.2# free
             total       used       free     shared    buffers     cached
Mem:        780588      80860     699728          0          0      51180
-/+ buffers/cache:      29680     750908
Swap:            0          0          0

bash-4.2# cat /proc/zoneinfo

Node 0, zone      DMA
  pages free     3272
        min      14
        low      17
        high     21
        scanned  0
        spanned  4095
        present  3998
        managed  3977
    nr_free_pages 3272
...
  start_pfn:         1
  inactive_ratio:    1
Node 0, zone    DMA32
  pages free     73548
        min      341
        low      426
        high     511
        scanned  0
        spanned  98304
        present  98304
        managed  92866
    nr_free_pages 73548
...
  start_pfn:         4096
  inactive_ratio:    1
Node 0, zone   Normal
  pages free     32630
        min      120
        low      150
        high     180
        scanned  0
        spanned  32768
        present  32768
        managed  32768
    nr_free_pages 32630
...
  start_pfn:         262144
  inactive_ratio:    1
Node 0, zone  Movable
  pages free     65491
        min      241
        low      301
        high     361
        scanned  0
        spanned  98304
        present  65536
        managed  65536
    nr_free_pages 65491
...
  start_pfn:         294912
  inactive_ratio:    1


