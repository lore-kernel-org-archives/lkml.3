Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaKDBKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:10:21 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:5278 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750894AbaKDBKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:10:17 -0500
X-IronPort-AV: E=Sophos;i="5.04,843,1406563200"; 
   d="scan'208";a="42793815"
Message-ID: <54582796.7030700@cn.fujitsu.com>
Date: Tue, 4 Nov 2014 09:10:46 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: <akpm@linux-foundation.org>, <santosh.shilimkar@ti.com>,
        <grygorii.strashko@ti.com>, <yinghai@kernel.org>,
        <isimatu.yasuaki@jp.fujitsu.co>, <fabf@skynet.be>, <nzimmer@sgi.com>,
        <wangnan0@huawei.com>, <vdavydov@parallels.com>, <toshi.kani@hp.com>,
        <phacht@linux.vnet.ibm.com>, <tj@kernel.org>,
        <kirill.shutemov@linux.intel.com>, <riel@redhat.com>,
        <luto@amacapital.net>, <hpa@linux.intel.com>, <aarcange@redhat.com>,
        <qiuxishi@huawei.com>, <mgorman@suse.de>, <rientjes@google.com>,
        <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] Fix node meminfo corruption.
References: <1414748812-22610-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1414748812-22610-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I thinks these two problems are very important and should be merged ASAP.
Would you please help to have a look at it ?

Thanks.

On 10/31/2014 05:46 PM, Tang Chen wrote:
> There are two problems when calculating node meminfo:
>
> 1. When hot-adding a node without onlining any page, MemTotal corrupted.
>
> # hot-add node2 (memory not onlined)
> # cat /sys/device/system/node/node2/meminfo
> Node 2 MemTotal:       33554432 kB			/* corrupted */
> Node 2 MemFree:               0 kB
> Node 2 MemUsed:        33554432 kB
> Node 2 Active:                0 kB
> ......
>
>
> 2. When onlining memory on node2, MemFree of node3 corrupted.
>
> # for ((i = 2048; i < 2064; i++)); do echo online_movable > /sys/devices/system/node/node2/memory$i/state; done
> # cat /sys/devices/system/node/node2/meminfo
> Node 2 MemTotal:       33554432 kB
> Node 2 MemFree:        33549092 kB
> Node 2 MemUsed:            5340 kB
> ......
> # cat /sys/devices/system/node/node3/meminfo
> Node 3 MemTotal:              0 kB
> Node 3 MemFree:               248 kB                    /* corrupted */
> Node 3 MemUsed:               0 kB
> ......
>
> This patch-set fixes them.
>
> Tang Chen (2):
>    mem-hotplug: Reset node managed pages when hot-adding a new pgdat.
>    mem-hotplug: Fix wrong check for zone->pageset initialization in
>      online_pages().
>
>   include/linux/bootmem.h |  1 +
>   include/linux/mm.h      |  1 +
>   mm/bootmem.c            |  9 +++++----
>   mm/memory_hotplug.c     | 15 ++++++++++++++-
>   mm/nobootmem.c          |  8 +++++---
>   mm/page_alloc.c         |  5 +++++
>   6 files changed, 31 insertions(+), 8 deletions(-)
>

