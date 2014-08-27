Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaH0DYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 23:24:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43285 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaH0DYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 23:24:22 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53FD4F12.6010500@jp.fujitsu.com>
Date: Wed, 27 Aug 2014 12:22:58 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Toshi Kani <toshi.kani@hp.com>,
        David Rientjes <rientjes@google.com>, <wangnan0@huawei.com>,
        <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] memory-hotplug: fix not enough check of valid_zones
References: <1409046575-11025-1-git-send-email-zhenzhang.zhang@huawei.com> <53FC5A04.9070300@huawei.com> <53FC6009.1010308@jp.fujitsu.com> <53FD3A74.4020008@huawei.com>
In-Reply-To: <53FD3A74.4020008@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/27 10:55), Zhang Zhen wrote:
> On 2014/8/26 18:23, Yasuaki Ishimatsu wrote:
>> (2014/08/26 18:57), Zhang Zhen wrote:
>>> As Yasuaki Ishimatsu described the check here is not enough
>>> if memory has hole as follows:
>>>
>>> PFN       0x00          0xd0          0xe0          0xf0
>>>                +-------------+-------------+-------------+
>>> zone type   |   Normal    |     hole    |   Normal    |
>>>                +-------------+-------------+-------------+
>>> In this case, the check can't guarantee that this is "the last
>>> block of memory".
>>> The check of ZONE_MOVABLE has the same problem.
>>>
>>> Change the interface name to valid_zones according to most pepole's
>>> suggestion.
>>>
>>> Sample output of the sysfs files:
>>>      memory0/valid_zones: none
>>>      memory1/valid_zones: DMA32
>>>      memory2/valid_zones: DMA32
>>>      memory3/valid_zones: DMA32
>>>      memory4/valid_zones: Normal
>>>      memory5/valid_zones: Normal
>>>      memory6/valid_zones: Normal Movable
>>>      memory7/valid_zones: Movable Normal
>>>      memory8/valid_zones: Movable
>>
>> The patch has two changes:
>>   - change sysfs interface name
>>   - change check of ZONE_MOVABLE
>> So please separate them.
>>
> Ok, i will separate them.
>
> Thanks!
>>> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
>>> ---
>>>    Documentation/ABI/testing/sysfs-devices-memory |  8 ++---
>>>    Documentation/memory-hotplug.txt               |  4 +--
>>>    drivers/base/memory.c                          | 42 ++++++--------------------
>>>    3 files changed, 15 insertions(+), 39 deletions(-)
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
>>> index 2b2a1d7..deef3b5 100644
>>> --- a/Documentation/ABI/testing/sysfs-devices-memory
>>> +++ b/Documentation/ABI/testing/sysfs-devices-memory
>>> @@ -61,13 +61,13 @@ Users:        hotplug memory remove tools
>>>            http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
>>>
>>>
>>> -What:           /sys/devices/system/memory/memoryX/zones_online_to
>>> +What:           /sys/devices/system/memory/memoryX/valid_zones
>>>    Date:           July 2014
>>>    Contact:    Zhang Zhen <zhenzhang.zhang@huawei.com>
>>>    Description:
>>> -        The file /sys/devices/system/memory/memoryX/zones_online_to
>>> -        is read-only and is designed to show which zone this memory block can
>>> -        be onlined to.
>>> +        The file /sys/devices/system/memory/memoryX/valid_zones    is
>>> +        read-only and is designed to show which zone this memory
>>> +        block can be onlined to.
>>>
>>>    What:        /sys/devices/system/memoryX/nodeY
>>>    Date:        October 2009
>>> diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
>>> index 5b34e33..947229c 100644
>>> --- a/Documentation/memory-hotplug.txt
>>> +++ b/Documentation/memory-hotplug.txt
>>> @@ -155,7 +155,7 @@ Under each memory block, you can see 4 files:
>>>    /sys/devices/system/memory/memoryXXX/phys_device
>>>    /sys/devices/system/memory/memoryXXX/state
>>>    /sys/devices/system/memory/memoryXXX/removable
>>> -/sys/devices/system/memory/memoryXXX/zones_online_to
>>> +/sys/devices/system/memory/memoryXXX/valid_zones
>>>
>>>    'phys_index'      : read-only and contains memory block id, same as XXX.
>>>    'state'           : read-write
>>> @@ -171,7 +171,7 @@ Under each memory block, you can see 4 files:
>>>                        block is removable and a value of 0 indicates that
>>>                        it is not removable. A memory block is removable only if
>>>                        every section in the block is removable.
>>> -'zones_online_to' : read-only: designed to show which zone this memory block
>>> +'valid_zones' : read-only: designed to show which zone this memory block
>>>                can be onlined to.
>>>
>>>    NOTE:
>>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>>> index ccaf37c..efd456c 100644
>>> --- a/drivers/base/memory.c
>>> +++ b/drivers/base/memory.c
>>> @@ -374,21 +374,7 @@ static ssize_t show_phys_device(struct device *dev,
>>>    }
>>>
>>>    #ifdef CONFIG_MEMORY_HOTREMOVE
>>> -static int __zones_online_to(unsigned long end_pfn,
>>> -                struct page *first_page, unsigned long nr_pages)
>>> -{
>>> -    struct zone *zone_next;
>>> -
>>> -    /* The mem block is the last block of memory. */
>>> -    if (!pfn_valid(end_pfn + 1))
>>> -        return 1;
>>> -    zone_next = page_zone(first_page + nr_pages);
>>> -    if (zone_idx(zone_next) == ZONE_MOVABLE)
>>> -        return 1;
>>> -    return 0;
>>> -}
>>> -
>>> -static ssize_t show_zones_online_to(struct device *dev,
>>> +static ssize_t show_valid_zones(struct device *dev,
>>>                    struct device_attribute *attr, char *buf)
>>>    {
>>>        struct memory_block *mem = to_memory_block(dev);
>>> @@ -407,33 +393,23 @@ static ssize_t show_zones_online_to(struct device *dev,
>>>
>>>        zone = page_zone(first_page);
>>>
>>> -#ifdef CONFIG_HIGHMEM
>>> -    if (zone_idx(zone) == ZONE_HIGHMEM) {
>>> -        if (__zones_online_to(end_pfn, first_page, nr_pages))
>>> +    if (zone_idx(zone) == ZONE_MOVABLE - 1) {
>>> +        /*The mem block is the last memoryblock of this zone.*/
>>> +        if (end_pfn == zone_end_pfn(zone))
>>>                return sprintf(buf, "%s %s\n",
>>>                        zone->name, (zone + 1)->name);
>>>        }
>>> -#else
>>> -    if (zone_idx(zone) == ZONE_NORMAL) {
>>> -        if (__zones_online_to(end_pfn, first_page, nr_pages))
>>> -            return sprintf(buf, "%s %s\n",
>>> -                    zone->name, (zone + 1)->name);
>>> -    }
>>> -#endif
>>>
>>>        if (zone_idx(zone) == ZONE_MOVABLE) {
>>> -        if (!pfn_valid(start_pfn - nr_pages))
>>> -            return sprintf(buf, "%s %s\n",
>>> -                        zone->name, (zone - 1)->name);
>>> -        zone_prev = page_zone(first_page - nr_pages);
>>> -        if (zone_idx(zone_prev) != ZONE_MOVABLE)
>>> +        /*The mem block is the first memoryblock of ZONE_MOVABLE.*/
>>
>>> +        if (start_pfn == zone->zone_start_pfn)
>>>                return sprintf(buf, "%s %s\n",
>>> -                        zone->name, (zone - 1)->name);
>>> +                    zone->name, (zone - 1)->name);
>>
>> How about swap zone->name and (zone - 1)->name.
>>
>> If swapping them, sample output of the sysfs files shows as follows:
>>       memory0/valid_zones: none
>>       memory1/valid_zones: DMA32
>>       memory2/valid_zones: DMA32
>>       memory3/valid_zones: DMA32
>>       memory4/valid_zones: Normal
>>       memory5/valid_zones: Normal
>>       memory6/valid_zones: Normal Movable
>>       memory7/valid_zones: Normal Movable
>>
> 	memory6/valid_zones: Normal Movable
> 	memory7/valid_zones: Movable Normal
> Here can better show the dividing line between ZONE_MOVABLE and ZONE_NORMAL.
>

> The first column shows it's default zone,

If so, please write the information in 'valid_zones' term
of memory-hotplug.txt. Nobody know it.

Thanks,
Yasuaki Ishimatasu

> for memory6:
> 	the first column Normal shows that it can be onlined to ZONE_NORMAL by default.
> 	echo offline > memory6/state
> 	echo online > memory6/state
> 	the second column Movable shows that it can be onlined to ZONE_MOVABLE by online_movable.
> 	echo offline > memory6/state
> 	echo online_movable > memory6/state
> for memory7:
> 	the first column Movable shows that it can be onlined to ZONE_MOVABLE by default.
> 	echo offline > memory7/state
> 	echo online > memory7/state
> 	the second column Normal shows that it can be onlined to ZONE_NORMAL by online_kernel.
> 	echo offline > memory7/state
> 	echo online_kernel > memory7/state
>
> And it is more convenient for script to work.
> So i think we should leave it as it is.
>
> Thanks!
>                               ~~~~~~~~~~~~~~
>>       memory8/valid_zones: Movable
>>
>> Thanks,
>> Yasuaki Ishimatsu
>>
>>>        }
>>>
>>>        return sprintf(buf, "%s\n", zone->name);
>>>    }
>>> -static DEVICE_ATTR(zones_online_to, 0444, show_zones_online_to, NULL);
>>> +static DEVICE_ATTR(valid_zones, 0444, show_valid_zones, NULL);
>>>    #endif
>>>
>>>    static DEVICE_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
>>> @@ -587,7 +563,7 @@ static struct attribute *memory_memblk_attrs[] = {
>>>        &dev_attr_phys_device.attr,
>>>        &dev_attr_removable.attr,
>>>    #ifdef CONFIG_MEMORY_HOTREMOVE
>>> -    &dev_attr_zones_online_to.attr,
>>> +    &dev_attr_valid_zones.attr,
>>>    #endif
>>>        NULL
>>>    };
>>>
>>
>>
>>
>> .
>>
>
>


