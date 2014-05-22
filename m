Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaEVL33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:29:29 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41345 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbaEVL31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:29:27 -0400
X-Sasl-enc: yDSkV4Bh/EOTf6kFZZ3oslCKu2NMfk+K0/hHmJHPqoq2 1400758165
Date: Thu, 22 May 2014 19:29:19 +0800
From: Ian Kent <raven@themaw.net>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>
Subject: Re: /proc/stat vs. failed order-4 allocation
Message-ID: <20140522112918.GA30340@perseus.fritz.box>
References: <20140521122521.GB7471@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521122521.GB7471@osiris>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 02:25:21PM +0200, Heiko Carstens wrote:
> Hi all,
> 
> I'm just wondering why /proc/stat is a single_open() seq_file and not a
> regular seq_file with an iterator (say 48 online cpus for each iteration
> or something similar).
> 
> Of course, in theory, the "intr" line may be very long as well...
> 
> With the current implementation everything must fit into a single buffer.
> So if memory is highly fragmented we run into failing higher order
> allocations (like below), which effectively means reading /proc/stat
> doesn't work anymore.
> 
> From stat_open:
> 
>         size_t size = 1024 + 128 * num_possible_cpus();
> 	[...]
>         /* minimum size to display an interrupt count : 2 bytes */
>         size += 2 * nr_irqs;
> 	[...]
>         buf = kmalloc(size, GFP_KERNEL);
>         if (!buf)
>                 return -ENOMEM;
> 
> With num_possible_cpus() = 256 we end up with an order 4 allocation.

Appologies in advance, I think my comment is off-topic, but never the
less ....

The previous size calcualtion requested memory in multiples of page
size.

Won't the current size calcualtion result in memory fragmentation?
Won't that lead much more rapidly to the page allocation failure
below on low memory systems even with a small number of CPUs?

> 
> So, would there be any objections, adding a cpu iterator to /proc/stat?
> 
> 62129.701569] sadc: page allocation failure: order:4, mode:0x1040d0
> [62129.701573] CPU: 1 PID: 192063 Comm: sadc Not tainted 3.10.0-123.el7.s390x #1
> [62129.701574] 00000000edf27840 00000000edf27850 0000000000000002 0000000000000000 
> 00000000edf278e0 00000000edf27858 00000000edf27858 00000000001120c0 
> 0000000000000000 000000000072c7c0 0000000000711836 000000000000000b 
> 00000000edf278a0 00000000edf27840 0000000000000000 0000000000000000 
> 00000000001040d0 00000000001120c0 00000000edf27840 00000000edf278a0 
> [62129.701586] Call Trace:
> [62129.701588] ([<0000000000111fbe>] show_trace+0xe6/0x130)
> [62129.701591] [<0000000000112074>] show_stack+0x6c/0xe8
> [62129.701593] [<000000000020d356>] warn_alloc_failed+0xd6/0x138
> [62129.701596] [<00000000002114d2>] __alloc_pages_nodemask+0x9da/0xb68
> [62129.701598] [<000000000021168e>] __get_free_pages+0x2e/0x58
> [62129.701599] [<000000000025a05c>] kmalloc_order_trace+0x44/0xc0
> [62129.701602] [<00000000002f3ffa>] stat_open+0x5a/0xd8
> [62129.701604] [<00000000002e9aaa>] proc_reg_open+0x8a/0x140
> [62129.701606] [<0000000000273b64>] do_dentry_open+0x1bc/0x2c8
> [62129.701608] [<000000000027411e>] finish_open+0x46/0x60
> [62129.701610] [<000000000028675a>] do_last+0x382/0x10d0
> [62129.701612] [<0000000000287570>] path_openat+0xc8/0x4f8
> [62129.701614] [<0000000000288bde>] do_filp_open+0x46/0xa8
> [62129.701616] [<000000000027541c>] do_sys_open+0x114/0x1f0
> [62129.701618] [<00000000005b1c1c>] sysc_tracego+0x14/0x1a
> [62129.701620] [<000003fffd0040a0>] 0x3fffd0040a0
> [62129.701624] Mem-Info:
> [62129.701625] DMA per-cpu:
> [62129.701627] CPU 0: hi: 186, btch: 31 usd: 0
> [62129.701628] CPU 1: hi: 186, btch: 31 usd: 0
> [62129.701630] CPU 2: hi: 186, btch: 31 usd: 51
> [62129.701631] Normal per-cpu:
> [62129.701632] CPU 0: hi: 186, btch: 31 usd: 30
> [62129.701634] CPU 1: hi: 186, btch: 31 usd: 0
> [62129.701635] CPU 2: hi: 186, btch: 31 usd: 0
> [62129.701639] active_anon:5416 inactive_anon:5571 isolated_anon:0
> active_file:440513 inactive_file:406221 isolated_file:27
> unevictable:1741 dirty:35305 writeback:0 unstable:0
> free:40319 slab_reclaimable:41921 slab_unreclaimable:34553
> mapped:3921 shmem:1351 pagetables:296 bounce:0
> free_cma:0
> [62129.701648] DMA free:25192kB min:11800kB low:14748kB high:17700kB active_anon:11032kB inactive_anon:11320kB active_file:1002092kB inactive_file:904260kB unevictable:3772kB isolated(anon):0kB isolated(file):4kB present:2097152kB managed:2070452kB mlocked:3772kB dirty:55072kB writeback:0kB mapped:6316kB shmem:1152kB slab_reclaimable:61192kB slab_unreclaimable:50108kB kernel_stack:2368kB pagetables:532kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:133 all_unreclaimable? no
> [62129.701652] lowmem_reserve[]: 0 1837 1837
> [62129.701658] Normal free:136084kB min:10724kB low:13404kB high:16084kB active_anon:10632kB inactive_anon:10964kB active_file:759960kB inactive_file:720624kB unevictable:3192kB isolated(anon):0kB isolated(file):4kB present:1966080kB managed:1881776kB mlocked:3192kB dirty:86148kB writeback:0kB mapped:9368kB shmem:4252kB slab_reclaimable:106492kB slab_unreclaimable:88104kB kernel_stack:5808kB pagetables:652kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> [62129.701661] lowmem_reserve[]: 0 0 0
> [62129.701664] DMA: 1540*4kB (UEM) 2217*8kB (UEM) 9*16kB (UEM) 1*32kB (R) 5*64kB (R) 1*128kB (R) 1*256kB (R) 1*512kB (R) 0*1024kB = 25288kB
> [62129.701673] Normal: 21631*4kB (UEM) 5755*8kB (UEM) 145*16kB (UEM) 8*32kB (ER) 4*64kB (R) 2*128kB (R) 0*256kB 1*512kB (R) 0*1024kB = 136164kB
> [62129.701682] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1024kB
> [62129.701684] 849331 total pagecache pages
> [62129.701685] 131 pages in swap cache
> [62129.701687] Swap cache stats: add 9956, delete 9825, find 1049/1416
> [62129.701688] Free swap = 7186784kB
> [62129.701689] Total swap = 7212140kB
> [62129.710679] 1015808 pages RAM
> [62129.710681] 23437 pages reserved
> [62129.710682] 1360146 pages shared
> [62129.710683] 384507 pages non-shared
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
