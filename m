Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbaGRJRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:17:46 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:50410 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755451AbaGRJRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:17:43 -0400
X-IronPort-AV: E=Sophos;i="5.00,914,1396972800"; 
   d="scan'208";a="33451710"
Message-ID: <53C8E602.1060301@cn.fujitsu.com>
Date: Fri, 18 Jul 2014 17:16:50 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
CC: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pei Feiyue <peifeiyue@huawei.com>, <linux-mm@kvack.org>,
        <x86@kernel.org>, <linux-ia64@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-sh@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] memory-hotplug: suitable memory should go to ZONE_MOVABLE
References: <1405670163-53747-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1405670163-53747-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/18/2014 03:55 PM, Wang Nan wrote:
> This series of patches fix a problem when adding memory in bad manner.
> For example: for a x86_64 machine booted with "mem=400M" and with 2GiB
> memory installed, following commands cause problem:
> 
>  # echo 0x40000000 > /sys/devices/system/memory/probe
> [   28.613895] init_memory_mapping: [mem 0x40000000-0x47ffffff]
>  # echo 0x48000000 > /sys/devices/system/memory/probe
> [   28.693675] init_memory_mapping: [mem 0x48000000-0x4fffffff]
>  # echo online_movable > /sys/devices/system/memory/memory9/state
>  # echo 0x50000000 > /sys/devices/system/memory/probe 
> [   29.084090] init_memory_mapping: [mem 0x50000000-0x57ffffff]
>  # echo 0x58000000 > /sys/devices/system/memory/probe 
> [   29.151880] init_memory_mapping: [mem 0x58000000-0x5fffffff]
>  # echo online_movable > /sys/devices/system/memory/memory11/state
>  # echo online> /sys/devices/system/memory/memory8/state
>  # echo online> /sys/devices/system/memory/memory10/state
>  # echo offline> /sys/devices/system/memory/memory9/state
> [   30.558819] Offlined Pages 32768
>  # free
>              total       used       free     shared    buffers     cached
> Mem:        780588 18014398509432020     830552          0          0      51180
> -/+ buffers/cache: 18014398509380840     881732
> Swap:            0          0          0
> 
> This is because the above commands probe higher memory after online a
> section with online_movable, which causes ZONE_HIGHMEM (or ZONE_NORMAL
> for systems without ZONE_HIGHMEM) overlaps ZONE_MOVABLE.

Yeah, this is rare in reality but can happen. Could you please also
include the free result and zoneinfo after applying your patch?

Thanks.

> 
> After the second online_movable, the problem can be observed from
> zoneinfo:
> 
>  # cat /proc/zoneinfo
> ...
> Node 0, zone  Movable
>   pages free     65491
>         min      250
>         low      312
>         high     375
>         scanned  0
>         spanned  18446744073709518848
>         present  65536
>         managed  65536
> ...
> 
> This series of patches solve the problem by checking ZONE_MOVABLE when
> choosing zone for new memory. If new memory is inside or higher than
> ZONE_MOVABLE, makes it go there instead.
> 
> 
> Wang Nan (5):
>   memory-hotplug: x86_64: suitable memory should go to ZONE_MOVABLE
>   memory-hotplug: x86_32: suitable memory should go to ZONE_MOVABLE
>   memory-hotplug: ia64: suitable memory should go to ZONE_MOVABLE
>   memory-hotplug: sh: suitable memory should go to ZONE_MOVABLE
>   memory-hotplug: powerpc: suitable memory should go to ZONE_MOVABLE
> 
>  arch/ia64/mm/init.c   |  7 +++++++
>  arch/powerpc/mm/mem.c |  6 ++++++
>  arch/sh/mm/init.c     | 13 ++++++++-----
>  arch/x86/mm/init_32.c |  6 ++++++
>  arch/x86/mm/init_64.c | 10 ++++++++--
>  5 files changed, 35 insertions(+), 7 deletions(-)
> 


-- 
Thanks.
Zhang Yanfei
