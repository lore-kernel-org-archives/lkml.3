Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3J3XEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:04:42 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39134 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3J3XEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:04:40 -0400
Date: Thu, 31 Oct 2013 07:04:14 +0800
From: Wang YanQing <udknight@gmail.com>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] drm: fix resources leak in error handle code path
Message-ID: <20131030230414.GA4064@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series patches fix resource leak
issue in error handle code path I meet
with drm, vmalloc leak, etc.

I meet below issue caused by drm haven't release 
resource(include 40K vmalloc per module insert failed) 
in error code path and buggy nvidia driver try to insert 
nvidia module cycled when it failed to probe device which
had been controlled by nouveau built-in kernel, then
drm leak all the vmalloc space finally:

[ 2075.508077] vmap allocation for size 9637888 failed: use vmalloc=<size> to increase size.
[ 2075.508083] vmalloc: allocation failure: 9633737 bytes
[ 2075.508085] modprobe: page allocation failure: order:0, mode:0xd2
[ 2075.508089] CPU: 0 PID: 11113 Comm: modprobe Tainted: P           O 3.10.16+ #13
[ 2075.508091] Hardware name: Acer            Aspire 4741                    /Aspire 4741                    , BIOS V1.04           03/02/2010
[ 2075.508093]  c17295c4 f5283eac c15df443 f5283edc c10b3311 c1727ec4 f2c15ac0 00000000
[ 2075.508097]  000000d2 c17295c4 f5283ecc f5283ef0 000000d2 0092ffc9 ffffffff f5283f0c
[ 2075.508101]  c10d86e7 000000d2 00000000 c17295c4 0092ffc9 c1077408 f56979c0 f5283f28
[ 2075.508106] Call Trace:
[ 2075.508113]  [<c15df443>] dump_stack+0x16/0x1b
[ 2075.508118]  [<c10b3311>] warn_alloc_failed+0xa1/0x100
[ 2075.508123]  [<c10d86e7>] __vmalloc_node_range+0x177/0x1e0
[ 2075.508128]  [<c1077408>] ? SyS_init_module+0x78/0xc0
[ 2075.508131]  [<c10d87b0>] __vmalloc_node+0x60/0x70
[ 2075.508134]  [<c1077408>] ? SyS_init_module+0x78/0xc0
[ 2075.508137]  [<c10d88c8>] vmalloc+0x38/0x40
[ 2075.508140]  [<c1077408>] ? SyS_init_module+0x78/0xc0
[ 2075.508142]  [<c1077408>] SyS_init_module+0x78/0xc0
[ 2075.508147]  [<c15e291e>] sysenter_do_call+0x12/0x26
[ 2075.508149] Mem-Info:
[ 2075.508151] DMA per-cpu:
[ 2075.508153] CPU    0: hi:    0, btch:   1 usd:   0
[ 2075.508154] CPU    1: hi:    0, btch:   1 usd:   0
[ 2075.508156] CPU    2: hi:    0, btch:   1 usd:   0
[ 2075.508157] CPU    3: hi:    0, btch:   1 usd:   0
[ 2075.508158] Normal per-cpu:
[ 2075.508160] CPU    0: hi:  186, btch:  31 usd: 125
[ 2075.508162] CPU    1: hi:  186, btch:  31 usd: 138
[ 2075.508163] CPU    2: hi:  186, btch:  31 usd: 155
[ 2075.508165] CPU    3: hi:  186, btch:  31 usd: 144
[ 2075.508166] HighMem per-cpu:
[ 2075.508167] CPU    0: hi:  186, btch:  31 usd: 132
[ 2075.508169] CPU    1: hi:  186, btch:  31 usd: 170
[ 2075.508171] CPU    2: hi:  186, btch:  31 usd: 155
[ 2075.508172] CPU    3: hi:  186, btch:  31 usd: 153
[ 2075.508177] active_anon:2889 inactive_anon:27 isolated_anon:0
[ 2075.508177]  active_file:66897 inactive_file:117009 isolated_file:0
[ 2075.508177]  unevictable:0 dirty:47 writeback:0 unstable:0
[ 2075.508177]  free:292466 slab_reclaimable:4051 slab_unreclaimable:2244
[ 2075.508177]  mapped:2241 shmem:206 pagetables:189 bounce:0
[ 2075.508177]  free_cma:0
[ 2075.508185] DMA free:15896kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15980kB managed:15904kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[ 2075.508186] lowmem_reserve[]: 0 842 1923 1923
[ 2075.508193] Normal free:803896kB min:3680kB low:4600kB high:5520kB active_anon:0kB inactive_anon:0kB active_file:14052kB inactive_file:18684kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:897016kB managed:863160kB mlocked:0kB dirty:72kB writeback:0kB mapped:4kB shmem:0kB slab_reclaimable:16204kB slab_unreclaimable:8968kB kernel_stack:1272kB pagetables:756kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[ 2075.508195] lowmem_reserve[]: 0 0 8647 8647
[ 2075.508202] HighMem free:350072kB min:512kB low:1688kB high:2868kB active_anon:11556kB inactive_anon:108kB active_file:253536kB inactive_file:449352kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1106844kB managed:1106844kB mlocked:0kB dirty:116kB writeback:0kB mapped:8960kB shmem:824kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[ 2075.508203] lowmem_reserve[]: 0 0 0 0
[ 2075.508206] DMA: 0*4kB 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15896kB
[ 2075.508216] Normal: 50*4kB (UM) 180*8kB (UM) 159*16kB (UEM) 65*32kB (UEM) 29*64kB (UEM) 1*128kB (M) 0*256kB 0*512kB 1*1024kB (M) 2*2048kB (UR) 193*4096kB (MR) = 803896kB
[ 2075.508228] HighMem: 1270*4kB (U) 942*8kB (UM) 467*16kB (UM) 1012*32kB (UM) 632*64kB (UM) 199*128kB (UM) 61*256kB (UM) 24*512kB (M) 5*1024kB (M) 3*2048kB (UM) 47*4096kB (MR) = 350072kB
[ 2075.508240] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 2075.508242] 184112 total pagecache pages
[ 2075.508243] 0 pages in swap cache
[ 2075.508245] Swap cache stats: add 0, delete 0, find 0/0
[ 2075.508246] Free swap  = 4551676kB
[ 2075.508247] Total swap = 4551676kB
[ 2075.512956] 505855 pages RAM
[ 2075.512959] 277506 pages HighMem
[ 2075.512961] 7415 pages reserved
[ 2075.512962] 1086176 pages shared
[ 2075.512964] 172994 pages non-shared

The reason is resource allocated in drm_fill_in_dev
haven't be freed when dev->driver->load return error,
we current relay on drm_put_dev to free resource
allocated in drm_fill_in_dev called in module_exit,
but in error code path in drm_get_[pci|platform|usb]_dev,
below line 

"list_add_tail(&dev->driver_item, &driver->device_list);"

will be skipped, and drm_[pci|platform|usb]_exit willn't
free resource.

This series patch fix it and it also ajust and improve 
error handle code path for drm_fill_in_dev, drm_get_[pci|platform|usb]_dev.

It include 5 patches:

1:drm:drm_stub: add new function drm_cleanup_in_dev
2:drm:drm_pci: fix resource leak in drm_get_pci_dev
3:drm:drm_platform: fix resource leak in drm_get_platform_dev
4:drm:drm_usb: fix resource leak in drm_get_usb_dev
5:drm:drm_stub: rewrite error handle code for drm_fill_in_dev

Thanks.


