Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaAVDVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 22:21:00 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37115 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaAVDUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 22:20:54 -0500
Date: Tue, 21 Jan 2014 19:20:45 -0800
From: Steven Noonan <steven@uplinklabs.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BISECTED] Linux 3.12.7 introduces page map handling regression
Message-ID: <20140122032045.GA22182@falcon.amazon.com>
References: <20140121232708.GA29787@amazon.com>
 <20140122014908.GG18164@kroah.com>
 <CA+55aFw7fTFJtOAa+RETGSL7ZXZE4Ysk9+Xmg6_5yyLkwRtcTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFw7fTFJtOAa+RETGSL7ZXZE4Ysk9+Xmg6_5yyLkwRtcTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 06:47:07PM -0800, Linus Torvalds wrote:
> On Tue, Jan 21, 2014 at 5:49 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Odds are this also shows up in 3.13, right?

Reproduced using 3.13 on the PV guest:

	[  368.756763] BUG: Bad page map in process mp  pte:80000004a67c6165 pmd:e9b706067
	[  368.756777] page:ffffea001299f180 count:0 mapcount:-1 mapping:          (null) index:0x0
	[  368.756781] page flags: 0x2fffff80000014(referenced|dirty)
	[  368.756786] addr:00007fd1388b7000 vm_flags:00100071 anon_vma:ffff880e9ba15f80 mapping:          (null) index:7fd1388b7
	[  368.756792] CPU: 29 PID: 618 Comm: mp Not tainted 3.13.0-ec2 #1
	[  368.756795]  ffff880e9b718958 ffff880e9eaf3cc0 ffffffff814d8748 00007fd1388b7000
	[  368.756803]  ffff880e9eaf3d08 ffffffff8116d289 0000000000000000 0000000000000000
	[  368.756809]  ffff880e9b7065b8 ffffea001299f180 00007fd1388b8000 ffff880e9eaf3e30
	[  368.756815] Call Trace:
	[  368.756825]  [<ffffffff814d8748>] dump_stack+0x45/0x56
	[  368.756833]  [<ffffffff8116d289>] print_bad_pte+0x229/0x250
	[  368.756837]  [<ffffffff8116eae3>] unmap_single_vma+0x583/0x890
	[  368.756842]  [<ffffffff8116feb5>] unmap_vmas+0x65/0x90
	[  368.756847]  [<ffffffff81175dac>] unmap_region+0xac/0x120
	[  368.756852]  [<ffffffff81176379>] ? vma_rb_erase+0x1c9/0x210
	[  368.756856]  [<ffffffff81177f10>] do_munmap+0x280/0x370
	[  368.756860]  [<ffffffff81178041>] vm_munmap+0x41/0x60
	[  368.756864]  [<ffffffff81178f32>] SyS_munmap+0x22/0x30
	[  368.756869]  [<ffffffff814e70ed>] system_call_fastpath+0x1a/0x1f
	[  368.756872] Disabling lock debugging due to kernel taint
	[  368.760084] BUG: Bad rss-counter state mm:ffff880e9d079680 idx:0 val:-1
	[  368.760091] BUG: Bad rss-counter state mm:ffff880e9d079680 idx:1 val:1

> 
> Probably. I don't have a Xen PV setup to test with (and very little
> interest in setting one up).. And I have a suspicion that it might not
> be so much about Xen PV, as perhaps about the kind of hardware.
> 
> I suspect the issue has something to do with the magic _PAGE_NUMA
> tie-in with _PAGE_PRESENT. And then mprotect(PROT_NONE) ends up
> removing the _PAGE_PRESENT bit, and now the crazy numa code is
> confused.
> 
> The whole _PAGE_NUMA thing is a f*cking horrible hack, and shares the
> bit with _PAGE_PROTNONE, which is why it then has that tie-in to
> _PAGE_PRESENT.
> 
> Adding Andrea to the Cc, because he's the author of that horridness.
> Putting Steven's test-case here as an attachement for Andrea, maybe
> that makes him go "Ahh, yes, silly case".
> 
> Also added Kirill, because he was involved the last _PAGE_NUMA debacle.
> 
> Andrea, you can find the thread on lkml, but it boils down to commit
> 1667918b6483 (backported to 3.12.7 as 3d792d616ba4) breaking the
> attached test-case (but apparently only under Xen PV). There it
> apparently causes a "BUG: Bad page map .." error.
> 
> And I suspect this is another of those "this bug is only visible on
> real numa machines, because _PAGE_NUMA isn't actually ever set
> otherwise". That has pretty much guaranteed that it gets basically
> zero testing, which is not a great idea when coupled with that subtle
> sharing of the _PAGE_PROTNONE bit..
> 
> It may be that the whole "Xen PV" thing is a red herring, and that
> Steven only sees it on that one machine because the one he runs as a
> PV guest under is a real NUMA machine, and all the other machines he
> has tried it on haven't been numa. So it *may* be that that "only
> under Xen PV" is a red herring. But that's just a possible guess.

The PV and HVM guests are both on NUMA hosts, but we don't expose NUMA to the
PV guest, so it fakes a NUMA node at startup.

I've also tried running a PV guest on a dual socket host with interleaved
memory:

	# dmesg | grep -i -e numa -e node
	[    0.000000] NUMA turned off
	[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000005607fffff]
	[    0.000000] Initmem setup node 0 [mem 0x00000000-0x5607fffff]
	[    0.000000]   NODE_DATA [mem 0x55d4f2000-0x55d518fff]
	[    0.000000] Movable zone start for each node
	[    0.000000] Early memory node ranges
	[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
	[    0.000000]   node   0: [mem 0x00100000-0x5607fffff]
	[    0.000000] On node 0 totalpages: 5638047
	[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
	[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
	[    0.010697] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
	# dmesg | tail -n 21
	[  348.467265] BUG: Bad page map in process t  pte:800000008a6ef165 pmd:53aa39067
	[  348.467280] page:ffffea000229bbc0 count:0 mapcount:-1 mapping:          (null) index:0x0
	[  348.467286] page flags: 0x1ffc0000000014(referenced|dirty)
	[  348.467293] addr:00007f8c9fca0000 vm_flags:00100071 anon_vma:ffff88053aff19c0 mapping:          (null) index:7f8c9fca0
	[  348.467301] CPU: 0 PID: 359 Comm: t Tainted: G    B        3.12.8-1-ec2 #1
	[  348.467306]  ffff8805396f71f8 ffff880539c49cc0 ffffffff814c77bb 00007f8c9fca0000
	[  348.467316]  ffff880539c49d08 ffffffff8116788e 0000000000000000 0000000000000000
	[  348.467325]  ffff88053aa39500 ffffea000229bbc0 00007f8c9fca1000 ffff880539c49e30
	[  348.467334] Call Trace:
	[  348.467346]  [<ffffffff814c77bb>] dump_stack+0x45/0x56
	[  348.467355]  [<ffffffff8116788e>] print_bad_pte+0x22e/0x250
	[  348.467362]  [<ffffffff811690b3>] unmap_single_vma+0x583/0x890
	[  348.467369]  [<ffffffff8116a445>] unmap_vmas+0x65/0x90
	[  348.467375]  [<ffffffff8117051c>] unmap_region+0xac/0x120
	[  348.467382]  [<ffffffff81170af9>] ? vma_rb_erase+0x1c9/0x210
	[  348.467389]  [<ffffffff811726d0>] do_munmap+0x280/0x370
	[  348.467395]  [<ffffffff81172801>] vm_munmap+0x41/0x60
	[  348.467404]  [<ffffffff81173702>] SyS_munmap+0x22/0x30
	[  348.467413]  [<ffffffff814d61ad>] system_call_fastpath+0x1a/0x1f
	[  348.470081] BUG: Bad rss-counter state mm:ffff88053a992100 idx:0 val:-1
	[  348.470091] BUG: Bad rss-counter state mm:ffff88053a992100 idx:1 val:1

As for bare metal Linux repro, I have a 2-socket Westmere box with NUMA enabled
running Linux 3.12.8. It doesn't repro:

	$ sudo journalctl -b | grep -i -e node -e numa | cut -c 30-
	SRAT: PXM 0 -> APIC 0x00 -> Node 0
	SRAT: PXM 0 -> APIC 0x02 -> Node 0
	SRAT: PXM 0 -> APIC 0x04 -> Node 0
	SRAT: PXM 0 -> APIC 0x10 -> Node 0
	SRAT: PXM 0 -> APIC 0x12 -> Node 0
	SRAT: PXM 0 -> APIC 0x14 -> Node 0
	SRAT: PXM 0 -> APIC 0x01 -> Node 0
	SRAT: PXM 0 -> APIC 0x03 -> Node 0
	SRAT: PXM 0 -> APIC 0x05 -> Node 0
	SRAT: PXM 0 -> APIC 0x11 -> Node 0
	SRAT: PXM 0 -> APIC 0x13 -> Node 0
	SRAT: PXM 0 -> APIC 0x15 -> Node 0
	SRAT: PXM 1 -> APIC 0x20 -> Node 1
	SRAT: PXM 1 -> APIC 0x22 -> Node 1
	SRAT: PXM 1 -> APIC 0x24 -> Node 1
	SRAT: PXM 1 -> APIC 0x30 -> Node 1
	SRAT: PXM 1 -> APIC 0x32 -> Node 1
	SRAT: PXM 1 -> APIC 0x34 -> Node 1
	SRAT: PXM 1 -> APIC 0x21 -> Node 1
	SRAT: PXM 1 -> APIC 0x23 -> Node 1
	SRAT: PXM 1 -> APIC 0x25 -> Node 1
	SRAT: PXM 1 -> APIC 0x31 -> Node 1
	SRAT: PXM 1 -> APIC 0x33 -> Node 1
	SRAT: PXM 1 -> APIC 0x35 -> Node 1
	SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
	SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
	SRAT: Node 0 PXM 0 [mem 0x100000000-0x63fffffff]
	SRAT: Node 1 PXM 1 [mem 0x640000000-0xc3fffffff]
	NUMA: Initialized distance table, cnt=2
	NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
	NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x63fffffff] -> [mem 0x00000000-0x63fffffff]
	Initmem setup node 0 [mem 0x00000000-0x63fffffff]
	  NODE_DATA [mem 0x63ffd9000-0x63fffffff]
	Initmem setup node 1 [mem 0x640000000-0xc3fffffff]
	  NODE_DATA [mem 0xc3ffd6000-0xc3fffcfff]
	 [ffffea0000000000-ffffea0018ffffff] PMD -> [ffff880627e00000-ffff88063fdfffff] on node 0
	 [ffffea0019000000-ffffea0030ffffff] PMD -> [ffff880c27600000-ffff880c3f5fffff] on node 1
	Movable zone start for each node
	Early memory node ranges
	  node   0: [mem 0x00001000-0x0009bfff]
	  node   0: [mem 0x00100000-0xbf78ffff]
	  node   0: [mem 0x100000000-0x63fffffff]
	  node   1: [mem 0x640000000-0xc3fffffff]
	On node 0 totalpages: 6289195
	On node 1 totalpages: 6291456
	setup_percpu: NR_CPUS:4096 nr_cpumask_bits:24 nr_cpu_ids:24 nr_node_ids:2
	SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=2
	Enabling automatic NUMA balancing. Configure with numa_balancing= or sysctl
	Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
	smpboot: Booting Node   0, Processors  #   1 #   2 #   3 #   4 #   5 OK
	smpboot: Booting Node   1, Processors  #   6 #   7 #   8 #   9 #  10 #  11 OK
	smpboot: Booting Node   0, Processors  #  12 #  13 #  14 #  15 #  16 #  17 OK
	smpboot: Booting Node   1, Processors  #  18 #  19 #  20 #  21 #  22 #  23 OK
	pci_bus 0000:00: on NUMA node 0 (pxm 0)
	[...]
	$ uname -r
	3.12.8-1
	$ sudo dmesg -c
	$ gcc -O2 -o t t.c
	$ ./t
	$ dmesg
	$


> Christ, how I hate that _PAGE_NUMA bit. Andrea: the fact that it gets
> no testing on any normal machines is a major problem. If it was simple
> and straightforward and the code was "obviously correct", it wouldn't
> be such a problem, but the _PAGE_NUMA code definitely does not fall
> under that "simple and obviously correct" heading.
> 
> Guys, any ideas?
> 
>                 Linus
