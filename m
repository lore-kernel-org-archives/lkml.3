Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3CFCS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 21:18:26 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:56382 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3CFCSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 21:18:17 -0500
From: Andrew Cooks <acooks@gmail.com>
To: acooks@gmail.com
Cc: Dan Williams <djbw@fb.com> (maintainer:ASYNCHRONOUS TRAN... 
	,commit_signer:2/10=20%),
        Vinod Koul <vinod.koul@intel.com> (supporter:DMA GENERIC OFFLO... 
	,commit_signer:6/10=60%),
        Russell King <rmk+kernel@arm.linux.org.uk> (commit_signer:6/10=60%),
        Linus Walleij <linus.walleij@linaro.org> (commit_signer:6/10=60%),
        Jassi Brar <jassisinghbrar@gmail.com> (commit_signer:6/10=60%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH][v2] check for dma mapping error in ioat_dma_self_test
Date: Wed,  6 Mar 2013 10:17:22 +0800
Message-Id: <1362536245-4708-1-git-send-email-acooks@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <CAJtEV7bGjdJdCsKZ05+FbzoNDeMd2YUh=B=qc=ev_Z2ESg7vPQ@mail.gmail.com>
References: <CAJtEV7bGjdJdCsKZ05+FbzoNDeMd2YUh=B=qc=ev_Z2ESg7vPQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a warning in ioat_dma_self_test when DMA_API_DEBUG is enabled. The warning is:

[    1.581984] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.582095] bus: 'pci': add driver ioatdma
[    1.582102] bus: 'pci': driver_probe_device: matched device 0000:00:04.0 with driver ioatdma
[    1.582104] bus: 'pci': really_probe: probing driver ioatdma with device 0000:00:04.0
[    1.582175] ioatdma 0000:00:04.0: can't derive routing for PCI INT A
[    1.582281] ioatdma 0000:00:04.0: PCI INT A: no GSI
[    1.582552] ioatdma 0000:00:04.0: irq 52 for MSI/MSI-X
[    1.582631] Set context mapping for 00:04.0
[    1.582920] ------------[ cut here ]------------
[    1.583027] WARNING: at lib/dma-debug.c:933 check_unmap+0x645/0x6f1()
[    1.583132] Hardware name: To be filled by O.E.M.
[    1.583236] ioatdma 0000:00:04.0: DMA-API: device driver failed to check map error[device address=0x00000000ffff9800] [size=2000 bytes] [mapped as single]Modules linked in:
[    1.583240] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc1-dirty #248
[    1.583241] Call Trace:
[    1.583244]  [<ffffffff8103d98e>] warn_slowpath_common+0x85/0x9f
[    1.583246]  [<ffffffff8103da4b>] warn_slowpath_fmt+0x46/0x48
[    1.583248]  [<ffffffff81257a7b>] check_unmap+0x645/0x6f1
[    1.583251]  [<ffffffff81505e10>] ? _raw_spin_unlock_irqrestore+0x3f/0x55
[    1.583253]  [<ffffffff81257d07>] debug_dma_unmap_page+0x59/0x5b
[    1.583256]  [<ffffffff812ea925>] dma_unmap_single_attrs.clone.2+0x6a/0x73
[    1.583258]  [<ffffffff812eb3b7>] ioat_dma_self_test+0x228/0x29d
[    1.583260]  [<ffffffff8150449a>] ? __wait_for_common+0xe7/0x15a
[    1.583263]  [<ffffffff812ef74d>] ioat3_dma_self_test+0x16/0x29
[    1.583264]  [<ffffffff812e9be9>] ioat_probe+0xbc/0xea
[    1.583266]  [<ffffffff812ed1fb>] ioat3_dma_probe+0x1d3/0x275
[    1.583268]  [<ffffffff812e9135>] ioat_pci_probe+0x14d/0x178
[    1.583271]  [<ffffffff812650a7>] local_pci_probe+0x3e/0x66
[    1.583273]  [<ffffffff81265179>] __pci_device_probe+0xaa/0xc3
[    1.583275]  [<ffffffff8131fce7>] ? get_device+0x19/0x1f
[    1.583277]  [<ffffffff81265c06>] pci_device_probe+0x35/0x50
[    1.583280]  [<ffffffff81323960>] really_probe+0xda/0x29c
[    1.583282]  [<ffffffff8132e2dd>] ? pm_runtime_barrier+0x70/0x99
[    1.583284]  [<ffffffff81323b96>] driver_probe_device+0x74/0x8d
[    1.583286]  [<ffffffff81323c10>] __driver_attach+0x61/0x85
[    1.583288]  [<ffffffff81323baf>] ? driver_probe_device+0x8d/0x8d
[    1.583289]  [<ffffffff81323baf>] ? driver_probe_device+0x8d/0x8d
[    1.583291]  [<ffffffff81321f3a>] bus_for_each_dev+0x58/0x96
[    1.583293]  [<ffffffff813236d5>] driver_attach+0x1e/0x20
[    1.583295]  [<ffffffff813230ba>] bus_add_driver+0xed/0x223
[    1.583298]  [<ffffffff81ce06b9>] ? dma_bus_init+0x19/0x19
[    1.583300]  [<ffffffff813241f0>] driver_register+0x8f/0x108
[    1.583301]  [<ffffffff81ce06b9>] ? dma_bus_init+0x19/0x19
[    1.583303]  [<ffffffff81265d10>] __pci_register_driver+0x64/0x68
[    1.583305]  [<ffffffff81ce0721>] ioat_init_module+0x68/0x80
[    1.583307]  [<ffffffff81cdf92e>] ? setup_erst_disable+0x12/0x12
[    1.583310]  [<ffffffff81000237>] do_one_initcall+0x7f/0x133
[    1.583312]  [<ffffffff81cb27a6>] do_basic_setup+0x9c/0xba
[    1.583314]  [<ffffffff81cb28f0>] ? kernel_init_freeable+0x12c/0x12c
[    1.583316]  [<ffffffff81cb2877>] kernel_init_freeable+0xb3/0x12c
[    1.583318]  [<ffffffff814f7324>] ? rest_init+0xd8/0xd8
[    1.583320]  [<ffffffff814f7332>] kernel_init+0xe/0xdb
[    1.583322]  [<ffffffff8150d4dc>] ret_from_fork+0x7c/0xb0
[    1.583324]  [<ffffffff814f7324>] ? rest_init+0xd8/0xd8
[    1.583340] ---[ end trace a5a9423f147d46b4 ]---
[    1.583443] Mapped at:
[    1.583545]  [<ffffffff81258192>] debug_dma_map_page+0x4c/0xec
[    1.583547]  [<ffffffff812ea8a8>] dma_map_single_attrs.clone.1+0xe3/0xf6
[    1.583549]  [<ffffffff812eb260>] ioat_dma_self_test+0xd1/0x29d
[    1.583550]  [<ffffffff812ef74d>] ioat3_dma_self_test+0x16/0x29
[    1.583552]  [<ffffffff812e9be9>] ioat_probe+0xbc/0xea

Applies to 3.9-rc1


Signed-off-by: Andrew Cooks <acooks@gmail.com>
---
 drivers/dma/ioat/dma.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 1879a59..5431ba8 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -832,7 +832,18 @@ int ioat_dma_self_test(struct ioatdma_device *device)
 	}
 
 	dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, dma_src)) {
+		dev_err(dev, "dma mapping failed.\n");
+		goto free_resources;
+	}
+
 	dma_dest = dma_map_single(dev, dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, dma_dest)) {
+		dev_err(dev, "dma mapping failed.\n");
+		dma_unmap_single(dev, dma_src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
+		goto free_resources;
+	}
+
 	flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
 		DMA_PREP_INTERRUPT;
 	tx = device->common.device_prep_dma_memcpy(dma_chan, dma_dest, dma_src,
-- 
1.7.1

