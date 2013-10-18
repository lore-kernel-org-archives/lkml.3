Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab3JRRf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:35:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61600 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab3JRRf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:35:58 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-d0-5261717ce2ae
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, dave.jiang@intel.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 00/13] dmaengine: introduce dmaengine_unmap_data
Date: Fri, 18 Oct 2013 19:35:20 +0200
Message-id: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsVy+t9jAd2awsQggzlXjC02zljPajF96gVG
	ixM3G9kszja9Ybe4vGsOm8Xty7wW62e8ZrF42befxYHDo6W5h81j8Z6XTB59W1YxenzeJBfA
	EsVlk5Kak1mWWqRvl8CVsWbJQcaC6yoVhyduZWlgvCvVxcjJISFgInHkx0s2CFtM4sK99UA2
	F4eQwCJGie+ti9khnC4miRMXPjCDVLEJWElMbF/FCGKLCMhIbPi/nRmkiFlgI6PE1K8Qo4QF
	nCUmH94B1sAioCrRcOcsK4jNK+Ah0TblHwvEOnmJp/f72CYwci9gZFjFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERwmz6R3MK5qsDjEKMDBqMTD22GTGCTEmlhWXJl7iFGCg1lJhLfMGSjE
	m5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qB0WuSuoRx5xdJ
	7hm2W5hfLuyoK5wzuy7Pe77TlG3Ctxw7Mvad2duhdWjh4Sk7d0wPevZmwbK6i2ceGG6xXNL/
	onDhhvZAZ54rOsnqHxZdkZh1Ivihg66+3KyO5VzePFkHcmwyln75bzdVwHR6x6yi27bmd1iu
	zGOfnhVfZsC94N6hPds6HG8yZyuxFGckGmoxFxUnAgBblIOIDwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Original patch series description by Dan. ]

dmaengine from the beginning has placed the burden of unmapping dma
buffers on the individual drivers.  The thought being that since the dma
driver already has the descriptor it can use that information for
unmapping.  This results in a lot of cruft to read back data from
descriptors, places a burden on channels that need to break up an
operation internally into multiple descriptors, and makes it difficult
to have dma mappings with different lifetimes than the current
operation.

For example an xor->copy->xor chain wants to leave all buffers
mapped until completion, async_tx currently performs invalid overlapping
mappings.  With dmaengine_unmap_data map once and take a reference for
descriptor that uses the mapping.

Reference to v1:
	https://lkml.org/lkml/2012/12/6/71

Changes since v1:
- synced patch series with next-20131016
- removed no longer needed "async_memset: convert to dmaengine_unmap_data"
  patch (patch #5 in v1)
- added patch #1 ("dmatest: make driver unmap also source buffers by itself")
- added patch #11 ("NTB: convert to dmaengine_unmap_data")
- prepared pl330 driver for adding missing unmap in patch #3
- in patch #4:
  - fixed IS_ENABLED() check
  - fixed release ordering in dmaengine_destroy_unmap_pool()
  - fixed check for success in dmaengine_init_unmap_pool()
  - replaced kmem_cache_free() by mempool_free()
  - added missing unmap->len initializations
  - added __init tag to dmaengine_init_unmap_pool()
- in patch #5:
  - added missing unmap->len initialization
  - fixed whitespace damage
- did minor cleanups in patches #6 & #7
- added temporary dma_dest array in patches #8 & #9

Tested on Exynos4412-based Trats2 board containing PL330 DMA engine, with
additional patches doing memory copying tests using DMA memcpy API.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (4):
  dmatest: make driver unmap also source buffers by itself
  NTB: convert to dmaengine_unmap_data
  dmaengine: remove DMA unmap from drivers
  dmaengine: remove DMA unmap flags

Dan Williams (9):
  dmaengine: consolidate memcpy apis
  dmaengine: prepare for generic 'unmap' data
  dmaengine: reference counted unmap data
  async_memcpy: convert to dmaengine_unmap_data
  async_xor: convert to dmaengine_unmap_data
  async_xor_val: convert to dmaengine_unmap_data
  async_raid6_recov: convert to dmaengine_unmap_data
  async_pq: convert to dmaengine_unmap_data
  async_pq_val: convert to dmaengine_unmap_data

 arch/arm/include/asm/hardware/iop3xx-adma.h |  30 ----
 arch/arm/include/asm/hardware/iop_adma.h    |   4 -
 arch/arm/mach-iop13xx/include/mach/adma.h   |  26 ---
 crypto/async_tx/async_memcpy.c              |  37 ++--
 crypto/async_tx/async_pq.c                  | 174 ++++++++++--------
 crypto/async_tx/async_raid6_recov.c         |  61 +++++--
 crypto/async_tx/async_xor.c                 | 123 +++++++------
 drivers/ata/pata_arasan_cf.c                |   3 +-
 drivers/dma/amba-pl08x.c                    |  32 +---
 drivers/dma/at_hdmac.c                      |  26 +--
 drivers/dma/dmaengine.c                     | 262 ++++++++++++++++++---------
 drivers/dma/dmatest.c                       |   9 +-
 drivers/dma/dw/core.c                       |  21 +--
 drivers/dma/ep93xx_dma.c                    |  30 +---
 drivers/dma/fsldma.c                        |  17 +-
 drivers/dma/ioat/dma.c                      |  20 +--
 drivers/dma/ioat/dma.h                      |  12 --
 drivers/dma/ioat/dma_v2.c                   |   2 +-
 drivers/dma/ioat/dma_v3.c                   | 179 +-----------------
 drivers/dma/iop-adma.c                      |  97 +---------
 drivers/dma/mv_xor.c                        |  45 +----
 drivers/dma/pl330.c                         |   2 +
 drivers/dma/ppc4xx/adma.c                   | 270 +---------------------------
 drivers/dma/timb_dma.c                      |  37 +---
 drivers/dma/txx9dmac.c                      |  25 +--
 drivers/media/platform/m2m-deinterlace.c    |   3 +-
 drivers/media/platform/timblogiw.c          |   2 +-
 drivers/misc/carma/carma-fpga.c             |   3 +-
 drivers/mtd/nand/atmel_nand.c               |   3 +-
 drivers/mtd/nand/fsmc_nand.c                |   2 -
 drivers/net/ethernet/micrel/ks8842.c        |   6 +-
 drivers/ntb/ntb_transport.c                 |  64 +++++--
 drivers/spi/spi-dw-mid.c                    |   4 +-
 include/linux/dmaengine.h                   |  64 +++++--
 34 files changed, 538 insertions(+), 1157 deletions(-)

-- 
1.8.2.3

