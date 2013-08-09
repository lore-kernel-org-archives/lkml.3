Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031554Ab3HIXSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:18:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:16098 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031447Ab3HIXSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:18:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="384692703"
Message-ID: <520578D0.7020607@intel.com>
Date: Fri, 09 Aug 2013 16:18:40 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: x86: early boot crash: "alloc_low_page: ran out of memory" (bisected)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a 100% reproducible panic early in boot:

> [    0.000000] Kernel panic - not syncing: alloc_low_page: ran out of memory

I'm not sure why I didn't run in to this until now.  I think there are a
couple of config options that need to get set just right to trigger it,
but CONFIG_DEBUG_PAGEALLOC seems to be the main one.  Full config is here:

	http://sr71.net/~dave/intel/foo/config-bigbox-crash-20130809.txt

I bisected it back to this commit (which I seem to remember causing some
other probems):

> commit 8170e6bed465b4b0c7687f93e9948aca4358a33b
> Author: H. Peter Anvin <hpa@zytor.com>
> Date:   Thu Jan 24 12:19:52 2013 -0800
> 
>     x86, 64bit: Use a #PF handler to materialize early mappings on demand

I need somewhere between 500G and 600G of memory to trigger it, but it
can be triggered using qemu with much less _actual_ RAM than that.  From
looking at the dmesg diffs, I suspect that the delta in memory use
between using 1G and 4k ptes for the identity mapping (DEBUG_PAGEALLOC
forces 4k pages) is the proximate trigger.

I also suspect that alloc_low_pages() is buggy in the way it manipulates
min/max_pfn_mapped.  I'm quite baffled how 'max_pfn_mapped' is supposed
to get set up correctly.  Current code says:

	max_pfn_mapped = 0; /* will get exact value next */

but I certainly don't see it getting set later on in that function, or
_ever_ as adding some printk()'s shows:

> +[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> +[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 0 max_pfn_mapped: 0
> +[    0.000000] BRK [0x02086000, 0x02086fff] PGTABLE
> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 0 max_pfn_mapped: 0
> +[    0.000000] BRK [0x02087000, 0x02087fff] PGTABLE
> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 0 max_pfn_mapped: 0
> +[    0.000000] BRK [0x02088000, 0x02088fff] PGTABLE
> +[    0.000000] init_memory_mapping: [mem 0xf07fe00000-0xf07fffffff]
> +[    0.000000]  [mem 0xf07fe00000-0xf07fffffff] page 4k
> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 252182528 max_pfn_mapped: 0
> +[    0.000000] BRK [0x02089000, 0x02089fff] PGTABLE
> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 252182528 max_pfn_mapped: 0
> +[    0.000000] BRK [0x0208a000, 0x0208afff] PGTABLE
> +[    0.000000] alloc_low_pages(1) min_pfn_mapped: 252182528 max_pfn_mapped: 0
> +[    0.000000] Kernel panic - not syncing: alloc_low_page: ran out of memory

I'll take a closer look at it next week, but figured I'd report it first.

Full dmesg:

> early console in setup code
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.8.0-rc5-00059-g8170e6b (davehans@viggo.jf.intel.com) (gcc version 4.6.3 20120306 (Red Hat 4.6.3-2) (GCC) ) #29 SMP Fri Aug 9 15:56:12 PDT 2013
> [    0.000000] Command line: root=/dev/sda1 console=ttyS0,115200 earlyprintk=ttyS0,115200 debug
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffbfff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000dfffc000-0x00000000dfffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000929bffffff] usable
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x929c000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] PAT not supported by CPU.
> [    0.000000] e820: last_pfn = 0xdfffc max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at [ffff8800000fdb00]
> [    0.000000] initial memory mapped: [mem 0x00000000-0xffffffffffffffff]
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x0205a000, 0x0205afff] PGTABLE
> [    0.000000] BRK [0x0205b000, 0x0205bfff] PGTABLE
> [    0.000000] BRK [0x0205c000, 0x0205cfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x929be00000-0x929bffffff]
> [    0.000000]  [mem 0x929be00000-0x929bffffff] page 4k
> [    0.000000] BRK [0x0205d000, 0x0205dfff] PGTABLE
> [    0.000000] BRK [0x0205e000, 0x0205efff] PGTABLE
> [    0.000000] Kernel panic - not syncing: alloc_low_page: ran out of memory
> [    0.000000] Pid: 0, comm: swapper Not tainted 3.8.0-rc5-00059-g8170e6b #29
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff81639b47>] panic+0xbb/0x1cb
> [    0.000000]  [<ffffffff816257aa>] alloc_low_pages+0x15a/0x160
> [    0.000000]  [<ffffffff81634d46>] phys_pmd_init+0x1f1/0x290
> [    0.000000]  [<ffffffff81634fb7>] phys_pud_init+0x1d2/0x24f
> [    0.000000]  [<ffffffff81635132>] kernel_physical_mapping_init+0xfe/0x16e
> [    0.000000]  [<ffffffff81625993>] init_memory_mapping+0x1e3/0x350
> [    0.000000]  [<ffffffff81cf5c5d>] init_range_memory_mapping+0xc2/0x10b
> [    0.000000]  [<ffffffff81cf5dd9>] init_mem_mapping+0x133/0x1c8
> [    0.000000]  [<ffffffff81ce77ad>] setup_arch+0x6ef/0xbe4
> [    0.000000]  [<ffffffff81639ca4>] ? printk+0x4d/0x4f
> [    0.000000]  [<ffffffff81ce3b4d>] start_kernel+0xce/0x3b3
> [    0.000000]  [<ffffffff81ce3592>] x86_64_start_reservations+0x91/0x95
> [    0.000000]  [<ffffffff81ce3681>] x86_64_start_kernel+0xeb/0xf2
