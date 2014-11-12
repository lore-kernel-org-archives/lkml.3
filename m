Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaKLIjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:39:09 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:52730 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023AbaKLIjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:39:08 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="43261193"
Message-ID: <54631C7F.5090905@cn.fujitsu.com>
Date: Wed, 12 Nov 2014 16:38:23 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: <akpm@linux-foundation.org>, <grygorii.strashko@ti.com>,
        <yinghai@kernel.org>, <isimatu.yasuaki@jp.fujitsu.com>,
        <fabf@skynet.be>, <nzimmer@sgi.com>, <wangnan0@huawei.com>,
        <vdavydov@parallels.com>, <toshi.kani@hp.com>,
        <phacht@linux.vnet.ibm.com>, <tj@kernel.org>,
        <kirill.shutemov@linux.intel.com>, <riel@redhat.com>,
        <luto@amacapital.net>, <hpa@linux.intel.com>, <aarcange@redhat.com>,
        <qiuxishi@huawei.com>, <mgorman@suse.de>, <rientjes@google.com>,
        <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] Fix node meminfo corruption.
References: <1415781410-19825-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1415781410-19825-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, please ignore this series. Sent by mistake.

On 11/12/2014 04:36 PM, Tang Chen wrote:
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

