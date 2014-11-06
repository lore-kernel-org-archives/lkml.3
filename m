Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaKFLlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:41:46 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50700 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751046AbaKFLlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:41:17 -0500
Message-ID: <545B5E03.3040809@arm.com>
Date: Thu, 06 Nov 2014 11:39:47 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: dan.j.williams@intel.com, vinod.koul@intel.com, dmaengine@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] dmaengine: pl330: Correct device assignment.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f6f2421c0a1c removed pl330_info structure by embedding it into
pl330_dmac structure, but did not ensure that the dmac->ddma.dev
pointer gets initialised before use. When dma_alloc_coherent() gets
called on arm64 a WARN() gets triggered due to dev being NULL.

------------[ cut here ]------------
WARNING: CPU: 1 PID: 1 at arch/arm64/mm/dma-mapping.c:49 __dma_alloc_coherent+0xd0/0xe0()
Use an actual device structure for DMA allocation
Modules linked in:
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.17.0+ #5
Call trace:
[<ffffffc000087f24>] dump_backtrace+0x0/0x130
[<ffffffc000088064>] show_stack+0x10/0x1c
[<ffffffc0004e8af8>] dump_stack+0x74/0xb8
[<ffffffc0000aa444>] warn_slowpath_common+0x8c/0xb4
[<ffffffc0000aa4b8>] warn_slowpath_fmt+0x4c/0x58
[<ffffffc000092580>] __dma_alloc_coherent+0xcc/0xe0
[<ffffffc000092734>] __dma_alloc_noncoherent+0x64/0x158
[<ffffffc000312cd8>] pl330_probe+0x650/0x8f0
[<ffffffc00030e1d4>] amba_probe+0xa0/0xc8
[<ffffffc000350240>] really_probe+0xc4/0x22c
[<ffffffc0003504b4>] __driver_attach+0xa0/0xa8
[<ffffffc00034e5fc>] bus_for_each_dev+0x54/0x98
[<ffffffc00034fd8c>] driver_attach+0x1c/0x28
[<ffffffc00034fa08>] bus_add_driver+0x14c/0x204
[<ffffffc000350b84>] driver_register+0x64/0x130
[<ffffffc00030dcf8>] amba_driver_register+0x50/0x5c
[<ffffffc0006a60d0>] pl330_driver_init+0x10/0x1c
[<ffffffc0000814ac>] do_one_initcall+0x88/0x19c
[<ffffffc00068dab8>] kernel_init_freeable+0x140/0x1e0
[<ffffffc0004e5e18>] kernel_init+0x10/0xd4
---[ end trace 76f2d47a444e523e ]---
(NULL device *): dmac_alloc_resources:1821 Can't allocate memory!
(NULL device *): Unable to create channels for DMAC

This patch will also ensure that any dev_err messages are printed 
with the appropriate device name.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 drivers/dma/pl330.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 4a5a2a8..ace7d42 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2629,6 +2629,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 		return -ENOMEM;
 	}
 
+	pd = &pl330->ddma;
+	pd->dev = &adev->dev;
+
 	pl330->mcbufsz = pdat ? pdat->mcbuf_sz : 0;
 
 	res = &adev->res;
@@ -2665,7 +2668,6 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	if (!add_desc(pl330, GFP_KERNEL, NR_DEFAULT_DESC))
 		dev_warn(&adev->dev, "unable to allocate desc\n");
 
-	pd = &pl330->ddma;
 	INIT_LIST_HEAD(&pd->channels);
 
 	/* Initialize channel parameters */
@@ -2702,7 +2704,6 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 		list_add_tail(&pch->chan.device_node, &pd->channels);
 	}
 
-	pd->dev = &adev->dev;
 	if (pdat) {
 		pd->cap_mask = pdat->cap_mask;
 	} else {
-- 
1.7.1

