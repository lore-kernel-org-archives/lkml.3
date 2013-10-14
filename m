Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3JNTev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:34:51 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:56782 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab3JNTeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:34:50 -0400
MIME-Version: 1.0
In-Reply-To: <525C0EFE.2010409@gmail.com>
References: <5258E560.5050506@cn.fujitsu.com>
	<525B19C3.9040907@gmail.com>
	<20131014133835.GG4722@htj.dyndns.org>
	<525BFCF3.5010908@gmail.com>
	<20131014142719.GI4722@htj.dyndns.org>
	<525C02DC.4050706@gmail.com>
	<20131014145131.GJ4722@htj.dyndns.org>
	<525C0866.2010808@gmail.com>
	<20131014151902.GL4722@htj.dyndns.org>
	<525C0EFE.2010409@gmail.com>
Date: Mon, 14 Oct 2013 12:34:49 -0700
X-Google-Sender-Auth: PS3HdBErhvw-erujtmXoVsydP68
Message-ID: <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
From: Yinghai Lu <yinghai@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 8:34 AM, Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:
> Hello tejun,
>
> On 10/14/2013 11:19 PM, Tejun Heo wrote:
>> Hey,
>>
>> On Mon, Oct 14, 2013 at 11:06:14PM +0800, Zhang Yanfei wrote:
>>> a little difference here, consider a 16-GB node. If we parse SRAT earlier,
>>> and still use the top-down allocation, and kernel image is loaded at 16MB,
>>> we reserve other nodes but this 16GB node that kernel resides in is used
>>> for boot-up allocation. So the page table is allocated from 16GB to 0.
>>> The page table is allocated on top of the the memory as possible.
>>>
>>> But if we use this approach, no matter how large the page table is, we
>>> allocate the page table in low memory which is the case that hpa concerns
>>> about the DMA.
>>
>> Yeah, sure there will be cases where parsing SRAT would be better.
>>
>>  4k mapping is in use, which is mostly for debugging && memory map is
>>  composed such that the highest non-hotpluggable address is high
>>  enough.
>>
>> It's going in circles again but my point has always been that the
>> above in itself don't seem to be substantial enough to justify
>> putting, say, initrd loading before page table init.
>>
>> Later some argued that bringing SRAT parsing earlier could help
>> implementing finer grained hotplug, which would be an acceptable path
>> to follow; however, that doesn't turn out to be true either.
>>
>> * Again, it matter if and only if 4k mapping is in use.  Do we even
>>   care?
>>
>> * SRAT isn't enough.  The whole device tree needs to be parsed to put
>>   page tables into local device.  It's a lot of churn, including major
>>   updates to page table allocation, just to support debug 4k mapping
>>   cases.  Doesn't make much sense to me.
>>
>> So, SRAT's usefulness seems extremely limited - it helps if the user
>> wants to use debug features along with memory hotplug on an extreme
>> large machine with devices which have low DMA limit, and that's it.
>> To me, it seems to be a poor argument.  Just declaring memory hotplug
>> works iff large kernel mapping is in use feels like a pretty good
>> trade-off to me, and I have no idea why I have to repeat all this,
>> which I've written multiple times already, in a private thread again.
>>
>> If the thread is to make progress, one has to provide counter
>> arguments to the points raised.  It feels like I'm going in circle
>> again.  The exact same content I wrote above has been repeated
>> multiple times in the past discussions and I'm getting tired of doing
>> it without getting any actual response.

The points for parsing SRAT early instead of Yanfei/Tang v7:
1. We just reached one unified path to setup page tables for 32bit,
64bit and xen or non xen after several years. We should not have add
another path for system
that support hotplug.

2. also we should avoid adding "movable_nodes" command line.

3. debug mapping 4k, and it is working all the way, why breaking it even for
memory hotplug path?

4. numa_meminfo now is static structure.
we have no reason that we can not parse SRAT etc to fill that struct.

5. for device tree, i assume that we could do same like srat parsing to find out
numa to fill the numa_meminfo early. or with help of BRK.

6. in the long run, We should rework our NUMA booting:
a. boot system with boot numa nodes early only.
b. in later init stage or user space, init other nodes
RAM/CPU/PCI...in parallel.
that will reduce boot time for 8 sockets/32 sockets dramatically.

We will need to parse srat table early so could avoid init memory for
non-boot nodes.

Yinghai
