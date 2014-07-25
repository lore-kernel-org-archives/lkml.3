Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062AbaGYCjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:39:53 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34545 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbaGYCjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:39:52 -0400
Message-ID: <53D1C363.7010802@huawei.com>
Date: Fri, 25 Jul 2014 10:39:31 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>
CC: <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>, <mgorman@suse.de>,
        <akpm@linux-foundation.org>, <zhangyanfei@cn.fujitsu.com>,
        <wangnan0@huawei.com>, Linux MM <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memory-hotplug: add sysfs zone_index attribute
References: <1406187138-27911-1-git-send-email-zhenzhang.zhang@huawei.com> <53D0B8B6.8040104@huawei.com> <53D14997.7090106@intel.com>
In-Reply-To: <53D14997.7090106@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/25 1:59, Dave Hansen wrote:
> On 07/24/2014 12:41 AM, Zhang Zhen wrote:
>> Currently memory-hotplug has two limits:
>> 1. If the memory block is in ZONE_NORMAL, you can change it to
>> ZONE_MOVABLE, but this memory block must be adjacent to ZONE_MOVABLE.
>> 2. If the memory block is in ZONE_MOVABLE, you can change it to
>> ZONE_NORMAL, but this memory block must be adjacent to ZONE_NORMAL.
>>
>> Without this patch, we don't know which zone a memory block is in.
>> So we don't know which memory block is adjacent to ZONE_MOVABLE or
>> ZONE_NORMAL.
>>
>> On the other hand, with this patch, we can easy to know newly added
>> memory is added as ZONE_NORMAL (for powerpc, ZONE_DMA, for x86_32,
>> ZONE_HIGHMEM).
> 
> A section can contain more than one zone.  This interface will lie about
> such sections, which is quite unfortunate.
> 
1. In arch_add_memory(), x86_64 add the new pages of the new memory block default to
ZONE_NORMAL (for powerpc, ZONE_DMA, for x86_32, ZONE_HIGHMEM).

2. In __offline_pages(), test_pages_in_a_zone() guaranteed the pages of a memory block
we try to offline are in the same zone. If a section contains more than one zone,
the memory block can not be offlined.

Based on the above two points, i think the pages of a memory block are in one zone, and the sections
of a memory block are in one zone.

Could you please explain in detail what is the case a section can contain more than one zone ?

Thanks for your comments!

> I'd really much rather see an interface that has a section itself
> enumerate to which zones it may be changed.  The way you have it now,
> any user has to know the rules that you've laid out above.  If the
> kernel changed those restrictions, we'd have to teach every application
> about the change in restrictions.
> 

This interface is designed to show which zone a memory block is in. If the kernel changed those
restrictions, this interface doesn't need to change.
For a x86_64 machine booted with "mem=400M" and with 2GiB memory installed.
Sample output of the sysfs files:
# cat block_size_bytes
8000000
# cat memory0/zone_index
DMA
# cat memory1/zone_index
DMA32
# cat memory2/zone_index
DMA32
# cat memory3/zone_index
DMA32
# echo 0x20000000 > probe
# cat memory4/zone_index
Normal
# echo online > memory4/state
# cat memory4/zone_index
Normal

# echo offline > memory4/state
# echo online_movable > memory4/state
# cat memory4/zone_index
Movable

Thanks!

Best regards!
> 
> 
> 
> .
> 


