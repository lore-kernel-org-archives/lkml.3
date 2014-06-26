Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbaFZLdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:33:10 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36477 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbaFZLdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:33:07 -0400
MIME-Version: 1.0
In-Reply-To: <1403713114-18923-3-git-send-email-t.figa@samsung.com>
References: <1403713114-18923-1-git-send-email-t.figa@samsung.com>
	<1403713114-18923-3-git-send-email-t.figa@samsung.com>
Date: Thu, 26 Jun 2014 12:33:05 +0100
Message-ID: <CAD8Lp46QXUbcv1Sue8AUqR3xrM=xVnUZ9dB9dPFVS+KUXAkivg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: EXYNOS: Add support for firmware-assisted suspend/resume
From: Daniel Drake <drake@endlessm.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Wed, Jun 25, 2014 at 5:18 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> On a numer of Exynos-based boards Linux kernel is running in non-secure
> mode under a secure firmware. This means that certain operations need to
> be handled in special way, with firmware assistance. System-wide
> suspend/resume is an example of such operations.

Thanks for working on this. Tested on ODROID-U2, it almost works! Now
instead of resetting upon resume, the system does go back into Linux.

However things go wrong at that point - maybe some memory corruption?
A memory allocation error from the USB stack, and then an unhandled
abort about 5 seconds which usually kills my bash process.

I'll try to find some time to investigate a bit more. In the mean
time, the crash log is below.
I'm testing with "rtcwake -m mem -s 10". That's using the internal RTC
with the max77686 RTC driver not built to avoid confusion. Also the
max77686 clk driver must be disabled otherwise it disables the
upstream clock source of the exynos's RTC.

Enabling non-boot CPUs ...
CPU1: Booted secondary processor
CPU1 is up
CPU2: Booted secondary processor
CPU2 is up
CPU3: Booted secondary processor
CPU3 is up
PM: noirq resume of devices complete after 1.460 msecs
PM: early resume of devices complete after 1.603 msecs
s3c-rtc 10070000.rtc: rtc disabled, re-enabling
usb usb1: root hub lost power or was reset
s3c-i2c 13860000.i2c: slave address 0x00
s3c-i2c 13860000.i2c: bus frequency set to 214 KHz
s3c-i2c 13870000.i2c: slave address 0x00
s3c-i2c 13870000.i2c: bus frequency set to 71 KHz
usb 1-2: reset high-speed USB device number 2 using exynos-ehci
swapper/0: page allocation failure: order:0, mode:0x284000
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc2-00034-g8f86926 #118
[<c0016140>] (unwind_backtrace) from [<c0011e14>] (show_stack+0x10/0x14)
[<c0011e14>] (show_stack) from [<c05b27f4>] (dump_stack+0x84/0xc4)
[<c05b27f4>] (dump_stack) from [<c00b5398>] (warn_alloc_failed+0x108/0x128)
[<c00b5398>] (warn_alloc_failed) from [<c00b8858>]
(__alloc_pages_nodemask+0x924/0xa3c)
[<c00b8858>] (__alloc_pages_nodemask) from [<c00ea824>] (new_slab+0xd8/0x340)
[<c00ea824>] (new_slab) from [<c05b0abc>]
(__slab_alloc.isra.53.constprop.58+0x280/0x3b0)
[<c05b0abc>] (__slab_alloc.isra.53.constprop.58) from [<c00ec7dc>]
(kmem_cache_alloc+0x118/0x204)
[<c00ec7dc>] (kmem_cache_alloc) from [<c02ba680>]
(radix_tree_node_alloc+0x8c/0x98)
[<c02ba680>] (radix_tree_node_alloc) from [<c02baed4>]
(__radix_tree_create+0x128/0x1c4)
[<c02baed4>] (__radix_tree_create) from [<c02baf9c>]
(radix_tree_insert+0x2c/0xd4)
[<c02baf9c>] (radix_tree_insert) from [<c02db86c>] (add_dma_entry+0x84/0x144)
[<c02db86c>] (add_dma_entry) from [<c03ccd08>]
(usb_hcd_map_urb_for_dma+0x450/0x540)
[<c03ccd08>] (usb_hcd_map_urb_for_dma) from [<c03cd660>]
(usb_hcd_submit_urb+0x6cc/0x7f8)
[<c03cd660>] (usb_hcd_submit_urb) from [<c03c1300>] (rx_submit+0xe4/0x210)
[<c03c1300>] (rx_submit) from [<c03c1630>] (rx_complete+0x19c/0x20c)
[<c03c1630>] (rx_complete) from [<c03cbd48>] (__usb_hcd_giveback_urb+0x6c/0xd0)
[<c03cbd48>] (__usb_hcd_giveback_urb) from [<c03cc88c>]
(usb_giveback_urb_bh+0xa0/0xcc)
[<c03cc88c>] (usb_giveback_urb_bh) from [<c00289e8>] (tasklet_action+0xcc/0x14c)
[<c00289e8>] (tasklet_action) from [<c0028b70>] (__do_softirq+0x108/0x24c)
[<c0028b70>] (__do_softirq) from [<c0028f20>] (irq_exit+0x98/0xe4)
[<c0028f20>] (irq_exit) from [<c000f31c>] (handle_IRQ+0xa0/0xc4)
[<c000f31c>] (handle_IRQ) from [<c0008628>] (gic_handle_irq+0x4c/0x68)
[<c0008628>] (gic_handle_irq) from [<c00129c0>] (__irq_svc+0x40/0x70)
Exception stack(0xc07f9f58 to 0xc07f9fa0)
9f40:                                                       ffffffed 00000000
9f60: ffffffed 00000000 c080048c c05bba78 00000000 00000000 c07f4f10 c08401aa
9f80: c07f8000 00000000 00000001 c07f9fa0 c000f5c4 c000f5c8 60000153 ffffffff
[<c00129c0>] (__irq_svc) from [<c000f5c8>] (arch_cpu_idle+0x28/0x2c)
[<c000f5c8>] (arch_cpu_idle) from [<c005db24>] (cpu_startup_entry+0x138/0x238)
[<c005db24>] (cpu_startup_entry) from [<c07abbd4>] (start_kernel+0x3ac/0x3b8)
Mem-info:
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  94
CPU    1: hi:  186, btch:  31 usd:  30
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:  98
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
active_anon:4564 inactive_anon:267 isolated_anon:0
 active_file:9994 inactive_file:5258 isolated_file:0
 unevictable:0 dirty:0 writeback:0 unstable:0
 free:347626 slab_reclaimable:4068 slab_unreclaimable:5438
 mapped:4418 shmem:913 pagetables:174 bounce:0
 free_cma:32441
Normal free:131792kB min:3444kB low:4304kB high:5164kB
active_anon:4372kB inactive_anon:272kB active_file:33896kB
inactive_file:4512kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:778240kB managed:743296kB mlocked:0kB
dirty:0kB writeback:0kB mapped:5208kB shmem:908kB
slab_reclaimable:16272kB slab_unreclaimable:21752kB kernel_stack:928kB
pagetables:696kB unstable:0kB bounce:0kB free_cma:129764kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 10296 10296
HighMem free:1258712kB min:512kB low:2036kB high:3564kB
active_anon:13884kB inactive_anon:796kB active_file:6080kB
inactive_file:16520kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:1317888kB managed:1317888kB mlocked:0kB
dirty:0kB writeback:20kB mapped:12464kB shmem:2744kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Normal: 68*4kB (UEMC) 15*8kB (UEM) 6*16kB (EM) 2*32kB (RC) 2*64kB (RC)
1*128kB (C) 1*256kB (R) 1*512kB (C) 1*1024kB (R) 1*2048kB (C)
31*4096kB (C) = 131624kB
HighMem: 173*4kB (UM) 52*8kB (UM) 21*16kB (UM) 14*32kB (UM) 11*64kB
(UM) 6*128kB (UM) 6*256kB (U) 3*512kB (UM) 3*1024kB (U) 0*2048kB
305*4096kB (UMR) = 1258788kB
16166 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
524032 pages of RAM
348040 free pages
8736 reserved pages
6850 slab pages
27050 pages shared
0 pages swap cached
SLUB: Unable to allocate memory on node -1 (gfp=0x0)
  cache: radix_tree_node, object size: 304, buffer size: 352, default
order: 1, min order: 0
  node 0: slabs: 820, objs: 18860, free: 0
DMA-API: cacheline tracking ENOMEM, dma-debug disabled
smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
[sched_delayed] sched: RT throttling activated
PM: resume of devices complete after 3978.631 msecs
PM: resume devices took 3.980 seconds
PM: Finishing wakeup.
Restarting tasks ...
usb 1-3: USB disconnect, device number 3
done.
Unhandled fault: imprecise external abort (0xc06) at 0xb6f28000
