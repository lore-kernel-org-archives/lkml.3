Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaKJJlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:41:10 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:38387 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaKJJlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:41:09 -0500
Message-ID: <54608706.6030109@huawei.com>
Date: Mon, 10 Nov 2014 17:36:06 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: <akpm@linux-foundation.org>, <santosh.shilimkar@ti.com>,
        <grygorii.strashko@ti.com>, <yinghai@kernel.org>,
        <isimatu.yasuaki@jp.fujitsu.co>, <fabf@skynet.be>, <nzimmer@sgi.com>,
        <wangnan0@huawei.com>, <vdavydov@parallels.com>, <toshi.kani@hp.com>,
        <phacht@linux.vnet.ibm.com>, <tj@kernel.org>,
        <kirill.shutemov@linux.intel.com>, <riel@redhat.com>,
        <luto@amacapital.net>, <hpa@linux.intel.com>, <aarcange@redhat.com>,
        <mgorman@suse.de>, <rientjes@google.com>, <hannes@cmpxchg.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v2 0/2] Fix node meminfo and zoneinfo corruption.
References: <1415353481-3140-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1415353481-3140-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.54608816.0046,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 378efc8d4105691f2e049f082ed273a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/7 17:44, Tang Chen wrote:

> There are two problems in memory hot-add progress:
> 
> 1. When hot-adding a node without onlining any page, node meminfo corrupted:
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
> 2. When onlining memory on node2, node2 zoneinfo and node3 meminfo corrupted:
> 
> # for ((i = 2048; i < 2064; i++)); do echo online_movable > /sys/devices/system/node/node2/memory$i/state; done
> # cat /sys/devices/system/node/node2/meminfo
> Node 2 MemTotal:       33554432 kB
> Node 2 MemFree:        33549092 kB
> Node 2 MemUsed:            5340 kB
> ......
> # cat /sys/devices/system/node/node3/meminfo
> Node 3 MemTotal:              0 kB
> Node 3 MemFree:               248 kB      /* corrupted, should be 0 */
> Node 3 MemUsed:               0 kB
> ......
> 
> # cat /proc/zoneinfo
> ......
> Node 2, zone   Movable
> ......
>         spanned  8388608
>         present  16777216		/* corrupted, should be 8388608 */
>         managed  8388608
> 
> 
> 
> Change log v1 -> v2:
> 1. Replace patch 2/2 with a new one. It provides the simplest way to
>    fix problem 2. 
> 
> Tang Chen (2):
>   mem-hotplug: Reset node managed pages when hot-adding a new pgdat.
>   mem-hotplug: Reset node present pages when hot-adding a new pgdat.
> 
>  include/linux/bootmem.h |  1 +
>  mm/bootmem.c            |  9 +++++----
>  mm/memory_hotplug.c     | 24 ++++++++++++++++++++++++
>  mm/nobootmem.c          |  8 +++++---
>  4 files changed, 35 insertions(+), 7 deletions(-)
> 

Hi Tang,

How about cc stable ?
 

