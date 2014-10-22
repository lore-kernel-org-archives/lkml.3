Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbaJVSK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:10:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbaJVSK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:10:26 -0400
Message-ID: <5447F2DF.3000506@redhat.com>
Date: Wed, 22 Oct 2014 14:09:35 -0400
From: Joe Mario <jmario@redhat.com>
Reply-To: jmario@redhat.com
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com, rfowles@redhat.com
Subject: Re: perf:  Translating mmap2 ids into socket info?
References: <20141022162026.GG135937@redhat.com> <20141022164510.GJ21513@worktop.programming.kicks-ass.net>
In-Reply-To: <20141022164510.GJ21513@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 12:45 PM, Peter Zijlstra wrote:
> On Wed, Oct 22, 2014 at 12:20:26PM -0400, Don Zickus wrote:
>> Hi,
>>
>> A question/request came up during our cache to cache analysis.  We were
>> wondering if give an unique mmap2 id (major, minor, inode, inode
>> generation), if it was possible to determine a cpu socket id that memory
>> was attached to at the time of the captured perf event?
>
> No, see below. Also socket is the wrong information, both AMD and Intel
> have chips with two nodes in one socket :-)
>
>> We ran into a scenario awhile back where a dcache struct was allocated on
>> say node2 and then subsequently free'd.  The memory was thought to be
>> re-allocated on node0 for another dcache entry.  It turned out the memory
>> was still attached to node2 and was causing slowdowns.
>
> Yes, kernel memory is directly addresses, you basically have a static
> address->node mapping, it never changes.

For kernel addresses, is there a reason not to have it available in perf,
especially when that knowledge is important to understanding a numa-related slowdown?

In our case, when we booted with one configuration, AIM ran fine.  When we
booted another way, AIM's performance dropped 50%.  It was all due to the dentry
lock being located on a different (now remote) numa node.

We used your dmesg approach to track down the home node in an attempt to understand
what was different between the two boots.  But the problem would have been obvious
if perf simply listed the home node info.

>
> For instance, on my ivb-ep I can find the following in my dmesg:
>
> [    0.000000] NUMA: Initialized distance table, cnt=2
> [    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x43fffffff] -> [mem 0x00000000-0x43fffffff]
> [    0.000000] NODE_DATA(0) allocated [mem 0x43fffc000-0x43fffffff]
> [    0.000000] NODE_DATA(1) allocated [mem 0x83fff9000-0x83fffcfff]
> [    0.000000]  [ffffea0000000000-ffffea000edfffff] PMD -> [ffff88042fe00000-ffff88043ddfffff] on node 0
> [    0.000000]  [ffffea000ee00000-ffffea001cdfffff] PMD -> [ffff88082f600000-ffff88083d5fffff] on node 1
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x83fffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0008dfff]
> [    0.000000]   node   0: [mem 0x00100000-0xbad28fff]
> [    0.000000]   node   0: [mem 0xbaf90000-0xbafc4fff]
> [    0.000000]   node   0: [mem 0xbafda000-0xbb3d3fff]
> [    0.000000]   node   0: [mem 0xbdfac000-0xbdffffff]
> [    0.000000]   node   0: [mem 0x100000000-0x43fffffff]
> [    0.000000]   node   1: [mem 0x440000000-0x83fffffff]
> [    0.000000] Initmem setup node 0 [mem 0x00001000-0x43fffffff]
> [    0.000000] On node 0 totalpages: 4174137
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3981 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 10422 pages used for memmap
> [    0.000000]   DMA32 zone: 762284 pages, LIFO batch:31
> [    0.000000]   Normal zone: 46592 pages used for memmap
> [    0.000000]   Normal zone: 3407872 pages, LIFO batch:31
> [    0.000000] Initmem setup node 1 [mem 0x440000000-0x83fffffff]
> [    0.000000] On node 1 totalpages: 4194304
> [    0.000000]   Normal zone: 57344 pages used for memmap
> [    0.000000]   Normal zone: 4194304 pages, LIFO batch:31
>
>> Our cache-to-cache tool noticed the slowdown but we couldn't understand
>> why because we had falsely assumed the memory was allocated on the local
>> node but instead it was on the remote node.
>
> But in general, you can never say for user memory, since that has the
> process page table mapping in between, the user virtual address is
> unrelated to backing (and can change frequently and without
> notification).
>
> Therefore the mmap(2) information is useless for this, it only concerns
> user memory.
>

