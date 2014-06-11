Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaFKLk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:40:26 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:63118 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaFKLkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:40:24 -0400
MIME-Version: 1.0
Date: Wed, 11 Jun 2014 13:40:21 +0200
X-Google-Sender-Auth: Cj-_oclb0JaJMZQsTUQ4DX26Sp4
Message-ID: <CAMuHMdXm_fT251+ih2cJS+hRkrPuVQi3sMFgYe+k18xe-Wd21w@mail.gmail.com>
Subject: BUG: Bad page state in process swapper pfn:00000
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laura Abbott <lauraa@codeaurora.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With current mainline, I get an early crash on r8a7791/koelsch:

BUG: Bad page state in process swapper  pfn:00000
page:ee20b000 count:0 mapcount:0 mapping:66756200 index:0x65726566
page flags: 0x74656b63(locked|error|lru|active|owner_priv_1|arch_1|private|writeback|head|swapcache
|reclaim|mlocked)
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
bad because of flags:
page flags: 0x212861(locked|lru|active|private|writeback|swapcache|mlocked)

I bisected it to

commit 1c2f87c22566cd057bc8cde10c37ae9da1a1bb76
Author: Laura Abbott <lauraa@codeaurora.org>
Date:   Sun Apr 13 22:54:58 2014 +0100

    ARM: 8025/1: Get rid of meminfo

    memblock is now fully integrated into the kernel and is the prefered
    method for tracking memory. Rather than reinvent the wheel with
    meminfo, migrate to using memblock directly instead of meminfo as
    an intermediate.

    Acked-by: Jason Cooper <jason@lakedaemon.net>
    Acked-by: Catalin Marinas <catalin.marinas@arm.com>
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
    Tested-by: Leif Lindholm <leif.lindholm@linaro.org>
    Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

As this is a quite intrusive change, it cannot be reverted on top of mainline.

The commit before (1c8c3cf0b5239388e712508a85821f4718f4d889)
does work. Dmesg difference between them:

 Uncompressing Linux... done, booting the kernel.
 Booting Linux on physical CPU 0x0
-Linux version 3.15.0-rc1-koelsch-reference-00027-g1c8c3cf0b523-dirty
(geert@ramsan) (gcc version 4.6.3 (GCC) ) #174 SMP Wed Jun 11 13:19:00
CEST 2014
+Linux version 3.15.0-rc1-koelsch-reference-00028-g1c2f87c22566-dirty
(geert@ramsan) (gcc version 4.6.3 (GCC) ) #175 SMP Wed Jun 11 13:20:28
CEST 2014
 CPU: ARMv7 Processor [413fc0f2] revision 2 (ARMv7), cr=10c5347d
 CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
-Ignoring memory at 0x200000000 outside 32-bit physical address space
 Machine model: Koelsch
 bootconsole [earlycon0] enabled
 debug: ignoring loglevel setting.
-Truncating RAM at 40000000-bfffffff to -6f7fffff (vmalloc region overlap).
+Truncating RAM at 0x00000000-0xc0000000 to -0x6f800000
 Memory policy: Data cache writealloc
+BUG: not creating mapping for 0x00000000 at 0x80000000 in user region
 BUG: mapping for 0xe6e60000 at 0xffe60000 out of vmalloc space
-On node 0 totalpages: 194560
-free_area_init_node: node 0, pgdat c04bf3c0, node_mem_map ef20b000
-  Normal zone: 1520 pages used for memmap
+On node 0 totalpages: 456704
+free_area_init_node: node 0, pgdat c04bf3c0, node_mem_map eea0b000
+  Normal zone: 3568 pages used for memmap
   Normal zone: 0 pages reserved
-  Normal zone: 194560 pages, LIFO batch:31
-PERCPU: Embedded 7 pages/cpu @ef1e7000 s7488 r8192 d12992 u32768
+  Normal zone: 456704 pages, LIFO batch:31
+PERCPU: Embedded 7 pages/cpu @ee9e4000 s7488 r8192 d12992 u32768
 pcpu-alloc: s7488 r8192 d12992 u32768 alloc=8*4096
 pcpu-alloc: [0] 0 [0] 1
-Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 193040
+Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 453136
 Kernel command line: console=ttySC6,115200 earlyprintk
ignore_loglevel ip=dhcp root=/dev/nfs
nfsroot=192.168.97.21:/home/koelsch/debian-armhf
 PID hash table entries: 4096 (order: 2, 16384 bytes)
-Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
-Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
-Memory: 766112K/778240K available (3423K kernel code, 151K rwdata,
1036K rodata, 215K init, 235K bss, 12128K reserved)
+Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
+Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
+BUG: Bad page state in process swapper  pfn:00000
+page:ee20b000 count:0 mapcount:0 mapping:66756200 index:0x65726566
+page flags: 0x74656b63(locked|error|lru|active|owner_priv_1|arch_1|private|writeback|head|swapcache|reclaim|mlocked)
+page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
+bad because of flags:
+page flags: 0x212861(locked|lru|active|private|writeback|swapcache|mlocked)
+Modules linked in:
+CPU: 0 PID: 0 Comm: swapper Not tainted
3.15.0-rc1-koelsch-reference-00028-g1c2f87c22566-dirty #175

My tree is dirty due to the r8a7791-specific DEBUG_LL patch.

Any suggestions before I dive deeper into this?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
