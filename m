Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbaJWLik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:38:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbaJWLig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:38:36 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dmaengine@vger.kernel.org
Subject: [RESEND PATCH] ioatdma, fix dma mapping errors
Date: Thu, 23 Oct 2014 07:38:29 -0400
Message-Id: <1414064309-22232-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No response from anyone the first time ...

P.

----8<----

Several systems are showing the following stack trace:

WARNING: CPU: 0 PID: 2352 at lib/dma-debug.c:1140 check_unmap+0x4ee/0x9e0()
ioatdma 0000:00:04.0: DMA-API: device driver failed to check map error[device address=0x0000000465bad000] [size=4096 bytes] [mapped as page]
Modules linked in: ioatdma(E+) nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache cfg80211 rfkill x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel cdc_ether ses ghash_clmulni_intel usbnet mii enclosure aesni_intel lrw gf128mul glue_helper iTCO_wdt shpchp ablk_helper iTCO_vendor_support cryptd pcspkr ipmi_devintf sb_edac lpc_ich edac_core mfd_core ipmi_si i2c_i801 wmi ipmi_msghandler nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sd_mod crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect sysimgblt drm_kms_helper ttm igb drm ptp pps_core dca i2c_algo_bit i2ccore megaraid_sas dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ioatdma]
CPU: 0 PID: 2352 Comm: insmod Tainted: G            E  3.17.0-rc4+ #14
Hardware name: HP ProLiant m300 Server Cartridge/, BIOS H02 01/30/2014
 0000000000000009 ffff88007994b7d8 ffffffff816e7225 ffff88007994b820
 ffff88007994b810 ffffffff8107e51d ffff88045fc56c00 ffff88046643ee90
 ffffffff8338ccd0 0000000000000286 ffffffff81956629 ffff88007994b870
Call Trace:
 [<ffffffff816e7225>] dump_stack+0x4d/0x66
 [<ffffffff8107e51d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8107e58c>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff81381e6e>] check_unmap+0x4ee/0x9e0
 [<ffffffff813823bf>] debug_dma_unmap_page+0x5f/0x70
 [<ffffffffa04546d8>] ioat_xor_val_self_test+0x498/0xcf0 [ioatdma]
 [<ffffffff81204f0a>] ? kfree+0xda/0x2b0
 [<ffffffffa044d510>] ? ioat_dma_setup_interrupts+0x120/0x2d0 [ioatdma]
 [<ffffffffa0454f4e>] ioat3_dma_self_test+0x1e/0x30 [ioatdma]
 [<ffffffffa044f904>] ioat_probe+0xf4/0x110 [ioatdma]
 [<ffffffffa04550f8>] ioat3_dma_probe+0x198/0x3a0 [ioatdma]
 [<ffffffffa044d18e>] ioat_pci_probe+0x11e/0x1b0 [ioatdma]
 [<ffffffff81393a15>] local_pci_probe+0x45/0xa0
 [<ffffffff81394be5>] ? pci_match_device+0xe5/0x110
 [<ffffffff81394d29>] pci_device_probe+0xd9/0x130
 [<ffffffff81462860>] driver_probe_device+0x90/0x3c0
 [<ffffffff81462c63>] __driver_attach+0x93/0xa0
 [<ffffffff81462bd0>] ? __device_attach+0x40/0x40
 [<ffffffff8146080b>] bus_for_each_dev+0x6b/0xb0
 [<ffffffff814622ce>] driver_attach+0x1e/0x20
 [<ffffffff81461ed8>] bus_add_driver+0x188/0x260
 [<ffffffffa0423000>] ? 0xffffffffa0423000
 [<ffffffff81463734>] driver_register+0x64/0xf0
 [<ffffffff813933a0>] __pci_register_driver+0x60/0x70
 [<ffffffffa0423089>] ioat_init_module+0x89/0x1000 [ioatdma]
 [<ffffffff8100212c>] do_one_initcall+0xbc/0x200
 [<ffffffff811e8b22>] ? __vunmap+0xd2/0x120
 [<ffffffff8111e73c>] load_module+0x14ec/0x1b50
 [<ffffffff81119970>] ? store_uevent+0x40/0x40
 [<ffffffff8111ef36>] SyS_finit_module+0x86/0xb0
 [<ffffffff816f1469>] system_call_fastpath+0x16/0x1b
---[ end trace 1052ccbbc3db4d08 ]---
Mapped at:
 [<ffffffff81380be1>] debug_dma_map_page+0x91/0x140
 [<ffffffffa045440e>] ioat_xor_val_self_test+0x1ce/0xcf0 [ioatdma]
 [<ffffffffa0454f4e>] ioat3_dma_self_test+0x1e/0x30 [ioatdma]
 [<ffffffffa044f904>] ioat_probe+0xf4/0x110 [ioatdma]
 [<ffffffffa04550f8>] ioat3_dma_probe+0x198/0x3a0 [ioatdma]

This happens because the current ioatdma DMA test code does not check the return
value of dma_map_page() calls with dma_mapping_error().  In addition, it was
noticed that mapping for the variable dest_dma is free'd before the last use.

This patch fixes these errors by initializing the dma_srcs[] array and checking
the returns with dma_mapping_error().

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: dmaengine@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/dma/ioat/dma_v3.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index b9b38a1..8c51b5c 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1265,9 +1265,17 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 	op = IOAT_OP_XOR;
 
 	dest_dma = dma_map_page(dev, dest, 0, PAGE_SIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, dest_dma))
+		goto dma_unmap;
+
 	for (i = 0; i < IOAT_NUM_SRC_TEST; i++)
+		dma_srcs[i] = DMA_ERROR_CODE;
+	for (i = 0; i < IOAT_NUM_SRC_TEST; i++) {
 		dma_srcs[i] = dma_map_page(dev, xor_srcs[i], 0, PAGE_SIZE,
 					   DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, dma_srcs[i]))
+			goto dma_unmap;
+	}
 	tx = dma->device_prep_dma_xor(dma_chan, dest_dma, dma_srcs,
 				      IOAT_NUM_SRC_TEST, PAGE_SIZE,
 				      DMA_PREP_INTERRUPT);
@@ -1298,7 +1306,6 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 		goto dma_unmap;
 	}
 
-	dma_unmap_page(dev, dest_dma, PAGE_SIZE, DMA_FROM_DEVICE);
 	for (i = 0; i < IOAT_NUM_SRC_TEST; i++)
 		dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE, DMA_TO_DEVICE);
 
@@ -1313,6 +1320,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 	}
 	dma_sync_single_for_device(dev, dest_dma, PAGE_SIZE, DMA_FROM_DEVICE);
 
+	dma_unmap_page(dev, dest_dma, PAGE_SIZE, DMA_FROM_DEVICE);
+
 	/* skip validate if the capability is not present */
 	if (!dma_has_cap(DMA_XOR_VAL, dma_chan->device->cap_mask))
 		goto free_resources;
@@ -1327,8 +1336,13 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 	xor_val_result = 1;
 
 	for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++)
+		dma_srcs[i] = DMA_ERROR_CODE;
+	for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++) {
 		dma_srcs[i] = dma_map_page(dev, xor_val_srcs[i], 0, PAGE_SIZE,
 					   DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, dma_srcs[i]))
+			goto dma_unmap;
+	}
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
 					  &xor_val_result, DMA_PREP_INTERRUPT);
@@ -1374,8 +1388,13 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 
 	xor_val_result = 0;
 	for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++)
+		dma_srcs[i] = DMA_ERROR_CODE;
+	for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++) {
 		dma_srcs[i] = dma_map_page(dev, xor_val_srcs[i], 0, PAGE_SIZE,
 					   DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, dma_srcs[i]))
+			goto dma_unmap;
+	}
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
 					  &xor_val_result, DMA_PREP_INTERRUPT);
@@ -1417,14 +1436,18 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 	goto free_resources;
 dma_unmap:
 	if (op == IOAT_OP_XOR) {
-		dma_unmap_page(dev, dest_dma, PAGE_SIZE, DMA_FROM_DEVICE);
+		if (dest_dma != DMA_ERROR_CODE)
+			dma_unmap_page(dev, dest_dma, PAGE_SIZE,
+				       DMA_FROM_DEVICE);
 		for (i = 0; i < IOAT_NUM_SRC_TEST; i++)
-			dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE,
-				       DMA_TO_DEVICE);
+			if (dma_srcs[i] != DMA_ERROR_CODE)
+				dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE,
+					       DMA_TO_DEVICE);
 	} else if (op == IOAT_OP_XOR_VAL) {
 		for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++)
-			dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE,
-				       DMA_TO_DEVICE);
+			if (dma_srcs[i] != DMA_ERROR_CODE)
+				dma_unmap_page(dev, dma_srcs[i], PAGE_SIZE,
+					       DMA_TO_DEVICE);
 	}
 free_resources:
 	dma->device_free_chan_resources(dma_chan);
-- 
1.7.9.3

